Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B5767605A
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjATWpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjATWpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:45:15 -0500
X-Greylist: delayed 534 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Jan 2023 14:45:06 PST
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C359213DD4
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:45:06 -0800 (PST)
Message-ID: <dfa5590d-17a6-a1bc-62ef-235f0190f037@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674253831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WbzdOZemLwi6FEhtFm4nXTHzZGOKvBEDZLdlVO+4Lkw=;
        b=a+u7IjPFjD+q6wRYBkodl/g9Lt+NNWcuFa6fXZIFhKW0t+s4eA0heh+PG4tNZaPQi7Kz1W
        jKjJBYWvy/3QQfB1q/s5fBd5NfIqNh3eXWChqlOskTCFGXx9SX7vAJay8vITFi5QOS8y0F
        UXxG0+9JBSubpdke2ArJPVTO4+nH8EQ=
Date:   Fri, 20 Jan 2023 14:30:20 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v8 17/17] selftests/bpf: Simple program to dump
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
References: <20230119221536.3349901-1-sdf@google.com>
 <20230119221536.3349901-18-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230119221536.3349901-18-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/23 2:15 PM, Stanislav Fomichev wrote:
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index e09bef2b7502..9c961d2d868e 100644
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
> @@ -383,6 +383,7 @@ test_subskeleton.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton_lib
>   test_subskeleton_lib.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton_lib.bpf.o
>   test_usdt.skel.h-deps := test_usdt.bpf.o test_usdt_multispec.bpf.o
>   xsk_xdp_progs.skel.h-deps := xsk_xdp_progs.bpf.o
> +xdp_hw_metadata.skel.h-deps := xdp_hw_metadata.bpf.o
>   
>   LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
>   
> @@ -580,6 +581,10 @@ $(OUTPUT)/xskxceiver: xskxceiver.c $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel.
>   	$(call msg,BINARY,,$@)
>   	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
>   
> +$(OUTPUT)/xdp_hw_metadata: xdp_hw_metadata.c $(OUTPUT)/network_helpers.o $(OUTPUT)/xsk.o $(OUTPUT)/xdp_hw_metadata.skel.h | $(OUTPUT)
> +	$(call msg,BINARY,,$@)
> +	$(Q)$(CC) $(CFLAGS) -static $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@

My dev machine fails on '-static' :(. A few machines that I got also don't have 
those static libraries, so likely the default environment that I got here.

It seems to be the only binary using '-static' in this Makefile. Can it be 
removed or at least not the default?

