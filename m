Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CF52CCA08
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387704AbgLBWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387664AbgLBWzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:55:13 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E764C061A4A
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:53:58 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id q22so2179439pfk.12
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yQiqnLCbPUEkQ+y8axoTVAEf5B7uvXOGPhszzHJMS84=;
        b=DK/1gsdXjpngCVfHMBCIhFaQzBNGIlZDtIvZgsFGilg8A1tPWbyuc0gQLKP64X86vf
         ewE11ViL0m3VYGzdAGRAeotRyoV9pmI/0tC7z4Q4wBDaesOM3t/lDxqjjx4aJw/3S6fy
         wfN9YaGKYpI/mX7STyIebLCWTgF6q/n7Im6ulS4zd83bAA/JdoSF9CsnHJrzGOJw2DK1
         z3rBRHZGXh7E5vAdf4QJUuWAD7UQ+Aa0tqmB7P9OM2q8v7zR2pIc4rLXr4WDZ+XKbbgF
         +AX6vju382lMiL/Kafl/X2+1HrppBxMf5br5SWilzyIxEzLe7wax1YSgr1gcd8KYAvB2
         foMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yQiqnLCbPUEkQ+y8axoTVAEf5B7uvXOGPhszzHJMS84=;
        b=PA0GGrdTcw1pCe1hxDWEi9265ftvnx3WxEXlIW12dkewgPRwuerWTAPN2xqdgR3sST
         XoQ3DRrAg98xSJO+R7Lm7boW1rz9gN7815qJBfB6knQ+i3edwfhm9cUj7IRYPIc9eFzs
         5cpIFY0sXlCndblgp5Wrc8z/4n8TD3jtya/wUASmQcxdG9Jnuf7zCqT2aQuOxa49/Yie
         CsHdnsbdm/RStwEzRVcKJodj0VHUbWuu4kHBmRp+3p9AyvWxHEKqhf4x7fELQFf/TVcJ
         WzvSwK5yXs92feeoqI8t5K8ar1J3s+j1PHF7r7VyY8IspzXjTrcc0Lr31FSzg9AprKFm
         Cd9Q==
X-Gm-Message-State: AOAM533nzmFPnP1+n+OkpyCLCeVDh0e5GcPGRvMTLVPCuqMFz/w7K9Fg
        xGYoO4DlZ1LJmErxy425vIolkqGhyac=
X-Google-Smtp-Source: ABdhPJwYy/V9KTa18sy7KHZjP8E7xoIlO+8wjccAwDJ/mWP8ZxSfxE8VJqMyheLpyYPK0dUMmNHd4A==
X-Received: by 2002:aa7:982e:0:b029:18b:6372:d445 with SMTP id q14-20020aa7982e0000b029018b6372d445mr186709pfl.31.1606949637692;
        Wed, 02 Dec 2020 14:53:57 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id i3sm39962pjs.34.2020.12.02.14.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:53:57 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v3 4/8] net-zerocopy: Refactor frag-is-remappable test.
Date:   Wed,  2 Dec 2020 14:53:45 -0800
Message-Id: <20201202225349.935284-5-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
References: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
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

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

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

