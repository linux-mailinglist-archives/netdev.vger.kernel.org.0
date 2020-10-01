Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7473280339
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732755AbgJAPuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732361AbgJAPut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 11:50:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358C3207F7;
        Thu,  1 Oct 2020 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601567449;
        bh=DPYmFRaWGGCrp/ckt9+mPdNaN38f2eV04wVJSzsI55Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XpHBwZ23jkcXxijy1iZO2VcVLreBtVFP5NKEDPDiHewMEG+6mac8V2vXjPFvj6/WY
         BlkBjB/Heeren0AJ+YI+jb9BOsjhUTnZCzWcU5TgToXOBJ9kFh+cj01fZD3cpmWRqM
         mbTqG/Juihpn4XpyxJkKypw84D1o5rKjO0f6skEI=
Date:   Thu, 1 Oct 2020 08:50:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Michal Kubecek <mkubecek@suse.cz>, dsahern@kernel.org,
        pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20201001085047.3a1c55e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201001015323.GB4050473@lunn.ch>
References: <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
        <20200930120129.620a49f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <563a2334a42cc5f33089c2bff172d92e118575ea.camel@sipsolutions.net>
        <20200930121404.221033a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c161e922491c1a2330dcef6741a8cfa7f92999be.camel@sipsolutions.net>
        <20200930124612.32b53118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <48868126b563b1602093f6210ed957d7ed880584.camel@sipsolutions.net>
        <20200930134734.27bba000@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200930233817.GA3996795@lunn.ch>
        <20200930172317.48f85a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201001015323.GB4050473@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Oct 2020 03:53:23 +0200 Andrew Lunn wrote:
> On Wed, Sep 30, 2020 at 05:23:17PM -0700, Jakub Kicinski wrote:
> > On Thu, 1 Oct 2020 01:38:17 +0200 Andrew Lunn wrote:  
> > > > > > +static void genl_op_from_full(const struct genl_family *family,
> > > > > > +			      unsigned int i, struct genl_ops *op)
> > > > > > +{
> > > > > > +	memcpy(op, &family->ops[i], sizeof(*op));      
> > > > > 
> > > > > What's wrong with struct assignment? :)
> > > > > 
> > > > > 	*op = family->ops[i];    
> > > > 
> > > > Code size :)
> > > > 
> > > >    text	   data	    bss	    dec	    hex
> > > >   22657	   3590	     64	  26311	   66c7	memcpy
> > > >   23103	   3590	     64	  26757	   6885	struct    
> > > 
> > > You might want to show that to the compiler people. Did you look at
> > > the assembly?  
> > 
> > Somewhere along the line I lost the ability to decipher compiler code :(  
> 
> Yah, Z80 and 6809 i could sometimes just read the byte codes. That has
> long gone. I tend to read ARM assembly now a days being mostly in the
> embedded world.
> 
> So the memcpy version just calls memcpy by the looks of it. I thought
> it might of inlined it, but it has not. Maybe because of the -Os.
> 
> The struct assignment is interesting because it appears to be calling
> three functions to do the work. I wonder if it is avoiding copying the
> padding in the structure?
> 
> But still, that does not explain an extra 400 bytes in the text
> segment.

FWIW the 400 was without the -Os with -Os it's more like 50. So I'll
just go for it and do the struct assignment.
