Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E158D282659
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 21:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgJCTi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 15:38:26 -0400
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:50376 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725831AbgJCTi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 15:38:26 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 211BE100E7B42;
        Sat,  3 Oct 2020 19:38:25 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3870:4321:5007:10004:10400:10471:10481:10848:11026:11232:11658:11914:12043:12114:12296:12297:12740:12760:12895:13069:13255:13311:13357:13439:13972:14659:14721:19900:21080:21611:21627:21990:30003:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: join71_03142d2271af
X-Filterd-Recvd-Size: 2101
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Sat,  3 Oct 2020 19:38:23 +0000 (UTC)
Message-ID: <dbe67fce55c6bbe569cefdc1a01708a0d01b140a.camel@perches.com>
Subject: Re: [Linux-kernel-mentees][PATCH v2] net: usb: rtl8150: prevent
 set_ethernet_addr from setting uninit address
From:   Joe Perches <joe@perches.com>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 03 Oct 2020 12:38:22 -0700
In-Reply-To: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
References: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 13:02 +0530, Anant Thazhemadam wrote:
> When get_registers() fails (which happens when usb_control_msg() fails)
> in set_ethernet_addr(), the uninitialized value of node_id gets copied
> as the address.

unrelated trivia:

> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
[]
> @@ -274,12 +274,17 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
>  		return 1;
>  }
>  
> -static inline void set_ethernet_addr(rtl8150_t * dev)
> +static bool set_ethernet_addr(rtl8150_t *dev)
>  {
>  	u8 node_id[6];

This might be better as:

	u8 node_id[ETH_ALEN];

> +	int ret;
>  
> -	get_registers(dev, IDR, sizeof(node_id), node_id);
> -	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
> +	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
> +	if (ret == sizeof(node_id)) {
> +		memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));

and
		ether_addr_copy(dev->netdev->dev_addr, node_id);


