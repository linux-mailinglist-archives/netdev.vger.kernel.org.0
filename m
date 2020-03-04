Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010D8179BE7
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 23:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388436AbgCDWml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 17:42:41 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41670 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388505AbgCDWml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 17:42:41 -0500
Received: by mail-pf1-f195.google.com with SMTP id z65so1213858pfz.8
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 14:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=odK5+dhUnBqo/+13PepNr/CkWlUjNgQ8JDVfrKhakIk=;
        b=isdY1aSXFghm/7DcPvO2xsBI6RsGzX4b5UMukog5rXaPNNa7gW8dJ13PYJNrekz4Tc
         dH4RUdCfN25tOEOdXai1KnSscbdIv6B+XYH1HTrplPOXWVVZ5MkyAkwJesiA2LZ15dDh
         +pBQqERRnjfEMP/stih8i95gBD6GNbY6FH3dI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=odK5+dhUnBqo/+13PepNr/CkWlUjNgQ8JDVfrKhakIk=;
        b=a6l4lm3j5buj7HEnEPDeVKVLpF42gqxEYXhC2RLwkm58uWeNdlGEIKmZmq5/AXMxaT
         ouJ7updZS/V8tk7Vq4rbrFige7FcohJKq1sbc+GH5rHsWOIqA1cEi0pVSNl5l346FwhW
         NsUIrsnRoQynk9XSaFauWvYO39cU2PvTp43aSBSMvvGCgVY6lKsoBbkP5Jj8eQtXs89r
         AdzqX0cT9cuju9DonUbvPtZcvbVF5gowqMPcEWcbn+ml4xJ58pmSaE9wbJI0GGByiSTn
         XhfoYAj5sGyB/J4AZbAsl8AC0qnQKqC44KS28Oxi3OgDBvPqoyE1C0IuTQfmQOk2slcW
         Oqlg==
X-Gm-Message-State: ANhLgQ3NwexEs2F6VbvslmclNn+Wztr558bsNYmUgx0saZm+jDPmCB7a
        5XIic2tNJcjVOzL9AERUS05roA==
X-Google-Smtp-Source: ADFU+vuKmczxGP4mpY9UFRgyIrH5RPg53yiVBl1Tz6nWTwaU/eXHWFgTXsBhMOZfJPQKyh0YI4ZA9w==
X-Received: by 2002:aa7:8695:: with SMTP id d21mr5208658pfo.199.1583361760528;
        Wed, 04 Mar 2020 14:42:40 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w81sm15677072pff.22.2020.03.04.14.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 14:42:39 -0800 (PST)
Date:   Wed, 4 Mar 2020 14:42:38 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        daniel@iogearbox.net, kafai@fb.com, yhs@fb.com, andriin@fb.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        khilman@baylibre.com, mpe@ellerman.id.au,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 2/4] selftests: Fix seccomp to support relocatable build
 (O=objdir)
Message-ID: <202003041442.A46000C@keescook>
References: <cover.1583358715.git.skhan@linuxfoundation.org>
 <11967e5f164f0cd717921bd382ff9c13ef740146.1583358715.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11967e5f164f0cd717921bd382ff9c13ef740146.1583358715.git.skhan@linuxfoundation.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 03:13:33PM -0700, Shuah Khan wrote:
> Fix seccomp relocatable builds. This is a simple fix to use the
> right lib.mk variable TEST_GEN_PROGS for objects to leverage
> lib.mk common framework for relocatable builds.
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  tools/testing/selftests/seccomp/Makefile | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
> index 1760b3e39730..a8a9717fc1be 100644
> --- a/tools/testing/selftests/seccomp/Makefile
> +++ b/tools/testing/selftests/seccomp/Makefile
> @@ -1,17 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
> -all:
> -
> -include ../lib.mk
> -
> -.PHONY: all clean
> -
> -BINARIES := seccomp_bpf seccomp_benchmark
>  CFLAGS += -Wl,-no-as-needed -Wall
> +LDFLAGS += -lpthread
>  
> -seccomp_bpf: seccomp_bpf.c ../kselftest_harness.h

How is the ../kselftest_harness.h dependency detected in the resulting
build rules?

Otherwise, looks good.

-Kees

> -	$(CC) $(CFLAGS) $(LDFLAGS) $< -lpthread -o $@
> -
> -TEST_PROGS += $(BINARIES)
> -EXTRA_CLEAN := $(BINARIES)
> +TEST_GEN_PROGS := seccomp_bpf seccomp_benchmark
>  
> -all: $(BINARIES)
> +include ../lib.mk
> -- 
> 2.20.1
> 

-- 
Kees Cook
