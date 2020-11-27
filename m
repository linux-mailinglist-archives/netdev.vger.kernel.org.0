Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CF52C6A97
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 18:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732241AbgK0R1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 12:27:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732038AbgK0R1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 12:27:07 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273BB22242;
        Fri, 27 Nov 2020 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606498026;
        bh=Pj6KSTXj7DqmJrWEW522lcnWzphrRKrn95cMI+tly+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rHTd3VkHIBBuB9CH7L5iL6x90+U0JPgNSjmZiyl3mMLywOXuJRzgtHGELwEIiLx4y
         U/h9bO+zkGn4mdIT79ZKsjOKXs547goIddOPZS8eujiXayefu/vWDTnlGwmLsnFM6o
         oY1776VpFla6Sh6YGjj4dj12SFII6PjDRbPRDsvw=
Date:   Fri, 27 Nov 2020 09:27:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Karlsson <thomas.karlsson@paneda.se>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        jiri@resnulli.us, kaber@trash.net, edumazet@google.com,
        vyasevic@redhat.com, alexander.duyck@gmail.com
Subject: Re: Hardcoded multicast queue length in macvlan.c driver causes
 poor multicast receive performance
Message-ID: <20201127092705.67e00d14@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <3a30c2f6-e400-7001-69ec-683245620f2d@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
        <147b704ac1d5426fbaa8617289dad648@paneda.se>
        <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b93a6031-f1b4-729d-784b-b1f465d27071@paneda.se>
        <20201125085848.4f330dea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4e3c9f30-d43c-54b1-2796-86f38d316ef3@paneda.se>
        <20201125100710.7e766d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <956c4fca-2a54-97cb-5b4c-3a286743884b@paneda.se>
        <20201125150100.287ac72a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3a30c2f6-e400-7001-69ec-683245620f2d@paneda.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 21:00:46 +0100 Thomas Karlsson wrote:
> On 2020-11-26 00:01, Jakub Kicinski wrote:
> > On Wed, 25 Nov 2020 23:15:39 +0100 Thomas Karlsson wrote:  
> >> Or is there a way to set the parameters in a more "raw" form that
> >> does not require a patch to iproute2 with parameter parsing, error
> >> handing, man pages updates, etc. I feel that I'm getting in over my
> >> head here.  
> > 
> > We're here to assist! Netlink takes a little bit of effort 
> > to comprehend but it's very simple once you get the mechanics!
> >   
> 
> Thanks for the encouragement, I have been able to build iproute2 today and
> I am successfully communicating with the driver now being able to set and retrieve my queue len!
> 
> As I'm working on this I do got a question. I placed the bc_queue_len into the struct macvlan_port *port
> since that is where the bc_queue is located today. But when I change and retrieve the queue from userspace I realize
> that all macvlan interfaces that share the same physical lowerdev uses the same port structure and thus
> the same bc_queue_len.

Indeed looks like its an ingress attribute.

> It confused me at first and I'm not sure if that is how it should be. I expected the driver to have different
> bc_queues for all macvlan interfaces no matter which lowerdev they were using but obviously that is not the case.
> 
> It may be a bit confusing to change bc_queue_len on one macvlan and see that the change was applied to more than one.
> 
> But I'm not sure if I should just move bc_queue_len to the struct macvlan_dev either. because then different macvlans will use different queue lengths while they still use the same queue. Which may also be considered a bit illogical
> 
> Let me know what you prefer here!

I'd record the queue len requested by each interface in their struct
macvlan_dev and then calculate a max over the members to set the actual
value in struct macvlan_port.

Let me CC some extra people, looks like macvlan does not have a
maintainer..
