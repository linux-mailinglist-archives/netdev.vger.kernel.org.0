Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92ED16CA68C
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 15:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjC0Nzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 09:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjC0Nzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 09:55:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFACA3C18
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 06:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=qA2qmUmgzNZ6M5hGxW776YMPYLee0DGlWsrhfRKnr8Q=; b=hw
        vfO27TX4l/fxG4dUJJB76uuvQOcObu62aIQCH+/otfoVAN09Mrmw4V3JLeFg6fggqFTN0zqs3GWmg
        qr7e3qZQZTFgKtnDvfz+LXrl2Db0ivRGHv7af3ixpOi/TNUF9R9I8RmR3zRvKVR+ISsD/JGvsYaF+
        6ldfSx9nVYLzmzE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgnK2-008Wco-Lv; Mon, 27 Mar 2023 15:55:42 +0200
Date:   Mon, 27 Mar 2023 15:55:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, steffen@innosonix.de,
        Fabio Estevam <festevam@denx.de>
Subject: Re: [RFC] net: dsa: mv88e6xxx disable IGMP snooping on cpu port
Message-ID: <8bba8376-95f8-42d0-a6c2-6ea88f684113@lunn.ch>
References: <20230327134832.216867-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230327134832.216867-1-festevam@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 10:48:32AM -0300, Fabio Estevam wrote:
> From: Steffen Bätz <steffen@innosonix.de>
> 
> Don't enable IGMP snooping on CPU ports because the IGMP JOIN
> packet would never forward to the next bridge, but loop back to
> the actual cpu port.
> 
> The mv88e6320 manual describes the MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP
> bit as follows:
> 
> "IGMP and MLD Snooping. When this bit is set to a one and this port
> receives an IPv4 IGMP frame or an IPv6MLD frame, the frame is switched
> to the CPU port overriding the destination ports determined by the DA
> mapping.
> When this bit is cleared to a zero IGMP/MLD frames are not treated
> specially.
> IGMP/MLD Snooping is intended to be used on Normal Network or Provider
> ports only (see Frame Mode bits
> below) and only if Cut Through (88E6632 only) is disabled on the port
> (Port offset 0x1F) as the IPv6 Snoop point may be after byte 64."
> 
> If this bit is set (it was set at ALL ports), the mv88e6320 will snoop
> for any IGMP messages, and route them to the configured CPU port. This
> will hinder any outgoing IGMP messages from the CPU from leaving the
> switch, since they are immediately looped back to the CPU itself.

Hi Fabio, Steffen

It seems like you need the same change for DSA ports as well?

I did test IGMP snooping many years ago and it seemed to work. Has
there been any recent change in this code? Or is any of this behaviour
specific to the 6320? I probably tested using 6352, or 6390.

	 Andrew
