Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC8C43A525
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhJYU62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:58:28 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:51873 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbhJYU6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:58:25 -0400
Received: by mail-wm1-f47.google.com with SMTP id 5so2192525wmb.1;
        Mon, 25 Oct 2021 13:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q+yfKmb+onnS482Y6u9v2lkAP9a5r5WCNti0ot9YfMg=;
        b=xUQTw3gvr5nrkxlziOUeMn9HfUMvaQL0F4JcaLJAgjzeVs0W0mOa0m7PSt93PQb83q
         gRiekuo5cNPMtA6qRKzD1WipURbGmCZUKl2LAN5Egzp/k/bf3/wWkx/5s0qDb7sYEZG9
         ifVYrat4wIIRGHCtTqy84F+tUcTKAl6eCVzyzmEJtirXi69lIo1HprJGxT0uRTqBWkS3
         rxWj6ncPlD01FoBsXjFVSxWV1r5pxZyyxgwG2tabXdb+H7k9ss1P63Hyt3kmHRz6XtCT
         NwDiobnFeTqNs1a2vYoLc9hY3gTbRXNBaLNmwhME66ZYPFnecdyXw/O2zbebEbUxWaJ8
         /9qw==
X-Gm-Message-State: AOAM530OSOJXyIEJboGJlhBYLnyQnkW4VLRm2bsNqe84GUVtWOvDE25X
        yzqKuzYEBMdq8g3LHU8F1n4=
X-Google-Smtp-Source: ABdhPJy41VdkQyppTBh4meZBX/lXaHxLgbKOGQTqOHHeONNOEpR5bufaWYH/gDxFiXuknpfmkXcMPg==
X-Received: by 2002:a05:600c:3546:: with SMTP id i6mr51776416wmq.146.1635195361619;
        Mon, 25 Oct 2021 13:56:01 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id m15sm17916917wmq.0.2021.10.25.13.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 13:56:00 -0700 (PDT)
Date:   Mon, 25 Oct 2021 20:55:59 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, tj@kernel.org,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com,
        sfr@canb.auug.org.au, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH V9 0/9] x86/Hyper-V: Add Hyper-V Isolation VM
 support(First part)
Message-ID: <20211025205559.5wge6ohiktif5hwt@liuwe-devbox-debian-v2>
References: <20211025122116.264793-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025122116.264793-1-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 08:21:05AM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Hyper-V provides two kinds of Isolation VMs. VBS(Virtualization-based
> security) and AMD SEV-SNP unenlightened Isolation VMs. This patchset
> is to add support for these Isolation VM support in Linux.
> 
> The memory of these vms are encrypted and host can't access guest
> memory directly. Hyper-V provides new host visibility hvcall and
> the guest needs to call new hvcall to mark memory visible to host
> before sharing memory with host. For security, all network/storage
> stack memory should not be shared with host and so there is bounce
> buffer requests.
> 
> Vmbus channel ring buffer already plays bounce buffer role because
> all data from/to host needs to copy from/to between the ring buffer
> and IO stack memory. So mark vmbus channel ring buffer visible.
> 
> For SNP isolation VM, guest needs to access the shared memory via
> extra address space which is specified by Hyper-V CPUID HYPERV_CPUID_
> ISOLATION_CONFIG. The access physical address of the shared memory
> should be bounce buffer memory GPA plus with shared_gpa_boundary
> reported by CPUID.
> 
> This patchset is rebased on the commit d9abdee of Linux mainline tree
> and plus clean up patch from Borislav Petkov(https://lore.kernel.org/r/
> YWRwxImd9Qcls/Yy@zn.tnic)
> 
> 

Applied to hyperv-next. Thanks.

Wei.
