Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C592837C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbfEWQ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:27:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:49426 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730752AbfEWQ1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:27:33 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTqBA-0006CQ-CS; Thu, 23 May 2019 18:02:52 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTqBA-000Mgq-4p; Thu, 23 May 2019 18:02:52 +0200
Subject: Re: [PATCH bpf v1 1/3] selftests/bpf: Test correctness of narrow
 32bit read on 64bit field
To:     Krzesimir Nowak <krzesimir@kinvolk.io>, bpf@vger.kernel.org
Cc:     iago@kinvolk.io, alban@kinvolk.io, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrey Ignatov <rdna@fb.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190515134731.12611-1-krzesimir@kinvolk.io>
 <20190515134731.12611-2-krzesimir@kinvolk.io>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c28c3cea-a8e0-fbd8-6113-bbb4cece0178@iogearbox.net>
Date:   Thu, 23 May 2019 18:02:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190515134731.12611-2-krzesimir@kinvolk.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25458/Thu May 23 09:58:32 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/15/2019 03:47 PM, Krzesimir Nowak wrote:
> Test the correctness of the 32bit narrow reads by reading both halves
> of the 64 bit field and doing a binary or on them to see if we get the
> original value.
> 
> This isn't really tested - the program is not being run, because
> BPF_PROG_TYPE_PERF_EVENT is not supported by bpf_test_run_prog.

One option could be to add actual support for BPF_PROG_TYPE_PERF_EVENT to
test_verifier where the program gets actually triggered, and the result
stored in a map value that the test case reads out for checking the result
against the expected one. Recently added something similar for LRU maps in
the test suite, that shouldn't be too complex.

Thanks,
Daniel

> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  tools/testing/selftests/bpf/verifier/var_off.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/verifier/var_off.c b/tools/testing/selftests/bpf/verifier/var_off.c
> index 8504ac937809..2668819dcc85 100644
> --- a/tools/testing/selftests/bpf/verifier/var_off.c
> +++ b/tools/testing/selftests/bpf/verifier/var_off.c
> @@ -246,3 +246,18 @@
>  	.result = ACCEPT,
>  	.prog_type = BPF_PROG_TYPE_LWT_IN,
>  },
> +{
> +	"32bit loads of a 64bit field (both least and most significant words)",
> +	.insns = {
> +	BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1, offsetof(struct bpf_perf_event_data, sample_period)),
> +	BPF_LDX_MEM(BPF_W, BPF_REG_5, BPF_REG_1, offsetof(struct bpf_perf_event_data, sample_period) + 4),
> +	BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1, offsetof(struct bpf_perf_event_data, sample_period)),
> +	BPF_ALU64_IMM(BPF_LSH, BPF_REG_4, 32),
> +	BPF_ALU64_REG(BPF_OR, BPF_REG_4, BPF_REG_5),
> +	BPF_ALU64_REG(BPF_XOR, BPF_REG_4, BPF_REG_6),
> +	BPF_MOV64_REG(BPF_REG_0, BPF_REG_4),
> +	BPF_EXIT_INSN(),
> +	},
> +	.result = ACCEPT,
> +	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
> +},
> 

