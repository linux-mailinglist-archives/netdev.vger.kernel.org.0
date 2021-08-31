Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FB03FC848
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhHaNeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:34:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233928AbhHaNeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 09:34:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69DE60F92;
        Tue, 31 Aug 2021 13:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630416786;
        bh=7asLBEppjKvCHlRz/27vlUr1zsPezKtAWtq/AdxJjqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E456l2bmaqgN50NcK+i5AQJeEJqF0GQ9neavXpe4T7xetTaZFD3vOKAgSkhiDwmDw
         kgAMgMBNuaOcEdy943xS1/3RsSNp9ILhMvrOi3YothuEilb+nySWWOUD40khr3UgNq
         T9aAuZWbjJHGcPh7TnVC6LNLqJHxW6T27ChDRRO3q/P3w7sX85OWcajHGtgNFTG6n7
         nDO5BFINjlM3Of4DJSsMu151keR4a+FBY2e3eykFFOiZNs9unLbuFSX8jXU33S/kp9
         /CSflRAG4AuSKEHOV26EL5CvdX4SZE6GpOy+Tad0lIUKsMjOd6FmRmsAehWUDRExMY
         E0f0dauRVOIAQ==
Date:   Tue, 31 Aug 2021 06:33:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Jonathan Lemon" <bsd@fb.com>
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <20210831063304.4bcacbe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SJ0PR11MB4958029CF18F93846B29F685EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
        <20210829080512.3573627-2-maciej.machnikowski@intel.com>
        <20210829151017.GA6016@hoboy.vegasvil.org>
        <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210830205758.GA26230@hoboy.vegasvil.org>
        <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB4958029CF18F93846B29F685EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 10:20:18 +0000 Machnikowski, Maciej wrote:
> > Hmm, IDK if this really belongs in RTNL. The OCP time card that
> > Jonathan works on also wants to report signal lock, and it locks
> > to GNSS. It doesn't have any networking functionality whatsoever.
> > 
> > Can we add a genetlink family for clock info/configuration? From
> > what I understood discussing this with Jonathan it sounded like most
> > clocks today have a vendor-specific character device for configuration
> > and reading status.
> > 
> > I'm happy to write the plumbing if this seems like an okay idea
> > but too much work for anyone to commit.
> >   
> 
> I agree that this also is useful for Time card, yet it's also useful here.
> PTP subsystem should implement a similar logic to this one for
> DPLL-driven timers which can lock its frequency to external sources.

Why would we have two APIs for doing the same thing? IIUC Richard does
not want this in the PTP ioctls which is fair, but we need to cater to
devices which do not have netdevs.

> The reasoning behind putting it here is to enable returning the lock
> to the GNSS receiver embedded on the NIC as a source for the
> SyncE frequency. It helps distinguishing the embedded GNSS
> from the external sources. As a result - the upper layer can report
> GNSS lock based only on this message without the need to put the
> embedded  GNSS receiver in the config file. On the other hand - if
> sync to External source is reported such SW would need to read
> the source of external sync from the config file.
> 
> And the list is expandable - if we need to define more embedded
> sync source types we can always add more to it.
