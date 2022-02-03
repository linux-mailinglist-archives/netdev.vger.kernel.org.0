Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFF94A7EC5
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 05:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349311AbiBCE7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 23:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiBCE7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 23:59:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35BBC061714;
        Wed,  2 Feb 2022 20:59:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57D12B810E5;
        Thu,  3 Feb 2022 04:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E63CC340E8;
        Thu,  3 Feb 2022 04:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643864357;
        bh=X/IN/ufaQVVqsfNzGe5ik9OdqOkQduoWax2aLSQm6kY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qjIGYBj9mlOBAE96jS1sfVxgqO6RrhhMrfyusX1gBxXElem4To8eTuiQ78uuLJbZf
         3o5e6bJFEr9pWSdQ36f4nSSMavy/qXzyQTz5iDNWFaJFdUtrNjnXppI0DnpIkf6a8W
         /d/HSL2h8inQKXpvxVOmsRv1JF8kDjBRczfM7IhTMFBZ0GH1gfVcovBk7IdRVyjIRg
         jCM2E0XlshrZd55yhVqYtmSnt78DlaTRkeWEspr6o0BVvzsjtQZbqkIVehLbOK+VkL
         QZVyU9hHwDG4wn/6cEEpWfc7gLuR984XQJd2i3/feN2KXleYELtHGG7vj6ZfOc2PO5
         VrJ2bJLmF/YXA==
Date:   Wed, 2 Feb 2022 20:59:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v6 net-next] net-core: add InMacErrors counter
Message-ID: <20220202205916.58f4a592@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220201222845.3640041-1-jeffreyji@google.com>
References: <20220201222845.3640041-1-jeffreyji@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Feb 2022 22:28:45 +0000 Jeffrey Ji wrote:
> From: jeffreyji <jeffreyji@google.com>
> 
> Increment InMacErrors counter when packet dropped due to incorrect dest
> MAC addr.
> 
> An example when this drop can occur is when manually crafting raw
> packets that will be consumed by a user space application via a tap
> device. For testing purposes local traffic was generated using trafgen
> for the client and netcat to start a server
> 
> example output from nstat:
> \~# nstat -a | grep InMac
> Ip6InMacErrors                  0                  0.0
> IpExtInMacErrors                1                  0.0

I had another thing and this still doesn't sit completely well 
with me :(

Shouldn't we count those drops as skb->dev->rx_dropped?
Commonly NICs will do such filtering and if I got it right
in struct rtnl_link_stats64 kdoc - report them as rx_dropped.
It'd be inconsistent if on a physical interface we count
these as rx_dropped and on SW interface (or with promisc enabled 
etc.) in the SNMP counters. 
Or we can add a new link stat that NICs can use as well.

In fact I'm not sure this is really a IP AKA L3 statistic,
it's the L2 address that doesn't match.


If everyone disagrees - should we at least rename the MIB counter
similarly to the drop reason? Experience shows that users call for 
help when they see counters with Error in their name, I'd vote for
IpExtInDropOtherhost or some such. The statistic should also be
documented in Documentation/networking/snmp_counter.rst
