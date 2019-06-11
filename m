Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C263D00F
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 16:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388958AbfFKO6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 10:58:39 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:37627 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbfFKO6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 10:58:39 -0400
Received: by mail-it1-f194.google.com with SMTP id x22so5257131itl.2
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 07:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Ja2uJ5yiB+G9VJdxFvWClG/Yig83EfwfKTM85iRUek=;
        b=lbhjd5lcqpi4xc3IXw4BruKz2nrAJB/i2vn3CZiqAp/QDfiJpFt36sVytmMEkBLXuH
         37aUOwPOt7wzlsTmjYtn80e+kcxo7tYG/jgApEqNeRvQGy4rnEdUSZtuqWtRj6/G4wy7
         cNGQxFKVCIvLI748DKzwNeQ0kbF0ugqCF8+oteYeYEgX+23IP/5WdQ4rOKPurvQ3oMr1
         PRd7P3KMXc+wtQLLeXJ2D7CtPAu4eCZ3Lh6Ye5t3zsz+bxW7DKtUdYgbcBPOIEDu8mxe
         4vIzVe08Gidl/KyJsmeFmVaZ0zVDNR9j81S2ipzpCpGchJRxCrqkO/lhw3I+8P3DLG6b
         TlJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Ja2uJ5yiB+G9VJdxFvWClG/Yig83EfwfKTM85iRUek=;
        b=DmNzocHCsfXN+X1hqAYTJ75XvqZ6PNuQDoKuR+28WJVUUi3DeWRjLnFb0NqefrLxUC
         XO2E23no4m9Za8GH6Ejrmncfk83pZxhLXJ/eR1dpf+9Hf7EgmejkqpNw5tnHgQWDyKbY
         WyUaN1mWhpzMkUfqxsTZLQUC0vIkmBIupZ6jk3xuqVy9ZeQt4dDeADSZWISRQFFbyzI3
         J0z2ih2htCHI+O9QbcMFrkyxYdDT3RgYjGGIBWtJPrxbi5lsjY6PnxkuSBnZUUX7LgLI
         QBYeGNMkvqMDplnIHpMGcdz9g3GLqarRPn3+Xz8tME/q8ouROSoo7jCNgovJvdpBC/+H
         LiAg==
X-Gm-Message-State: APjAAAVSG3OTHfbG3ppqsqx3xR30ZM6QelqbXNVrPdYFk+Z2EZsylwrh
        xhF73xoEbCn5fa2fZ+FB963QEF3evvyX9fbY+M9T4Q==
X-Google-Smtp-Source: APXvYqyo9yf9KMv6gfbHHXAmSeiNf5is5WHNIqasNP9SNtlFOxt3b0zzyr6Qz+H6OtPWF25G/to1ojAZvrSa+nY8dK4=
X-Received: by 2002:a24:5285:: with SMTP id d127mr17414850itb.72.1560265118755;
 Tue, 11 Jun 2019 07:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <1559825374-32117-1-git-send-email-john.hurley@netronome.com>
 <20190606125818.bvo5im2wqj365tai@breakpoint.cc> <20190606.111954.2036000288766363267.davem@davemloft.net>
 <20190606195255.4uelltuxptwobhiv@breakpoint.cc>
In-Reply-To: <20190606195255.4uelltuxptwobhiv@breakpoint.cc>
From:   John Hurley <john.hurley@netronome.com>
Date:   Tue, 11 Jun 2019 15:58:27 +0100
Message-ID: <CAK+XE=m_Z=A6JXYvVzBBk+SPw5xnc_B3UsLfG81G5-kjrUNnzA@mail.gmail.com>
Subject: Re: [RFC net-next v2 1/1] net: sched: protect against loops in TC
 filter hooks
To:     Florian Westphal <fw@strlen.de>
Cc:     David Miller <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 8:52 PM Florian Westphal <fw@strlen.de> wrote:
>
> David Miller <davem@davemloft.net> wrote:
> > From: Florian Westphal <fw@strlen.de>
> > Date: Thu, 6 Jun 2019 14:58:18 +0200
> >
> > >> @@ -827,6 +828,7 @@ struct sk_buff {
> > >>    __u8                    tc_at_ingress:1;
> > >>    __u8                    tc_redirected:1;
> > >>    __u8                    tc_from_ingress:1;
> > >> +  __u8                    tc_hop_count:2;
> > >
> > > I dislike this, why can't we just use a pcpu counter?
> >
> > I understand that it's because the only precise context is per-SKB not
> > per-cpu doing packet processing.  This has been discussed before.
>
> I don't think its worth it, and it won't work with physical-world
> loops (e.g. a bridge setup with no spanning tree and a closed loop).
>
> Also I fear that if we start to do this for tc, we will also have to
> followup later with more l2 hopcounts for other users, e.g. veth,
> bridge, ovs, and so on.

Hi David/Florian,
Moving forward with this, should we treat the looping and recursion as
2 separate issues and at least prevent the potential stack overflow
panics caused by the recursion?
The pcpu counter should protect against this.
Are there context specific issues that we may miss by doing this?
If not I will respin with the pcpu counter in act_mirred.
