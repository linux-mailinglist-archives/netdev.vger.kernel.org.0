Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8379C1CB518
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 18:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEHQmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 12:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbgEHQmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 12:42:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D030021582;
        Fri,  8 May 2020 16:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588956141;
        bh=vcPU+rx5pULADqGbBMLpriY4bFtBs1+dU4PrA35NxJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sKWRa+SHlfxVOJJC99k2E79+OHcoI+NOUZPduSasgkkbUCWtQVNQ8cWmbaXijfyQy
         HoAhT+pD1trrTU+QTjEXsqSMM0v6yU35rzp97DFlxpbUjI4tdbY4ChTkqJ0DigVNiQ
         kZSkLHyCPvfi0pigsgRbSGvxmi082gMq8C0jO52s=
Date:   Fri, 8 May 2020 09:42:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: Re: [PATCH net-next 7/7] net: atlantic: unify get_mac_permanent
Message-ID: <20200508094218.260acc03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <628e45f4-048a-2b8f-10c8-5b1908d54cc8@marvell.com>
References: <20200507081510.2120-1-irusskikh@marvell.com>
        <20200507081510.2120-8-irusskikh@marvell.com>
        <20200507122957.5dd4b84b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <628e45f4-048a-2b8f-10c8-5b1908d54cc8@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 12:14:51 +0300 Igor Russkikh wrote:
> >> This patch moves MAC generation into a separate function, which is called  
> >> from both places to reduce the amount of copy/paste.  
> > 
> > Right, but why do you have your own mac generation rather than using
> > eth_hw_addr_random(). You need to set NET_ADDR_RANDOM for example,
> > just use standard helpers, please.  
> 
> We want this still be an Aquantia vendor id MAC, not a fully random mac.
> Thats why the logic below randomizes only low three octets.

Are there any other drivers in tree which do that? I think the standard
operating procedure is:

if (!valid) {
	netdev_warn(dev, "Invalid MAC using random\n");
	eth_hw_addr_random(dev);
}

Please see all the eth_hw_addr_random() calls in drivers.

> >> +static inline bool aq_hw_is_zero_ether_addr(const u8 *addr)  
> > 
> > No static inlines in C files, please. Let compiler decide inlineing &
> > generate a warning when function becomes unused.  
> 
> Ok, will fix.
> 
> >> +	get_random_bytes(&rnd, sizeof(unsigned int));
> >> +	l = 0xE300 0000U | (0xFFFFU & rnd) | (0x00 << 16);
> >> +	h = 0x8001300EU;
> >> +
> >> +	mac[5] = (u8)(0xFFU & l);
> >> +	l >>= 8;
> >> +	mac[4] = (u8)(0xFFU & l);
> >> +	l >>= 8;
> >> +	mac[3] = (u8)(0xFFU & l);
> >> +	l >>= 8;
> >> +	mac[2] = (u8)(0xFFU & l);
> >> +	mac[1] = (u8)(0xFFU & h);
> >> +	h >>= 8;
> >> +	mac[0] = (u8)(0xFFU & h);  
> > 
> > This can be greatly simplified using helpers from etherdevice.h, if
> > it's really needed.  
> 
> This is the exact place where we put Aquantia vendor id, even if mac is random.
> 
> eth_hw_addr_random is more suitable for software devices like bridges, which
> are not related to any vendor.

What's the basis for this statement? 

Please look around the existing drivers.
