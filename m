Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA155A165B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 18:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242773AbiHYQIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 12:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237841AbiHYQIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 12:08:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F747B2DA8;
        Thu, 25 Aug 2022 09:08:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AC6761B4E;
        Thu, 25 Aug 2022 16:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E320BC433D7;
        Thu, 25 Aug 2022 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661443724;
        bh=IMsQUj71lEbOVDscuHJdk+CmFlQ43bhAr+LVmmu7XPY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SMb3Rw2CXh0D0k6QofNIIJw1t8s5pxMXZ+HdBCy0bBZG1uYZYNTDsCLtLcdhuRRNH
         lPtht2fXW+ApBX/T5JbFjUgXxmh1navyVJYyFtbNZR8AjjeMgdP6EZcmJQ5qvkpfcG
         9mE9OyNKiZbZxnyXKf7IEbr9l0dnhUQ3kYyEvgYDraXxn+hiE72il3x9MvrafedmCE
         AOd5ccrxBObNPD0j+qZqcl3L3ND6b4gU+s4SFHCqoItbqGC2hq5lirYFbDxlv9CrQV
         umB4GQBEpqmh7GpS6izlWll15cPgMHvkEZ5xN0EhxrUbBKa5WOfXVVyi0QUCdcg/mo
         GKZWr9O+95w3g==
Date:   Thu, 25 Aug 2022 09:08:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     andrei.tachici@stud.acs.upb.ro
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, hkallweit1@gmail.com, joel@jms.id.au,
        krzysztof.kozlowski+dt@linaro.org, l.stelmach@samsung.com,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        vegard.nossum@oracle.com, vladimir.oltean@nxp.com
Subject: Re: [net-next v5 2/3] net: ethernet: adi: Add ADIN1110 support
Message-ID: <20220825090842.24c5bc7f@kernel.org>
In-Reply-To: <20220825105517.19301-1-andrei.tachici@stud.acs.upb.ro>
References: <20220823160241.36bc2480@kernel.org>
        <20220825105517.19301-1-andrei.tachici@stud.acs.upb.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 13:55:17 +0300 andrei.tachici@stud.acs.upb.ro wrote:
> > I thought this is a callback for legacy SR-IOV NICs. What are you using
> > it for in a HW device over SPI? :S  
> 
> Here I wanted to allow the user to change between VEPA/VEB. The ADIN2111 switch
> is not VLAN aware and also can't do any meaningful forwarding when multiple
> ports from multiple ADIN2111 switches are added to the same software bridge. For these
> cases I thought the user would like to disable hardware forwarding (VEB).

VEPA/VEB is only for traffic originating on the host, it's sort of
inverse of what you're doing. In SR-IOV host has "multiple ports"
not the device. So the question is whether the device punts the packets
produced by the host to the network or tries to switch them internally.
In the former case the connected switch must support hair-pinning the
traffic.

A completely different kettle of fish that "should I forward between
two external ports".

> Should detect the above cases and automatically disable any forwarding instead?

Bridge offloading experts would have to help us out regarding what
other drivers do, I'd think that offload for a bridge straddling
multiple ASICs should still be possible. You can program the forwarding
based on the FDB of the host.
 
> Hardware forwarding translates to: I don't know this MAC address (not my MAC address)
> throw it back to the other port. ADIN2111 can't learn the FDB, although has 16 entries that
> can be statically programmed.

Do the 16 entries control forwarding (ie. allow you to decide forward
to other port vs forward to host)? Or just trap the packets that match
to the host?
