Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D9B190400
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 04:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgCXD4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 23:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbgCXD4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 23:56:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CCCA20714;
        Tue, 24 Mar 2020 03:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585022182;
        bh=93sdHtEFzAe/5o7rPqKAmT81a4Sb44X0aXkgKWe/VKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l12mmRaXsGTXbUxuCbmztpmks9n7GY2lve7Di82rW/GtND0tIKOXdieYyJJIlcNiY
         fFHLfLbOPyTkAiu8UPPMVV8IWzj6Y/T/JVrHB0gskqLbopXGFtiyNf8HU4YHZeGsxa
         d0ttRKHtrvxgpbp4Tlk7vC3G3S8kJmDocV+2t0iE=
Date:   Mon, 23 Mar 2020 20:56:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, parav@mellanox.com, yuvalav@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        moshe@mellanox.com, ayal@mellanox.com, eranbe@mellanox.com,
        vladbu@mellanox.com, kliteyn@mellanox.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, tariqt@mellanox.com,
        oss-drivers@netronome.com, snelson@pensando.io,
        drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200323205619.2f957f1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200323220605.GE20941@ziepe.ca>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
        <20200320073555.GE11304@nanopsycho.orion>
        <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
        <20200321093525.GJ11304@nanopsycho.orion>
        <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200323220605.GE20941@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Mar 2020 19:06:05 -0300 Jason Gunthorpe wrote:
> On Mon, Mar 23, 2020 at 12:21:23PM -0700, Jakub Kicinski wrote:
> > > >I see so you want the creation to be controlled by the same entity that
> > > >controls the eswitch..
> > > >
> > > >To me the creation should be on the side that actually needs/will use
> > > >the new port. And if it's not eswitch manager then eswitch manager
> > > >needs to ack it.    
> > > 
> > > Hmm. The question is, is it worth to complicate things in this way?
> > > I don't know. I see a lot of potential misunderstandings :/  
> > 
> > I'd see requesting SFs over devlink/sysfs as simplification, if
> > anything.  
> 
> We looked at it for a while, working the communication such that the
> 'untrusted' side could request a port be created with certain
> parameters and the 'secure eswitch' could know those parameters to
> authorize and wire it up was super complicated and very hard to do
> without races.
> 
> Since it is a security sensitive operation it seems like a much more
> secure design to have the secure side do all the creation and present
> the fully operational object to the insecure side.
> 
> To draw a parallel to qemu & kvm, the untrusted guest VM can't request
> that qemu create a virtio-net for it. Those are always hot plugged in
> by the secure side. Same flow here.

Could you tell us a little more about the races? Other than the
communication channel what changes between issuing from cloud API
vs devlink?

Side note - there is no communication channel between VM and hypervisor
right now, which is the cause for weird designs e.g. the failover/auto
bond mechanism.

> > > >The precedence is probably not a strong argument, but that'd be the
> > > >same way VFs work.. I don't think you can change how VFs work, right?    
> > > 
> > > You can't, but since the VF model is not optimal as it turned out, do we
> > > want to stick with it for the SFs too?  
> > 
> > The VF model is not optimal in what sense? I thought the main reason
> > for SFs is that they are significantly more light weight on Si side.  
> 
> Not entirely really, the biggest reason for SF is because VF have to
> be pr-eallocated and have a number limited by PCI.
> 
> The VF model is poor because the VF is just a dummy stub until the
> representor/eswitch side is fully configured. There is no way for the
> Linux driver to know if the VF is operational or not, so we get weird
> artifacts where we sometimes bind a driver to a VF (and get a
> non-working ethXX) and sometimes we don't. 

Sounds like an implementation issue :S

> The only reason it is like this is because of how SRIOV requires
> everything to be preallocated.

SF also requires pre-allocated resources, so you're not talking about
PCI mem space etc. here I assume.

> The SFs can't even exist until they are configured, so there is no
> state where a driver is connected to an inoperative SF.

You mean it doesn't exist in terms of sysfs device entry?

Okay, if we limit ourselves to sysfs as device interface then sure.
We have far richer interfaces in networking world, so it's a little 
hard to sympathize.

> So it would be nice if VF and SF had the same flow, the SF flow is
> better, lets fix the VF flow to match it.
