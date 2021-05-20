Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684B7389A52
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 02:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhETAIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 20:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhETAIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 20:08:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F23F261074;
        Thu, 20 May 2021 00:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621469221;
        bh=oW9HLixCOVzavCFez1aoL3mPt1aIQQd6USvqcCYfClk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y4enn5UJK+2NnIeOdKNArG97lC7QFnH0K+g401ySdvkeFzU6CqIl/tDOuO+HhN7Ye
         msej3Jak1RcuPHxdMMImJFY27JZ4O/PaEI/humVv28rivJDMQlEZ1zq931bj9Juh/O
         3P96DEtASI4GF7SA32kmcxy3EPgqUijtev8yIPKpBd9JpP5gzZFooWsI4hkefHUx0t
         aZDUHxs74YPZIDTvDIXRuq1/EpJgXGc/nfpDaAC7MaiCOsE6nwleALSaoq4q9rUu2K
         GxK96FD77TjQOo2KUfl89vgojejM93IkOHMDowxE16rrWF8DpMGF8S/AB9gImW4XKJ
         AUFdgV25uX3sw==
Message-ID: <35937fe6d371a43aa0bfe70c9fab549b62089592.camel@kernel.org>
Subject: Re: [PATCH net-next] mlx5: count all link events
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Date:   Wed, 19 May 2021 17:07:00 -0700
In-Reply-To: <20210519140659.30c3813c@kicinski-fedora-PC1C0HJN>
References: <20210519171825.600110-1-kuba@kernel.org>
         <f48c950330996dcbb11f1a78b7c0a0445c656a20.camel@kernel.org>
         <20210519140659.30c3813c@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-05-19 at 14:06 -0700, Jakub Kicinski wrote:
> On Wed, 19 May 2021 13:49:00 -0700 Saeed Mahameed wrote:
> > On Wed, 2021-05-19 at 10:18 -0700, Jakub Kicinski wrote:
> > > mlx5 devices were observed generating
> > > MLX5_PORT_CHANGE_SUBTYPE_ACTIVE
> > > events without an intervening MLX5_PORT_CHANGE_SUBTYPE_DOWN. This
> > > breaks link flap detection based on Linux carrier state
> > > transition
> > > count as netif_carrier_on() does nothing if carrier is already
> > > on.
> > > Make sure we count such events.
> > 
> > Can you share more on the actual scenario that has happened ? 
> > in mlx5 i know of situations where fw might generate such events,
> > just
> > as FYI for virtual ports (vports) on some configuration changes.
> > 
> > another explanation is that in the driver we explicitly query the
> > link
> > state and we never take the event value, so it could have been that
> > the
> > link flapped so fast we missed the intermediate state.
> 
> The link flaps quite a bit, this is likely a bad cable or port.
> I scanned the fleet a little bit more and I see a couple machines 
> in such state, in each case the switch is also seeing the link flaps,
> not just the NIC. Without this patch the driver registers a full flap
> once every ~15min, with the patch it's once a second. That's much
> closer to what the switch registers.
> 
> Also the issue affects all hosts in MH, and persists across reboots
> of a single host (hence I could test this patch).
> 

reproduces on reboots even with a good cable ? 
you reboot the peer machine or the DUT (under test) machine ?

> > According to HW spec for some reason we should always query and not
> > rely on the event. 
> > 
> > <quote>
> > If software retrieves this indication (port state change event),
> > this
> > signifies that the state has been
> > changed and a QUERY_VPORT_STATE command should be performed to get
> > the
> > new state.
> > </quote>
> 
> I see, seems reasonable. I'm guessing the FW generates only one of
> the
> events on minor type of faults? I don't think the link goes fully
> down,
> because I can SSH to those machines, they just periodically drop
> traffic. But the can't fully retrain the link at such high rate, 
> I don't think.
> 

hmm, Then i would like to get to the bottom of this, so i will have to
consult with FW.
But regardless, we can progress with the patch, I think the HW spec
description forces us to do so.. 



