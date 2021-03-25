Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA04348A6B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 08:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhCYHtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 03:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229619AbhCYHtF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 03:49:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8042261574;
        Thu, 25 Mar 2021 07:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616658545;
        bh=/JQYd6mC27MAlb+cNIvcwb8HZBaUE09MYG3eku/VEL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r3KBVOwrJFm1qkGhJuO67qMebjRmMNnTa96D0siLaig4BqcpGXil6ua4dJXVlQMdU
         GwGFduCfgZHs73NLWLlqCvmwzE5ybZrJwjPULaHWp52Eurq6WrqnHy2o9eP8IApguL
         g//tf4EERHO4irjJM5RD0gMXlZNZlqn4epO7OcMOk6WLmmYwGMzKwVZF6EV17Zekia
         d5K9lRCQoomXIF4sr7toswd41TpEEDveZGtnQ7lB2LyJKBvprveO9QFa9OrZtriuyL
         VjpKzQSXxSTDRgD9uBlD0m0FKKG2Nls1qEm7UfWwoHd01oZJwyRLe0FQvFY8uOwu6l
         pfChPR3UV1LqA==
Date:   Thu, 25 Mar 2021 09:49:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Mark Bloch <mbloch@nvidia.com>, Adit Ranadive <aditr@vmware.com>,
        Ariel Elior <aelior@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christian Benvenuti <benve@cisco.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        target-devel@vger.kernel.org,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next] RDMA: Support more than 255 rdma ports
Message-ID: <YFxAbeGKAuFJYrll@unreal>
References: <20210301070420.439400-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301070420.439400-1-leon@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 09:04:20AM +0200, Leon Romanovsky wrote:
> From: Mark Bloch <mbloch@nvidia.com>
> 
> Current code uses many different types when dealing with a port of a
> RDMA device: u8, unsigned int and u32. Switch to u32 to clean up the
> logic.
> 
> This allows us to make (at least) the core view consistent and use the same
> type. Unfortunately not all places can be converted. Many uverbs functions
> expect port to be u8 so keep those places in order not to break UAPIs.
> HW/Spec defined values must also not be changed.
> 
> With the switch to u32 we now can support devices with more than 255
> ports. U32_MAX is reserved to make control logic a bit easier to deal
> with. As a device with U32_MAX ports probably isn't going to happen any
> time soon this seems like a non issue.
> 
> When a device with more than 255 ports is created uverbs will report
> the RDMA device as having 255 ports as this is the max currently supported.
> 
> The verbs interface is not changed yet because the IBTA spec limits the
> port size in too many places to be u8 and all applications that relies in
> verbs won't be able to cope with this change. At this stage, we are
> extending the interfaces that are using vendor channel solely
> 
> Once the limitation is lifted mlx5 in switchdev mode will be able to have
> thousands of SFs created by the device. As the only instance of an RDMA
> device that reports more than 255 ports will be a representor device
> and it exposes itself as a RAW Ethernet only device CM/MAD/IPoIB and other
> ULPs aren't effected by this change and their sysfs/interfaces that
> are exposes to userspace can remain unchanged.
> 
> While here cleanup some alignment issues and remove unneeded sanity
> checks (mainly in rdmavt),
> 
> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---

Jason, ping

Thanks
