Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C915547EA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiFVKPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 06:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbiFVKPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 06:15:44 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E793AA60
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 03:15:43 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id n144so25277404ybf.12
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 03:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4I3+LXpt/GiQmM5EiT2rdams3BlOILH3mkwLj6ht4s=;
        b=j9cyv0qF+sSr6PMRpl4IZXeEyCpg+67GKtmIoQHOoeShowZUJUywEb5ehGht7miIcU
         8JA3/6Arxhh8jsVkN/hWodnyiBwD54ZTi7nAd/WoMZIEo/uHV6L6SHBBzRhJ4IPAjX5i
         UiATeJxGpWHfaAxIGUFQvdWDPaVVzKgv+cOG4jOzTVyu2d2cDo9gMEKaSmzUhPMxzhBr
         FKJ4zsWtaqLrNtNLVg1JFM/R5KvGyQvYICWcJ81Zci1pIT5yghTjmSFaGlFK7QxgUI9h
         /wxaoB8etBlF0Qm1ZgqmGFgYwfvMuzWulGGTS9M6hI1JXR+/tv1Bt19i23J4G68/8M4O
         8lpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4I3+LXpt/GiQmM5EiT2rdams3BlOILH3mkwLj6ht4s=;
        b=r/abWn5Ots4NxoMc/9f7r2UP4r7c1X6tnXCZtpMdQhLPO3Nig5uyaq9sS/RTvGd7+R
         NJD1ZQ38sHTbcQ/HH49sgILhPI1WEZtKsBCZpA2WaiGbGkYJXHW5hnkOIF3QoVAztrTs
         mJCBCU5xU07tzzvFK0UCg9tCQk2CUTx4eziC4RQ+h+HK0a9PS0qsemHxrR6rBdH1KN8P
         7XT6UzlxIKoGYBC3XmDReM6QVs/1dbivl9dgknblDUpSwQzaQQ9+Md2w+ZZ7nCOSaBB7
         vIK0EiTXu5Vn/ZmObdIAX/Z5ZQovvkHwcrS9R5R6NHbJLt5EYMPOkcYJh9Dha62h05D0
         zU6w==
X-Gm-Message-State: AJIora+1GlRPKFctUkeAxdT6UkzB9XkyHVTNiL9Mb+V5JTZHWEEtf+FP
        9aXJ9ip7a0r3n+Iy/7U3JeFGmg1WmI0X5WxNE0jm2Q==
X-Google-Smtp-Source: AGRyM1ti2VhjJkptOA8pdJZGoLHG3Mko+AoL3e9cWc+9Gzrhpb4C5/vZXiTldoqd8Pf35Himh0JR8EiD+MlncJBJlX0=
X-Received: by 2002:a25:ae23:0:b0:668:daf8:c068 with SMTP id
 a35-20020a25ae23000000b00668daf8c068mr2824487ybj.427.1655892942629; Wed, 22
 Jun 2022 03:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220619003919.394622-1-i.maximets@ovn.org> <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
