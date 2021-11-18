Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D534562B3
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhKRSpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhKRSpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:45:55 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AEFC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:42:55 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p18so5993669plf.13
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=trgLLdRoT+n1b1ZyQJumup4Q5cZa0mbWekdA7zJj1aM=;
        b=Di6C5t/oTv3r1M+4hIZu+IuHmC/NkjBaUp7qqEB8dQzFNX1tUoZrx9VGvcI5Bv3zkK
         XTsInu31PXildGkudmD7tZIAEyHfihd7Ill8iQ3ux9WcQ7F5ddMZ8u2wlYyCm/JCcP1u
         Un9+rbXIqOqQyRi2YfoGTq1QknX/osZq0Ntqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=trgLLdRoT+n1b1ZyQJumup4Q5cZa0mbWekdA7zJj1aM=;
        b=sbojrq2QL+aqMb7tSCx9iLPdiD3Lqc1ViZXPtoFZH+cgR595BhrPFI2ztjj9nZMBfd
         Q8SJEAnHo5yUGJXMrqmO4OQjakEkmJEFT1XAuXrdteOwQ00OK7TzktE9zESunti7n60o
         PexfoquJC3Uon8jbPgDO19TCwSTx7Y7W2ETqTIvP7bSqi8X++2d2BaB28y7XOM1S6UDM
         wiu1YfC8U+1IW+jT/eSBNrEWxd2acjo8DmoBmkesd4Fapi4rAwgIILfpzEFZ928RIzd5
         dahdMVw9Rx2VWSlfKHatnXXhSGqr2IsPo83Rr3jH4tAlET3vOybXYHpkH/jKp+BNfu2+
         SZLQ==
X-Gm-Message-State: AOAM530+z03Hr5lG2uaPZ7PsBfQMj4bHPl++UptjPqRKgdOoloGOEZlB
        waMhXe9P8amN7NzVoG+LoWOEAg==
X-Google-Smtp-Source: ABdhPJy5jA9oURWO/IdEb+TEeg6tSEfrABxABtNmnaCStJglp5gHxTLDbkr428ogTAAJMamcnx43Mw==
X-Received: by 2002:a17:903:22cc:b0:142:d31:bd9 with SMTP id y12-20020a17090322cc00b001420d310bd9mr68301328plg.64.1637260974821;
        Thu, 18 Nov 2021 10:42:54 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id pj12sm9636583pjb.51.2021.11.18.10.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:42:54 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] bnx2x: Use struct_group() for memcpy() region
Date:   Thu, 18 Nov 2021 10:42:53 -0800
Message-Id: <20211118184253.1284535-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3770; h=from:subject; bh=6hEwDO0xCiVwAnLg85cXqg70QHmcnaSDSuC1mUGRrWU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlp6s9ZWd2LgEbJd7SUPDgW+6bEFR1SxPLBnQO7ja DhC5E4qJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZaerAAKCRCJcvTf3G3AJkoMD/ 46Sjcyi/9leOEaXQUWHSHGcVuhgVsYRm81DoGsbSucKamBD0J9BCsf6zw93ldojsRK0JUtUfW570PS qoZ42PwYS2gqV0L8F8fdKjnxVUbO+/Jbo7m6w6qFTS3yTPyQ6hJgiEclkE72d2zOmBKqqme+Zw+83Z U1s8ReI/CGgTey4mqdC2koRH0PyNPTl1pOVvyLsmsllgvqnjqvlh0RTrzeyO7n/bDLVi/40zQS/pDe BtGUDWxyYkRB4frRMfS2/h4DmwixorTYqu8tjxI+k0ZICqZfoP6NpdrATy7qKLvnziMdqSVVUzRRoi y6KOJc9iDKM1CQfwafsjLIBZGzhDYS5OKhXbekY4fUk8qfnGrEKIItg3NLGGIFNqCVxNinsY7R3o6L CinZm8SxgApls7KFtK8j3JrtpjdqC7J6iAL3nYhXHSVPsZwv7P20iC0uNawe63E73tJHh6md9i/nH8 mDGZgtWoZh7zPDuobkobw2hE1lkdvGcaVZqLh6AwxMh4bcYUbMusE3TxzM0OHtXCpGsYeX+RQ5AOPu /rfWw5byHpAt3cPIqo52nu9+SGMlYoTbjYW+ShjqIgXfCT+OSCsl6aF1B3NOyPGvzHNTgBsHg2KZj4 AaRvsRJOFe/vR35PXp4PP4xjmVAyJy+IHo5yjf2vMFP7xP2fuKisnLSQmTcA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct nig_stats around members egress_mac_pkt0_lo,
egress_mac_pkt0_hi, egress_mac_pkt1_lo, and egress_mac_pkt1_hi (and the
respective members in struct bnx2x_eth_stats), so they can be referenced
together. This will allow memcpy() and sizeof() to more easily reason
about sizes, improve readability, and avoid future warnings about writing
beyond the end of struct bnx2x_eth_stats's rx_stat_ifhcinbadoctets_hi.

