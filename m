Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1032EF7A1
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbhAHSqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbhAHSqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:46:35 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44142C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:45:55 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id q1so11238176ilt.6
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GxUfRyuTPxVrCCGePmmFFitKQEftWvBnavnssBc4Aig=;
        b=E+mF052pil7+9hXec3kIWtV03Zwf6FkJw1r03uE75jO4XEV1WW8vdZmc+U7I/j+xZx
         awBX318w0QgvkvGzDr75xmnzvS76jYLHTNsuA5qkmWPQTPM4guVEVkBNGTjdKLxLoXgw
         k6UJWrSKJ707HBk/yUQRKMioHH6STHPIqUYOjQCPUZTZGrgWnbGNSPfaQFQ/YowGGqzB
         FAAli63roPiwQbLi1PQ3tyug3xzsuSXr/LwxJNV0obvuk/n4xyc/v9Qn+VAGzmH7NUMr
         L5cn5GW+1IhhahtCNj6ZV3TxjWmEbhaulMlLew+GNSWueHTSZ0IC8+uoJmBb0NmXykTC
         GLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GxUfRyuTPxVrCCGePmmFFitKQEftWvBnavnssBc4Aig=;
        b=gz7TcIkVAvyjgmHxJbF3A10rK1b364AQjWKQKUSx0ClvCQgq0Q1HTayRrlmE5xAICR
         dPjWvdDUMb1eyv+o6+Vyq4/MhnNW8NsVd3POw+Ei3htcnckYQImraGYwuBLeYjvDiIkY
         f2Z1rP6S/dxdzUH49aYOuZnUHER2h+xh/L/947v6A4uDUn9lx4tfTAOx/HZ+IKhv2J9s
         1zv72jDwLqZVmiOCQNN4f+zhTzgXQHKYu0zIF4TnyPuPxXsV4hZt9leNa97q7ZqLGP4W
         pghyR/OB9V5J+dDhaPhVn5tpB/DZTVxky974JtpKSqC6ZEf9H36CTvaIuuyLPMVKiHpc
         vhKA==
X-Gm-Message-State: AOAM533LLMw23zYQdd1OvrVbUIhP7K3CUPcpsOFW0RM+OaAfnWakkOk8
        65mwLOi5E01/h8VE42b1wGsmxGFtJST6qSL5lrKZLWjpYpfQAw==
X-Google-Smtp-Source: ABdhPJxYJrROJVQzMsC1f84cva+Nai4diMkoX08bgz6sdKNsVPEZjrpcb+EX8aw7kQ03PdMx23BPstTh93vGEY0nFV4=
X-Received: by 2002:a05:6e02:1a6d:: with SMTP id w13mr4960928ilv.69.1610131554387;
 Fri, 08 Jan 2021 10:45:54 -0800 (PST)
MIME-Version: 1.0
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
 <20210106215539.2103688-2-jesse.brandeburg@intel.com> <CANn89iLcRrmXW_MGjuMMnNxWS+kaEnY=Y79hCPuiwiDd_G9=EA@mail.gmail.com>
 <20210108103537.00005168@intel.com>
In-Reply-To: <20210108103537.00005168@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 19:45:41 +0100
Message-ID: <CANn89iL8KZGQhNbwwYRS2POkc_VEiSCecOyaCF4z95=StRn_xQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/2] net: core: count drops from GRO
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev <netdev@vger.kernel.org>, intel-wired-lan@lists.osuosl.org,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 7:35 PM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> Eric Dumazet wrote:
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -6071,6 +6071,7 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
> > >                 break;
> > >
> > >         case GRO_DROP:
> > > +               atomic_long_inc(&skb->dev->rx_dropped);
> > >                 kfree_skb(skb);
> > >                 break;
> > >
> > > @@ -6159,6 +6160,7 @@ static gro_result_t napi_frags_finish(struct napi_struct *napi,
> > >                 break;
> > >
> > >         case GRO_DROP:
> > > +               atomic_long_inc(&skb->dev->rx_dropped);
> > >                 napi_reuse_skb(napi, skb);
> > >                 break;
> > >
> >
> >
> > This is not needed. I think we should clean up ice instead.
>
> My patch 2 already did that. I was trying to address the fact that I'm
> *actually seeing* GRO_DROP return codes coming back from stack.
>
> I'll try to reproduce that issue again that I saw. Maybe modern kernels
> don't have the problem as frequently or at all.


Jesse, you are sending a patch for current kernels.

It is pretty clear that the issue you have can not happen with current
kernels, by reading the code source,
even without an actual ICE piece of hardware to test this :)

>
> > Drivers are supposed to have allocated the skb (using
> > napi_get_frags()) before calling napi_gro_frags()
>
> ice doesn't use napi_get_frags/napi_gro_frags, so I'm not sure how this
> is relevant.
>
> > Only napi_gro_frags() would return GRO_DROP, but we supposedly could
> > crash at that point, since a driver is clearly buggy.
>
> seems unlikely since we don't call those functions.
>
> > We probably can remove GRO_DROP completely, assuming lazy drivers are fixed.
>
> This might be ok, but doesn't explain why I was seeing this return
> code (which was the whole reason I was trying to count them), however I
> may have been running on a distro kernel from redhat/centos 8 when I
> was seeing these events. I haven't fully completed spelunking all the
> different sources, but might be able to follow down the rabbit hole
> further.

Yes please :)

>
>
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 8fa739259041aaa03585b5a7b8ebce862f4b7d1d..c9460c9597f1de51957fdcfc7a64ca45bce5af7c
> > 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6223,9 +6223,6 @@ gro_result_t napi_gro_frags(struct napi_struct *napi)
> >         gro_result_t ret;
> >         struct sk_buff *skb = napi_frags_skb(napi);
> >
> > -       if (!skb)
> > -               return GRO_DROP;
> > -
> >         trace_napi_gro_frags_entry(skb);
> >
> >         ret = napi_frags_finish(napi, skb, dev_gro_receive(napi, skb));
>
> This change (noted from your other patches is fine), and a likely
> improvement, thanks for sending those!

Sure !
