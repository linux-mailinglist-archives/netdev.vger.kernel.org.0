Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B7E4EE40
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 19:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfFUR7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 13:59:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50438 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfFUR7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 13:59:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so7116226wmf.0
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 10:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XbG+M/su6pkc7+Il073k2uQdZNpQNluZQlODsDqLVc8=;
        b=NmThPT/wVJfQ0a9AzSB9mMxlmhBK0S0BMOZST9ov/9sPqv64dE5p7CJqboGqEIHk6R
         zNFJ9aIy3veZeR9ofoAUi+bKZ3IDrHPqPjp3jcPl9yyTMrN5zPQfzpW6ijSVF6JNs9EB
         1KSc8yeRVH2z1FWv2skZc7eebNrl+qiLWK5OA4UMMua0P+6w7pgeHBhXgeW2k12J7yaI
         MV60w9OFvbiE6QwyZc1dQtv4Jw/7DpTVlRyDylLai3BN5IU4hk3OuDHBlSUoEUUK/lp1
         XocZSC6+XQ2VmDMjZCxVcoDw7F/9EU2fQMhhCqE9gkFVpQ25B/lXI7AzbXJRMPtuR1T8
         ohHg==
X-Gm-Message-State: APjAAAXxknm16UfSGOD3q4ht/o5nti4BJIUFVynbsBjWi9VAku9vSqWx
        ZK0RjdvA9u4I00R2hacdqtuBzSgUuo7bNK+4K2g=
X-Google-Smtp-Source: APXvYqym9xnTFz2Lx0pYTeVkaxhlUWTm1u+kPGijyOpxWOMtjhy0alS/4zE/koYYg6MdGVN0RDJvUv+ZqnnQRjEyxMA=
X-Received: by 2002:a7b:cc81:: with SMTP id p1mr4731094wma.107.1561139945484;
 Fri, 21 Jun 2019 10:59:05 -0700 (PDT)
MIME-Version: 1.0
From:   Joe Stringer <joe@wand.net.nz>
Date:   Fri, 21 Jun 2019 10:58:54 -0700
Message-ID: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
Subject: Removing skb_orphan() from ip_rcv_core()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks, picking this up again..

As discussed during LSFMM, I've been looking at adding something like
an `skb_sk_assign()` helper to BPF so that logic similar to TPROXY can
be implemented with integration into other BPF logic, however
currently any attempts to do so are blocked by the skb_orphan() call
in ip_rcv_core() (which will effectively ignore any socket assign
decision made by the TC BPF program).

Recently I was attempting to remove the skb_orphan() call, and I've
been trying different things but there seems to be some context I'm
missing. Here's the core of the patch:

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index ed97724c5e33..16aea980318a 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -500,8 +500,6 @@ static struct sk_buff *ip_rcv_core(struct sk_buff
*skb, struct net *net)
       memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
       IPCB(skb)->iif = skb->skb_iif;

-       /* Must drop socket now because of tproxy. */
-       skb_orphan(skb);

       return skb;

The statement that the socket must be dropped because of tproxy
doesn't make sense to me, because the PRE_ROUTING hook is hit after
this, which will call into the tproxy logic and eventually
nf_tproxy_assign_sock() which already does the skb_orphan() itself.

However, if I drop these lines then I end up causing sockets to
release references too many times. Seems like if we don't orphan the
skb here, then later logic assumes that we have one more reference
than we actually have, and decrements the count when it shouldn't
(perhaps the skb_steal_sock() call in __inet_lookup_skb() which seems
to assume we always have a reference to the socket?)

Splat:

refcount_t hit zero at sk_stop_timer+0x2c/0x30 in cilium-agent[16359],
uid/euid: 0/0
WARNING: CPU: 0 PID: 16359 at kernel/panic.c:686 refcount_error_report+0x9c/0xa1
...
? inet_put_port+0xa6/0xd0
inet_csk_clear_xmit_timers+0x2e/0x50
tcp_done+0x8b/0xf0
tcp_reset+0x49/0xc0
tcp_validate_incoming+0x2f7/0x410
tcp_rcv_state_process+0x250/0xdb6
? tcp_v4_connect+0x46f/0x4e0
tcp_v4_do_rcv+0xbd/0x1f0
__release_sock+0x84/0xd0
release_sock+0x30/0xa0
inet_stream_connect+0x47/0x60

(Full version: https://gist.github.com/joestringer/d5313e4bf4231e2c46405bd7a3053936
)

This seems potentially related to some of the socket referencing
discussion in the peer thread "[RFC bpf-next 0/7] Programming socket
lookup with BPF".

During LSFMM, it seemed like no-one knew quite why the skb_orphan() is
necessary in that path in the current version of the code, and that we
may be able to remove it. Florian, I know you weren't in the room for
that discussion, so raising it again now with a stack trace, Do you
have some sense what's going on here and whether there's a path
towards removing it from this path or allowing the skb->sk to be
retained during ip_rcv() in some conditions?
