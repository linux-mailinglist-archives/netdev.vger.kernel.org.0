Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5D23610BF
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhDORIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233330AbhDORIM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 13:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE66D6117A;
        Thu, 15 Apr 2021 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618506469;
        bh=UhUdy577XnJm+KLMSVcapJ6O/bfWJhT3U16MvDu14w4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RLwnbtUaPPruiND980ylCVIkimsGwoFgQHCRoGswvIHOFraGCPC3g40Nu759a4aYA
         UY8WNBdXe4Ut4Tc17NjOdTZDlBHLvzEyrgF1fQd93fIvOpVI8qrZ+79HJVG2Jdld9a
         rICme70Gket0R1jJJ1gO2uo04ow2P8CEf8zEe5lnSDNULYlv2TabN1jNsKRMis7Jl2
         +7XY5lOolpR96RvrBmi/EBe/y5EcakT8hJzjk1/k2AOCpEPRzLnzFh9hAg3pOBApTo
         FYA6MS/+CayDp/VtDYrWa/96Xasimuek5SMMKpcuRcKTgF91PBOSaOJqgtz6iIUOyk
         AMLeRfqu9up6Q==
Date:   Thu, 15 Apr 2021 10:07:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 05/15] ice: replace custom AIM algorithm with
 kernel's DIM library
Message-ID: <20210415100748.44fffef5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a5c5405dbaad4bcc8b291c266ad34a39@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
        <20210415003013.19717-6-anthony.l.nguyen@intel.com>
        <20210415094651.06041834@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a5c5405dbaad4bcc8b291c266ad34a39@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 17:03:23 +0000 Keller, Jacob E wrote:
> > On Wed, 14 Apr 2021 17:30:03 -0700 Tony Nguyen wrote:  
> > > +static void ice_tx_dim_work(struct work_struct *work)
> > > +{
> > > +	struct ice_ring_container *rc;
> > > +	struct ice_q_vector *q_vector;
> > > +	struct dim *dim;
> > > +	u16 itr, intrl;
> > > +
> > > +	dim = container_of(work, struct dim, work);
> > > +	rc = container_of(dim, struct ice_ring_container, dim);
> > > +	q_vector = container_of(rc, struct ice_q_vector, tx);
> > > +
> > > +	if (dim->profile_ix >= ARRAY_SIZE(tx_profile))
> > > +		dim->profile_ix = ARRAY_SIZE(tx_profile) - 1;
> > > +
> > > +	/* look up the values in our local table */
> > > +	itr = tx_profile[dim->profile_ix].itr;
> > > +	intrl = tx_profile[dim->profile_ix].intrl;
> > > +
> > > +	ice_write_itr(rc, itr);
> > > +	ice_write_intrl(q_vector, intrl);
> > > +
> > > +	dim->state = DIM_START_MEASURE;  
> > 
> > Are you only doing register writes in ice_write_itr/intrl or talk to FW?
> > Scheduler is expensive so you can save real cycles if you don't have to
> > rely on a work to do the programming (not sure how hard that is with
> > DIM, but since you're already sorta poking at the internals I thought
> > I'd ask).  
> 
> Hmm. I believe we only have to do register writes. If I recall, at
> least based on reading the other DIMLIB implementations, they seem to
> have mostly moved to a work item for apparently moving these changes
> out of the hot path.. but maybe that's not really an issue. Ofcourse
> the current dim implementation enforces use of the work queue, so I
> think it would require refactoring the library to support doing
> immediate application as opposed to using the work item..

I think it may be because of FW programming which needs to sleep. The
extra scheduler work because of this async mechanism does impact real
workloads (admittedly not more than 1%), but up to you.
