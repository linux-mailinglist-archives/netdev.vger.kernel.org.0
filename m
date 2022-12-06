Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1558C643D79
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 08:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbiLFHNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 02:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLFHNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 02:13:23 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C8C14000;
        Mon,  5 Dec 2022 23:13:22 -0800 (PST)
Message-ID: <1892a6ce-bbad-20af-20b4-cc23fb7a6206@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670310800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QyALjt60Qi+vXADvlWHNeABSReSlCiteUK32rWt9Xwk=;
        b=jZUQkv6WLmtF+hrG0RndBm76BNpFrr5y3177yAadKPfFVwYX8yZUp71uZWRhOmeWBD1Cs5
        8QMgY21jrAq4CEcn51mzPf2Ges+CatUtm+TRD8JtknvvQHix7ptd/ApG/cNH9p7PQBHkw1
        wi76R2sCwxKeYtt1Uxkmm3riv5Kxq0M=
Date:   Mon, 5 Dec 2022 23:13:12 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next,v6 4/4] selftests/bpf: add xfrm_info tests
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org, liuhangbin@gmail.com,
        lixiaoyan@google.com, jtoppins@redhat.com, kuniyu@amazon.co.jp
References: <20221203084659.1837829-1-eyal.birger@gmail.com>
 <20221203084659.1837829-5-eyal.birger@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221203084659.1837829-5-eyal.birger@gmail.com>
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

On 12/3/22 12:46 AM, Eyal Birger wrote:
> +#define PING_ARGS "-i 0.01 -c 3 -w 10 -q"

Applied with a few changes.

PING_ARGS is removed because it is unused.

[ ... ]

> +static int test_xfrm_ping(struct xfrm_info *skel, u32 if_id)
> +{
> +	skel->bss->req_if_id = if_id;
> +
> +	SYS("ping -i 0.01 -c 3 -w 10 -q 192.168.1.200 > /dev/null");
> +
> +	if (!ASSERT_EQ(skel->bss->resp_if_id, if_id, "if_id"))
> +		goto fail;
> +
> +	return 0;
> +fail:
> +	return -1;
> +}
> +
> +static void _test_xfrm_info(void)
> +{
> +	LIBBPF_OPTS(bpf_tc_hook, tc_hook, .attach_point = BPF_TC_INGRESS);
> +	int get_xfrm_info_prog_fd, set_xfrm_info_prog_fd;
> +	struct xfrm_info *skel = NULL;
> +	struct nstoken *nstoken = NULL;
> +	int ifindex;
> +
> +	/* load and attach bpf progs to ipsec dev tc hook point */
> +	skel = xfrm_info__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "xfrm_info__open_and_load"))
> +		goto done;
> +	nstoken = open_netns(NS0);
> +	if (!ASSERT_OK_PTR(nstoken, "setns " NS0))
> +		goto done;
> +	ifindex = if_nametoindex("ipsec0");
> +	if (!ASSERT_NEQ(ifindex, 0, "ipsec0 ifindex"))
> +		goto done;
> +	tc_hook.ifindex = ifindex;
> +	set_xfrm_info_prog_fd = bpf_program__fd(skel->progs.set_xfrm_info);
> +	get_xfrm_info_prog_fd = bpf_program__fd(skel->progs.get_xfrm_info);
> +	if (!ASSERT_GE(set_xfrm_info_prog_fd, 0, "bpf_program__fd"))
> +		goto done;
> +	if (!ASSERT_GE(get_xfrm_info_prog_fd, 0, "bpf_program__fd"))
> +		goto done;
> +	if (attach_tc_prog(&tc_hook, get_xfrm_info_prog_fd,
> +			   set_xfrm_info_prog_fd))
> +		goto done;
> +
> +	/* perform test */
> +	if (!ASSERT_EQ(test_xfrm_ping(skel, IF_ID_0_TO_1), 0, "ping " NS1))
> +		goto done;
> +	if (!ASSERT_EQ(test_xfrm_ping(skel, IF_ID_0_TO_2), 0, "ping " NS2))
> +		goto done;
> +
> +done:
> +	if (nstoken)
> +		close_netns(nstoken);
> +	if (skel)

NULL check is removed.  xfrm_info__destroy() can handle NULL.

> +		xfrm_info__destroy(skel);
> +}

