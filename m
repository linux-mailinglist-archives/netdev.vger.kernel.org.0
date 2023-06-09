Return-Path: <netdev+bounces-9645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 611B472A1A6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F3631C210FF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBD9206B7;
	Fri,  9 Jun 2023 17:53:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA70419BA3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C87FC433D2;
	Fri,  9 Jun 2023 17:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686333189;
	bh=BZ4LW9yQtmYSq1v+GgFTnuPjo9FB2FZms3pxwBFzl2c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N0Rq8BzdL3qrqoWP8Qhh3lNehik/jQ/iB3qdwsFlpE4XOohQma9e2xR9e/+1tfCxy
	 xBsy/5H/cnJWyXRJ6KeHrcFr11nuGzs6jxZOjhgsLbT5rYGbNycC+ab0UKQk75PpqB
	 4qbdlbE/fnlO934f68DHpA8keMBj+xPykmK9qxtJUs2ZTsCBW9X9sO5vBKzcnfgKSz
	 qU8JwnX6v36pCBgUAx1RSv3UdeRIsWRPVQ8RPfoQlPT2KTKJuOiCtuyAc4Tw5cG8eC
	 OJ9QbMmrO5SwNrJYs5EyxqBbyIb8UJryrUX20WBzhOwWIrfr0PLkL/Vps6nrfKN0sX
	 XPGbxYQ3M6wHQ==
Date: Fri, 9 Jun 2023 10:53:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Magali Lemes <magali.lemes@canonical.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 shuah@kernel.org, vfedorenko@novek.ru, tianjia.zhang@linux.alibaba.com,
 andrei.gherzan@canonical.com, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] selftests: net: tls: check if FIPS mode is
 enabled
Message-ID: <20230609105307.492cd1f2@kernel.org>
In-Reply-To: <20230609164324.497813-2-magali.lemes@canonical.com>
References: <20230609164324.497813-1-magali.lemes@canonical.com>
	<20230609164324.497813-2-magali.lemes@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  9 Jun 2023 13:43:22 -0300 Magali Lemes wrote:
> diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
> index e699548d4247..0725c60f227c 100644
> --- a/tools/testing/selftests/net/tls.c
> +++ b/tools/testing/selftests/net/tls.c
> @@ -25,6 +25,8 @@
>  #define TLS_PAYLOAD_MAX_LEN 16384
>  #define SOL_TLS 282
>  
> +static int fips_enabled = 0;

No need to zero init static variables, but really instead of doing 
the main() hack you should init this to a return value of a function.
And have that function read the value.

>  struct tls_crypto_info_keys {
>  	union {
>  		struct tls12_crypto_info_aes_gcm_128 aes128;

> @@ -311,6 +317,9 @@ FIXTURE_SETUP(tls)
>  	int one = 1;
>  	int ret;
>  
> +	if (fips_enabled && variant->fips_non_compliant)
> +		return;

Eh, let me help you, this should really be part of the SETUP() function
but SETUP() doesn't currently handle SKIP(). So you'll need to add this
to your series:

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index d8bff2005dfc..3091c345452e 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -249,7 +249,7 @@
 
 /**
  * FIXTURE_SETUP() - Prepares the setup function for the fixture.
- * *_metadata* is included so that EXPECT_* and ASSERT_* work correctly.
+ * *_metadata* is included so that EXPECT_*, ASSERT_* etc. work correctly.
  *
  * @fixture_name: fixture name
  *
@@ -275,7 +275,7 @@
 
 /**
  * FIXTURE_TEARDOWN()
- * *_metadata* is included so that EXPECT_* and ASSERT_* work correctly.
+ * *_metadata* is included so that EXPECT_*, ASSERT_* etc. work correctly.
  *
  * @fixture_name: fixture name
  *
@@ -388,7 +388,7 @@
 		if (setjmp(_metadata->env) == 0) { \
 			fixture_name##_setup(_metadata, &self, variant->data); \
 			/* Let setup failure terminate early. */ \
-			if (!_metadata->passed) \
+			if (!_metadata->passed || _metadata->skip) \
 				return; \
 			_metadata->setup_completed = true; \
 			fixture_name##_##test_name(_metadata, &self, variant->data); \

