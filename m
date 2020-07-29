Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C70231C73
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 12:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgG2KDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 06:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgG2KDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 06:03:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8A0C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 03:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2C4goeNS4lNhuoX9pbxWtq6GEJCpzsG8u5XFiX4iRxU=; b=eWPnLoL+fqogF7iW3UpfTXAgs
        0UOJGbqAd5Z7SBSIkpisio5AB8csSq9/VilCvIB8IFtSSHm6OV3b7iH9oFVLGAJsAKb4HWbK0w/Tq
        2oOza5VZo38UtGl8rOZYgJCxKZnUShutU5ldiPVEBydrCinLm9PueUvx4t/P0zycLx4SRHW2Fm+ay
        M55lExhtB6swxljYQS45baEHjwMHyBHdGn4bzz5NmstFBfKYLhco1kZmTzkdnRwLN4iLv1vaMSVjJ
        a/4GeaJ0+gEd6GHkwYqgZoecnOQJapQ3zStwJifgNrob5YjWHrLzg00P6IR+DARBKqpSFryfGeVwY
        9MsIdJmng==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45632)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0ivO-0005G6-HB; Wed, 29 Jul 2020 11:03:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0ivJ-0005aF-Gg; Wed, 29 Jul 2020 11:02:57 +0100
Date:   Wed, 29 Jul 2020 11:02:57 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
Message-ID: <20200729100257.GX1551@shell.armlinux.org.uk>
References: <20200727090601.6500-1-kurt@linutronix.de>
 <20200727090601.6500-5-kurt@linutronix.de>
 <87a6zli04l.fsf@mellanox.com>
 <875za7sr7b.fsf@kurt>
 <87pn8fgxj3.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pn8fgxj3.fsf@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 11:06:08PM +0200, Petr Machata wrote:
> 
> Kurt Kanzenbach <kurt@linutronix.de> writes:
> 
> > On Mon Jul 27 2020, Petr Machata wrote:
> >> So this looks good, and works, but I'm wondering about one thing.
> >
> > Thanks for testing.
> >
> >>
> >> Your code (and evidently most drivers as well) use a different check
> >> than mlxsw, namely skb->len + ETH_HLEN < X. When I print_hex_dump()
> >> skb_mac_header(skb), skb->len in mlxsw with some test packet, I get e.g.
> >> this:
> >>
> >>     00000000259a4db7: 01 00 5e 00 01 81 00 02 c9 a4 e4 e1 08 00 45 00  ..^...........E.
> >>     000000005f29f0eb: 00 48 0d c9 40 00 01 11 c8 59 c0 00 02 01 e0 00  .H..@....Y......
> >>     00000000f3663e9e: 01 81 01 3f 01 3f 00 34 9f d3 00 02 00 2c 00 00  ...?.?.4.....,..
> >>                             ^sp^^ ^dp^^ ^len^ ^cks^       ^len^
> >>     00000000b3914606: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02  ................
> >>     000000002e7828ea: c9 ff fe a4 e4 e1 00 01 09 fa 00 00 00 00 00 00  ................
> >>     000000000b98156e: 00 00 00 00 00 00                                ......
> >>
> >> Both UDP and PTP length fields indicate that the payload ends exactly at
> >> the end of the dump. So apparently skb->len contains all the payload
> >> bytes, including the Ethernet header.
> >>
> >> Is that the case for other drivers as well? Maybe mlxsw is just missing
> >> some SKB magic in the driver.
> >
> > So I run some tests (on other hardware/drivers) and it seems like that
> > the skb->len usually doesn't include the ETH_HLEN. Therefore, it is
> > added to the check.
> >
> > Looking at the driver code:
> >
> > |static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
> > |					void *trap_ctx)
> > |{
> > |	[...]
> > |	/* The sample handler expects skb->data to point to the start of the
> > |	 * Ethernet header.
> > |	 */
> > |	skb_push(skb, ETH_HLEN);
> > |	mlxsw_sp_sample_receive(mlxsw_sp, skb, local_port);
> > |}
> >
> > Maybe that's the issue here?
> 
> Correct, mlxsw pushes the header very soon. Given that both
> ptp_classify_raw() and eth_type_trans() that are invoked later assume
> the header, it is reasonable. I have shuffled the pushes around and have
> a patch that both works and I think is correct.

Would it make more sense to do:

	u8 *data = skb_mac_header(skb);
	u8 *ptr = data;

	if (type & PTP_CLASS_VLAN)
		ptr += VLAN_HLEN;

	switch (type & PTP_CLASS_PMASK) {
	case PTP_CLASS_IPV4:
		ptr += IPV4_HLEN(ptr) + UDP_HLEN;
		break;

	case PTP_CLASS_IPV6:
		ptr += IP6_HLEN + UDP_HLEN;
		break;

	case PTP_CLASS_L2:
		break;

	default:
		return NULL;
	}

	ptr += ETH_HLEN;

	if (ptr + 34 > skb->data + skb->len)
		return NULL;

	return ptr;

in other words, compare pointers, so that whether skb_push() etc has
been used on the skb is irrelevant?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
