Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CE1E9624
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 06:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfJ3FvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 01:51:08 -0400
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:39252 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725855AbfJ3FvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 01:51:08 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id A3105180388F1;
        Wed, 30 Oct 2019 05:51:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:599:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2896:2902:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3874:4321:4385:5007:7576:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:13069:13095:13255:13311:13357:13439:14181:14659:14721:21080:21433:21451:21627:21740:21939:30003:30029:30045:30046:30054:30055:30070:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: nest43_60c9df2ab6455
X-Filterd-Recvd-Size: 2239
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Wed, 30 Oct 2019 05:51:05 +0000 (UTC)
Message-ID: <b552e8483feae4c122c862dcb8483f482f942763.camel@perches.com>
Subject: Re: [net-next 2/8] e1000e: Use rtnl_lock to prevent race conditions
 between net and pci/pm
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Morumuri Srivalli <smorumu1@in.ibm.com>,
        David Dai <zdai@linux.vnet.ibm.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Date:   Tue, 29 Oct 2019 22:50:57 -0700
In-Reply-To: <20191030043633.26249-3-jeffrey.t.kirsher@intel.com>
References: <20191030043633.26249-1-jeffrey.t.kirsher@intel.com>
         <20191030043633.26249-3-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-29 at 21:36 -0700, Jeff Kirsher wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> This patch is meant to address possible race conditions that can exist
> between network configuration and power management. A similar issue was
> fixed for igb in commit 9474933caf21 ("igb: close/suspend race in
> netif_device_detach").
[]
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
[]
> @@ -4715,12 +4715,12 @@ int e1000e_close(struct net_device *netdev)
>  
>  	pm_runtime_get_sync(&pdev->dev);
>  
> -	if (!test_bit(__E1000_DOWN, &adapter->state)) {
> +	if (netif_device_present(netdev)) {
>  		e1000e_down(adapter, true);
>  		e1000_free_irq(adapter);
>  
>  		/* Link status message must follow this format */
> -		pr_info("%s NIC Link is Down\n", adapter->netdev->name);
> +		pr_info("%s NIC Link is Down\n", netdev->name);

This change is already a minor optimization, but perhaps
this should instead be:

	netdev_info(netdev, "NIC Link is Down\n");

And whatever pr_<level> uses should use netdev_<level>
where possible in the driver.


