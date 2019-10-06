Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B906CCEFD
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfJFGfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:35:19 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59687 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbfJFGfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:35:19 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ED482202D1;
        Sun,  6 Oct 2019 02:35:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Oct 2019 02:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tIfmR/SqpsleNdpFp
        jI6VWqNuHADnpJGMXzSje3QDHc=; b=Oa71BkRS/DySwxLFOzSoi2d7J/08dZ0qe
        hIi68TxXDvsvZIKou7U5pco/FSVQ7LeqpAaKqylUmGtJgRruBDxc0YAzXrznKxy4
        +YoHp1apLRzDUKrJyrZieD7gqpzdRLVsbNB33mh6SSbIQBii9YwquHiDnCaui+eq
        0HitAomkOCs5xoxQjb9RqY01/zgX/3q23uFWEb2zY6q32pSqT/J41ZeH15YyDj4P
        AhRO1ksc+0XV0ZqBVKAzmTkTJHQeFqtB6cXbPYY72BXqglEwzgfFQLVp8cqaBfFi
        ADoEUqvWOjljbI/gJlsx8/E/1V3hEVT2pCwpvyMCWXNGa6h2ySsCw==
X-ME-Sender: <xms:JYuZXe-LI5_q-G-3qdfAa9go-rvdxXg-AYlapjjLr4L7yYdRnvuCMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheeggdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:JYuZXS9EVJWdDQZWTJd9KC7ThNHQalDlbLRgfxqxEi7rGRfzYWon3Q>
    <xmx:JYuZXfAuIqlsrbOnGyliFK3I1W7Bto9OqBTmuMZevt8UwdhTgVOHvg>
    <xmx:JYuZXayl-C3H0XeUsVi4dI0dr_ZjuRiIOdaHdMM2uC410b6R2nJc5A>
    <xmx:JYuZXSspTH-igQEnsZKMtjHG6T03b4ecJK6qhrC60IcJu_knVAMx_A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5CF6CD6005A;
        Sun,  6 Oct 2019 02:35:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/5] mlxsw: Query number of modules from firmware
Date:   Sun,  6 Oct 2019 09:34:47 +0300
Message-Id: <20191006063452.7666-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Vadim says:

The patchset adds support for a new field "num_of_modules" of Management
General Peripheral Information Register (MGPIR), providing the maximum
number of QSFP modules, which can be supported by the system.

It allows to obtain the number of QSFP modules directly from this field,
as a static data, instead of old method of getting this info through
"network port to QSFP module" mapping. With the old method, in case of
port dynamic re-configuration some modules can logically "disappear" as
a result of port split operations, which can cause some modules to
appear missing.

Such scenario can happen on a system equipped with a BMC card, while PCI
chip driver at host CPU side can perform some ports "split" or "unsplit"
operations, while BMC side I2C chip driver reads the "port-to-module"
mapping.

Add common API for FW "minor" and "subminor" versions validation and
share it between PCI and I2C based drivers.

Add FW version validation for "minimal" driver, because use of new field
"num_of_modules" in MGPIR register is not backward compatible.

Vadim Pasternak (5):
  mlxsw: reg: Extend MGPIR register with new field exposing the number
    of QSFP modules
  mlxsw: hwmon: Provide optimization for QSFP modules number detection
  mlxsw: thermal: Provide optimization for QSFP modules number detection
  mlxsw: core: Push minor/subminor fw version check into helper
  mlxsw: minimal: Add validation for FW version

 drivers/net/ethernet/mellanox/mlxsw/core.c    | 10 +++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 66 +++++++++----------
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 40 +++++------
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 30 +++++++++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 10 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 +-
 7 files changed, 103 insertions(+), 62 deletions(-)

-- 
2.21.0

