Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E204A1E37B1
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 07:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgE0FJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 01:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgE0FJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 01:09:00 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85DB020899;
        Wed, 27 May 2020 05:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590556140;
        bh=lcTl97DRKxnKu0MpzTbjW/vwMuC88LbibBedXb/b+eo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kKmsiqlS1BxDCxtGtYBs2dsTODpmJH4aElfvbExQp4oYCbvocxs/OzQXdFV+YiMkZ
         YbSGe27cuE9BRSQBHJrUHAsir13JThJdJ8jyOe9xecngud4yu7qyRDESkDxhuP2DC4
         MLzWhK/E5VSQ/k/s/u9Qf431XkkQ/PPd4UEMrdPY=
Date:   Wed, 27 May 2020 08:08:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>
Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
Message-ID: <20200527050855.GB349682@unreal>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200521141247.GQ24561@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7EE04047F@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7EE04047F@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 01:58:01AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
> >
> > On Wed, May 20, 2020 at 12:03:59AM -0700, Jeff Kirsher wrote:
> > > This patch set adds a unified Intel Ethernet Protocol Driver for RDMA
> > > that supports a new network device E810 (iWARP and RoCEv2 capable) and
> > > the existing X722 iWARP device. The driver architecture provides the
> > > extensibility for future generations of Intel HW supporting RDMA.
> > >
> > > This driver replaces the legacy X722 driver i40iw and extends the ABI
> > > already defined for i40iw. It is backward compatible with legacy X722
> > > rdma-core provider (libi40iw).
> > >
> > > This series was built against the rdma for-next branch.  This series
> > > is dependant upon the v4 100GbE Intel Wired LAN Driver Updates
> > > 2020-05-19
> > > 12 patch series, which adds virtual_bus interface and ice/i40e LAN
> > > driver changes.
> > >
> > > v5-->v6:
> > > *Convert irdma destroy QP to a synchronous API *Drop HMC obj macros
> > > for use counts like IRDMA_INC_SD_REFCNT et al.
> > > *cleanup unneccesary 'mem' variable in irdma_create_qp *cleanup unused
> > > headers such as linux/moduleparam.h et. al *set kernel_ver in
> > > irdma_ualloc_resp struct to current ABI ver. Placeholder to  support
> > > user-space compatbility checks in future *GENMASK/FIELD_PREP scheme to
> > > set WQE descriptor fields considered for irdma  driver but decision to
> > > drop. The FIELD_PREP macro cannot be used on the device  bitfield mask
> > > array maintained for common WQE descriptors and initialized  based on
> > > HW generation. The macro expects compile time constants only.
> >
> > The request was to use GENMASK for the #define constants. If you move to a
> > code environment then the spot the constant appears in the C code should be
> > FIELD_PREP'd into the something dynamic code can use.
> >
>
> Maybe I am missing something here, but from what I understood,
> the vantage point of using GENMASK for the masks
> was so that we could get rid of open coding the shift constants and use the
> FIELD_PREP macro to place the value in the field of a descriptor.
> This should work for the static masks. So something like --
>
> -#define IRDMA_UDA_QPSQ_INLINEDATALEN_S 48
> -#define IRDMA_UDA_QPSQ_INLINEDATALEN_M \
> -       ((u64)0xff << IRDMA_UDA_QPSQ_INLINEDATALEN_S)
> +#define IRDMA_UDA_QPSQ_INLINEDATALEN_M GENMASK_ULL(55, 48)
>
> -#define LS_64(val, field)      (((u64)(val) << field ## _S) & (field ## _M))
> +#define LS_64(val, field)      (FIELD_PREP(val,(field ## _M)))
                                                         ^^^^ it is not needed anymore
>
> However we have device's dynamically computed bitfield mask array and shifts
> for some WQE descriptor fields --
> see icrdma_init_hw.c
> https://lore.kernel.org/linux-rdma/20200520070415.3392210-3-jeffrey.t.kirsher@intel.com/#Z30drivers:infiniband:hw:irdma:icrdma_hw.c

I'm looking on it and see static assignments, to by dynamic you will need
"to play" with hw_shifts/hw_masks later, but you don't. What am I missing?

+	for (i = 0; i < IRDMA_MAX_SHIFTS; ++i)
+		dev->hw_shifts[i] = i40iw_shifts[i];
+
+	for (i = 0; i < IRDMA_MAX_MASKS; ++i)
+		dev->hw_masks[i] = i40iw_masks[i];

>
> we still need to use the custom macro FLD_LS_64 without FIELD_PREP in this case
> as FIELD_PREP expects compile time constants.
> +#define FLD_LS_64(dev, val, field)	\
> +	(((u64)(val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field
> +## _M])
> And the shifts are still required for these fields which causes a bit of
> inconsistency
>
>
>
