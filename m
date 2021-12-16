Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5BB476F75
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbhLPLFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:05:07 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:33494 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbhLPLFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 06:05:05 -0500
Received: by mail-wm1-f44.google.com with SMTP id n14-20020a7bcbce000000b00332f4abf43fso1216100wmi.0;
        Thu, 16 Dec 2021 03:05:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ia0s2pfedLLV2rKQx/9pdjpwFu99hZ9OuUlgB2e9yo0=;
        b=QD1MWjI3cV8s6jVSqVs1as2VGFrfr3uQ7QEgUzny9ZeFl4huygcaWzECHILPpjtjfm
         gxQWHj3z36xZww5UHis+C3N+KxS36IJomsIXHvS4reElrCWAldyt8204oTMmCkMwI1LT
         6+0kGo7wdt5ItXqqrffpNvPm+UYwLBgB5O5mXJ3narZC/tdS32J6HWCt1vxjiFkZBMsQ
         AK/408VXXwe8bXjRYEs82t4JTHa9QMSuxh+0TQCyLd1VwJ+7rfSSlXuRX6zpo6lt19nD
         hBUyDgoqdJ3B9BQp4xu1nbINouljoa0TBhQvRALqHk+4M1iYWFTPFjjDQR7YpiQ6celB
         /rQw==
X-Gm-Message-State: AOAM532HZfn/CSh8UtHKdvTJkLDC8SAtcYPfqHYi8UWdzXepYwptICzV
        Jcp1NqjCVZXTfnJdZTKITu0=
X-Google-Smtp-Source: ABdhPJz9k2azLHdE9YVUF2mYlnC5nG4eLgboSYl5jYHIGX/6zclpudEz7h2L6IJ5hM2Wce25bH6xTw==
X-Received: by 2002:a05:600c:296:: with SMTP id 22mr4493492wmk.11.1639652703518;
        Thu, 16 Dec 2021 03:05:03 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id w15sm4376365wrk.77.2021.12.16.03.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 03:05:02 -0800 (PST)
Date:   Thu, 16 Dec 2021 11:05:01 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com
Subject: Re: [PATCH V7 1/5] swiotlb: Add swiotlb bounce buffer remap function
 for HV IVM
Message-ID: <20211216110501.y2i7adl3ilkrodaq@liuwe-devbox-debian-v2>
References: <20211213071407.314309-1-ltykernel@gmail.com>
 <20211213071407.314309-2-ltykernel@gmail.com>
 <198e9243-abca-b23e-0e8e-8581a7329ede@intel.com>
 <3243ff22-f6c8-b7cd-26b7-6e917e274a7c@gmail.com>
 <c25ff1e8-4d1e-cf1c-a9f6-c189307f92fd@intel.com>
 <a1c8f26f-fbf2-29b6-e734-e6d6151c39f8@amd.com>
 <7afc23c3-22e7-9bbf-7770-c683bf84a7cc@intel.com>
 <fb2ff8b7-ab8c-7c4b-0850-222cd2cf7c4a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb2ff8b7-ab8c-7c4b-0850-222cd2cf7c4a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 01:00:38PM +0800, Tianyu Lan wrote:
> 
> 
> On 12/15/2021 6:40 AM, Dave Hansen wrote:
> > On 12/14/21 2:23 PM, Tom Lendacky wrote:
> > > > I don't really understand how this can be more general any *not* get
> > > > utilized by the existing SEV support.
> > > 
> > > The Virtual Top-of-Memory (VTOM) support is an SEV-SNP feature that is
> > > meant to be used with a (relatively) un-enlightened guest. The idea is
> > > that the C-bit in the guest page tables must be 0 for all accesses. It
> > > is only the physical address relative to VTOM that determines if the
> > > access is encrypted or not. So setting sme_me_mask will actually cause
> > > issues when running with this feature. Since all DMA for an SEV-SNP
> > > guest must still be to shared (unencrypted) memory, some enlightenment
> > > is needed. In this case, memory mapped above VTOM will provide that via
> > > the SWIOTLB update. For SEV-SNP guests running with VTOM, they are
> > > likely to also be running with the Reflect #VC feature, allowing a
> > > "paravisor" to handle any #VCs generated by the guest.
> > > 
> > > See sections 15.36.8 "Virtual Top-of-Memory" and 15.36.9 "Reflect #VC"
> > > in volume 2 of the AMD APM [1].
> > 
> > Thanks, Tom, that's pretty much what I was looking for.
> > 
> > The C-bit normally comes from the page tables.  But, the hardware also
> > provides an alternative way to effectively get C-bit behavior without
> > actually setting the bit in the page tables: Virtual Top-of-Memory
> > (VTOM).  Right?
> > 
> > It sounds like Hyper-V has chosen to use VTOM instead of requiring the
> > guest to do the C-bit in its page tables.
> > 
> > But, the thing that confuses me is when you said: "it (VTOM) is meant to
> > be used with a (relatively) un-enlightened guest".  We don't have an
> > unenlightened guest here.  We have Linux, which is quite enlightened.
> > 
> > > Is VTOM being used because there's something that completely rules out
> > > using the C-bit in the page tables?  What's that "something"?
> 
> 
> For "un-enlightened" guest, there is an another system running insider
> the VM to emulate some functions(tsc, timer, interrupt and so on) and
> this helps not to modify OS(Linux/Windows) a lot. In Hyper-V Isolation
> VM, we called the new system as HCL/paravisor. HCL runs in the VMPL0 and
> Linux runs in VMPL2. This is similar with nested virtualization. HCL
> plays similar role as L1 hypervisor to emulate some general functions
> (e.g, rdmsr/wrmsr accessing and interrupt injection) which needs to be
> enlightened in the enlightened guest. Linux kernel needs to handle
> #vc/#ve exception directly in the enlightened guest. HCL handles such
> exception in un-enlightened guest and emulate interrupt injection which
> helps not to modify OS core part code. Using vTOM also is same purpose.
> Hyper-V uses vTOM avoid changing page table related code in OS(include
> Windows and Linux)and just needs to map memory into decrypted address
> space above vTOM in the driver code.
> 
> Linux has generic swiotlb bounce buffer implementation and so introduce
> swiotlb_unencrypted_base here to set shared memory boundary or vTOM.
> Hyper-V Isolation VM is un-enlightened guest. Hyper-V doesn't expose sev/sme
> capability to guest and so SEV code actually doesn't work.
> So we also can't interact current existing SEV code and these code is
> for enlightened guest support without HCL/paravisor. If other platforms
> or SEV want to use similar vTOM feature, swiotlb_unencrypted_base can
> be reused. So swiotlb_unencrypted_base is a general solution for all
> platforms besides SEV and Hyper-V.
> 

Thanks for the detailed explanation.

Dave, are you happy with this?

The code looks pretty solid to my untrained eyes. And the series has
collected necessary acks from stakeholders. If I don't hear objection by
EOD Friday I will apply this series to hyperv-next.

Wei.
