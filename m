Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA71E9F76
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfJ3PsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:48:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:52934 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfJ3PsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 11:48:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 08:48:24 -0700
X-IronPort-AV: E=Sophos;i="5.68,247,1569308400"; 
   d="scan'208";a="194007371"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 08:48:24 -0700
Message-ID: <cf197ef61703cbaa64ac522cf5d191b4b74f64d6.camel@linux.intel.com>
Subject: Re: [net-next 2/8] e1000e: Use rtnl_lock to prevent race conditions
 between net and pci/pm
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Joe Perches <joe@perches.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Morumuri Srivalli <smorumu1@in.ibm.com>,
        David Dai <zdai@linux.vnet.ibm.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Date:   Wed, 30 Oct 2019 08:48:24 -0700
In-Reply-To: <b552e8483feae4c122c862dcb8483f482f942763.camel@perches.com>
References: <20191030043633.26249-1-jeffrey.t.kirsher@intel.com>
         <20191030043633.26249-3-jeffrey.t.kirsher@intel.com>
         <b552e8483feae4c122c862dcb8483f482f942763.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-29 at 22:50 -0700, Joe Perches wrote:
> On Tue, 2019-10-29 at 21:36 -0700, Jeff Kirsher wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > This patch is meant to address possible race conditions that can exist
> > between network configuration and power management. A similar issue was
> > fixed for igb in commit 9474933caf21 ("igb: close/suspend race in
> > netif_device_detach").
> []
> > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> []
> > @@ -4715,12 +4715,12 @@ int e1000e_close(struct net_device *netdev)
> >  
> >  	pm_runtime_get_sync(&pdev->dev);
> >  
> > -	if (!test_bit(__E1000_DOWN, &adapter->state)) {
> > +	if (netif_device_present(netdev)) {
> >  		e1000e_down(adapter, true);
> >  		e1000_free_irq(adapter);
> >  
> >  		/* Link status message must follow this format */
> > -		pr_info("%s NIC Link is Down\n", adapter->netdev->name);
> > +		pr_info("%s NIC Link is Down\n", netdev->name);
> 
> This change is already a minor optimization, but perhaps
> this should instead be:
> 
> 	netdev_info(netdev, "NIC Link is Down\n");
> 
> And whatever pr_<level> uses should use netdev_<level>
> where possible in the driver.

I don't view it as an optimization. The test to enter this section was
based on adapter and is now based on netdev. So the info message was
changed from being adapter based and made netdev based. I suspect changing
to netdev_info is going to change the messaging since it dumps more than
just the netdevice name and adds a colon.

If we are going to change the messaging I think it would be better to do
it as a separate patch. There are a couple spots that output the message
"NIC Link is Down" so we should probably update both of those and the
"Link is UP" at the same time. Since you mentioned it do you want to patch
that or should I?

Thanks.

- Alex


