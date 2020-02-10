Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8F3157C12
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 14:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbgBJNem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 08:34:42 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:32789 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgBJNeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 08:34:37 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 78796cac;
        Mon, 10 Feb 2020 13:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=FWRLHQb/Wkrguqh1GNxMa+ZuXh0=; b=ofQWQ3
        QpYaHzbX6LySlsZ815dSy/eeRIrson/iEV9t0229lQWg4JZrJtwZOiFGor73SRc+
        yUsM2G2ArK+qRXqYS+cHNgCsE4NVT+0bPnM57NER6VBECoo3YtVoV2g88xky8NGO
        kgUlUsHyKqLAn/uk7plYInLtkg108LrZITWa7UauuTYy4oxVzyj2a0Sls2xT0Bfr
        fyQxt9Kmj12VCHIRqWUYYMjZGesADHI27rsYkee9bz1ajWCEAbrdiBGeZFbzTuGh
        L3iF9nF24ZdmjSBcZjEvRlWNlCwVCaSNJf0WWjpE8B7ovPyTggnldO1H54+RH2Ua
        50pn7DNW7D5FvKmg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4a55e41f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 10 Feb 2020 13:33:00 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id q84so9204350oic.4;
        Mon, 10 Feb 2020 05:34:35 -0800 (PST)
X-Gm-Message-State: APjAAAVHCoz189H3xmqDV3ecBRSl1291kQxJsGdxqiS/oVnbZkWpydmU
        NmIepAEODwWRj1H4a9eSl9k2OiJ9mCOUOTyJodU=
X-Google-Smtp-Source: APXvYqwydHmB1nhSiVJUryyoPZAWeDbWwGafsEHQgKlTlSBYBcSdT2TFMloy/9NkuAFY/AcDP7RYNdYcGt2k2vzas6E=
X-Received: by 2002:aca:2109:: with SMTP id 9mr756086oiz.119.1581341675101;
 Mon, 10 Feb 2020 05:34:35 -0800 (PST)
MIME-Version: 1.0
References: <20200209143143.151632-1-Jason@zx2c4.com> <20200209143143.151632-3-Jason@zx2c4.com>
 <20200210.123619.546500251078019206.davem@davemloft.net>
In-Reply-To: <20200210.123619.546500251078019206.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 10 Feb 2020 14:34:24 +0100
X-Gmail-Original-Message-ID: <CAHmME9qSQaWJi_npqX7YQFhCsuikvKhGe62o-ztEaD5h-zvd1A@mail.gmail.com>
Message-ID: <CAHmME9qSQaWJi_npqX7YQFhCsuikvKhGe62o-ztEaD5h-zvd1A@mail.gmail.com>
Subject: Re: [PATCH net 3/5] sunvnet: use icmp_ndo_send helper
To:     David Miller <davem@davemloft.net>
Cc:     netfilter-devel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        shannon.nelson@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 12:36 PM David Miller <davem@davemloft.net> wrote:
>
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Date: Sun,  9 Feb 2020 15:31:41 +0100
>
> > Because sunvnet is calling icmp from network device context, it should use
> > the ndo helper so that the rate limiting applies correctly.
> >
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> Two things, first you should resubmit this patch series with a proper
> header [PATCH 0/N ... ] posting.

Ack, will do for v2.

>
> Second:
>
> > @@ -1363,14 +1363,14 @@ sunvnet_start_xmit_common(struct sk_buff *skb, struct net_device *dev,
> >                       rt = ip_route_output_key(dev_net(dev), &fl4);
> >                       if (!IS_ERR(rt)) {
> >                               skb_dst_set(skb, &rt->dst);
> > -                             icmp_send(skb, ICMP_DEST_UNREACH,
> > -                                       ICMP_FRAG_NEEDED,
> > -                                       htonl(localmtu));
> > +                             icmp_ndo_send(skb, ICMP_DEST_UNREACH,
> > +                                           ICMP_FRAG_NEEDED,
> > +                                           htonl(localmtu));
> >                       }
> >               }
>
> Well, obviously if the saddr could be wrong here then this invalidates
> the route lookup done in the lines above your changes.
>
> It looks like this code is just making sure the ICMP path is routable
> which is kinda bogus because that is the icmp code's job.  So very
> likely the right thing to do is to remove all of that route lookup
> and check code entirely.  And that matches what all the other instances
> of driver icmp calls in your patces do.

Good point. I'll simplify that by just getting rid of the superfluous
route lookup and make sure that the other ones are okay too.

Thanks,
Jason
