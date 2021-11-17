Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344D04550AC
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241410AbhKQWpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:45:10 -0500
Received: from www62.your-server.de ([213.133.104.62]:51840 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241317AbhKQWpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 17:45:09 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mnTcz-0009qo-Kq; Wed, 17 Nov 2021 23:42:05 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mnTcz-000DgA-7Y; Wed, 17 Nov 2021 23:42:05 +0100
Subject: Re: [PATCH] selftests/bpf: fix array_size.cocci warning:
To:     Guo Zhengkui <guozhengkui@vivo.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com
References: <20211117132024.11509-1-guozhengkui@vivo.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8f387f33-51f7-feea-d366-ceb5bbed0b51@iogearbox.net>
Date:   Wed, 17 Nov 2021 23:42:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211117132024.11509-1-guozhengkui@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26356/Wed Nov 17 10:26:25 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/21 2:20 PM, Guo Zhengkui wrote:
> Use ARRAY_SIZE() because it uses __must_be_array(arr) to make sure
> arr is really an array.
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>   .../testing/selftests/bpf/prog_tests/cgroup_attach_override.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
> index 356547e849e2..1921c5040d8c 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
> @@ -1,5 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   
> +#include <linux/kernel.h>
>   #include <test_progs.h>

No need for the extra include. test_progs.h already includes bpf_util.h, please check
such trivialities before submission. Simple grep would have revealed use of ARRAY_SIZE()
in various places under tools/testing/selftests/bpf/prog_tests/.

>   #include "cgroup_helpers.h"
> @@ -16,10 +17,9 @@ static int prog_load(int verdict)
>   		BPF_MOV64_IMM(BPF_REG_0, verdict), /* r0 = verdict */
>   		BPF_EXIT_INSN(),
>   	};
> -	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
>   
>   	return bpf_test_load_program(BPF_PROG_TYPE_CGROUP_SKB,
> -			       prog, insns_cnt, "GPL", 0,
> +			       prog, ARRAY_SIZE(prog), "GPL", 0,
>   			       bpf_log_buf, BPF_LOG_BUF_SIZE);

There are many more similar occurrences. Please just send one cleanup patch to reduce
churn in the git log.

Thanks,
Daniel
