Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1B25FC02D
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 07:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJLFtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 01:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiJLFtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 01:49:41 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7205EF47;
        Tue, 11 Oct 2022 22:49:37 -0700 (PDT)
Message-ID: <43bf4a5f-dac9-4fe9-1eba-9ab9beb650aa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665553775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=40pZpkslxkeKFTGJuJ6oWOyvEYbIxCXMcmV6B+QVCKE=;
        b=FPHUHxXPavilQJi/8GZV/2hlYEaBDl6tPElHTjQ7fQtQb8R43hdTwRPYoNrrr3wNB2ys+w
        hwkxfTzI0qsGl2WNKzsbQMBhIrWF3fAfxQZbhUo1jk6z+ySK3eSa7kM4/VJPygXZIBsFAg
        3eya216VizU5VPDOjGXNmmk04iyHxeQ=
Date:   Tue, 11 Oct 2022 22:49:32 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v4 2/3] selftests/bpf: Add connmark read test
Content-Language: en-US
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        bpf@vger.kernel.org, memxor@gmail.com
References: <cover.1660254747.git.dxu@dxuuu.xyz>
 <d3bc620a491e4c626c20d80631063922cbe13e2b.1660254747.git.dxu@dxuuu.xyz>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <d3bc620a491e4c626c20d80631063922cbe13e2b.1660254747.git.dxu@dxuuu.xyz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/22 2:55 PM, Daniel Xu wrote:
> Test that the prog can read from the connection mark. This test is nice
> because it ensures progs can interact with netfilter subsystem
> correctly.
> 
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 3 ++-
>   tools/testing/selftests/bpf/progs/test_bpf_nf.c | 3 +++
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> index 88a2c0bdefec..544bf90ac2a7 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> @@ -44,7 +44,7 @@ static int connect_to_server(int srv_fd)
>   
>   static void test_bpf_nf_ct(int mode)
>   {
> -	const char *iptables = "iptables -t raw %s PREROUTING -j CT";
> +	const char *iptables = "iptables -t raw %s PREROUTING -j CONNMARK --set-mark 42/0";
Hi Daniel Xu, this test starts failing recently in CI [0]:

Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
   iptables v1.8.8 (nf_tables): Could not fetch rule set generation id: Invalid 
argument

   Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
   iptables v1.8.8 (nf_tables): Could not fetch rule set generation id: Invalid 
argument

   Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
   iptables v1.8.8 (nf_tables): Could not fetch rule set generation id: Invalid 
argument

   Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
   iptables v1.8.8 (nf_tables): Could not fetch rule set generation id: Invalid 
argument

   test_bpf_nf_ct:PASS:test_bpf_nf__open_and_load 0 nsec
   test_bpf_nf_ct:FAIL:iptables unexpected error: 1024 (errno 0)

Could you help to take a look? Thanks.

[0]: https://github.com/kernel-patches/bpf/actions/runs/3231598391/jobs/5291529292

>   	int srv_fd = -1, client_fd = -1, srv_client_fd = -1;
>   	struct sockaddr_in peer_addr = {};
>   	struct test_bpf_nf *skel;
> @@ -114,6 +114,7 @@ static void test_bpf_nf_ct(int mode)
>   	/* expected status is IPS_SEEN_REPLY */
>   	ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
>   	ASSERT_EQ(skel->data->test_exist_lookup, 0, "Test existing connection lookup");
> +	ASSERT_EQ(skel->bss->test_exist_lookup_mark, 43, "Test existing connection lookup ctmark");
>   end:
>   	if (srv_client_fd != -1)
>   		close(srv_client_fd);
> diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> index 84e0fd479794..2722441850cc 100644
> --- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> @@ -28,6 +28,7 @@ __be16 sport = 0;
>   __be32 daddr = 0;
>   __be16 dport = 0;
>   int test_exist_lookup = -ENOENT;
> +u32 test_exist_lookup_mark = 0;
>   
>   struct nf_conn;
>   
> @@ -174,6 +175,8 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
>   		       sizeof(opts_def));
>   	if (ct) {
>   		test_exist_lookup = 0;
> +		if (ct->mark == 42)
> +			test_exist_lookup_mark = 43;
>   		bpf_ct_release(ct);
>   	} else {
>   		test_exist_lookup = opts_def.error;

