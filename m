Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B707C3BF663
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhGHHmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:42:51 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:11526 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhGHHmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 03:42:49 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2021 03:42:48 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1625729648;
    s=strato-dkim-0002; d=aepfle.de;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=Ie8bhNxcgTEIyaHnXue+qUsCeFcFU7OWzE+Hs21wg9g=;
    b=nKxlYYk9ExTxZ9BuI9EhfpAje6vEfx0GVmBer00VZb2GlgTta4a3e6mEReme+AVLKJ
    x1g28GBLyGoFvM6gaG5z7b+cV6ZJFLoem/obwXB9+z0+SoPV6pwNVVIIk3/UOPHsneyg
    GWLwYXUqnjer9VpKH4m9Cx5Kv703S9RZFcbTVNL6kEIMVP91SRDKJaQgZM42hrAkVc4e
    lmSSydRxnY+lu4pZdDi8VibLUhPOJminze/kIh5/0FPTHkurK2p5a/EfuKxM/KIN1xWG
    WfgjyRn1yLU1J5t4Nvhf0XjMie6PdfNUCxeSR2W7CoeJ26/3wkjbXCgr0r3rPyjQAbxh
    dA9w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2EQZWCpfu+qG7CngxMFH1J+3q8wa/QDiZbDmui9LcK/RdXt7GAQpV1nK0bLlEYINdoY/p1XzQbc+3kk9TsJTnzSvdM+YSIzPms="
X-RZG-CLASS-ID: mo00
Received: from aepfle.de
    by smtp.strato.de (RZmta 47.28.1 AUTH)
    with ESMTPSA id 30791cx687Y4Yio
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 8 Jul 2021 09:34:04 +0200 (CEST)
Date:   Thu, 8 Jul 2021 09:34:00 +0200
From:   Olaf Hering <olaf@aepfle.de>
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
        rppt@kernel.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, ardb@kernel.org,
        nramas@linux.microsoft.com, robh@kernel.org, keescook@chromium.org,
        rientjes@google.com, pgonda@google.com, martin.b.radev@gmail.com,
        hannes@cmpxchg.org, saravanand@fb.com, krish.sadhukhan@oracle.com,
        xen-devel@lists.xenproject.org, tj@kernel.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        anparri@microsoft.com
Subject: Re: [RFC PATCH V4 01/12] x86/HV: Initialize shared memory boundary
 in the Isolation VM.
Message-ID: <20210708073400.GA28528@aepfle.de>
References: <20210707153456.3976348-1-ltykernel@gmail.com>
 <20210707153456.3976348-2-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210707153456.3976348-2-ltykernel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, Tianyu Lan wrote:

> +++ b/include/asm-generic/mshyperv.h
> @@ -34,8 +34,18 @@ struct ms_hyperv_info {

>  	void  __percpu **ghcb_base;

It would be cool if the cover letter states which commit id this series is based on.

Thanks,
Olaf
