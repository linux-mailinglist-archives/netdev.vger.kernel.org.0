Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E39F6529C4
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 00:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiLTXVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 18:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiLTXVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 18:21:13 -0500
Received: from out-127.mta0.migadu.com (out-127.mta0.migadu.com [IPv6:2001:41d0:1004:224b::7f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84B4B6E
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 15:21:12 -0800 (PST)
Message-ID: <7372590a-f40b-17d1-f780-3bd1ce4f30bb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671578470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3rJJdWwF5tZwAZGlG9S4+BM5oF4WqZa/1LhVRAvblzc=;
        b=uHIdeFu+nq1WAZ3W9XuXsb344ouUymlyEkd5bwRxF9F1xgNXNidtYi9YjEdUDAQdh7DG9L
        Rdv/FYTx7fZdOJ8lrsyXUDqGlBuyMOhCzHab/IY2W+b9/XV2Neru/ahYhsPM/7tlycSqWN
        pSXSWvB4z2MUsPdsTRU3AWJNFIHos0s=
Date:   Tue, 20 Dec 2022 15:21:08 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf 2/2] selftests/bpf: tunnel: add sanity test for
 checksums
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net
References: <20221220004701.402165-1-kuba@kernel.org>
 <20221220004701.402165-2-kuba@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221220004701.402165-2-kuba@kernel.org>
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

On 12/19/22 4:47 PM, Jakub Kicinski wrote:
> Simple netdevsim based test. Netdevsim will validate xmit'ed
> packets, in particular we care about checksum sanity (along
> the lines of checks inside skb_checksum_help()). Triggering
> skb_checksum_help() directly would require the right HW device
> or a crypto device setup, netdevsim is much simpler.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   drivers/net/netdevsim/netdev.c                |  5 ++++
>   tools/testing/selftests/bpf/test_tc_tunnel.sh | 27 +++++++++++++++++++
>   2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
> index 6db6a75ff9b9..e4808a6d37a4 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -33,6 +33,11 @@ static netdev_tx_t nsim_start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	if (!nsim_ipsec_tx(ns, skb))
>   		goto out;
>   
> +	/* Validate the packet */
> +	if (skb->ip_summed == CHECKSUM_PARTIAL)
> +		WARN_ON_ONCE((unsigned int)skb_checksum_start_offset(skb) >=
> +			     skb_headlen(skb));
> +
>   	u64_stats_update_begin(&ns->syncp);
>   	ns->tx_packets++;
>   	ns->tx_bytes += skb->len;
> diff --git a/tools/testing/selftests/bpf/test_tc_tunnel.sh b/tools/testing/selftests/bpf/test_tc_tunnel.sh
> index 334bdfeab940..4dac87f6a6fa 100755
> --- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
> +++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
> @@ -15,6 +15,7 @@ readonly ns1_v4=192.168.1.1
>   readonly ns2_v4=192.168.1.2
>   readonly ns1_v6=fd::1
>   readonly ns2_v6=fd::2
> +readonly nsim_v4=192.168.2.1
>   
>   # Must match port used by bpf program
>   readonly udpport=5555
> @@ -67,6 +68,10 @@ cleanup() {
>   	if [[ -n $server_pid ]]; then
>   		kill $server_pid 2> /dev/null
>   	fi
> +
> +	if [ -e /sys/bus/netdevsim/devices/netdevsim1 ]; then
> +	    echo 1 > /sys/bus/netdevsim/del_device
> +	fi
>   }
>   
>   server_listen() {
> @@ -93,6 +98,25 @@ verify_data() {
>   	fi
>   }
>   
> +decap_sanity() {
> +    echo "test decap sanity"
> +    modprobe netdevsim
> +    echo 1 1 > /sys/bus/netdevsim/new_device
> +    udevadm settle
> +    nsim=$(ls /sys/bus/netdevsim/devices/netdevsim1/net/)
> +    ip link set dev $nsim up
> +    ip addr add dev $nsim $nsim_v4/24
> +
> +    tc qdisc add dev $nsim clsact
> +    tc filter add dev $nsim egress \
> +       bpf direct-action object-file ${BPF_FILE} section decap
> +
> +    echo abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz | \
> +	nc -u 192.168.2.2 7777

Thanks for the fix and the idea on how to test it.

I have posted a patch to translate this test to a test for test_progs that can 
finish and exit such that it can be run continuously in CI.  The test attaches a 
tc-bpf at lo and the bpf prog directly checks for the skb->ip_summed == 
CHECKSUM_NONE and the broken csum_start condition.

If the test_progs patch looks good, patch 1 can be landed first and then land 
the test_progs patch.  wdyt?
