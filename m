Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB78C11EE72
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfLMXZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:25:39 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42814 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfLMXZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:25:39 -0500
Received: by mail-lj1-f195.google.com with SMTP id e28so443266ljo.9;
        Fri, 13 Dec 2019 15:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ajSzcywX0kn22XFVXdXCg7n3vQlG/dOEDYZp4LUX3Ow=;
        b=h+PdYdtDFlgO1U/WzbDm1uXfUHVZn+MtjrKRm73syiH8DlTPUcb4qJ6z5D+aVyKLWM
         3p80Jet0AQS6RILOtnQ+eR1O8YrkXKC77h1hzgbZrNgsPJtIcFU76+pe2A3cR1rmd5vg
         bDUYBUx7rit+wxs8KyjHbOy7SIws/nLj9JqV8ooZJx68PzhWH1RO2/npkIcbgNWZT/+s
         k864tuznfak8xnIdzg0V7Ky7diQuUJ3dtkwhTdY1w5WmEB8dwZimJYaukYaGL0buyy4e
         3hLYjA0iDJ07K02uOy8JOqX/vfgWErhYOfNbx/U09txBZcqOQLEinvMQm2jJgGPpgH+f
         tUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ajSzcywX0kn22XFVXdXCg7n3vQlG/dOEDYZp4LUX3Ow=;
        b=TPW5u7VXaMLOMqmEcWIC2zUXXbSTwfR5HK24IHUQPnuhxkOEz+MqvwkgNdd/1yWMIx
         ePrus31Dz4YZJrJYZrOHx/63o8TILMsFou4Rb1XNcF9RVV+Ycl2AWTylhR1jHMODcYQ9
         Zza+YDd5OgPMjTNqskQ6nZkIfkfWvHsE+VctGIqQdUuzORtZfTDlDZyhghGzn418kzsE
         pNWrVkX12XX0yhKe2NlfHFNuMFSo8Ak0LQzCvlsj8s9544GoufQfWRROItizGGSWqLEP
         l3/jVEwTlGN6n8K4p2QvsCKKrOWjSqeTHOicov/Mu8QDSYbTcSn99lpaEknxujYZdV9H
         oA6Q==
X-Gm-Message-State: APjAAAVLpQfUUFNQ/ImxMRi1r8TV5tC84O/UCUWiYKlrecaqRL+dV6lY
        QOeIvR6BSHRRostc22BukFPkMSuCLWIoTWqDHxc=
X-Google-Smtp-Source: APXvYqwa1Yam+ePaC98hMchGUQ10VfLcXFLEsxbNjQNIehCxvVsHQbhBtkk278u/Jr194totuUgTlelgH/mObOFrKQM=
X-Received: by 2002:a2e:8e8d:: with SMTP id z13mr11197976ljk.10.1576279537229;
 Fri, 13 Dec 2019 15:25:37 -0800 (PST)
MIME-Version: 1.0
References: <20191213154634.27338-1-lmb@cloudflare.com> <20191213180817.2510-1-lmb@cloudflare.com>
 <5e7ccc2c-cb6b-0154-15bf-fa93d374266e@gmail.com>
In-Reply-To: <5e7ccc2c-cb6b-0154-15bf-fa93d374266e@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 Dec 2019 15:25:25 -0800
Message-ID: <CAADnVQKmNifGQzh+gTL3vvxuEBR9et8-Oj++OWKgY4pfYc-=sQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: clear skb->tstamp in bpf_redirect when necessary
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 1:09 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 12/13/19 10:08 AM, Lorenz Bauer wrote:
> > Redirecting a packet from ingress to egress by using bpf_redirect
> > breaks if the egress interface has an fq qdisc installed. This is the same
> > problem as fixed in 'commit 8203e2d844d3 ("net: clear skb->tstamp in forwarding paths")
> >
> > Clear skb->tstamp when redirecting into the egress path.
> >
> > Fixes: 80b14dee2bea ("net: Add a new socket option for a future transmit time.")
> > Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  net/core/filter.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index f1e703eed3d2..d914257763b5 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -2055,6 +2055,7 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
> >       }
> >
> >       skb->dev = dev;
> > +     skb->tstamp = 0;
> >
> >       dev_xmit_recursion_inc();
> >       ret = dev_queue_xmit(skb);
> >
>
> Thanks !
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Applied. Thanks
