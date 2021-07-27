Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B7C3D813E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhG0VRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbhG0VQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:16:56 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0D7C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mt6so1910348pjb.1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vvD4cE9CC0UwuFk0tFrxkl0FdzddHJztTx+G0lXko2o=;
        b=X2kAI6271c2kBTWRkNK+SRyUD05VC55sahGiHWkGhtgogxcqv13k4bEJx1CzoRkXNa
         NYhpiT00hyKycZt5MZCqoJys0Vj8ijuU6JI/ftE4rUt3HcwgYje+gBJFSIJVGEF29R+B
         1p8D2+Q//lxigAx/4Pqgw4xuPqYVkWyNr336o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vvD4cE9CC0UwuFk0tFrxkl0FdzddHJztTx+G0lXko2o=;
        b=QlwOcbQrakupZzxfriTjUkp/GUSRfJzTJ3+Augtu/OzI3Nes1yPk9Um39CFVf/8Ew7
         4Rx3T5ilMSHaZti55P6JVfNYcg8y+VGH9JZZmTCxAu8q0PT4p3SLOPd/hDiabKo/QKod
         787bMfiHhw32sXsA4jz/5WbZmBGeJ6rHPv4i8hgtIt7VQiSNNhh0NtHVY+fiEVLLMuFI
         Ec2XRhrghmJApFP2aaAnxDpzqYh+HyMG39VM9lqzib81tXHIGTiZ+HTYhp9kYb9JQ/PT
         O8jIlXgbmDCHJHdo/UBwqXJ0YNYQh5dVi/5GYtRIjfK3ykgIY7jpxV5Z6QHeHhKQuOKr
         9vkQ==
X-Gm-Message-State: AOAM533KWNshCn5i3RiFHiDCcWwVpSlgvaN97YzTRKMStWO9Nv2K6B8m
        HBwmtJB+cyaftIQvk/dDCHmgRA==
X-Google-Smtp-Source: ABdhPJzx5uKJYYGIQeb6ncc39fFtWiuuJzbqS3/tvESRfbaEkAgXMJJefnvqpPoyIhq8uFbnDuQ/Yw==
X-Received: by 2002:a17:90a:3fc6:: with SMTP id u6mr9309818pjm.146.1627420615860;
        Tue, 27 Jul 2021 14:16:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t9sm5079279pgc.81.2021.07.27.14.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:16:54 -0700 (PDT)
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
Subject: [PATCH 21/64] cxgb4: Use struct_group() for memcpy() region
Date:   Tue, 27 Jul 2021 13:58:12 -0700
Message-Id: <20210727205855.411487-22-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3924; h=from:subject; bh=y2sMUjTim/gIwxveSmmQhx7NYTt7b1pVbIiPi7Evl4M=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOEnE25c6OQAZUZh7are7MybFphgO5c0XjmqaoM cypZk3uJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzhAAKCRCJcvTf3G3AJrVgD/ 9EUipW/aGz8pZZO+KYM/hHRGzHn3eJ8lr6sIZd2kwgY/YenMRyXcbyazHaKtq9k4qFGDfasF7ov858 QgSo0FLS6kKdp77nml8K4O9E8I7ayBPKVtULTSDvCMtWKEqBcfC6Q7M0Nb1UixUrR2Z1JhZZK9WtWH ID8omgKPI4LnnaYo4ycEAVB9pzBuOp2dw3mX8jThZiOXisc1A8O6CIE/RAKv1Fno46ecBIpYI58Lfj Q2dLClrapmNlYoUxj2kteXxZy308YbZng7p0daoSE68G8Dm0g06bXBLPRLc/bImHPgA3klYnSoixgZ RMD6kvFN+5q7n8MnIJdaq7gJBYyPBy/9C6wwG2lmKxvmgPKgNj1zDkyb7ttS5FAEi0kc+f+uE/Qvc6 LxFFznj1facXXLvYjxYdFVv9TF/b9/6/BBeUCOHLnyB4kGzOqlN4zBCzSlX25q7Qr8HnPEr34tJ/mP 3QyTlF29k5BfJetxRga3bVSYt4eLe0vVj8bLZug1htSckQNfV4X1STPomfizJ8F8ssl8VR+AZqcEPZ ru/Rhw2gsydUoGnN1DHmcUDJjNa8iHRdhVeY0MaxkmG0p3DjmhYkpj3nmosca/JbyjnMdcrVrIyErT CYzNTxmbAjdwEJnwSyRPybVcS5R4LwUCJqb30qR0qVGXDBcsbP8DrEjKddqA==
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

