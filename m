Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412C642F4D8
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 16:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240062AbhJOOKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 10:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbhJOOKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 10:10:19 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B094C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 07:08:12 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id a7so23077624yba.6
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 07:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EknDO0Lxqz6goVyoL+OLdAwbHcz+DtZ3AhFPKmQIGZA=;
        b=GnLX0gwcfrTy2zaj88HAZOrHHfSHJfJpoRc3a4V/JoRFsVzAeUxvwNtQDt32bnR1um
         NQpVChIEDhbaTmw7HPNqwVAF2Ff1qNoUbweG7tOAG2jrmRCf0MqDrFbs7giYFtV0ZyIY
         OcM0JJTHnfVwyB5uZP5QFViPf6DJUjZI/nse3bVc1Rqpchrhd4MIsUi5O/2CYea9VnYM
         TuyGpx3yEk/ibjeuLVWhuVH5iZxk4AJwzQPDjPo81oNOthIDIIe22hp6YiJZEH8Mx4Vq
         TNNnl3DYQ5L04mtgCgeZ3qYiHtooJqQKWyNn+IssQAPmebWpvn+aEt7WQHzL4PmxmU3X
         43/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EknDO0Lxqz6goVyoL+OLdAwbHcz+DtZ3AhFPKmQIGZA=;
        b=x6glHXK+/ZE/5/6URTaL73bLhAyJuP4HFQg3FecQbg5fgr6dux89NCyGtKGckSf/5n
         ADPgxndJoS6OiLSf00vqe54DiXrRNycYj4cvv5GMA961YdWofI/2YhGMd8MABJtulyyv
         8FYgh2vsiB9jlszmb20VmcSvjO1UJrProb+v68EZjbMRCXsNgEFGPHkXJM5RMGbQGPAI
         oKhjKm+7zX+enPw0ZomC7coUl4Wmjn6DNNK3aSz8XWDlpYhqukAaNEDt5G5c12XldT4E
         W3gFuV21aRHGtWVxKnoRlU8WZBX+il4KkzZAIuf+qbK5GSb659GIOgKz1adHvZOXuSxm
         uofQ==
X-Gm-Message-State: AOAM532k9wUX3QSVY/Ta0fIBz+BZfieo1nOBHPACCGees31bMXQ0Facy
        HlK1yvcoP0GIZw/i0SO5CoeC3vgWhlWhjGxLadJBqg==
X-Google-Smtp-Source: ABdhPJxvijjPYU+5dAGtG2AEIvtztA/BfZ7EcR3x6oEPn5xoTGRpVddCSzLuNdHSxOIuGswTYE6PNLDz10JQZ1U4L5w=
X-Received: by 2002:a5b:783:: with SMTP id b3mr13360982ybq.328.1634306891258;
 Fri, 15 Oct 2021 07:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com> <9608bf7c-a6a2-2a30-2d96-96bd1dfb25e3@bobbriscoe.net>
In-Reply-To: <9608bf7c-a6a2-2a30-2d96-96bd1dfb25e3@bobbriscoe.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 15 Oct 2021 07:08:00 -0700
Message-ID: <CANn89iKavhJGi0NE873v+qCjZL=NRbMjVCsLJJv2o9nXyDSmUQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
To:     Bob Briscoe <ietf@bobbriscoe.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 5:59 AM Bob Briscoe <ietf@bobbriscoe.net> wrote:
>
> Eric,
>
> Because the threshold is in time units, I suggest the condition for
> exceeding it needs to be AND'd with (*backlog > mtu), otherwise you can
> get 100% solid marking at low link rates.
>
> When ce_threshold is for DCs, low link rates are unlikely.
> However, given ce_threshold_ect1 is mainly for the Internet, during
> testing with 1ms threshold we encountered solid marking at low link
> rates, so we had to add a 1 packet floor:
> https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726.pdf
>
> Sorry to chime in after your patch went to net-next.
>

What you describe about a minimal backlog was already there with
ce_threshold handling ?

Or is it something exclusive to L4S ?

This deserves a separate patch, if anything :)


