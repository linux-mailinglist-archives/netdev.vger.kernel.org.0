Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3788D69EFBD
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 08:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjBVH7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 02:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjBVH7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 02:59:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1963C27D49
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 23:59:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A324861236
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883EAC433D2;
        Wed, 22 Feb 2023 07:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677052745;
        bh=MqlZ9ZAu20m+gpd5aPzIcbCvwp33WL/BvlIwtVK6J9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IQHunqa6wuodI3pN1Slqz9A/YGuYwjlVmvTcoQ94YvvuoUfLeyQYTALKYwlyz9Kr1
         g8Umol4zveySa+mOsuSBnZ8JLkB4hHUbCJqj31yq89YSz/3UkguI4MKQXGH2vDrXdD
         pnOHLjIqH6U4T88niu0DIBFH3oD7R2TrKvA1Tx+WS9a9FfuTNGyOsZE12PMKAFjYnm
         A9gEIdos01E8IeohozHI7+7eYjGbVXlhDrM5pThodMKsoRRnTcLXmcOS1syAGACCnG
         igkVNnuwWtAAoU0Dp8Y9Qr0oVCKEhoyigIfYH0sgseLXdVFi9w/yqybUvCOF8fM+Z8
         DqqF/MlwT+wNQ==
Date:   Wed, 22 Feb 2023 09:59:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, brett.creeley@amd.com
Subject: Re: [PATCH v3 net-next 00/14] pds_core driver
Message-ID: <Y/XLRC4FJBiE0UCy@unreal>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
 <Y/H14ByDBPTA+yqg@unreal>
 <bea899bd-c7c1-80cd-8804-e6a3167ea9eb@amd.com>
 <Y/RqeOVZaGA6nIW9@unreal>
 <71f2f2cc-44e7-c315-2005-0b23c8f812af@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71f2f2cc-44e7-c315-2005-0b23c8f812af@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 02:03:24PM -0800, Shannon Nelson wrote:
> On 2/20/23 10:53 PM, Leon Romanovsky wrote:
> > On Mon, Feb 20, 2023 at 03:53:02PM -0800, Shannon Nelson wrote:
> > > On 2/19/23 2:11 AM, Leon Romanovsky wrote:
> > > > On Fri, Feb 17, 2023 at 02:55:44PM -0800, Shannon Nelson wrote:
> > > > > Summary:
> > > > > --------
> > > > > This patchset implements new driver for use with the AMD/Pensando
> > > > > Distributed Services Card (DSC), intended to provide core configuration
> > > > > services through the auxiliary_bus for VFio and vDPA feature specific
> > > > > drivers.
> > > > 
> > > > Hi,
> > > > 
> > > > I didn't look very deeply to this series, but three things caught my
> > > > attention and IMHO they need to be changed/redesinged before someone
> > > > can consider to merge it.
> > > > 
> > > > 1. Use of bus_register_notifier to communicate between auxiliary devices.
> > > > This whole concept makes aux logic in this driver looks horrid. The idea
> > > > of auxiliary bus is separate existing device to sub-devices, while every
> > > > such sub-device is controlled through relevant subsystem. Current
> > > > implementation challenges this assumption by inventing own logic.
> > > > 2. devm_* interfaces. It is bad. Please don't use them in such a complex
> > > > driver.
> > > > 3. Listen to PCI BOUND_DRIVER event can't be correct either.
> > > > 
> > > > Thanks
> > > 
> > > Hi Leon,
> > > 
> > > Thanks for your comments.  I’ll respond to 1 and 3 together.
> > > 
> > > > 1. Use of bus_register_notifier to communicate between auxiliary devices.
> > > > 3. Listen to PCI BOUND_DRIVER event can't be correct either
> > > 
> > > We’re only using the notifier for the core driver to know when to create and
> > > destroy auxiliary devices, not for communicate between auxiliary devices or
> > > drivers – I agree, that would be ugly.
> > > 
> > > We want to create the auxiliary device after a VF PCI device is bound to a
> > > driver (BUS_NOTIFY_BOUND_DRIVER), and remove that auxiliary device just
> > > before a VF is unbound from its PCI driver (BUS_NOTIFY_UNBIND_DRIVER);
> > > bus_notify_register gives us access to these messages.  I believe this is
> > > not too far off from other examples that can be seen in
> > > vfio/pci/vfio_pci_core, net/ethernet/ibm/emac, and net/mctp.
> > > 
> > > Early on we were creating and deleting the auxiliary devices at the same
> > > time as calling sriov_enable() and sriov_disable() but found that when the
> > > user was doing unbind/bind operations we could end up with in-operative
> > > clients and occasional kernel panics because the devices and drivers were
> > > out-of-sync.  Listening for the bind/unbind events allows the pds_core
> > > driver to make sure the auxiliary devices serving each of the VF drivers are
> > > kept in sync with the state of the VF PCI drivers.
> > 
> > Auxiliary devices are intended to statically re-partition existing physical devices.
> > You are not supposed to create such devices on the fly. So once you create VF physical
> > device, it should already have aux device created too.
> > 
> > This is traditional driver device model which you should follow and not
> > reinvent your own schema, just to overcome bugs.
> 
> Not so much a “bug”, I think, as an incomplete model which we addressed by
> using a hotplug model with the aux-devices.  We felt we were following a
> part of the device model, but perhaps from the wrong angle: hot-plugging the
> aux-devices, which  worked nicely to simplify the aux-driver/pci-driver
> relationship.  

