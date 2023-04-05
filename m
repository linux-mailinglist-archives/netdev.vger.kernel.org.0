Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4256D7422
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 08:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbjDEGID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 02:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236821AbjDEGH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 02:07:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E02F198C
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:07:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89DCC63A4F
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 06:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31787C433D2;
        Wed,  5 Apr 2023 06:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680674872;
        bh=gxYNun/FDgc5ByMUYUI67Fw3MKJ0cU8VNfeJz6BaPsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VXTZvjCwES6TYeDYmCkPr7x7NOq4h9IoXKlFy8LyrN54S61s6qUb08rQX3ihjsxaK
         acYORSJCQFNgkcrhqo2sweerd0WJNTykD6u1hGiQmcrXsBs7tIIipFYCURyLT56A2W
         8u/+HFLupAOfydBf9EUkzR3UdVmYFq8nQkZKCS96fUXDGlHfrHOPy/M/Fel+SlY/Eu
         dGVwZdLSgxUM+v2G6GxRg9rNloJq0knoXANaz+jZrKpIlqdid5YTrA+eA7ZTyXIcCu
         SFm3+ro2Fxqo6Sf/GTRc4KTTwRf3ykt31ctdgit5J7uFVNFACvLGx1xSy+PlMcTCrN
         0CaTjXfMsJo1Q==
Date:   Wed, 5 Apr 2023 09:07:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v8 net-next 10/14] pds_core: add auxiliary_bus devices
Message-ID: <20230405060747.GN4514@unreal>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
 <20230330234628.14627-11-shannon.nelson@amd.com>
 <20230401182701.GA831478@unreal>
 <fc39973a-3f57-87d0-ff46-15a09e9b5f58@amd.com>
 <20230403061808.GA7387@unreal>
 <a44770b2-ff3e-a88e-03c4-e7818b33333d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44770b2-ff3e-a88e-03c4-e7818b33333d@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 02:44:34PM -0700, Shannon Nelson wrote:
> On 4/2/23 11:18 PM, Leon Romanovsky wrote:
> > 
> > On Sat, Apr 01, 2023 at 01:15:03PM -0700, Shannon Nelson wrote:
> > > On 4/1/23 11:27 AM, Leon Romanovsky wrote:
> > > > 
> > > > On Thu, Mar 30, 2023 at 04:46:24PM -0700, Shannon Nelson wrote:
> > > > > An auxiliary_bus device is created for each vDPA type VF at VF probe
> > > > > and destroyed at VF remove.  The VFs are always removed on PF remove, so
> > > > > there should be no issues with VFs trying to access missing PF structures.
> > > > > 
> > > > > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > > > > ---
> > > > >    drivers/net/ethernet/amd/pds_core/Makefile |   1 +
> > > > >    drivers/net/ethernet/amd/pds_core/auxbus.c | 142 +++++++++++++++++++++
> > > > >    drivers/net/ethernet/amd/pds_core/core.h   |   6 +
> > > > >    drivers/net/ethernet/amd/pds_core/main.c   |  36 +++++-
> > > > >    include/linux/pds/pds_auxbus.h             |  16 +++
> > > > >    include/linux/pds/pds_common.h             |   1 +
> > > > >    6 files changed, 200 insertions(+), 2 deletions(-)
> > > > >    create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
> > > > >    create mode 100644 include/linux/pds/pds_auxbus.h
> > > > 
> > > > I feel that this auxbus usage is still not correct.
> > > > 
> > > > The idea of auxiliary devices is to partition physical device (for
> > > > example PCI device) to different sub-devices, where every sub-device
> > > > belongs to different sub-system. It is not intended to create per-VF
> > > > devices.
> > > > 
> > > > In your case, you should create XXX vDPA auxiliary devices which are
> > > > connected in one-to-one scheme to their PCI VF counterpart.
> > > 
> > > I don't understand - first I read
> > >      "It is not intended to create per-VF devices"
> > > and then
> > >      "you should create XXX vDPA auxiliary devices which are
> > >      connected in one-to-one scheme to their PCI VF counterpart."
> > > These seem at first to be directly contradictory statements, so maybe I'm
> > > missing some nuance.
> > 
> > It is not, as I'm looking in the code and don't expect to see the code
> > like this. It gives me a sense that auxdevice is not created properly
> > as nothing shouldn't be happen from these checks.
> > 
> > +       if (pf->state) {
> > +               dev_warn(vf->dev, "%s: PF in a transition state (%lu)\n",
> > +                        __func__, pf->state);
> > +               err = -EBUSY;
> > +       } else if (!pf->vfs) {
> > +               dev_warn(vf->dev, "%s: PF vfs array not ready\n",
> > +                        __func__);
> > +               err = -ENOTTY;
> > +       } else if (vf->vf_id >= pf->num_vfs) {
> > +               dev_warn(vf->dev, "%s: vfid %d out of range\n",
> > +                        __func__, vf->vf_id);
> > +               err = -ERANGE;
> > +       } else if (pf->vfs[vf->vf_id].padev) {
> > +               dev_warn(vf->dev, "%s: vfid %d already running\n",
> > +                        __func__, vf->vf_id);
> > +               err = -ENODEV;
> > +       }
> > 
> > > 
> > > We have a PF device that has an adminq, VF devices that don't have an
> > > adminq, and the adminq is needed for some basic setup before the rest of the
> > > vDPA driver can use the VF.  To access the PF's adminq we set up an
> > > auxiliary device per feature in each VF - but currently only offer one
> > > feature (vDPA) and no sub-devices yet.  We're trying to plan for the future.
> > 
> > It looks like premature effort to me.
> > 
> > > 
> > > Is it that we only have one feature per VF so far is what is causing the
> > > discomfort?
> > 
> > This whole patch is not easy for me.
> 
> Yes, those are extraneous checks left from testing the new driver
> organization.  They are no longer needed, and can come out in the next
> round.
> 
> In addition to spreading out the pds_core.rst creation across the patchset
> and adding more to the commit descriptions, I'll see if there are some other
> nips and tucks I can do to possibly make the patchset more palatable.

You also need to rework your auxdevice id creation scheme to be more
like other drivers.

This line assumes that you have only one PF device in the system.
+       aux_dev->id = vf->id;

Thanks

> 
> sln
