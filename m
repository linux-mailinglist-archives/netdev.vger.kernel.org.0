Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2817238FE41
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 11:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhEYJ5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 05:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbhEYJ5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 05:57:09 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8414DC061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 02:55:38 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id k14so42917506eji.2
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 02:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/f4f0aZeBzeXlWyKfJdQ1/8QAd+9GfrpiTcDBRRwltI=;
        b=SU2hSmsRmylGpFNYI0BcOgB9PyqmDrVC5VDUt2NFrsoKW1c7DhbIq09SdAdQA8gTMc
         SfzORijh8wbt8IUOyiMDKvEZRRcjm06GhhjV1Mg75BYEQYag3FG71i/iV+NE2aidHqCO
         XcINDVoKexgJbqhtw8MHwytUJc/g1UhkXV+pA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/f4f0aZeBzeXlWyKfJdQ1/8QAd+9GfrpiTcDBRRwltI=;
        b=fbvzG5iAGchlaQJW8HdhD76rKAUizKOD8iIfgz+lFX0n1bHN1Fy2DYpeH+3bP7fCIS
         b4mww8W6mHEsW43WF5s6jGa2Tfw4QbpPy1mCVYseDB9aPWGUiKRhTNXm+MaGD2dCoy7n
         bT9pa3m8skaMxljVMg6lbYoRAcyV6nbmGkqzmyYQBvg4ENFAVZ0SAeWvJ6GkkDUIB00C
         8bQWndAb300ZWrctpTNoFoIjknRd4opxqPAVjvRTLUZen6pCoj2cxEXXVD5kj855tqcH
         hMvj52128En6/QKIZUbVBtHoADDSvmfLMv3vwJdXwtVmTskyTts2b/oE38vMg2lI51vx
         P/8g==
X-Gm-Message-State: AOAM533DhitvQJixMCqRsNvgeL5YrkGwuDfI0HCAsBBBtw8f1zAX6sSq
        iosSUU/0UHOu3Y04VDLYC7W3AA==
X-Google-Smtp-Source: ABdhPJxVa0MvHCvfDBB/Htx8BdGMf0iWX5rMdlAc6qB0/TuX3OEi4wBu9sCsXxx94amSH5FCsuS/lA==
X-Received: by 2002:a17:906:fccc:: with SMTP id qx12mr27810844ejb.21.1621936537051;
        Tue, 25 May 2021 02:55:37 -0700 (PDT)
Received: from [192.168.1.149] ([80.208.74.47])
        by smtp.gmail.com with ESMTPSA id g4sm10751126edw.8.2021.05.25.02.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 02:55:36 -0700 (PDT)
Subject: Re: [PATCH 1/2] lib: test_scanf: Fix incorrect use of type_min() with
 unsigned types
To:     Richard Fitzgerald <rf@opensource.cirrus.com>, pmladek@suse.com,
        rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        andriy.shevchenko@linux.intel.com, w@1wt.eu, lkml@sdf.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.cirrus.com
References: <20210524155941.16376-1-rf@opensource.cirrus.com>
 <20210524155941.16376-2-rf@opensource.cirrus.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <a3396d45-4720-ee30-6493-b19f90c74e54@rasmusvillemoes.dk>
Date:   Tue, 25 May 2021 11:55:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210524155941.16376-2-rf@opensource.cirrus.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/05/2021 17.59, Richard Fitzgerald wrote:
> sparse was producing warnings of the form:
> 
>  sparse: cast truncates bits from constant value (ffff0001 becomes 1)
> 
> The problem was that value_representable_in_type() compared unsigned types
> against type_min(). But type_min() is only valid for signed types because
> it is calculating the value -type_max() - 1. 

... and casts that to (T), so it does produce 0 as it should. E.g. for
T==unsigned char, we get

#define type_min(T) ((T)((T)-type_max(T)-(T)1))
(T)((T)-255 - (T)1)
(T)(-256)

which is 0 of type unsigned char.

The minimum value of an
> unsigned is obviously 0, so only type_max() need be tested.

That part is true.

But type_min and type_max have been carefully created to produce values
of the appropriate type that actually represent the minimum/maximum
representable in that type, without invoking UB. If this program doesn't
produce the expected results for you, I'd be very interested in knowing
your compiler version:

#include <stdio.h>

#define is_signed_type(type)       (((type)(-1)) < (type)1)
#define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 -
is_signed_type(type)))
#define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
#define type_min(T) ((T)((T)-type_max(T)-(T)1))

int main(int argc, char *argv[])
{
#define p(T, PT, fmt) do {					\
		PT vmin = type_min(T);				\
		PT vmax = type_max(T);				\
		printf("min(%s) = "fmt", max(%s) = "fmt"\n",#T, vmin, #T, vmax); \
	} while (0)

	p(_Bool, int, "%d");
	p(unsigned char, int, "%d");
	p(signed char, int, "%d");
	p(unsigned int, unsigned int, "%u");
	p(unsigned long long, unsigned long long, "%llu");
	p(signed long long, signed long long, "%lld");
	
	return 0;
}



>  lib/test_scanf.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/test_scanf.c b/lib/test_scanf.c
> index 8d577aec6c28..48ff5747a4da 100644
> --- a/lib/test_scanf.c
> +++ b/lib/test_scanf.c
> @@ -187,8 +187,8 @@ static const unsigned long long numbers[] __initconst = {
>  #define value_representable_in_type(T, val)					 \
>  (is_signed_type(T)								 \
>  	? ((long long)(val) >= type_min(T)) && ((long long)(val) <= type_max(T)) \
> -	: ((unsigned long long)(val) >= type_min(T)) &&				 \
> -	  ((unsigned long long)(val) <= type_max(T)))
> +	: ((unsigned long long)(val) <= type_max(T)))


With or without this, these tests are tautological when T is "long long"
or "unsigned long long". I don't know if that is intended. But it won't,
say, exclude ~0ULL if that is in the numbers[] array from being treated
as fitting in a "long long".

Rasmus
