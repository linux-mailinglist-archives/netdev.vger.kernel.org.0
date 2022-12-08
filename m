Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F6D64658F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiLHACU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiLHACS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:02:18 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8DA8C440
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 16:02:16 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d3so18578808plr.10
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 16:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dk1yAoyQU+RLCYzQPhP3++n5k0AlqyyhOlwfArVtCN8=;
        b=CfAuGzp9X4iBKtpuQ05m/nLzqNjWLddivhcjBXfwQpOFO0jBdxJx2iBZedSmSZhQkq
         xUTzYrTLLf23grDjO0hf/+R8GsE4OfFz5vPRSFlyvyiRbq7JAN5B0OhF2O1LGbvKXpc2
         dkD25p/EY7gml9MOqEmL3vlNPDCwS8NjoJx1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dk1yAoyQU+RLCYzQPhP3++n5k0AlqyyhOlwfArVtCN8=;
        b=HzXoI58Dc4XNgTGxDGockZwtRjVjxEjGugdd3tYyUG1sqSibQ3tVpFSBVV2kL60G2P
         EHv9xjzQ6MTULXkL6MqbXfXOslZeYbq3wams+UZGCUAviem00+xTV+TIY/C/uzHsN1pF
         GRQEdXthumyWbhmpT/Z06jpyfXXiBgDhtHZqRO7+853Qks8G/NATNvO1fRbBFEA7Cv5J
         XDohfdxqAaDt8SQ2R169jisM5c4stP/fkUAaZfPHX00eQxaKaXvKCey6yMEBQUAzS5WN
         nX+GdzAqbqNLGDixi347fvot83hyu4m6j9sQ3Iqxh7DyuB3XniPqpmZhS8JAwpZOA93y
         i06g==
X-Gm-Message-State: ANoB5pkpsLZNz7Ps7fyn8uDq0h9qRRSWfa6Jx6VuSse0x2n/g1E7iQbU
        PoI8HYJPduy0dQ4kc0C74mLJlA==
X-Google-Smtp-Source: AA0mqf4HIgFTUJHMRF3JILeCrjw7S70fUUJWDbaPjwiHDjSbqcJpUgdTYeHaVR0Jfy9Z0A83nK/xfA==
X-Received: by 2002:a17:90b:711:b0:210:9858:2b2c with SMTP id s17-20020a17090b071100b0021098582b2cmr102785702pjz.191.1670457735590;
        Wed, 07 Dec 2022 16:02:15 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s30-20020a63925e000000b00477def759cbsm5933519pgn.58.2022.12.07.16.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 16:02:15 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        pepsipu <soopthegoop@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Andrii Nakryiko <andrii@kernel.org>, ast@kernel.org,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>, martin.lau@linux.dev,
        Stanislav Fomichev <sdf@google.com>, song@kernel.org,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Rasesh Mody <rmody@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Richard Gobert <richardbgobert@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        GR-Linux-NIC-Dev@marvell.com, linux-hardening@vger.kernel.org
Subject: [PATCH net-next v2] skbuff: Introduce slab_build_skb()
Date:   Wed,  7 Dec 2022 16:02:13 -0800
Message-Id: <20221208000209.gonna.368-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6532; h=from:subject:message-id; bh=I5zpjdf6giyPTGWK3waT0b1aZ9hEwojgcygujraz8dc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjkSmEkOgkOZcWwciYH5GLWV3obftsCrvUcG4e847b Bi5nkbGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY5EphAAKCRCJcvTf3G3AJrfZD/ 9J2X/Gw9ncWI4dk8wA/WdzHwO05CFaHzRpUpXr+GMG8xWhch5i+SxqJDXVTzXb0YA7TXlpkO9D+otk 5R29AmizYM7EXsl1yZeyMbGQ5hpAufcuX82qAOIodz/lW3bzrzs21vRcUZLrwoV/Fyw0pxzHY5Pf5h ph+jxiId3DghZjSkowXYtsPGXEcnWxRVtUdTcXIwi4Ry8XvyJpqk0jOBV7ZnM8kEJVJ6pUgNjdt61c Gdhjag0bgthVFgM2mpz/QmavD+S+3QlwLB9a3DoVWUJOKJTSQrHNNzbygYMoN5RqmnPz+OcqVneI4E +XcJ6Dh3/v1qbD+rVNET9u/b3bPLy/x06rWB8dgrKn0P/mb601uzlKCKhmm1TG24z1Z9h8w366AVA7 9dU9EwQINOJTDi6NUYcnGa3GApoKuVGCZ03C9xewFJ6BfCrj5qjwQT7CGTH5Vug9puDgl7rBqlIskS WiKGOdtd2hO+BdD3ggipo0i6+bmO07sYVTvcUDv/6GsZZyUy8jET1YpxQS6KU6pKyabXunytY0XNDN o2/3jZeX+Q1xeLy+ge8aeZvS6ypBvKHk51BiHlDd+HM/Ea0wvyjuZr6d5xnNwg9UqO3Po4lIYkKctJ kXJR6WE6EASTgDFD1Xdp19J2MB65NyB2AMFRRTo2I8Nk6cmA+N6Z+5R+M5Sg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller reported:

  BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x235/0x340 net/core/skbuff.c:294
  Write of size 32 at addr ffff88802aa172c0 by task syz-executor413/5295

For bpf_prog_test_run_skb(), which uses a kmalloc()ed buffer passed to
build_skb().

