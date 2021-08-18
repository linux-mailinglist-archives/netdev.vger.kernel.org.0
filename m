Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500B73EFC1D
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbhHRGSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbhHRGP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:15:59 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5A9C035468
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:18 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso1604749pjy.5
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BDT2fv9pfPiv1eAB6s8PWvAAZ1ZckqznJ2ALg+gPyfo=;
        b=GDS8UWoPWcrfY1r0pDowGDsnjvLxTblGroT3aoPBYgt+/WbY0erIf0jdv4Xl45shvj
         j9zj9v2NaIZtdgbvi8GLZDj4Hm1sAYkI2EwPdrZG7aZ8qsADOPvEU59FnIJJYz0j65/C
         bOca4M3rGPC1xWi0Ih3N8kfstEUi5Y3hHpM3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BDT2fv9pfPiv1eAB6s8PWvAAZ1ZckqznJ2ALg+gPyfo=;
        b=rihHUaqgIlcQlJsRTP31zmzVUcE+AlzohyVyDjImjLZXYE1IHb8stbnAwaoeD5fg68
         CRr7DlO32DjqSHL4e+7QMDtqRx0IvLS1L4mSF7h623Vp7j/6FVn2B39grJsMQjeJopYV
         YhCSmJtQHLVgJk02OUE4GPCxgpi7twu55jMzwWoSfsk80vQxsC3PWUxkyDxGF3IISyjM
         KQD2jh75qOITTUBFKLRAHQyZKnbl70cRf1FJvwW71IMSW4o6h9jaX6570otboWNqug4m
         av3/tgpmZRGBVpiU+NIvBcI38YUG0Y8HxVQu60/iZk0gWyj9Gsc12OvCn/+muoKnGLB3
         JFWg==
X-Gm-Message-State: AOAM532CxVOJ3sRGZlzddfKS7MsC1CC5plcqwzez/f5jPmahjZgbmH0f
        YRayHGP2Mj16POsdWeKtgzVJtQ==
X-Google-Smtp-Source: ABdhPJwK+GLrG/Hom7mv5L50YA6UhrS3ILfmKufoI8xzyKjhia4oO5TnM2RHSHpEbLSgxrVMRUP2eA==
X-Received: by 2002:a17:902:b692:b0:12d:8cb5:c7cc with SMTP id c18-20020a170902b69200b0012d8cb5c7ccmr5923307pls.60.1629267258164;
        Tue, 17 Aug 2021 23:14:18 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g3sm4520535pfi.197.2021.08.17.23.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:14:15 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 16/63] cxgb4: Use struct_group() for memcpy() region
Date:   Tue, 17 Aug 2021 23:04:46 -0700
Message-Id: <20210818060533.3569517-17-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4073; h=from:subject; bh=eOsIaAlKZ+jaUAE4737EiEbAobPk2H/ORfpZU/wxuAs=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMh8INFtUpImPaCu5uPFf3XUpelM+TUfZrriwlj qbNTtbmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjIQAKCRCJcvTf3G3AJpHMD/ 9ulpQtJQ8WW2UDyVKDWl0ixLhGGZti9h5dytD5AiXPr910zjFt/C7q/91dxBO9pH2eT6Di3Xq9dh+K +RNg7W/kd/ipZzl/CgcXlerviASuRTfnjGWeCFx98isL1s9+s1OP3BbwPrxJwOS/0obiqD58a9DBA9 1KNE/fUqCX93AeYK/npFyvpeoIbYK4zEeFaPIMtWYrQqXSi83b6SQ+HTFlJqrmq/PCCeZWE2BY5aas AkMcF7UTZGEeXmGPC/XROIZpjP+tj6OfWF0v5SjhJm91llU9t4FbJtTRrOyRrl522kf4FO7j4y+nNG FGC9DTy0LoJB96Eb2ZFdopzkjQSo/yBOZOBOrUtcwGvmOy374FZvePpkHG3y4P7itt2REdLBTbzDKJ UM5aPWsQeMC4ennTEvnuT5IFcJ9hq3vRCaDwH8e1WjFwsJpgNGSE0/tGMsjb9tnUAWksAsFbtrLz2y peiuYrMYM+5kNm+48kjEXMM//i4A3/jQID4fnMElCtn1ZX7QNONXIZXpWypNCC91e/sNeSUSWM8zNy SDJ46sQNh3i+Q/we8kk+7K1AjP0d2gG9/zLC0W2sTQvJjnC5mYQWZ3dEcC3+79lQHdWNf3UJv6SN1G oaAt98DBivV7/3Vi4TBGj6gJ86eFRzGhXg5jqSQnFP3tmopC7MhBXCxXiJGQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct fw_eth_tx_pkt_vm_wr around members ethmacdst,
ethmacsrc, ethtype, and vlantci, so they can be referenced together. This
will allow memcpy() and sizeof() to more easily reason about sizes,
improve readability, and avoid future warnings about writing beyond the
end of ethmacdst.

