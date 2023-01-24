Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4977C67910F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbjAXGf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjAXGf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:35:26 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9355B3CE36;
        Mon, 23 Jan 2023 22:34:52 -0800 (PST)
Message-ID: <d2606312-1e04-55ff-e01e-daf83ed99836@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674542090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoQl7uUFk5a4iB7hSBnRz259kIa6WGS8ZI2M0mlcDxc=;
        b=UJ00gwjq4gFjn29yUIgtP3vJKG2pGDukPyC0hkIVIP2nqN05joUBN4WcO+osDMjimoNFlw
        jsl0LQkfUx6HI3nz1gtWCAc7b2kCr0XlXsGZTlLXXEj3jCpUP8Pj0JXXPRLcpiWXydy+1m
        UfNa2J/CmihbLVVjWaz3Ys4ifQ5VFxU=
Date:   Mon, 23 Jan 2023 22:34:36 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 7/7] selftests/bpf: introduce XDP compliance test
 tool
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com,
        bpf@vger.kernel.org
References: <cover.1674234430.git.lorenzo@kernel.org>
 <986321f8621e9367653e21b35566e7cda976b886.1674234430.git.lorenzo@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <986321f8621e9367653e21b35566e7cda976b886.1674234430.git.lorenzo@kernel.org>
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

On 1/20/23 9:16 AM, Lorenzo Bianconi wrote:
> +static __always_inline int xdp_process_echo_packet(struct xdp_md *xdp, bool dut)
> +{
> +	void *data_end = (void *)(long)xdp->data_end;
> +	__be32 saddr = dut ? tester_ip : dut_ip;
> +	__be32 daddr = dut ? dut_ip : tester_ip;
> +	void *data = (void *)(long)xdp->data;
> +	struct ethhdr *eh = data;
> +	struct tlv_hdr *tlv;
> +	struct udphdr *uh;
> +	struct iphdr *ih;
> +	__be16 port;
> +	__u8 *cmd;
> +
> +	if (eh + 1 > (struct ethhdr *)data_end)
> +		return -EINVAL;
> +
> +	if (eh->h_proto != bpf_htons(ETH_P_IP))
> +		return -EINVAL;

Both v6 and v4 support are needed as a tool.

[ ... ]

> diff --git a/tools/testing/selftests/bpf/test_xdp_features.sh b/tools/testing/selftests/bpf/test_xdp_features.sh
> new file mode 100755
> index 000000000000..98b8fd2b6c16
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_xdp_features.sh
> @@ -0,0 +1,99 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# Create 2 namespaces with two veth peers, and
> +# check reported and detected XDP capabilities
> +#
> +#   NS0(v00)              NS1(v11)
> +#       |                     |
> +#       |                     |
> +# (v01, id:111)  ------  (v10,id:222)
> +
> +readonly NS0="ns1-$(mktemp -u XXXXXX)"
> +readonly NS1="ns2-$(mktemp -u XXXXXX)"
> +ret=1
> +
> +setup() {
> +	{
> +		ip netns add ${NS0}
> +		ip netns add ${NS1}
> +
> +		ip link add v01 index 111 type veth peer name v00 netns ${NS0}
> +		ip link add v10 index 222 type veth peer name v11 netns ${NS1}
> +
> +		ip link set v01 up
> +		ip addr add 10.10.0.1/24 dev v01
> +		ip link set v01 address 00:11:22:33:44:55
> +		ip -n ${NS0} link set dev v00 up
> +		ip -n ${NS0} addr add 10.10.0.11/24 dev v00
> +		ip -n ${NS0} route add default via 10.10.0.1
> +		ip -n ${NS0} link set v00 address 00:12:22:33:44:55
> +
> +		ip link set v10 up
> +		ip addr add 10.10.1.1/24 dev v10
> +		ip link set v10 address 00:13:22:33:44:55
> +		ip -n ${NS1} link set dev v11 up
> +		ip -n ${NS1} addr add 10.10.1.11/24 dev v11
> +		ip -n ${NS1} route add default via 10.10.1.1
> +		ip -n ${NS1} link set v11 address 00:14:22:33:44:55
> +
> +		sysctl -w net.ipv4.ip_forward=1
> +		# Enable XDP mode
> +		ethtool -K v01 gro on
> +		ethtool -K v01 tx-checksumming off
> +		ip netns exec ${NS0} ethtool -K v00 gro on
> +		ip netns exec ${NS0} ethtool -K v00 tx-checksumming off
> +		ethtool -K v10 gro on
> +		ethtool -K v10 tx-checksumming off
> +		ip netns exec ${NS1} ethtool -K v11 gro on
> +		ip netns exec ${NS1} ethtool -K v11 tx-checksumming off
> +	} > /dev/null 2>&1
> +}
> +
> +cleanup() {
> +	ip link del v01 2> /dev/null
> +	ip link del v10 2> /dev/null
> +	ip netns del ${NS0} 2> /dev/null
> +	ip netns del ${NS1} 2> /dev/null
> +	[ "$(pidof xdp_features)" = "" ] || kill $(pidof xdp_features) 2> /dev/null
> +}
> +
> +test_xdp_features() {
> +	setup
> +
> +	## XDP_PASS
> +	ip netns exec ${NS1} ./xdp_features -f XDP_PASS -D 10.10.1.11 -T 10.10.0.11 v11 &
> +	ip netns exec ${NS0} ./xdp_features -t -f XDP_PASS -D 10.10.1.11 -C 10.10.1.11 -T 10.10.0.11 v00
> +
> +	[ $? -ne 0 ] && exit
> +
> +	# XDP_DROP
> +	ip netns exec ${NS1} ./xdp_features -f XDP_DROP -D 10.10.1.11 -T 10.10.0.11 v11 &
> +	ip netns exec ${NS0} ./xdp_features -t -f XDP_DROP -D 10.10.1.11 -C 10.10.1.11 -T 10.10.0.11 v00
> +
> +	[ $? -ne 0 ] && exit
> +
> +	## XDP_TX
> +	./xdp_features -f XDP_TX -D 10.10.0.1 -T 10.10.0.11 v01 &
> +	ip netns exec ${NS0} ./xdp_features -t -f XDP_TX -D 10.10.0.1 -C 10.10.0.1 -T 10.10.0.11 v00
> +
> +	## XDP_REDIRECT
> +	ip netns exec ${NS1} ./xdp_features -f XDP_REDIRECT -D 10.10.1.11 -T 10.10.0.11 v11 &
> +	ip netns exec ${NS0} ./xdp_features -t -f XDP_REDIRECT -D 10.10.1.11 -C 10.10.1.11 -T 10.10.0.11 v00
> +
> +	[ $? -ne 0 ] && exit
> +
> +	## XDP_NDO_XMIT
> +	./xdp_features -f XDP_NDO_XMIT -D 10.10.0.1 -T 10.10.0.11 v01 &
> +	ip netns exec ${NS0} ./xdp_features -t -f XDP_NDO_XMIT -D 10.10.0.1 -C 10.10.0.1 -T 10.10.0.11 v00
> +
> +	ret=$?
> +	cleanup
> +}
> +
> +set -e
> +trap cleanup 2 3 6 9
> +
> +test_xdp_features

This won't be run by bpf CI.

A selftest in test_progs is needed to test the libbpf changes in patch 6.

