Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1682826DC
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 23:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgJCVf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 17:35:28 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:46694 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725913AbgJCVf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 17:35:27 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 15FD6181D337B;
        Sat,  3 Oct 2020 21:35:26 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4250:4321:4605:5007:10004:10400:10481:10848:11026:11232:11658:11914:12043:12296:12297:12740:12760:12895:13069:13095:13255:13311:13357:13439:13548:13972:14659:14721:19900:21080:21433:21611:21627:21990:30003:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: rail62_5216b07271b0
X-Filterd-Recvd-Size: 2049
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Sat,  3 Oct 2020 21:35:24 +0000 (UTC)
Message-ID: <d44d8c784f9df6f55dcf494c9c21cd11b16338d4.camel@perches.com>
Subject: Re: [PATCH v3] net: usb: rtl8150: set random MAC address when
 set_ethernet_addr() fails
From:   Joe Perches <joe@perches.com>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 03 Oct 2020 14:35:23 -0700
In-Reply-To: <20201003211931.11544-1-anant.thazhemadam@gmail.com>
References: <20201003211931.11544-1-anant.thazhemadam@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-10-04 at 02:49 +0530, Anant Thazhemadam wrote:
> When get_registers() fails, in set_ethernet_addr(),the uninitialized
> value of node_id gets copied as the address. This can be considered as
> set_ethernet_addr() itself failing.
[]
> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
[]
> @@ -909,7 +914,10 @@ static int rtl8150_probe(struct usb_interface *intf,
>  		goto out1;
>  	}
>  	fill_skb_pool(dev);
> -	set_ethernet_addr(dev);
> +	if (!set_ethernet_addr(dev)) {
> +		dev_err(&intf->dev, "assigining a random MAC address\n");
> +		eth_hw_addr_random(dev->netdev);

4 things:

o Typo for assigning
o Reverse the assignment and message to show the new random MAC
o This should use netdev_<level>
o Is this better as error or notification?

	if (!set_ethernet_addr(dev)) {
		eth_hw_addr_random(dev->netdev);
		netdev_notice(dev->netdev, "Assigned a random MAC: %pM\n",
			      dev->netdev->dev_addr);
	}

