Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C0717143D
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 10:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgB0JkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 04:40:22 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46907 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbgB0JkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 04:40:22 -0500
Received: by mail-lf1-f66.google.com with SMTP id v6so1543636lfo.13
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 01:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=l/D5jluT5xqNHQU1vo/noAgoHY8QhTggTRdGJ80ZzPU=;
        b=xFWzua6cmk6gOZySAdIdtZlgoVzhe8yn2DlA4EVHZLBYy68MTLIs/SRD76062QZmFP
         PVoXvHnnaDi93/VPYpf9cQEn/edTXf/7ZLoPu7V5aojiQ9jrhOKdiKaPtQg3fP1HxCeM
         sL6Muuq7JKQ3ualVpGEI/4ZeUeRlxwO+VlZJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=l/D5jluT5xqNHQU1vo/noAgoHY8QhTggTRdGJ80ZzPU=;
        b=izOOVBUpVMCqM8Ab5cOKdejFkw09C5zfaI1OZzhse+kWVIZCz4r/nhtPZGsCBEBao3
         Tedr7baJpPDFY888O1phr6ZoacDk4HK3kWNIEeIKvHpaYWVOPxe+xpuHFDCRdGSfyUcm
         QwrXl9BssIszRMGv0+dxGKh8HJSfWaHlkmHu3/CZtnsnVXLusS8TK6lkA0uyCj5Btk3E
         ZQaNTprjHv6RrqqcG04SSVQybNkJGdrKaDcxb01GcM21nyKIv23ZN89ypZmngfMdXgJ5
         wkFplF/JrPcuJKATatNiNDcFqDtEiKpBzN8vtkvyieOjGJeqY29pFKR9X+xusoRJt+6w
         r73Q==
X-Gm-Message-State: ANhLgQ1Rg8sfVBPPUoce38xoDopXoGEuTuC1w9xX02SLpOSUxwigTGZm
        4V4Os+XinM+14oA/+jvShnL/LA==
X-Google-Smtp-Source: ADFU+vuUnNQ4/Xgq1ilcmSCp1otOPEeGuI4iCPph36H7xl9iHlRyhFrWUJxaSH6VP2+djCzwVRttmw==
X-Received: by 2002:ac2:50c7:: with SMTP id h7mr1730259lfm.101.1582796419232;
        Thu, 27 Feb 2020 01:40:19 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n132sm2918985lfd.81.2020.02.27.01.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 01:40:18 -0800 (PST)
References: <20200225135636.5768-1-lmb@cloudflare.com> <20200225135636.5768-4-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 3/7] skmsg: introduce sk_psock_hooks
In-reply-to: <20200225135636.5768-4-lmb@cloudflare.com>
Date:   Thu, 27 Feb 2020 10:40:17 +0100
Message-ID: <878skocqri.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 02:56 PM CET, Lorenz Bauer wrote:
> The sockmap works by overriding some of the callbacks in sk->sk_prot, while
> leaving others untouched. This means that we need access to the struct proto
> for any protocol we want to support. For IPv4 this is trivial, since both
> TCP and UDP are always compiled in. IPv6 may be disabled or compiled as a
> module, so the existing TCP sockmap hooks use some trickery to lazily
> initialize the modified struct proto for TCPv6.
>
> Pull this logic into a standalone struct sk_psock_hooks, so that it can be
> re-used by UDP sockmap.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

I've been looking at how to simplify this a bit. One thing that seems
like an easy win is to fold sk_psock_hooks_init into its callers. Then
we can go back to using spinlock initializer macros. Patch below.

This highlights some inconsistency in naming instances of
sk_psock_hooks, that is tcp_bpf_hooks vs udp_psock_proto.

---
 include/linux/skmsg.h | 7 -------
 net/ipv4/tcp_bpf.c    | 3 ++-
 net/ipv4/udp_bpf.c    | 3 ++-
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 174c76c725fb..4566724dc0c9 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -425,13 +425,6 @@ static inline void psock_progs_drop(struct sk_psock_progs *progs)
 	psock_set_prog(&progs->skb_verdict, NULL);
 }

-static inline int sk_psock_hooks_init(struct sk_psock_hooks *hooks,
-				       struct proto *ipv4_base)
-{
-	spin_lock_init(&hooks->ipv6_lock);
-	return hooks->rebuild_proto(hooks->ipv4, ipv4_base);
-}
-
 int sk_psock_hooks_install(struct sk_psock_hooks *hooks, struct sock *sk);

 #endif /* _LINUX_SKMSG_H */
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index fa7e474b981b..5cb9a0724cf6 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -570,13 +570,14 @@ static struct proto tcp_bpf_ipv6[TCP_BPF_NUM_CFGS];
 static struct sk_psock_hooks tcp_bpf_hooks __read_mostly = {
 	.ipv4 = &tcp_bpf_ipv4[0],
 	.ipv6 = &tcp_bpf_ipv6[0],
+	.ipv6_lock = __SPIN_LOCK_UNLOCKED(tcp_bpf_hooks.ipv6_lock),
 	.rebuild_proto = tcp_bpf_rebuild_proto,
 	.choose_proto = tcp_bpf_choose_proto,
 };

 static int __init tcp_bpf_init_psock_hooks(void)
 {
-	return sk_psock_hooks_init(&tcp_bpf_hooks, &tcp_prot);
+	return tcp_bpf_rebuild_proto(tcp_bpf_ipv4, &tcp_prot);
 }
 core_initcall(tcp_bpf_init_psock_hooks);

diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index e085a0648a94..da5eb1d2265d 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -30,13 +30,14 @@ static struct proto udpv6_proto;
 static struct sk_psock_hooks udp_psock_proto __read_mostly = {
 	.ipv4 = &udpv4_proto,
 	.ipv6 = &udpv6_proto,
+	.ipv6_lock = __SPIN_LOCK_UNLOCKED(udp_psock_proto.ipv6_lock),
 	.rebuild_proto = udp_bpf_rebuild_protos,
 	.choose_proto = udp_bpf_choose_proto,
 };

 static int __init udp_bpf_init_psock_hooks(void)
 {
-	return sk_psock_hooks_init(&udp_psock_proto, &udp_prot);
+	return udp_bpf_rebuild_protos(&udpv4_proto, &udp_prot);
 }
 core_initcall(udp_bpf_init_psock_hooks);
