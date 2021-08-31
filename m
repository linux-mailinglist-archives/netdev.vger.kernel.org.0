Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B2F3FCAE5
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 17:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbhHaPdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 11:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239158AbhHaPdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 11:33:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9579B60F42;
        Tue, 31 Aug 2021 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630423949;
        bh=ybLmg9lp5eiVFEI/aszefp33Vquu0/8MQSxWb8mNW+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HyqmIRJYUd4I+C/QRbEgYjSuShO1hpLfzyO1ttkbuelhA+wBMVuTgUahpD2H5kwlA
         JZLxumuzEfF/+APc9MMFzYcJZAWw4lF3wLFM4eHL102WZHC6bk1WXRKdyTy982XpH/
         Bfk92DnljKP09IUMzFzX9+Nm7/FdWDfMllK6nbxi+ubQ7sEp0vrkwfRcLzmLeP/qiM
         xXVRlDP/ODH7ddjz1080efxbbFyWGexflXMETKQ70Y/Rk6hTBxsJ+zMDo54I6jur5z
         uW6NojKMgtB5Q3+zsqf7s8RASiZq7hLpPUaFkKtTIsfAmph+TB++qo6imS2ewPeYkp
         GyinD0CjsjiIw==
Date:   Tue, 31 Aug 2021 08:32:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <20210831083227.3d9df78a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SJ0PR11MB4958304AA06A63DD6290D3DEEACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
        <20210829080512.3573627-2-maciej.machnikowski@intel.com>
        <20210829151017.GA6016@hoboy.vegasvil.org>
        <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210830205758.GA26230@hoboy.vegasvil.org>
        <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB4958029CF18F93846B29F685EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
        <20210831063304.4bcacbe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB49583C74616AC7E715C6E3A9EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
        <20210831071801.0535c0cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB4958304AA06A63DD6290D3DEEACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 15:19:36 +0000 Machnikowski, Maciej wrote:
> > It's a reasonable SW design strategy to start simple. Unfortunately,
> > it doesn't apply to stable uAPI design. You're adding a RTNL op, which
> > will have to be supported for ever. If we add anything "later" it will
> > be a strict addition, and will have to be backward compatible. Which
> > I'm not sure how to do when the object we'd operate on would be
> > completely different (clock vs netdev).  
> 
> I agree - the point I'm trying to make here is that the existence of
> the PTP-specific interface will not invalidate the need of having 
> SyncE-specific one as well. Even if we report lock-states for the clock
> we will still need to report lock-states for devices that don't use PTP
> clocks, but support SyncE. (that's also a reason why RTNL is still required).
> 
> The RTNL interface will also address devices that only need the 
> frequency syntonization (especially in Radio Access Networks).
> 
> > 
> > As I said I can write the boilerplate code for you if you prefer, the
> > code implementing the command and the driver interface will be almost
> > identical.  
> 
> I think it's a great idea to start that in parallel to this patch. Then move
> the common structures to the generic layer and use them in both
> SyncE-specific RTNL implementation and PTP-specific part that will
> be added. This won't affect SyncE specific APIs. The "worst" that can
> happen is that the driver will put the same info for PTP part and
> SyncE part if that's the design someone follows.

I don't understand why we need the SyncE RTNL if we have clock API for
controlling the freq source. Are you saying that there are
implementations out there which use SyncE to recover Rx clock and use
it for Tx but the PTP ticker is in a different clock domain?
