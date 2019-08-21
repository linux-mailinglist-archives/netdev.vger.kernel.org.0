Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FC39790D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 14:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfHUMRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 08:17:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:60648 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfHUMRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 08:17:06 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0PXz-0005EJ-22; Wed, 21 Aug 2019 14:17:03 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0PXy-000ReL-SG; Wed, 21 Aug 2019 14:17:02 +0200
Subject: Re: [PATCH bpf-next v2 2/4] selftests/bpf: test_progs: remove global
 fail/success counts
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org,
        Andrii Nakryiko <andriin@fb.com>
References: <20190819191752.241637-1-sdf@google.com>
 <20190819191752.241637-3-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5248b967-2887-2205-3e59-fc067e2ada33@iogearbox.net>
Date:   Wed, 21 Aug 2019 14:17:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190819191752.241637-3-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25548/Wed Aug 21 10:27:18 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/19 9:17 PM, Stanislav Fomichev wrote:
> Now that we have a global per-test/per-environment state, there
> is no longer need to have global fail/success counters (and there
> is no need to save/get the diff before/after the test).

Thanks for the improvements, just a small comment below, otherwise LGTM.

> Introduce QCHECK macro (suggested by Andrii) and covert existing tests
> to it. QCHECK uses new test__fail() to record the failure.
> 
> Cc: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
[...]
> @@ -96,17 +93,25 @@ extern struct ipv6_packet pkt_v6;
>   #define _CHECK(condition, tag, duration, format...) ({			\
>   	int __ret = !!(condition);					\
>   	if (__ret) {							\
> -		error_cnt++;						\
> +		test__fail();						\
>   		printf("%s:FAIL:%s ", __func__, tag);			\
>   		printf(format);						\
>   	} else {							\
> -		pass_cnt++;						\
>   		printf("%s:PASS:%s %d nsec\n",				\
>   		       __func__, tag, duration);			\
>   	}								\
>   	__ret;								\
>   })
>   
> +#define QCHECK(condition) ({						\
> +	int __ret = !!(condition);					\
> +	if (__ret) {							\
> +		test__fail();						\
> +		printf("%s:FAIL:%d ", __func__, __LINE__);		\
> +	}								\
> +	__ret;								\
> +})

I know it's just a tiny nit but the name QCHECK() really doesn't tell me anything
if I don't see its definition. Even just a CHECK_FAIL() might be 'better' and
more aligned with the CHECK() and CHECK_ATTR() we have, at least I don't think
many would automatically derive 'quiet' from the Q prefix [0].

   [0] https://lore.kernel.org/bpf/CAEf4BzbUGiUZBWkTWe2=LfhkXYhQGndN9gR6VTZwfV3eytstUw@mail.gmail.com/

>   #define CHECK(condition, tag, format...) \
>   	_CHECK(condition, tag, duration, format)
>   #define CHECK_ATTR(condition, tag, format...) \
> 

