Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE7069FFC2
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 00:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjBVXof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 18:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjBVXoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 18:44:34 -0500
Received: from out-1.mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6904437546
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 15:44:25 -0800 (PST)
Message-ID: <8781d9c2-2352-ac0b-9d79-82be8eb404ff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677109463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zOfnUIOeegu6Q0Q517qiQX6rk85cNNgrg389FKVsBY=;
        b=a3DJBgHVFwC2IwdYf9pZnscKpcARqtHBZxjeVP8T+3JBCckmMdbiJJrt/R7XG8/gKhDCEX
        6T/nUtEloErFXuPcOn+2gToeIG+S1bz0joco8kuLX6+MqzoBMq6HMsvj/8Eye/UDeieKkF
        3x4ONBCf+AGfPZNst1dlGkgQk9l5O/8=
Date:   Wed, 22 Feb 2023 15:44:17 -0800
MIME-Version: 1.0
Subject: Re: [PATCHv2 bpf-next] selftests/bpf: run mptcp in a dedicated netns
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
References: <20230219070124.3900561-1-liuhangbin@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230219070124.3900561-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/23 11:01 PM, Hangbin Liu wrote:
> The current mptcp test is run in init netns. If the user or default
> system config disabled mptcp, the test will fail. Let's run the mptcp
> test in a dedicated netns to avoid none kernel default mptcp setting.
> 
> Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v2: remove unneed close_cgroup_fd goto label.
> ---
>   .../testing/selftests/bpf/prog_tests/mptcp.c  | 27 +++++++++++++++++--
>   1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> index 59f08d6d1d53..dbe2bcfd3b38 100644
> --- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> @@ -7,6 +7,16 @@
>   #include "network_helpers.h"
>   #include "mptcp_sock.skel.h"
>   
> +#define SYS(fmt, ...)						\
> +	({							\
> +		char cmd[1024];					\
> +		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
> +		if (!ASSERT_OK(system(cmd), cmd))		\
> +			goto fail;				\
> +	})
> +
> +#define NS_TEST "mptcp_ns"
> +
>   #ifndef TCP_CA_NAME_MAX
>   #define TCP_CA_NAME_MAX	16
>   #endif
> @@ -138,12 +148,20 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
>   
>   static void test_base(void)
>   {
> +	struct nstoken *nstoken = NULL;
>   	int server_fd, cgroup_fd;
>   
>   	cgroup_fd = test__join_cgroup("/mptcp");
>   	if (!ASSERT_GE(cgroup_fd, 0, "test__join_cgroup"))
>   		return;
>   
> +	SYS("ip netns add %s", NS_TEST);
> +	SYS("ip -net %s link set dev lo up", NS_TEST);
> +
> +	nstoken = open_netns(NS_TEST);
> +	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
> +		goto fail;
> +
>   	/* without MPTCP */
>   	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
>   	if (!ASSERT_GE(server_fd, 0, "start_server"))
> @@ -157,13 +175,18 @@ static void test_base(void)
>   	/* with MPTCP */
>   	server_fd = start_mptcp_server(AF_INET, NULL, 0, 0);
>   	if (!ASSERT_GE(server_fd, 0, "start_mptcp_server"))
> -		goto close_cgroup_fd;
> +		goto fail;
>   
>   	ASSERT_OK(run_test(cgroup_fd, server_fd, true), "run_test mptcp");
>   
>   	close(server_fd);
>   
> -close_cgroup_fd:
> +fail:
> +	if (nstoken)
> +		close_netns(nstoken);
> +
> +	system("ip netns del " NS_TEST " >& /dev/null");

It needs to be "&>", like the fix in commit 98e13848cf43 ("selftests/bpf: Fix 
decap_sanity_ns cleanup").

Since it needs to respin, could you help and take this chance to put the above 
SYS() macro into the test_progs.h. Other selftests are doing similar thing also. 
If possible, it may be easier to have a configurable "goto_label" as the first arg.
