Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43561B64DE
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgDWT4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgDWT4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 15:56:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AE942076C;
        Thu, 23 Apr 2020 19:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587671762;
        bh=1lzjt61Blpm/d2gXQhDTUE1Do2hLy6/abTbhwipsKUk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jyRGAaf+l9cwhmN6RwO11regt9RQVsZu2gC3xOZQ4zk099hvIXTqxm3dRi+Rc/1d0
         5M31j9Eq5BC6cAdSB8mM6ozV3PxUQ1DRkCO45Jmv6OCoLwiNAXLM4HDrnkbvFg8GKw
         wGKb/OY48V2Enp7ZOCZIFu+ISBqIre7hbTOuGdYo=
Date:   Thu, 23 Apr 2020 12:56:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, ruxandra.radulescu@nxp.com,
        ioana.ciornei@nxp.com, nipun.gupta@nxp.com, shawnguo@kernel.org
Subject: Re: [PATCH net-next 2/2] dpaa2-eth: fix return codes used in
 ndo_setup_tc
Message-ID: <20200423125600.16956cc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200423123356.523264b4@hermes.lan>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
        <158765387082.1613879.14971732890635443222.stgit@firesoul>
        <20200423082804.6235b084@hermes.lan>
        <20200423173804.004fd0f6@carbon>
        <20200423123356.523264b4@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 12:33:56 -0700 Stephen Hemminger wrote:
> On Thu, 23 Apr 2020 17:38:04 +0200
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> 
> > On Thu, 23 Apr 2020 08:28:58 -0700
> > Stephen Hemminger <stephen@networkplumber.org> wrote:
> >   
> > > On Thu, 23 Apr 2020 16:57:50 +0200
> > > Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> > >     
> > > > Drivers ndo_setup_tc call should return -EOPNOTSUPP, when it cannot
> > > > support the qdisc type. Other return values will result in failing the
> > > > qdisc setup.  This lead to qdisc noop getting assigned, which will
> > > > drop all TX packets on the interface.
> > > > 
> > > > Fixes: ab1e6de2bd49 ("dpaa2-eth: Add mqprio support")
> > > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>      
> > > 
> > > Would it be possible to use extack as well?    
> > 
> > That is what patch 1/2 already does.
> >   
> > > Putting errors in dmesg is unhelpful    
> > 
> > This patchset does not introduce any dmesg printk.
> >   
> 
> I was thinking that this  
> 	if (num_tc  > dpaa2_eth_tc_count(priv)) {
>  		netdev_err(net_dev, "Max %d traffic classes supported\n",
>  			   dpaa2_eth_tc_count(priv));
> -		return -EINVAL;
> +		return -EOPNOTSUPP;
>  	}
> 
> could be an extack message

That's a good question, actually. In this case Jesper was seeing a
failure when creating the default qdisc. The extack would go nowhere,
we'd have to print it to the logs, no? Which we should probably do,
anyway.

> but doing that would require a change
> to the ndo_setup_tc hook to allow driver to return its own error message
> as to why the setup failed.

Yeah :S The block offload command contains extack, but this driver
doesn't understand block offload, so it won't interpret it...

That brings me to an important point - doesn't the extack in patch 1
override any extack driver may have set?

I remember we discussed this when adding extacks to the TC core, but 
I don't remember the conclusion now, ugh.
