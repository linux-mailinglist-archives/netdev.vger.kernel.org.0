Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFFD188EF4
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCQUZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:25:56 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34027 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgCQUZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:25:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id a23so10129759plm.1
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 13:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MZN9B+W7EvES6uCESizNLVYmhi4wQkGfGjOmzf14kGA=;
        b=ZFFul7/h9YK6HFCn1/cbAj3yfVlrV7XAUnzy0ivo+c6ba67JuLAzJfSisBlmY4UfIt
         avEN3UUsLE49r/vFRmJZBREwGx5bKXTAaQwkNzioyDPLD8b93eLWnf6LsurvEikNknEJ
         IP6kNVIyFXHclp9BkahjVJ7GJRMBq4ecpU268=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MZN9B+W7EvES6uCESizNLVYmhi4wQkGfGjOmzf14kGA=;
        b=OZXTROYOAVOoVAl6NX1/JjWAKufhO5JSWrQk/14camrjm+9Ygsh3khx8cm9s8vsHv4
         I98jKrSZrSXjBm94X6VEDYGQ954vB6z02zuummxvRfR7vAr+Te4Ftf0Ba9Q3CrJ9pNWm
         m94SedgnZ5FzrtN8gE7R54KyViu9LWKdvz1h2Qnni/2cWjmj7EjxG2kViiDSMhAHgJWF
         1GGotU8qd4pTvvCf8oReeptOFK6Kst5zjp6SSYP1qRu+HofVdChau0Ja9Iw7m1cevVU0
         ZUp146obRqbp0f9mx2Q+b7+07Rrn7JTcM1a0Y3TiekdB7AitSrhypPtnHeVX2O8eB6BX
         jHUA==
X-Gm-Message-State: ANhLgQ03dHJQqX9mnY77FAOp2L/fdA77Ly2sMtdMqmHkx3YHCyB/RlXg
        31EevLlT/7Uad+P2MUWzx0X/jg==
X-Google-Smtp-Source: ADFU+vs4xYpzu5kVG4IVSxnHs8wUySIoggXnk9xyuDp5x+DvfvD7QJt/q8JRcsRyo8t5GVb/fDglOA==
X-Received: by 2002:a17:90b:3742:: with SMTP id ne2mr1022165pjb.144.1584476755627;
        Tue, 17 Mar 2020 13:25:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n5sm4120501pfq.35.2020.03.17.13.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 13:25:54 -0700 (PDT)
Date:   Tue, 17 Mar 2020 13:25:53 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, Tim.Bird@sony.com
Subject: Re: [PATCH v3 4/6] kselftest: run tests by fixture
Message-ID: <202003171324.E6E5FE7@keescook>
References: <20200316225647.3129354-1-kuba@kernel.org>
 <20200316225647.3129354-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316225647.3129354-5-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 03:56:44PM -0700, Jakub Kicinski wrote:
> Now that all tests have a fixture object move from a global
> list of tests to a list of tests per fixture.
> 
> Order of tests may change as we will now group and run test
> fixture by fixture, rather than in declaration order.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  tools/testing/selftests/kselftest_harness.h | 32 +++++++++++++--------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
> index 0f68943d6f04..36ab1b92eb35 100644
> --- a/tools/testing/selftests/kselftest_harness.h
> +++ b/tools/testing/selftests/kselftest_harness.h
> @@ -660,8 +660,11 @@
>  }
>  
>  /* Contains all the information about a fixture */
> +struct __test_metadata;
> +

Comment should be moved under this (it applies to __fixture_metadata not
__test_metadata).

>  struct __fixture_metadata {
>  	const char *name;
> +	struct __test_metadata *tests;
>  	struct __fixture_metadata *prev, *next;
>  } _fixture_global __attribute__((unused)) = {
>  	.name = "global",
> @@ -696,7 +699,6 @@ struct __test_metadata {
>  };
>  
>  /* Storage for the (global) tests to be run. */
> -static struct __test_metadata *__test_list;
>  static unsigned int __test_count;
>  
>  /*
> @@ -710,8 +712,10 @@ static unsigned int __test_count;
>   */
>  static inline void __register_test(struct __test_metadata *t)
>  {
> +	struct __fixture_metadata *f = t->fixture;
> +
>  	__test_count++;
> -	__LIST_APPEND(__test_list, t);
> +	__LIST_APPEND(f->tests, t);

Not a big deal, but why not just "f->fixture->tests" here instead of a
separate variable?

>  }
>  
>  static inline int __bail(int for_realz, bool no_print, __u8 step)
> @@ -724,14 +728,15 @@ static inline int __bail(int for_realz, bool no_print, __u8 step)
>  	return 0;
>  }
>  
> -void __run_test(struct __test_metadata *t)
> +void __run_test(struct __fixture_metadata *f,
> +		struct __test_metadata *t)
>  {
>  	pid_t child_pid;
>  	int status;
>  
>  	t->passed = 1;
>  	t->trigger = 0;
> -	printf("[ RUN      ] %s.%s\n", t->fixture->name, t->name);
> +	printf("[ RUN      ] %s.%s\n", f->name, t->name);
>  	alarm(t->timeout);
>  	child_pid = fork();
>  	if (child_pid < 0) {
> @@ -781,13 +786,14 @@ void __run_test(struct __test_metadata *t)
>  		}
>  	}
>  	printf("[     %4s ] %s.%s\n", (t->passed ? "OK" : "FAIL"),
> -	       t->fixture->name, t->name);
> +	       f->name, t->name);
>  	alarm(0);
>  }
>  
>  static int test_harness_run(int __attribute__((unused)) argc,
>  			    char __attribute__((unused)) **argv)
>  {
> +	struct __fixture_metadata *f;
>  	struct __test_metadata *t;
>  	int ret = 0;
>  	unsigned int count = 0;
> @@ -796,13 +802,15 @@ static int test_harness_run(int __attribute__((unused)) argc,
>  	/* TODO(wad) add optional arguments similar to gtest. */
>  	printf("[==========] Running %u tests from %u test cases.\n",
>  	       __test_count, __fixture_count + 1);
> -	for (t = __test_list; t; t = t->next) {
> -		count++;
> -		__run_test(t);
> -		if (t->passed)
> -			pass_count++;
> -		else
> -			ret = 1;
> +	for (f = __fixture_list; f; f = f->next) {
> +		for (t = f->tests; t; t = t->next) {
> +			count++;
> +			__run_test(f, t);
> +			if (t->passed)
> +				pass_count++;
> +			else
> +				ret = 1;
> +		}
>  	}
>  	printf("[==========] %u / %u tests passed.\n", pass_count, count);
>  	printf("[  %s  ]\n", (ret ? "FAILED" : "PASSED"));
> -- 
> 2.24.1
> 

But, with at least the first comment moved:

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
