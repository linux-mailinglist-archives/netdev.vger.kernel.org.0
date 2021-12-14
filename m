Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB51B47467F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 16:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhLNPdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 10:33:08 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:45909 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhLNPdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 10:33:07 -0500
Received: by mail-wm1-f49.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so14003662wme.4;
        Tue, 14 Dec 2021 07:33:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gGTASyVvn36rhQtSc7TEVERHcrRg+7y0+ImLAER1pZU=;
        b=52gmw2Lrs8NtuXs8v4/Faw/tv4kDP/WfvXe6yi5/oiyLhxp6ryPD4O67AP259oZt6N
         4eydRsNXzxUzz2uYrf8ozt81iKbofH4tze4gv7XoZ/j+Qu2VSsXDPLww6CxMrxL+cly3
         /txE49yu1qx6mFvKMfdmV0jpM+9Kv9Chnna/8i6XUWwJq/LI9M3BU0tDqv5Ha8T3/v/0
         vWL6wzMW+dXolqCFOzWDwTyiXZFLbylES2ZVr4cN1sswvp+qzZvPphAIDAQBmn43KNkr
         99jUmVmqeevcmUi41Nvlfg5xKyrNioEl9+uLrg+oXTbTbAZ2i9ewPAhLG3H9K2jqZgH+
         GtzQ==
X-Gm-Message-State: AOAM530Qm4azQK0p77qbimETDy6iVj18kTwuXiYvAEe8PMrNGYQfhAPq
        sKxe0Sr8FrNIImtGap7rDTY=
X-Google-Smtp-Source: ABdhPJxHhur3wQN8WmEyNxA+W1/sE24M3nO1TWjo2rJ0GnYL+t3NixDhtMD6glLsTC6egs0Kn3Dhjw==
X-Received: by 2002:a7b:c1cb:: with SMTP id a11mr8027105wmj.30.1639495985661;
        Tue, 14 Dec 2021 07:33:05 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id a198sm118170wmd.42.2021.12.14.07.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 07:33:05 -0800 (PST)
Date:   Tue, 14 Dec 2021 15:33:03 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH V7 2/5] x86/hyper-v: Add hyperv Isolation VM check in the
 cc_platform_has()
Message-ID: <20211214153303.qmhowu4lfpcp4gej@liuwe-devbox-debian-v2>
References: <20211213071407.314309-1-ltykernel@gmail.com>
 <20211213071407.314309-3-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213071407.314309-3-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 02:14:03AM -0500, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Hyper-V provides Isolation VM for confidential computing support and
> guest memory is encrypted in it. Places checking cc_platform_has()
> with GUEST_MEM_ENCRYPT attr should return "True" in Isolation vm. e.g,
> swiotlb bounce buffer size needs to adjust according to memory size
> in the sev_setup_arch(). Add GUEST_MEM_ENCRYPT check for Hyper-V Isolation
> VM.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>

x86 maintainers, any comment on this patch?

> ---
> Change since v6:
> 	* Change the order in the cc_platform_has() and check sev first.
> 
> Change since v3:
> 	* Change code style of checking GUEST_MEM attribute in the
> 	  hyperv_cc_platform_has().
> ---
>  arch/x86/kernel/cc_platform.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kernel/cc_platform.c b/arch/x86/kernel/cc_platform.c
> index 03bb2f343ddb..6cb3a675e686 100644
> --- a/arch/x86/kernel/cc_platform.c
> +++ b/arch/x86/kernel/cc_platform.c
> @@ -11,6 +11,7 @@
>  #include <linux/cc_platform.h>
>  #include <linux/mem_encrypt.h>
>  
> +#include <asm/mshyperv.h>
>  #include <asm/processor.h>
>  
>  static bool __maybe_unused intel_cc_platform_has(enum cc_attr attr)
> @@ -58,12 +59,19 @@ static bool amd_cc_platform_has(enum cc_attr attr)
>  #endif
>  }
>  
> +static bool hyperv_cc_platform_has(enum cc_attr attr)
> +{
> +	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
> +}
>  
>  bool cc_platform_has(enum cc_attr attr)
>  {
>  	if (sme_me_mask)
>  		return amd_cc_platform_has(attr);
>  
> +	if (hv_is_isolation_supported())
> +		return hyperv_cc_platform_has(attr);
> +
>  	return false;
>  }
>  EXPORT_SYMBOL_GPL(cc_platform_has);
> -- 
> 2.25.1
> 
