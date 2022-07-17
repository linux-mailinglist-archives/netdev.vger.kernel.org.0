Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD5157775E
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiGQQ4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiGQQ4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:56:24 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C341813FA6;
        Sun, 17 Jul 2022 09:56:22 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id o26so7246129qkl.6;
        Sun, 17 Jul 2022 09:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wvctxbE7AX0aP5YUM45JP6LkP+57Bz6KK7nOycNQst8=;
        b=EMK6m15BuwHEJMxE9cRKgVio0vqeTEi8JLhy8/XYyk5mRbqET0cyoIOi5JFxZHh1HC
         WtrLKsajJwfZSSZtC+GEseBDOewisUn5oKPkx/x+PyZs8MsQOY/dki9h8wA1iOaNjL5p
         TRr6uC7fUeCCg+y5lcdXKyl6u954MC60WnTxd6Tcx89zBOTiuiWptgOqSK7/vKj8nrFX
         LqTZnvh+K/z6iwGJkpNzCp4usg5LRzmMtEQ6sSM0VeD1t+UZ42HsIr2aqtkEvGhc246r
         80HeTcgg/tTN1wM6MEWs+WuoVcRWQ0y6siAjJlLHR0qXK53F7HscrrGaj9qhqjimFRRz
         1ndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wvctxbE7AX0aP5YUM45JP6LkP+57Bz6KK7nOycNQst8=;
        b=SOhvrXvbCvw6EEdA49D1yqH7qfFnBRDj/GSyHDczP+LY4suqCI0hXNvgGbDM+qbFwz
         iOxq7k5Sr+7BP7gLICafJGVoZ5vt3aXuGNX/IWh2QoXE6+Np9Zbns8HpdXfXf3Q5/hOO
         o1HL1Mrf3aja6p3Pw0a6i3mPmpGRD68Wbzx4DEhH1LApZaDBPoitb7DBm+CQVudMAwa0
         MAORdYrZk69BEQucpml2I8TwMKiH8B9V8tM+AZLCPWzeS3g6eRCajm5EzeSRHFRCv9u0
         Caggm9WTTmQ8GzkTqVqrz9Sdkdy/vbJzvyoCeA49xIVmHdoHkcoY4Kt7SlkuvoiykQex
         ijKA==
X-Gm-Message-State: AJIora/w102O7ryrGttiKltGkoNeI0LYu8fQMto83scxZPhbyF39vmXc
        Sw+gmrpCshNpLTZGoBG5GcQ=
X-Google-Smtp-Source: AGRyM1u2r3ihr3dFz0xOY0Faxar3HctKntuptrt5yAuyXFRax9rFgHKbSRZIkGh7CvCoXDpjBTqGQg==
X-Received: by 2002:a05:620a:408e:b0:6b5:67b4:fbf9 with SMTP id f14-20020a05620a408e00b006b567b4fbf9mr15090890qko.278.1658076981847;
        Sun, 17 Jul 2022 09:56:21 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:db10:283b:b16c:9691])
        by smtp.gmail.com with ESMTPSA id t13-20020a37ea0d000000b006af147d4876sm9020690qkj.30.2022.07.17.09.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 09:56:21 -0700 (PDT)
Date:   Sun, 17 Jul 2022 09:56:22 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf-next] tcp: fix sock skb accounting in tcp_read_skb()
Message-ID: <YtQ/Np8DZBJVFO3l@pop-os.localdomain>
References: <20220709222029.297471-1-xiyou.wangcong@gmail.com>
 <CANn89iJSQh-5DAhEL4Fh5ZDrtY47y0Mo9YJbG-rnj17pdXqoXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJSQh-5DAhEL4Fh5ZDrtY47y0Mo9YJbG-rnj17pdXqoXA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 03:20:37PM +0200, Eric Dumazet wrote:
> On Sun, Jul 10, 2022 at 12:20 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Before commit 965b57b469a5 ("net: Introduce a new proto_ops
> > ->read_skb()"), skb was not dequeued from receive queue hence
> > when we close TCP socket skb can be just flushed synchronously.
> >
> > After this commit, we have to uncharge skb immediately after being
> > dequeued, otherwise it is still charged in the original sock. And we
> > still need to retain skb->sk, as eBPF programs may extract sock
> > information from skb->sk. Therefore, we have to call
> > skb_set_owner_sk_safe() here.
> >
> > Fixes: 965b57b469a5 ("net: Introduce a new proto_ops ->read_skb()")
> > Reported-and-tested-by: syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com
> > Tested-by: Stanislav Fomichev <sdf@google.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/ipv4/tcp.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 9d2fd3ced21b..c6b1effb2afd 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1749,6 +1749,7 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
> >                 int used;
> >
> >                 __skb_unlink(skb, &sk->sk_receive_queue);
> > +               WARN_ON(!skb_set_owner_sk_safe(skb, sk));
> >                 used = recv_actor(sk, skb);
> >                 if (used <= 0) {
> >                         if (!copied)
> > --
> > 2.34.1
> >
> 
> I am reading tcp_read_skb(),it seems to have other bugs.
> I wonder why syzbot has not caught up yet.

As you mentioned this here I assume you suggest I should fix all bugs in
one patch? (I am fine either way in this case, only slightly prefer to fix
one bug in each patch for readability.)

> 
> It ignores the offset value from tcp_recv_skb(), this looks wrong to me.
> The reason tcp_read_sock() passes a @len parameter is that is it not
> skb->len, but (skb->len - offset)

If I understand tcp_recv_skb() correctly it only returns an offset for a
partial read of an skb. IOW, if we always read an entire skb at a time,
offset makes no sense here, right?

> 
> Also if recv_actor(sk, skb) returns 0, we probably still need to
> advance tp->copied_seq,
> for instance if skb had a pure FIN (and thus skb->len == 0), since you
> removed the skb from sk_receive_queue ?

Doesn't the following code handle this case?

        if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
                consume_skb(skb);
                ++seq;
                break;
        }

which is copied from tcp_read_sock()...

Thanks.
