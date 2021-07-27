Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32ED3D7FD9
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhG0U7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbhG0U7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:10 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA63C061765
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso987783pjf.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bokzvyrG/U6aqJMcplPprkAXMLOtluQLvxu28yduQ3I=;
        b=BRJ6YXZFlzjubx3iY+P/cRdBsRsX9+VYLhU8PHg2kq/i8EQRUyFiRWx/kjBN2fHZ57
         Rbvn2BG0HVn8p+mlpPeMBNL1FomMRZkRcy6dAl/Lz52OpvlFYUdeYvXs1q7RrMdf5wMe
         Wym2Ven54uHKxbOOcmPeVL9UTM7qkeunpAHmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bokzvyrG/U6aqJMcplPprkAXMLOtluQLvxu28yduQ3I=;
        b=t72MJoFt5C7SBZqP4i01AUjvuCa8m6BMg+qADnJJgyXtYrJrCG6M/qqKqqEz2pekKK
         7zIgoRpDZOFzhtsBvVRiNYUw3K+TgVIWqJFoZB8buZhzoKrSNjQ6ANGeSDABLB+Et35B
         XiKYfDiGV29zYIsz8mMcYMYm07vvqHlPjz/wELZTC0slCYzBHKEtnBR1ClWc0xnEMWnK
         MJHldQnwza1TFEGND4t1tvS6lPQ65rm4aS/4JRZL7HC0om3sqDRkrrB9kd/BGcbroOS5
         i3IfwcIZjfP1+je2cjO8Y9lWgHngKwS2psrLGQXjOAkVAHL+X6dJzcMyTAvfPvf4jBto
         KlOA==
X-Gm-Message-State: AOAM530LeOt9fj+Qpr5Ljo7BPDaax14oquKtmTWtC8avSnwZ1LP8pBel
        eplVnStygCTLn6bL2zpN1Chtjw==
X-Google-Smtp-Source: ABdhPJxFkKX2Cb+2kct+lBvPCB88+g8EFFUo2+jlZ/mx9XAKU9M3E91dz4xBGj+tCH29yt2HnGdwfQ==
X-Received: by 2002:aa7:80d3:0:b029:347:820c:fbf with SMTP id a19-20020aa780d30000b0290347820c0fbfmr25091421pfn.73.1627419549404;
        Tue, 27 Jul 2021 13:59:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b7sm4526752pfl.195.2021.07.27.13.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:09 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 22/64] bnx2x: Use struct_group() for memcpy() region
Date:   Tue, 27 Jul 2021 13:58:13 -0700
Message-Id: <20210727205855.411487-23-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3598; h=from:subject; bh=A1ElP4tjKK6Dp0sFHqCrYLWenZcmBSW5YxsW0evE5y8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOFm863HXtOc8ZeFmq+4wnVfKZlM+JRATLTvRzZ tF2gptuJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzhQAKCRCJcvTf3G3AJg5IEA CxuS8kVvtGTeWwaE8ktJ8PBB1PQTvGy+LqQckpDdbfcwdWpfpfUaRcWDUYeyxQViauxQkjKX+WtpGq hyus00PTGVEQ+WIyIaFXYIjua1ivJAE+8+FSub7TLXSsMnwjQ+LHHUYqIonTydXZVNbnI26vGNsNW7 ZiV9OdkeutbHuBOgoqWEev1HlbW4+SZ11/dsn9f2pkkzB8YIhMzFPMi81NohsNTWNaJi74eoKX6qCr e5hNPHv43bf04K61+a0YVVBBpstRQLsnB1CKmBSNAfoc0edgbIAlA0OMq9CdvWO82lwYn6tk73H1Th 7fuTfssESoKBnqznYLIApEuQg37xDIDAdFz4SIssl7up5lwyunQcndQRrMZj1Y0tXkcj5w6CCUCWPw lmJrQWyWwVSqc682o6B1DYKJ4oZqFDaiMvdanoCeHEjy6x8afQF7duJMQRMS14TygWN8NoWnEQuqEI a0XvMB5J/4Z8eLg8jRrtFzwMiR9aIWjrHcHSQ+Co9sVbkxRgedeTJXK3HctCj2xHW68hdTNWPREow9 XuwAmRn6yMPi0xBwSZ1DDYkz8HIa5o6cUScE4nvrwcxz17OQhpwTybWpV3OxK3O2n9Oi/oLBwMKtNZ ogeLRK3dAHlvMOQzHJDjzkWma5VuOaPCqM5XgIHjiRuhS4PU0czJaG8Sd63Q==
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

