Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B7C402F1A
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345741AbhIGTsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232112AbhIGTsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 15:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13FDB61106;
        Tue,  7 Sep 2021 19:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631044051;
        bh=1Bz7auCWrxm+wLmDaCt3yZIJBxmHDfjlY1u05m7Vaao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qDHeBAwlLs885YAnETqy2p4CZIr2qQqC6vWR5P0lvoRrkHASe9jcrUDXgVLjCE657
         JNWNrXr68I0i0nIZQc+uC+AreEcZnHnXtdXgaLyc9coysCPgyAoE8gUALmRbnusK/k
         TU8AeqRvyZGnFvmq5jEBB663tsgGFe6m306D8r9m2FUmufaL2Kaet1xSVw7biO5XnI
         ACGxyNdasrIf5e0EwQdv7jnfowRniFZpQlqYfXaUnKIKfJJTPzb/iT25unDa7N6J5V
         MeHjMu/sK2BX+lOyZ33z3P/6yNyLLJL9xfTJNRVIefEfkloWluQ0s83KV2+gkrs3q4
         2evhlWCKatWxA==
Date:   Tue, 7 Sep 2021 12:47:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Andrew Lunn" <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-2-maciej.machnikowski@intel.com>
        <20210903151425.0bea0ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Sep 2021 15:47:05 +0000 Machnikowski, Maciej wrote:
> > > It can be either in FW or in Linux - depending on the deployment.
> > > We try to define the API that would enable Linux to manage that.  
> > 
> > We should implement the API for Linux to manage things from the get go.  
> 
> Yep! Yet let's go one step at a time. I believe once we have the basics (EEC 
> monitoring and recovered clock configuration) we'll be able to implement
> a basic functionality - and add bells and whistles later on, as there are more
> capabilities that we could support in SW.

The set API may shape how the get API looks. We need a minimal viable
API where the whole control part of it is not "firmware or proprietary
tools take care of that".

Do you have public docs on how the whole solution works?

> > > The DPLL will operate on pins, so it will have a pin connected from the
> > > MAC/PHY that will have the recovered clock, but the recovered clock
> > > can be enabled from any port/lane. That information is kept in the
> > > MAC/PHY and the DPLL side will not be aware who it belongs to.  
> > 
> > So the clock outputs are muxed to a single pin at the Ethernet IP
> > level, in your design. I wonder if this is the common implementation
> > and therefore if it's safe to bake that into the API. Input from other
> > vendors would be great...  
> 
> I believe this is the state-of-art: here's the Broadcom public one
> https://docs.broadcom.com/doc/1211168567832, I believe Marvel
> has similar solution. But would also be happy to hear others.

Interesting. That reveals the need for also marking the backup
(/secondary) clock.

Have you seen any docs on how systems with discreet PHY ASICs mux 
the clocks?

> > Also do I understand correctly that the output of the Ethernet IP
> > is just the raw Rx clock once receiver is locked and the DPLL which
> > enum if_synce_state refers to is in the time IP, that DPLL could be
> > driven by GNSS etc?  
> 
> Ethernet IP/PHY usually outputs a divided clock signal (since it's 
> easier to route) derived from the RX clock.
> The DPLL connectivity is vendor-specific, as you can use it to connect 
> some external signals, but you can as well just care about relying 
> the SyncE clock and only allow recovering it and passing along 
> the QL info when your EEC is locked. That's why I backed up from
> a full DPLL implementation in favor of a more generic EEC clock.

What is an ECC clock? To me the PLL state in the Ethernet port is the
state of the recovered clock. enum if_eec_state has values like
holdover which seem to be more applicable to the "system wide" PLL.

Let me ask this - if one port is training the link and the other one has
the lock and is the source - what state will be reported for each port?

> The Time IP is again relative and vendor-specific. If SyncE is deployed 
> alongside PTP it will most likely be tightly coupled, but if you only
> care about having a frequency source - it's not mandatory and it can be
> as well in the PHY IP.

I would not think having just the freq is very useful.

> Also I think I will strip the reported states to the bare minimum defined
> in the ITU-T G.781 instead of reusing the states that were already defined 
> for a specific DPLL.
> 
> > > This is the right thinking. The DPLL can also have different external sources,
> > > like the GNSS, and can also drive different output clocks. But for the most
> > > basic SyncE implementation, which only runs on a recovered clock, we won't  
> > > need the DPLL subsystem.  
> > 
> > The GNSS pulse would come in over an external pin, tho, right? Your
> > earlier version of the patchset had GNSS as an enum value, how would
> > the driver / FW know that a given pin means GNSS?  
> 
> The GNSS 1PPS will more likely go directly to the "full" DPLL. 
> The pin topology can be derived from FW or any vendor-specific way of mapping
> pins to their sources. And, in "worst" case can just be hardcoded for a specific
> device.
