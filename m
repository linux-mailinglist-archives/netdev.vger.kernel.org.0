Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5D71EE59C
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 15:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgFDNsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 09:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbgFDNsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 09:48:15 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674F2C08C5C0;
        Thu,  4 Jun 2020 06:48:14 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id e125so3650206lfd.1;
        Thu, 04 Jun 2020 06:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iMMF10Nxs4oc2EJJanF54FJNWM4D4Wwm1OdBu2wm4Z4=;
        b=sFXZR15/LjqG5bpCkxOk37qC9tElVU94FDwkLLfN9UCkQU3wR4HPwpJalmClK0WYId
         TK6qeC9VmQi1kN/fYn2uo77S6U3dVSlwcJhXWqOrCD8+8PeohG7Xn6gEW02z9J9azgjI
         LjIhE9h/6nc/czWT+jayLqT96lT+joKTedEpgQuS0967kKFH6QY5aV5KRxzexUCmlutV
         //C8VFzwL9ddcQVIX3sYK4MI86YxL9Sgu4FZXcZZOv4FFhhtxjlr2srMXtRo63T7hImF
         WtwQr/H1MPKmgaEzFCK3eUmei3ieS5j+8orUdaYCy6Ex+4mlhdW9tGzjg4AXi0M8CA6d
         +GUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iMMF10Nxs4oc2EJJanF54FJNWM4D4Wwm1OdBu2wm4Z4=;
        b=YTT/oiJ6TG5j1stJX+o4rMZogz0rgHW1Uyz8onUU0AwddOi8C2RLnYMrcmlkwlikRp
         oXuBqFz7+dYl3eFUsGv9bQ3HOdPKSPhqZNkViiLphBcvFWXpVNTvRBU63QXdFNc/H1Yd
         X6in6E8hrSJOwTzADAse//Af/jOxt/RnYpXezZkKSPmrEvQDL93EbvdlzfQ20TubCa/0
         5JgzLr0fwQ3jQa0B4Jrox9bQaCsPKmvsBqyKCseThsRLftSGP9xTMEDM+RAgQVRGXoXS
         64Ox/00BdozijCYyU95ba0Gb+hdj6u2HXxx6sm8EEtpc3VU4J7VFGI25faZysLCa2Kvv
         Ie3Q==
X-Gm-Message-State: AOAM532s/gHVlxeceNj4SXIF9C6kt3qa3zNvIhjwqPPjxwl9ZP+0YuTZ
        FA7mT3oSxFbXm2QGMHarQjYyaLBlpnhVJUPG2go=
X-Google-Smtp-Source: ABdhPJwIR6Q2Naj2V+WJIUcSDZdWNqsRdct/J8jlK8ybr+qXkoX6RREh9lcQJkoOOoeN0FxBfO3Sew2nuLo6o95L/B0=
X-Received: by 2002:a19:2358:: with SMTP id j85mr2654922lfj.182.1591278492760;
 Thu, 04 Jun 2020 06:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <20200604090014.23266-1-kerneljasonxing@gmail.com> <CANn89iKt=3iDZM+vUbCvO_aGuedXFhzdC6OtQMeVTMDxyp9bAg@mail.gmail.com>
In-Reply-To: <CANn89iKt=3iDZM+vUbCvO_aGuedXFhzdC6OtQMeVTMDxyp9bAg@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 4 Jun 2020 21:47:36 +0800
Message-ID: <CAL+tcoCU157eGmMMabT5icdFJTMEWymNUNxHBbxY1OTir0=0FQ@mail.gmail.com>
Subject: Re: [PATCH v2 4.19] tcp: fix TCP socks unreleased in BBR mode
To:     Eric Dumazet <edumazet@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        liweishi <liweishi@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 9:10 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jun 4, 2020 at 2:01 AM <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <kerneljasonxing@gmail.com>
> >
> > When using BBR mode, too many tcp socks cannot be released because of
> > duplicate use of the sock_hold() in the manner of tcp_internal_pacing()
> > when RTO happens. Therefore, this situation maddly increases the slab
> > memory and then constantly triggers the OOM until crash.
> >
> > Besides, in addition to BBR mode, if some mode applies pacing function,
> > it could trigger what we've discussed above,
> >
> > Reproduce procedure:
> > 0) cat /proc/slabinfo | grep TCP
> > 1) switch net.ipv4.tcp_congestion_control to bbr
> > 2) using wrk tool something like that to send packages
> > 3) using tc to increase the delay and loss to simulate the RTO case.
> > 4) cat /proc/slabinfo | grep TCP
> > 5) kill the wrk command and observe the number of objects and slabs in
> > TCP.
> > 6) at last, you could notice that the number would not decrease.
> >
> > v2: extend the timer which could cover all those related potential risks
> > (suggested by Eric Dumazet and Neal Cardwell)
> >
> > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > Signed-off-by: liweishi <liweishi@kuaishou.com>
> > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
>
> That is not how things work really.
>
> I will submit this properly so that stable teams do not have to guess
> how to backport this to various kernels.
>
> Changelog is misleading, this has nothing to do with BBR, we need to be precise.
>

Thanks for your help. I can finally apply this patch into my kernel.

Looking forward to your patchset :)

Jason

> Thank you.