"pahole" shows no size nor member offset changes to struct
fw_eth_tx_pkt_vm_wr. "objdump -d" shows no object code changes.

Cc: Raju Rangoju <rajur@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |  8 +++++---
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h | 10 ++++++----
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c    |  7 ++-----
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 6a099cb34b12..9080b2c5ffe8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1842,8 +1842,10 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 	 * (including the VLAN tag) into the header so we reject anything
 	 * smaller than that ...
 	 */
-	fw_hdr_copy_len = sizeof(wr->ethmacdst) + sizeof(wr->ethmacsrc) +
-			  sizeof(wr->ethtype) + sizeof(wr->vlantci);
+	BUILD_BUG_ON(sizeof(wr->firmware) !=
+		     (sizeof(wr->ethmacdst) + sizeof(wr->ethmacsrc) +
+		      sizeof(wr->ethtype) + sizeof(wr->vlantci)));
+	fw_hdr_copy_len = sizeof(wr->firmware);
 	ret = cxgb4_validate_skb(skb, dev, fw_hdr_copy_len);
 	if (ret)
 		goto out_free;
@@ -1924,7 +1926,7 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 	wr->equiq_to_len16 = cpu_to_be32(wr_mid);
 	wr->r3[0] = cpu_to_be32(0);
 	wr->r3[1] = cpu_to_be32(0);
-	skb_copy_from_linear_data(skb, (void *)wr->ethmacdst, fw_hdr_copy_len);
+	skb_copy_from_linear_data(skb, &wr->firmware, fw_hdr_copy_len);
 	end = (u64 *)wr + flits;
 
 	/* If this is a Large Send Offload packet we'll put in an LSO CPL
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index 0a326c054707..2419459a0b85 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -794,10 +794,12 @@ struct fw_eth_tx_pkt_vm_wr {
 	__be32 op_immdlen;
 	__be32 equiq_to_len16;
 	__be32 r3[2];
-	u8 ethmacdst[6];
-	u8 ethmacsrc[6];
-	__be16 ethtype;
-	__be16 vlantci;
+	struct_group(firmware,
+		u8 ethmacdst[ETH_ALEN];
+		u8 ethmacsrc[ETH_ALEN];
+		__be16 ethtype;
+		__be16 vlantci;
+	);
 };
 
 #define FW_CMD_MAX_TIMEOUT 10000
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 7bc80eeb2c21..671ca93e64ab 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -1167,10 +1167,7 @@ netdev_tx_t t4vf_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct cpl_tx_pkt_core *cpl;
 	const struct skb_shared_info *ssi;
 	dma_addr_t addr[MAX_SKB_FRAGS + 1];
-	const size_t fw_hdr_copy_len = (sizeof(wr->ethmacdst) +
-					sizeof(wr->ethmacsrc) +
-					sizeof(wr->ethtype) +
-					sizeof(wr->vlantci));
+	const size_t fw_hdr_copy_len = sizeof(wr->firmware);
 
 	/*
 	 * The chip minimum packet length is 10 octets but the firmware
@@ -1267,7 +1264,7 @@ netdev_tx_t t4vf_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	wr->equiq_to_len16 = cpu_to_be32(wr_mid);
 	wr->r3[0] = cpu_to_be32(0);
 	wr->r3[1] = cpu_to_be32(0);
-	skb_copy_from_linear_data(skb, (void *)wr->ethmacdst, fw_hdr_copy_len);
+	skb_copy_from_linear_data(skb, &wr->firmware, fw_hdr_copy_len);
 	end = (u64 *)wr + flits;
 
 	/*
-- 
2.30.2

