Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044A31B6E9C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgDXHEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:04:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45168 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726056AbgDXHEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587711884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hEu1SJ6duuRKGFhLNJbLv4ttQeQ0Cp8Q4HQbhwQjvIo=;
        b=WxkYsEvW4U9VVWWh8mmDQ0yWh5q7VHqpmGTzgV6SvuOw3yu65v+nh99EONIM1ZZm9bbTO8
        8CwDRGCvrEftjcsYDr47LzXZMCKv4PkeEaDfkEtYh0GIXtySy4r1VBwzxom68HhX4zSppC
        MKoABi3a2kXP8LFkiLlEUkiS+sPrzxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-LgN9UwMcOCywosakEpF2vQ-1; Fri, 24 Apr 2020 03:04:40 -0400
X-MC-Unique: LgN9UwMcOCywosakEpF2vQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9DB9100A8E8;
        Fri, 24 Apr 2020 07:04:38 +0000 (UTC)
Received: from carbon (unknown [10.40.208.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2A3F60CD1;
        Fri, 24 Apr 2020 07:04:27 +0000 (UTC)
Date:   Fri, 24 Apr 2020 09:04:26 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, ruxandra.radulescu@nxp.com,
        ioana.ciornei@nxp.com, nipun.gupta@nxp.com, shawnguo@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next 2/2] dpaa2-eth: fix return codes used in
 ndo_setup_tc
Message-ID: <20200424090426.1f9505e9@carbon>
In-Reply-To: <20200423125600.16956cc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
        <158765387082.1613879.14971732890635443222.stgit@firesoul>
        <20200423082804.6235b084@hermes.lan>
        <20200423173804.004fd0f6@carbon>
        <20200423123356.523264b4@hermes.lan>
        <20200423125600.16956cc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 12:56:00 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 23 Apr 2020 12:33:56 -0700 Stephen Hemminger wrote:
> > On Thu, 23 Apr 2020 17:38:04 +0200
> > Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> >   
> > > On Thu, 23 Apr 2020 08:28:58 -0700
> > > Stephen Hemminger <stephen@networkplumber.org> wrote:
> > >     
> > > > On Thu, 23 Apr 2020 16:57:50 +0200
> > > > Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> > > >       
> > > > > Drivers ndo_setup_tc call should return -EOPNOTSUPP, when it cannot
> > > > > support the qdisc type. Other return values will result in failing the
> > > > > qdisc setup.  This lead to qdisc noop getting assigned, which will
> > > > > drop all TX packets on the interface.
> > > > > 
> > > > > Fixes: ab1e6de2bd49 ("dpaa2-eth: Add mqprio support")
> > > > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>        
> > > > 
> > > > Would it be possible to use extack as well?      
> > > 
> > > That is what patch 1/2 already does.
> > >     
> > > > Putting errors in dmesg is unhelpful      
> > > 
> > > This patchset does not introduce any dmesg printk.
> > >     
> > 
> > I was thinking that this  
> > 	if (num_tc  > dpaa2_eth_tc_count(priv)) {
> >  		netdev_err(net_dev, "Max %d traffic classes supported\n",
> >  			   dpaa2_eth_tc_count(priv));
> > -		return -EINVAL;
> > +		return -EOPNOTSUPP;
> >  	}
> > 
> > could be an extack message  

First of all, this is a fix, and we need to keep it simple, as it needs
to be backported to v5.3.

Talking about converting this warning message this into a extack, I'm
actually not convinced that is a good idea, or will even work.  First
the extack cannot contain the %d number.  Second returning -EOPNOTSUPP
this is actually not an error, and I don't think tc will print the
extack in that case?
 
> That's a good question, actually. In this case Jesper was seeing a
> failure when creating the default qdisc. The extack would go nowhere,
> we'd have to print it to the logs, no? Which we should probably do,
> anyway.

Good point. We probably need a separate dmesg error when we cannot
configure the default qdisc.  As there is not end-user to receive the
extack.   But I would place that at a higher level in qdisc_create_dflt().
It would definitely have helped me to identify what net-subsystem was
dropping packets, and after my patch[1/2] adding the extack, an
end-user would get a meaning full message to ease the troubleshooting.

(Side-note: First I placed an extack in qdisc_create_dflt() but I
realized it was wrong, because it could potentially override messages
from the lower layers.)

(For a separate patch:)

We should discuss, that when creating the default qdisc, we should IMHO
not allow that to fail.  As you can see in [1], this step happens
during the qdisc init function e.g. it could also fail due to low
memory. IMHO we should have a fallback, for when the default qdisc init
fails, e.g. assign pfifo_fast instead or even noqueue.


> > but doing that would require a change
> > to the ndo_setup_tc hook to allow driver to return its own error message
> > as to why the setup failed.  
> 
> Yeah :S The block offload command contains extack, but this driver
> doesn't understand block offload, so it won't interpret it...
> 
> That brings me to an important point - doesn't the extack in patch 1
> override any extack driver may have set?

Nope, see above side-note.  I set the extack at the "lowest level",
e.g. closest to the error that cause the err back-propagation, when I
detect that this will cause a failure at higher level.


> I remember we discussed this when adding extacks to the TC core, but 
> I don't remember the conclusion now, ugh.

When adding the extack code, I as puzzled that during debugging I
managed to override other extack messages.  Have anyone though about a
better way to handle if extack messages gets overridden?


[1] https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/board_nxp_ls1088/nxp-board04-troubleshoot-qdisc.org
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

