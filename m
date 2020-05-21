Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A411DD69E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbgEUTHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbgEUTHz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 15:07:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A0B820738;
        Thu, 21 May 2020 19:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590088074;
        bh=WH+ly+8Pofo+saJ9jshEuqzR1rRZFjalJ3fz0UIGWxE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dG/t4AxB+175M33YLQXBpBQgb0VBxOp08RfM3dhJ2MDJW0GysPUO7Bnn6+0gFUHRE
         cdGGKsI31s20vZuzsb4y1vX0Z+zyk4FvTGTaZmzcrrjQF7lLgl7oBZUgafPQg+5aAP
         ChpFXhPmJWWdkfbSRLuQKlv245MtVHHgxCInZINQ=
Date:   Thu, 21 May 2020 12:07:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Message-ID: <20200521120752.07fd83aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <VI1PR0402MB38710DAD1F17B80F83403396E0B60@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387101A0B3D3382B08DBE07CE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200519114342.331ff0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387192A5F1A47C6779D0958DE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200519143525.136d3c3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871686102702FC257853855E0B60@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200520121252.6cee8674@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38710DAD1F17B80F83403396E0B60@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 20:24:43 +0000 Ioana Ciornei wrote:
> > Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
> > classes
> > 
> > On Wed, 20 May 2020 15:10:42 +0000 Ioana Ciornei wrote:  
> > > DPAA2 has frame queues per each Rx traffic class and the decision from
> > > which queue to pull frames from is made by the HW based on the queue
> > > priority within a channel (there is one channel per each CPU).  
> > 
> > IOW you're reading the descriptor for the device memory/iomem address and
> > the HW will return the next descriptor based on configured priority?  
> 
> That's the general idea but the decision is not made on a frame by frame bases
> but rather on a dequeue operation which can, at a maximum, return
> 16 frame descriptors at a time.

I see!

> > Presumably strict priority?  
> 
> Only the two highest traffic classes are in strict priority, while the other 6 TCs
> form two priority tiers - medium(4 TCs) and low (last two TCs).
> 
> > > If this should be modeled in software, then I assume there should be a
> > > NAPI instance for each traffic class and the stack should know in
> > > which order to call the poll() callbacks so that the priority is respected.  
> > 
> > Right, something like that. But IMHO not needed if HW can serve the right
> > descriptor upon poll.  
> 
> After thinking this through I don't actually believe that multiple NAPI instances
> would solve this in any circumstance at all:
> 
> - If you have hardware prioritization with full scheduling on dequeue then job on the
> driver side is already done.
> - If you only have hardware assist for prioritization (ie hardware gives you multiple
> rings but doesn't tell you from which one to dequeue) then you can still use a single
> NAPI instance just fine and pick the highest priority non-empty ring on-the-fly basically.
> 
> What I am having trouble understanding is how the fully software implementation
> of this possible new Rx qdisc should work. Somehow the skb->priority should be taken
> into account when the skb is passing though the stack (ie a higher priority skb should
> surpass another previously received skb even if the latter one was received first, but
> its priority queue is congested).

I'd think the SW implementation would come down to which ring to
service first. If there are multiple rings on the host NAPI can try
to read from highest priority ring first and then move on to next prio.
Not sure if there would be a use case for multiple NAPIs for busy
polling or not.

I was hoping we can solve this with the new ring config API (which is
coming any day now, ehh) - in which I hope user space will be able to
assign rings to NAPI instances, all we would have needed would be also
controlling the querying order. But that doesn't really work for you,
it seems, since the selection is offloaded to HW :S

> I don't have a very deep understanding of the stack but I am thinking that the
> enqueue_to_backlog()/process_backlog() area could be a candidate place for sorting out
> bottlenecks. In case we do that I don't see why a qdisc would be necessary at all and not
> have everybody benefit from prioritization based on skb->priority.

I think once the driver picks the frame up it should run with it to
completion (+/-GRO). We have natural batching with NAPI processing.
Every NAPI budget high priority rings get a chance to preempt lower
ones.
