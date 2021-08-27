Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631AC3F9E22
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbhH0RmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhH0RmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 13:42:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AF44600D4;
        Fri, 27 Aug 2021 17:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630086073;
        bh=DgYmO5lLiHXNPE+bTt0kpJLEduGmJ62HuY9b2S4IhUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v5CFy4Y53ir/ekEqVrb37yJbS7N+GnhiX8a5ZHkAkLqCFMO+1hlQLEMIYoOQg78lQ
         BE0uo/vHpfBxnyaR1kBG5sGR4fAWwgEKlv5Kw30ypy6hcugZI89kTJRWxmKPE0vFHA
         aVk8PgyzjF1S9xogR6CSjmPtpDC0A1llmdWuC6mA=
Date:   Fri, 27 Aug 2021 19:41:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V4 04/13] hyperv: Mark vmbus ring buffer visible to host
 in Isolation VM
Message-ID: <YSkjsapeNj+2j//o@kroah.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-5-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827172114.414281-5-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 01:21:02PM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Mark vmbus ring buffer visible with set_memory_decrypted() when
> establish gpadl handle.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
>        * Change vmbus_teardown_gpadl() parameter and put gpadl handle,
>        buffer and buffer size in the struct vmbus_gpadl.
> ---
>  drivers/hv/channel.c            | 36 ++++++++++++++++++++++++++++-----
>  drivers/net/hyperv/hyperv_net.h |  1 +
>  drivers/net/hyperv/netvsc.c     | 16 +++++++++++----
>  drivers/uio/uio_hv_generic.c    | 14 +++++++++++--
>  include/linux/hyperv.h          |  8 +++++++-
>  5 files changed, 63 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index f3761c73b074..82650beb3af0 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -17,6 +17,7 @@
>  #include <linux/hyperv.h>
>  #include <linux/uio.h>
>  #include <linux/interrupt.h>
> +#include <linux/set_memory.h>
>  #include <asm/page.h>
>  #include <asm/mshyperv.h>
>  
> @@ -474,6 +475,13 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>  	if (ret)
>  		return ret;
>  
> +	ret = set_memory_decrypted((unsigned long)kbuffer,
> +				   HVPFN_UP(size));
> +	if (ret) {
> +		pr_warn("Failed to set host visibility for new GPADL %d.\n", ret);

dev_warn()?  You have access to a struct device, why not use it?

same for all other instances here.

thanks,

greg k-h
