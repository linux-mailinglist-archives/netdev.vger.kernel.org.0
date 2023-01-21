Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED467663F
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 13:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjAUMmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 07:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjAUMmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 07:42:10 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F375D30194
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 04:42:08 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id qx13so20093560ejb.13
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 04:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zc0FC7NkEM/67KsxUI/D/IwurehJDeU/inVJuiDa5c4=;
        b=wztFXIzWKmfAYgOITSnMSCDzzDnQeT81wORwMoKti1yaZtjU0jq3EvM4EkOvhW1P5q
         lIlXvNRyweQsA5zuxfIbIkI3qB3i2LIJnHvDNaMnVaQehu6D9GVxt5LNb4CQL4mC6HV6
         NOt+0TW8aq92W1EQxViWcu36/TfmE+oRZrIpo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zc0FC7NkEM/67KsxUI/D/IwurehJDeU/inVJuiDa5c4=;
        b=irCv5n960n+zwByJhTXox44mFx9jFxsXr6GpzH5JSa011y1260oqjwha89JTKQR3nD
         HrRnJX9VmG32WF8McaRdnzwCr1XHWpyAEeHsh/9nMPyVhssPW2CX5+RaH24WCo95cuUy
         Yve3JBio1y5MSLAtyO8xx4bGqHZm5kxi5Or9ZJqQZg85HtI/tiu8a/edi8Yvy9Jqq65C
         MvdVVfCsx9EmlUI3NyDxVZVh7N4rQGugFsH62yCfleF0vs/cOYojIUWEJ03FUGJgkpr/
         7/E8cjxqoV7xIKUygdbkWU0LFodmmGD9CWjdigfZNgsldOjw7fQGZaQf59BoWpnuc+gn
         ersQ==
X-Gm-Message-State: AFqh2kpHevU71ieQ5DG2+mD9+c+UCKpJnY8uhZxth7Ydq02tekDoviWY
        7WWdjkLamBi4Bu3oZeYVI9E+ow==
X-Google-Smtp-Source: AMrXdXvkf9hgcoQ9e84pUi6+pGLkVzoExVOBKTrJznonCPRqXbB2u6CLS6SwVhwh1Aa8gBw+fHPMGg==
X-Received: by 2002:a17:907:d492:b0:7aa:491c:6cdf with SMTP id vj18-20020a170907d49200b007aa491c6cdfmr16502495ejc.18.1674304928556;
        Sat, 21 Jan 2023 04:42:08 -0800 (PST)
Received: from cloudflare.com (79.191.179.97.ipv4.supernova.orange.pl. [79.191.179.97])
        by smtp.gmail.com with ESMTPSA id lh2-20020a170906f8c200b00877696c015asm4541586ejb.134.2023.01.21.04.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 04:42:07 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Sat, 21 Jan 2023 13:41:44 +0100
Subject: [PATCH bpf v2 2/4] bpf, sockmap: Check for any of tcp_bpf_prots
 when cloning a listener
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230113-sockmap-fix-v2-2-1e0ee7ac2f90@cloudflare.com>
References: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
In-Reply-To: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com,
        syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
 include/linux/util_macros.h | 12 ++++++++++++
 net/ipv4/tcp_bpf.c          |  4 ++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/util_macros.h b/include/linux/util_macros.h
index 72299f261b25..43db6e47503c 100644
--- a/include/linux/util_macros.h
+++ b/include/linux/util_macros.h
@@ -38,4 +38,16 @@
  */
 #define find_closest_descending(x, a, as) __find_closest(x, a, as, >=)
 
+/**
+ * is_insidevar - check if the @ptr points inside the @var memory range.
+ * @ptr:	the pointer to a memory address.
+ * @var:	the variable which address and size identify the memory range.
+ *
+ * Evaluates to true if the address in @ptr lies within the memory
+ * range allocated to @var.
+ */
+#define is_insidevar(ptr, var)						\
+	((uintptr_t)(ptr) >= (uintptr_t)(var) &&			\
+	 (uintptr_t)(ptr) <  (uintptr_t)(var) + sizeof(var))
+
 #endif
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 94aad3870c5f..cf26d65ca389 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -6,6 +6,7 @@
 #include <linux/bpf.h>
 #include <linux/init.h>
 #include <linux/wait.h>
+#include <linux/util_macros.h>
 
 #include <net/inet_common.h>
 #include <net/tls.h>
@@ -639,10 +640,9 @@ EXPORT_SYMBOL_GPL(tcp_bpf_update_proto);
  */
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 {
-	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	struct proto *prot = newsk->sk_prot;
 
-	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
+	if (is_insidevar(prot, tcp_bpf_prots))
 		newsk->sk_prot = sk->sk_prot_creator;
 }
 #endif /* CONFIG_BPF_SYSCALL */

-- 
2.39.0

