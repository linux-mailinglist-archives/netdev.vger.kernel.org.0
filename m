Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833EC136B57
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgAJKul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:50:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43325 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgAJKuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:50:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id d16so1325381wre.10
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 02:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x/PpG3/qK5hQR6KN+p/37WA4pTFpmd2R9d2LRqSHtZk=;
        b=XJBfsBdhVipFtWgm1WkSXSL9WdfaT807exLmP8idg9/ejh936CptxtA3uVXnh9zKxA
         1FsPripCK9a+bYOvWK0reZ7Q6DHtpcpKcvMjKwTfaY3vHR3TlRI8ra2Z3ydgHFvRH3AA
         4yQnDJIscVd35OM/vYsg0aEieBMYbMD/Qw/rA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x/PpG3/qK5hQR6KN+p/37WA4pTFpmd2R9d2LRqSHtZk=;
        b=Ic8HunARENXz6V0B9gdgG2YfzTvWW3825oRJr6T5M1iZiHkwOTw8LLFJ2h0whCGt/1
         Ito7Qv/rBTez9ghm9dylFNhTOsmM7nsh8pwER4JXlHXT3jvB5oyOgi0Z2O4uGC9aF3z1
         AIQRB1Yr6ekL1TxF5Gs7hgUvkJBShYV55/OKIeQlMUebIRj/ORYOSbJ1dD0jFuweMbsW
         zhD6Tfv5hngMCSbl7VzSmrXW7OZNCVjeMcjTtNBWRZJDOinB96FnzGBY9S5dsYv4s1WH
         rxKL50eU6TVJBWaDwpTFeR/9Nozdi1KwAkg+I0E1yxJerDN+efCH5xKVa6V7ZkmB6i3l
         nr2w==
X-Gm-Message-State: APjAAAXAHTu/tawYLSeN7ItJPE3HoMnLKAluYKO+aQ+XV8XzopeMVJz+
        wFeYZWr5qff/qk+r+g/dM8HlIw==
X-Google-Smtp-Source: APXvYqwzgmXFAsPY2sRnLEcHD5sBCE3vayVrqcx4xFvfcNz0X94qZHJHfzk49wOWznaZrYdtInSzxg==
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr2814160wrr.98.1578653437659;
        Fri, 10 Jan 2020 02:50:37 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id f1sm1821145wmc.45.2020.01.10.02.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 02:50:37 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 06/11] bpf, sockmap: Don't set up sockmap progs for listening sockets
Date:   Fri, 10 Jan 2020 11:50:22 +0100
Message-Id: <20200110105027.257877-7-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110105027.257877-1-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that sockmap can hold listening sockets, when setting up the psock we
will (i) grab references to verdict/parser progs, and (2) override socket
upcalls sk_data_ready and sk_write_space.

We cannot redirect to listening sockets so we don't need to link the socket
to the BPF progs, but more importantly we don't want the listening socket
to have overridden upcalls because they would get inherited by child
sockets cloned from it.

Introduce a separate initialization path for listening sockets that does
not change the upcalls and ignores the BPF progs.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 99daea502508..d1a91e41ff82 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -228,6 +228,30 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	return ret;
 }
 
+static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
+{
+	struct sk_psock *psock;
+	int ret;
+
+	psock = sk_psock_get_checked(sk);
+	if (IS_ERR(psock))
+		return PTR_ERR(psock);
+
+	if (psock) {
+		tcp_bpf_reinit(sk);
+		return 0;
+	}
+
+	psock = sk_psock_init(sk, map->numa_node);
+	if (!psock)
+		return -ENOMEM;
+
+	ret = tcp_bpf_init(sk);
+	if (ret < 0)
+		sk_psock_put(sk, psock);
+	return ret;
+}
+
 static void sock_map_free(struct bpf_map *map)
 {
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
@@ -352,7 +376,15 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 	if (!link)
 		return -ENOMEM;
 
-	ret = sock_map_link(map, &stab->progs, sk);
+	/* Only established or almost established sockets leaving
+	 * SYN_RECV state need to hold refs to parser/verdict progs
+	 * and have their sk_data_ready and sk_write_space callbacks
+	 * overridden.
+	 */
+	if (sk->sk_state == TCP_LISTEN)
+		ret = sock_map_link_no_progs(map, sk);
+	else
+		ret = sock_map_link(map, &stab->progs, sk);
 	if (ret < 0)
 		goto out_free;
 
-- 
2.24.1