>
> Bob
>
>
> On 14/10/2021 18:59, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Add TCA_FQ_CODEL_CE_THRESHOLD_ECT1 boolean option to select Low Latency,
> > Low Loss, Scalable Throughput (L4S) style marking, along with ce_threshold.
> >
> > If enabled, only packets with ECT(1) can be transformed to CE
> > if their sojourn time is above the ce_threshold.
> >
> > Note that this new option does not change rules for codel law.
> > In particular, if TCA_FQ_CODEL_ECN is left enabled (this is
> > the default when fq_codel qdisc is created), ECT(0) packets can
> > still get CE if codel law (as governed by limit/target) decides so.
> >
> > Section 4.3.b of current draft [1] states:
> >
> > b.  A scheduler with per-flow queues such as FQ-CoDel or FQ-PIE can
> >      be used for L4S.  For instance within each queue of an FQ-CoDel
> >      system, as well as a CoDel AQM, there is typically also ECN
> >      marking at an immediate (unsmoothed) shallow threshold to support
> >      use in data centres (see Sec.5.2.7 of [RFC8290]).  This can be
> >      modified so that the shallow threshold is solely applied to
> >      ECT(1) packets.  Then if there is a flow of non-ECN or ECT(0)
> >      packets in the per-flow-queue, the Classic AQM (e.g.  CoDel) is
> >      applied; while if there is a flow of ECT(1) packets in the queue,
> >      the shallower (typically sub-millisecond) threshold is applied.
> >
> > Tested:
> >
> > tc qd replace dev eth1 root fq_codel ce_threshold_ect1 50usec
> >
> > netperf ... -t TCP_STREAM -- K dctcp
> >
> > tc -s -d qd sh dev eth1
> > qdisc fq_codel 8022: root refcnt 32 limit 10240p flows 1024 quantum 9212 target 5ms ce_threshold_ect1 49us interval 100ms memory_limit 32Mb ecn drop_batch 64
> >   Sent 14388596616 bytes 9543449 pkt (dropped 0, overlimits 0 requeues 152013)
> >   backlog 0b 0p requeues 152013
> >    maxpacket 68130 drop_overlimit 0 new_flow_count 95678 ecn_mark 0 ce_mark 7639
> >    new_flows_len 0 old_flows_len 0
> >
> > [1] L4S current draft:
> > https://datatracker.ietf.org/doc/html/draft-ietf-tsvwg-l4s-arch
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > Cc: Ingemar Johansson S <ingemar.s.johansson@ericsson.com>
> > Cc: Tom Henderson <tomh@tomh.org>
> > Cc: Bob Briscoe <in@bobbriscoe.net>
> > ---
> >   include/net/codel.h            |  2 ++
> >   include/net/codel_impl.h       | 18 +++++++++++++++---
> >   include/uapi/linux/pkt_sched.h |  1 +
> >   net/mac80211/sta_info.c        |  1 +
> >   net/sched/sch_fq_codel.c       | 15 +++++++++++----
> >   5 files changed, 30 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/net/codel.h b/include/net/codel.h
> > index a6e428f801350809322aaff08d92904e059c3b5a..5e8b181b76b829d6af3c57809d9bc5f0578dd112 100644
> > --- a/include/net/codel.h
> > +++ b/include/net/codel.h
> > @@ -102,6 +102,7 @@ static inline u32 codel_time_to_us(codel_time_t val)
> >    * @interval:       width of moving time window
> >    * @mtu:    device mtu, or minimal queue backlog in bytes.
> >    * @ecn:    is Explicit Congestion Notification enabled
> > + * @ce_threshold_ect1: if ce_threshold only marks ECT(1) packets
> >    */
> >   struct codel_params {
> >       codel_time_t    target;
> > @@ -109,6 +110,7 @@ struct codel_params {
> >       codel_time_t    interval;
> >       u32             mtu;
> >       bool            ecn;
> > +     bool            ce_threshold_ect1;
> >   };
> >
> >   /**
> > diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
> > index d289b91dcd65ecdc96dc0c9bf85d4a4be6961022..7af2c3eb3c43c24364519120aad5be77522854a6 100644
> > --- a/include/net/codel_impl.h
> > +++ b/include/net/codel_impl.h
> > @@ -54,6 +54,7 @@ static void codel_params_init(struct codel_params *params)
> >       params->interval = MS2TIME(100);
> >       params->target = MS2TIME(5);
> >       params->ce_threshold = CODEL_DISABLED_THRESHOLD;
> > +     params->ce_threshold_ect1 = false;
> >       params->ecn = false;
> >   }
> >
> > @@ -246,9 +247,20 @@ static struct sk_buff *codel_dequeue(void *ctx,
> >                                                   vars->rec_inv_sqrt);
> >       }
> >   end:
> > -     if (skb && codel_time_after(vars->ldelay, params->ce_threshold) &&
> > -         INET_ECN_set_ce(skb))
> > -             stats->ce_mark++;
> > +     if (skb && codel_time_after(vars->ldelay, params->ce_threshold)) {
> > +             bool set_ce = true;
> > +
> > +             if (params->ce_threshold_ect1) {
> > +                     /* Note: if skb_get_dsfield() returns -1, following
> > +                      * gives INET_ECN_MASK, which is != INET_ECN_ECT_1.
> > +                      */
> > +                     u8 ecn = skb_get_dsfield(skb) & INET_ECN_MASK;
> > +
> > +                     set_ce = (ecn == INET_ECN_ECT_1);
> > +             }
> > +             if (set_ce && INET_ECN_set_ce(skb))
> > +                     stats->ce_mark++;
> > +     }
> >       return skb;
> >   }
> >
> > diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> > index ec88590b3198441f18cc9def7bd40c48f0bc82a1..6be9a84cccfa79bace1f3f7123d02f484b67a25e 100644
> > --- a/include/uapi/linux/pkt_sched.h
> > +++ b/include/uapi/linux/pkt_sched.h
> > @@ -840,6 +840,7 @@ enum {
> >       TCA_FQ_CODEL_CE_THRESHOLD,
> >       TCA_FQ_CODEL_DROP_BATCH_SIZE,
> >       TCA_FQ_CODEL_MEMORY_LIMIT,
> > +     TCA_FQ_CODEL_CE_THRESHOLD_ECT1,
> >       __TCA_FQ_CODEL_MAX
> >   };
> >
> > diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> > index 2b5acb37587f7068e2d11fe842ec963a556f1eb1..a39830418434d4bb74d238373f63a4858230fce5 100644
> > --- a/net/mac80211/sta_info.c
> > +++ b/net/mac80211/sta_info.c
> > @@ -513,6 +513,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
> >       sta->cparams.target = MS2TIME(20);
> >       sta->cparams.interval = MS2TIME(100);
> >       sta->cparams.ecn = true;
> > +     sta->cparams.ce_threshold_ect1 = false;
> >
> >       sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
> >
> > diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
> > index bb0cd6d3d2c2749d54e26368fb2558beedea85c9..033d65d06eb136ff704cddd3ee950a5c3a5d9831 100644
> > --- a/net/sched/sch_fq_codel.c
> > +++ b/net/sched/sch_fq_codel.c
> > @@ -362,6 +362,7 @@ static const struct nla_policy fq_codel_policy[TCA_FQ_CODEL_MAX + 1] = {
> >       [TCA_FQ_CODEL_CE_THRESHOLD] = { .type = NLA_U32 },
> >       [TCA_FQ_CODEL_DROP_BATCH_SIZE] = { .type = NLA_U32 },
> >       [TCA_FQ_CODEL_MEMORY_LIMIT] = { .type = NLA_U32 },
> > +     [TCA_FQ_CODEL_CE_THRESHOLD_ECT1] = { .type = NLA_U8 },
> >   };
> >
> >   static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
> > @@ -408,6 +409,9 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
> >               q->cparams.ce_threshold = (val * NSEC_PER_USEC) >> CODEL_SHIFT;
> >       }
> >
> > +     if (tb[TCA_FQ_CODEL_CE_THRESHOLD_ECT1])
> > +             q->cparams.ce_threshold_ect1 = !!nla_get_u8(tb[TCA_FQ_CODEL_CE_THRESHOLD_ECT1]);
> > +
> >       if (tb[TCA_FQ_CODEL_INTERVAL]) {
> >               u64 interval = nla_get_u32(tb[TCA_FQ_CODEL_INTERVAL]);
> >
> > @@ -544,10 +548,13 @@ static int fq_codel_dump(struct Qdisc *sch, struct sk_buff *skb)
> >                       q->flows_cnt))
> >               goto nla_put_failure;
> >
> > -     if (q->cparams.ce_threshold != CODEL_DISABLED_THRESHOLD &&
> > -         nla_put_u32(skb, TCA_FQ_CODEL_CE_THRESHOLD,
> > -                     codel_time_to_us(q->cparams.ce_threshold)))
> > -             goto nla_put_failure;
> > +     if (q->cparams.ce_threshold != CODEL_DISABLED_THRESHOLD) {
> > +             if (nla_put_u32(skb, TCA_FQ_CODEL_CE_THRESHOLD,
> > +                             codel_time_to_us(q->cparams.ce_threshold)))
> > +                     goto nla_put_failure;
> > +             if (nla_put_u8(skb, TCA_FQ_CODEL_CE_THRESHOLD_ECT1, q->cparams.ce_threshold_ect1))
> > +                     goto nla_put_failure;
> > +     }
> >
> >       return nla_nest_end(skb, opts);
> >
>
> --
> ________________________________________________________________
> Bob Briscoe                               http://bobbriscoe.net/
>