"pahole" shows no size nor member offset changes to either struct.
"objdump -d" shows no meaningful object code changes (i.e. only source
line number induced differences and optimizations).

Additionally adds BUILD_BUG_ON() to compare the separate struct group
sizes.

Reviewed-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Link: https://lore.kernel.org/lkml/DM5PR18MB2229B0413C372CC6E49D59A3B2C59@DM5PR18MB2229.namprd18.prod.outlook.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c |  7 ++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h | 14 ++++++++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
index 0b193edb73b8..2bb133ae61c3 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
@@ -849,7 +849,8 @@ static int bnx2x_hw_stats_update(struct bnx2x *bp)
 
 	memcpy(old, new, sizeof(struct nig_stats));
 
-	memcpy(&(estats->rx_stat_ifhcinbadoctets_hi), &(pstats->mac_stx[1]),
+	BUILD_BUG_ON(sizeof(estats->shared) != sizeof(pstats->mac_stx[1]));
+	memcpy(&(estats->shared), &(pstats->mac_stx[1]),
 	       sizeof(struct mac_stx));
 	estats->brb_drop_hi = pstats->brb_drop_hi;
 	estats->brb_drop_lo = pstats->brb_drop_lo;
@@ -1634,9 +1635,9 @@ void bnx2x_stats_init(struct bnx2x *bp)
 			REG_RD(bp, NIG_REG_STAT0_BRB_TRUNCATE + port*0x38);
 	if (!CHIP_IS_E3(bp)) {
 		REG_RD_DMAE(bp, NIG_REG_STAT0_EGRESS_MAC_PKT0 + port*0x50,
-			    &(bp->port.old_nig_stats.egress_mac_pkt0_lo), 2);
+			    &(bp->port.old_nig_stats.egress_mac_pkt0), 2);
 		REG_RD_DMAE(bp, NIG_REG_STAT0_EGRESS_MAC_PKT1 + port*0x50,
-			    &(bp->port.old_nig_stats.egress_mac_pkt1_lo), 2);
+			    &(bp->port.old_nig_stats.egress_mac_pkt1), 2);
 	}
 
 	/* Prepare statistics ramrod data */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
index d55e63692cf3..ae93c078707b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
@@ -36,10 +36,14 @@ struct nig_stats {
 	u32 pbf_octets;
 	u32 pbf_packet;
 	u32 safc_inp;
-	u32 egress_mac_pkt0_lo;
-	u32 egress_mac_pkt0_hi;
-	u32 egress_mac_pkt1_lo;
-	u32 egress_mac_pkt1_hi;
+	struct_group(egress_mac_pkt0,
+		u32 egress_mac_pkt0_lo;
+		u32 egress_mac_pkt0_hi;
+	);
+	struct_group(egress_mac_pkt1,
+		u32 egress_mac_pkt1_lo;
+		u32 egress_mac_pkt1_hi;
+	);
 };
 
 enum bnx2x_stats_event {
@@ -83,6 +87,7 @@ struct bnx2x_eth_stats {
 	u32 no_buff_discard_hi;
 	u32 no_buff_discard_lo;
 
+	struct_group(shared,
 	u32 rx_stat_ifhcinbadoctets_hi;
 	u32 rx_stat_ifhcinbadoctets_lo;
 	u32 tx_stat_ifhcoutbadoctets_hi;
@@ -159,6 +164,7 @@ struct bnx2x_eth_stats {
 	u32 tx_stat_dot3statsinternalmactransmiterrors_lo;
 	u32 tx_stat_bmac_ufl_hi;
 	u32 tx_stat_bmac_ufl_lo;
+	);
 
 	u32 pause_frames_received_hi;
 	u32 pause_frames_received_lo;
-- 
2.30.2

