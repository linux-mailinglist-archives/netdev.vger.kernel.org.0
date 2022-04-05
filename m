Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FE24F2234
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiDEErj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 00:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiDEErM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 00:47:12 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E31F9FD9;
        Mon,  4 Apr 2022 21:43:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 71A6168AFE; Tue,  5 Apr 2022 06:43:31 +0200 (CEST)
Date:   Tue, 5 Apr 2022 06:43:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Ariel Elior <aelior@marvell.com>, Anna Schumaker <anna@kernel.org>,
        Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        target-devel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Xiao Yang <yangx.jy@fujitsu.com>
Subject: Re: [PATCH] RDMA: Split kernel-only global device caps from uvers
 device caps
Message-ID: <20220405044331.GA22322@lst.de>
References: <0-v1-47e161ac2db9+80f-kern_caps_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-47e161ac2db9+80f-kern_caps_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 01:18:00PM -0300, Jason Gunthorpe wrote:
> Split ib_device::device_cap_flags into kernel_cap_flags that holds the
> flags only used by the kernel.
> 
> This cleanly splits out the uverbs flags from the kernel flags to avoid
> confusion in the flags bitmap.

> Followup from Xiao Yang's series

Can you point me to this series?

> -	if (!(device->attrs.device_cap_flags & IB_DEVICE_ALLOW_USER_UNREG)) {
> +	if (!(device->attrs.kernel_cap_flags & IB_KDEVICE_ALLOW_USER_UNREG)) {

Maybe shorten the prefix to IBD_ ?

> +enum ib_kernel_cap_flags {
> +	/*
> +	 * This device supports a per-device lkey or stag that can be
> +	 * used without performing a memory registration for the local
> +	 * memory.  Note that ULPs should never check this flag, but
> +	 * instead of use the local_dma_lkey flag in the ib_pd structure,
> +	 * which will always contain a usable lkey.
> +	 */
> +	IB_KDEVICE_LOCAL_DMA_LKEY = 1 << 0,
> +	IB_KDEVICE_UD_TSO = 1 << 1,
> +	IB_KDEVICE_BLOCK_MULTICAST_LOOPBACK = 1 << 2,
> +	IB_KDEVICE_INTEGRITY_HANDOVER = 1 << 3,
> +	IB_KDEVICE_ON_DEMAND_PAGING = 1ULL << 4,
> +	IB_KDEVICE_SG_GAPS_REG = 1ULL << 5,
> +	IB_KDEVICE_VIRTUAL_FUNCTION = 1ULL << 6,
> +	IB_KDEVICE_RDMA_NETDEV_OPA = 1ULL << 7,
> +	IB_KDEVICE_ALLOW_USER_UNREG = 1ULL << 8,
> +};

And maybe not in this patch, but if you touch this anyway please add
comments to document allthe flags.
