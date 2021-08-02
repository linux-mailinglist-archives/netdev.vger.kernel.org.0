Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B643DD5DC
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhHBMkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:40:10 -0400
Received: from 8bytes.org ([81.169.241.247]:52914 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233605AbhHBMkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 08:40:09 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 32B79379; Mon,  2 Aug 2021 14:39:56 +0200 (CEST)
Date:   Mon, 2 Aug 2021 14:39:48 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, anparri@microsoft.com
Subject: Re: [PATCH 06/13] HV: Add ghcb hvcall support for SNP VM
Message-ID: <YQfnlBwyZUJyixQX@8bytes.org>
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-7-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728145232.285861-7-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 10:52:21AM -0400, Tianyu Lan wrote:
> +	hv_ghcb->ghcb.protocol_version = 1;
> +	hv_ghcb->ghcb.ghcb_usage = 1;

The values set to ghcb_usage deserve some defines (here and below).

> +
> +	hv_ghcb->hypercall.outputgpa = (u64)output;
> +	hv_ghcb->hypercall.hypercallinput.asuint64 = 0;
> +	hv_ghcb->hypercall.hypercallinput.callcode = control;
> +
> +	if (input_size)
> +		memcpy(hv_ghcb->hypercall.hypercalldata, input, input_size);
> +
> +	VMGEXIT();
> +
> +	hv_ghcb->ghcb.ghcb_usage = 0xffffffff;

...

>  union hv_ghcb {
>  	struct ghcb ghcb;
> +	struct {
> +		u64 hypercalldata[509];
> +		u64 outputgpa;
> +		union {
> +			union {
> +				struct {
> +					u32 callcode        : 16;
> +					u32 isfast          : 1;
> +					u32 reserved1       : 14;
> +					u32 isnested        : 1;
> +					u32 countofelements : 12;
> +					u32 reserved2       : 4;
> +					u32 repstartindex   : 12;
> +					u32 reserved3       : 4;
> +				};
> +				u64 asuint64;
> +			} hypercallinput;
> +			union {
> +				struct {
> +					u16 callstatus;
> +					u16 reserved1;
> +					u32 elementsprocessed : 12;
> +					u32 reserved2         : 20;
> +				};
> +				u64 asunit64;
> +			} hypercalloutput;
> +		};
> +		u64 reserved2;
> +	} hypercall;

Okay, this answers my previous question :)

