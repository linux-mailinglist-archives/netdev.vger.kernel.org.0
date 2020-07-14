Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447BE21F7B4
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgGNQy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgGNQy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 12:54:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5942242B;
        Tue, 14 Jul 2020 16:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594745696;
        bh=+1A/LnyoyLX3MlO1k7bXYC438wSSxPoYVWvO7Ruh+uc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=No/GI/dvirVYSrC48VSl5ghL0UK045Ne9bBxyTYYKDLpEzLAOh84+tQ7ytAaba/It
         OwP5Bx+F+kWqN5AE/juPeknJlCKPsSfq8r9KUILJOAYoiKx/bxNSp/P8UxSNTPJY2n
         /XvSgNR2z3QwFoDulX97DHGo7Iq62fXvKrArte8o=
Date:   Tue, 14 Jul 2020 09:54:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 6/6] enetc: Add adaptive interrupt coalescing
Message-ID: <20200714095454.35705c36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM0PR04MB675470086CB8131D715D402A96610@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
        <1594644970-13531-7-git-send-email-claudiu.manoil@nxp.com>
        <20200713153017.07caaf73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR04MB675470086CB8131D715D402A96610@AM0PR04MB6754.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 11:21:45 +0000 Claudiu Manoil wrote:
> >Does it really make sense to implement DIM for TX?
> >
> >For TX the only thing we care about is that no queue in the system
> >underflows. So the calculation is simply timeout = queue len / speed.
> >The only problem is which queue in the system is the smallest (TX
> >ring, TSQ etc.) but IMHO there's little point in the extra work to
> >calculate the thresholds dynamically. On real life workloads the
> >scheduler overhead the async work structs introduce cause measurable
> >regressions.
> >
> >That's just to share my experience, up to you to decide if you want
> >to keep the TX-side DIM or not :)  
> 
> Yeah, I'm not happy either with Tx DIM, it seems too much for this device,
> too much overhead.
> But it seemed there's no other option left, because leaving coalescing as
> disabled for Tx is not an option as there are too many Tx interrupts, but
> on the other hand coming up with a single Tx coalescing time threshold to
> cover all the possible cases is not feasible either.  However your suggestion
> to compute the Tx coalescing values based on link speed, at least that's how
> I read it, is worth investigating.  This device is supposed to handle link speeds
> ranging from 10Mbit to 2.5G, so it would be great if TX DIM could be replaced
> replaced in this case by a set of precomputed values based on link speed.
> I'm going to look into this.  If you have any other suggestion on this pls let me know.

If you were happy with TX DIM - my guess would be that even if you
leave the TX coalescing with the value optimal for 2.5G - it will be
perfectly fine for other speeds, too. TX DIM is quite aggressive, if
I'm reading the code correctly it maxes out at 64us - which is a low
value for TX.

In my experiments with 25G NICs and TCP workloads (and some synthetic
netperf TCP_RR) the optimal value seems to be TSQ / link speed (- some
safety margin). Which is ~360us for 25G, since the TSQ value was bumped
to 1MB in recent kernels.

Obviously YMMV if the system is running a routing or raw socket app.
Then you presumably want to sustain max throughput on 2.5G with min
sized frames. And your rings by default hold 256 entries - that's still
~50us to complete a ring.
