Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A2B30D14B
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhBCCOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:14:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230098AbhBCCOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 21:14:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 275EE64F78;
        Wed,  3 Feb 2021 02:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612318442;
        bh=Nw+vJvN6NWuPl0t2BHt2VefFIK3Rtuig6Vjum+RhBec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sCiPC/qhTV/ifEMhx0H7ocM2LdYWCicB3yxGKILSoir5GAHhL839namyDlxTyfxmc
         PmG8Kp0vZO16h1rPPsXxyB1fGJYeO5K3eJh/e/0rKxc/9DIRXr7UW1tmt41EZdsYjU
         AU+b5XcIphcfXkXcTaH95b1s71UbiMbYsTtzqGeCDtHc9bmfNAzua9EpuIVCALvLDe
         bQAhNH8iDmF7QdLSm1/axBMa0foZhfEwCo+6xyxTrQaK9wnW/zqsldPVOyZVryJNiP
         OlAJPSFzpu01YAODbsxmAUkHMyja6fLcxzk//6DhllVitMZ3z0khSiLajDoaEn9Ac5
         wnKARxbo2y8BA==
Date:   Tue, 2 Feb 2021 18:14:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <parav@nvidia.com>, <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 0/2] devlink: Add port function attribute to
 enable/disable roce
Message-ID: <20210202181401.66f4359f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201175152.11280-1-yishaih@nvidia.com>
References: <20210201175152.11280-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 19:51:50 +0200 Yishai Hadas wrote:
> Currently mlx5 PCI VF and SF are enabled by default for RoCE
> functionality.
> 
> Currently a user does not have the ability to disable RoCE for a PCI
> VF/SF device before such device is enumerated by the driver.
> 
> User is also incapable to do such setting from smartnic scenario for a
> VF from the smartnic.
> 
> Current 'enable_roce' device knob is limited to do setting only at
> driverinit time. By this time device is already created and firmware has
> already allocated necessary system memory for supporting RoCE.
> 
> When a RoCE is disabled for the PCI VF/SF device, it saves 1 Mbyte of
> system memory per function. Such saving is helpful when running on low
> memory embedded platform with many VFs or SFs.
> 
> Therefore, it is desired to empower user to disable RoCE functionality
> before a PCI SF/VF device is enumerated.

You say that the user on the VF/SF side wants to save memory, yet
the control knob is on the eswitch instance side, correct?

> This is achieved by extending existing 'port function' object to control
> capabilities of a function. This enables users to control capability of
> the device before enumeration.
> 
> Examples when user prefers to disable RoCE for a VF when using switchdev
> mode:
> 
> $ devlink port show pci/0000:06:00.0/1
> pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller 0
> pfnum 0 vfnum 0 external false splittable false
>   function:
>     hw_addr 00:00:00:00:00:00 roce on
> 
> $ devlink port function set pci/0000:06:00.0/1 roce off
>   
> $ devlink port show pci/0000:06:00.0/1
> pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller 0
> pfnum 0 vfnum 0 external false splittable false
>   function:
>     hw_addr 00:00:00:00:00:00 roce off
> 
> FAQs:
> -----
> 1. What does roce on/off do?
> Ans: It disables RoCE capability of the function before its enumerated,
> so when driver reads the capability from the device firmware, it is
> disabled.
> At this point RDMA stack will not be able to create UD, QP1, RC, XRC
> type of QPs. When RoCE is disabled, the GID table of all ports of the
> device is disabled in the device and software stack.
> 
> 2. How is the roce 'port function' option different from existing
> devlink param?
> Ans: RoCE attribute at the port function level disables the RoCE
> capability at the specific function level; while enable_roce only does
> at the software level.
> 
> 3. Why is this option for disabling only RoCE and not the whole RDMA
> device?
> Ans: Because user still wants to use the RDMA device for non RoCE
> commands in more memory efficient way.

What are those "non-RoCE commands" that user may want to use "in a more
efficient way"?
