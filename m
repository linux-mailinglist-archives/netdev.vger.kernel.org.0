Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7E6352AFC
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 15:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhDBN0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 09:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhDBN0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 09:26:09 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A3CC0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 06:26:06 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so6194561pjb.0
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 06:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nk+eDWG+Yugeh+2vUQ3xh9rieveuu83pFSxXTHCSafY=;
        b=B2uCfpeLEfh7+GbIRXc92PEReJZPG8BgODY1iTU947PttSc1udmsdBVjcPOoriAixR
         FyOfN5k0IL+LrCvxBJk/vwh0V+yWkXlw5rO4V9LPmQBEr28bgLoytT4sWrAcG9R3ZZ15
         p0PHhZljifXdclzWtfw5MPBO3EFOPL5Z3nzIjJoiMKMkMkj+TaFsKk0Q22gmnaxB8x8A
         vrCcpm9loqwbDrDWd8rznfahQtAgDj6I5xK+K+Lb1WzZq6WOKir4uHHXXs/RqRO1IBMn
         tqkP4ba57yZE9LLVjuGHsVlr9fXGu0LNLEJPmKFA5+Nxmo7FThhOyxRAzpYtuzQMAVxc
         QGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nk+eDWG+Yugeh+2vUQ3xh9rieveuu83pFSxXTHCSafY=;
        b=RjxU9jnuoBc8AXZNAFc1HX2UWc6oa67Q44b/qnYV2aYquA12KhMUSRCc14iQ0v9QYZ
         Vf8llWZbWKM3KOWX44e8g/MA0msLF7lvGPac4WnbbFP4JycG9IyD5kMxI5R6pK5/S5l+
         kJ0oKz/mSCs29qYAhkVd3pKKNe0x2iIOQcVAMdY519uRj1whmWytHXupeWde9Ds5oqNi
         KrLGj2ZyQrFfS0W0Ku45y6B5gqfQRiBVwgIUMTnxCzRyTpLnknWU9Pvw9ChB1O9IzGYE
         yyIqMXOV8xgJlyNqWnZhKJLba9T0OpzMOg2vtMSHPnwl6akJKfq7/cCaaup6DUDkVRyk
         MLPA==
X-Gm-Message-State: AOAM530KHACHHomM12xfiAdU4ADytBtbb0HVdFC6Xt9GjufRk+X/H+Rx
        tP8a+5UvTkQET3hNI4pCeRc=
X-Google-Smtp-Source: ABdhPJz75mHHj1AwPACN1N3Khde/fIrHWHsGNKQt88nZjq2LvlV8IY6bbUOiBoDPXvcxYAE3Q9sDVw==
X-Received: by 2002:a17:902:bd8f:b029:e6:ec5a:3a6 with SMTP id q15-20020a170902bd8fb02900e6ec5a03a6mr13074978pls.31.1617369966016;
        Fri, 02 Apr 2021 06:26:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a57a:ec96:644b:4d80])
        by smtp.gmail.com with ESMTPSA id s22sm8143247pjs.42.2021.04.02.06.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 06:26:05 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net] virtio_net: Do not pull payload in skb->head
Date:   Fri,  2 Apr 2021 06:26:02 -0700
Message-Id: <20210402132602.3659282-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Xuan Zhuo reported that commit 3226b158e67c ("net: avoid 32 x truesize
under-estimation for tiny skbs") brought  a ~10% performance drop.

The reason for the performance drop was that GRO was forced
to chain sk_buff (using skb_shinfo(skb)->frag_list), which
uses more memory but also cause packet consumers to go over
a lot of overhead handling all the tiny skbs.

It turns out that virtio_net page_to_skb() has a wrong strategy :
It allocates skbs with GOOD_COPY_LEN (128) bytes in skb->head, then
copies 128 bytes from the page, before feeding the packet to GRO stack.

This was suboptimal before commit 3226b158e67c ("net: avoid 32 x truesize
under-estimation for tiny skbs") because GRO was using 2 frags per MSS,
meaning we were not packing MSS with 100% efficiency.

Fix is to pull only the ethernet header in page_to_skb()

Then, we change virtio_net_hdr_to_skb() to pull the missing
headers, instead of assuming they were already pulled by callers.

This fixes the performance regression, but could also allow virtio_net
to accept packets with more than 128bytes of headers.

Many thanks to Xuan Zhuo for his report, and his tests/help.

Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://www.spinics.net/lists/netdev/msg731397.html
Co-Developed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org
---
 drivers/net/virtio_net.c   | 10 +++++++---
 include/linux/virtio_net.h | 14 +++++++++-----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 82e520d2cb1229a0c7b9fd0def3e4a7135536478..0824e6999e49957f7aaf7c990f6259792d42f32b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -406,9 +406,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	offset += hdr_padded_len;
 	p += hdr_padded_len;
 
-	copy = len;
-	if (copy > skb_tailroom(skb))
-		copy = skb_tailroom(skb);
+	/* Copy all frame if it fits skb->head, otherwise
+	 * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
+	 */
+	if (len <= skb_tailroom(skb))
+		copy = len;
+	else
+		copy = ETH_HLEN + metasize;
 	skb_put_data(skb, p, copy);
 
 	if (metasize) {
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 98775d7fa69632e2c2da30b581a666f7fbb94b64..b465f8f3e554f27ced45c35f54f113cf6dce1f07 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -65,14 +65,18 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 
 	if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
-		u16 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
-		u16 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
+		u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
+		u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
+		u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
+
+		if (!pskb_may_pull(skb, needed))
+			return -EINVAL;
 
 		if (!skb_partial_csum_set(skb, start, off))
 			return -EINVAL;
 
 		p_off = skb_transport_offset(skb) + thlen;
-		if (p_off > skb_headlen(skb))
+		if (!pskb_may_pull(skb, p_off))
 			return -EINVAL;
 	} else {
 		/* gso packets without NEEDS_CSUM do not set transport_offset.
@@ -102,14 +106,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			}
 
 			p_off = keys.control.thoff + thlen;
-			if (p_off > skb_headlen(skb) ||
+			if (!pskb_may_pull(skb, p_off) ||
 			    keys.basic.ip_proto != ip_proto)
 				return -EINVAL;
 
 			skb_set_transport_header(skb, keys.control.thoff);
 		} else if (gso_type) {
 			p_off = thlen;
-			if (p_off > skb_headlen(skb))
+			if (!pskb_may_pull(skb, p_off))
 				return -EINVAL;
 		}
 	}
-- 
2.31.0.208.g409f899ff0-goog

