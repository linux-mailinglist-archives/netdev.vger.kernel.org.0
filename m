Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12FD4453F7
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhKDNhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229869AbhKDNhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 09:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 631D3604DC;
        Thu,  4 Nov 2021 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636032894;
        bh=9qXAYUtBCWzw9t8zMrMjZkQj7zOepHgYzz4xCjoSlGs=;
        h=From:To:Cc:Subject:Date:From;
        b=XSL8Ti0fhy/2OR5olQKQ9QxLeb6P/8PnIURdemC5X+bP/7J1E/klZdgS4eRrFON0u
         WexF4sPUGTgRYLpiJ8rgLwrh1O365EFyvyj+ZnbIwsX4QiU1x2pDlFqbCVT+Yw9OYS
         O/j5B9kiBamTjJf/ACJ7KlwsiPoU3waMWxXcmwS3stVKpxmvL/gwI17hlvGddKNrGy
         rwOAEQuS9xz7R8tdyLuFjYqlwCNtSJEztTdCXw1SIay82/O3QI2B+pvDcwzqIdOqCF
         DZExLR05abR/DGyoj/NMBbnfB3VNUdSg+f0I0PizBuve2vGwGck7ncTp+qtjliYy7f
         h1dn1cKDW0WuA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        George Cherian <george.cherian@marvell.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] octeontx2-pf: select CONFIG_NET_DEVLINK
Date:   Thu,  4 Nov 2021 14:34:42 +0100
Message-Id: <20211104133449.1118457-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The octeontx2 pf nic driver failsz to link when the devlink support
is not reachable:

aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_dl_mcam_count_get':
otx2_devlink.c:(.text+0x10): undefined reference to `devlink_priv'
aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_dl_mcam_count_validate':
otx2_devlink.c:(.text+0x50): undefined reference to `devlink_priv'
aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_dl_mcam_count_set':
otx2_devlink.c:(.text+0xd0): undefined reference to `devlink_priv'
aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_devlink_info_get':
otx2_devlink.c:(.text+0x150): undefined reference to `devlink_priv'

This is already selected by the admin function driver, but not the
actual nic, which might be built-in when the af driver is not.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/marvell/octeontx2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index 3f982ccf2c85..639893d87055 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -31,6 +31,7 @@ config NDC_DIS_DYNAMIC_CACHING
 config OCTEONTX2_PF
 	tristate "Marvell OcteonTX2 NIC Physical Function driver"
 	select OCTEONTX2_MBOX
+	select NET_DEVLINK
 	depends on (64BIT && COMPILE_TEST) || ARM64
 	depends on PCI
 	depends on PTP_1588_CLOCK_OPTIONAL
-- 
2.29.2

