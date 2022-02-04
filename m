Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96704A9B5F
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 15:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359438AbiBDOrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 09:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiBDOrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 09:47:09 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FBBC061714;
        Fri,  4 Feb 2022 06:47:08 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id p7so13503460edc.12;
        Fri, 04 Feb 2022 06:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wWp3X4UPWd440tI67mwYFPhgiomADBgs/mNH8wZeAl0=;
        b=LEwr1bXTEO7IJ5xySYVUPr4GVIobsHChXleOt11h2qgc2Tkuq3OGHj4TDLreM91l21
         icK0ga6mf32oY5VFoRFHGib8jvlOupXXuBoz+oQFGTaCs0WT7+XOXLeCxh0EjfYrTS03
         8DLhTocpVjeQWtjfLriI/3M1r5pxFlVeYIeB1hiXMhuRj89eCogVtjo+t0g7CFV5f2mY
         3CBYpZHxJLNXxF23VmJcTa4nhRS6pMSoJUSaUW+A4K+dDq/ccCwiteEtcRRgYF+52VHk
         4dWaE7CEW520+VXNrlPOZeYsyNI4j9avdIm+CmBKylas3bSkTbP0C0WuU5QbK+z3hkb6
         V7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wWp3X4UPWd440tI67mwYFPhgiomADBgs/mNH8wZeAl0=;
        b=O15QorgvZcjvM6aalYc2LelU/l0e2NyipWTZSOjNCssdwt8nnKWT/RH8rBnkNne2ic
         VppY1coIURXW/hY8geouceNSmcYzOuXoMWgIR1z7SbpqmyvuhNXBYmHG5TsE7gjSG5Hx
         WKnOxfpsMYpSloR32oazlHEcyk4e9t3F9/E7DIj6UZGlH+75dm+1CX1rtEMgF3DSK74E
         SjXhRrYj6UqJ1Hyy/SfUPZZ7yjeBzAn2BBML/ZPdKUUbwhddRgAdULcVg68g+sGGvmYA
         yU9Ap+pLnBFv4t8hAIQo90/s1vY+LTwQSo6dBCjr/qJIJwyV9eSOdjnahsuoYE0P6RCI
         JuLw==
X-Gm-Message-State: AOAM533tO48H8aSdgviGNAWHjt9vnH7cKMHImJaHu7P5B3wcdSEKVS3B
        DqXOFwlGO66NcPKbxljuwUmMj/B0Ph6lwjfigH4=
X-Google-Smtp-Source: ABdhPJyRdZi/L+7DYPZuGYGq/RtrcK04EagQGt8iR9vlrUsBkiN76WUoLIX+WPMSXv2o1iAeVim89cLhDSFjt5WUoJg=
X-Received: by 2002:a05:6402:5203:: with SMTP id s3mr3298814edd.389.1643986027368;
 Fri, 04 Feb 2022 06:47:07 -0800 (PST)
MIME-Version: 1.0
References: <20220128073319.1017084-1-imagedong@tencent.com>
 <20220128073319.1017084-4-imagedong@tencent.com> <16e8de51-6b56-3dfe-e9c4-524ab40cdea9@gmail.com>
In-Reply-To: <16e8de51-6b56-3dfe-e9c4-524ab40cdea9@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 4 Feb 2022 22:42:13 +0800
Message-ID: <CADxym3aB380ZSGTtJwi3xAahXHgBhG41ACoXZhheZ9qOarizKQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/7] net: ipv4: use kfree_skb_reason() in ip_rcv_core()
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        pablo@netfilter.org, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Kees Cook <keescook@chromium.org>,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>,
        Mengen Sun <mengensun@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 2:06 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/28/22 12:33 AM, menglong8.dong@gmail.com wrote:
> \> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> > index 3a025c011971..627fad437593 100644
> > --- a/net/ipv4/ip_input.c
> > +++ b/net/ipv4/ip_input.c
> > @@ -436,13 +436,18 @@ static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
> >  static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
> >  {
> >       const struct iphdr *iph;
> > +     int drop_reason;
> >       u32 len;
> >
> > +     drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
>
> move this line down, right before:
>
>         if (!pskb_may_pull(skb, sizeof(struct iphdr)))
>                 goto inhdr_error;
>
> > +
> >       /* When the interface is in promisc. mode, drop all the crap
> >        * that it receives, do not try to analyse it.
> >        */
> > -     if (skb->pkt_type == PACKET_OTHERHOST)
> > +     if (skb->pkt_type == PACKET_OTHERHOST) {
> > +             drop_reason = SKB_DROP_REASON_OTHERHOST;
> >               goto drop;
> > +     }
> >
> >       __IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
> >
> > @@ -488,6 +493,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
> >
> >       len = ntohs(iph->tot_len);
> >       if (skb->len < len) {
> > +             drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
> >               __IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
> >               goto drop;
> >       } else if (len < (iph->ihl*4))
> > @@ -516,11 +522,13 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
> >       return skb;
> >
> >  csum_error:
> > +     drop_reason = SKB_DROP_REASON_IP_CSUM;
> >       __IP_INC_STATS(net, IPSTATS_MIB_CSUMERRORS);
> >  inhdr_error:
> > +     drop_reason = drop_reason ?: SKB_DROP_REASON_IP_INHDR;
>
> That makes assumptions about the value of SKB_DROP_REASON_NOT_SPECIFIED.
> Make that line:
>         if (drop_reason != SKB_DROP_REASON_NOT_SPECIFIED)
>                 drop_reason = SKB_DROP_REASON_IP_INHDR;
>

You are right, the assumptions here are unsuitable. But I guess it
should be this?

         if (drop_reason == SKB_DROP_REASON_NOT_SPECIFIED)
                 drop_reason = SKB_DROP_REASON_IP_INHDR;

> >       __IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
> >  drop:
> > -     kfree_skb(skb);
> > +     kfree_skb_reason(skb, drop_reason);
> >  out:
> >       return NULL;
> >  }
>
