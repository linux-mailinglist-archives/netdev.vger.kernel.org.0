Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0000B394830
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhE1VPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:15:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:41710 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhE1VPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 17:15:20 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmjNA-0000UR-78; Fri, 28 May 2021 22:46:24 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmjNA-000JT2-0a; Fri, 28 May 2021 22:46:24 +0200
Subject: Re: [PATCH] selftests/bpf: Fix return value check in attach_bpf()
To:     Yu Kuai <yukuai3@huawei.com>, shuah@kernel.org, ast@kernel.org,
        andrii@kernel.org
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com
References: <20210528090758.1108464-1-yukuai3@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c5a37d91-dd20-55e3-a78b-272a00b940d5@iogearbox.net>
Date:   Fri, 28 May 2021 22:46:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210528090758.1108464-1-yukuai3@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26184/Fri May 28 13:05:50 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 11:07 AM, Yu Kuai wrote:
> use libbpf_get_error() to check the return value of
> bpf_program__attach().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   tools/testing/selftests/bpf/benchs/bench_rename.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/testing/selftests/bpf/benchs/bench_rename.c
> index c7ec114eca56..b7d4a1d74fca 100644
> --- a/tools/testing/selftests/bpf/benchs/bench_rename.c
> +++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
> @@ -65,7 +65,7 @@ static void attach_bpf(struct bpf_program *prog)
>   	struct bpf_link *link;
>   
>   	link = bpf_program__attach(prog);
> -	if (!link) {
> +	if (libbpf_get_error(link)) {
>   		fprintf(stderr, "failed to attach program!\n");
>   		exit(1);
>   	}

Could you explain the rationale of this patch? bad2e478af3b ("selftests/bpf: Turn
on libbpf 1.0 mode and fix all IS_ERR checks") explains: 'Fix all the explicit
IS_ERR checks that now will be broken because libbpf returns NULL on error (and
sets errno).' So the !link check looks totally reasonable to me. Converting to
libbpf_get_error() is not wrong in itself, but given you don't make any use of
the err code, there is also no point in this diff here.

Thanks,
Daniel
