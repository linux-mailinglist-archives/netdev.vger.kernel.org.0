Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954B030E32F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 20:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhBCTXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 14:23:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232051AbhBCTX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 14:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A7C564DF5;
        Wed,  3 Feb 2021 19:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612380165;
        bh=kB89/TlhGyCz1GyXxEFvgWet15euMK4rhW4b7b2/V84=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MI0HrjGAS4mV4YDPWoDrMPrXkwkwTTc2EDZGQvmZj8sdt8Lx0MKKM33t1cCis8cZa
         2AlVxeNattKePN4KlK38Dtz7VmE4JvocjzXCWIreZrPbF+4qYO7ZHnMx++LdJndH5m
         xDxN0CvWpfb+HmMs4pLiaWdCAUsAYmqpI80Ag6LjNeTAREsbFwv6eBaqTGn2367hpK
         sqtGNRP5mI06AGA5FNjV3oOLpWWFQ60DQ6kOV3R9eRYh/VCM8XSzUaelIgzVTq7C0H
         6KwJ4Ai0C8AD2rXQowa/vIRHZkNIgjxPYG9i5t8u9xUSG3l/PODhJSFzpgUPoyIHs5
         4oU14zUYJhwTQ==
Message-ID: <38d73470cd4faac0dc6c09697f33c5fb90d13f4e.camel@kernel.org>
Subject: Re: [PATCH net-next 0/2] devlink: Add port function attribute to
 enable/disable roce
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, parav@nvidia.com
Date:   Wed, 03 Feb 2021 11:22:44 -0800
In-Reply-To: <20210203105102.71e6fa2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210201175152.11280-1-yishaih@nvidia.com>
         <20210202181401.66f4359f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <d01dfcc6f46f2c70c4921139543e5823582678c8.camel@kernel.org>
         <20210203105102.71e6fa2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-03 at 10:51 -0800, Jakub Kicinski wrote:
> On Tue, 02 Feb 2021 20:13:48 -0800 Saeed Mahameed wrote:
> > On Tue, 2021-02-02 at 18:14 -0800, Jakub Kicinski wrote:
> > > On Mon, 1 Feb 2021 19:51:50 +0200 Yishai Hadas wrote:  
> > > > Currently mlx5 PCI VF and SF are enabled by default for RoCE
> > > > functionality.
> > > > 
> > > > Currently a user does not have the ability to disable RoCE for
> > > > a
> > > > PCI
> > > > VF/SF device before such device is enumerated by the driver.
> > > > 
> > > > User is also incapable to do such setting from smartnic
> > > > scenario
> > > > for a
> > > > VF from the smartnic.
> > > > 
> > > > Current 'enable_roce' device knob is limited to do setting only
> > > > at
> > > > driverinit time. By this time device is already created and
> > > > firmware has
> > > > already allocated necessary system memory for supporting RoCE.
> > > > 
> > > > When a RoCE is disabled for the PCI VF/SF device, it saves 1
> > > > Mbyte
> > > > of
> > > > system memory per function. Such saving is helpful when running
> > > > on
> > > > low
> > > > memory embedded platform with many VFs or SFs.
> > > > 
> > > > Therefore, it is desired to empower user to disable RoCE
> > > > functionality
> > > > before a PCI SF/VF device is enumerated.  
> > > 
> > > You say that the user on the VF/SF side wants to save memory, yet
> > > the control knob is on the eswitch instance side, correct?
> > >   
> > 
> > yes, user in this case is the admin, who controls the provisioned
> > network function SF/VFs.. by turning off this knob it allows to
> > create
> > more of that resource in case the user/admin is limited by memory.
> 
> Ah, so in case of the SmartNIC this extra memory is allocated on the
> control system, not where the function resides?
> 

most of the memeory are actually allocated from where the function
resides, some are on the management system but it is not as critical.
SFs for now can only be probed on the management system, so the main
issue will be on the SmartNIC side for now.

> My next question is regarding the behavior on the target system -
> what
> does "that user" see? Can we expect they will understand that the
> limitation was imposed by the admin and not due to some
> initialization
> failure or SW incompatibility?
> 

the whole thing works with only real HW capabilities, there is no
synthetic SW capabilities. 

when mlx5 instance driver loads, it doesn't assume anything about
underlying HW, and it queries for the advertised FW capability
according to the HW spec before it enables a feature.

so this patch adds the ability for admin to enforce a specific HW cap
"off" for a VF/SF hca slice.


> > > > This is achieved by extending existing 'port function' object
> > > > to
> > > > control
> > > > capabilities of a function. This enables users to control
> > > > capability of
> > > > the device before enumeration.
> > > > 
> > > > Examples when user prefers to disable RoCE for a VF when using
> > > > switchdev
> > > > mode:
> > > > 
> > > > $ devlink port show pci/0000:06:00.0/1
> > > > pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf
> > > > controller
> > > > 0
> > > > pfnum 0 vfnum 0 external false splittable false
> > > >   function:
> > > >     hw_addr 00:00:00:00:00:00 roce on
> > > > 
> > > > $ devlink port function set pci/0000:06:00.0/1 roce off
> > > >   
> > > > $ devlink port show pci/0000:06:00.0/1
> > > > pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf
> > > > controller
> > > > 0
> > > > pfnum 0 vfnum 0 external false splittable false
> > > >   function:
> > > >     hw_addr 00:00:00:00:00:00 roce off
> > > > 
> > > > FAQs:
> > > > -----
> > > > 1. What does roce on/off do?
> > > > Ans: It disables RoCE capability of the function before its
> > > > enumerated,
> > > > so when driver reads the capability from the device firmware,
> > > > it is
> > > > disabled.
> > > > At this point RDMA stack will not be able to create UD, QP1,
> > > > RC,
> > > > XRC
> > > > type of QPs. When RoCE is disabled, the GID table of all ports
> > > > of
> > > > the
> > > > device is disabled in the device and software stack.
> > > > 
> > > > 2. How is the roce 'port function' option different from
> > > > existing
> > > > devlink param?
> > > > Ans: RoCE attribute at the port function level disables the
> > > > RoCE
> > > > capability at the specific function level; while enable_roce
> > > > only
> > > > does
> > > > at the software level.
> > > > 
> > > > 3. Why is this option for disabling only RoCE and not the whole
> > > > RDMA
> > > > device?
> > > > Ans: Because user still wants to use the RDMA device for non
> > > > RoCE
> > > > commands in more memory efficient way.  
> > > 
> > > What are those "non-RoCE commands" that user may want to use "in
> > > a
> > > more
> > > efficient way"?  
> > 
> > RAW eth QP, i think you already know this one, it is a very thin
> > layer
> > that doesn't require the whole rdma stack.
> 
> Sorry for asking a leading question. You know how we'll feel about
> that one, do we need to talk this out or can we save ourselves the
> battle? :S

I know, I know :/

So, there is no rdma bit/cap in HW.. to disable non-RoCE commands we
will have to disable etherent capability. 

The user interface here has no synthetic semantics, all knobs will
eventually be mapped to real HW/FW capabilities to get disabled.

the whole feature is about allowing admin to ship network functions
with different capabilities that are actually enforced by FW/HW.. 
so the user of the VF will see, RDMA/ETH only cards or both.






