Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBB34DBEC0
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 06:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiCQFyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 01:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiCQFyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 01:54:20 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C6124B5E0;
        Wed, 16 Mar 2022 22:25:26 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id bg10so8421950ejb.4;
        Wed, 16 Mar 2022 22:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=em46uHT2Wr9UGmvm3AylWtT1TeSOw0Y1k0gjyaknWRs=;
        b=SCN/EWikFBaQIMyNBdgMwQPzjJYXS8611qgRiiXVB40QrJAh/iVayzKoZG3EFCNQ1R
         pRJ75Z2HJMaQtkYgfAHjJCf7SjyksYMbRknnDtFe+Slq+fW/M1wV7j7UcG08j3Rtuit8
         fHkFvL+Vgb5co84FN3C60G0XEZ3P3+MJArtfFMJex3n2yNmjXkBdzpHiKl9cM0p7BC6L
         Oj8u5yffGQm7tLeLceYCxbmBgmOglURzUbxjqpA6+ZN+nYNdBUWlNlhDl+7yiAh1FwA4
         qCTHTeGJpU0H/CvHWDdEzIh/iFewSRMwwGJb3uHSDqa2U9ARAwQ56xhSqfC9G+iaPV7+
         I5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=em46uHT2Wr9UGmvm3AylWtT1TeSOw0Y1k0gjyaknWRs=;
        b=N3OdN98ZWw9a0eDRayOm2N03XPofh6tO9nApWJwFw7CmheXwWY8KG2aq67U0fHYjjk
         6Tl5IAXd5Q1RgxDzTNHFl94W2xmuuu7mXo8zD0ycHJCrYl9IYJgaVX+bpomGTfeVOVc1
         IN1ChOANzA6RuY320EqdB+MJr+Ox9xnZt5FZ7+3o3Qc25cQY+UfMr76M9z3rLbjtfJ/7
         ffKRq7yCZXbu5Eko20+fYrqS2jm6fKTy0o/xEiulTs9u6WyZu5vxvJTsSEBTNhhDrCX5
         Abz5s5LX8IVExkggbgezDcnAUZpTzjWC5NEFiy1DlpeKQoNeiiVq9gfFQxxajZix+ySm
         sfQw==
X-Gm-Message-State: AOAM530H3BO7kNlDwZZP0I3fhQYd93RKFNF3HvVPOr6AsSo8qeY3bbxe
        nPrXwjeVSD/rRZ50MXLmhHqTV4QO4Avy0AWpZgM=
X-Google-Smtp-Source: ABdhPJyodRmFf+W07T3ZTiIAjPM8ILlaASkFXoFD123jhF8y7tm+hYMm2er40FO+jqjY1tlRsRNzF86XkHMGdGdp+M4=
X-Received: by 2002:a17:906:4cca:b0:6ce:6a06:bf7 with SMTP id
 q10-20020a1709064cca00b006ce6a060bf7mr2862712ejt.109.1647494724540; Wed, 16
 Mar 2022 22:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-3-imagedong@tencent.com> <f6c1dbe5-ba6f-6e68-aa3b-4fe018d5092f@kernel.org>
In-Reply-To: <f6c1dbe5-ba6f-6e68-aa3b-4fe018d5092f@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 17 Mar 2022 13:25:13 +0800
Message-ID: <CADxym3Z_o6P+jSu5sUZDQf4bGUj4f4tGEYi7a9z+wRjYu0o1xw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: icmp: introduce __ping_queue_rcv_skb()
 to report drop reasons
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 11:56 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/16/22 12:31 AM, menglong8.dong@gmail.com wrote:
> > diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> > index 3ee947557b88..9a1ea6c263f8 100644
> > --- a/net/ipv4/ping.c
> > +++ b/net/ipv4/ping.c
> > @@ -934,16 +934,24 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
> >  }
> >  EXPORT_SYMBOL_GPL(ping_recvmsg);
> >
> > -int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > +static enum skb_drop_reason __ping_queue_rcv_skb(struct sock *sk,
> > +                                              struct sk_buff *skb)
> >  {
> > +     enum skb_drop_reason reason;
> > +
> >       pr_debug("ping_queue_rcv_skb(sk=%p,sk->num=%d,skb=%p)\n",
> >                inet_sk(sk), inet_sk(sk)->inet_num, skb);
> > -     if (sock_queue_rcv_skb(sk, skb) < 0) {
> > -             kfree_skb(skb);
> > +     if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
> > +             kfree_skb_reason(skb, reason);
> >               pr_debug("ping_queue_rcv_skb -> failed\n");
> > -             return -1;
> > +             return reason;
> >       }
> > -     return 0;
> > +     return SKB_NOT_DROPPED_YET;
> > +}
> > +
> > +int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > +{
> > +     return __ping_queue_rcv_skb(sk, skb) ?: -1;
> >  }
> >  EXPORT_SYMBOL_GPL(ping_queue_rcv_skb);
> >
>
> This is a generic proto callback and you are now changing its return
> code in a way that seems to conflict with existing semantics

The return value of ping_queue_rcv_skb() seems not changed.
In the previous code, -1 is returned on failure and 0 for success.
This logic isn't changed, giving __ping_queue_rcv_skb() != 0 means
failure and -1 is returned. Isn't it?
