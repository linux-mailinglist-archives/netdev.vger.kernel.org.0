Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0376A3F0E6A
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhHRWyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbhHRWyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 18:54:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1846C061796
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 15:54:04 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so3469675pjb.2
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 15:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bdg/OtOV5wymBEUwuQlX5+GK5JjmwLGgSiZ+Tmmadzg=;
        b=bGU4j745GyvuoiOCvJ9XjMdyezUrxYO1pPcd3Nh9uTw2AHyNof0gLDjkyhM8xE1bpY
         ZhK4WiLLT0bHAnhPZz+LIR1+EgOwNsqitav2SEBVEKiVfgPXmLnjjumcy0TFltdAkpUp
         +Y/iv2y66lHJkcJw8yDjHLrdQLAKo5xhCntkA7/YsKW0wiAtv4Qvj7Ok2yu75nvP5VG/
         kQ33sD5kcz6G3nunSMjMr3GEhOael40I5f0/SkDnOprQdLkOYlZpBPRnAiPwJ3is8bPU
         tVhgUeDxPTVKaaCpoehLowvGyCLbirnVXNHyIzEPJxHcN9722SczInchAhVN3qboCzK5
         oo2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bdg/OtOV5wymBEUwuQlX5+GK5JjmwLGgSiZ+Tmmadzg=;
        b=UREdlgiQeP7vczznZSvWriYoBCk2yagCaPf29sxqAKzBGF/39iWqvK4xyfB4ZgWfOL
         prveg1v2Tx5gPqYvc5xDCgxtGG7od4BxrV8j/huTU8YEPtWQaphSKdSnlNr8vZFKjKyk
         TOZomsTn7F0HYOLvbG+puXsKsVN5EH1KTGRvifqQdU7s/knY/Ec/Z75/EGFWWb8MXNFW
         cdn9M1NaWMTxPS5n8YsmsLsP30V0MUOzUymUZWCbqV+Y2VQbXku+YZx90m/92cCyPtZy
         oHX/FvbyXtHNqQWhqUGY/j04Kixz2YVA6RQvAt6FbJB7LM5Ud9a58bPI22kpZ92S1b2b
         H9ww==
X-Gm-Message-State: AOAM533yMAMmUdku2A9gulzwecT0qsRDWg1IYiJeWp3eSN09epSi8Hh/
        YT31YMZYWFbzW/NrMo8VLATh4A==
X-Google-Smtp-Source: ABdhPJzzXby04WbbyigGFBDREGEkGV8RqUxAeMQ0ojYzJgYocP/xgVxlZiD/Hh9heqjmIsz5yKhdZw==
X-Received: by 2002:a17:90a:af88:: with SMTP id w8mr11746328pjq.104.1629327244194;
        Wed, 18 Aug 2021 15:54:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s26sm894895pgv.46.2021.08.18.15.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 15:54:03 -0700 (PDT)
Date:   Wed, 18 Aug 2021 22:53:58 +0000
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
Message-ID: <YR2PhlO3njPcFOkg@google.com>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-54-keescook@chromium.org>
 <YR0jIEzEcUom/7rd@google.com>
 <202108180922.6C9E385A1@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202108180922.6C9E385A1@keescook>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021, Kees Cook wrote:
> On Wed, Aug 18, 2021 at 03:11:28PM +0000, Sean Christopherson wrote:
> > From dbdca1f4cd01fee418c252e54c360d518b2b1ad6 Mon Sep 17 00:00:00 2001
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Wed, 18 Aug 2021 08:03:08 -0700
> > Subject: [PATCH] KVM: x86: Replace memset() "optimization" with normal
> >  per-field writes
> > 
> > Explicitly zero select fields in the emulator's decode cache instead of
> > zeroing the fields via a gross memset() that spans six fields.  gcc and
> > clang are both clever enough to batch the first five fields into a single
> > quadword MOV, i.e. memset() and individually zeroing generate identical
> > code.
> > 
> > Removing the wart also prepares KVM for FORTIFY_SOURCE performing
> > compile-time and run-time field bounds checking for memset().
> > 
> > No functional change intended.
> > 
> > Reported-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> Do you want me to take this patch into my tree, or do you want to carry
> it for KVM directly?

That's a Paolo question :-)

What's the expected timeframe for landing stricter bounds checking?  If it's
5.16 or later, the easiest thing would be to squeak this into 5.15.
