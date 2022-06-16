Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBB054E521
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 16:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiFPOlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 10:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376985AbiFPOle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 10:41:34 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A98846B1B;
        Thu, 16 Jun 2022 07:41:33 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o1qgd-0008lW-5M; Thu, 16 Jun 2022 16:41:31 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o1qgc-000QsI-Uv; Thu, 16 Jun 2022 16:41:30 +0200
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Test tail call counting with
 bpf2bpf and data on stack
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        kernel-team@cloudflare.com
References: <20220615151721.404596-1-jakub@cloudflare.com>
 <20220615151721.404596-3-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e88f66e7-3bfd-1563-8a74-26f0ac19bfe0@iogearbox.net>
Date:   Thu, 16 Jun 2022 16:41:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220615151721.404596-3-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26574/Thu Jun 16 10:06:40 2022)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/22 5:17 PM, Jakub Sitnicki wrote:
> Cover the case when tail call count needs to be passed from BPF function to
> BPF function, and the caller has data on stack. Specifically when the size
> of data allocated on BPF stack is not a multiple on 8.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>   .../selftests/bpf/prog_tests/tailcalls.c      | 55 +++++++++++++++++++
>   .../selftests/bpf/progs/tailcall_bpf2bpf6.c   | 42 ++++++++++++++
>   2 files changed, 97 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
> index c4da87ec3ba4..19c70880cfb3 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
> @@ -831,6 +831,59 @@ static void test_tailcall_bpf2bpf_4(bool noise)
>   	bpf_object__close(obj);
>   }
>   
> +#include "tailcall_bpf2bpf6.skel.h"
> +
> +/* Tail call counting works even when there is data on stack which is
> + * not aligned to 8 bytes.
> + */
> +static void test_tailcall_bpf2bpf_6(void)
> +{
> +	struct tailcall_bpf2bpf6 *obj;
> +	int err, map_fd, prog_fd, main_fd, data_fd, i, val;
> +	LIBBPF_OPTS(bpf_test_run_opts, topts,
> +		.data_in = &pkt_v4,
> +		.data_size_in = sizeof(pkt_v4),
> +		.repeat = 1,
> +	);
> +
> +	obj = tailcall_bpf2bpf6__open_and_load();
> +	if (!ASSERT_OK_PTR(obj, "open and load"))
> +		return;
> +
> +	main_fd = bpf_program__fd(obj->progs.entry);
> +	if (!ASSERT_GE(main_fd, 0, "entry prog fd"))
> +		goto out;
> +
> +	map_fd = bpf_map__fd(obj->maps.jmp_table);
> +	if (!ASSERT_GE(map_fd, 0, "jmp_table map fd"))
> +		goto out;
> +
> +	prog_fd = bpf_program__fd(obj->progs.classifier_0);
> +	if (!ASSERT_GE(prog_fd, 0, "classifier_0 prog fd"))
> +		goto out;
> +
> +	i = 0;
> +	err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
> +	if (!ASSERT_OK(err, "jmp_table map update"))
> +		goto out;
> +
> +	err = bpf_prog_test_run_opts(main_fd, &topts);
> +	ASSERT_OK(err, "entry prog test run");
> +	ASSERT_EQ(topts.retval, 0, "tailcall retval");
> +
> +	data_fd = bpf_map__fd(obj->maps.bss);
> +	if (!ASSERT_GE(map_fd, 0, "bss map fd"))
> +		goto out;
> +
> +	i = 0;
> +	err = bpf_map_lookup_elem(data_fd, &i, &val);
> +	ASSERT_OK(err, "bss map lookup");
> +	ASSERT_EQ(val, 1, "done flag is set");
> +
> +out:
> +	tailcall_bpf2bpf6__destroy(obj);
> +}
> +
>   void test_tailcalls(void)
>   {
>   	if (test__start_subtest("tailcall_1"))
> @@ -855,4 +908,6 @@ void test_tailcalls(void)
>   		test_tailcall_bpf2bpf_4(false);
>   	if (test__start_subtest("tailcall_bpf2bpf_5"))
>   		test_tailcall_bpf2bpf_4(true);
> +	if (test__start_subtest("tailcall_bpf2bpf_6"))
> +		test_tailcall_bpf2bpf_6();
>   }
> diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c
> new file mode 100644
> index 000000000000..256de9bcc621
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c
> @@ -0,0 +1,42 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define __unused __attribute__((always_unused))
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
> +	__uint(max_entries, 1);
> +	__uint(key_size, sizeof(__u32));
> +	__uint(value_size, sizeof(__u32));
> +} jmp_table SEC(".maps");
> +
> +int done = 0;
> +
> +SEC("tc")
> +int classifier_0(struct __sk_buff *skb __unused)
> +{
> +	done = 1;
> +	return 0;
> +}

Looks like this fails CI with:

   progs/tailcall_bpf2bpf6.c:17:40: error: unknown attribute 'always_unused' ignored [-Werror,-Wunknown-attributes]
   int classifier_0(struct __sk_buff *skb __unused)
                                          ^~~~~~~~
   progs/tailcall_bpf2bpf6.c:5:33: note: expanded from macro '__unused'
   #define __unused __attribute__((always_unused))
                                   ^~~~~~~~~~~~~
   1 error generated.
   make: *** [Makefile:509: /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tailcall_bpf2bpf6.o] Error 1
   make: *** Waiting for unfinished jobs....
   Error: Process completed with exit code 2.
