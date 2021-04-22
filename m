Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391D83688C3
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhDVV4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:56:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:39264 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbhDVV4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 17:56:52 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZhIs-000DUm-AJ; Thu, 22 Apr 2021 23:56:06 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZhIs-000JP5-1R; Thu, 22 Apr 2021 23:56:06 +0200
Subject: Re: [PATCH] selftests/bpf: fix warning comparing pointer to 0
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, shuah@kernel.org
Cc:     ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1619085648-36826-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7ecb85e6-410b-65bb-a042-74045ee17c3f@iogearbox.net>
Date:   Thu, 22 Apr 2021 23:56:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1619085648-36826-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26148/Thu Apr 22 13:06:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 12:00 PM, Jiapeng Chong wrote:
> Fix the following coccicheck warning:
> 
> ./tools/testing/selftests/bpf/progs/fentry_test.c:76:15-16: WARNING
> comparing pointer to 0.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

How many more of those 'comparing pointer to 0' patches do you have?
Right now we already merged the following with similar trivial pattern:

  - ebda107e5f222a086c83ddf6d1ab1da97dd15810
  - a9c80b03e586fd3819089fbd33c38fb65ad5e00c
  - 04ea63e34a2ee85cfd38578b3fc97b2d4c9dd573

Given they don't really 'fix' anything, I would like to reduce such
patch cleanup churn on the bpf tree. Please _consolidate_ all other
such occurrences into a _single_ patch for BPF selftests, and resubmit.

Thanks!

> ---
>   tools/testing/selftests/bpf/progs/fentry_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
> index 52a550d..d4247d6 100644
> --- a/tools/testing/selftests/bpf/progs/fentry_test.c
> +++ b/tools/testing/selftests/bpf/progs/fentry_test.c
> @@ -73,7 +73,7 @@ int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
>   SEC("fentry/bpf_fentry_test8")
>   int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
>   {
> -	if (arg->a == 0)
> +	if (!arg->a)
>   		test8_result = 1;
>   	return 0;
>   }
> 

