Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E234562B1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbhKRSpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbhKRSpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:45:38 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9246DC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:42:37 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v23so5838479pjr.5
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g7ifohihFWpBPEIRBMYCFD6XSm1nWNG6BpDsTRZ6XHo=;
        b=nkO9BbBDPXOsM3iKcvdiJU2kN/Y9lod4pdeqrpEQ4NsbYSAFDJfn8ipnOrTYMLBkfF
         fHUZvQgnHl9KOTHbksUvi78a3kAZWPcfZymKAZ0P/hLX6WpIAafyfrW5T9SR8IpBMKYW
         WYhE2I9MQx2Cwq6LbuRu+YJ3k0pBrFxb1SzC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g7ifohihFWpBPEIRBMYCFD6XSm1nWNG6BpDsTRZ6XHo=;
        b=O/NG5oi/+rbrjlzREndQzbmxa7rum9OX0g3RNhQiR12kGYPZMyjSxYArp7Z5ncms9Z
         5jm6SdIE555nVd61G2bsdhOpoOxkfUybJyOpYpnn4x6sGVAw3QK+auMs+cLYcrdspMtc
         2PSf62R+53idyi7vwjs08PXTzDKvMZGZ7UF1jyAnwR0o0PjkA2CAGlW+gTSPBfzSVgIg
         HnugiMTQRAGP2Q7RsTaxnfVVT5Hc9tiGR6m8Usx4CzOlw+k4meDpaxZ87qcPqASRgc2S
         kAY+RmxVK42kOATg17IU2JkdNhNleCV42OamHJQCLgKLMJVdJCHv23hTLL8kBpDWudb9
         O1IA==
X-Gm-Message-State: AOAM5313zzyBrbmayXyS+ZqV3HEef7oLSilPIAYR8S2cn65aSqF8MzZN
        LiYurgaK0fbcfRaFzsWjPaJ5bQ==
X-Google-Smtp-Source: ABdhPJzuxcqShpJAFKUX7yLMAwiXFEcdxpfYbLbv+aYUdUEo4NbDZO8nRU8+U530R6FtH9E5mMhZIQ==
X-Received: by 2002:a17:902:a510:b0:143:7fd1:b18a with SMTP id s16-20020a170902a51000b001437fd1b18amr69429684plq.2.1637260957147;
        Thu, 18 Nov 2021 10:42:37 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y31sm288832pgl.3.2021.11.18.10.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:42:36 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] cxgb4: Use struct_group() for memcpy() region
Date:   Thu, 18 Nov 2021 10:42:35 -0800
Message-Id: <20211118184235.1284358-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3924; h=from:subject; bh=EMSVOdlEBrYT3K6eEToqxZPrwfpp5pSNuUCPZIFpsTY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlp6aSFKw9+pCxJQ3EV3+TcOWuFZLNs55OeSKsRMV jVEUSKaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZaemgAKCRCJcvTf3G3AJuyTEA CNwo8Xp1yn8UbjydyJx7J6i2MK4E2aH/B55NFxqj8lUt50CGbXoSA0AQ3MQzwxk7gxNFgsN/xn/uDz Uj4exyiP6RmfrMMYo8Pxcs1MXbuOh6BTXWBgwzoWyVvUudEnGY4pU7xyrsmIGTpAGZdGtZKVn2En/F +e5e0qetdKdhYJIBAq1XeY9xcTnAEDZUtbJ8b8jUeUSgYnORkZDWVeKhfcZJZLW/a8jFMXTLaVfJhq nDU2ATmRV3Kswrx1jfLKcz+o7i9/u39a5bK+aUfzB/3xY16sM/HklzNWSjrPs9RYjqKagQLkBUuLcq YSf8yzJw47SPbig8EzTzXsWhfVXIPXVWZoVFLKkl6XejrDYwHf306EqgvHen3BhLyEv5+H7HU9QxzK 0+A/KtrJx2vi4+tqjvdPZInAHJahqsNFHW0zV/HBSCHb1tqHB9kA6QTm2jugZ/K1+7C2iOOqacL4i8 sdh8pGzlZhUvX1Iurfmyd8h6WThis4Ji+9AL/3ZNh2OGvTgHcAqPZWcXiagO4yJEvoEAzoHi5jlp7M 8S3CmAj7Cfg6UzBQghTemd3Ct78REZcJZ5AZxniW2f4rm8BCmA6SO5rbSGtVe9pHUuOuCKv05AiIIB RJ1B3IwoXXnB2Jl729izsIes8AUTywpzskT8tlQBjHiFvyF6NdJC7dJMTyDw==
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
index fa5b596ff23a..f889f404305c 100644
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
index 0295b2406646..43b2ceb6aa32 100644
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

