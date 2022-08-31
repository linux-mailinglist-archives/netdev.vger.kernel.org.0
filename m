Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5335A8401
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 19:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiHaRI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 13:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiHaRIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 13:08:55 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D98C6FEB
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 10:08:55 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 21so5084172ybl.6
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 10:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=zftIQ411D/F+q8QhoQwsILwL9NsdWWrYVbDr2LyC+Ag=;
        b=OQ7sKCmxPyWKCDN5gUarxjhFYd1O4pOph4TbiOP/usrlDrDxDZ/Lkqk4RvcIg1yqb2
         87Y598LALYgpF3y5oor4fgJv6Z9xgMYkaodCZbSQY9fD0FrPd8FbIs7uvzDQLnlzrkjX
         c01YOnh8XQbuuZa5detMGe6+1oJGccmePC9jwWaCKjQHP+Y6aGPK+QzBtgWlRsO4LUh7
         oa415oD6dIyw8872X+zSQiwBvCloZS4btS1yk1pmrMva8uIY7LAHOc0U1hYvpgyZbXWA
         A/fQ0qpLvy2jqNlznSadD4JgCkYxA5wLwB3ufQeOLKHQTyy9iC15CP1bw3EXIVumgoA3
         ALBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=zftIQ411D/F+q8QhoQwsILwL9NsdWWrYVbDr2LyC+Ag=;
        b=slqI7JCJGAp/70jUy7/v0FGgpxHecLzbnwywt2X3c/qudZ9ahUXK6MlSjcvJCYgObW
         /JZ+Lai+mGfCnC0mcoj+9b2z6oHqb8UUWrGUf1MaB5avUvgHVuUnLmFCey61ClEELxSV
         0Dl4D1W7qtgDjjVnZrOyk89JBc0k61YlX1sb8soc78dPm1x67DCFUkzKD6UmV3eBeQ8H
         GPeKxM/jLDW21vtH+PqtDOvBO4GCtDsWsGMmksinFKosjfr6b23ntTXOWoVxmNqEIkYi
         Twm88JwXLjL9w1+FoZN/q7l0DFQd1ycGJF8NjDsFWomkBTutLmYgCDdhjY3ABsGPxqnW
         iq2A==
X-Gm-Message-State: ACgBeo0sDjbJw7GsWwna5ErRH69aZJ1gkEuznFzM3ROfupYVn2vC2rqG
        Xaby3fuquUuRCMiCKvfkNrqk8gmuweDcY+A36+peGg==
X-Google-Smtp-Source: AA6agR4bpTI9OyQMRsa/Sv5Ts/rONTlAjKcYdn/SaPSeJ8HtCSTWSqVEIb5kQseLtBokc7e3e9iApAvkakWAKjEc28o=
X-Received: by 2002:a25:4291:0:b0:696:56f3:5934 with SMTP id
 p139-20020a254291000000b0069656f35934mr16104965yba.55.1661965733674; Wed, 31
 Aug 2022 10:08:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220831092103.442868-1-toke@toke.dk>
In-Reply-To: <20220831092103.442868-1-toke@toke.dk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 31 Aug 2022 10:08:42 -0700
Message-ID: <CANn89iKiJ91D7fELw9iKB4yCLaDj-WEv27wRS4PtLqM7oK8m=w@mail.gmail.com>
Subject: Re: [PATCH net] sch_cake: Return __NET_XMIT_STOLEN when consuming
 enqueued skb
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cake@lists.bufferbloat.net,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Aug 31, 2022 at 2:25 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=
.dk> wrote:
>
> When the GSO splitting feature of sch_cake is enabled, GSO superpackets
> will be broken up and the resulting segments enqueued in place of the
> original skb. In this case, CAKE calls consume_skb() on the original skb,
> but still returns NET_XMIT_SUCCESS. This can confuse parent qdiscs into
> assuming the original skb still exists, when it really has been freed. Fi=
x
> this by adding the __NET_XMIT_STOLEN flag to the return value in this cas=
e.
>

I think you forgot to give credits to the team who discovered this issue.

Something like this

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-18231



> Fixes: 0c850344d388 ("sch_cake: Conditionally split GSO segments")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> ---
>  net/sched/sch_cake.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
> index a43a58a73d09..a04928082e4a 100644
> --- a/net/sched/sch_cake.c
> +++ b/net/sched/sch_cake.c
> @@ -1713,6 +1713,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct=
 Qdisc *sch,
>         }
>         idx--;
>         flow =3D &b->flows[idx];
> +       ret =3D NET_XMIT_SUCCESS;
>
>         /* ensure shaper state isn't stale */
>         if (!b->tin_backlog) {
> @@ -1771,6 +1772,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct=
 Qdisc *sch,
>
>                 qdisc_tree_reduce_backlog(sch, 1-numsegs, len-slen);
>                 consume_skb(skb);
> +               ret |=3D __NET_XMIT_STOLEN;
>         } else {
>                 /* not splitting */
>                 cobalt_set_enqueue_time(skb, now);
> @@ -1904,7 +1906,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct=
 Qdisc *sch,
>                 }
>                 b->drop_overlimit +=3D dropped;
>         }
> -       return NET_XMIT_SUCCESS;
> +       return ret;
>  }
>
>  static struct sk_buff *cake_dequeue_one(struct Qdisc *sch)
> --
> 2.37.2
>
