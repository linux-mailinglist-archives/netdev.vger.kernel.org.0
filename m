Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48081434C41
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhJTNl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhJTNl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 09:41:57 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75FFC06161C;
        Wed, 20 Oct 2021 06:39:42 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0db30070b4efa7ef8aef1e.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:b300:70b4:efa7:ef8a:ef1e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7316B1EC0570;
        Wed, 20 Oct 2021 15:39:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634737180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=u6CGs01obc8jKPitQtYRdGE87x9sved8yOI/KYoYUvM=;
        b=JOKjVeuLwqZCuvZ6qwDs2kFiAENVgsfWrC1duhZjVCLqxPZEjspIKzy2GG5wfa9FghK6FD
        6BUAIx7wFBudqOs3rEenI/nv4Kfz3muGrf+OpOpJ0AAImqmKIH4NDzPQ/GxHnWgAHMLVXD
        XyFXHXj5LiYFLCSO/Hl2eW5mrHiQ/d4=
Date:   Wed, 20 Oct 2021 15:39:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        jroedel@suse.de, brijesh.singh@amd.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, tj@kernel.org,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com, hannes@cmpxchg.org,
        rientjes@google.com, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb
 hv call out of sev code
Message-ID: <YXAcGtxe08XiHBFH@zn.tnic>
References: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
 <20211020062321.3581158-1-ltykernel@gmail.com>
 <YW/oaZ2GN15hQdyd@zn.tnic>
 <c5b55d93-14c4-81cf-e999-71ad5d6a1b41@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c5b55d93-14c4-81cf-e999-71ad5d6a1b41@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 08:39:59PM +0800, Tianyu Lan wrote:
> Hyper-V runs paravisor in guest VMPL0 which emulates some functions
> (e.g, timer, tsc, serial console and so on) via handling VC exception.
> GHCB pages are allocated and set up by the paravisor and report to Linux
> guest via MSR register.Hyper-V SEV implementation is unenlightened guest
> case which doesn't Linux doesn't handle VC and paravisor in the VMPL0
> handle it.

Aha, unenlightened.

So why don't you export the original function by doing this (only
partial diff to show intent only):

---
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index f1d513897baf..bfe82f58508f 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -125,7 +125,7 @@ static enum es_result verify_exception_info(struct ghcb *ghcb, struct es_em_ctxt
 	return ES_VMM_ERROR;
 }
 
-static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb, bool set_ghcb_msr,
 					  struct es_em_ctxt *ctxt,
 					  u64 exit_code, u64 exit_info_1,
 					  u64 exit_info_2)
@@ -138,7 +138,14 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
 	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
 
-	sev_es_wr_ghcb_msr(__pa(ghcb));
+	/*
+	 * Hyper-V unenlightened guests use a paravisor for communicating and
+	 * GHCB pages are being allocated by that paravisor which uses a
+	 * different MSR and protocol.
+	 */
+	if (set_ghcb_msr)
+		sev_es_wr_ghcb_msr(__pa(ghcb));
+
 	VMGEXIT();
 
 	return verify_exception_info(ghcb, ctxt);


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
