Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F08E7DA8C
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 13:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbfHALrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 07:47:17 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34497 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfHALrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 07:47:16 -0400
Received: by mail-lj1-f195.google.com with SMTP id p17so69068098ljg.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 04:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZjmvCfksO5i4OgPdHptucLhtzAqpKuPPbM9IMLKAEX8=;
        b=MY6C2gAG/m2nm+IynEElGBBKP4JEYyRwvweVvnmSYYmeZKw4q6kSCJrIJWQQHZLqo0
         gJ4pbCQtF3//ZduCkGtF364PxSGLDkve0H/LEUNduLts291E9JuZpCjoh6OMT7h0QbLD
         D8xXy8y+i1bd9PCx4UjpIgULetu6UdCF2BMCdiA7Dv0t++lKlqjKZf0AOtcLVgwaDpBU
         XWFURIxMZewXsBgY8WJvTHTa7z+4mDpFygm0Not0hReZCxYnwCyM9OTJOL5vG3KNN2yq
         FXLdPPDNZh+BAtzAqQJBzYGmQBrH1l5cqE3x7G+C/JyvuP7pP6aVIAtQW9GcjOr8oVpq
         pv1A==
X-Gm-Message-State: APjAAAVEXvDSnuPh+hGGh9DvyteRsXZD0ieWFQD5xaCHz8Hc0Kpq4bt3
        mKdqns+0AdjyK/PortSxHrUxkQmuDbE9nA3ySbVg9r8Y
X-Google-Smtp-Source: APXvYqzUmKsMptn1owkPtGVZ2cOYw1oDcBkPsCahi9gmMdekV5W29oI32q6fTgnFRW7p/WoxZoXccmXgZ/bRHJED5Fc=
X-Received: by 2002:a2e:9643:: with SMTP id z3mr68846819ljh.43.1564660034911;
 Thu, 01 Aug 2019 04:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190731183116.4791-1-mcroce@redhat.com> <20190801071801.GF3579@kwain>
In-Reply-To: <20190801071801.GF3579@kwain>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Thu, 1 Aug 2019 13:46:39 +0200
Message-ID: <CAGnkfhyx7MHaG=YNhS7VrzsBqhVCPw5VeHPM7SFpiLeq3cb5Gw@mail.gmail.com>
Subject: Re: [PATCH net] mvpp2: fix panic on module removal
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@free-electrons.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 9:18 AM Antoine Tenart
<antoine.tenart@bootlin.com> wrote:
>
> Hi Matteo,
>
> On Wed, Jul 31, 2019 at 08:31:16PM +0200, Matteo Croce wrote:
> >
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index c51f1d5b550b..5002d51fc9d6 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -5760,7 +5760,6 @@ static int mvpp2_remove(struct platform_device *pdev)
> >       mvpp2_dbgfs_cleanup(priv);
> >
> >       flush_workqueue(priv->stats_queue);
> > -     destroy_workqueue(priv->stats_queue);
> >
> >       fwnode_for_each_available_child_node(fwnode, port_fwnode) {
> >               if (priv->port_list[i]) {
> > @@ -5770,6 +5769,8 @@ static int mvpp2_remove(struct platform_device *pdev)
> >               i++;
> >       }
>
> Shouldn't you also move flush_workqueue() here?
>

I think that that flush it's unneeded at all, as all port remove calls
cancel_delayed_work_sync().

I tried removing it and it doesn't crash on rmmod.

--
Matteo Croce
per aspera ad upstream
