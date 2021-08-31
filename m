Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959463FC98E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 16:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhHaOS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 10:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229760AbhHaOS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 10:18:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF5A060E98;
        Tue, 31 Aug 2021 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630419483;
        bh=16No4/WXmYSaZayhxCmNxyBwKKmbtjKVe/w00sxst3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KrIm+5/4nhCnMKoj/FNgR8NyXM0zfJXxBfQw3OKmzvRafWpRv/2zahLTLGJBvhE05
         UMx0dftI/94QEQYxrwPj8t1d60EQ+3lr6nzpEaemTea6NvvdJItbEkPKK8z6/YXd/r
         CsFs4JeS2gl6Wyic4DEJ1xFU4aAzs3aP05YjteEi252H9EgXS4Rb8B2EkxX6NQesXa
         4M1WX8NcAKe6fW6Vu+9dEmPDo6f+1UiG2HTWELgyKB2cCVYbG43+kh44QHKAoz9qSE
         XxxALhqau8DAHfGf8mEtEObU4Ilt8dZbK8ruqjZCo8yiOZC8aaXcIatqAtLCNLiWhN
         bYcFBn87gmVKA==
Date:   Tue, 31 Aug 2021 07:18:01 -0700
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
Message-ID: <20210831071801.0535c0cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SJ0PR11MB49583C74616AC7E715C6E3A9EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
        <20210829080512.3573627-2-maciej.machnikowski@intel.com>
        <20210829151017.GA6016@hoboy.vegasvil.org>
        <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210830205758.GA26230@hoboy.vegasvil.org>
        <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB4958029CF18F93846B29F685EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
        <20210831063304.4bcacbe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB49583C74616AC7E715C6E3A9EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 14:07:32 +0000 Machnikowski, Maciej wrote:
> > > I agree that this also is useful for Time card, yet it's also useful here.
> > > PTP subsystem should implement a similar logic to this one for
> > > DPLL-driven timers which can lock its frequency to external sources.  
> > 
> > Why would we have two APIs for doing the same thing? IIUC Richard does
> > not want this in the PTP ioctls which is fair, but we need to cater to devices
> > which do not have netdevs.  
> 
> From technical point of view - it can be explained by the fact that the DPLL
> driving the SyncE logic can be separate from the one driving PTP.  Also
> SyncE is frequency-only oriented and doesn't care about phase and
> Time of Day that PTP also needs. The GNSS lock on the PTP side will be
> multi-layered, as the full lock would mean that our PTP clock is not only
> syntonized, but also has its time and phase set correctly.

Just because GNSS lock addresses more parameters (potentially) doesn't
mean the syntonization part shouldn't be addressed by the same API.

> A PTP can reuse the "physical" part of this interface later on, but it also needs
> to solve more SW-specific challenges, like reporting the PTP lock on a SW level.
> 
> I agree that having such API for PTP subsystem will be very useful,
> but let's address SyncE in netdev first and build the PTP netlink on top of what
> we learn here. We can always move the structures defined here to the layer
> above without affecting any APIs.

It's a reasonable SW design strategy to start simple. Unfortunately, 
it doesn't apply to stable uAPI design. You're adding a RTNL op, which
will have to be supported for ever. If we add anything "later" it will
be a strict addition, and will have to be backward compatible. Which
I'm not sure how to do when the object we'd operate on would be
completely different (clock vs netdev).

As I said I can write the boilerplate code for you if you prefer, the
code implementing the command and the driver interface will be almost
identical.

Is there a reason why RTNL is better?
