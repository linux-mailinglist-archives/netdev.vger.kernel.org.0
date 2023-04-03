Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883216D3D33
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 08:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjDCGSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 02:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjDCGST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 02:18:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A5149E5
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 23:18:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58D91B81197
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542AAC433EF;
        Mon,  3 Apr 2023 06:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680502691;
        bh=ieqHrusdExysUOpkDLAkNofEI203VDR7HQHpO73+dVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ruax/CdlnqlKliv+7D8lI7w4ip3ovgsA1rp9pTLAEm67etWOTQKN0STPtWupGd7QO
         15OWZBV0dFU/q0Au3CBuX3IK6yurLTebddFrrTIyDIlN1+VjGIZpavSEF6dPNFuLac
         zsW0xCbZ5KhuhJBlhr638aa635ieV7t+KL7H/fDkvq8DMy9YJkovB81Tk7MA+fgcKr
         Snzhth10WlEcBplNHzJSX1ke0imejy64uR0NpJadlbmwwGsEfp92+i8WKCuT99XsEQ
         2il3jagVYf5SYTJKYDOVEony2ImmJXD1VPS8wJGxOSULGQzUxDylpBfJDznoMXi0D/
         L7RtjZaUczthg==
Date:   Mon, 3 Apr 2023 09:18:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v8 net-next 10/14] pds_core: add auxiliary_bus devices
Message-ID: <20230403061808.GA7387@unreal>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
 <20230330234628.14627-11-shannon.nelson@amd.com>
 <20230401182701.GA831478@unreal>
 <fc39973a-3f57-87d0-ff46-15a09e9b5f58@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc39973a-3f57-87d0-ff46-15a09e9b5f58@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 01:15:03PM -0700, Shannon Nelson wrote:
> On 4/1/23 11:27 AM, Leon Romanovsky wrote:
> > 
> > On Thu, Mar 30, 2023 at 04:46:24PM -0700, Shannon Nelson wrote:
> > > An auxiliary_bus device is created for each vDPA type VF at VF probe
> > > and destroyed at VF remove.  The VFs are always removed on PF remove, so
> > > there should be no issues with VFs trying to access missing PF structures.
> > > 
> > > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > > ---
> > >   drivers/net/ethernet/amd/pds_core/Makefile |   1 +
> > >   drivers/net/ethernet/amd/pds_core/auxbus.c | 142 +++++++++++++++++++++
> > >   drivers/net/ethernet/amd/pds_core/core.h   |   6 +
> > >   drivers/net/ethernet/amd/pds_core/main.c   |  36 +++++-
> > >   include/linux/pds/pds_auxbus.h             |  16 +++
> > >   include/linux/pds/pds_common.h             |   1 +
> > >   6 files changed, 200 insertions(+), 2 deletions(-)
> > >   create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
> > >   create mode 100644 include/linux/pds/pds_auxbus.h
> > 
> > I feel that this auxbus usage is still not correct.
> > 
> > The idea of auxiliary devices is to partition physical device (for
> > example PCI device) to different sub-devices, where every sub-device
> > belongs to different sub-system. It is not intended to create per-VF
> > devices.
> > 
> > In your case, you should create XXX vDPA auxiliary devices which are
> > connected in one-to-one scheme to their PCI VF counterpart.
> 
> I don't understand - first I read
>     "It is not intended to create per-VF devices"
> and then
>     "you should create XXX vDPA auxiliary devices which are
>     connected in one-to-one scheme to their PCI VF counterpart."
> These seem at first to be directly contradictory statements, so maybe I'm
> missing some nuance.

It is not, as I'm looking in the code and don't expect to see the code
like this. It gives me a sense that auxdevice is not created properly
as nothing shouldn't be happen from these checks.

+	if (pf->state) {
+		dev_warn(vf->dev, "%s: PF in a transition state (%lu)\n",
+			 __func__, pf->state);
+		err = -EBUSY;
+	} else if (!pf->vfs) {
+		dev_warn(vf->dev, "%s: PF vfs array not ready\n",
+			 __func__);
+		err = -ENOTTY;
+	} else if (vf->vf_id >= pf->num_vfs) {
+		dev_warn(vf->dev, "%s: vfid %d out of range\n",
+			 __func__, vf->vf_id);
+		err = -ERANGE;
+	} else if (pf->vfs[vf->vf_id].padev) {
+		dev_warn(vf->dev, "%s: vfid %d already running\n",
+			 __func__, vf->vf_id);
+		err = -ENODEV;
+	}

> 
> We have a PF device that has an adminq, VF devices that don't have an
> adminq, and the adminq is needed for some basic setup before the rest of the
> vDPA driver can use the VF.  To access the PF's adminq we set up an
> auxiliary device per feature in each VF - but currently only offer one
> feature (vDPA) and no sub-devices yet.  We're trying to plan for the future.

It looks like premature effort to me.

> 
> Is it that we only have one feature per VF so far is what is causing the
> discomfort?

This whole patch is not easy for me.

Thanks

> 
> sln
> 
