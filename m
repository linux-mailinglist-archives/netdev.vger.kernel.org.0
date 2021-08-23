Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C03B3F4DB5
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 17:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhHWPs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 11:48:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:34654 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhHWPsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 11:48:55 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mICBA-0006tY-Ed; Mon, 23 Aug 2021 17:48:04 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mICB9-000Jg5-UB; Mon, 23 Aug 2021 17:48:04 +0200
Subject: Re: [PATCH bpf-next] bpf: test_bpf: Print total time of test in the
 summary
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1629548039-3747-1-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4226eb32-7755-5a32-5c58-7e64c129727c@iogearbox.net>
Date:   Mon, 23 Aug 2021 17:48:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1629548039-3747-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26272/Mon Aug 23 10:21:13 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/21 2:13 PM, Tiezhu Yang wrote:
> The total time of test is useful to compare the performance
> when bpf_jit_enable is 0 or 1, so print it in the summary.
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   lib/test_bpf.c | 27 +++++++++++++++++++++------
>   1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index 830a18e..b1b17ba 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -8920,6 +8920,9 @@ static __init int test_skb_segment_single(const struct skb_segment_test *test)
>   static __init int test_skb_segment(void)
>   {
>   	int i, err_cnt = 0, pass_cnt = 0;
> +	u64 start, finish;
> +
> +	start = ktime_get_ns();
>   
>   	for (i = 0; i < ARRAY_SIZE(skb_segment_tests); i++) {
>   		const struct skb_segment_test *test = &skb_segment_tests[i];
> @@ -8935,8 +8938,10 @@ static __init int test_skb_segment(void)
>   		}
>   	}
>   
> -	pr_info("%s: Summary: %d PASSED, %d FAILED\n", __func__,
> -		pass_cnt, err_cnt);
> +	finish = ktime_get_ns();
> +
> +	pr_info("%s: Summary: %d PASSED, %d FAILED in %llu nsec\n",
> +		__func__, pass_cnt, err_cnt, finish - start);
>   	return err_cnt ? -EINVAL : 0;
>   }

I don't think this gives you any accurate results (e.g. what if this gets migrated
or preempted?); maybe rather use the duration from __run_one() ..

Thanks,
Daniel
