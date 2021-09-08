Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E15D4041FC
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 01:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbhIHX7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 19:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhIHX7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 19:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 637B661074;
        Wed,  8 Sep 2021 23:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631145483;
        bh=naqFHkyuBJj75mYvsBiHe8qSClYBBKiI1/BuxmIm9Rc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JZjlze49Z84VDPYYfXqYdWFDEUisnWjMKAHNR4JLCOM9bKq90K7M4MqpqsRhnH+Nd
         WAIF4JFhDWbdo72pXx89d/i3xRFdssgDzTjrTQCQw7eh6tTOSDz8CLtn9XdO1BKqkg
         s7F1OorDuTZZhsgS4doHJ2tab8EElZGmRh12bRXUqywjXAL4hhLCDn8gcjXoOw1S+C
         3pGCaNmxtOoylC5oNIKVeERm20Bs+SZzoBAogKqI6U0zzeimh0+jbedBxy6FMcoZTF
         5VIPFOLq3DMzEmZ6ZMdS9JtdUJLM6hrYxT7J875+3aRqntafz5qdmqqp8UPCSHW1II
         5mile4vYJlcJA==
Date:   Wed, 8 Sep 2021 16:58:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <20210908165802.1d5c952d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YTlD3Gok7w/MF+g2@lunn.ch>
References: <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB4951AA3C65DD8E7612F5F396EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210908151852.7ad8a0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YTlD3Gok7w/MF+g2@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Sep 2021 01:14:36 +0200 Andrew Lunn wrote:
> > As you said, pin -> ref mapping is board specific, so the API should
> > not assume knowledge of routing between Port and ECC.  
> 
> That information will probably end up in device tree. And X different
> implementations of ACPI, unless somebody puts there foot down and
> stops the snow flakes.
> 
> > Imagine a system with two cascaded switch ASICs and a bunch of PHYs.
> > How do you express that by pure extensions to the proposed API?  
> 
> Device tree is good at that. ACPI might eventually catch up.

I could well be wrong but some of those connectors could well be just
SMAs on the back plate, no? User could cable those up to their heart
content.

https://engineering.fb.com/2021/08/11/open-source/time-appliance/

> How complex a setup do we actually expect? Can there be multiple
> disjoint SyncE trees within an Ethernet switch cluster? Or would it be
> reasonable to say all you need to configure is the clock source, and
> all other ports of the switches are slaves if SyncE is enabled for the
> port? I've never see any SOHO switch hardware which allows you to have
> disjoint PTP trees, so it does not sound too unreasonable to only
> allow a single SyncE tree per switch cluster.

Not sure. I get the (perhaps unfounded) feeling that just forwarding
the clock from one port to the rest is simpler. Maciej cares primarily
about exposing the clock to other non-Ethernet things, the device would
be an endpoint here, using the clock for LTE or whatnot.

> Also, if you are cascading switches, you generally don't put PHYs in
> the middle, you just connect the SERDES lanes together.

My concern was a case where PHY connected to one switch exposes the
refclock on an aux pin which is then muxed to more than one switch ASIC.
IOW the "source port" is not actually under the same switch. 

Again, IDK if that's realistic.
