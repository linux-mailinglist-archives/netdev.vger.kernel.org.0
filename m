Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC96466F1B
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 02:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377925AbhLCBb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 20:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377888AbhLCBb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 20:31:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DDFC06174A;
        Thu,  2 Dec 2021 17:28:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C19E628A9;
        Fri,  3 Dec 2021 01:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD68AC00446;
        Fri,  3 Dec 2021 01:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638494885;
        bh=OkSCwBuYLTYykjXFiRND6TNstXo05tFEWLU7PYXH85U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OcwRueO9VFvJVmuc/bIbkjeYC1A/Un0krvr9XG5XICqKUvPqsPWJQsm0wx74URKeZ
         LcksgMi2oxX2vnrOai9v0rM1dgKyIGijE5JoHwN+kg5P+AAJoKz/rNPzXJ4eZRqtBo
         rV38FlfnAVKfIVwe+YNaE18gVhyjkQL25IfaOZJTJJ+GsJ2UFliDv4RS63ZkMtVt68
         eZizxxWHiBqoYSdvk7ElBERQIndyKdAxKbf8q/SAb00X8q7apyZJDBrX9iMXiJi1hf
         T2PorrNGX91oL0fue9YAsiV8ayXdSZ4bzwC/r1Hgv9hCcOPaghTLsADuKrLfA48raV
         Cc5apWG2wCrRg==
Date:   Thu, 2 Dec 2021 17:28:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Shay Drory <shayd@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net/mlx5: Memory optimizations
Message-ID: <20211202172803.10cd5deb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <36d138a36fb1f86397929d56e6b716e89fc61e2e.camel@nvidia.com>
References: <20211130150705.19863-1-shayd@nvidia.com>
        <20211130113910.25a9e3ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <879d6d7c-f789-69bc-9f2d-bf77d558586a@nvidia.com>
        <20211202093129.2713b64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <36d138a36fb1f86397929d56e6b716e89fc61e2e.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Dec 2021 18:55:37 +0000 Saeed Mahameed wrote:
> On Thu, 2021-12-02 at 09:31 -0800, Jakub Kicinski wrote:
> > On Wed, 1 Dec 2021 10:22:17 +0200 Shay Drory wrote:  
> > > EQ resides in the host memory. It is RO for host driver, RW by
> > > device.
> > > When interrupt is generated EQ entry is placed by device and read
> > > by driver.
> > > It indicates about what event occurred such as CQE, async and more.  
> > 
> > I understand that. My point was the resource which is being consumed
> > here is _host_ memory. Is there precedent for configuring host memory
> > consumption via devlink resource?
> 
> it's a device resource size nonetheless, devlink resource API makes
> total sense.

I disagree. Devlink resources were originally written to partition
finite device resources. You're just sizing a queue here.

> > I'd even question whether this belongs in devlink in the first place.
> > It is not global device config in any way. If devlink represents the
> > entire device it's rather strange to have a case where main instance
> > limits a size of some resource by VFs and other endpoints can still
> > choose whatever they want.
> 
> This resource is per function instance, we have devlink instance per
> function, e.g. in the VM, there is a VF devlink instance the VM user
> can use to control own VF resources. in the PF/Hypervisor, the only
> devlink representation of the VF will be devlink port function (used
> for other purposes)
> 
> for example:
> 
> A tenant can fine-tune a resource size tailored to their needs via the
> VF's own devlink instance.

Yeah, because it's a device resource. Tenant can consume their host
DRAM in any way they find suitable.

> An admin can only control or restrict a max size of a resource for a
> given port function ( the devlink instance that represents the VF in
> the hypervisor). (note: this patchset is not about that)
> 
> > > So far no feedback by other vendors.
> > > The resources are implemented in generic way, if other vendors
> > > would
> > > like to implement them.  
> > 
> > Well, I was hoping you'd look around, but maybe that's too much to
> > ask of a vendor.  
> 
> We looked, eq is a common object among many other drivers.
> and DEVLINK_PARAM_GENERIC_ID_MAX_MACS is already a devlink generic
> param, and i am sure other vendors have limited macs per VF :) .. 
> so this applies to all vendors even if they don't advertise it.

Yeah, if you're not willing to model the Event Queue as a queue using
params seems like a better idea than abusing resources.
