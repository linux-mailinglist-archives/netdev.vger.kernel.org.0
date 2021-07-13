Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AAE3C6FF9
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 13:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbhGMLzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbhGMLzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 07:55:00 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E214C0613DD;
        Tue, 13 Jul 2021 04:52:10 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s15so32746786edt.13;
        Tue, 13 Jul 2021 04:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OeqxKzwwhx4YHjM5KQJiNswe/2PWyz6Lv9R2luzCE0o=;
        b=kdwgFvjffiTSAMCVLAlAXO/xfCCfsHdFcohe7BrIigsO2Gi/JaFMJgz0+YfOihMLt5
         U5+xa1J4u0uxnCnwpepb7wpWtTJcnQChQf454jXMXqdVQPwE5zHGT44KjSfYXPfKAotw
         wD92oGaNENSzsS96hPEqXNL2c7O7o/4xldnOoiVnrT/0V6yr4jEaRevMDFUd3kFhFjwB
         c0wv1jEz/EWCTNysAYEhhrIh280yXNAFuuADatudSLol+YWeeMrrf4QetdeK5IRy0bs2
         teWi1toJKpWWS46rze9zcODz1N91Vc4sWz7tchO41wfFj8Dokeh60zoW9v5/fxct5V8k
         XQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OeqxKzwwhx4YHjM5KQJiNswe/2PWyz6Lv9R2luzCE0o=;
        b=M4/hcVmPXByhPrjeBSEnOxGzMH/VLNdiNTL63paMxY3g5cFd+Z2KKBr3qkL8NtDET2
         bT2/9NIBkvWfkSgC+yRo9NdQ/k728LbtOq4JPfILQy3FnF+/Ag+9eXHRGvpuHzJsFMxd
         6cigW+l3FCnmYsFk4wv1mtdnkZn+n0Esirf3HjAMHRu3tMGryQcsMd4WoVMxroSnUqUi
         jV0gJOUHEySrYyFosZT1cxQ195wIrmPbVKPYHhK79rWb3iOovVNtya4PFSRlZkK0shDM
         CIX3coYRex/sFZ9f9yWYU0bEy7tNSsnhZO5bSuhnq5ut0WUpKQY3TZi+XsVRB4UREc/Q
         Ih3A==
X-Gm-Message-State: AOAM531g0pG1GlRqDKyu7v9WjangIi+oKgwOcFoq7r67FuYZly4pH8VQ
        /IMH9ZDMBKa5vGCSsoy4c4hmtWYKWu8bOCFfHmU=
X-Google-Smtp-Source: ABdhPJzv1VXR1O+kok2yEmvazi+5hwbcyw1N8xI/oLAgFZKKOKokQ7ifIh7Z28Q8tF6LbMV9x9KTcORdxVsEtfixIJs=
X-Received: by 2002:a05:6402:4c5:: with SMTP id n5mr5138855edw.322.1626177128540;
 Tue, 13 Jul 2021 04:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210713094158.450434-1-mudongliangabcd@gmail.com> <CAKXUXMwMvWmS1jMfGe15tJKXpKdqGnhjsOhBKPkQ6_+twZpKxA@mail.gmail.com>
In-Reply-To: <CAKXUXMwMvWmS1jMfGe15tJKXpKdqGnhjsOhBKPkQ6_+twZpKxA@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 13 Jul 2021 19:51:42 +0800
Message-ID: <CAD-N9QUipQHb7WS1V=3MXmuO4uweYqX-=BMfmV_fUVhSxqXFHA@mail.gmail.com>
Subject: Re: [PATCH] audit: fix memory leak in nf_tables_commit
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 7:47 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>
> On Tue, Jul 13, 2021 at 11:42 AM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
> > free the adp variable.
> >
> > Fix this by freeing the linked list with head adl.
> >
> > backtrace:
> >   kmalloc include/linux/slab.h:591 [inline]
> >   kzalloc include/linux/slab.h:721 [inline]
> >   nf_tables_commit_audit_alloc net/netfilter/nf_tables_api.c:8439 [inline]
> >   nf_tables_commit+0x16e/0x1760 net/netfilter/nf_tables_api.c:8508
> >   nfnetlink_rcv_batch+0x512/0xa80 net/netfilter/nfnetlink.c:562
> >   nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
> >   nfnetlink_rcv+0x1fa/0x220 net/netfilter/nfnetlink.c:652
> >   netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> >   netlink_unicast+0x2c7/0x3e0 net/netlink/af_netlink.c:1340
> >   netlink_sendmsg+0x36b/0x6b0 net/netlink/af_netlink.c:1929
> >   sock_sendmsg_nosec net/socket.c:702 [inline]
> >   sock_sendmsg+0x56/0x80 net/socket.c:722
> >
> > Reported-by: syzbot <syzkaller@googlegroups.com>
>
> As far as I see, the more default way is to reference to syzbot by:
>
> Reported-by: syzbot+[[20-letter hex reference]]@syzkaller.appspotmail.com
>

Hi Lukas,

this bug is not listed on the syzbot dashboard. I found this bug by
setting up a local syzkaller instance, so I only list syzbot other
than concrete syzbot id.

best regards,
Dongliang Mu

> as in for example:
>
> Reported-by: syzbot+fee64147a25aecd48055@syzkaller.appspotmail.com
>
> A rough count says that format above is used 1300 times, whereas
>
> Reported-by: syzbot <syzkaller@googlegroups.com>
>
> is only used about 330 times.
>
>
> Lukas
>
> > Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >  net/netfilter/nf_tables_api.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 390d4466567f..7f45b291be13 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -8444,6 +8444,16 @@ static int nf_tables_commit_audit_alloc(struct list_head *adl,
> >         return 0;
> >  }
> >
> > +static void nf_tables_commit_free(struct list_head *adl)
> > +{
> > +       struct nft_audit_data *adp, *adn;
> > +
> > +       list_for_each_entry_safe(adp, adn, adl, list) {
> > +               list_del(&adp->list);
> > +               kfree(adp);
> > +       }
> > +}
> > +
> >  static void nf_tables_commit_audit_collect(struct list_head *adl,
> >                                            struct nft_table *table, u32 op)
> >  {
> > @@ -8508,6 +8518,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
> >                 ret = nf_tables_commit_audit_alloc(&adl, trans->ctx.table);
> >                 if (ret) {
> >                         nf_tables_commit_chain_prepare_cancel(net);
> > +                       nf_tables_commit_free(adl);
> >                         return ret;
> >                 }
> >                 if (trans->msg_type == NFT_MSG_NEWRULE ||
> > @@ -8517,6 +8528,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
> >                         ret = nf_tables_commit_chain_prepare(net, chain);
> >                         if (ret < 0) {
> >                                 nf_tables_commit_chain_prepare_cancel(net);
> > +                               nf_tables_commit_free(adl);
> >                                 return ret;
> >                         }
> >                 }
> > --
> > 2.25.1
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/20210713094158.450434-1-mudongliangabcd%40gmail.com.
