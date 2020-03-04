Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E21178E37
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbgCDKOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:14:25 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46514 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387816AbgCDKNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:13:49 -0500
Received: by mail-lj1-f195.google.com with SMTP id h18so1318063ljl.13
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 02:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=37n9ID/jQISQUdmUM2Xy9nSmU2zdBjkBqvMddVrEaU0=;
        b=JYPrHolptd1n2nSDReTgh2qB3EIJhFPcT8U2rWu0VGMz4ZfOXORHYPLWXVMzA2hkhv
         8i5RXCTGg8rYBAYowpL0n60igO49EEIw2yd8naNh3dsGnw1G6eg68anezW6ztoYc/W6J
         3CD+fjvY3YO9JCmls4GuxCUQrUdCuSmwfDHjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37n9ID/jQISQUdmUM2Xy9nSmU2zdBjkBqvMddVrEaU0=;
        b=DtQEPRTnCDSmY4eJoCSxgsooijFhXyvdR5bmCPzuKV1zELeoLOaFWLAtWWVyef0Rft
         bSUH1jw3s/4Pw5s4LhecNBMO1GG6ceiKHvxVz6lxlU6sNMOpY0fLA4H7Z0vWQFZ+C7CU
         4cmVoVuWbdtqFYVxJVmpLiFu7peZs2mozauX4LNA5aQakoYLnywFDXoeOl3myQ+9xnmt
         RHk3aEt2zMW9mhzi0kt/4sbw4EyrKxveU00bz4YS2a4LTZ0jmwo7RQz8oqBpH02sVFOS
         1xhyApLdqMTpjOJfAiBNXzezdHlZX4N7pAQA7EZgE/w4+xayppt+E4NYzAPZpn/IZdmL
         lowQ==
X-Gm-Message-State: ANhLgQ2rRnZRAdmITxUF4WjdK0Cg4Kud7S+OdIfDjc4lbFQhC1kckccG
        B0ipmvRTs8w7tyk+Ep+BzyJm1A==
X-Google-Smtp-Source: ADFU+vvdRHJXk5KTON2lz3bzzhYKfTKoWcnjztS1Xi8SaNMzHXlSTQRuZRQFj4iNxNcGreu2af+oMw==
X-Received: by 2002:a2e:8884:: with SMTP id k4mr1535745lji.59.1583316826417;
        Wed, 04 Mar 2020 02:13:46 -0800 (PST)
Received: from localhost.localdomain ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id l7sm341777lfk.65.2020.03.04.02.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 02:13:45 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 06/12] bpf: sockmap: simplify sock_map_init_proto
Date:   Wed,  4 Mar 2020 11:13:11 +0100
Message-Id: <20200304101318.5225-7-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304101318.5225-1-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can take advantage of the fact that both callers of
sock_map_init_proto are holding a RCU read lock, and
have verified that psock is valid.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 net/core/sock_map.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 9898294e119d..83c5082cefd3 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -141,28 +141,17 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
 	}
 }
 
-static int sock_map_init_proto(struct sock *sk)
+static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
 {
-	struct sk_psock *psock;
 	struct proto *prot;
 
 	sock_owned_by_me(sk);
 
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (unlikely(!psock)) {
-		rcu_read_unlock();
-		return -EINVAL;
-	}
-
 	prot = tcp_bpf_get_proto(sk, psock);
-	if (IS_ERR(prot)) {
-		rcu_read_unlock();
+	if (IS_ERR(prot))
 		return PTR_ERR(prot);
-	}
 
 	sk_psock_update_proto(sk, psock, prot);
-	rcu_read_unlock();
 	return 0;
 }
 
@@ -241,7 +230,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	if (msg_parser)
 		psock_set_prog(&psock->progs.msg_parser, msg_parser);
 
-	ret = sock_map_init_proto(sk);
+	ret = sock_map_init_proto(sk, psock);
 	if (ret < 0)
 		goto out_drop;
 
@@ -286,7 +275,7 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
 	if (!psock)
 		return -ENOMEM;
 
-	ret = sock_map_init_proto(sk);
+	ret = sock_map_init_proto(sk, psock);
 	if (ret < 0)
 		sk_psock_put(sk, psock);
 	return ret;
-- 
2.20.1

