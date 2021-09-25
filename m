Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC77A4180EC
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 12:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244114AbhIYKDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 06:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:32862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234958AbhIYKDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 06:03:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A581610C7;
        Sat, 25 Sep 2021 10:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632564093;
        bh=vUQvWAePLzdLRZc+ChBxFiJ4phqK0Y1Dzy6kDhpJQjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D0RfZDMUicf0Nrzi/I154oj+a7L6krXbMFxL6f7OAeo8Z04aUeN1Hx0PsYmQj/rhd
         JU4tYtwi9tTNK7v4dxzx0tns/ms73lEwQhhWWb8TPCMXPSjXjl3RE+6mheH6ORhiIY
         exH7Mhs4jo2IWpb2FgIbU9j5E0vf6zlwGKSJarVLrxpJ5jpuQhQeCKoFstG1MrxkWy
         wuvhA56lJq/ntXQfDpjKsrb1LcA52GxnQGFmFLSHAoIiCSCUkhMLD3675/Av/t+N2q
         5UFJR6wtk3Q+HYEssMyA1zsvkPZW3eS2KBqQp+rE7h0mhFCeMlD7obG50wFu5gsBBh
         FuSDkIKvRepsg==
Date:   Sat, 25 Sep 2021 13:01:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next 1/6] bnxt_en: Check devlink allocation and
 registration status
Message-ID: <YU7zeca8AsJwQTsD@unreal>
References: <cover.1632420430.git.leonro@nvidia.com>
 <e7708737fadf4fe6f152afc76145c728c201adad.1632420430.git.leonro@nvidia.com>
 <CAKOOJTz4A2ER8MQE1dW27Spocds09SYafjeuLcFDJ0nL6mKyOw@mail.gmail.com>
 <YU0JlzFOa7kpKgnd@unreal>
 <20210923183956.506bfde2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKOOJTwh6TnNM4uSM2rbaij=xO92UzF2hs11pgOFUniOb3HAkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTwh6TnNM4uSM2rbaij=xO92UzF2hs11pgOFUniOb3HAkA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 10:20:32AM -0700, Edwin Peer wrote:
> On Thu, Sep 23, 2021 at 6:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Fri, 24 Sep 2021 02:11:19 +0300 Leon Romanovsky wrote:
> > > > minor nit: There's obviously nothing incorrect about doing this (and
> > > > adding the additional error label in the cleanup code above), but bnxt
> > > > has generally adopted a style of having cleanup functions being
> > > > idempotent. It generally makes error handling simpler and less error
> > > > prone.
> > >
> > > I would argue that opposite is true. Such "impossible" checks hide unwind
> > > flow errors, missing releases e.t.c.
> >
> > +1, fwiw
> 
> I appreciate that being more explicit can improve visibility, but it
> does not make error handling inherently less error prone, nor is it
> simpler (ie. the opposite isn't true). Idempotency is orthogonal to
> unwind flow or the presence or not of a particular unwind handler (one
> can still enforce either in review). But, if release handlers are
> independent (most in bnxt are), then permitting other orderings can be
> perfectly valid and places less burden on achieving the canonical form
> for correctness (ie. usage is simpler and less error prone). That's
> not to say we should throw caution to the wind and allow arbitrary
> unwind flows, but it does mean certain mistakes don't result in actual
> bugs. There are other flexibility benefits too. A single, unwind
> everything, handler can be reused in more than one context.

And this is where the fun begins. Different context means different
lifetime expectations, maybe need of locking and unpredictable flows
from reader perspective.

For example, in this devlink case, it took me time to check all driver
to see that pf can't be null. 

The idea that adding code that maybe will be used can be seen as
anti-pattern.

Thanks
