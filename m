Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8DD67CAF
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 04:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfGNCXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 22:23:42 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45034 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbfGNCXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 22:23:42 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so6146393pgl.11
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 19:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XrHoy11RvrOO+et8+bRO533s0q9/C4Kd/0y9v0lpdtk=;
        b=URyOTN5Luh8qrh4gC0B76I55UWIIw2DjXU0paLnAOwXc89apnQp7BsoYHJW+JHLFgf
         NDzhClHO3TMlFC1QPc7fAdWag/RWG7HQz686oxRX+6Icmdp3vXbeBnCTkW9yN8zDmidP
         x3JY7Y2HH+PLRKkzl4ASzR1grvG1UpVgbvomcvftx429sk2v3IrRzcSs99zCMS5M3sOm
         Nth1nmq9P0Sq5DpARXdEtdmiqYlnHlJB2wuHvZPBL0zhvArNOfd+Pl4MeRUs7V4RdU36
         cjPHHAeCLaJFYXFKrABEFeJiLWE2wTcjIIH+xdtSKZ/QXUY2d1W/onOI+gjXVECMqydw
         JxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XrHoy11RvrOO+et8+bRO533s0q9/C4Kd/0y9v0lpdtk=;
        b=oTDGlNxSZyXMZ0frx8IlHx+ujQ/E6MogU+vcl4y94HjIKLlWtypqCGXHX7+lxcbbOm
         1VvPpnobDoNv3vqmPJyag26cGa/HiNw2I5oH4u4GPbjtWh7G4OExOVMUq4wJLUKf062+
         ClEJJYq8m6COs2sEdMuT3Yt1h3DenMFcRp4ZVVDzXFW9YIuWsjYaGWrpk0I/W5OvWW6y
         ucal1xldwy3hNJA85Y8c6Xq3WCA9ac3lbdD4cnBMnOUZCINOlF2Wl9+KeR2C7lYWNpvv
         i8LuKuifXZsW4LMxtmTEBuLPLbIbr7AawEXtPfY2wFtKlfXEVjj9Y6nzZoJhtQu3ePBw
         EINw==
X-Gm-Message-State: APjAAAVcMHcdBZ8B4x20L6R/rlqq0OVA8oinUY+KZvC3QttDficngp+D
        aoAz5djaj7Ug2a/dBUmykrT1d46WEhL/HMwCQAY8S2z7
X-Google-Smtp-Source: APXvYqwi7tcEZ8AGSu27F4pfN3mRrRhKjVAyaGchD7tk8wBRtwyusq8G95GmHju8R9UbeCv9xjhSSUFzgfZ4MEh3b2M=
X-Received: by 2002:a63:8a43:: with SMTP id y64mr19412267pgd.104.1563071021375;
 Sat, 13 Jul 2019 19:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190712201749.28421-1-xiyou.wangcong@gmail.com> <8733195c-ac70-4a2a-db2f-b9bdfd05a703@gmail.com>
In-Reply-To: <8733195c-ac70-4a2a-db2f-b9bdfd05a703@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 13 Jul 2019 19:23:30 -0700
Message-ID: <CAM_iQpUwAcqyFw0dGAJWvKWaGzV2YGD_oJHYrae3aCt-BE9ong@mail.gmail.com>
Subject: Re: [Patch net] net_sched: unset TCQ_F_CAN_BYPASS when adding filters
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 13, 2019 at 5:54 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 7/12/19 10:17 PM, Cong Wang wrote:
> > For qdisc's that support TC filters and set TCQ_F_CAN_BYPASS,
> > notably fq_codel, it makes no sense to let packets bypass the TC
> > filters we setup in any scenario, otherwise our packets steering
> > policy could not be enforced.
> >
> > This can be easily reproduced with the following script:
> >
> >  ip li add dev dummy0 type dummy
> >  ifconfig dummy0 up
> >  tc qd add dev dummy0 root fq_codel
> >  tc filter add dev dummy0 parent 8001: protocol arp basic action mirred egress redirect dev lo
> >  tc filter add dev dummy0 parent 8001: protocol ip basic action mirred egress redirect dev lo
> >  ping -I dummy0 192.168.112.1
> >
> > Without this patch, packets are sent directly to dummy0 without
> > hitting any of the filters. With this patch, packets are redirected
> > to loopback as expected.
> >
> > This fix is not perfect, it only unsets the flag but does not set it back
> > because we have to save the information somewhere in the qdisc if we
> > really want that.
> >
> > Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
> > Cc: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > ---
> >  net/sched/cls_api.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> > index 638c1bc1ea1b..5c800b0c810b 100644
> > --- a/net/sched/cls_api.c
> > +++ b/net/sched/cls_api.c
> > @@ -2152,6 +2152,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
> >               tfilter_notify(net, skb, n, tp, block, q, parent, fh,
> >                              RTM_NEWTFILTER, false, rtnl_held);
> >               tfilter_put(tp, fh);
> > +             q->flags &= ~TCQ_F_CAN_BYPASS;
> >       }
> >
> >  errout:
> >
>
> Strange, because sfq and fq_codel are roughly the same for TCQ_F_CAN_BYPASS handling.
>
> Why is fq_codel_bind() not effective ?

Because I don't have class id set in the filter.

>
> If not effective, sfq had the same issue, so the Fixes: tag needs to be refined,
> maybe to commit 23624935e0c4 net_sched: TCQ_F_CAN_BYPASS generalization
>

Yeah, I think it is probably a better commit here.

Thanks.
