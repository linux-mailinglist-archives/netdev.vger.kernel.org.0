Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80522CC964
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbgLBWK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387442AbgLBWK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:10:58 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4136BC061A47
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:10:18 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id r9so1810977pjl.5
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kF6MpbIz7UBtOUQRndbrPYKTjWhsAlqLLMJgGNnG7ng=;
        b=EjwrA82jdXQg+V949MNc/Y0Gn5b+TnSJxrJzewtMbt+t1BR7b/wKUG73OJtDUXtKkq
         0hSr/NKUGT51IYH3GomiPSjleFRyDbTFtt0/vIlpcZ3PU3AozGRiHg32t+4aocikeGix
         AnkBqMNeGWDXrknm7SWFCottES3t0H8bcMsBTiHBUAAFDQJWjoOTByHyjQlj7S62R5Wm
         lrN86eEkv81/mtwt8RQdjWeaLjP15I5wquoZNvzwvLuullNQ/meILSHj9PybVa7jYuH+
         iZdiUO9Z1A3DeRTEc48bd4pYuqqa2sXhWi2prwljgvYrCjVJkOqLFfSHZ60yYEO2lPul
         2HpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kF6MpbIz7UBtOUQRndbrPYKTjWhsAlqLLMJgGNnG7ng=;
        b=C6L/ZS/2ZpDaC0qeMt6uTa1VodnjbxGrJXkqmK766NR3AV2sBajw+gjWFTw1yvM6wP
         7x6+5MIxrM1u9iMy/XAuivKwIa06kFpCteSAFbMRVRQFRNeq5m1ObtEauPakyWLnMpAz
         5kuFIKkVNk9GiI9AZ+sGWnqE7iM4Qx70ujaMJfTEaWLauN8ABD2xOfeJmIiHjTt/d9d7
         lj05vqL4fM2DMjQdQDSuQyVm9dYBfEPJUt9lJV1EmDr+aDyavLLPgO9I3lGk0nuEiXrX
         lUtOkfU09KmQMsluvI/YPyT8kGQ5FrOgoL/yZ1v2cMam5h/qC7cpCkqQVL5Zbep3nYvl
         qZjg==
X-Gm-Message-State: AOAM533keJUyGjkqzTI4mhAd40733AJuFUnSs+KbK1fWWh7DCzunN8Y5
        FB1bCr5QUbAx9mxbY2VTHog=
X-Google-Smtp-Source: ABdhPJy7QGWk5pDjl71vr9ZqA5VpBcKFaiFlxnIFzHPKpWeJ9si4su71HdPl6i9FJNrL5O4vgLt0OQ==
X-Received: by 2002:a17:902:eac1:b029:da:88ce:f38f with SMTP id p1-20020a170902eac1b02900da88cef38fmr166365pld.42.1606947017829;
        Wed, 02 Dec 2020 14:10:17 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id p16sm4872pju.47.2020.12.02.14.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:10:17 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v2 3/8] net-zerocopy: Refactor skb frag fast-forward op.
Date:   Wed,  2 Dec 2020 14:09:40 -0800
Message-Id: <20201202220945.911116-4-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
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

