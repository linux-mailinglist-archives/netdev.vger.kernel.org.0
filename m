Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE8836685
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfFEVMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:14 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36230 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFEVMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:13 -0400
Received: by mail-qt1-f193.google.com with SMTP id u12so260609qth.3
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dLPGcpdSfCRyLS7Y0eLFF/7oaj5BqRJXgjbceBIYUm4=;
        b=SpyhmVvwml9onZ0Njos468DQURqk7c/5lTuIfyYgbgpDLS6n/BOLyRIYh7SL9Yog0D
         drYfBCfO5FwtR4pke+vjQfo3xaDKxFhvcfc1nyvwmDEEmAhmf6WS4xQdENgBZdplr1is
         uiWH5vN89p7R0fc5Y2/e5s6VvdUdHNNm0tqsvP6vS0iaoAha+S9XxN+hNynUiaUV9tP2
         GrKQai+C0ayE6qYyvQRzIdDGkzrDsp68XUsQoFqFx7LCBqpOLcrDa4Am8IMV0A3rzb1f
         pEfu+3p9ItMn93UknNriwze1ZOdSqKU7WfvXKitX397aPDzUZIhuIKy14Kai16xnkawY
         iH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dLPGcpdSfCRyLS7Y0eLFF/7oaj5BqRJXgjbceBIYUm4=;
        b=f/rxnld5dyUbXClB9Eku2Gk66tcHbJHXMXw+6/9ZWYj2MBMW8YH9V17hbJ/rSK2Vh0
         HXt2V/GTAr78VUFoLoqf2b83andYBAKHNvAkjcGzbYdIDzKfgtu0c5uLyK3ckJ+c4CLW
         lIYUcD2WHWb20GxnCT6PYqf8oByzSJz148nhwLjtQhsbiFpEJPePs1E+PnWxTsKEVjks
         kQ+LKc9h0WmBJKnHi/VfYQU4VHNbcbHcL9bcnHFieNALKK7lpz9mI31vd+aThBifFxFo
         sdSiII8LYb27wivtihww6EDumQ67cUd7xMGRt7BkF4/UKPHn99rE+mPL4w9jbL5+MnwN
         n0Ag==
X-Gm-Message-State: APjAAAXkxoEPo/noodXKmqXclELAwplfcRHC5nf4MfcaTMjTjeAG9aHg
        7D1v4nOg0ylg1kWT0vvMiZ/ASniNBX0=
X-Google-Smtp-Source: APXvYqz7zdttjXY4FDHfxhkT6UsaQtyX7n/pF0LpgXX6QkL0ufMGbZ1lgssVJ7IcFgm3jjf8t7c++g==
X-Received: by 2002:a0c:95f8:: with SMTP id t53mr16117357qvt.115.1559769132475;
        Wed, 05 Jun 2019 14:12:12 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:11 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 07/13] nfp: prepare for more TX metadata prepend
Date:   Wed,  5 Jun 2019 14:11:37 -0700
Message-Id: <20190605211143.29689-8-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent patches will add support for more TX metadata fields.
Prepare for this by handling an additional double word - firmware
handle as metadata type 7.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../ethernet/netronome/nfp/nfp_net_common.c   | 44 ++++++++++++++-----
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  1 +
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index ac6ea6d3557b..df21effec320 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -808,24 +808,47 @@ static void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring)
 	tx_ring->wr_ptr_add = 0;
 }
 
-static int nfp_net_prep_port_id(struct sk_buff *skb)
+static int nfp_net_prep_tx_meta(struct sk_buff *skb, u64 tls_handle)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
 	unsigned char *data;
+	u32 meta_id = 0;
+	int md_bytes;
 
-	if (likely(!md_dst))
-		return 0;
-	if (unlikely(md_dst->type != METADATA_HW_PORT_MUX))
+	if (likely(!md_dst && !tls_handle))
 		return 0;
+	if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX)) {
+		if (!tls_handle)
+			return 0;
+		md_dst = NULL;
+	}
 
-	if (unlikely(skb_cow_head(skb, 8)))
+	md_bytes = 4 + !!md_dst * 4 + !!tls_handle * 8;
+
+	if (unlikely(skb_cow_head(skb, md_bytes)))
 		return -ENOMEM;
 
-	data = skb_push(skb, 8);
-	put_unaligned_be32(NFP_NET_META_PORTID, data);
-	put_unaligned_be32(md_dst->u.port_info.port_id, data + 4);
+	meta_id = 0;
+	data = skb_push(skb, md_bytes) + md_bytes;
+	if (md_dst) {
+		data -= 4;
+		put_unaligned_be32(md_dst->u.port_info.port_id, data);
+		meta_id = NFP_NET_META_PORTID;
+	}
+	if (tls_handle) {
+		/* conn handle is opaque, we just use u64 to be able to quickly
+		 * compare it to zero
+		 */
+		data -= 8;
+		memcpy(data, &tls_handle, sizeof(tls_handle));
+		meta_id <<= NFP_NET_META_FIELD_SIZE;
+		meta_id |= NFP_NET_META_CONN_HANDLE;
+	}
+
+	data -= 4;
+	put_unaligned_be32(meta_id, data);
 
-	return 8;
+	return md_bytes;
 }
 
 /**
@@ -848,6 +871,7 @@ static int nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 	struct nfp_net_dp *dp;
 	dma_addr_t dma_addr;
 	unsigned int fsize;
+	u64 tls_handle = 0;
 	u16 qidx;
 
 	dp = &nn->dp;
@@ -869,7 +893,7 @@ static int nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_BUSY;
 	}
 
-	md_bytes = nfp_net_prep_port_id(skb);
+	md_bytes = nfp_net_prep_tx_meta(skb, tls_handle);
 	if (unlikely(md_bytes < 0))
 		goto err_flush;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index b570c90fa96c..ee6b24e4eacd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -44,6 +44,7 @@
 #define NFP_NET_META_MARK		2
 #define NFP_NET_META_PORTID		5
 #define NFP_NET_META_CSUM		6 /* checksum complete type */
+#define NFP_NET_META_CONN_HANDLE	7
 
 #define NFP_META_PORT_ID_CTRL		~0U
 
-- 
2.21.0

