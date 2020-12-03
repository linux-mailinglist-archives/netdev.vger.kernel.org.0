Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943482CD093
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 08:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgLCHrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 02:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729389AbgLCHrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 02:47:46 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BB4C061A4D;
        Wed,  2 Dec 2020 23:47:06 -0800 (PST)
Received: from zn.tnic (p200300ec2f0dc500db287c99eb312af4.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:c500:db28:7c99:eb31:2af4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BDDD61EC04DD;
        Thu,  3 Dec 2020 08:47:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1606981624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=GedApLaNstVc3e1C3spK8dfnCKnZJiZf08fLRjtMt2A=;
        b=Fd2gqakHIUkjMZIpv84iCARF7D6l2nvr1+N7K02vNH9XhX6+OH4BTfHRmIN4GPL5GuZ5VE
        owPiDdfM5QEJL4SuOBYLcv1eoqlCNLRkloYOzifN1dXLYIe3PomA2GCKgtSUCGDl4Z9yog
        NoQT7vEwbjDu8q7G31I+62fLnJWJutc=
Date:   Thu, 3 Dec 2020 08:46:59 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dmitry.torokhov@gmail.com,
        derek.kiernan@xilinx.com, dragan.cvetic@xilinx.com,
        richardcochran@gmail.com, linux-hyperv@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86: make VMware support optional
Message-ID: <20201203074631.GC3059@zn.tnic>
References: <20201202211949.17730-1-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201202211949.17730-1-info@metux.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 10:19:48PM +0100, Enrico Weigelt, metux IT consult wrote:
> Make it possible to opt-out from VMware support, for minimized kernels
> that never will be run under Vmware (eg. high-density virtualization
> or embedded systems).
> 
> Average distro kernel will leave it on, therefore default to y.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>
> ---
>  arch/x86/Kconfig                 | 11 +++++++++++
>  arch/x86/kernel/cpu/Makefile     |  4 +++-
>  arch/x86/kernel/cpu/hypervisor.c |  2 ++
>  drivers/input/mouse/Kconfig      |  2 +-
>  drivers/misc/Kconfig             |  2 +-
>  drivers/ptp/Kconfig              |  2 +-
>  6 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f6946b81f74a..eff12460cb3c 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -801,6 +801,17 @@ config X86_HV_CALLBACK_VECTOR
>  
>  source "arch/x86/xen/Kconfig"
>  
> +config VMWARE_GUEST
> +	bool "VMware Guest support"
> +	default y
> +	help
> +	  This option enables several optimizations for running under the
> +	  VMware hypervisor.
> +
> +	  Disabling it saves a few kb, for stripped down kernels eg. in high

I was actually expecting for you to do your own measurements and show data.
Anyway, I did it for you:

   text    data     bss     dec     hex filename
15949304        127806978       36597916        180354198       abffc96 vmlinux.before
15947650        127802430       36602012        180352092       abff45c vmlinux.after

this is with my .config.

How much is it with a stripped down kernel? I bet it is even less. Which
makes this whole effort not worth it...

Also, when you send a new version of your patches, please rework *all*
review feedback you've received on the previous one.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