When build_skb() is passed a frag_size of 0, it means the buffer came
from kmalloc. In these cases, ksize() is used to find its actual size,
but since the allocation may not have been made to that size, actually
perform the krealloc() call so that all the associated buffer size
checking will be correctly notified. Split this logic out into a new
interface, slab_build_skb(), but leave the original 0 checking for now
to catch any stragglers.

Reported-by: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
Link: https://groups.google.com/g/syzkaller-bugs/c/UnIKxTtU5-0/m/-wbXinkgAQAJ
Fixes: 38931d8989b5 ("mm: Make ksize() a reporting-only function")
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: pepsipu <soopthegoop@gmail.com>
Cc: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: kasan-dev <kasan-dev@googlegroups.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: ast@kernel.org
Cc: bpf <bpf@vger.kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Hao Luo <haoluo@google.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: jolsa@kernel.org
Cc: KP Singh <kpsingh@kernel.org>
Cc: martin.lau@linux.dev
Cc: Stanislav Fomichev <sdf@google.com>
Cc: song@kernel.org
Cc: Yonghong Song <yhs@fb.com>
Cc: netdev@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
Is this what you had in mind for this kind of change?
v2: introduce separate helper (kuba)
v1: https://lore.kernel.org/netdev/20221206231659.never.929-kees@kernel.org/
---
 drivers/net/ethernet/broadcom/bnx2.c      |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c |  2 +-
 include/linux/skbuff.h                    |  1 +
 net/bpf/test_run.c                        |  2 +-
 net/core/skbuff.c                         | 52 +++++++++++++++++++++--
 5 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index fec57f1982c8..b2230a4a2086 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -3045,7 +3045,7 @@ bnx2_rx_skb(struct bnx2 *bp, struct bnx2_rx_ring_info *rxr, u8 *data,
 
 	dma_unmap_single(&bp->pdev->dev, dma_addr, bp->rx_buf_use_size,
 			 DMA_FROM_DEVICE);
-	skb = build_skb(data, 0);
+	skb = slab_build_skb(data);
 	if (!skb) {
 		kfree(data);
 		goto error;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index ed274f033626..e5116a86cfbc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -200,7 +200,7 @@ static void qed_ll2b_complete_rx_packet(void *cxt,
 	dma_unmap_single(&cdev->pdev->dev, buffer->phys_addr,
 			 cdev->ll2->rx_size, DMA_FROM_DEVICE);
 
-	skb = build_skb(buffer->data, 0);
+	skb = slab_build_skb(buffer->data);
 	if (!skb) {
 		DP_INFO(cdev, "Failed to build SKB\n");
 		kfree(buffer->data);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7be5bb4c94b6..0b391b635430 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1253,6 +1253,7 @@ struct sk_buff *build_skb_around(struct sk_buff *skb,
 void skb_attempt_defer_free(struct sk_buff *skb);
 
 struct sk_buff *napi_build_skb(void *data, unsigned int frag_size);
+struct sk_buff *slab_build_skb(void *data);
 
 /**
  * alloc_skb - allocate a network buffer
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 13d578ce2a09..611b1f4082cf 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1130,7 +1130,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	}
 	sock_init_data(NULL, sk);
 
-	skb = build_skb(data, 0);
+	skb = slab_build_skb(data);
 	if (!skb) {
 		kfree(data);
 		kfree(ctx);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d9719e72f9d..2bff6af6a777 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -269,12 +269,10 @@ static struct sk_buff *napi_skb_cache_get(void)
 	return skb;
 }
 
-/* Caller must provide SKB that is memset cleared */
-static void __build_skb_around(struct sk_buff *skb, void *data,
-			       unsigned int frag_size)
+static inline void __finalize_skb_around(struct sk_buff *skb, void *data,
+					 unsigned int size)
 {
 	struct skb_shared_info *shinfo;
-	unsigned int size = frag_size ? : ksize(data);
 
 	size -= SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
@@ -296,6 +294,52 @@ static void __build_skb_around(struct sk_buff *skb, void *data,
 	skb_set_kcov_handle(skb, kcov_common_handle());
 }
 
+static inline void __slab_build_skb(struct sk_buff *skb, void *data,
+				    unsigned int *size)
+{
+	void *resized;
+
+	*size = ksize(data);
+	/* krealloc() will immediate return "data" when
+	 * "ksize(data)" is requested: it is the existing upper
+	 * bounds. As a result, GFP_ATOMIC will be ignored.
+	 */
+	resized = krealloc(data, *size, GFP_ATOMIC);
+	WARN_ON_ONCE(resized != data);
+}
+
+struct sk_buff *slab_build_skb(void *data)
+{
+	struct sk_buff *skb;
+	unsigned int size;
+
+	skb = kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return NULL;
+
+	memset(skb, 0, offsetof(struct sk_buff, tail));
+	__slab_build_skb(skb, data, &size);
+	__finalize_skb_around(skb, data, size);
+
+	return skb;
+}
+EXPORT_SYMBOL(slab_build_skb);
+
+/* Caller must provide SKB that is memset cleared */
+static void __build_skb_around(struct sk_buff *skb, void *data,
+			       unsigned int frag_size)
+{
+	unsigned int size = frag_size;
+
+	/* When frag_size == 0, the buffer came from kmalloc, so we
+	 * must find its true allocation size (and grow it to match).
+	 */
+	if (WARN_ONCE(size == 0, "Use slab_build_skb() instead"))
+		__slab_build_skb(skb, data, &size);
+
+	__finalize_skb_around(skb, data, size);
+}
+
 /**
  * __build_skb - build a network buffer
  * @data: data buffer provided by caller
-- 
2.34.1

