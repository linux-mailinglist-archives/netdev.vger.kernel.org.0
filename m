Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A204969DACE
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 07:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbjBUGxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 01:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbjBUGxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 01:53:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602BA55A0
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 22:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1004BB80E37
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 06:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C935C433EF;
        Tue, 21 Feb 2023 06:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676962428;
        bh=aHUO9gkVwD4c3AJ8ruq9vwrp6zdEpVp57cF0CkSHhTY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j1uTXg1kuEk8DQoxMckt7AkWVpJZ5f3Mkg9BhfFmzt7LgAxK/IFWYVRjnig3SgUAz
         hPN7dmiSNAq5Blfz3jVyaxIjBBkjGfsSVMNAosqptZZf/+vY98Clzd3YEzZQCOxP1D
         PwpmvHndknDQ6or0aUmUVnZnd21Xg4SHNjtMqEWmUMeWK4Dy+/2sSQRhYGBxk4usx3
         0KJCpFERqMxPoP4TMug4Y9LRc5wVkbHxzk3nZq6PIBUcTE68As/Z8Ii/szx1RuQj9i
         ltucY9CvTjgHXofr5h1dHyZw3B8TGlbnWMncnQ0KE1Jpxa9Pc/CHDpiGtZogDULVLD
         ReALV69eE5HLA==
Date:   Tue, 21 Feb 2023 08:53:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, brett.creeley@amd.com
Subject: Re: [PATCH v3 net-next 00/14] pds_core driver
Message-ID: <Y/RqeOVZaGA6nIW9@unreal>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
 <Y/H14ByDBPTA+yqg@unreal>
 <bea899bd-c7c1-80cd-8804-e6a3167ea9eb@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bea899bd-c7c1-80cd-8804-e6a3167ea9eb@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 03:53:02PM -0800, Shannon Nelson wrote:
> On 2/19/23 2:11 AM, Leon Romanovsky wrote:
> > On Fri, Feb 17, 2023 at 02:55:44PM -0800, Shannon Nelson wrote:
> > > Summary:
> > > --------
> > > This patchset implements new driver for use with the AMD/Pensando
> > > Distributed Services Card (DSC), intended to provide core configuration
> > > services through the auxiliary_bus for VFio and vDPA feature specific
> > > drivers.
> > 
> > Hi,
> > 
> > I didn't look very deeply to this series, but three things caught my
> > attention and IMHO they need to be changed/redesinged before someone
> > can consider to merge it.
> > 
> > 1. Use of bus_register_notifier to communicate between auxiliary devices.
> > This whole concept makes aux logic in this driver looks horrid. The idea
> > of auxiliary bus is separate existing device to sub-devices, while every
> > such sub-device is controlled through relevant subsystem. Current
> > implementation challenges this assumption by inventing own logic.
> > 2. devm_* interfaces. It is bad. Please don't use them in such a complex
> > driver.
> > 3. Listen to PCI BOUND_DRIVER event can't be correct either.
> > 
> > Thanks
> 
> Hi Leon,
> 
> Thanks for your comments.  I’ll respond to 1 and 3 together.
> 
> > 1. Use of bus_register_notifier to communicate between auxiliary devices.
> > 3. Listen to PCI BOUND_DRIVER event can't be correct either
> 
> We’re only using the notifier for the core driver to know when to create and
> destroy auxiliary devices, not for communicate between auxiliary devices or
> drivers – I agree, that would be ugly.
> 
> We want to create the auxiliary device after a VF PCI device is bound to a
> driver (BUS_NOTIFY_BOUND_DRIVER), and remove that auxiliary device just
> before a VF is unbound from its PCI driver (BUS_NOTIFY_UNBIND_DRIVER);
> bus_notify_register gives us access to these messages.  I believe this is
> not too far off from other examples that can be seen in
> vfio/pci/vfio_pci_core, net/ethernet/ibm/emac, and net/mctp.
> 
> Early on we were creating and deleting the auxiliary devices at the same
> time as calling sriov_enable() and sriov_disable() but found that when the
> user was doing unbind/bind operations we could end up with in-operative
> clients and occasional kernel panics because the devices and drivers were
> out-of-sync.  Listening for the bind/unbind events allows the pds_core
> driver to make sure the auxiliary devices serving each of the VF drivers are
> kept in sync with the state of the VF PCI drivers.

Auxiliary devices are intended to statically re-partition existing physical devices.
You are not supposed to create such devices on the fly. So once you create VF physical
device, it should already have aux device created too.

This is traditional driver device model which you should follow and not
reinvent your own schema, just to overcome bugs.

Additionally, it is unclear how much we should invest in this review
given the fact that pds VFIO series was NACKed.

> 
> 
> > 2. devm_* interfaces
> 
> Can you elaborate a bit on why you see using the devm interfaces as bad?  I
> don’t see the code complexity being any different than using the non-devm
> interfaces, and these give the added protection of making sure to not leak
> resources on driver removals, whether clean or on error.  We are using these
> allocations for longer term driver structures, not for ephemeral short-term
> use buffers or fast-path operations, so the overhead should remain minimal.
> It seems to me this is the advertised use as described in the devres notes
> under Documentation.

We had a very interesting talk in last LPC and overall agreement across
various subsystem maintainers was to stay away from devm_* interfaces.
https://lpc.events/event/16/contributions/1227/

We prefer explicit nature of kzalloc/kfree instead of implicit approach
of devm_kzalloc.

Thanks

> 
> Thanks,
> sln
> 
> 
