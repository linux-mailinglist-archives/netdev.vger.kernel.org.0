Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C48862CFC4
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiKQAdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiKQAdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:33:21 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E6D532C5
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EX9u5uTydEn4p+OgWvSoSP/Lj+p2xP9oUwwBGTuBWb4=; b=NL/Zi4t2z14jTsbNu6YRgL9z7P
        +3Ob8GZkXFO6QE+Fvors29VcUh/NodUYujTwQn3eFHJONuFuF9OXmwJejN5n14WBzNlQRJaDKjeLM
        Vyjv5LWeOhDklu77kZ74G8g9VGkDn71fCCVOtlb/hLkIvs3sEFkK1oWQ+Zf5NsptjDAg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovSqE-002d5b-64; Thu, 17 Nov 2022 01:33:18 +0100
Date:   Thu, 17 Nov 2022 01:33:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steve Williams <steve.williams@getcruise.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sandlan: Add the sandlan virtual network
 interface
Message-ID: <Y3WBTvhiCLd7+R5Y@lunn.ch>
References: <20221116222429.7466-1-steve.williams@getcruise.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116222429.7466-1-steve.williams@getcruise.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 02:24:29PM -0800, Steve Williams wrote:
> From: Stephen Williams <steve.williams@getcruise.com>
> 
> This is a virtual driver that is useful for testing network protocols
> or other complex networking without real ethernet hardware. Arbitrarily
> complex networks can be created and simulated by creating virtual network
> devices and assigning them to named broadcast domains, and all the usual
> ethernet-aware tools can operate on that network.
> 
> This is different from e.g. the tun/tap device driver in that it is not
> point-to-point.

My experience simulating networks using GNS3 and CORE is that you
combine tun/tap with a bridge. That reflects the reality of most of
todays networks, in that they no longer do CSMA-CD, they have point to
point links to a switch, the switch does address learning, filtering,
IGMP snooping, etc, and your total net bandwidth is much higher than
your line rate.

I did however recently learn that some T1 automotive network are
CSMA-CD, a good old fashioned shared bus.

So have you reimplemented basic bridge functionality? I've not looked
at the code yet to answer the question myself.

> +EXAMPLE
> +=======
> +
> +In this example, we create two NICs in a shared domain, and also create
> +a 3rd in the sae domain that wireshark can use to snoop on the network
> +traffic.
> +
> +First, make sure the interfaces exist::
> +
> +  echo +sandlan0 > /sys/class/net/sandlan_interfaces
> +  echo +sandlan1 > /sys/class/net/sandlan_interfaces
> +  echo +sandlan2 > /sys/class/net/sandlan_interfaces

A sysfs interface is unlikely to be accepted. You should be using
netlink.

ip link add sandlan0 type sandlan

etc.

> +While we're at it, demonstrate sandlan domains. Create a domain and
> +put all the interfaces in that domain. Note that this is a
> +connectivity domain, and not the same as netns namespaces::
> +
> +  echo +side > /sys/class/net/sandlan_domains
> +  echo side > /sys/class/net/sandlan0/sandlan/domain
> +  echo side > /sys/class/net/sandlan1/sandlan/domain
> +  echo side > /sys/class/net/sandlan2/sandlan/domain

ip link set sandlan0 domain side

   Andrew
