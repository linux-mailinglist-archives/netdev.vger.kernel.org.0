Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CB9439BB5
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbhJYQkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbhJYQkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:40:11 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9F0C061745;
        Mon, 25 Oct 2021 09:37:46 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0f4e00d98b5d26705b4d72.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:4e00:d98b:5d26:705b:4d72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C44141EC059F;
        Mon, 25 Oct 2021 18:37:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1635179864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=MJuJcHvxEylws1A/g+jonB8G00Egqb6ciiDm4/cW1YE=;
        b=V2guSgAo5hTXqtSlwxmzaS+p4E2+a623ae+2MLfciZNSWHNuvSBHE8RICDzewGi5XdKCDp
        bKiDVch/2eKTxLdVEkCZYz6NWxdiOtNHTqyjbo7QWEJxHpqduLqiJMDddbAo9sXh8vOgz9
        QIf78Jogc01/jA0DCmUXx+wDm/9236A=
Date:   Mon, 25 Oct 2021 18:37:43 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Wei Liu <wei.liu@kernel.org>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        brijesh.singh@amd.com, jroedel@suse.de, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, rientjes@google.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, saravanand@fb.com, aneesh.kumar@linux.ibm.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH V8 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
Message-ID: <YXbdV8N51hMMsP6X@zn.tnic>
References: <20211021154110.3734294-1-ltykernel@gmail.com>
 <20211021154110.3734294-6-ltykernel@gmail.com>
 <YXGTwppQ8syUyJ72@zn.tnic>
 <00946764-7fe0-675f-7b3e-9fb3b8e3eb89@gmail.com>
 <20211025112033.eqelx54p2dmlhykw@liuwe-devbox-debian-v2>
 <YXaT5HcLoX59jZH2@zn.tnic>
 <f5b6f9e8-5888-bd5f-143f-a7b12ec17bbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5b6f9e8-5888-bd5f-143f-a7b12ec17bbb@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 08:27:39PM +0800, Tianyu Lan wrote:
>       I just sent out v9 version and compile hv ghcb related functions
> when CONFIG_AMD_MEM_ENCRYPT is selected. The sev_es_ghcb_hv_call()
> stub is not necessary in the series and remove it. Please have a look
> and give your ack if it's ok. Then Wei can merge it through Hyper-V
> next branch.

I have merged it after running a bunch of randbuild tests and had to fix
one or two:

https://git.kernel.org/tip/007faec014cb5d26983c1f86fd08c6539b41392e

From my POV that branch is not going to change anymore so Wei can now
merge this tip branch - tip:x86/sev - and write a proper merge commit
message explaining why he's merging a tip branch and then apply the rest
of the HyperV stuff ontop.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
