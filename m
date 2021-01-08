Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC04B2EF92E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 21:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbhAHU1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 15:27:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbhAHU1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 15:27:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E5FD2399C;
        Fri,  8 Jan 2021 20:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610137622;
        bh=uKMf/YCjz4GqBLQ8uH3F7hRE4xdACHWcOKV7E2KR6rY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dKsTN3UP4YZ8SoW6w2vdMEJYgnLRQemcYBHXJcsSXKaGU2t5k1SzZBBNti6cgaKhx
         iPZc5RaymVwhHNU7yNdJJ2LK+VLL279DNY5P4e0SbUzsWKktvPKaZ1fQb1PC3GnGgm
         OXFizs8ZK0k8/UxMBFfs9Ikb35+oa9nIYPWWenh7ekZoowIZ+VcHGxiBJ2OxgksQKH
         I+nX/Lme6FMg8C6QHoaEzEH7mE47mrqitE29wzHNp1YovCeY+EgOgsTOp/OZRjPSOd
         LXNOLCt+TC5jDh+C4uhoZBJ6LF86GyNC2S2Tg4eqxW3NQnKQgG7yPXsm8vxqAf8iF0
         o5Lt2XpBmZIhQ==
Message-ID: <0e06ff3234b78b5bde6bf77d192a42c3f8ab5319.camel@kernel.org>
Subject: Re: [PATCH net-next v1 1/2] net: core: count drops from GRO
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 08 Jan 2021 12:26:58 -0800
In-Reply-To: <c11bb25a-f73d-3ae9-b1fd-7eb96bc79cc7@pensando.io>
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
         <20210106215539.2103688-2-jesse.brandeburg@intel.com>
         <1e4ee1cf-c2b7-8ba3-7cb1-5c5cb3ff1e84@pensando.io>
         <20210108102630.00004202@intel.com>
         <c11bb25a-f73d-3ae9-b1fd-7eb96bc79cc7@pensando.io>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-01-08 at 11:21 -0800, Shannon Nelson wrote:
> On 1/8/21 10:26 AM, Jesse Brandeburg wrote:
> > Shannon Nelson wrote:
> > 
> > > On 1/6/21 1:55 PM, Jesse Brandeburg wrote:
> > > > When drivers call the various receive upcalls to receive an skb
> > > > to the stack, sometimes that stack can drop the packet. The
> > > > good
> > > > news is that the return code is given to all the drivers of
> > > > NET_RX_DROP or GRO_DROP. The bad news is that no drivers except
> > > > the one "ice" driver that I changed, check the stat and
> > > > increment
> > > If the stack is dropping the packet, isn't it up to the stack to
> > > track
> > > that, perhaps with something that shows up in netstat -s?  We
> > > don't
> > > really want to make the driver responsible for any drops that
> > > happen
> > > above its head, do we?
> > I totally agree!
> > 
> > In patch 2/2 I revert the driver-specific changes I had made in an
> > earlier patch, and this patch *was* my effort to make the stack
> > show the
> > drops.
> > 
> > Maybe I wasn't clear. I'm seeing packets disappear during TCP
> > workloads, and this GRO_DROP code was the source of the drops (I
> > see it
> > returning infrequently but regularly)
> > 
> > The driver processes the packet but the stack never sees it, and
> > there
> > were no drop counters anywhere tracking it.
> > 
> 
> My point is that the patch increments a netdev counter, which to my
> mind 
> immediately implicates the driver and hardware, rather than the
> stack.  
> As a driver maintainer, I don't want to be chasing driver packet
> drop 
> reports that are a stack problem.  I'd rather see a new counter in 
> netstat -s that reflects the stack decision and can better imply
> what 
> went wrong.  I don't have a good suggestion for a counter name at
> the 
> moment.
> 
> I guess part of the issue is that this is right on the boundary of 
> driver-stack.  But if we follow Eric's suggestions, maybe the
> problem 
> magically goes away :-) .
> 
> sln
> 

I think there is still some merit in this patchset even with Eric's
removal of GRO_DROP from gro_receive(). As Eric explained, it is still
possible to silently drop for the same reason when drivers
call napi_get_frags or even alloc_skb() apis, many drivers do not
account for such packet drops, and maybe it is the right thing to do to
inline the packet drop accounting into the skb alloc APIs ? the
question is, is it the job of those APIs to update netdev->stats ?





