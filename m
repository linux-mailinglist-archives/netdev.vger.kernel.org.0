Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A312DA11D
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502878AbgLNUHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502729AbgLNUHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 15:07:42 -0500
Message-ID: <b53248b50737f49f78e6919b53d720b8caa7f548.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607976421;
        bh=3/wEl1L3wGhIAcG0RBSdE+TJGFwkivmfCtdBCW6bKwM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZAKGlHMumiwoiULwiY4EcDzVd3aqyXqmtwPEv4voLSLIkBCilLvnaTPW1g3PIsWVf
         vj37n2sF+RX8+A6gb24tP57i0sJo1J3StBXGEZ5vPyqfJTiqw2FW9yglDNv5IVFdsz
         vW0ZcOWXh6mIpq/ZSqKuA6YGekHuc8W93r7I3PDcPknr91zl2uC8Uggiwp9Q/iOJ4r
         JfFgo853rwtR1FnLJXtMniIgJGz+Ux40b7si5xTWWup6ezQKuJU4phskcv15iGCWQt
         Z2gR4VCuSTOmCNxtnYqPRT2ysMUnVRRYvkSZbhh3ZtGvRIWYWnCV7Bnq9skOAnFSTZ
         VhtbmiDPHh9Cg==
Subject: Re: [net-next v3 00/14] Add mlx5 subfunction support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 12:06:59 -0800
In-Reply-To: <BY5PR12MB43221E39769969BFD554BAADDCC70@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201212061225.617337-1-saeed@kernel.org>
         <20201212122518.1c09eefe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201213120848.GB5005@unreal>
         <BY5PR12MB43221E39769969BFD554BAADDCC70@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-14 at 03:25 +0000, Parav Pandit wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > Sent: Sunday, December 13, 2020 5:39 PM
> > 
> > On Sat, Dec 12, 2020 at 12:25:18PM -0800, Jakub Kicinski wrote:
> > > On Fri, 11 Dec 2020 22:12:11 -0800 Saeed Mahameed wrote:
> > > > Hi Dave, Jakub, Jason,
> > > > 
> > > > This series form Parav was the theme of this mlx5 release
> > > > cycle,
> > > > we've been waiting anxiously for the auxbus infrastructure to
> > > > make
> > > > it into the kernel, and now as the auxbus is in and all the
> > > > stars
> > > > are aligned, I can finally submit this V2 of the devlink and
> > > > mlx5
> > subfunction support.
> > > > Subfunctions came to solve the scaling issue of virtualization
> > > > and
> > > > switchdev environments, where SRIOV failed to deliver and users
> > > > ran
> > > > out of VFs very quickly as SRIOV demands huge amount of
> > > > physical
> > > > resources in both of the servers and the NIC.
> > > > 
> > > > Subfunction provide the same functionality as SRIOV but in a
> > > > very
> > > > lightweight manner, please see the thorough and detailed
> > > > documentation from Parav below, in the commit messages and the
> > > > Networking documentation patches at the end of this series.
> > > > 
> > > > Sending V2/V3 as a continuation to V1 that was sent Last month
> > > > [0],
> > > > [0]
> > > > https://lore.kernel.org/linux-rdma/20201112192424.2742-1-parav@nvidi
> > > > a.com/
> > > 
> > > This adds more and more instances of the 32 bit build warning.
> > > 
> > > The warning was also reported separately on netdev after the
> > > recent
> > > mlx5-next pull.
> > > 
> > > Please address that first (or did you already do and I missed it
> > > somehow?)
> > 
> > Hi Jakub,
> > 
> > I posted a fix from Parav,
> > https://lore.kernel.org/netdev/20201213120641.216032-1-
> > leon@kernel.org/T/#u
> > 
> > Thanks
> 
> Hi Jakub,
> This patchset is not added the original warning. Warning got added
> due to a commit [1].
> Its not related to subfunction.
> It will be fixed regardless of this patchset as posted in [2].
> 
> [1] 2a2970891647 ("net/mlx5: Add sample offload hardware bits and
> structures")
> [2] https://lore.kernel.org/netdev/20201213123620.GC5005@unreal/

I will resend this pr with the fix patch.

Thanks,
Saeed.

