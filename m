Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C7D319791
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 01:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBLAmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 19:42:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhBLAm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 19:42:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F5E864DE9;
        Fri, 12 Feb 2021 00:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613090506;
        bh=N8MMQ3Tnr1bhPxFBn4mIqDFBbmodPR8nXHhqJVdYGn4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mja3xy1hXZUFSGemlo2NrcrMUmHzp9xp/I1rwJA3BT+60DFUAqScCv4w5Lw47FTDh
         NM4cX1O3T/cdbRjM069Qxu51zUhiqj9I3Hkw5lMJ1YwTn6SnYuOHx33FOSdaPAtiQm
         7lVIbBFEZxsGe/6V56vLjEHKCeLpgQsLXm6GGL4srpxQguX/B0OIfV9+9o4z37VsRj
         s03Nytbnd4tcofgITvicxEHRVyJdc7MuReDMNBEehJAFfZ1s6fDc0xBlMEsN9uRukK
         AAwKbYbaMgpkql7qoI/nGPVFLV0YxYlM342vr4m8iPaCUVK+6QD6TcSBs4scBciuvw
         1Zx2krURiYQTA==
Message-ID: <f8320042b1b0d60f8885e7c62760ee4fca0b89b2.camel@kernel.org>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
From:   Saeed Mahameed <saeed@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Leon Romanovsky <leon@kernel.org>, Chris Mi <cmi@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, kernel test robot <lkp@intel.com>
Date:   Thu, 11 Feb 2021 16:41:45 -0800
In-Reply-To: <20210211215952.GA374617@shredder.lan>
References: <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20210130144231.GA3329243@shredder.lan>
         <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
         <20210201180837.GB3456040@shredder.lan> <20210208070350.GB4656@unreal>
         <20210208085746.GA179437@shredder.lan> <20210208090702.GB20265@unreal>
         <20210208170735.GA207830@shredder.lan> <20210209064702.GB139298@unreal>
         <30482e059a48fb35f90a7594355bc27dcd71dacc.camel@kernel.org>
         <20210211215952.GA374617@shredder.lan>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-02-11 at 23:59 +0200, Ido Schimmel wrote:
> On Wed, Feb 10, 2021 at 09:09:41PM -0800, Saeed Mahameed wrote:
> > This won't solve anything other than compilation time dependency
> > between built-in modules to external modules, this is not the case.
> > 
> > our case is when both mlx5 and psample are modules, you can't load
> > mlx5
> > without loading psample, even if you are not planning to use
> > psample or
> > mlx5 psample features, which is 99.99% of the cases.
> 
> You are again explaining what are the implications of the dependency,
> but you are not explaining why it is the end of the world for you.
> All I
> hear are hypotheticals. Dependencies are also a common practice in
> the
> kernel and mlx5 has a few of its own (I see that pci_hyperv_intf was
> loaded by mlx5_core on my system, for example).
> 

Very great example actually, the reason there is pci_hyperv_intf in
first place is exactly to avoid hard dependency between mlx5_core and
pci_hyperv.ko so they came up with pci_hyperv_intf which is a thin
layer between pci_hyperv and mlx5_core, microsoft insisted at the time
that pci_hyperv_intf can be a module (I really don't know why
though) ..

if there wasn't  pci_hyperv_intf then pci_hyperv would be a direct
dependency of mlx5_core, the problem s that pci_hperv can only be
loaded on a hyperv VM.. if you try to load it on any different host it
will fail, thus mlx5 can never load on any system where pci_hyperv.ko
is enabled as CONFIG option but it is not a hyperv VM..

Anyway the point is clear and very straight forward:

A hw_driver.ko should never depend on feature_x.ko, because who knows
what dependencies feature_x.ko are hiding behind or what pre-conditions
feature_x.ko can impose.


> > What we are asking for here is not new, and is a common practice in
> > netdev stack
> > 
> > see :
> > udp_tunnel_nic_ops
> > netfilter is full of these, see nf_ct_hook..
> > 
> > I don't see anything wrong with either repeating this practice for
> > any
> > module or having some sort of a generic proxy in the built-in
> > netdev
> > layer..
> 
> If you want to move forward with patch, then I ask that you provide a
> proper commit message with all the information that was exchanged in
> this thread so that multiple people wouldn't need to milk it again
> upon

Apparently you didn't milk this thread well enough, we already shut the
door on this patch weeks ago :)

But We are still discussing the dependency claim, not related to
psample..
We have some features lined up with harder dependencies than psample.

Again as i previously said, I will try to come up with a unified
universal approach with the necessary documentation and explanations.


> re-submission. For example:
> 
> "
> The tc-sample action sends sampled packets to the psample module
> which
> encapsulates them in generic netlink messages along with associated
> metadata and emits notifications to user space.
> 
> Device drivers that offload this action are expected to report
> sampled
> packets directly to the psample module by calling
> psample_sample_packet(). This creates a dependency between these
> drivers
> and the psample module.
> 
> While we are not aware of a problem this dependency can create, we
> prefer to avoid it due to past experience with other dependencies.
> For
> example, we discovered that a dependency of mlx5_core on nf_conntrack
> will result in mlx5_core being unloaded upon a restart of the
> firewalld
> service. This is because the firewalld service iterates over all the
> dependants of nf_conntrack and unloads them so that it could
> eventually
> unload nf_conntrack [1]. In addition, the psample module is only
> needed
> in a small subset of deployments.
> 
> Therefore, avoid this dependency by doing XYZ. This is a common way
> to
> reduce dependencies and employed by XYZ, for example.
> 
> Note that while the psample module will not be loaded upon the
> loading
> of offloading drivers, it will be loaded by act_sample, which depends
> on
> it. And since drivers offload the act_sample action, psample will be
> loaded when needed.
> 
> Encapsulating the sampling code in a driver with a config option and
> making it depend on psample will result in the psample module being
> loaded in most cases given that some distributions blindly enable all
> config options.
> 
> [1]   
> https://github.com/firewalld/firewalld/blob/master/src/firewall/core/modules.py#L97
> "
> 
> I also ask that this patch will be routed via the mlxsw queue. Few
> reasons:
> 
> 1. mlxsw already depends on psample while mlx5 does not. Therefore,
> this
> patch needs to take care of mlxsw first. There is no reason to call
> into
> psample differently from different drivers
> 
> 2. We are about to queue changes (for 5.13) to psample that are going
> to
> conflict with this patch. To avoid the conflict, I want to queue this
> patch on top of these changes. The changes also contain selftests
> which
> will provide better test coverage for this patch
> 
> Thanks

Thanks, will keep this in mind.