By looking (very briefly) on your pds_core and pds_vfio code, your
notification scheme worked by chance as it lacks proper PCI and driver
locks. You probably didn't stress enough PCI PF teardown.

> However, I think the hole we fell into was expecting the
> client to be tied to a pci device on the other end, and this shouldn’t be a
> factor in the core’s management of the aux device.
> 
> So, the aux-device built by the core needs to remain the constant, which is
> what we originally had: the aux devices created at pci_enable_sriov() time
> and torn down at pci_disable_sriov().  It’s easy enough to go back to that
> model, and that makes sense.

Not really, aux device creation is supposed to be in .probe() call of
your PCI function, whenever it is PF or VF. After call to
pci_enable_sriov(), the HW will add VFs, which will cause to PCI core to
attempt and load pds_core .probe() callback.

> 
> Meanwhile, for those clients that do rely on the existence of a pci device,
> would you see that as a proper use of a bus listener to have the aux-driver
> subscribe and listen for its bind/unbind events?

No, these events must go.

> 
> 
> > 
> > Additionally, it is unclear how much we should invest in this review
> > given the fact that pds VFIO series was NACKed.
> 
> We haven’t given up on that one yet, and we have a vDPA client in mind as
> well possibly one or two others.

I don't know about your plans and judge by what I saw in ML, VFIO was NACKed for
second time already on the same ground.

Thanks

> 
> 
> > 
> > > 
> > > 
> > > > 2. devm_* interfaces
> > > 
> > > Can you elaborate a bit on why you see using the devm interfaces as bad?  I
> > > don’t see the code complexity being any different than using the non-devm
> > > interfaces, and these give the added protection of making sure to not leak
> > > resources on driver removals, whether clean or on error.  We are using these
> > > allocations for longer term driver structures, not for ephemeral short-term
> > > use buffers or fast-path operations, so the overhead should remain minimal.
> > > It seems to me this is the advertised use as described in the devres notes
> > > under Documentation.
> > 
> > We had a very interesting talk in last LPC and overall agreement across
> > various subsystem maintainers was to stay away from devm_* interfaces.
> > https://lpc.events/event/16/contributions/1227/
> > 
> > We prefer explicit nature of kzalloc/kfree instead of implicit approach
> > of devm_kzalloc.
> 
> Interesting – thanks, I missed that presentation.  Sure, we can pull back on
> this.
> 
> Thanks for your comments.
> 
> sln
> 
