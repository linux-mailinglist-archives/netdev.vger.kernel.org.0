Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC082CCBA
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfE1Q4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:56:32 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:36597 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfE1Q4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:56:31 -0400
Received: by mail-it1-f195.google.com with SMTP id e184so5060213ite.1
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 09:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DMU8hxlWz4QvGo3NHFJ3rYMjNIzP4+LSL6yM65Zz5jA=;
        b=XH5etCgW8J35QagIZVKgzUdNd2vIS0fPMb56ud0PyBx3bQHhnDoUH2xXMh8i9mNd1K
         +CQ/B3CnH+PwseaIj/vrTtuXU81UZOG7B+whjw0g/lit2KVp7KXrKh9Ua5H/LmJI6pUx
         tSVPs6iJykhzxjkaOGl8tTH+rrQw5X+hklV/BikR+MW4UWIWuzTrWDpvcZbMGxAcPEo1
         mvKPhnVS6hnzEyhR8w/fnPz8zGrnBuB96nTmqvU5lW1iyLqgOBIGSm9VVs6LA/XYajzd
         BY5tUpjtBJJ3Scq7wrAyEcZpgUqEIN0bxexxhX9eqMM4FD8vasXgsDBoOnySBpmypsAC
         Cebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DMU8hxlWz4QvGo3NHFJ3rYMjNIzP4+LSL6yM65Zz5jA=;
        b=bP9vx0WgeviSh+n/ogYcDQICInS+bNopp0B9V279vifd22GZahopBzvXHCBm8PGMZ+
         66bqUZL5v6S2BZQsrhIZ4Gk7VHnxoJsNGSPMxUZg3vwEySJACgkqiGGK1Es5HZ24+8Ni
         cXiTVKgd/yUfgTB7lbeq0LlXFZg8jY9j02jOtSkvoCFnlqfgrBjkDPxdSCutXOj+jcWZ
         ZJK4CDIABvipyxOa4TSMTtg4pk/LBlKRHfeb96CipBlmqjKTf6GIhYA5G3rm3TDUkrkE
         sJFzyNho/JN+mCRdstH6/3TbprJO8jT2ULED600z06Yty+YuTe8AcBFYEbqOA5+KAcGk
         qpqA==
X-Gm-Message-State: APjAAAVYzlbrjIQS8bt05X8o0uabpUv+7JFT3TiWTGc+GbcndH6l53KE
        3FBTA/TP+oeG+YmR1k5F4Jzxvhfoe/tzG5/knJNBSg==
X-Google-Smtp-Source: APXvYqzlICI4q27DrJXr1y1Htb3Cxy4JlVCRxkVGTSUFi8yAiK0zDY4//XiVTQ2MRnYgY4U7I87hOpwS+e4Ysp+Qby8=
X-Received: by 2002:a24:284b:: with SMTP id h72mr3663947ith.72.1559062590425;
 Tue, 28 May 2019 09:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <1558713946-25314-1-git-send-email-john.hurley@netronome.com> <531c9565-5e42-3c87-891e-1cae13ae89bf@iogearbox.net>
In-Reply-To: <531c9565-5e42-3c87-891e-1cae13ae89bf@iogearbox.net>
From:   John Hurley <john.hurley@netronome.com>
Date:   Tue, 28 May 2019 17:56:19 +0100
Message-ID: <CAK+XE=naods2Yhd1roKDcq+8ScZ34NGPBwjoEUXMUr=XcqH4PQ@mail.gmail.com>
Subject: Re: [RFC net-next 1/1] net: sched: protect against loops in TC filter hooks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com, alexei.starovoitov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 7:32 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 05/24/2019 06:05 PM, John Hurley wrote:
> > TC hooks allow the application of filters and actions to packets at both
> > ingress and egress of the network stack. It is possible, with poor
> > configuration, that this can produce loops whereby an ingress hook calls
> > a mirred egress action that has an egress hook that redirects back to
> > the first ingress etc. The TC core classifier protects against loops when
> > doing reclassifies but, as yet, there is no protection against a packet
> > looping between multiple hooks. This can lead to stack overflow panics.
> >
> > Add a per cpu counter that tracks recursion of packets through TC hooks.
> > The packet will be dropped if a recursive limit is passed and the counter
> > reset for the next packet.
>
> NAK. This is quite a hack in the middle of the fast path. Such redirection
> usually has a rescheduling point, like in cls_bpf case. If this is not the
> case for mirred action as I read your commit message above, then fix mirred
> instead if it's such broken.
>

Hi Daniel,
Yes, I take your point on the positioning of the code.
I was trying to cater for all cases here but can look at bringing this
closer to the cause.
John

