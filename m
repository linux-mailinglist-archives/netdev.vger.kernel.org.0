Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864D4224D69
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 19:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgGRR7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 13:59:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36387 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728088AbgGRR7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 13:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595095142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YOC3JVzPDRJhj3DObWDI+eRxn6AScgc2CNNC0ur8YY8=;
        b=Z+uuqjC436f7nIqAj6snvN2gdpFoH9CWsMzCXM2SAcfrmCmFxg1qbW5Tlp64YR13uxdfXN
        FOh4AfIDjIXF99bV9ZNMw8jWKUlY6Bpax9crzyYN1Dox6BjA2uZLDHskfGHWFViU5lGpXn
        zEosDEWV1HpMVlV7rGfIQYLeP12TZQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-AErGAKYCPzqPt3p_G0o39A-1; Sat, 18 Jul 2020 13:58:58 -0400
X-MC-Unique: AErGAKYCPzqPt3p_G0o39A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3D0A1081;
        Sat, 18 Jul 2020 17:58:56 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D33C10013C4;
        Sat, 18 Jul 2020 17:58:55 +0000 (UTC)
Date:   Sat, 18 Jul 2020 19:58:50 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200718195850.61104dd2@elisabeth>
In-Reply-To: <9e47f521-b3dc-f116-658b-d6897b0ddf20@gmail.com>
References: <20200712200705.9796-1-fw@strlen.de>
        <20200712200705.9796-2-fw@strlen.de>
        <20200713003813.01f2d5d3@elisabeth>
        <20200713080413.GL32005@breakpoint.cc>
        <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
        <20200713140219.GM32005@breakpoint.cc>
        <20200714143327.2d5b8581@redhat.com>
        <20200715124258.GP32005@breakpoint.cc>
        <20200715153547.77dbaf82@elisabeth>
        <20200715143356.GQ32005@breakpoint.cc>
        <20200717142743.6d05d3ae@elisabeth>
        <89e5ec7b-845f-ab23-5043-73e797a29a14@gmail.com>
        <20200718085645.7420da02@elisabeth>
        <9e47f521-b3dc-f116-658b-d6897b0ddf20@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Jul 2020 11:02:46 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 7/18/20 12:56 AM, Stefano Brivio wrote:
> > On Fri, 17 Jul 2020 09:04:51 -0600
> > David Ahern <dsahern@gmail.com> wrote:
> >   
> >> On 7/17/20 6:27 AM, Stefano Brivio wrote:  
> >>>>    
> >>>>> Note that this doesn't work as it is because of a number of reasons
> >>>>> (skb doesn't have a dst, pkt_type is not PACKET_HOST), and perhaps we
> >>>>> shouldn't be using icmp_send(), but at a glance that looks simpler.      
> >>>>
> >>>> Yes, it also requires that the bridge has IP connectivity
> >>>> to reach the inner ip, which might not be the case.    
> >>>
> >>> If the VXLAN endpoint is a port of the bridge, that needs to be the
> >>> case, right? Otherwise the VXLAN endpoint can't be reached.
> >>>     
> >>>>> Another slight preference I have towards this idea is that the only
> >>>>> known way we can break PMTU discovery right now is by using a bridge,
> >>>>> so fixing the problem there looks more future-proof than addressing any
> >>>>> kind of tunnel with this problem. I think FoU and GUE would hit the
> >>>>> same problem, I don't know about IP tunnels, sticking that selftest
> >>>>> snippet to whatever other test in pmtu.sh should tell.      
> >>>>
> >>>> Every type of bridge port that needs to add additional header on egress
> >>>> has this problem in the bridge scenario once the peer of the IP tunnel
> >>>> signals a PMTU event.    
> >>>
> >>> Yes :(  
> >>
> >> The vxlan/tunnel device knows it is a bridge port, and it knows it is
> >> going to push a udp and ip{v6} header. So why not use that information
> >> in setting / updating the MTU? That's what I was getting at on Monday
> >> with my comment about lwtunnel_headroom equivalent.  
> > 
> > If I understand correctly, you're proposing something similar to my
> > earlier draft from:
> > 
> > 	<20200713003813.01f2d5d3@elisabeth>
> > 	https://lore.kernel.org/netdev/20200713003813.01f2d5d3@elisabeth/
> > 
> > the problem with it is that it wouldn't help: the MTU is already set to
> > the right value for both port and bridge in the case Florian originally
> > reported.  
> 
> I am definitely hand waving; I have not had time to create a setup
> showing the problem. Is there a reproducer using only namespaces?

And I'm laser pointing: check the bottom of that email ;)

-- 
Stefano

