Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB4028C3B0
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 23:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbgJLVBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 17:01:20 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:36686 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729639AbgJLVBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 17:01:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CJIzxj74bRbK6s07BM0CYFriStr95mhUR/FUtxsHOVI=; b=cyr+pQNICJxG1pzmfwF4K8B77P
        xbKi8vFMvJcXOeKnMkdUYQn+MEsresCGmf29nTQmbd+YE8gU2/8BmXmi5H0vPXAG8SOyc+5Wxrkja
        tTbvRUyzQ9l0MqbHI/cn0jK0BjZGcZrQFqIXMZbwNb59/nzYODrQ56QYd6+q01k8GwZA=;
Received: from lan.nucleusys.com ([92.247.61.126] helo=nucleusys.com)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kS4wN-0007CC-HJ; Tue, 13 Oct 2020 00:01:07 +0300
Date:   Tue, 13 Oct 2020 00:01:06 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Joe Perches <joe@perches.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.8 18/24] net: usb: rtl8150: set random MAC
 address when set_ethernet_addr() fails
Message-ID: <20201012210105.GA26582@nucleusys.com>
References: <20201012190239.3279198-1-sashal@kernel.org>
 <20201012190239.3279198-18-sashal@kernel.org>
 <c93d120c850c5fecadaea845517f0fdbfd9a61c7.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c93d120c850c5fecadaea845517f0fdbfd9a61c7.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-10-12 12:11:18, Joe Perches wrote: > On Mon, 2020-10-12
    at 15:02 -0400, Sasha Levin wrote: > > From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
    > > > > [ Upstream commit f45a4248ea4cc13ed50 [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-10-12 12:11:18, Joe Perches wrote:
> On Mon, 2020-10-12 at 15:02 -0400, Sasha Levin wrote:
> > From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> > 
> > [ Upstream commit f45a4248ea4cc13ed50618ff066849f9587226b2 ]
> > 
> > When get_registers() fails in set_ethernet_addr(),the uninitialized
> > value of node_id gets copied over as the address.
> > So, check the return value of get_registers().
> > 
> > If get_registers() executed successfully (i.e., it returns
> > sizeof(node_id)), copy over the MAC address using ether_addr_copy()
> > (instead of using memcpy()).
> > 
> > Else, if get_registers() failed instead, a randomly generated MAC
> > address is set as the MAC address instead.
> 
> This autosel is premature.
> 
> This patch always sets a random MAC.
> See the follow on patch: https://lkml.org/lkml/2020/10/11/131
> To my knowledge, this follow-ob has yet to be applied:

ACK, the follow-on patch has got the correct semantics.


		Petko


> > diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> []
> > @@ -274,12 +274,20 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
> >  		return 1;
> >  }
> >  
> > -static inline void set_ethernet_addr(rtl8150_t * dev)
> > +static void set_ethernet_addr(rtl8150_t *dev)
> >  {
> > -	u8 node_id[6];
> > +	u8 node_id[ETH_ALEN];
> > +	int ret;
> > +
> > +	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
> >  
> > -	get_registers(dev, IDR, sizeof(node_id), node_id);
> > -	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
> > +	if (ret == sizeof(node_id)) {
> 
> So this needs to use
> 	if (!ret) {
> 
> or 
> 	if (ret < 0)
> 
> and reversed code blocks
> 
> > +		ether_addr_copy(dev->netdev->dev_addr, node_id);
> > +	} else {
> > +		eth_hw_addr_random(dev->netdev);
> > +		netdev_notice(dev->netdev, "Assigned a random MAC address: %pM\n",
> > +			      dev->netdev->dev_addr);
> > +	}
> >  }
> >  
> >  static int rtl8150_set_mac_address(struct net_device *netdev, void *p)
> 
> 
