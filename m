Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFD335D737
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 07:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhDMFZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 01:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhDMFZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 01:25:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3195F611F2;
        Tue, 13 Apr 2021 05:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618291536;
        bh=BYdKNEzjsLQFccWdqpIXZS/XFAP9UbBsQWDpwNZphIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EF8G4wbEvnYxypwYFaBiysU0C8Z8WID2LRco2SIUKEKcDUhdWsWIN773djYTvp+GJ
         6D9mtgd3sCv8F8ZNpkp2gOkGO/6rNFVvrttmKZIasN0LRP9Fkgr0kmkZM5VLuBCQi8
         USJuOO7jJ4r9ZTogXf4/4IFq7+kw5tSpipiXWiV1RrFpG6nJ9sJuPnNDXvlylGPPMV
         tm3OQS2aF04CFHz8dnZhZ9VCW/21h4wXq1KNGCtsZ73CNRsa6QWIoGdFdniCwK3cOx
         bXoIUBqe1ZBMVBp6oArpv1ybfflp5p3e8N70jbIc/10EIaPkCQ3xEpQLzzaH9zJA0W
         sMp9zEXpXo8Vw==
Date:   Tue, 13 Apr 2021 08:25:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH net-next 4/5] bnxt_en: Refactor __bnxt_vf_reps_destroy().
Message-ID: <YHUrTTf3xb4+j2/v@unreal>
References: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
 <1618186695-18823-5-git-send-email-michael.chan@broadcom.com>
 <YHP4piIPfdXca+uB@unreal>
 <CACKFLi=jOqZx-yBBnNFaCOyWTWBKZ=W1KvY2xX-sKAxxOv7kQw@mail.gmail.com>
 <YHSEaVtK/SfrwkRq@unreal>
 <CACKFLimkp8HafpK+cP4+ib9gDkqT9=Evvm-mPrRd9gAHyADcPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKFLimkp8HafpK+cP4+ib9gDkqT9=Evvm-mPrRd9gAHyADcPA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 10:51:25AM -0700, Michael Chan wrote:
> On Mon, Apr 12, 2021 at 10:33 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Mon, Apr 12, 2021 at 09:31:33AM -0700, Michael Chan wrote:
> > > On Mon, Apr 12, 2021 at 12:37 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Sun, Apr 11, 2021 at 08:18:14PM -0400, Michael Chan wrote:
> > > > > Add a new helper function __bnxt_free_one_vf_rep() to free one VF rep.
> > > > > We also reintialize the VF rep fields to proper initial values so that
> > > > > the function can be used without freeing the VF rep data structure.  This
> > > > > will be used in subsequent patches to free and recreate VF reps after
> > > > > error recovery.
> > > > >
> > > > > Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> > > > > Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> > > > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > > > > ---
> > > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 21 ++++++++++++++-----
> > > > >  1 file changed, 16 insertions(+), 5 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> > > > > index b5d6cd63bea7..a4ac11f5b0e5 100644
> > > > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> > > > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> > > > > @@ -288,6 +288,21 @@ void bnxt_vf_reps_open(struct bnxt *bp)
> > > > >               bnxt_vf_rep_open(bp->vf_reps[i]->dev);
> > > > >  }
> > > > >
> > > > > +static void __bnxt_free_one_vf_rep(struct bnxt *bp, struct bnxt_vf_rep *vf_rep)
> > > > > +{
> > > > > +     if (!vf_rep)
> > > > > +             return;
> > > >
> > > > How can it be NULL if you check that vf_rep != NULL when called to
> > > > __bnxt_free_one_vf_rep() ?
> > > >
> > >
> > > For this patch, the if (!vf_rep) check here is redundant.  But it is
> > > needed in the next patch (patch 5) that calls this function from
> > > bnxt_vf_reps_free() in a different context.  Thanks.
> >
> > So add it in the patch that needs it.
> >
> 
> As stated in the changelog, we added more code to make this function
> more general and usable from another context.  The check for !vf_rep
> is part of that.  In my opinion, I think it is ok to keep it here
> given that the intent of this patch is to create a more general
> function.  Thanks.

I disagreed, but given the fact that Dave already merged this series, it
doesn't matter anymore.

Thanks