> Thanks,
> Daniel
>
> > Signed-off-by: John Hurley <john.hurley@netronome.com>
> > Reviewed-by: Simon Horman <simon.horman@netronome.com>
> > ---
> >  net/core/dev.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 55 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index b6b8505..a6d9ed7 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -154,6 +154,9 @@
> >  /* This should be increased if a protocol with a bigger head is added. */
> >  #define GRO_MAX_HEAD (MAX_HEADER + 128)
> >
> > +#define SCH_RECURSION_LIMIT  4
> > +static DEFINE_PER_CPU(int, sch_recursion_level);
> > +
> >  static DEFINE_SPINLOCK(ptype_lock);
> >  static DEFINE_SPINLOCK(offload_lock);
> >  struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
> > @@ -3598,16 +3601,42 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
> >  }
> >  EXPORT_SYMBOL(dev_loopback_xmit);
> >
> > +static inline int sch_check_inc_recur_level(void)
> > +{
> > +     int rec_level = __this_cpu_inc_return(sch_recursion_level);
> > +
> > +     if (rec_level >= SCH_RECURSION_LIMIT) {
> > +             net_warn_ratelimited("Recursion limit reached on TC datapath, probable configuration error\n");
> > +             return -ELOOP;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static inline void sch_dec_recur_level(void)
> > +{
> > +     __this_cpu_dec(sch_recursion_level);
> > +}
> > +
> >  #ifdef CONFIG_NET_EGRESS
> >  static struct sk_buff *
> >  sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> >  {
> >       struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
> >       struct tcf_result cl_res;
> > +     int err;
> >
> >       if (!miniq)
> >               return skb;
> >
> > +     err = sch_check_inc_recur_level();
> > +     if (err) {
> > +             sch_dec_recur_level();
> > +             *ret = NET_XMIT_DROP;
> > +             consume_skb(skb);
> > +             return NULL;
> > +     }
> > +
> >       /* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
> >       mini_qdisc_bstats_cpu_update(miniq, skb);
> >
> > @@ -3620,22 +3649,26 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> >               mini_qdisc_qstats_cpu_drop(miniq);
> >               *ret = NET_XMIT_DROP;
> >               kfree_skb(skb);
> > -             return NULL;
> > +             skb = NULL;
> > +             break;
> >       case TC_ACT_STOLEN:
> >       case TC_ACT_QUEUED:
> >       case TC_ACT_TRAP:
> >               *ret = NET_XMIT_SUCCESS;
> >               consume_skb(skb);
> > -             return NULL;
> > +             skb = NULL;
> > +             break;
> >       case TC_ACT_REDIRECT:
> >               /* No need to push/pop skb's mac_header here on egress! */
> >               skb_do_redirect(skb);
> >               *ret = NET_XMIT_SUCCESS;
> > -             return NULL;
> > +             skb = NULL;
> > +             break;
> >       default:
> >               break;
> >       }
> >
> > +     sch_dec_recur_level();
> >       return skb;
> >  }
> >  #endif /* CONFIG_NET_EGRESS */
> > @@ -4670,6 +4703,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
> >  #ifdef CONFIG_NET_CLS_ACT
> >       struct mini_Qdisc *miniq = rcu_dereference_bh(skb->dev->miniq_ingress);
> >       struct tcf_result cl_res;
> > +     int err;
> >
> >       /* If there's at least one ingress present somewhere (so
> >        * we get here via enabled static key), remaining devices
> > @@ -4679,6 +4713,14 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
> >       if (!miniq)
> >               return skb;
> >
> > +     err = sch_check_inc_recur_level();
> > +     if (err) {
> > +             sch_dec_recur_level();
> > +             *ret = NET_XMIT_DROP;
> > +             consume_skb(skb);
> > +             return NULL;
> > +     }
> > +
> >       if (*pt_prev) {
> >               *ret = deliver_skb(skb, *pt_prev, orig_dev);
> >               *pt_prev = NULL;
> > @@ -4696,12 +4738,14 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
> >       case TC_ACT_SHOT:
> >               mini_qdisc_qstats_cpu_drop(miniq);
> >               kfree_skb(skb);
> > -             return NULL;
> > +             skb = NULL;
> > +             break;
> >       case TC_ACT_STOLEN:
> >       case TC_ACT_QUEUED:
> >       case TC_ACT_TRAP:
> >               consume_skb(skb);
> > -             return NULL;
> > +             skb = NULL;
> > +             break;
> >       case TC_ACT_REDIRECT:
> >               /* skb_mac_header check was done by cls/act_bpf, so
> >                * we can safely push the L2 header back before
> > @@ -4709,14 +4753,18 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
> >                */
> >               __skb_push(skb, skb->mac_len);
> >               skb_do_redirect(skb);
> > -             return NULL;
> > +             skb = NULL;
> > +             break;
> >       case TC_ACT_REINSERT:
> >               /* this does not scrub the packet, and updates stats on error */
> >               skb_tc_reinsert(skb, &cl_res);
> > -             return NULL;
> > +             skb = NULL;
> > +             break;
> >       default:
> >               break;
> >       }
> > +
> > +     sch_dec_recur_level();
> >  #endif /* CONFIG_NET_CLS_ACT */
> >       return skb;
> >  }
> >
>
