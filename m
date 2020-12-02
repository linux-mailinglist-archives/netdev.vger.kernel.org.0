Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BD42CC965
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbgLBWLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387442AbgLBWLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:11:00 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FE4C061A48
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:10:19 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 4so1908563plk.5
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fx2J5kxkuy4RVQPdcQdvLIdfLQ1KmMIrt6Uak2OdX1I=;
        b=tZKIvjrSiwk2uFDis4sT08WCbufr0qyAwYTvUDg2a1MrjCtV/fmJ5/T8+sZeKg9D2N
         wJt+goPhJ113l0Fc3b+bMSWWKjMPk+WhmrAs2x9OuSt8SaSDlrfDY+6bhBmDAn2Iqljp
         +YIgHu+t69lJZPdcUjBFMqxsTF55uxqLHm6eqBGFvFbdgl82qI/jx/meEnEhM7Tk3wnD
         Su4/VypluEGAs/q2QZtRV0Uq1r4nGFGFdEFOAbzcPCwlXGbWQANIA4AiYHaGlz6QZjL5
         vutp5wdVtQz459iI6e5yBRUmKKh7ChQj7BYG/tOAswb34eYxXcFhXNDE1r7OFRlUlT7J
         F4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fx2J5kxkuy4RVQPdcQdvLIdfLQ1KmMIrt6Uak2OdX1I=;
        b=Qjy1AoPjm2CwKOi9h8iPMWsc9G91loF/UqIXOGQwH9Z8XAEI4NjNDvlNR/lgwPvIg3
         7Gj9qZaHq5j+0sLwOA7fFj+JGLKXHQjBO4NZ9cd09dGUuSgBp8vQ/NdXNnMuwF85vQdN
         3WtNQVqVlO39TGSAceDXI2Eaimyr9jdC5NqothoswWsbjP98eFP69JuqVJPWb2T6bUEP
         wHTwjUN2PW8Sz3Z99Zz7GzzxEUl8WLT9HcK5Li7UUNGeVijdVl1nH1ryUEaRj3+mGjDJ
         Tt6YkM2qoyuV9/vQIa3teI5eEXmWb9gUR/dWs28aEaOjn32kUxEnsMbXb2uWcisrIk3G
         rmHg==
X-Gm-Message-State: AOAM533LWNY22u5M0qnJl/WrQhB0NWb+9oIftylMdVN0rtgQ9SZETpc+
        2wN+bXuC0ZaV06LSbJnTBOY=
X-Google-Smtp-Source: ABdhPJw8knJBUKQ77DVvtCVmi2KSPYSuNH8GezOkQPNpENzO/6valQjY2xeJsZu62ZDOPXyS9QBOuw==
X-Received: by 2002:a17:90a:fa8e:: with SMTP id cu14mr78855pjb.140.1606947019294;
        Wed, 02 Dec 2020 14:10:19 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id p16sm4872pju.47.2020.12.02.14.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:10:18 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v2 4/8] net-zerocopy: Refactor frag-is-remappable test.
Date:   Wed,  2 Dec 2020 14:09:41 -0800
Message-Id: <20201202220945.911116-5-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Refactor frag-is-remappable test for tcp receive zerocopy. This is
part of a patch set that introduces short-circuited hybrid copies
for small receive operations, which results in roughly 33% fewer
syscalls for small RPC scenarios.
---
 net/ipv4/tcp.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0f17b46c4c0c..4bdd4a358588 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1765,6 +1765,26 @@ static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
 	return frag;
 }
 
+static bool can_map_frag(const skb_frag_t *frag)
+{
+	return skb_frag_size(frag) == PAGE_SIZE && !skb_frag_off(frag);
+}
+
+static int find_next_mappable_frag(const skb_frag_t *frag,
+				   int remaining_in_skb)
+{
+	int offset = 0;
+
+	if (likely(can_map_frag(frag)))
+		return 0;
+
+	while (offset < remaining_in_skb && !can_map_frag(frag)) {
+		offset += skb_frag_size(frag);
+		++frag;
+	}
+	return offset;
+}
+
 static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
 				   struct sk_buff *skb, u32 copylen,
 				   u32 *offset, u32 *seq)
@@ -1890,6 +1910,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	ret = 0;
 	curr_addr = address;
 	while (length + PAGE_SIZE <= zc->length) {
+		int mappable_offset;
+
 		if (zc->recv_skip_hint < PAGE_SIZE) {
 			u32 offset_frag;
 
@@ -1917,15 +1939,11 @@ static int tcp_zerocopy_receive(struct sock *sk,
 			if (!frags || offset_frag)
 				break;
 		}
-		if (skb_frag_size(frags) != PAGE_SIZE || skb_frag_off(frags)) {
-			int remaining = zc->recv_skip_hint;
 
-			while (remaining && (skb_frag_size(frags) != PAGE_SIZE ||
-					     skb_frag_off(frags))) {
-				remaining -= skb_frag_size(frags);
-				frags++;
-			}
-			zc->recv_skip_hint -= remaining;
+		mappable_offset = find_next_mappable_frag(frags,
+							  zc->recv_skip_hint);
+		if (mappable_offset) {
+			zc->recv_skip_hint = mappable_offset;
 			break;
 		}
 		pages[pg_idx] = skb_frag_page(frags);
-- 
2.29.2.576.ga3fc446d84-goog

