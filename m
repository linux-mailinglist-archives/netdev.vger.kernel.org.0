Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247846549DC
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 01:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiLWAxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 19:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLWAxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 19:53:13 -0500
Received: from out-45.mta0.migadu.com (out-45.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4B12125F
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 16:53:11 -0800 (PST)
Message-ID: <95e79329-b7c9-550b-290e-e5e4ea6e7a01@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671756789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8F4nSg+GS23zqd95hLuwa8elF3fLcZRY59bli0MHJA=;
        b=bPnReTNEzwB68kA42490iey6Obp/BMjIrwRzQJzOY1mxHfIp4iKE/mUPhH8wg7U15k/gGC
        pMQj5UhRnNe6/IotGuTqCt6fQkl1iCPAV694rFXyARffG7o7INDxjLs4rfoSQAIzEYkC1I
        IL7cYf+gdxmS64ayyjzeGTtS2yLC08s=
Date:   Thu, 22 Dec 2022 16:53:03 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v5 17/17] selftests/bpf: Simple program to dump
 XDP RX metadata
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20221220222043.3348718-1-sdf@google.com>
 <20221220222043.3348718-18-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221220222043.3348718-18-sdf@google.com>
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

On 12/20/22 2:20 PM, Stanislav Fomichev wrote:
> To be used for verification of driver implementations. Note that
> the skb path is gone from the series, but I'm still keeping the
> implementation for any possible future work.
> 
> $ xdp_hw_metadata <ifname>
> 
> On the other machine:
> 
> $ echo -n xdp | nc -u -q1 <target> 9091 # for AF_XDP
> $ echo -n skb | nc -u -q1 <target> 9092 # for skb
> 
> Sample output:
> 
>    # xdp
>    xsk_ring_cons__peek: 1
>    0x19f9090: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
>    rx_timestamp_supported: 1
>    rx_timestamp: 1667850075063948829
>    0x19f9090: complete idx=8 addr=8000
> 
>    # skb
>    found skb hwtstamp = 1668314052.854274681
> 
> Decoding:
>    # xdp
>    rx_timestamp=1667850075.063948829
> 
>    $ date -d @1667850075
>    Mon Nov  7 11:41:15 AM PST 2022
>    $ date
>    Mon Nov  7 11:42:05 AM PST 2022
> 
>    # skb
>    $ date -d @1668314052
>    Sat Nov 12 08:34:12 PM PST 2022
>    $ date
>    Sat Nov 12 08:37:06 PM PST 2022
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   tools/testing/selftests/bpf/.gitignore        |   1 +
>   tools/testing/selftests/bpf/Makefile          |   6 +-
>   .../selftests/bpf/progs/xdp_hw_metadata.c     |  81 ++++
>   tools/testing/selftests/bpf/xdp_hw_metadata.c | 405 ++++++++++++++++++
>   4 files changed, 492 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>   create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
> 
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index 07d2d0a8c5cb..01e3baeefd4f 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -46,3 +46,4 @@ test_cpp
>   xskxceiver
>   xdp_redirect_multi
>   xdp_synproxy
> +xdp_hw_metadata
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index e6cbc04a7920..b7d5d3aa554e 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -83,7 +83,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>   	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
>   	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
> -	xskxceiver xdp_redirect_multi xdp_synproxy veristat
> +	xskxceiver xdp_redirect_multi xdp_synproxy veristat xdp_hw_metadata
>   
>   TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/sign-file
>   TEST_GEN_FILES += liburandom_read.so
> @@ -241,6 +241,9 @@ $(OUTPUT)/test_maps: $(TESTING_HELPERS)
>   $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
>   $(OUTPUT)/xsk.o: $(BPFOBJ)
>   $(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
> +$(OUTPUT)/xdp_hw_metadata: $(OUTPUT)/xsk.o $(OUTPUT)/xdp_hw_metadata.skel.h
> +$(OUTPUT)/xdp_hw_metadata: $(OUTPUT)/network_helpers.o
> +$(OUTPUT)/xdp_hw_metadata: LDFLAGS += -static


This test binary fails to build for llvm.  gcc looks fine though.  The CI tests 
cannot be run on this set because of this.  Please take a look:

https://github.com/kernel-patches/bpf/actions/runs/3745257032/jobs/6359527599#step:11:2202


I only have minor comments on the set.  Looking forward to v6.
