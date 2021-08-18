Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6058D3F0794
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbhHRPMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239504AbhHRPMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:12:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91998C06179A
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 08:11:35 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so5413013pje.0
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 08:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BATSV86SaK5afBXIFxzdzZX4j4EhGdui2K0OHBJGQcw=;
        b=nKyY7H15ZclPASn0mrCWStoJsQEVzP5/BmW4V3jtYB1HxVdnZRQQ4l+PtPCRG/dTV6
         xfDqZKumuBc2DNoifQ7E+k+2RHNCKiMDNP3onIJnlrl5OiL/2iza72Z9iX+5k4rKwpSO
         /m3Ffp/F03wd5BcOk1ihua3YxRddIsYpot1qTBRf+xRtenjeQ4qFFoOSIN66Jft6TSfW
         c2t4wMFRzHKGD7LvgQQ/GVhG8mAh1vCDNxP/Inly9yMM79tpqdyKRQdjifrNITzwA6c7
         yGxl1c2NhdVpvxPZ2G3/l6okDceS2O7mIXsDYuviCR6t29nOh+UDrTcg3BH0FRZEUvzE
         zLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BATSV86SaK5afBXIFxzdzZX4j4EhGdui2K0OHBJGQcw=;
        b=BJqBm+2vijTiIhXHLbKWoeevm2+OARSr4G3veCzcVbUOx93d+MAtES+nxUrxPUw0Iy
         /594ds/TXZr0Ii/kcPAswunfsFdt8yOSijsixQOJnuWPAh3tHY4ecu63/NzzN1Uh7Ffn
         8YhHvgjYacuUomiop7StNyfk3Ln+xcwV9XkuVMowZXWqF8vu2pgogwtigV8XiqhVvC/X
         6vTMLPkVLuMumk4Ryg7GAgAyVJdcvL8/C3h/34GBljMeeuLyTEDs1YCb7tqWreok8/0j
         j7MHK+eAfHfMnQoDIj+CaMRmXXGEMm5kQvSzWT1HKTNi6zUJu0BAJI9p3yLdluDuFjph
         s5Qg==
X-Gm-Message-State: AOAM532U62pw6SqNqC5IpfIScTlIFuXZN36U3lfwG0qslGlFbYO1ufK1
        WD6vmLn084K2Yp9TxBn7mW87WQ==
X-Google-Smtp-Source: ABdhPJyb9v3aI2ukGkg+KeS46DSybL7HwTNvsJIGANZduqIYX0SVbX0PrpsQIc/aOBu7eADDQMvgoA==
X-Received: by 2002:a17:90b:1e03:: with SMTP id pg3mr9751970pjb.203.1629299494765;
        Wed, 18 Aug 2021 08:11:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m7sm28291pfc.212.2021.08.18.08.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 08:11:34 -0700 (PDT)
Date:   Wed, 18 Aug 2021 15:11:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 53/63] KVM: x86: Use struct_group() to zero decode
 cache
Message-ID: <YR0jIEzEcUom/7rd@google.com>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-54-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818060533.3569517-54-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021, Kees Cook wrote:
>  arch/x86/kvm/emulate.c     |  3 +--
>  arch/x86/kvm/kvm_emulate.h | 19 +++++++++++--------
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 2837110e66ed..2608a047e769 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5377,8 +5377,7 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop)
>  
>  void init_decode_cache(struct x86_emulate_ctxt *ctxt)
>  {
> -	memset(&ctxt->rip_relative, 0,
> -	       (void *)&ctxt->modrm - (void *)&ctxt->rip_relative);
> +	memset(&ctxt->decode_cache, 0, sizeof(ctxt->decode_cache));
>  
>  	ctxt->io_read.pos = 0;
>  	ctxt->io_read.end = 0;
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 68b420289d7e..9b8afcb8ad39 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -341,14 +341,17 @@ struct x86_emulate_ctxt {
>  	 * the rest are initialized unconditionally in x86_decode_insn
>  	 * or elsewhere
>  	 */
> -	bool rip_relative;
> -	u8 rex_prefix;
> -	u8 lock_prefix;
> -	u8 rep_prefix;
> -	/* bitmaps of registers in _regs[] that can be read */
> -	u32 regs_valid;
> -	/* bitmaps of registers in _regs[] that have been written */
> -	u32 regs_dirty;
> +	struct_group(decode_cache,

This is somewhat misleading because half of this struct is the so called "decode
cache", not just these six fields.

KVM's "optimization" is quite ridiculous as this has never been such a hot path
that saving a few mov instructions would be noticeable.  And hilariously, the
"optimization" is completely unnecessary because both gcc and clang are clever
enough to batch the first five into a movq even when zeroing the fields individually.

So, I would much prefer to go with the following:

From dbdca1f4cd01fee418c252e54c360d518b2b1ad6 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Aug 2021 08:03:08 -0700
Subject: [PATCH] KVM: x86: Replace memset() "optimization" with normal
 per-field writes

Explicitly zero select fields in the emulator's decode cache instead of
zeroing the fields via a gross memset() that spans six fields.  gcc and
clang are both clever enough to batch the first five fields into a single
quadword MOV, i.e. memset() and individually zeroing generate identical
code.

Removing the wart also prepares KVM for FORTIFY_SOURCE performing
compile-time and run-time field bounds checking for memset().

No functional change intended.

Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 9 +++++++--
 arch/x86/kvm/kvm_emulate.h | 6 +-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2837110e66ed..bf81fd017e7f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5377,8 +5377,13 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop)

 void init_decode_cache(struct x86_emulate_ctxt *ctxt)
 {
-	memset(&ctxt->rip_relative, 0,
-	       (void *)&ctxt->modrm - (void *)&ctxt->rip_relative);
+	/* Clear fields that are set conditionally but read without a guard. */
+	ctxt->rip_relative = false;
+	ctxt->rex_prefix = 0;
+	ctxt->lock_prefix = 0;
+	ctxt->rep_prefix = 0;
+	ctxt->regs_valid = 0;
+	ctxt->regs_dirty = 0;

 	ctxt->io_read.pos = 0;
 	ctxt->io_read.end = 0;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 68b420289d7e..bc1fecacccd4 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -336,11 +336,7 @@ struct x86_emulate_ctxt {
 		fastop_t fop;
 	};
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
-	/*
-	 * The following six fields are cleared together,
-	 * the rest are initialized unconditionally in x86_decode_insn
-	 * or elsewhere
-	 */
+
 	bool rip_relative;
 	u8 rex_prefix;
 	u8 lock_prefix;
--
2.33.0.rc1.237.g0d66db33f3-goog

> +		bool rip_relative;
> +		u8 rex_prefix;
> +		u8 lock_prefix;
> +		u8 rep_prefix;
> +		/* bitmaps of registers in _regs[] that can be read */
> +		u32 regs_valid;
> +		/* bitmaps of registers in _regs[] that have been written */
> +		u32 regs_dirty;
> +	);
> +
>  	/* modrm */
>  	u8 modrm;
>  	u8 modrm_mod;
> -- 
> 2.30.2
> 
