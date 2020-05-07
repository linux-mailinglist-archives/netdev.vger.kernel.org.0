Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86861C9F48
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 01:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgEGXsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 19:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgEGXsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 19:48:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD2B321582;
        Thu,  7 May 2020 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588895302;
        bh=k/6cWflhLaq57PWrLv3ChauE/FA6fj6ckUlTW4Yxifg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tcUM+aUeNTL0MQllKrWji6y2mfXybL2tNRMv912IbQLaNf8jWP0WqBV0vaBJiEcGq
         ffhCTjcn75Dlb8OGSvllq1hHZE6ODsI635Rqh/vFwAIlcpqOBpqweKzFbifnoHnEEp
         8n5SyOYryLk9RMM7zkpBMBqH+WR91NEyeJj1cY+8=
Date:   Thu, 7 May 2020 16:48:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        jiri@resnulli.us
Subject: Re: [RFC PATCH net] net: flow_offload: simplify hw stats check
 handling
Message-ID: <20200507164820.0f48c36b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200507164643.GA10994@salvia>
References: <49176c41-3696-86d9-f0eb-c20207cd6d23@solarflare.com>
        <20200507153231.GA10250@salvia>
        <9000b990-9a25-936e-6063-0034429256f0@solarflare.com>
        <20200507164643.GA10994@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 18:46:43 +0200 Pablo Neira Ayuso wrote:
> On Thu, May 07, 2020 at 04:49:15PM +0100, Edward Cree wrote:
> > On 07/05/2020 16:32, Pablo Neira Ayuso wrote:  
> > > On Thu, May 07, 2020 at 03:59:09PM +0100, Edward Cree wrote:  
> > >> Make FLOW_ACTION_HW_STATS_DONT_CARE be all bits, rather than none, so that
> > >>  drivers and __flow_action_hw_stats_check can use simple bitwise checks.  
> > > 
> > > You have have to explain why this makes sense in terms of semantics.
> > > 
> > > _DISABLED and _ANY are contradicting each other.  
> > No, they aren't.  The DISABLED bit means "I will accept disabled", it doesn't
> >  mean "I insist on disabled".  What _does_ mean "I insist on disabled" is if
> >  the DISABLED bit is set and no other bits are.
> > So DISABLED | ANY means "I accept disabled; I also accept immediate or
> >  delayed".  A.k.a. "I don't care, do what you like".  
> 
> Jiri said Disabled means: bail out if you cannot disable it.

That's in TC uAPI Jiri chose... doesn't mean we have to do the same
internally.

> If the driver cannot disable, then it will have to check if the
> frontend is asking for Disabled (hence, report error to the frontend)
> or if it is actually asking for Don't care.
> 
> What you propose is a context-based interpretation of the bits. So
> semantics depend on how you accumulate/combine bits.
> 
> I really think bits semantics should be interpreted on the bit alone
> itself.

These 3 paragraphs sound to me like you were arguing for Ed's approach..

> There is one exception though, that is _ANY case, where you let the
> driver pick between delayed or immediate. But if the driver does not
> support for counters, it bails out in any case, so the outcome in both
> request is basically the same.
> 
> You are asking for different outcome depending on how bits are
> combined, which can be done, but it sounds innecessarily complicated
> to me.

No, quite the opposite, the code as committed to net has magic values
which drivers have to check.

The counter-proposal is that each bit represents a configuration, and
if more than one bit is set the driver gets to choose which it prefers. 
What could be simpler?

netfilter just has to explicitly set the field to DONT_CARE rather than 
depending on 0 form zalloc() coinciding with the correct value.
