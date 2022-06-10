Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D14545D8A
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347025AbiFJHdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346826AbiFJHcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:32:51 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDB712C94B
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 00:32:32 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id t32so1136749ybt.12
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 00:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VpciQYHvryj/PequWAT65fK8eJ0KET3ZyhRRjOWqX1M=;
        b=UQ/yeNEKOtigurLd3J5UurzMzK/E0NubjoHgaLV+IJcD/aIMXKfBefiPuvfEu1Xp94
         oao/op3nyn/VBSVwZYQ9FboihtQcWlOGwGbhJEX3Ypq0CJDExUsCR726Oqua5Z8X+Bd3
         klgenZZQ7M2aOLizpFGil8fRF5QP8nA4zixyH8sZ2X+Hi3OQTasZPW7XIjCxORtrUi7f
         j9LGi8hfxudJgV/noJCWT24jBloCNlc6+Hlt0bNWiZVrb8VGz9pw5PFUypzoEeV+A1hx
         rhpTqPtB0beClKdRNPHpqt/lW1DO6YlKlxpbAKi5bxLsB9Ab7cXnUo8B/CGc2k+33JqQ
         WBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VpciQYHvryj/PequWAT65fK8eJ0KET3ZyhRRjOWqX1M=;
        b=cjqZqRyePE/Md2GcR8AVwR6qRP4kS89pFkW/xxVXbrqqdRK16z9cQBSbq8x5PYAbyC
         fQagGeeMnbHLCNaWviUE40g9np/GrTJ0aCY8Zp2f+jvjVS+/NEfpn1EDeEDZ4PwcgFi+
         1ID2OjvZs2rc4R1dMQrfDLAe7lyaUxmPVEA7NUiLUxK/JP0YrTHBU0QCrZjWbHXGNDAn
         nFNWbN9zc2Tpu8hErvsv91vf1cTohaIb3o2HEG/yAoKIYvWzSq6vYnFGuXk+Cug65DSl
         A9jTUGdveiYez+d++SkNw0pcWWY2FL6G8AHkFtfOVuYK7DwRAqHk4KDiJZ9o26InCYOM
         h1Gg==
X-Gm-Message-State: AOAM532tEE0Hbasvyb7fPX63Jld0jalwPDxM67tkHYurDLwOu/Jr64w1
        eV1n7CYJiN19sJ69MGfa6ylDctrSE9uvDC5xx1yq7A==
X-Google-Smtp-Source: ABdhPJyodnCZYSm5uCy1IFU1S5PAg2DfIXbShb1DCSPfCarwHd2KuFRpUkN6RVaisqspfcszAh5pzkAxuGGPbpUlM24=
X-Received: by 2002:a05:6902:c9:b0:641:1998:9764 with SMTP id
 i9-20020a05690200c900b0064119989764mr42673115ybs.427.1654846350939; Fri, 10
 Jun 2022 00:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220610070529.1623-1-zhudi2@huawei.com>
In-Reply-To: <20220610070529.1623-1-zhudi2@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Jun 2022 00:32:19 -0700
Message-ID: <CANn89iKvXUbunP6UtNE1tNCH7FwCux22_rqwhGigvGn_64-6FA@mail.gmail.com>
Subject: Re: [PATCH] fq_codel: Discard problematic packets with pkt_len 0
To:     Di Zhu <zhudi2@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, rose.chen@huawei.com,
        syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 12:07 AM Di Zhu <zhudi2@huawei.com> wrote:
>
> Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
> skbs, that is, the flow->head is null.
> The root cause is that: when the first queued skb with pkt_len 0, backlogs
> of the flow that this skb enqueued is still 0 and if sch->limit is set to
> 0 then fq_codel_drop() will be called. At this point, the backlogs of all
> flows are all 0, so flow with idx 0 is selected to drop, but this flow have
> not any skbs.
> skb with pkt_len 0 can break existing processing logic, so just discard
> these invalid skbs.
>
> LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
>
> Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
> Signed-off-by: Di Zhu <zhudi2@huawei.com>
> ---
>  net/sched/sch_fq_codel.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
> index 839e1235db05..c0f82b7358e1 100644
> --- a/net/sched/sch_fq_codel.c
> +++ b/net/sched/sch_fq_codel.c
> @@ -191,6 +191,9 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>         unsigned int pkt_len;
>         bool memory_limited;
>
> +       if (unlikely(!qdisc_pkt_len(skb)))
> +               return qdisc_drop(skb, sch, to_free);
> +


This has been discussed in the past.

Feeding ndo_start_xmit() in hundreds of drivers with zero-length
packets will crash anyway.

We are not going to add such silly tests in all qdiscs, and then all
ndo_start_xmit(), since qdiscs are not mandatory.

Please instead fix BPF layer, instead of hundreds of drivers/qdiscs.
