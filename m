Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060D841685E
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 01:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243561AbhIWXM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 19:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243533AbhIWXM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 19:12:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBA3D61107;
        Thu, 23 Sep 2021 23:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632438683;
        bh=ILJ6ftNnE9k3HLjd3767aM80d5dSXwBb9STyViQHsTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d6xb0sBmcLCsSN4o8Nmf9iBZmY6iH5GTHlUTZ4njs2oiGZTh3bnipzbuFqBILzhNF
         5px5K9H0CcDO51xqA9JT5vbfYRvb9wt8A5YJkii6rglY3yLCjLi3U1TJCSOg6MH0ua
         eJZMmO7dG0QNdxwpNvFnPdz7dCOh1N4ATR7X0vZuwImk2U5Q4n4mPV9UU118v2M8t+
         eTKCfSnGGoRgXKY1yZ9mLmZFBh6XZmK0VDZwqFmrBtco2c20AVkDiryk+MiBSjAc7B
         y2f/O2BPpkQuZ0h5UBgPN+RYTGDMXjGds1n4mYmeT1rGszU4aOEnTuVOV5KJjynLXJ
         zEIphBay1IBcg==
Date:   Fri, 24 Sep 2021 02:11:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <YU0JlzFOa7kpKgnd@unreal>
References: <cover.1632420430.git.leonro@nvidia.com>
 <e7708737fadf4fe6f152afc76145c728c201adad.1632420430.git.leonro@nvidia.com>
 <CAKOOJTz4A2ER8MQE1dW27Spocds09SYafjeuLcFDJ0nL6mKyOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTz4A2ER8MQE1dW27Spocds09SYafjeuLcFDJ0nL6mKyOw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 02:11:40PM -0700, Edwin Peer wrote:
> On Thu, Sep 23, 2021 at 11:13 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > devlink is a software interface that doesn't depend on any hardware
> > capabilities. The failure in SW means memory issues, wrong parameters,
> > programmer error e.t.c.
> >
> > Like any other such interface in the kernel, the returned status of
> > devlink APIs should be checked and propagated further and not ignored.
> >
> > Fixes: 4ab0c6a8ffd7 ("bnxt_en: add support to enable VF-representors")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  5 ++++-
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 13 ++++++-------
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h | 13 -------------
> >  3 files changed, 10 insertions(+), 21 deletions(-)

<...>

> > @@ -835,9 +837,6 @@ void bnxt_dl_unregister(struct bnxt *bp)
> >  {
> >         struct devlink *dl = bp->dl;
> >
> > -       if (!dl)
> > -               return;
> > -
> 
> minor nit: There's obviously nothing incorrect about doing this (and
> adding the additional error label in the cleanup code above), but bnxt
> has generally adopted a style of having cleanup functions being
> idempotent. It generally makes error handling simpler and less error
> prone.

I would argue that opposite is true. Such "impossible" checks hide unwind
flow errors, missing releases e.t.c.

<...>

> >
> 
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>

Thanks for the review.


> 
> Regards,
> Edwin Peer
