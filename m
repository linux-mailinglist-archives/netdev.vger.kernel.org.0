Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576214925C9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbiARMgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 07:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbiARMgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 07:36:04 -0500
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [IPv6:2001:1600:4:17::8faa])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCEBC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 04:36:04 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JdStT1zBDzMq01B;
        Tue, 18 Jan 2022 13:36:01 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4JdStQ5z5tzlhMBj;
        Tue, 18 Jan 2022 13:35:58 +0100 (CET)
Message-ID: <8ea3bd61-8251-a5b6-c0b4-6d15bac4d2c5@digikod.net>
Date:   Tue, 18 Jan 2022 13:35:46 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:LANDLOCK SECURITY MODULE" 
        <linux-security-module@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:NETWORKING [MPTCP]" <mptcp@lists.linux.dev>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Cc:     kernel@collabora.com
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
 <20220118112909.1885705-7-usama.anjum@collabora.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH 06/10] selftests: landlock: Add the uapi headers include
 variable
In-Reply-To: <20220118112909.1885705-7-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/01/2022 12:29, Muhammad Usama Anjum wrote:
> Out of tree build of this test fails if relative path of the output
> directory is specified. Remove the un-needed include paths and use
> KHDR_INCLUDES to correctly reach the headers.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>   tools/testing/selftests/landlock/Makefile | 11 +++--------
>   1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
> index a99596ca9882..44c724b38a37 100644
> --- a/tools/testing/selftests/landlock/Makefile
> +++ b/tools/testing/selftests/landlock/Makefile
> @@ -1,6 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   
> -CFLAGS += -Wall -O2
> +CFLAGS += -Wall -O2 $(KHDR_INCLUDES)
>   
>   src_test := $(wildcard *_test.c)
>   
> @@ -12,13 +12,8 @@ KSFT_KHDR_INSTALL := 1
>   OVERRIDE_TARGETS := 1
>   include ../lib.mk
>   
> -khdr_dir = $(top_srcdir)/usr/include

This should be updated to:
khdr_dir = ${abs_srctree}/usr/include

Using a global KHDR_DIR instead of khdr_dir could be useful for others too.

> -
> -$(khdr_dir)/linux/landlock.h: khdr
> -	@:

This should be kept as is, otherwise we loose this check to rebuild the 
headers if linux/landlock.h is updated, which is handy for development.
KVM lost a similar behavior with this patch series.

> -
>   $(OUTPUT)/true: true.c
>   	$(LINK.c) $< $(LDLIBS) -o $@ -static
>   
> -$(OUTPUT)/%_test: %_test.c $(khdr_dir)/linux/landlock.h ../kselftest_harness.h common.h

This should not be changed.

> -	$(LINK.c) $< $(LDLIBS) -o $@ -lcap -I$(khdr_dir)
> +$(OUTPUT)/%_test: %_test.c ../kselftest_harness.h common.h
> +	$(LINK.c) $< $(LDLIBS) -o $@ -lcap

This doesn't work when building in the local directory because 
$abs_srctree and $KHDR_INCLUDES are empty:
cd tools/testing/selftests/landlock && make
