Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB18F63E2C8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 22:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiK3Vdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 16:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiK3Vd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 16:33:28 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7964E691;
        Wed, 30 Nov 2022 13:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lbdNefhhgXM7ZaI0RoGL+Vf+j9ov0wu6h8WSdMv2Ff4=; b=Pbt1JYlXAKfCaAMAYKIKJqHAwE
        B3ujmaiKSDSg1p+rvpwUQSaVq440+VzfZhlIKgv2f2A3GmOX+Y137OjVA956qFMRorszuLZoWZjrw
        fU3L3BXP/s06KhweF+IzNZ9GVP66u1x+7H2PFs5dButx9GT9nFbyhKEf7rGw0xi+hkfY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0UhK-00407n-Qa; Wed, 30 Nov 2022 22:32:54 +0100
Date:   Wed, 30 Nov 2022 22:32:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Brian Masney <bmasney@redhat.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cth451@gmail.com
Subject: Re: [PATCH] net: atlantic: fix check for invalid ethernet addresses
Message-ID: <Y4fMBl6sv+SUyt9Z@lunn.ch>
References: <20221130174259.1591567-1-bmasney@redhat.com>
 <Y4ex6WqiY8IdwfHe@lunn.ch>
 <Y4fGORYQRfYTabH1@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4fGORYQRfYTabH1@x1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > -	return !(addr[0] == 0 && addr[1] == 0 && addr[2] == 0);
> > > +	return !(addr[0] == 0 && addr[1] == 0 && addr[2] == 0) &&
> > > +		!(addr[3] == 0 && addr[4] == 0 && addr[5] == 0);
> > 
> > Hi Brian
> > 
> > is_valid_ether_addr()
> 
> aq_nic_ndev_register() already calls is_valid_ether_addr():
> 
> 	if (is_valid_ether_addr(addr) &&
> 	    aq_nic_is_valid_ether_addr(addr)) {
> 		(self->ndev, addr);
> 	} else {
> 		...
> 	}
> 
> That won't work for this board since that function only checks that the
> MAC "is not 00:00:00:00:00:00, is not a multicast address, and is not
> FF:FF:FF:FF:FF:FF." The MAC address that we get on all of our boards is
> 00:17:b6:00:00:00.

Which is a valid MAC address. So i don't see why the kernel should
reject it and use a random one.

Maybe you should talk to Marvell about how you can program the
e-fuses. You can then use MAC addresses from A8-97-DC etc.

	 Andrew
