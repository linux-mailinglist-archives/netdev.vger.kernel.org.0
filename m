Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D042F30E34C
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 20:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhBCTap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 14:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhBCTai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 14:30:38 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BEAC06178C
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 11:29:58 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id h21so544884qvb.8
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 11:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OBAOidSrXm2Sy3YWpFzBuwWGoxluD1cVMxKH70h9RdA=;
        b=VvcwiUzaV4GaYHjC04reFXKGPZNzf8sPDljnzOcaFj6isl8heE+W+aC3WVVWIh1RYZ
         QvPgf7zap2cTNZIBoB83sf0VPWrAkwjsdyeW5zaczqYsrrZEdBcB/NYjf/tKQAwc+d5b
         qZv3NSQx09nPJl/apPmammstQwGJ3wEn6R3IXuI7mp6eQzO0u1DLNRcnHijYbuHXhMvZ
         CSFk9Zh5414yO4BHNueOMEaWql6PfZiubz2Bi8l5ikMJY6w4Cs/Vjz7+73Sz986fsDVj
         UfAIO6OWx8qcNNYStwG52WJWAl8WPTWyZDSy5fgFgOVmOaI9wLA2y44PvAUhYjlC1cvw
         w1oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OBAOidSrXm2Sy3YWpFzBuwWGoxluD1cVMxKH70h9RdA=;
        b=AtcMvOgqFdXqeAbahaDyfZCGL1gxT0fmzh7MWqri9AbAD+wOb5wo7ZemjUVRKwxLec
         VF2cV5LMIqddEWvz8YA4F3brDB3a/AO3JTH9fRH+FAcNLdIH84aVUuzDGLyMo8++z1Ms
         h2qKEMorhiUE8LpYowsxQWPNcStzHdPd3DUP8kDE2terKVHgp8NrY+gf8hosY1nFRGId
         dh1BA26NpOZalf7k43q0H+SIE363ES9jU0yBguSu4rOmoF/jOPD+tu8ZsA7fUlh5NF96
         qqAaU4i/81FG/mOZwYYvda4YjnwOud0h+tLt1Pin8WO19gRCKFin6zbBof+nZrjVuirs
         LaYg==
X-Gm-Message-State: AOAM5308zV1nd8psfhRUXcplS3eNXgU/yy64/44OByXqB8sGlDRBuKk8
        cpxrlCnSeVLlNzWxNVhHPQY1cWAAeaw=
X-Google-Smtp-Source: ABdhPJypGVbp6daxuqqqhcX0BZcKVcJUqMuChO8YXteg5DQ5SOWG1a0spbI3XNwEIFME3b71C/Tsbg==
X-Received: by 2002:a0c:9ac2:: with SMTP id k2mr4374168qvf.3.1612380597373;
        Wed, 03 Feb 2021 11:29:57 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:2842:1f5d:2de6:8f67])
        by smtp.gmail.com with ESMTPSA id c17sm2704135qkb.13.2021.02.03.11.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 11:29:55 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, oliver.graute@gmail.com,
        sagi@grimberg.me, viro@zeniv.linux.org.uk, hch@lst.de,
        alexander.duyck@gmail.com, eric.dumazet@gmail.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net v2] udp: fix skb_copy_and_csum_datagram with odd segment sizes
Date:   Wed,  3 Feb 2021 14:29:52 -0500
Message-Id: <20210203192952.1849843-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

When iteratively computing a checksum with csum_block_add, track the
offset "pos" to correctly rotate in csum_block_add when offset is odd.

The open coded implementation of skb_copy_and_csum_datagram did this.
With the switch to __skb_datagram_iter calling csum_and_copy_to_iter,
pos was reinitialized to 0 on each call.

Bring back the pos by passing it along with the csum to the callback.

Changes v1->v2
  - pass csum value, instead of csump pointer (Alexander Duyck)

Link: https://lore.kernel.org/netdev/20210128152353.GB27281@optiplex/
Fixes: 950fcaecd5cc ("datagram: consolidate datagram copy to iter helpers")
Reported-by: Oliver Graute <oliver.graute@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/uio.h |  8 +++++++-
 lib/iov_iter.c      | 24 ++++++++++++++----------
 net/core/datagram.c | 12 ++++++++++--
 3 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 72d88566694e..27ff8eb786dc 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -260,7 +260,13 @@ static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
 {
 	i->count = count;
 }
-size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump, struct iov_iter *i);
+
+struct csum_state {
+	__wsum csum;
+	size_t off;
+};
+
+size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csstate, struct iov_iter *i);
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index a21e6a5792c5..f0b2ccb1bb01 100644
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
+	__wsum sum = csstate->csum;
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
+	csstate->csum = sum;
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
+	sum = csstate->csum;
+	off = csstate->off;
 	if (unlikely(iov_iter_is_discard(i))) {
 		WARN_ON(1);	/* for now */
 		return 0;
@@ -1561,7 +1564,8 @@ size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump,
 		off += v.iov_len;
 	})
 	)
-	*csum = sum;
+	csstate->csum = sum;
+	csstate->off = off;
 	return bytes;
 }
 EXPORT_SYMBOL(csum_and_copy_to_iter);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 81809fa735a7..15ab9ffb27fe 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -721,8 +721,16 @@ static int skb_copy_and_csum_datagram(const struct sk_buff *skb, int offset,
 				      struct iov_iter *to, int len,
 				      __wsum *csump)
 {
-	return __skb_datagram_iter(skb, offset, to, len, true,
-			csum_and_copy_to_iter, csump);
+	struct csum_state csdata = { .csum = *csump };
+	int ret;
+
+	ret = __skb_datagram_iter(skb, offset, to, len, true,
+				  csum_and_copy_to_iter, &csdata);
+	if (ret)
+		return ret;
+
+	*csump = csdata.csum;
+	return 0;
 }
 
 /**
-- 
2.30.0.365.g02bc693789-goog

