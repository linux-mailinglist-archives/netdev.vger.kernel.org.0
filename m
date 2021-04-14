Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1744135F820
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350736AbhDNPqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:46:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233199AbhDNPqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:46:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B73761164;
        Wed, 14 Apr 2021 15:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618415154;
        bh=hfUH+l4yceoC3AqTD4Kdw7lyf+fTM5LhOB+L96OLehc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0tjSNZK6avIABrfXwQbVKug5rACXB5oWomA2ezly6jw95g6/7PUCtVF1oFXJ5wVHE
         FcBEykVjCai8T/rSms3YMehK5wMagFIRVK/CLORkifh3WpNOfF3hyOve3c38SON951
         OhI8K1OOAlcNulMnOPPJBC9QO9eAi8eEwbOuV7Q8=
Date:   Wed, 14 Apr 2021 17:45:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [Resend RFC PATCH V2 08/12] UIO/Hyper-V: Not load UIO HV driver
 in the isolation VM.
Message-ID: <YHcOL+HlEoh5jPb8@kroah.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-9-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414144945.3460554-9-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 10:49:41AM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> UIO HV driver should not load in the isolation VM for security reason.
> Return ENOTSUPP in the hv_uio_probe() in the isolation VM.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/uio/uio_hv_generic.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
> index 0330ba99730e..678b021d66f8 100644
> --- a/drivers/uio/uio_hv_generic.c
> +++ b/drivers/uio/uio_hv_generic.c
> @@ -29,6 +29,7 @@
>  #include <linux/hyperv.h>
>  #include <linux/vmalloc.h>
>  #include <linux/slab.h>
> +#include <asm/mshyperv.h>
>  
>  #include "../hv/hyperv_vmbus.h"
>  
> @@ -241,6 +242,10 @@ hv_uio_probe(struct hv_device *dev,
>  	void *ring_buffer;
>  	int ret;
>  
> +	/* UIO driver should not be loaded in the isolation VM.*/
> +	if (hv_is_isolation_supported())
> +		return -ENOTSUPP;
> +		
>  	/* Communicating with host has to be via shared memory not hypercall */
>  	if (!channel->offermsg.monitor_allocated) {
>  		dev_err(&dev->device, "vmbus channel requires hypercall\n");
> -- 
> 2.25.1
> 

Again you send out known-wrong patches?

:(
