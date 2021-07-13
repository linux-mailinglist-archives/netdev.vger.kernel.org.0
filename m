Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EAD3C6FEF
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 13:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbhGMLuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbhGMLuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 07:50:15 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F32DC0613DD;
        Tue, 13 Jul 2021 04:47:26 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r135so34363511ybc.0;
        Tue, 13 Jul 2021 04:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cuhTsqiAR1PuP9DOnQbs4r/pWF1mt0x6HYCYKTd+DvY=;
        b=hQqtp6MpfUSjY4P7bpv2UJxjB1KB8zT2wVbTNEBHsGKfF1W6Fz7wMlsEYx7VhkbNff
         XmYKNbvwMruvcJZbogUXAgq9WoxEbc5L8ok2rf3lXelPD+q5KvC0+7CwckYkB7gxzTA/
         4dZPnpnJ7uTodaXlWYEm/8gH7N4Q6gpCbgkdiW1BN8DWbshRClA9p0RL+NI4jXTXdoWA
         OzhgGUmBGwN9EGu5Lb4uQCDMPtoV/LZF2YeDuGL8Fv+RVWu/27t5ulfxAr+G3o6eqzW4
         6HE7pwuof638hYVqcszEYyb4PkzfILP8mm0HUTodfW6ohuKnenWHt5kgCn6JvXdsnI7x
         scZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cuhTsqiAR1PuP9DOnQbs4r/pWF1mt0x6HYCYKTd+DvY=;
        b=sQBfFOuub0mwoge7hQv13wEu8xnOo+1rukpSlYu2ojTMhtCWrhzZCQL4IyIhw/IF71
         x3wjrL7u8ZgGYJzTkfjF9s4V7E0vLFLUs6THzFBJm2AMhXgrlwjEV84J3/l9HJsR3DVv
         D+cSHKpsoPDmGcI/uj1LYxwxAjoAlwLeD6uuWCWlzjayjNA3QjNZlbJDIwcbUnl8eg8s
         jiKL8uF3LhalovbKWTHckI+jJCAYiQekppEy7zVLDqGWlCaTwgAY5w9ZiaVqqjU0q63+
         ua2UK8b9TuK74hGJztUOkt0zH0LzPvAnQVBE2XqLRZsfyXPkh0hLPFOpa+TQNn6Lk6nG
         IrvQ==
X-Gm-Message-State: AOAM530ZJ9gRP/bMdBo7ek5GuFZlGp5VTdfYYtiDtMJV0WlvjfwtGo8n
        5cqTBRV32dlSqaPE+EM1TeM/pf/qy9ALyMOR168=
X-Google-Smtp-Source: ABdhPJxok7m5N2LiU5BHTGtcI74np0U4SiGSxVlGhK+jMHAn/uuqpJm2KI5NiUAR4Gfmr3WV77oxRjlKvhgO4IM3whA=
X-Received: by 2002:a25:ab26:: with SMTP id u35mr5657712ybi.151.1626176845295;
 Tue, 13 Jul 2021 04:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210713094158.450434-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210713094158.450434-1-mudongliangabcd@gmail.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Tue, 13 Jul 2021 13:47:14 +0200
Message-ID: <CAKXUXMwMvWmS1jMfGe15tJKXpKdqGnhjsOhBKPkQ6_+twZpKxA@mail.gmail.com>
Subject: Re: [PATCH] audit: fix memory leak in nf_tables_commit
To:     Dongliang Mu <mudongliangabcd@gmail.com>
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

On Tue, Jul 13, 2021 at 11:42 AM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
> free the adp variable.
>
> Fix this by freeing the linked list with head adl.
>
> backtrace:
>   kmalloc include/linux/slab.h:591 [inline]
>   kzalloc include/linux/slab.h:721 [inline]
>   nf_tables_commit_audit_alloc net/netfilter/nf_tables_api.c:8439 [inline]
>   nf_tables_commit+0x16e/0x1760 net/netfilter/nf_tables_api.c:8508
>   nfnetlink_rcv_batch+0x512/0xa80 net/netfilter/nfnetlink.c:562
>   nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
>   nfnetlink_rcv+0x1fa/0x220 net/netfilter/nfnetlink.c:652
>   netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>   netlink_unicast+0x2c7/0x3e0 net/netlink/af_netlink.c:1340
>   netlink_sendmsg+0x36b/0x6b0 net/netlink/af_netlink.c:1929
>   sock_sendmsg_nosec net/socket.c:702 [inline]
>   sock_sendmsg+0x56/0x80 net/socket.c:722
>
> Reported-by: syzbot <syzkaller@googlegroups.com>

As far as I see, the more default way is to reference to syzbot by:

Reported-by: syzbot+[[20-letter hex reference]]@syzkaller.appspotmail.com

as in for example:

Reported-by: syzbot+fee64147a25aecd48055@syzkaller.appspotmail.com

A rough count says that format above is used 1300 times, whereas

Reported-by: syzbot <syzkaller@googlegroups.com>

is only used about 330 times.


Lukas

> Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  net/netfilter/nf_tables_api.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 390d4466567f..7f45b291be13 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -8444,6 +8444,16 @@ static int nf_tables_commit_audit_alloc(struct list_head *adl,
>         return 0;
>  }
>
> +static void nf_tables_commit_free(struct list_head *adl)
> +{
> +       struct nft_audit_data *adp, *adn;
> +
> +       list_for_each_entry_safe(adp, adn, adl, list) {
> +               list_del(&adp->list);
> +               kfree(adp);
> +       }
> +}
> +
>  static void nf_tables_commit_audit_collect(struct list_head *adl,
>                                            struct nft_table *table, u32 op)
>  {
> @@ -8508,6 +8518,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>                 ret = nf_tables_commit_audit_alloc(&adl, trans->ctx.table);
>                 if (ret) {
>                         nf_tables_commit_chain_prepare_cancel(net);
> +                       nf_tables_commit_free(adl);
>                         return ret;
>                 }
>                 if (trans->msg_type == NFT_MSG_NEWRULE ||
> @@ -8517,6 +8528,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>                         ret = nf_tables_commit_chain_prepare(net, chain);
>                         if (ret < 0) {
>                                 nf_tables_commit_chain_prepare_cancel(net);
> +                               nf_tables_commit_free(adl);
>                                 return ret;
>                         }
>                 }
> --
> 2.25.1
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/20210713094158.450434-1-mudongliangabcd%40gmail.com.
