Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58AD49FBEB
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbiA1OnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:43:01 -0500
Received: from www62.your-server.de ([213.133.104.62]:58490 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349397AbiA1Omz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:42:55 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nDSSX-0000FP-76; Fri, 28 Jan 2022 15:42:41 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nDSSW-000Tvp-Qt; Fri, 28 Jan 2022 15:42:40 +0100
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: check whether s32 is
 sufficient for kfunc offset
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <20220127071532.384888-1-houtao1@huawei.com>
 <20220127071532.384888-3-houtao1@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ba562bf9-c328-1258-940f-b4d9a3169776@iogearbox.net>
Date:   Fri, 28 Jan 2022 15:42:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220127071532.384888-3-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26436/Fri Jan 28 10:22:17 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 8:15 AM, Hou Tao wrote:
> In add_kfunc_call(), bpf_kfunc_desc->imm with type s32 is used to
> represent the offset of called kfunc from __bpf_call_base, so
> add a test to ensure that the offset will not be overflowed.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Thanks for looking into this!

> ---
>   .../selftests/bpf/prog_tests/ksyms_module.c   | 72 +++++++++++++++++++
>   1 file changed, 72 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> index d490ad80eccb..ce0cd3446931 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> @@ -6,6 +6,76 @@
>   #include "test_ksyms_module.lskel.h"
>   #include "test_ksyms_module.skel.h"
>   
> +/* Most logic comes from bpf_object__read_kallsyms_file() */
> +static int test_find_func_in_kallsyms(const char *func, unsigned long *addr)
> +{
> +	/* Same as KSYM_NAME_LEN */
> +	char sym_name[128];
> +	char sym_type;
> +	unsigned long sym_addr;
> +	int ret, err;
> +	FILE *f;
> +
> +	f = fopen("/proc/kallsyms", "r");
> +	if (!f)
> +		return -errno;
> +
> +	err = -ENOENT;
> +	while (true) {
> +		ret = fscanf(f, "%lx %c %127s%*[^\n]\n",
> +			     &sym_addr, &sym_type, sym_name);
> +		if (ret == EOF && feof(f))
> +			break;
> +
> +		if (ret != 3) {
> +			err = -EINVAL;
> +			break;
> +		}
> +
> +		if ((sym_type == 't' || sym_type == 'T') &&
> +		    !strcmp(sym_name, func)) {
> +			*addr = sym_addr;
> +			err = 0;
> +			break;
> +		}
> +	}
> +
> +	fclose(f);
> +	return err;
> +}

Could we just reuse kallsyms_find() from trace_helpers.c which is also used
in couple of other prog_tests already?

> +
> +/*
> + * Check whether or not s32 in bpf_kfunc_desc is sufficient
> + * to represent the offset between bpf_testmod_test_mod_kfunc
> + * and __bpf_call_base.
> + */
> +void test_ksyms_module_valid_offset(void)
> +{
> +	unsigned long kfunc_addr;
> +	unsigned long base_addr;
> +	int used_offset;
> +	long actual_offset;
> +	int err;
> +
> +	if (!env.has_testmod) {
> +		test__skip();
> +		return;
> +	}
> +
> +	err = test_find_func_in_kallsyms("bpf_testmod_test_mod_kfunc",
> +					 &kfunc_addr);
> +	if (!ASSERT_OK(err, "find kfunc addr"))
> +		return;
> +
> +	err = test_find_func_in_kallsyms("__bpf_call_base", &base_addr);
> +	if (!ASSERT_OK(err, "find base addr"))
> +		return;
> +
> +	used_offset = kfunc_addr - base_addr;
> +	actual_offset = kfunc_addr - base_addr;
> +	ASSERT_EQ((long)used_offset, actual_offset, "kfunc offset overflowed");

Is the above also executed in case bpf_jit_supports_kfunc_call() falls back to
the default __weak callback, returning false? If yes, then the ASSERT_EQ() may
fail on archs like s390, ppc, etc where the offset may not be enough.

> +}
> +
>   void test_ksyms_module_lskel(void)
>   {
>   	struct test_ksyms_module_lskel *skel;
> @@ -55,6 +125,8 @@ void test_ksyms_module_libbpf(void)
>   
>   void test_ksyms_module(void)
>   {
> +	if (test__start_subtest("valid_offset"))
> +		test_ksyms_module_valid_offset();
>   	if (test__start_subtest("lskel"))
>   		test_ksyms_module_lskel();
>   	if (test__start_subtest("libbpf"))
> 

