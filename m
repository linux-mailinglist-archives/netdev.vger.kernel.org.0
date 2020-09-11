Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8B52660F4
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 16:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgIKNRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 09:17:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:35685 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgIKNQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 09:16:48 -0400
IronPort-SDR: gYCt5I6CwdiVg6ZgphjGSkugImpSDejVN8RvnLGGUlD75OWs31uzplHme1X5L4zWaV9G+56gfD
 XZXs6AH9GUOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="222953182"
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="222953182"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 06:16:34 -0700
IronPort-SDR: +P15umNu7E6s9G4fsdhvpCFWZUI7rwKE/pmlbwgWaXgrF6JTUpzZmc/7IU8Y7CEu4iQveekacw
 c13egy1x5v+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="300927206"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga003.jf.intel.com with ESMTP; 11 Sep 2020 06:16:32 -0700
Date:   Fri, 11 Sep 2020 15:10:27 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        jeffrey.t.kirsher@intel.com,
        Network Development <netdev@vger.kernel.org>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH net-next] i40e: allow VMDQs to be used with AF_XDP
 zero-copy
Message-ID: <20200911131027.GA2052@ranger.igk.intel.com>
References: <1599826106-19020-1-git-send-email-magnus.karlsson@gmail.com>
 <20200911120519.GA9758@ranger.igk.intel.com>
 <CAJ8uoz3ctVoANjiO_nQ38YA-JoB0nQH1B4W01AZFw3iCyCC_+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz3ctVoANjiO_nQ38YA-JoB0nQH1B4W01AZFw3iCyCC_+w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 02:29:50PM +0200, Magnus Karlsson wrote:
> On Fri, Sep 11, 2020 at 2:11 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Fri, Sep 11, 2020 at 02:08:26PM +0200, Magnus Karlsson wrote:
> > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >
> > > Allow VMDQs to be used with AF_XDP sockets in zero-copy mode. For some
> > > reason, we only allowed main VSIs to be used with zero-copy, but
> > > there is now reason to not allow VMDQs also.
> >
> > You meant 'to allow' I suppose. And what reason? :)
> 
> Yes, sorry. Should be "not to allow". I was too trigger happy ;-).
> 
> I have gotten requests from users that they want to use VMDQs in
> conjunction with containers. Basically small slices of the i40e
> portioned out as netdevs. Do you see any problems with using a VMDQ
> iwth zero-copy?

No, I only meant to provide the actual reason (what you wrote above) in
the commit message.

> 
> /Magnus
> 
> > >
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > > index 2a1153d..ebe15ca 100644
> > > --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > > +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > > @@ -45,7 +45,7 @@ static int i40e_xsk_pool_enable(struct i40e_vsi *vsi,
> > >       bool if_running;
> > >       int err;
> > >
> > > -     if (vsi->type != I40E_VSI_MAIN)
> > > +     if (!(vsi->type == I40E_VSI_MAIN || vsi->type == I40E_VSI_VMDQ2))
> > >               return -EINVAL;
> > >
> > >       if (qid >= vsi->num_queue_pairs)
> > > --
> > > 2.7.4
> > >
