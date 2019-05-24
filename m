Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2477329ADA
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389352AbfEXPTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:19:13 -0400
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:33270 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389079AbfEXPTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 11:19:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 6A263837F252;
        Fri, 24 May 2019 15:19:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3873:3874:4321:5007:10004:10400:10848:11026:11232:11658:11914:12043:12296:12740:12760:12895:13069:13095:13137:13150:13230:13231:13311:13357:13439:13972:14039:14659:14721:21080:21324:21433:21451:21627:30029:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:28,LUA_SUMMARY:none
X-HE-Tag: eye33_15cd51fc83639
X-Filterd-Recvd-Size: 2470
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Fri, 24 May 2019 15:19:09 +0000 (UTC)
Message-ID: <f6286af05b1eda38b103ef1337cd7086d3ea4372.camel@perches.com>
Subject: Re: [PATCH net] bonding: make debugging output more succinct
From:   Joe Perches <joe@perches.com>
To:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Fri, 24 May 2019 08:19:07 -0700
In-Reply-To: <20190524135623.17326-1-jarod@redhat.com>
References: <20190524135623.17326-1-jarod@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-24 at 09:56 -0400, Jarod Wilson wrote:
> Seeing bonding debug log data along the lines of "event: 5" is a bit spartan,
> and often requires a lookup table if you don't remember what every event is.
> Make use of netdev_cmd_to_name for an improved debugging experience, so for
> the prior example, you'll see: "bond_netdev_event received NETDEV_REGISTER"
> instead (both are prefixed with the device for which the event pertains).
> 
> There are also quite a few places that the netdev_dbg output could stand to
> mention exactly which slave the message pertains to (gets messy if you have
> multiple slaves all spewing at once to know which one they pertain to).
[]
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
[]
> @@ -1515,7 +1515,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>  	new_slave->original_mtu = slave_dev->mtu;
>  	res = dev_set_mtu(slave_dev, bond->dev->mtu);
>  	if (res) {
> -		netdev_dbg(bond_dev, "Error %d calling dev_set_mtu\n", res);
> +		netdev_dbg(bond_dev, "Error %d calling dev_set_mtu for slave %s\n",
> +			   res, slave_dev->name);

Perhaps better to add and use helper mechanisms like:

#define slave_dbg(bond_dev, slave_dev, fmt, ...)				\
	netdev_dbg(bond_dev, "(slave %s) " fmt, (slave_dev)->name, ##__VA_ARGS__)

So this might be
		slave_dbg(bond_dev, slave_dev, "Error %d calling dev_set_mtu\n",
			  res);
etc...

So there would be a unified style to grep in the logs.