In-Reply-To: <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Jun 2022 12:15:31 +0200
Message-ID: <CANn89i+JdDukwEhZ=41FxY-w63eER6JVixkwL+s2eSOjo6aWEQ@mail.gmail.com>
Subject: Re: [PATCH net] net: ensure all external references are released in
 deferred skbuffs
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 12:02 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sun, Jun 19, 2022 at 2:39 AM Ilya Maximets <i.maximets@ovn.org> wrote:
> >
> > Open vSwitch system test suite is broken due to inability to
> > load/unload netfilter modules.  kworker thread is getting trapped
> > in the infinite loop while running a net cleanup inside the
> > nf_conntrack_cleanup_net_list, because deferred skbuffs are still
> > holding nfct references and not being freed by their CPU cores.
> >
> > In general, the idea that we will have an rx interrupt on every
> > CPU core at some point in a near future doesn't seem correct.
> > Devices are getting created and destroyed, interrupts are getting
> > re-scheduled, CPUs are going online and offline dynamically.
> > Any of these events may leave packets stuck in defer list for a
> > long time.  It might be OK, if they are just a piece of memory,
> > but we can't afford them holding references to any other resources.
> >
> > In case of OVS, nfct reference keeps the kernel thread in busy loop
> > while holding a 'pernet_ops_rwsem' semaphore.  That blocks the
> > later modprobe request from user space:
> >
> >   # ps
> >    299 root  R  99.3  200:25.89 kworker/u96:4+
> >
> >   # journalctl
> >   INFO: task modprobe:11787 blocked for more than 1228 seconds.
> >         Not tainted 5.19.0-rc2 #8
> >   task:modprobe     state:D
> >   Call Trace:
> >    <TASK>
> >    __schedule+0x8aa/0x21d0
> >    schedule+0xcc/0x200
> >    rwsem_down_write_slowpath+0x8e4/0x1580
> >    down_write+0xfc/0x140
> >    register_pernet_subsys+0x15/0x40
> >    nf_nat_init+0xb6/0x1000 [nf_nat]
> >    do_one_initcall+0xbb/0x410
> >    do_init_module+0x1b4/0x640
> >    load_module+0x4c1b/0x58d0
> >    __do_sys_init_module+0x1d7/0x220
> >    do_syscall_64+0x3a/0x80
> >    entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >
> > At this point OVS testsuite is unresponsive and never recover,
> > because these skbuffs are never freed.
> >
> > Solution is to make sure no external references attached to skb
> > before pushing it to the defer list.  Using skb_release_head_state()
> > for that purpose.  The function modified to be re-enterable, as it
> > will be called again during the defer list flush.
> >
> > Another approach that can fix the OVS use-case, is to kick all
> > cores while waiting for references to be released during the net
> > cleanup.  But that sounds more like a workaround for a current
> > issue rather than a proper solution and will not cover possible
> > issues in other parts of the code.
> >
> > Additionally checking for skb_zcopy() while deferring.  This might
> > not be necessary, as I'm not sure if we can actually have zero copy
> > packets on this path, but seems worth having for completeness as we
> > should never defer such packets regardless.
> >
> > CC: Eric Dumazet <edumazet@google.com>
> > Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
> > Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> > ---
> >  net/core/skbuff.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
>
> I do not think this patch is doing the right thing.
>
> Packets sitting in TCP receive queues should not hold state that is
> not relevant for TCP recvmsg().
>
> This consumes extra memory for no good reason, and defer expensive
> atomic operations.
>
> We for instance release skb dst before skb is queued, we should do the
> same for conntrack state.
>
> This would increase performance anyway, as we free ct state while cpu
> caches are hot.

I am thinking of the following instead.

A new helper can be added (and later be used in net/packet/af_packet.c
and probably elsewhere)

diff --git a/include/net/dst.h b/include/net/dst.h
index 6aa252c3fc55ccaee58faebf265510469e91d780..7c3316d9d6e73daea17223a5261f6a5c4f68eae3
100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -276,6 +276,15 @@ static inline void skb_dst_drop(struct sk_buff *skb)
        }
 }

+/* Before queueing skb in a receive queue, get rid of
+ * potentially expensive components.
+ */
+static inline void skb_cleanup(struct sk_buff *skb)
+{
+       skb_dst_drop(skb);
+       nf_reset_ct(skb);
+}
+
 static inline void __skb_dst_copy(struct sk_buff *nskb, unsigned long refdst)
 {
        nskb->slow_gro |= !!refdst;
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index fdbcf2a6d08ef4a5164247b5a5b4b222289b191a..913c98e446d56ee067b54b2c704ac1195ef1a81e
100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -177,7 +177,7 @@ void tcp_fastopen_add_skb(struct sock *sk, struct
sk_buff *skb)
        if (!skb)
                return;

-       skb_dst_drop(skb);
+       skb_cleanup(skb);
        /* segs_in has been initialized to 1 in tcp_create_openreq_child().
         * Hence, reset segs_in to 0 before calling tcp_segs_in()
         * to avoid double counting.  Also, tcp_segs_in() expects
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2e2a9ece9af27372e6b653d685a89a2c71ba05d1..987981a16ee34e0601e7e722abef1bb098c307c5
100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5005,7 +5005,7 @@ static void tcp_data_queue(struct sock *sk,
struct sk_buff *skb)
                __kfree_skb(skb);
                return;
        }
-       skb_dst_drop(skb);
+       skb_cleanup(skb);
        __skb_pull(skb, tcp_hdr(skb)->doff * 4);

        reason = SKB_DROP_REASON_NOT_SPECIFIED;
@@ -5931,7 +5931,7 @@ void tcp_rcv_established(struct sock *sk, struct
sk_buff *skb)
                        NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPHPHITS);

                        /* Bulk data transfer: receiver */
-                       skb_dst_drop(skb);
+                       skb_cleanup(skb);
                        __skb_pull(skb, tcp_header_len);
                        eaten = tcp_queue_rcv(sk, skb, &fragstolen);

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fe8f23b95d32ca4a35d05166d471327bc608fa91..d9acd906f28267ff07450d78d079e4e8eab74957
100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1765,7 +1765,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
         */
        skb_condense(skb);

-       skb_dst_drop(skb);
+       skb_cleanup(skb);

        if (unlikely(tcp_checksum_complete(skb))) {
                bh_unlock_sock(sk);
