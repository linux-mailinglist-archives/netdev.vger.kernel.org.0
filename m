Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD8035CF83
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243266AbhDLRdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240002AbhDLRdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 13:33:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF7126121F;
        Mon, 12 Apr 2021 17:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618248813;
        bh=dBHIGjIJmbrz3EGBOlBwi6JdImEDv/iFw2s6PbBzIRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qOZXBMjS+O51Hi0xjEVASVs/qJlF9DZQLj8uR6l7jffLaS2hTUIrOZeuCHJlG1w17
         0gzzQn8bJqY8P1KUPtPlAORlSfCy5KIt3urMFLnXZSt5t2E+5/oD5oKzao+713ciYd
         DDCqT5ase+s/bCl9Qpk2+maZX6rlkK19Tl1sC+6+v0MiINF2VDaf772FHmyZQbtyUF
         oEkxCdlaYD5BHMkcyWmLfzs0omlAj1Q7U5kd5wiyQEFJ3eiy6rMjifzst/his36Srd
         Va1CgukdSUyPd6BsmbxY7FY/rhP5nxsM6GWQNIBPQHoZNBZb5QSWiPNStGmLog3kEw
         KvlhFV9naqDzQ==
Date:   Mon, 12 Apr 2021 20:33:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH net-next 4/5] bnxt_en: Refactor __bnxt_vf_reps_destroy().
Message-ID: <YHSEaVtK/SfrwkRq@unreal>
References: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
 <1618186695-18823-5-git-send-email-michael.chan@broadcom.com>
 <YHP4piIPfdXca+uB@unreal>
 <CACKFLi=jOqZx-yBBnNFaCOyWTWBKZ=W1KvY2xX-sKAxxOv7kQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKFLi=jOqZx-yBBnNFaCOyWTWBKZ=W1KvY2xX-sKAxxOv7kQw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 09:31:33AM -0700, Michael Chan wrote:
> On Mon, Apr 12, 2021 at 12:37 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Sun, Apr 11, 2021 at 08:18:14PM -0400, Michael Chan wrote:
> > > Add a new helper function __bnxt_free_one_vf_rep() to free one VF rep.
> > > We also reintialize the VF rep fields to proper initial values so that
> > > the function can be used without freeing the VF rep data structure.  This
> > > will be used in subsequent patches to free and recreate VF reps after
> > > error recovery.
> > >
> > > Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> > > Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > > ---
> > >  drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 21 ++++++++++++++-----
> > >  1 file changed, 16 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> > > index b5d6cd63bea7..a4ac11f5b0e5 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> > > @@ -288,6 +288,21 @@ void bnxt_vf_reps_open(struct bnxt *bp)
> > >               bnxt_vf_rep_open(bp->vf_reps[i]->dev);
> > >  }
> > >
> > > +static void __bnxt_free_one_vf_rep(struct bnxt *bp, struct bnxt_vf_rep *vf_rep)
> > > +{
> > > +     if (!vf_rep)
> > > +             return;
> >
> > How can it be NULL if you check that vf_rep != NULL when called to
> > __bnxt_free_one_vf_rep() ?
> >
> 
> For this patch, the if (!vf_rep) check here is redundant.  But it is
> needed in the next patch (patch 5) that calls this function from
> bnxt_vf_reps_free() in a different context.  Thanks.

So add it in the patch that needs it.

Thanks
