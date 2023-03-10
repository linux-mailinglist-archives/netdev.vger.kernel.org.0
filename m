Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F116B429D
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 15:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjCJOE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 09:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbjCJOEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 09:04:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F124216303;
        Fri, 10 Mar 2023 06:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=acNodJD2WAKf57OqVLqP1J5aQ8nNbHY7zv9kAeoHAlI=; b=kIPWFiZDUo+EHrOqCDzaJPaV7Q
        X6c7V5nUb3ffXA/fxKt6vbHQPuVgWicK0vd2ZkMX6uyx85HrgtRZdyucywrVYV/Cc/fzQUBxx7bqf
        doQkNQVtXtIRMjFotope2Ny8g8yx565Z9PrT3aTQtZFMp6OvYlm553fO8IoXjHJf/D0wXbpSXtZB/
        PZGM46tnfnTZz2sHs9h+flgCMOiupvD95P4S0re/FMEZlML6nw0D4KVV4BOblwt0pmJz+7I6V6nWw
        q7/PnbKJoxWQn7d/44wxBIRCZWZUul+w5xjcUsPdoqxloGjSeCbkP3pQdYb2TaaN+vwRlkxxSzQGI
        ZgUSO7nQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35434)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1padMP-0006m3-SA; Fri, 10 Mar 2023 14:04:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1padMN-0004k3-Ul; Fri, 10 Mar 2023 14:04:39 +0000
Date:   Fri, 10 Mar 2023 14:04:39 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <ZAs492RCZcz6oyW7@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-2-lukma@denx.de>
 <20230310120235.2cjxauvqxyei45li@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310120235.2cjxauvqxyei45li@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 02:02:35PM +0200, Vladimir Oltean wrote:
> It would be good if the commit message contained the procedure based on
> which you had made these changes - and preferably they were mechanical.
> Having a small C program written would be absolutely ideal.
> This is so that reviewers wouldn't have to do it in parallel...
> 
> My analysis has determined the following 3 categories:
> 
> static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
> {
> 	struct mv88e6xxx_chip *chip = ds->priv;
> 
> 	if (chip->info->ops->port_set_jumbo_size)
> 		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; // 10210
> 	else if (chip->info->ops->set_max_frame_size)
> 		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; // 1602
> 	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; // 1492

The question concerning the 1492 MTU (and the others above) is
something that does need to be addressed, but I don't believe it
should be part of this patch series.

In order to properly address this, we need to do a bit of research.
Originally, the driver calculated the MTU by taking the frame size
(1522, 1632 or 10240) and subtracting VLAN_ETH_HLEN and ETH_FCS_LEN.

This would mean the frame sizes were 1500, 1610 and 10218. However,
as a result of:

commit b9c587fed61cf88bd45822c3159644445f6d5aa6
Author: Andrew Lunn <andrew@lunn.ch>
Date:   Sun Sep 26 19:41:26 2021 +0200

    dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports

This was changed to include the EDSA_HLEN of 8 bytes. The question
is why - and that's a question for Andrew.

The frame size check is not well described looking at the 6176
functional specification. It takes about using an adjusted frame
size in the paragraph that talks about ingress headers, but then
it only takes about adjusting by two bytes which are sent before
the DA, only if MV88E6XXX_PORT_CTL0_HEADER is set (which we don't
touch).

Against the bits that control the maximum frame size, it does state
that "the definition of frame size is counting the frame bytes from
MAC-DA through Layer2 CRC of the frame".

No mention is made whether the EDSA header is included or not, the
assumption was that it wasn't prior to the commit above, but it
would appear that caused a problem, so the EDSA header was added.

Now, obviously, on external ports (those which don't use the EDSA
header) the EDSA header doesn't restrict the size of packets sent
or received on that port. However, the header does exist on the
CPU port - and the obvious question is, does the max frame size
apply, and if so does it apply with the EDSA header included or
excluded. We don't know from the documentation.

DSA ports (those between switches) don't use the EDSA header, but
instead use the DSA header which is four bytes long. Again, whether
that is included in the maximum frame size is unspecified.

Maybe Andrew has some input here as he made the above commit and
can remember why it was necessary.

However, to me, it seems to be rather absurd as it would mean that
on a device that only supports 1522 maximum packet size, the CPU
port using an EDSA header would be incapable of sending or
receiving a packet containing 1500 bytes of payload, VLAN header
and ethernet header, because as soon as the EDSA header is added
we're over the 1522 limit - and that would basically mean the
switch can't be used in a normal ethernet network to switch
such packets.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
