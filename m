Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF6D389863
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 23:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhESVIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 17:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhESVIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 17:08:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EE6B6100C;
        Wed, 19 May 2021 21:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621458420;
        bh=yT+FZcpEa4gUROQLcKv7whNLxo3Nsd8nwlRGNRxWB94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f9mJZ8yvp9B6zJ0zdKSLFdteddVhynPq/3U0pA+eJ5ywT0Yep280I7yi26BF4OJHF
         aurQ6r5/YE7gEjbslZNdhZxtiCX9FdJUiBk83RpGTOCWnQtzsPRVGI23CyaBppcpPb
         bgmP/ym4bfD3RXMtVWZ5pIuLuAu068dTQO5IxCSIUgXp2gSRw+cYJwuezLsXRQLOdw
         bOAIJzUbN7Hy2zz7Ps0BWKUHh38J2kEUYzl+IDP1+iugsCzO/PXbwmjp/3tKhr+QA6
         z1cgC+AkN+P4CAMma60tA97LdTz+1eYXu4vJWugc4ye2xrCxK6BLdrKPBM9+EkO6MW
         aCNayKvoh8zWQ==
Date:   Wed, 19 May 2021 14:06:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mlx5: count all link events
Message-ID: <20210519140659.30c3813c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <f48c950330996dcbb11f1a78b7c0a0445c656a20.camel@kernel.org>
References: <20210519171825.600110-1-kuba@kernel.org>
        <f48c950330996dcbb11f1a78b7c0a0445c656a20.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 May 2021 13:49:00 -0700 Saeed Mahameed wrote:
> On Wed, 2021-05-19 at 10:18 -0700, Jakub Kicinski wrote:
> > mlx5 devices were observed generating MLX5_PORT_CHANGE_SUBTYPE_ACTIVE
> > events without an intervening MLX5_PORT_CHANGE_SUBTYPE_DOWN. This
> > breaks link flap detection based on Linux carrier state transition
> > count as netif_carrier_on() does nothing if carrier is already on.
> > Make sure we count such events.
> 
> Can you share more on the actual scenario that has happened ? 
> in mlx5 i know of situations where fw might generate such events, just
> as FYI for virtual ports (vports) on some configuration changes.
> 
> another explanation is that in the driver we explicitly query the link
> state and we never take the event value, so it could have been that the
> link flapped so fast we missed the intermediate state.

The link flaps quite a bit, this is likely a bad cable or port.
I scanned the fleet a little bit more and I see a couple machines 
in such state, in each case the switch is also seeing the link flaps, 
not just the NIC. Without this patch the driver registers a full flap
once every ~15min, with the patch it's once a second. That's much
closer to what the switch registers.

Also the issue affects all hosts in MH, and persists across reboots
of a single host (hence I could test this patch).

> According to HW spec for some reason we should always query and not
> rely on the event. 
> 
> <quote>
> If software retrieves this indication (port state change event), this
> signifies that the state has been
> changed and a QUERY_VPORT_STATE command should be performed to get the
> new state.
> </quote>

I see, seems reasonable. I'm guessing the FW generates only one of the
events on minor type of faults? I don't think the link goes fully down,
because I can SSH to those machines, they just periodically drop
traffic. But the can't fully retrain the link at such high rate, 
I don't think.

> > netif_carrier_event() increments the counters and fires the linkwatch
> > events. The latter is not necessary for the use case but seems like
> > the right thing to do.
