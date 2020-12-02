Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5934E2CCA07
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbgLBWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387566AbgLBWzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:55:13 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26225C061A49
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:53:57 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id f17so186582pge.6
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wTsfUYOdoYiwZAtLhjpPjaSfgXXTJRBYDbKCj7wu+aw=;
        b=gRp5A5RHz5soLefsXQo1EGY8nC0E2zz1Lk+u71qGYLppeSCFWTdt8zyp/X+EXX2DPB
         1F/o4ybBVkmAAI5NwzVDmo852gOG7fDgU2NPIMzBhPExI2wq6GfBjOL40yy4iaLD0Dar
         JyL6OKMfwnJdcoBAIGXMNI51EYT7YQWH0jtmYo54ua+ZZuPZIWK9JunxPsOOcPC/1KQs
         n+odIB3i7Wd99VQsYD3uk+IY9R0tH6f2bnJz1prWFxURmWkdrzCShnlEIGe+tzWrFPM7
         XBA8+THLm6fxVfF/Zjqo7isy4YWvefhav0F+xeb4pOqQKlHVadAfZ1UNRkwpUFsWL3Zt
         DdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wTsfUYOdoYiwZAtLhjpPjaSfgXXTJRBYDbKCj7wu+aw=;
        b=KtfoHCH0iaMUNyHZIA1dvxxCNsL1ZT3YGpxqY/0yjeTiTwEDT9q/dATkvTirT835zz
         7SajCAqjUxWPSmY4owBQm6LiatHevTmne/JreMq4oqOrRGWLIdlSIXsY8nsnzZqQlluY
         8/q3QujlUAbEVk++tqq1RY8cFDYB1/VCK59D8F62NuodMzWlrdiL9jKfB41ca77Hii7Q
         lmer5zSNtNsLfXuWhYg4hA1ZpZk68tpsG7N9/1xbDc8U810cQNrf+LgUFEJtv9pHP1k4
         /RhjPHCZmh0LxyN9JnrJdcz9phlYEAyWhp0sERq6CcCTy7Fz6m2Prb8Jj0aDuQL5a8b/
         R5Tg==
X-Gm-Message-State: AOAM530hs82llFQWMPIxf5l1CvKyqE/O8n5ILfDKYl4GsofPT3vUZyKG
        5D1LbWRDHFz/9toZ55eewMg=
X-Google-Smtp-Source: ABdhPJyYu2uSXVFd1Ttqn6/ia+IDVRAMbbj0H3UQmZ3uJcmE5FTRbPWQJr9m4jU74UkfFjaKvCWX8g==
X-Received: by 2002:a63:f652:: with SMTP id u18mr459535pgj.240.1606949636722;
        Wed, 02 Dec 2020 14:53:56 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id i3sm39962pjs.34.2020.12.02.14.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:53:56 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v3 3/8] net-zerocopy: Refactor skb frag fast-forward op.
Date:   Wed,  2 Dec 2020 14:53:44 -0800
Message-Id: <20201202225349.935284-4-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
References: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Refactor skb frag fast-forwarding for tcp receive zerocopy. This is
part of a patch set that introduces short-circuited hybrid copies
for small receive operations, which results in roughly 33% fewer
syscalls for small RPC scenarios.

skb_advance_to_frag(), given a skb and an offset into the skb,
iterates from the first frag for the skb until we're at the frag
specified by the offset. Assuming the offset provided refers to how
many bytes in the skb are already read, the returned frag points to
the next frag we may read from, while offset_frag is set to the number
of bytes from this frag that we have already read.

If frag is not null and offset_frag is equal to 0, then we may be able
to map this frag's page into the process address space with
vm_insert_page(). However, if offset_frag is not equal to 0, then we
cannot do so.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 net/ipv4/tcp.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 232cb478bacd..0f17b46c4c0c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1743,6 +1743,28 @@ int tcp_mmap(struct file *file, struct socket *sock,
 }
 EXPORT_SYMBOL(tcp_mmap);
 
+static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
+				       u32 *offset_frag)
+{
+	skb_frag_t *frag;
+
+	offset_skb -= skb_headlen(skb);
+	if ((int)offset_skb < 0 || skb_has_frag_list(skb))
+		return NULL;
+
+	frag = skb_shinfo(skb)->frags;
+	while (offset_skb) {
+		if (skb_frag_size(frag) > offset_skb) {
+			*offset_frag = offset_skb;
+			return frag;
+		}
+		offset_skb -= skb_frag_size(frag);
+		++frag;
+	}
+	*offset_frag = 0;
+	return frag;
+}
+
 static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
 				   struct sk_buff *skb, u32 copylen,
 				   u32 *offset, u32 *seq)
@@ -1869,6 +1891,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	curr_addr = address;
 	while (length + PAGE_SIZE <= zc->length) {
 		if (zc->recv_skip_hint < PAGE_SIZE) {
+			u32 offset_frag;
+
 			/* If we're here, finish the current batch. */
 			if (pg_idx) {
 				ret = tcp_zerocopy_vm_insert_batch(vma, pages,
@@ -1889,16 +1913,9 @@ static int tcp_zerocopy_receive(struct sock *sk,
 				skb = tcp_recv_skb(sk, seq, &offset);
 			}
 			zc->recv_skip_hint = skb->len - offset;
-			offset -= skb_headlen(skb);
-			if ((int)offset < 0 || skb_has_frag_list(skb))
+			frags = skb_advance_to_frag(skb, offset, &offset_frag);
+			if (!frags || offset_frag)
 				break;
-			frags = skb_shinfo(skb)->frags;
-			while (offset) {
-				if (skb_frag_size(frags) > offset)
-					goto out;
-				offset -= skb_frag_size(frags);
-				frags++;
-			}
 		}
 		if (skb_frag_size(frags) != PAGE_SIZE || skb_frag_off(frags)) {
 			int remaining = zc->recv_skip_hint;
-- 
2.29.2.576.ga3fc446d84-goog

