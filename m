Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58AF32DEB2
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 01:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCEA5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 19:57:30 -0500
Received: from p3plsmtpa12-03.prod.phx3.secureserver.net ([68.178.252.232]:45966
        "EHLO p3plsmtpa12-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229451AbhCEA53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 19:57:29 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2021 19:57:29 EST
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id HyfNlebmbKlXKHyfPlxTQW; Thu, 04 Mar 2021 17:50:08 -0700
X-CMAE-Analysis: v=2.4 cv=UJAYoATy c=1 sm=1 tr=0 ts=60418040
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=0GwoGiBFgAMBLWIAvXgA:9 a=1rRqZVMH8gknjsDx:21
 a=NUkpBooKR02OtL0q:21 a=CjuIK1q_8ugA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Moshe Shemesh'" <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Adrian Pop'" <pop.adrian61@gmail.com>,
        "'Michal Kubecek'" <mkubecek@suse.cz>, <netdev@vger.kernel.org>
Cc:     "'Vladyslav Tarasiuk'" <vladyslavt@nvidia.com>,
        <don@thebollingers.org>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
In-Reply-To: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
Subject: RE: [RFC PATCH V2 net-next 0/5] ethtool: Extend module EEPROM dump API
Date:   Thu, 4 Mar 2021 16:50:04 -0800
Message-ID: <001001d71159$7c868070$75938150$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFnKUugUW+R+aqYgGARCVs1/gX+X6tUQlrw
Content-Language: en-us
X-CMAE-Envelope: MS4xfOwPI3n9eIDpw0phvt3dtReEr9LS2eFbUWi+frXxH2ID1hHI48up8vX9kr+ts4InwWpNwyKJpWERkWiWIiLXf0V4FxnkGoj8POSw7fo1IjscJkqLMUXH
 j0TC14qujIyMGjZpS6U6jCpdty7fG4UXxBa0yF68rus3OkIrAmt20TEXu/HOBXsZG6B/dQoklB11uuCfwRXYdH+83z94Ze9CnmTFVbeq3GotyxeWoLiD//Wb
 yf46vqEQ2MVzV5lBpbwH3ncTM9fWCsJJLYZCUD/ySeUR/PcJ4Zv6zbZo1FG4nEZB1cL71wWHDbOmagQPmj1YLIPnwvNHe2OPXlALjc1pCPSuXH1ujorShR//
 WCURRbNHt45USnADyD3Z+WrU6ozkOvl2pDsrc33XOMj62DLD9mToWZuvuoOpoDAq3ugCTk1h
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 04, 2021 at 10:57AM-0800, Moshe Shemesh wrote:
> Ethtool supports module EEPROM dumps via the `ethtool -m <dev>`
> command.
> But in current state its functionality is limited - offset and length
parameters,
> which are used to specify a linear desired region of EEPROM data to dump,
is
> not enough, considering emergence of complex module EEPROM layouts
> such as CMIS 4.0.
> Moreover, CMIS 4.0 extends the amount of pages that may be accessible by
> introducing another parameter for page addressing - banks.

This is nice work, addressing the banks problem (though there are no devices
with bank switching yet?)

I suggest this change increase the maximum size of EEPROM to the maximum
the architecture allows.  That's 256 pages (128 bytes) plus the lower page
for
a total of 257*256 bytes.  SFP devices can access another 256 bytes since
they
use two i2c addresses but only one of them is paged.  The size increase is
necessary for bank support since banked pages are all above the current
640 byte limit.  Note that the SFF-* specs do not specify what is in pages
above page 3 (except CMIS), but they DO specify that those pages are
available for proprietary uses by module vendors.  I will call out these
changes
in the following patches.

Ethtool also supports module 'change-eeprom', a write function mirroring the
dump function.  That path needs to be implemented too.  There are some 
very interesting proprietary tricks that some modules can do by writing
the right magic to the right registers, some of which are on pages in the
0xF0 range.

> 
> Besides, currently module EEPROM is represented as a chunk of
> concatenated pages, where lower 128 bytes of all pages, except page 00h,
> are omitted. Offset and length are used to address parts of this fake
linear
> memory. But in practice drivers, which implement
> get_module_info() and get_module_eeprom() ethtool ops still calculate
> page number and set I2C address on their own.
> 
> This series tackles these issues by adding ethtool op, which allows to
pass
> page number, bank number and I2C address in addition to offset and length
> parameters to the driver, adds corresponding netlink infrastructure and
> implements the new interface in mlx5 driver.
> 
> This allows to extend userspace 'ethtool -m' CLI by adding new parameters
-
> page, bank and i2c. New command line format:
>  ethtool -m <dev> [hex on|off] [raw on|off] [offset N] [length N] [page N]
> [bank N] [i2c N]
> 
> The consequence of this series is a possibility to dump arbitrary EEPROM
> page at a time, in contrast to dumps of concatenated pages. Therefore,
> offset and length change their semantics and may be used only to specify a
> part of data within a page, which size is currently limited to 256 bytes.

Just to be clear, if you define a page to be 256 bytes, and only specify
offset
within a page, then offset 0-127 is the same for every page on the device,
and useful offsets for each page start at 128.  This can be confusing, but I
think it is the right approach.

> 
> As for backwards compatibility with get_module_info() and
> get_module_eeprom() pair, the series addresses it as well by implementing
> a fallback mechanism. As mentioned earlier, drivers derive a page number
> from 'global' offset, so this can be done vice versa without their
involvement
> thanks to standardization. If kernel netlink handler of 'ethtool -m'
command
> detects that new ethtool op is not supported by the driver, it calculates
> offset from given page number and page offset and calls old ndos, if they
are
> available.
> 
> Change log:
> v1 -> v2:
> - Limited i2c_address values by 127
> - Added page bound check for offset and length
> - Added defines for these two points
> - Added extack to ndo parameters
> - Moved ethnl_ops_begin(dev) and set error path accordingly
> 
> 
> 
> Vladyslav Tarasiuk (5):
>   ethtool: Allow network drivers to dump arbitrary EEPROM data
>   net/mlx5: Refactor module EEPROM query
>   net/mlx5: Implement get_module_eeprom_data_by_page()
>   net/mlx5: Add support for DSFP module EEPROM dumps
>   ethtool: Add fallback to get_module_eeprom from netlink command
> 
>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  42 +++
>  .../net/ethernet/mellanox/mlx5/core/port.c    | 101 ++++++--
>  include/linux/ethtool.h                       |   7 +-
>  include/linux/mlx5/port.h                     |  12 +
>  include/uapi/linux/ethtool.h                  |  26 ++
>  include/uapi/linux/ethtool_netlink.h          |  19 ++
>  net/ethtool/Makefile                          |   2 +-
>  net/ethtool/eeprom.c                          | 239 ++++++++++++++++++
>  net/ethtool/netlink.c                         |  10 +
>  net/ethtool/netlink.h                         |   2 +
>  10 files changed, 430 insertions(+), 30 deletions(-)  create mode 100644
> net/ethtool/eeprom.c
> 
> --
> 2.18.2

Don Bollinger

