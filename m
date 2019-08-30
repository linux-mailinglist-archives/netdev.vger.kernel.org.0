Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF1EA3045
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 08:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfH3Gyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 02:54:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfH3Gyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 02:54:50 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B9E2820ABB;
        Fri, 30 Aug 2019 06:54:49 +0000 (UTC)
Received: from ceranb (ovpn-204-112.brq.redhat.com [10.40.204.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 099B65C1D6;
        Fri, 30 Aug 2019 06:54:46 +0000 (UTC)
Date:   Fri, 30 Aug 2019 08:54:45 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>, idosch@idosch.org,
        andrew@lunn.ch, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        allan.nielsen@microchip.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to
 dev->promiscuity.
Message-ID: <20190830085445.1c28dc02@ceranb>
In-Reply-To: <20190830063624.GN2312@nanopsycho>
References: <20190829193613.GA23259@splinter>
        <20190829.151201.940681219080864052.davem@davemloft.net>
        <20190830053940.GL2312@nanopsycho>
        <20190829.230233.287975311556641534.davem@davemloft.net>
        <20190830063624.GN2312@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 30 Aug 2019 06:54:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 08:36:24 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Fri, Aug 30, 2019 at 08:02:33AM CEST, davem@davemloft.net wrote:
> >From: Jiri Pirko <jiri@resnulli.us>
> >Date: Fri, 30 Aug 2019 07:39:40 +0200
> >  
> >> Because the "promisc mode" would gain another meaning. Now how the
> >> driver should guess which meaning the user ment when he setted it?
> >> filter or trap?
> >> 
> >> That is very confusing. If the flag is the way to do this, let's
> >> introduce another flag, like IFF_TRAPPING indicating that user
> >> wants exactly this.  
> >
> >I don't understand how the meaning of promiscuous mode for a
> >networking device has suddenly become ambiguous, when did this start
> >happening?  
> 
> The promiscuity is a way to setup the rx filter. So promics == rx
> filter off. For normal nics, where there is no hw fwd datapath,
> this coincidentally means all received packets go to cpu.
> But if there is hw fwd datapath, rx filter is still off, all rxed
> packets are processed. But that does not mean they should be trapped
> to cpu.

+1
Promisc is Rx filtering option and should not imply that offloaded
traffic is trapped to CPU.

> Simple example:
> I need to see slowpath packets, for example arps/stp/bgp/... that
> are going to cpu, I do:
> tcpdump -i swp1
> 
> I don't want to get all the traffic running over hw running this cmd.
> This is a valid usecase.
> 
> To cope with hw fwd datapath devices, I believe that tcpdump has to
> have notion of that. Something like:
> 
> tcpdump -i swp1 --hw-trapping-mode
> 
> The logic can be inverse:
> tcpdump -i swp1
> tcpdump -i swp1 --no-hw-trapping-mode
> 
> However, that would provide inconsistent behaviour between existing
> and patched tcpdump/kernel.
> 
> All I'm trying to say, there are 2 flags
> needed (if we don't use tc trap).

