Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED9A365F71
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhDTSfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233587AbhDTSey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 14:34:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3055361002;
        Tue, 20 Apr 2021 18:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618943662;
        bh=em6cx2HBxMwbhr6KaCllMTUwubhy8v8uRwj/RBaSigs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a+7/zfIUj3cUkwkz8a8LdV1bB3rMoS404I/qpQ6nWScZNcmnHWVJYDsgiyHbs/yAc
         4T/oS7l7fNHWbir/e8V3oFJ0zBgVCkrsqKHBmgqjoa0B9DW1Kvv6u/UrfEWgUcfk2w
         qSwmoatNxQkeOC+CDgHJgHYxmIBRpcjh3j8ZA60gMvQIvbO6B2DZgipb1n+33+00JG
         VwcWkpdoNK6olKESeBIvP208KaIEyBOaBP7PrwHkRyJV60aforGAmeV3/rWfgRKgXG
         nwb0wp0IPHW0fT1F9y4l2HLlbUqIAoGlzlokPDGTm2lLMy9RAJjTIzPMexHYdd7bqt
         +5Gr54GLIMtsA==
Date:   Tue, 20 Apr 2021 11:34:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 4/6] r8152: support new chips
Message-ID: <20210420113420.79d7c65a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0de9842749db4718b8f45a0f2fff7967@realtek.com>
References: <1394712342-15778-350-Taiwan-albertk@realtek.com>
        <1394712342-15778-354-Taiwan-albertk@realtek.com>
        <20210416145017.1946f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0de9842749db4718b8f45a0f2fff7967@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 07:00:39 +0000 Hayes Wang wrote:
> > > @@ -6878,7 +8942,11 @@ static int rtl8152_probe(struct usb_interface *intf,  
> > >  	set_ethernet_addr(tp);
> > >
> > >  	usb_set_intfdata(intf, tp);
> > > -	netif_napi_add(netdev, &tp->napi, r8152_poll, RTL8152_NAPI_WEIGHT);
> > > +
> > > +	if (tp->support_2500full)
> > > +		netif_napi_add(netdev, &tp->napi, r8152_poll, 256);  
> > 
> > why 256? We have 100G+ drivers all using 64 what's special here?
> >   
> > > +	else
> > > +		netif_napi_add(netdev, &tp->napi, r8152_poll, 64);  
> 
> We test 2.5G Ethernet on some embedded platform.
> And we find 64 is not large enough, and the performance
> couldn't reach 2.5 G bits/s.

Did you manage to identify what the cause is?

NAPI will keep calling your driver if the budget was exhausted, the
only difference between 64 and 256 should be the setup cost of the
driver's internal loop. And perhaps more frequent GRO flush - what's
the CONFIG_HZ set to?

