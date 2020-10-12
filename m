Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3066428C13F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391108AbgJLTLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:11:23 -0400
Received: from smtprelay0133.hostedemail.com ([216.40.44.133]:37514 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388013AbgJLTLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 15:11:23 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id E3DE9100E7B44;
        Mon, 12 Oct 2020 19:11:20 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:7514:7576:7903:9025:9165:10004:10400:10471:10481:10848:11026:11232:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:13069:13255:13311:13357:13439:13972:14181:14659:14721:19900:21080:21451:21611:21627:21788:21939:21990:30003:30012:30054:30070:30079:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: lamp55_0c0ae3f271fc
X-Filterd-Recvd-Size: 2942
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Mon, 12 Oct 2020 19:11:19 +0000 (UTC)
Message-ID: <c93d120c850c5fecadaea845517f0fdbfd9a61c7.camel@perches.com>
Subject: Re: [PATCH AUTOSEL 5.8 18/24] net: usb: rtl8150: set random MAC
 address when set_ethernet_addr() fails
From:   Joe Perches <joe@perches.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Date:   Mon, 12 Oct 2020 12:11:18 -0700
In-Reply-To: <20201012190239.3279198-18-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
         <20201012190239.3279198-18-sashal@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-12 at 15:02 -0400, Sasha Levin wrote:
> From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> 
> [ Upstream commit f45a4248ea4cc13ed50618ff066849f9587226b2 ]
> 
> When get_registers() fails in set_ethernet_addr(),the uninitialized
> value of node_id gets copied over as the address.
> So, check the return value of get_registers().
> 
> If get_registers() executed successfully (i.e., it returns
> sizeof(node_id)), copy over the MAC address using ether_addr_copy()
> (instead of using memcpy()).
> 
> Else, if get_registers() failed instead, a randomly generated MAC
> address is set as the MAC address instead.

This autosel is premature.

This patch always sets a random MAC.
See the follow on patch: https://lkml.org/lkml/2020/10/11/131
To my knowledge, this follow-ob has yet to be applied:

> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
[]
> @@ -274,12 +274,20 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
>  		return 1;
>  }
>  
> -static inline void set_ethernet_addr(rtl8150_t * dev)
> +static void set_ethernet_addr(rtl8150_t *dev)
>  {
> -	u8 node_id[6];
> +	u8 node_id[ETH_ALEN];
> +	int ret;
> +
> +	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
>  
> -	get_registers(dev, IDR, sizeof(node_id), node_id);
> -	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
> +	if (ret == sizeof(node_id)) {

So this needs to use
	if (!ret) {

or 
	if (ret < 0)

and reversed code blocks

> +		ether_addr_copy(dev->netdev->dev_addr, node_id);
> +	} else {
> +		eth_hw_addr_random(dev->netdev);
> +		netdev_notice(dev->netdev, "Assigned a random MAC address: %pM\n",
> +			      dev->netdev->dev_addr);
> +	}
>  }
>  
>  static int rtl8150_set_mac_address(struct net_device *netdev, void *p)

