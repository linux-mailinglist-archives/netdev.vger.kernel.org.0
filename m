Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879373E58AB
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 12:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239957AbhHJK4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 06:56:35 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:44796 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbhHJK4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 06:56:34 -0400
Received: by mail-wm1-f52.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so2213359wmd.3;
        Tue, 10 Aug 2021 03:56:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M8c678fNnsGLoOeW7UexhiEvWyA8c3/gcsG+wSE2ct8=;
        b=YCI+qtGD/0L1xixPkuKTCC9Y8GQEW84XhzIUrfCXbiM5lACxef/iVs8OaZUE8vlfWz
         wb9Q27CJyNtk7GkL9WoCerNfoPpW1jXOkHFFUwggNVxvFMs/0WbeccPAEZshTMpnsHK8
         2XXUvydEAATjFYZtx4hXnUeKXMHyR7AMBnViRjwy5UVEJiVODi4evvd4u5W7c4ngbSNr
         6SbbZobe51y/833k1QCUM8izOTg6PPK04cOTm5CwqkQ4Aa4CB3LIEGOLEJNTGGWiukx4
         HJP+JSHQhsZUxxooZK5jUmoub4YR/rJz4jS5zC84guG0sxcTIqR7+ySXAzsDYBiEckYY
         +KAA==
X-Gm-Message-State: AOAM532uc1vxVQawPdccOCemU10J7dvdUsgvNr4g+KFPB+vUNigtNZ6k
        Njjo1fGMRMwwzASB+USy4NA=
X-Google-Smtp-Source: ABdhPJz2yF8WcgnnZUSV/YZcts24nqVnzunX66Xx60m+tHd6RHQnGzum63lk7AYwHZ32aACM7/ys3w==
X-Received: by 2002:a1c:7dd0:: with SMTP id y199mr2862006wmc.23.1628592971259;
        Tue, 10 Aug 2021 03:56:11 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id x18sm20028730wmc.17.2021.08.10.03.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 03:56:10 -0700 (PDT)
Date:   Tue, 10 Aug 2021 10:56:09 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V3 01/13] x86/HV: Initialize GHCB page in Isolation VM
Message-ID: <20210810105609.soi67eg2us5w7yuq@liuwe-devbox-debian-v2>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-2-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809175620.720923-2-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 01:56:05PM -0400, Tianyu Lan wrote:
[...]
>  static int hv_cpu_init(unsigned int cpu)
>  {
>  	union hv_vp_assist_msr_contents msr = { 0 };
> @@ -85,6 +111,8 @@ static int hv_cpu_init(unsigned int cpu)
>  		}
>  	}
>  
> +	hyperv_init_ghcb();
> +

Why is the return value not checked here? If that's not required, can
you leave a comment?

Wei.
