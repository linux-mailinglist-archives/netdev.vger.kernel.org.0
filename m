Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98EB32D9D0
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 19:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbhCDS61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 13:58:27 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4873 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbhCDS6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 13:58:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60412d960000>; Thu, 04 Mar 2021 10:57:26 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 18:57:25 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 4 Mar 2021 18:57:23 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V2 net-next 0/5] ethtool: Extend module EEPROM dump API
Date:   Thu, 4 Mar 2021 20:57:03 +0200
Message-ID: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614884246; bh=6BnLMNKK3HVaMYgQsSIQ1K36uV74iNG318mFPhZ9F+8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type;
        b=l1NyVFAcQtW8nIdcrnpszm7n9cYsMruPDPU6iBX3IsiSv57bBhnAahNUc+jFujnS6
         o26Njom6fP4FZYDaDCElthu4DHiEGjMh0YX+TBT7LO0TZM7riI3YCArF1JdUV/wgIe
         2+c2f6sl61L4ukUrQ2VC0SqX/U49agJcPQbTwelkCYCbIMzbMtKTDz3Jb3nK9vSSm1
         XiJbpZ0gKnVTZZr+0O9KIZRmrqxxY3fmNm1+PTbPmFkd4IWbxYqmMC1hDID/K2j8E8
         y3EN0GzCzwFw1UHlCtoQLq9qCSSVt4+2hEs+Fj6RO31GlGR5iBESz+ly05erbhULHz
         rxz90/imPVMAw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethtool supports module EEPROM dumps via the `ethtool -m <dev>` command.
But in current state its functionality is limited - offset and length
parameters, which are used to specify a linear desired region of EEPROM
data to dump, is not enough, considering emergence of complex module
EEPROM layouts such as CMIS 4.0.
Moreover, CMIS 4.0 extends the amount of pages that may be accessible by
introducing another parameter for page addressing - banks.

Besides, currently module EEPROM is represented as a chunk of
concatenated pages, where lower 128 bytes of all pages, except page 00h,
are omitted. Offset and length are used to address parts of this fake
linear memory. But in practice drivers, which implement
get_module_info() and get_module_eeprom() ethtool ops still calculate
page number and set I2C address on their own.

This series tackles these issues by adding ethtool op, which allows to
pass page number, bank number and I2C address in addition to offset and
length parameters to the driver, adds corresponding netlink
infrastructure and implements the new interface in mlx5 driver.

This allows to extend userspace 'ethtool -m' CLI by adding new
parameters - page, bank and i2c. New command line format:
 ethtool -m <dev> [hex on|off] [raw on|off] [offset N] [length N] [page N] [bank N] [i2c N]

The consequence of this series is a possibility to dump arbitrary EEPROM
page at a time, in contrast to dumps of concatenated pages. Therefore,
offset and length change their semantics and may be used only to specify
a part of data within a page, which size is currently limited to 256
bytes.

As for backwards compatibility with get_module_info() and
get_module_eeprom() pair, the series addresses it as well by
implementing a fallback mechanism. As mentioned earlier, drivers derive
a page number from 'global' offset, so this can be done vice versa
without their involvement thanks to standardization. If kernel netlink
handler of 'ethtool -m' command detects that new ethtool op is not
supported by the driver, it calculates offset from given page number and
page offset and calls old ndos, if they are available.

Change log:
v1 -> v2:
- Limited i2c_address values by 127
- Added page bound check for offset and length
- Added defines for these two points
- Added extack to ndo parameters
- Moved ethnl_ops_begin(dev) and set error path accordingly



Vladyslav Tarasiuk (5):
  ethtool: Allow network drivers to dump arbitrary EEPROM data
  net/mlx5: Refactor module EEPROM query
  net/mlx5: Implement get_module_eeprom_data_by_page()
  net/mlx5: Add support for DSFP module EEPROM dumps
  ethtool: Add fallback to get_module_eeprom from netlink command

 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  42 +++
 .../net/ethernet/mellanox/mlx5/core/port.c    | 101 ++++++--
 include/linux/ethtool.h                       |   7 +-
 include/linux/mlx5/port.h                     |  12 +
 include/uapi/linux/ethtool.h                  |  26 ++
 include/uapi/linux/ethtool_netlink.h          |  19 ++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/eeprom.c                          | 239 ++++++++++++++++++
 net/ethtool/netlink.c                         |  10 +
 net/ethtool/netlink.h                         |   2 +
 10 files changed, 430 insertions(+), 30 deletions(-)
 create mode 100644 net/ethtool/eeprom.c

-- 
2.18.2

