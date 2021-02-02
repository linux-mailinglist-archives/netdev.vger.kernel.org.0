Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB4830CC36
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbhBBTr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240043AbhBBTqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 14:46:24 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE685C0613D6
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 11:45:43 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id r77so21014202qka.12
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 11:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XKeYZpu4KjRZk7l45S+n9YFrwBRQQLpNsrbS6qyY4aM=;
        b=uZ8Y+YzmAE0yhFq3TMiWAP+8eyFJxPl0DRR2ay/0e05QuKTgWo3xYk8gHXHl+kutIo
         NJRjJBfD2sYHelj+muphz53HpBZjYfed/iHs90lGSOsT9P6kyebnpqGz0hgrIdH7F4ff
         pUH1UqufuEmfx01+/go96+hv3fa4XfwUgtXbajecPDMdxtgQMcW9FKkRFXkOenDkGhqf
         wsZxqarTSKU7BvOB2GV3Es3csBcVRgoiWKJ//5qEgEB4rGJ+Bi0SljGhmEx/vPYHcLVV
         o26xtKcCtEhX+shorJHKyEpTjC/0VcC1Ts4KT4ODEwr2y00uEK+8ZjN+1QdNOj7tj4ul
         QGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XKeYZpu4KjRZk7l45S+n9YFrwBRQQLpNsrbS6qyY4aM=;
        b=W1g7BmEaSN6Fq118dfDbP6gHBhqcpaAj35LH+n7mIFVOVWVcSo1Y9aFexmjntYGaEn
         zUaTwBGBybqJdjILGxRf7R2F4AGA01RYVPqi1SOSVoIfYggaE0UTGibSBEppNqbargCC
         Acs4Ki6r7/RAB5N/VHhvbf9MgiqglslD/X2+Myp+ICkP8bP/YEPztF7pNgfpUhfJgtIJ
         IjbGw+GFGDIB/0AatZYeIG1pLU5P/Y++oX+ZGdIm+ofpwk9izoxKZecEAg59oDpA7V+Y
         v1D+Bptk7Te0L22CSBZtiXFJLKSuQOpE7cKK4FCqzzubs2oAtyuhI0QtE/lIglRBKure
         hogg==
X-Gm-Message-State: AOAM5320+ttQBQtb8J1KhCTNZ61uKkJZlcR+nFleu4dYOgEMnem+lX2h
        FOS5wVWXtNvWr09pHLkjwNbPUg592hE=
X-Google-Smtp-Source: ABdhPJwQjj5ZUi94bKhDSXlFnVDS7MF3Z1UZwGBPWezZMb65STUQVFVnQKyHfS4J+FibuncbfV6tQQ==
X-Received: by 2002:a05:620a:b03:: with SMTP id t3mr23927288qkg.459.1612295142778;
        Tue, 02 Feb 2021 11:45:42 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:2842:1f5d:2de6:8f67])
        by smtp.gmail.com with ESMTPSA id p12sm17193435qtw.27.2021.02.02.11.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 11:45:42 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, oliver.graute@gmail.com,
        sagi@grimberg.me, viro@zeniv.linux.org.uk, hch@lst.de,
        alexander.duyck@gmail.com, eric.dumazet@gmail.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] udp: fix skb_copy_and_csum_datagram with odd segment sizes
Date:   Tue,  2 Feb 2021 14:45:39 -0500
Message-Id: <20210202194539.1442079-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

When iteratively computing a checksum with csum_block_add, track the
offset to correctly rotate in csum_block_add when offset is odd.

The open coded implementation of skb_copy_and_csum_datagram did this.
With the switch to __skb_datagram_iter calling csum_and_copy_to_iter,
pos was reinitialized to 0 on each call.

Bring back the pos by passing it along with the csum to the callback.

Link: https://lore.kernel.org/netdev/20210128152353.GB27281@optiplex/
Fixes: 950fcaecd5cc ("datagram: consolidate datagram copy to iter helpers")
Reported-by: Oliver Graute <oliver.graute@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>

---

Once the fix makes it to net-next, I'll follow-up with a regression
test to tools/testing/selftests/net
---
 include/linux/uio.h |  8 +++++++-
 lib/iov_iter.c      | 24 ++++++++++++++----------
 net/core/datagram.c |  4 +++-
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 72d88566694e..308194b08ca8 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -260,7 +260,13 @@ static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
 {
 	i->count = count;
 }
-size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump, struct iov_iter *i);
+
+struct csum_state {
+	__wsum *csump;
+	size_t off;
+};
+
+size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csstate, struct iov_iter *i);
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index a21e6a5792c5..087235d60514 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -592,14 +592,15 @@ static __wsum csum_and_memcpy(void *to, const void *from, size_t len,
 }
 
 static size_t csum_and_copy_to_pipe_iter(const void *addr, size_t bytes,
-				__wsum *csum, struct iov_iter *i)
+					 struct csum_state *csstate,
+					 struct iov_iter *i)
 {
 	struct pipe_inode_info *pipe = i->pipe;
 	unsigned int p_mask = pipe->ring_size - 1;
+	__wsum sum = *csstate->csump;
+	size_t off = csstate->off;
 	unsigned int i_head;
 	size_t n, r;
-	size_t off = 0;
-	__wsum sum = *csum;
 
 	if (!sanity(i))
 		return 0;
@@ -621,7 +622,8 @@ static size_t csum_and_copy_to_pipe_iter(const void *addr, size_t bytes,
 		i_head++;
 	} while (n);
 	i->count -= bytes;
-	*csum = sum;
+	*csstate->csump = sum;
+	csstate->off = off;
 	return bytes;
 }
 
@@ -1522,18 +1524,19 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum,
 }
 EXPORT_SYMBOL(csum_and_copy_from_iter_full);
 
-size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump,
+size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *_csstate,
 			     struct iov_iter *i)
 {
+	struct csum_state *csstate = _csstate;
 	const char *from = addr;
-	__wsum *csum = csump;
 	__wsum sum, next;
-	size_t off = 0;
+	size_t off;
 
 	if (unlikely(iov_iter_is_pipe(i)))
-		return csum_and_copy_to_pipe_iter(addr, bytes, csum, i);
+		return csum_and_copy_to_pipe_iter(addr, bytes, _csstate, i);
 
-	sum = *csum;
+	sum = *csstate->csump;
+	off = csstate->off;
 	if (unlikely(iov_iter_is_discard(i))) {
 		WARN_ON(1);	/* for now */
 		return 0;
@@ -1561,7 +1564,8 @@ size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump,
 		off += v.iov_len;
 	})
 	)
-	*csum = sum;
+	*csstate->csump = sum;
+	csstate->off = off;
 	return bytes;
 }
 EXPORT_SYMBOL(csum_and_copy_to_iter);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 81809fa735a7..c6ac5413dda9 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -721,8 +721,10 @@ static int skb_copy_and_csum_datagram(const struct sk_buff *skb, int offset,
 				      struct iov_iter *to, int len,
 				      __wsum *csump)
 {
+	struct csum_state csdata = { .csump = csump };
+
 	return __skb_datagram_iter(skb, offset, to, len, true,
-			csum_and_copy_to_iter, csump);
+			csum_and_copy_to_iter, &csdata);
 }
 
 /**
-- 
2.30.0.365.g02bc693789-goog

