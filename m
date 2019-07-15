Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9815569D17
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732732AbfGOUtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:49:52 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36521 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732649AbfGOUtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:49:51 -0400
Received: by mail-oi1-f193.google.com with SMTP id w7so13769180oic.3;
        Mon, 15 Jul 2019 13:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=lV8etYsEZTqwvPfp5XBIG2UlKxfnHXO0yLVdtiun7Hk=;
        b=A6oDPw/P5DaD/KV31i8qd/1mEavsEstipFzcCzGzu0sJzWuXKw9nPZTkZJDsuFTI+K
         +Yw2K0GpcCzHYgMRjwGcoDYWU9oAFF6a7qP8EAjxZIAXCnR2arpXjDQAoCnRoglxzc3j
         sw7Vnf1P824ybfZ5D2g2iICbhzzo68Z9LkGklGI9MgQw0L+NZmLfcbzSHdXw1KbgcQxK
         o7WIaXJhasJQ0VlDwLgRTh9Y143AUZr7uqLC69N61xyfS1uThf5Mg5jKnRz1cVUOOfV6
         WNStly7n4k7poRNf4+tvfVgiY9vOmnx+pw56590ewW+uDndaHlWcOWpsfgpORRY6I40G
         S13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lV8etYsEZTqwvPfp5XBIG2UlKxfnHXO0yLVdtiun7Hk=;
        b=Thbjje2yXFUrwwZCJgUr/lXjRs3zzxjXxV/aucCV19kytbDgnWHWbNusYGPiYXd2Ge
         KkNgZ9mFBmEqhtOHbWb88pKDzrGPXs3Fn6Smn45ek382Z1GMsIUDcGgigWvL+Mpc7v5L
         dztqsjG+4U+Jx5eM0OHhls1jzjBK/S2KOABaUfgTO/Xws6Cemmc8nDrBxPHdP+2DTRt8
         q8bNQfBtRd0Hw005KjUsYI/PSFXa0Xa4ap3en+RlVYycoMz8J+QyQZcYsr5DrmA5tLq1
         G1n2HDVK1rWpeg8I/On8sioj52xsT5sjng8vvQIsca7a4lmZ96c6SPigxWTLGeS2HMX5
         BBBw==
X-Gm-Message-State: APjAAAUEvQhQGPZy/FH+mbfPZkj4CnEYFj5OmXfrfQvpENpNdbt8VEOv
        3T9Eds3YPeu7+opXmGgXvLA=
X-Google-Smtp-Source: APXvYqxreGOSOOAh7PHOq4M2LAgBr8ThKgY4J1T50izt/wa85YyiyU5U5VZALXG9S7ZTevrr/3Bq3g==
X-Received: by 2002:a05:6808:293:: with SMTP id z19mr14235591oic.13.1563223790790;
        Mon, 15 Jul 2019 13:49:50 -0700 (PDT)
Received: from [127.0.1.1] ([99.0.85.34])
        by smtp.gmail.com with ESMTPSA id i11sm6506126oia.9.2019.07.15.13.49.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:49:50 -0700 (PDT)
Subject: [bpf PATCH v3 7/8] bpf: sockmap,
 only create entry if ulp is not already enabled
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 15 Jul 2019 13:49:49 -0700
Message-ID: <156322378927.18678.10640333359699805145.stgit@john-XPS-13-9370>
In-Reply-To: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
References: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sockmap does not currently support adding sockets after TLS has been
enabled. There never was a real use case for this so it was never
added. But, we lost the test for ULP at some point so add it here
and fail the socket insert if TLS is enabled. Future work could
make sockmap support this use case but fixup the bug here.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 56bcabe7c2f2..1330a7442e5b 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -334,6 +334,7 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 				  struct sock *sk, u64 flags)
 {
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct sk_psock_link *link;
 	struct sk_psock *psock;
 	struct sock *osk;
@@ -344,6 +345,8 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 		return -EINVAL;
 	if (unlikely(idx >= map->max_entries))
 		return -E2BIG;
+	if (unlikely(icsk->icsk_ulp_data))
+		return -EINVAL;
 
 	link = sk_psock_init_link();
 	if (!link)

