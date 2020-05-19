Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727451DA3B3
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgESVf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgESVf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 17:35:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 418BD205CB;
        Tue, 19 May 2020 21:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589924128;
        bh=Kxf8BQo5GY6wWDdymIIteJzoiDVi/OQb+bglh5ZG6pY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y19fkRvzT+bYIfRF3XXx5W+eFo3+bmZe5tVIiq0DGGJMTaJZOnZoisBv+EXXohcxg
         Lk4lPnk7Fd/5NpUMXrz0lFFs2VEhyCQ3BRY6AEPRuIGQHUH4vHD/F5OtJcSLHhA6D5
         32Lb1VA6kXm/3UdhUJdNUW2T3SxQfJpvL8MSFL0I=
Date:   Tue, 19 May 2020 14:35:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Message-ID: <20200519143525.136d3c3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <VI1PR0402MB387192A5F1A47C6779D0958DE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387101A0B3D3382B08DBE07CE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200519114342.331ff0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387192A5F1A47C6779D0958DE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 20:58:50 +0000 Ioana Ciornei wrote:
> > This needs to be well
> > integrated with the rest of the stack, but I don't think TC qdisc offload is a fit.
> > Given we don't have qdiscs on ingress. As I said a new API for this would most
> > likely have to be created.  
> 
> For just assigning a traffic class based on packet headers a tc filter with the
> skbedit priority action on ingress is enough (maybe even too much since there are
> other drivers that have the same default prioritization based on VLAN PCP).
> 
> But you are correct that this would not be enough to cover all possible use cases except
> for the most simple ones. There are per-traffic class ingress policers, and those become
> tricky to support since there's nothing that denotes the traffic class to match on,
> currently. I see 2 possible approaches, each with its own drawbacks:
> - Allow clsact to be classful, similar to mqprio, and attach filters to its classes (each
>   class would correspond to an ingress traffic class). But this would make the skbedit
>   action redundant, since QoS classification with a classful clsact should be done
>   completely differently now. Also, the classful clsact would have to deny qdiscs attached
>   to it that don't make sense, because all of those were written with egress in mind.
> - Try to linearize the ingress filter rules under the classless clsact, both the ones that
>   have a skbedit action, and the ones that match on a skb priority in order to perform
>   ingress policing. But this would be very brittle because the matching order would depend
>   on the order in which the rules were introduced:
>   rule 1: flower skb-priority 5 action police rate 34Mbps # note: matching on skb-priority doesn't exist (yet?)
>   rule 2: flower vlan_prio 5 action skbedit priority 5
>   In this case, traffic with VLAN priority 5 would not get rate-limited to 34Mbps.
> 
> So this is one of the reasons why I preferred to defer the hard questions and start with
> something simple (which for some reason still gets pushback).

You're jumping to classification while the configuration of the queues
itself is still not defined. How does the user know how many queues
there are to classify into?

Does this driver has descriptor rings for RX / completion? How does it
decide which queue to pool at NAPI time?
