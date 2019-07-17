Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56FDF6B71C
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 09:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfGQHHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 03:07:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34812 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfGQHHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 03:07:39 -0400
Received: by mail-pl1-f194.google.com with SMTP id i2so11474553plt.1
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 00:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=STQjFOD3USINkj9qErQKrsBiU5H7YIvj79KmIFnrB9Q=;
        b=W3XyGdzDsexqe0muEM722ykD0hL+8JfwPIlYwPnV4DD0TjMu+tAsuTICk6QeYBYnMy
         JYQtdrviTygejdwujje2maMnJf/yAJPuRETyboAyccAbcoz473Ylaf1UBDptAr6eCRFg
         poDc9aCorXO6EPuXIDDLSAeBFt+ZbKpAN1gck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=STQjFOD3USINkj9qErQKrsBiU5H7YIvj79KmIFnrB9Q=;
        b=ePZ62Hz4f4EzOf6cBFxGUzQruDECwrwLnO/fUP/e0m6oROon6VVYXqUVITPFT2FiPM
         3Hw+LTV+G/K7lZ93ocGd7/QJ9sK141q1GLAI4e9c6qmwFpe7ecBiF/mhj3L2nNSImp55
         eRHQD4M1iZCf38Dn0uyP6c/FZo202DsEZa7Wit4cAd2MXayphJIe39go6Nn2NI3CVdBC
         GubxOoTmBfe3ALLeSxhhYpWuB7U1Oav453xhl2xUgZWV866XynhHyOFYA1XlZfvnPzi8
         XC0B1cmOU0kD/VI3XO3XCBJruGEmsmlhR1dwURGDW9bEO8jJXBBxNxz2fEWbEXaRiWkd
         Rrcw==
X-Gm-Message-State: APjAAAUjcv9rwuO8KYWVlVmZT+SfCarXuPN9VQgDdlbZuzoj1XB9TP6A
        sKyPDm+TKs1J0CodH+Dwe3s2jceHDLM=
X-Google-Smtp-Source: APXvYqy96SMmiKKLWY67yIGo/SXIFZc+ZOm3cU5Am6Kf3+Np3Khnabm7vQpMPbayVupzSiZIIe81GQ==
X-Received: by 2002:a17:902:7488:: with SMTP id h8mr19094229pll.168.1563347258966;
        Wed, 17 Jul 2019 00:07:38 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r1sm22512849pgv.70.2019.07.17.00.07.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 00:07:38 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] bnxt_en: Fix VNIC accounting when enabling aRFS on 57500 chips.
Date:   Wed, 17 Jul 2019 03:07:23 -0400
Message-Id: <1563347243-8100-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike legacy chips, 57500 chips don't need additional VNIC resources
for aRFS/ntuple.  Fix the code accordingly so that we don't reserve
and allocate additional VNICs on 57500 chips.  Without this patch,
the driver is failing to initialize when it tries to allocate extra
VNICs.

Fixes: ac33906c67e2 ("bnxt_en: Add support for aRFS on 57500 chips.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---

Please queue this for 5.2 -stable also.  Thanks.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1069eb0..7134d2c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3075,7 +3075,7 @@ static int bnxt_alloc_vnics(struct bnxt *bp)
 	int num_vnics = 1;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (bp->flags & BNXT_FLAG_RFS)
+	if ((bp->flags & (BNXT_FLAG_RFS | BNXT_FLAG_CHIP_P5)) == BNXT_FLAG_RFS)
 		num_vnics += bp->rx_nr_rings;
 #endif
 
@@ -7186,6 +7186,9 @@ static int bnxt_alloc_rfs_vnics(struct bnxt *bp)
 #ifdef CONFIG_RFS_ACCEL
 	int i, rc = 0;
 
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		return 0;
+
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_vnic_info *vnic;
 		u16 vnic_id = i + 1;
@@ -9645,7 +9648,7 @@ int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 		return -ENOMEM;
 
 	vnics = 1;
-	if (bp->flags & BNXT_FLAG_RFS)
+	if ((bp->flags & (BNXT_FLAG_RFS | BNXT_FLAG_CHIP_P5)) == BNXT_FLAG_RFS)
 		vnics += rx_rings;
 
 	if (bp->flags & BNXT_FLAG_AGG_RINGS)
-- 
2.5.1

