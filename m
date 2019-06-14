Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5294647B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbfFNQkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:40:31 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35265 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfFNQkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 12:40:31 -0400
Received: by mail-pl1-f194.google.com with SMTP id p1so1243991plo.2
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 09:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IX90swC7hftdPTwLwP0qHVUYL7Fmqz1424fsCkB1o+c=;
        b=Cm/IFGaNgy0caHy/mW8NywZ1gdQyhTyUwuCO9nV1q9W3kH/492BFsctKCRSvXLS2S4
         B16cjJ/KGpC9Hhmqjbg4a8difj+MRnX9CwaQb8pVZOrUlpOfLIBWlkhFhrXosoQ+76T/
         izBcn1XV3EtbNdZoJA0cQ5RwEwBt1qcH6mt6+GqHBSyqUjmg+crSuwOj3fulVI5Hvwzz
         0H/4R9TCkAX11H12qbzZWgXJiZipGhCR55B0ih8jtR6fdJIELoosrjvyjdQLraNX9VJS
         oB/QvcZtjpxWtyWKkhpO8Pb2ytJj53JDaqMw0I37CF4y5d8xRLp9lzYaJgcgPW2bOyBj
         6rmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IX90swC7hftdPTwLwP0qHVUYL7Fmqz1424fsCkB1o+c=;
        b=pHMCCBpAWQf6bc/cHKNeFkJi7vgm5UiUUM1d1egFiL2rwSifx963qvyQ9F3cZNAwww
         XiQvrAYWwnbtSmFxoXu/Z6DHK2hPTs2Euo6b/jfbrpTzhdT5wVqgMO4+uXqC60VFOi2w
         BxTKBwio6NpRkZgOQHe0x4ffc/SHB40VGQtAtdXq40pV6VW1sMpFlCNYSocIEa2bRxQ5
         I8Z7zjahScB3FvrZIT5b1bQkn+blVnDDFjH7U391RLA/uRTsDHasa7BY28TdLjHJC9pZ
         stoRW1Ba2C1ijRH4pKsG9xN/fiJuLvHCOWye7M4Vj1stKvh5LjU6ac1GNNrnQx690nCq
         us1g==
X-Gm-Message-State: APjAAAUS4EFc10cfwKIdTSdOvki7ysML3O3G73sNAmPBFJVAt+6TrIL6
        rCbXsEmHNjSIKUUtzq9ksjKsbfqHNgYtm0VttfY=
X-Google-Smtp-Source: APXvYqzB9nq144eVvKQuSzykNI79XgdNfSCoBLQ1Inx4t7HgAIEDXpRfeNVvfKuSKiULek/8ZtgOTdK2Ce9VVyCTdZI=
X-Received: by 2002:a17:902:5c2:: with SMTP id f60mr93714889plf.61.1560530430772;
 Fri, 14 Jun 2019 09:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190612185121.4175-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190612185121.4175-1-jakub.kicinski@netronome.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 14 Jun 2019 09:40:18 -0700
Message-ID: <CAM_iQpXoKnP+Xj0CMQf08nBCnbPEVu=uTbgCk98C380pYSUetA@mail.gmail.com>
Subject: Re: [PATCH net] net: netem: fix use after free and double free with
 packet corruption
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        netem@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Eric Dumazet <edumazet@google.com>,
        posk@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 11:52 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> Brendan reports that the use of netem's packet corruption capability
> leads to strange crashes.  This seems to be caused by
> commit d66280b12bd7 ("net: netem: use a list in addition to rbtree")
> which uses skb->next pointer to construct a fast-path queue of
> in-order skbs.
>
> Packet corruption code has to invoke skb_gso_segment() in case
> of skbs in need of GSO.  skb_gso_segment() returns a list of
> skbs.  If next pointers of the skbs on that list do not get cleared
> fast path list goes into the weeds and tries to access the next
> segment skb multiple times.

Mind to be more specific? How could it be accessed multiple times?

>
> Reported-by: Brendan Galloway <brendan.galloway@netronome.com>
> Fixes: d66280b12bd7 ("net: netem: use a list in addition to rbtree")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> ---
>  net/sched/sch_netem.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
> index 956ff3da81f4..1fd4405611e5 100644
> --- a/net/sched/sch_netem.c
> +++ b/net/sched/sch_netem.c
> @@ -494,16 +494,13 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>          */
>         if (q->corrupt && q->corrupt >= get_crandom(&q->corrupt_cor)) {
>                 if (skb_is_gso(skb)) {
> -                       segs = netem_segment(skb, sch, to_free);
> -                       if (!segs)
> +                       skb = netem_segment(skb, sch, to_free);
> +                       if (!skb)
>                                 return rc_drop;
> -               } else {
> -                       segs = skb;
> +                       segs = skb->next;
> +                       skb_mark_not_on_list(skb);
>                 }
>
> -               skb = segs;
> -               segs = segs->next;
> -

I don't see how this works when we hit goto finish_segs?
Either goto finish_segs can be removed or needs to be fixed?

Thanks.
