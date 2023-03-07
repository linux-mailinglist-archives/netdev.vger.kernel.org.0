Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091676AF355
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjCGTDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjCGTDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:03:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F303EA17EF
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 10:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678214881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SuQ1nsMB/zs0IOcyvM1TrraIgMD7YOFy/X9RIOTfYDo=;
        b=HsuzWlmq8jZ3w53g81NoGf5/NGOKLXBVz/2iUNCXdrvPZK7G/wtggGRXu20/WAKgrrJQ+t
        Jm6eXZEKAMETp7RHidpHpoH3LiHVxS+n7X5lfRrl6oC12qsmhcZiyBtnNJcrGPUyzSP9Qe
        a7RV7vtCk3h5lMSgCoAUh+DiBsFL4I0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-S0dKixVGNKuuNqN42L6xPg-1; Tue, 07 Mar 2023 13:31:13 -0500
X-MC-Unique: S0dKixVGNKuuNqN42L6xPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF7A5100F90F;
        Tue,  7 Mar 2023 18:31:11 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.32.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19E1E1410DD9;
        Tue,  7 Mar 2023 18:31:11 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH nf-next 6/6] selftests: add a selftest for big tcp
References: <cover.1677888566.git.lucien.xin@gmail.com>
        <05ccf9eec0b79e62d52ae65a096126546d84bea6.1677888566.git.lucien.xin@gmail.com>
