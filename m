Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A3A47472D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 17:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhLNQKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 11:10:09 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43006 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbhLNQKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 11:10:08 -0500
Received: by mail-wr1-f51.google.com with SMTP id c4so33200068wrd.9;
        Tue, 14 Dec 2021 08:10:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZHPbCWI6bYGyjK8mmI0D3KyfsrOlvTBd5Vd+F5/Vwkw=;
        b=GVdnAkdGmrpQ/TDUYhNXccYo3u5fEwyCAJ51PVTyCJw6L2I5qjgfKFwL247pJDPB7G
         cJkp6f3BCpJVP9kcsXylsd7h37n26VdtqGo0Hx35Tpze9WuO/C/gCJH/YvnL8F7XX91b
         tPJTDkXh5I2cdX8s86GBKZCHvBO6fSOJBEYIOouXuZZXz1VoLMLWKix6khcVDJDljB3B
         fE+wzEPF8qS1sIkRjs0zpeOloB8j2xhJjk4NUInphZK3SUb+1ba02ptbFrSHSVLMRSBa
         0BPOJW5xlMSSnvcvxhvo9MFejxI9vvcu8qyrWWsGFgUqJySrlBOtkoP20yWBwwIv4Wz8
         QKtw==
X-Gm-Message-State: AOAM533HBFrhwYZgV3g+BXJnvn1FoDEE+PB9L0U+Hm8qIQ7fux23qUcU
        5hQux9fJBMgq6mN/s6hy9R8=
X-Google-Smtp-Source: ABdhPJzA+fSss7tQ8CtjfcSBZIFl347bWFgxFbLG30HYf3L29Y8+Tw56U4i6sm2K19aVkEk2EE2ZJw==
X-Received: by 2002:a5d:6a8f:: with SMTP id s15mr6869384wru.544.1639498206781;
        Tue, 14 Dec 2021 08:10:06 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id u10sm363011wrs.99.2021.12.14.08.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 08:10:06 -0800 (PST)
Date:   Tue, 14 Dec 2021 16:10:04 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, hch@lst.de, joro@8bytes.org,
        parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V7 2/5] x86/hyper-v: Add hyperv Isolation VM check in the
 cc_platform_has()
Message-ID: <20211214161004.6ofxl5ko43myn76o@liuwe-devbox-debian-v2>
References: <20211213071407.314309-1-ltykernel@gmail.com>
 <20211213071407.314309-3-ltykernel@gmail.com>
 <YbjArUL+biZMsFOL@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbjArUL+biZMsFOL@zn.tnic>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 05:05:01PM +0100, Borislav Petkov wrote:
> On Mon, Dec 13, 2021 at 02:14:03AM -0500, Tianyu Lan wrote:
> > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > 
> > Hyper-V provides Isolation VM for confidential computing support and
> > guest memory is encrypted in it. Places checking cc_platform_has()
> > with GUEST_MEM_ENCRYPT attr should return "True" in Isolation vm. e.g,
> 
> Stick to a single spelling variant: "VM".
> 
> > swiotlb bounce buffer size needs to adjust according to memory size
> > in the sev_setup_arch().
> 
> So basically you wanna simply say here:
> 
> "Hyper-V Isolation VMs need to adjust the SWIOTLB size just like SEV
> guests. Add a hyperv_cc_platform_has() variant which enables that."
> 
> ?
> 
> With that addressed you can have my
> 
> Acked-by: Borislav Petkov <bp@suse.de>

Thanks. I can address your comments when I pick up this series.

Wei.

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
