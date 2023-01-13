Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382C7669B5B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 16:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjAMPF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 10:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjAMPE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:04:56 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249C1820EA
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:56:29 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id fy8so52786452ejc.13
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tRg0fZfB0/F86fleBj0vJva1BOW0i0hgLuZy9INDlfg=;
        b=tkkrMh3cG4RUa1ibeKgrgxz8pa11m50Hm4gkN9LA/6MW45rjqgNLvHu75ug3xxV/Sq
         D3VCgVNolpquW4Mf7fbVuTjT4LgS36rQei9cWPb2NG5BINUqjfBq4StPEL+EawIaHUUN
         VbbU9Dschyomy2I0E6beP6UOHR1WODg3gYpAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tRg0fZfB0/F86fleBj0vJva1BOW0i0hgLuZy9INDlfg=;
        b=i+/ahMNn0nJ0/HK/pWpa5IAGChvBXHgReVIh++pfDFps20i0fruhjpt+JV6XoqY38p
         S1xgANgCbHGa59Eb7zXmEfD0cB+7tg5JK+IytNJMQJXDsiOIG4jd7OwaZ5a/N/CB3kU5
         R2sU5kwxDYcNr7lnJ0bhd/ARNfUSOPPhBwn5gozzeqYgF+blcSildmY59BVDMhNqsP65
         prQfMEnRFpFty39++BYJnKZ5Ym5g/iSbFB5JiFuf+8ZVq4O/rzld4eY3s5xd1SjkL/1g
         D+vfl8fm7pU6kYNV3voINsak1Gz3a3XfNsFeSR7P1YaH+Tm4FEncivXze/S2n2cszEnB
         S3GQ==
X-Gm-Message-State: AFqh2krnrSZojSsuwFFpQU0hG1Ugk/l+7AWbGAx7X+Mei/yCJaCq0Fx3
        M5YGfEBObPsvPUr/4EMy2611woKdG4ftn27O
X-Google-Smtp-Source: AMrXdXs8nUXnBEY/5CTr0aMxhZirAu0Zwvx+D8i0tlqIe3k6BW++Iiue2r5k5hQFe1G9b3W06IjT3g==
X-Received: by 2002:a17:906:6dcb:b0:7c0:d60b:2887 with SMTP id j11-20020a1709066dcb00b007c0d60b2887mr69713458ejt.69.1673621787334;
        Fri, 13 Jan 2023 06:56:27 -0800 (PST)
Received: from cloudflare.com (79.184.151.107.ipv4.supernova.orange.pl. [79.184.151.107])
        by smtp.gmail.com with ESMTPSA id mb9-20020a170906eb0900b0084d34eec68esm7622474ejb.213.2023.01.13.06.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 06:56:26 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
Subject: [PATCH bpf 1/3] bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener
Date:   Fri, 13 Jan 2023 15:56:21 +0100
Message-Id: <20230113-sockmap-fix-v1-1-d3cad092ee10@cloudflare.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113-sockmap-fix-v1-0-d3cad092ee10@cloudflare.com>
References: <20230113-sockmap-fix-v1-0-d3cad092ee10@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A listening socket linked to a sockmap has its sk_prot overridden. It
points to one of the struct proto variants in tcp_bpf_prots. The variant
depends on the socket's family and which sockmap programs are attached.

A child socket cloned from a TCP listener initially inherits their sk_prot.
But before cloning is finished, we restore the child's proto to the
listener's original non-tcp_bpf_prots one. This happens in
tcp_create_openreq_child -> tcp_bpf_clone.

Today, in tcp_bpf_clone we detect if the child's proto should be restored
by checking only for the TCP_BPF_BASE proto variant. This is not
correct. The sk_prot of listening socket linked to a sockmap can point to
to any variant in tcp_bpf_prots.

If the listeners sk_prot happens to be not the TCP_BPF_BASE variant, then
the child socket unintentionally is left if the inherited sk_prot by
tcp_bpf_clone.

This leads to issues like infinite recursion on close [1], because the
child state is otherwise not set up for use with tcp_bpf_prot operations.

Adjust the check in tcp_bpf_clone to detect all of tcp_bpf_prots variants.

Note that it wouldn't be sufficient to check the socket state when
overriding the sk_prot in tcp_bpf_update_proto in order to always use the
TCP_BPF_BASE variant for listening sockets. Since commit
b8b8315e39ff ("bpf, sockmap: Remove unhash handler for BPF sockmap usage")
it is possible for a socket to transition to TCP_LISTEN state while already
linked to a sockmap, e.g. connect() -> insert into map ->
connect(AF_UNSPEC) -> listen().

[1]: https://lore.kernel.org/all/00000000000073b14905ef2e7401@google.com/

Fixes: e80251555f0b ("tcp_bpf: Don't let child socket inherit parent protocol ops on copy")
Reported-by: syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv4/tcp_bpf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 94aad3870c5f..8db00647e0a4 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -639,10 +639,9 @@ EXPORT_SYMBOL_GPL(tcp_bpf_update_proto);
  */
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 {
-	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	struct proto *prot = newsk->sk_prot;
 
-	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
+	if (tcp_bpf_prots[0] <= prot && prot < tcp_bpf_prots[ARRAY_SIZE(tcp_bpf_prots)])
 		newsk->sk_prot = sk->sk_prot_creator;
 }
 #endif /* CONFIG_BPF_SYSCALL */

-- 
2.39.0
