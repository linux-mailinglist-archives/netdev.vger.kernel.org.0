Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BBC44C22D
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhKJNjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:39:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231210AbhKJNjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 08:39:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=virQNNKalV0a8U7ToqzDsctwOUdzNW0Hb+k7Zd27NHc=; b=qX
        751ZbcrzC+rctO8zfIW6W5PawRpvpMu1sWcKlDw4UV2Q+sDumVMC78Li2ZPWTqwRjjTeLTiJueOp4
        HXpEfexZns3lLDNDOe8fUS8DMpw7o+1WXEJz1z4oi/0qeJu2P5liG7S9RpsKPrbN5x4k5dcPsN+fo
        oqxCxJySoZOHPus=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mknlq-00D6pX-J4; Wed, 10 Nov 2021 14:36:10 +0100
Date:   Wed, 10 Nov 2021 14:36:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ecree.xilinx@gmail.com,
        hkallweit1@gmail.com, alexandr.lobakin@intel.com, saeed@kernel.org,
        netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv4 PATCH net-next] net: extend netdev_features_t
Message-ID: <YYvKyruLcemj6J+i@lunn.ch>
References: <20211107101519.29264-1-shenjian15@huawei.com>
 <YYr3FXJC3eu4AN31@lunn.ch>
 <86fa46f8-2a20-8912-7ec2-19257d6598db@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86fa46f8-2a20-8912-7ec2-19257d6598db@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 09:17:12AM +0800, shenjian (K) wrote:
> 
> 
> 在 2021/11/10 6:32, Andrew Lunn 写道:
> > > -	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
> > > +	if ((netdev_active_features_test_bit(netdev, NETIF_F_HW_TC_BIT) >
> > > +	    netdev_features_test_bit(NETIF_F_NTUPLE_BIT, features)) &&
> > Using > is interesting.
> will use
> 
> if (netdev_active_features_test_bit(netdev, NETIF_F_HW_TC_BIT) &&
>     !netdev_features_test_bit(netdev, NETIF_F_HW_TC_BIT))
> 
> instead.

I don't think it needs changing. It is just unusual. I had to think
about it, a while, and i was not initial sure it would still work.

> > But where did NETIF_F_NTUPLE_BIT come from?
> Thanks for catching this!
 
> > > -	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
> > > -		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
> > > -		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
> > > -		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
> > > -		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
> > > -		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
> > > +	netdev_features_zero(&features);
> > > +	netdev_features_set_array(hns3_default_features_array,
> > > +				  ARRAY_SIZE(hns3_default_features_array),
> > > +				  &features);
> > The original code is netdev->features |= so it is appending these
> > bits. Yet the first thing the new code does is zero features?
> > 
> >        Andrew
> > .
> The features is a local variable, the change for netdev->active_features is
> later, by calling
> 
> netdev_active_features_direct_or(netdev, features);

O.K. This and the NETIF_F_NTPLE_BIT points towards another issue. The
new API looks O.K. to me and we need to encourage more people to
review it. This patch allows us to see where you are going with the
change, and i think it is O.K.

However, you are about to modify a large number of files to swap to
this new API. Accidentally changing NETIF_F_HW_TC to
NETIF_F_NTUPLE_BIT is unlikely to be noticed in review given the size
of the change you are about to make. Changing the structure of the
code to later call netdev_active_features_direct_or() is going to be
messy. In order to have confidence you are not introducing a lot of
new bugs we are going to want to see the semantic patches which make
all the needed changes. So while waiting for further reviews, i
suggest you are start on the semantic patches. It could also be that
you want to modify the proposed API in minor ways to make it easier to
write the semantic patches.

      Andrew

