Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADA04422FB
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhKAWEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:04:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:57028 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhKAWEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 18:04:09 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhfMx-000Df9-4a; Mon, 01 Nov 2021 23:01:31 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhfMw-000VWU-Uf; Mon, 01 Nov 2021 23:01:30 +0100
Subject: Re: [PATCH bpf-next v2 1/2] bpf: clean-up bpf_verifier_vlog() for
 BPF_LOG_KERNEL log level
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211029135321.94065-1-houtao1@huawei.com>
 <20211029135321.94065-2-houtao1@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ebdd6730-1dfc-1889-eae9-00211bd82803@iogearbox.net>
Date:   Mon, 1 Nov 2021 23:01:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211029135321.94065-2-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26340/Mon Nov  1 09:21:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/21 3:53 PM, Hou Tao wrote:
> An extra newline will output for bpf_log() with BPF_LOG_KERNEL level
> as shown below:
> 
> [   52.095704] BPF:The function test_3 has 12 arguments. Too many.
> [   52.095704]
> [   52.096896] Error in parsing func ptr test_3 in struct bpf_dummy_ops
> 
> Now all bpf_log() are ended by newline, but not all btf_verifier_log()
> are ended by newline, so checking whether or not the log message
> has the trailing newline and adding a newline if not.
> 
> Also there is no need to calculate the left userspace buffer size
> for kernel log output and to truncate the output by '\0' which
> has already been done by vscnprintf(), so only do these for
> userspace log output.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>   kernel/bpf/verifier.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 3c8aa7df1773..22f0d2292c2c 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -299,13 +299,15 @@ void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
>   	WARN_ONCE(n >= BPF_VERIFIER_TMP_LOG_SIZE - 1,
>   		  "verifier log line truncated - local buffer too short\n");
>   
> -	n = min(log->len_total - log->len_used - 1, n);
> -	log->kbuf[n] = '\0';
> -
>   	if (log->level == BPF_LOG_KERNEL) {
> -		pr_err("BPF:%s\n", log->kbuf);
> +		bool newline = n > 0 && log->kbuf[n - 1] == '\n';
> +
> +		pr_err("BPF:%s%s", log->kbuf, newline ? "" : "\n");

nit: Given you change this anyway, is there a reason not to go with "BPF: %s%s" instead?

>   		return;
>   	}
> +
> +	n = min(log->len_total - log->len_used - 1, n);
> +	log->kbuf[n] = '\0';
>   	if (!copy_to_user(log->ubuf + log->len_used, log->kbuf, n + 1))
>   		log->len_used += n;
>   	else
> 