Date:   Tue, 07 Mar 2023 13:31:10 -0500
In-Reply-To: <05ccf9eec0b79e62d52ae65a096126546d84bea6.1677888566.git.lucien.xin@gmail.com>
        (Xin Long's message of "Fri, 3 Mar 2023 19:12:42 -0500")
Message-ID: <f7tbkl45s7l.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> This test runs on the client-router-server topo, and monitors the traffic
> on the RX devices of router and server while sending BIG TCP packets with
> netperf from client to server. Meanwhile, it changes 'tso' on the TX devs
> and 'gro' on the RX devs. Then it checks if any BIG TCP packets appears
> on the RX devs with 'ip/ip6tables -m length ! --length 0:65535' for each
> case.
>
> Note that we also add tc action ct in link1 ingress to cover the ipv6
> jumbo packets process in nf_ct_skb_network_trim() of nf_conntrack_ovs.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

LGTM - just one question

Reviewed-by: Aaron Conole <aconole@redhat.com>

>  tools/testing/selftests/net/Makefile   |   1 +
>  tools/testing/selftests/net/big_tcp.sh | 180 +++++++++++++++++++++++++
>  2 files changed, 181 insertions(+)
>  create mode 100755 tools/testing/selftests/net/big_tcp.sh
>
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index 6cd8993454d7..099741290184 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -48,6 +48,7 @@ TEST_PROGS += l2_tos_ttl_inherit.sh
>  TEST_PROGS += bind_bhash.sh
>  TEST_PROGS += ip_local_port_range.sh
>  TEST_PROGS += rps_default_mask.sh
> +TEST_PROGS += big_tcp.sh
>  TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
>  TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
>  TEST_GEN_FILES =  socket nettest
> diff --git a/tools/testing/selftests/net/big_tcp.sh b/tools/testing/selftests/net/big_tcp.sh
> new file mode 100755
> index 000000000000..cde9a91c4797
> --- /dev/null
> +++ b/tools/testing/selftests/net/big_tcp.sh
> @@ -0,0 +1,180 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Testing For IPv4 and IPv6 BIG TCP.
> +# TOPO: CLIENT_NS (link0)<--->(link1) ROUTER_NS (link2)<--->(link3) SERVER_NS
> +
> +CLIENT_NS=$(mktemp -u client-XXXXXXXX)
> +CLIENT_IP4="198.51.100.1"
> +CLIENT_IP6="2001:db8:1::1"
> +
> +SERVER_NS=$(mktemp -u server-XXXXXXXX)
> +SERVER_IP4="203.0.113.1"
> +SERVER_IP6="2001:db8:2::1"
> +
> +ROUTER_NS=$(mktemp -u router-XXXXXXXX)
> +SERVER_GW4="203.0.113.2"
> +CLIENT_GW4="198.51.100.2"
> +SERVER_GW6="2001:db8:2::2"
> +CLIENT_GW6="2001:db8:1::2"
> +
> +MAX_SIZE=128000
> +CHK_SIZE=65535
> +
> +# Kselftest framework requirement - SKIP code is 4.
> +ksft_skip=4
> +
> +setup() {
> +	ip netns add $CLIENT_NS
> +	ip netns add $SERVER_NS
> +	ip netns add $ROUTER_NS
> +	ip -net $ROUTER_NS link add link1 type veth peer name link0 netns $CLIENT_NS
> +	ip -net $ROUTER_NS link add link2 type veth peer name link3 netns $SERVER_NS
> +
> +	ip -net $CLIENT_NS link set link0 up
> +	ip -net $CLIENT_NS link set link0 mtu 1442
> +	ip -net $CLIENT_NS addr add $CLIENT_IP4/24 dev link0
> +	ip -net $CLIENT_NS addr add $CLIENT_IP6/64 dev link0 nodad
> +	ip -net $CLIENT_NS route add $SERVER_IP4 dev link0 via $CLIENT_GW4
> +	ip -net $CLIENT_NS route add $SERVER_IP6 dev link0 via $CLIENT_GW6
> +	ip -net $CLIENT_NS link set dev link0 \
> +		gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
> +	ip -net $CLIENT_NS link set dev link0 \
> +		gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
> +	ip net exec $CLIENT_NS sysctl -wq net.ipv4.tcp_window_scaling=10
> +
> +	ip -net $ROUTER_NS link set link1 up
> +	ip -net $ROUTER_NS link set link2 up
> +	ip -net $ROUTER_NS addr add $CLIENT_GW4/24 dev link1
> +	ip -net $ROUTER_NS addr add $CLIENT_GW6/64 dev link1 nodad
> +	ip -net $ROUTER_NS addr add $SERVER_GW4/24 dev link2
> +	ip -net $ROUTER_NS addr add $SERVER_GW6/64 dev link2 nodad
> +	ip -net $ROUTER_NS link set dev link1 \
> +		gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
> +	ip -net $ROUTER_NS link set dev link2 \
> +		gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
> +	ip -net $ROUTER_NS link set dev link1 \
> +		gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
> +	ip -net $ROUTER_NS link set dev link2 \
> +		gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
> +	# test for nf_ct_skb_network_trim in nf_conntrack_ovs used by TC ct action.
> +	ip net exec $ROUTER_NS tc qdisc add dev link1 ingress
> +	ip net exec $ROUTER_NS tc filter add dev link1 ingress \
> +		proto ip flower ip_proto tcp action ct
> +	ip net exec $ROUTER_NS tc filter add dev link1 ingress \
> +		proto ipv6 flower ip_proto tcp action ct
> +	ip net exec $ROUTER_NS sysctl -wq net.ipv4.ip_forward=1
> +	ip net exec $ROUTER_NS sysctl -wq net.ipv6.conf.all.forwarding=1
> +
> +	ip -net $SERVER_NS link set link3 up
> +	ip -net $SERVER_NS addr add $SERVER_IP4/24 dev link3
> +	ip -net $SERVER_NS addr add $SERVER_IP6/64 dev link3 nodad
> +	ip -net $SERVER_NS route add $CLIENT_IP4 dev link3 via $SERVER_GW4
> +	ip -net $SERVER_NS route add $CLIENT_IP6 dev link3 via $SERVER_GW6
> +	ip -net $SERVER_NS link set dev link3 \
> +		gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
> +	ip -net $SERVER_NS link set dev link3 \
> +		gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
> +	ip net exec $SERVER_NS sysctl -wq net.ipv4.tcp_window_scaling=10
> +	ip net exec $SERVER_NS netserver 2>&1 >/dev/null
> +}
> +
> +cleanup() {
> +	ip net exec $SERVER_NS pkill netserver
> +	ip -net $ROUTER_NS link del link1
> +	ip -net $ROUTER_NS link del link2
> +	ip netns del "$CLIENT_NS"
> +	ip netns del "$SERVER_NS"
> +	ip netns del "$ROUTER_NS"
> +}
> +
> +start_counter() {
> +	local ipt="iptables"
> +	local iface=$1
> +	local netns=$2
> +
> +	[ "$NF" = "6" ] && ipt="ip6tables"
> +	ip net exec $netns $ipt -t raw -A PREROUTING -i $iface \
> +		-m length ! --length 0:$CHK_SIZE -j ACCEPT
> +}
> +
> +check_counter() {
> +	local ipt="iptables"
> +	local iface=$1
> +	local netns=$2
> +
> +	[ "$NF" = "6" ] && ipt="ip6tables"
> +	test `ip net exec $netns $ipt -t raw -L -v |grep $iface | awk '{print $1}'` != "0"
> +}
> +
> +stop_counter() {
> +	local ipt="iptables"
> +	local iface=$1
> +	local netns=$2
> +
> +	[ "$NF" = "6" ] && ipt="ip6tables"
> +	ip net exec $netns $ipt -t raw -D PREROUTING -i $iface \
> +		-m length ! --length 0:$CHK_SIZE -j ACCEPT
> +}
> +
> +do_netperf() {
> +	local serip=$SERVER_IP4
> +	local netns=$1
> +
> +	[ "$NF" = "6" ] && serip=$SERVER_IP6
> +	ip net exec $netns netperf -$NF -t TCP_STREAM -H $serip 2>&1 >/dev/null
> +}
> +
> +do_test() {
> +	local cli_tso=$1
> +	local gw_gro=$2
> +	local gw_tso=$3
> +	local ser_gro=$4
> +	local ret="PASS"
> +
> +	ip net exec $CLIENT_NS ethtool -K link0 tso $cli_tso
> +	ip net exec $ROUTER_NS ethtool -K link1 gro $gw_gro
> +	ip net exec $ROUTER_NS ethtool -K link2 tso $gw_tso
> +	ip net exec $SERVER_NS ethtool -K link3 gro $ser_gro
> +
> +	start_counter link1 $ROUTER_NS
> +	start_counter link3 $SERVER_NS
> +	do_netperf $CLIENT_NS
> +
> +	if check_counter link1 $ROUTER_NS; then
> +		check_counter link3 $SERVER_NS || ret="FAIL_on_link3"
> +	else
> +		ret="FAIL_on_link1"
> +	fi
> +
> +	stop_counter link1 $ROUTER_NS
> +	stop_counter link3 $SERVER_NS
> +	printf "%-9s %-8s %-8s %-8s: [%s]\n" \
> +		$cli_tso $gw_gro $gw_tso $ser_gro $ret
> +	test $ret = "PASS"
> +}
> +
> +testup() {
> +	echo "CLI GSO | GW GRO | GW GSO | SER GRO" && \
> +	do_test "on"  "on"  "on"  "on"  && \
> +	do_test "on"  "off" "on"  "off" && \
> +	do_test "off" "on"  "on"  "on"  && \
> +	do_test "on"  "on"  "off" "on"  && \
> +	do_test "off" "on"  "off" "on"
> +}
> +
> +if ! netperf -V &> /dev/null; then

Is it ever possible that we get netperf without netserver?

> +	echo "SKIP: Could not run test without netperf tool"
> +	exit $ksft_skip
> +fi
> +
> +if ! ip link help 2>&1 | grep gso_ipv4_max_size &> /dev/null; then
> +	echo "SKIP: Could not run test without gso/gro_ipv4_max_size supported in ip-link"
> +	exit $ksft_skip
> +fi
> +
> +trap cleanup EXIT
> +setup && echo "Testing for BIG TCP:" && \
> +NF=4 testup && echo "***v4 Tests Done***" && \
> +NF=6 testup && echo "***v6 Tests Done***"
> +exit $?

