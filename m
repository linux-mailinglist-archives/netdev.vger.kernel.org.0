Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C10345E90
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 13:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhCWMyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 08:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhCWMxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 08:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A8B9619B8;
        Tue, 23 Mar 2021 12:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616504023;
        bh=B7zKP0wEFU2/3CWm2Zth2CEFBBqTytn5CoddIaTYU+I=;
        h=From:To:Cc:Subject:Date:From;
        b=oKP9MQbSO7Nq/q3n9+857PVW8po2CYEGWqF9iMOK0snF3j70JImIfLbBlYJNV2NTu
         K0lac8eIdd4H2GuhddVgKlWxnxl52/XouEIc/0nSF0mUhb2KXeTyHUZ6d0M7TVhd1x
         PETGi0NGmQqcDedfAQ9Tpewc8sVKByJ9xlH9BRHXNDsBjitZEyPtVQlGqAsP1NST9t
         9B3DCJyeViYxuIA8Hl+HhHIBVt1VsgR5W6VuxTBCTlDZNLF4ryqYoO0H/7Ya8egFsc
         xajjxOnlxieXLWYOWAgf7mAw7eqb2Y1xkwYAVsg2V4m+a81HKpbFx9gOTH0ykT2Xqu
         lr2TE7kBTaTSQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Christina Jacob <cjacob@marvell.com>,
        Zyta Szpak <zyta@marvell.com>,
        Colin Ian King <colin.king@canonical.com>,
        Rakesh Babu <rsaladi2@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] octeontx2: fix -Wnonnull warning
Date:   Tue, 23 Mar 2021 13:53:29 +0100
Message-Id: <20210323125337.1783611-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When compile testing this driver on a platform on which probe() is
known to fail at compile time, gcc warns about the cgx_lmactype_string[]
array being uninitialized:

In function 'strncpy',
    inlined from 'link_status_user_format' at /git/arm-soc/drivers/net/ethernet/marvell/octeontx2/af/cgx.c:838:2,
    inlined from 'cgx_link_change_handler' at /git/arm-soc/drivers/net/ethernet/marvell/octeontx2/af/cgx.c:853:2:
include/linux/fortify-string.h:27:30: error: argument 2 null where non-null expected [-Werror=nonnull]
   27 | #define __underlying_strncpy __builtin_strncpy

Address this by turning the runtime initialization into a fixed array,
which should also produce better code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 60 +++++++++----------
 1 file changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 9caa375d01b1..ea5a033a1d0b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -30,10 +30,35 @@
 static LIST_HEAD(cgx_list);
 
 /* Convert firmware speed encoding to user format(Mbps) */
-static u32 cgx_speed_mbps[CGX_LINK_SPEED_MAX];
+static const u32 cgx_speed_mbps[CGX_LINK_SPEED_MAX] = {
+	[CGX_LINK_NONE] = 0,
+	[CGX_LINK_10M] = 10,
+	[CGX_LINK_100M] = 100,
+	[CGX_LINK_1G] = 1000,
+	[CGX_LINK_2HG] = 2500,
+	[CGX_LINK_5G] = 5000,
+	[CGX_LINK_10G] = 10000,
+	[CGX_LINK_20G] = 20000,
+	[CGX_LINK_25G] = 25000,
+	[CGX_LINK_40G] = 40000,
+	[CGX_LINK_50G] = 50000,
+	[CGX_LINK_80G] = 80000,
+	[CGX_LINK_100G] = 100000,
+};
 
 /* Convert firmware lmac type encoding to string */
-static char *cgx_lmactype_string[LMAC_MODE_MAX];
+static const char *cgx_lmactype_string[LMAC_MODE_MAX] = {
+	[LMAC_MODE_SGMII] = "SGMII",
+	[LMAC_MODE_XAUI] = "XAUI",
+	[LMAC_MODE_RXAUI] = "RXAUI",
+	[LMAC_MODE_10G_R] = "10G_R",
+	[LMAC_MODE_40G_R] = "40G_R",
+	[LMAC_MODE_QSGMII] = "QSGMII",
+	[LMAC_MODE_25G_R] = "25G_R",
+	[LMAC_MODE_50G_R] = "50G_R",
+	[LMAC_MODE_100G_R] = "100G_R",
+	[LMAC_MODE_USXGMII] = "USXGMII",
+};
 
 /* CGX PHY management internal APIs */
 static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool en);
@@ -657,34 +682,6 @@ int cgx_fwi_cmd_generic(u64 req, u64 *resp, struct cgx *cgx, int lmac_id)
 	return err;
 }
 
-static inline void cgx_link_usertable_init(void)
-{
-	cgx_speed_mbps[CGX_LINK_NONE] = 0;
-	cgx_speed_mbps[CGX_LINK_10M] = 10;
-	cgx_speed_mbps[CGX_LINK_100M] = 100;
-	cgx_speed_mbps[CGX_LINK_1G] = 1000;
-	cgx_speed_mbps[CGX_LINK_2HG] = 2500;
-	cgx_speed_mbps[CGX_LINK_5G] = 5000;
-	cgx_speed_mbps[CGX_LINK_10G] = 10000;
-	cgx_speed_mbps[CGX_LINK_20G] = 20000;
-	cgx_speed_mbps[CGX_LINK_25G] = 25000;
-	cgx_speed_mbps[CGX_LINK_40G] = 40000;
-	cgx_speed_mbps[CGX_LINK_50G] = 50000;
-	cgx_speed_mbps[CGX_LINK_80G] = 80000;
-	cgx_speed_mbps[CGX_LINK_100G] = 100000;
-
-	cgx_lmactype_string[LMAC_MODE_SGMII] = "SGMII";
-	cgx_lmactype_string[LMAC_MODE_XAUI] = "XAUI";
-	cgx_lmactype_string[LMAC_MODE_RXAUI] = "RXAUI";
-	cgx_lmactype_string[LMAC_MODE_10G_R] = "10G_R";
-	cgx_lmactype_string[LMAC_MODE_40G_R] = "40G_R";
-	cgx_lmactype_string[LMAC_MODE_QSGMII] = "QSGMII";
-	cgx_lmactype_string[LMAC_MODE_25G_R] = "25G_R";
-	cgx_lmactype_string[LMAC_MODE_50G_R] = "50G_R";
-	cgx_lmactype_string[LMAC_MODE_100G_R] = "100G_R";
-	cgx_lmactype_string[LMAC_MODE_USXGMII] = "USXGMII";
-}
-
 static int cgx_link_usertable_index_map(int speed)
 {
 	switch (speed) {
@@ -826,7 +823,7 @@ static inline void link_status_user_format(u64 lstat,
 					   struct cgx_link_user_info *linfo,
 					   struct cgx *cgx, u8 lmac_id)
 {
-	char *lmac_string;
+	const char *lmac_string;
 
 	linfo->link_up = FIELD_GET(RESP_LINKSTAT_UP, lstat);
 	linfo->full_duplex = FIELD_GET(RESP_LINKSTAT_FDUPLEX, lstat);
@@ -1375,7 +1372,6 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	list_add(&cgx->cgx_list, &cgx_list);
 
-	cgx_link_usertable_init();
 
 	cgx_populate_features(cgx);
 
-- 
2.29.2

