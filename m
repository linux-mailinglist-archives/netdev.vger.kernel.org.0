Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D755F3FF7
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 11:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbiJDJkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 05:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiJDJjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 05:39:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A30138
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 02:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664876179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5+/fBSOuvj7TaWlAMwBkpH+OOamgAoEsUE6L/aWHraA=;
        b=IspTTi8i8c7YyKK8Ugu0epdTLVKFwVftc9Mn/t9sVVNvmAw/cni5AfiIz6necCl5/bd5BW
        uAECA8qqztsGxcAXcJhfpBxSPaOgVKeYhBsE7Xvj2wC2HiadBQUgMsuho6PwCUjiFmnmXX
        M9ryiZiAviIkBd2YVJz8r4R1YGaopKI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-27-a63NRn9bO92qPgETEDJ88Q-1; Tue, 04 Oct 2022 05:36:18 -0400
X-MC-Unique: a63NRn9bO92qPgETEDJ88Q-1
Received: by mail-wm1-f69.google.com with SMTP id j14-20020a05600c1c0e00b003bd44dc4c5cso421105wms.2
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 02:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=5+/fBSOuvj7TaWlAMwBkpH+OOamgAoEsUE6L/aWHraA=;
        b=FCPTgGRKur8BIEj0rW3hq2lQ+RjBWAldTxi+ogeH+lGPw9acxxzvTt8VH+CPodhHUi
         N0nuuG3WWXowxXi0bpwlCGxBWmTpt7MLl6gHSBmhHlW8MwxXbsRH2ZAY75QaoJKXdw8x
         Iy9y0MgiH9V/53KKOe4XEm47xcY74w6/waRDOIuK9H0Qf1LwMJsXbjRUm8YWQP1Yvo3b
         SBBGJdgBPzb0Hxn6IQ2GGx5bPGWHaqTell7F+24em959/vgfDWQjCBeYaBdDpGRxqW2B
         3uIauSv0K04QynrLMHf4WjJfo/EvmWdB2spnylBBB/UPd7iBhcKYKVNTdVAybKD4bbB1
         4DqA==
X-Gm-Message-State: ACrzQf1KfIDOtmtBfKCZZoEf7v6eNDV9pwecVYKoacmXUMTAiXP9uhy0
        MMJZtjuSh95B+ju0XOQhzUDE+LC3sQ4XTCqRHnvCRBAMaIFw3wLQWJb5VAblPf2vqsJMckJzrY5
        EJmVgwPWzaiIpSuR4
X-Received: by 2002:a05:6000:1d8b:b0:22a:c046:946d with SMTP id bk11-20020a0560001d8b00b0022ac046946dmr15704455wrb.249.1664876176839;
        Tue, 04 Oct 2022 02:36:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM58ShqSt9Uy1Ms63LJUwKLKxMzOwINvDcN7gbpiFrVBU7s+wKH1BRG8aaQeGB1UOOKj/LB4OQ==
X-Received: by 2002:a05:6000:1d8b:b0:22a:c046:946d with SMTP id bk11-20020a0560001d8b00b0022ac046946dmr15704438wrb.249.1664876176420;
        Tue, 04 Oct 2022 02:36:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-71.dyn.eolo.it. [146.241.97.71])
        by smtp.gmail.com with ESMTPSA id v1-20020a7bcb41000000b003b27f644488sm13984554wmj.29.2022.10.04.02.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 02:36:15 -0700 (PDT)
Message-ID: <f3d875d44afaf43250dca8f9614cab119bdf5d2c.camel@redhat.com>
Subject: Re: [PATCH net v3 2/2] selftests: add selftest for chaining of tc
 ingress handling to egress
From:   Paolo Abeni <pabeni@redhat.com>
To:     Paul Blakey <paulb@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 04 Oct 2022 11:36:14 +0200
In-Reply-To: <1664706272-10164-3-git-send-email-paulb@nvidia.com>
References: <1664706272-10164-1-git-send-email-paulb@nvidia.com>
         <1664706272-10164-3-git-send-email-paulb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2022-10-02 at 13:24 +0300, Paul Blakey wrote:
> This test runs a simple ingress tc setup between two veth pairs,
> then adds a egress->ingress rule to test the chaining of tc ingress
> pipeline to tc egress piepline.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
>  .../net/test_ingress_egress_chaining.sh       | 81 +++++++++++++++++++
>  1 file changed, 81 insertions(+)
>  create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh
> 
> diff --git a/tools/testing/selftests/net/test_ingress_egress_chaining.sh b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
> new file mode 100644
> index 000000000000..4775f5657e68
> --- /dev/null
> +++ b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
> @@ -0,0 +1,81 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# This test runs a simple ingress tc setup between two veth pairs,
> +# and chains a single egress rule to test ingress chaining to egress.
> +#
> +# Kselftest framework requirement - SKIP code is 4.
> +ksft_skip=4
> +
> +if [ "$(id -u)" -ne 0 ];then
> +	echo "SKIP: Need root privileges"
> +	exit $ksft_skip
> +fi
> +
> +if [ ! -x "$(command -v iperf)" ]; then
> +	echo "SKIP: Could not run test without iperf tool"

You just need to establish a TCP connection towards a given IP, right?

Than you can use the existing self-tests program:

# listener:
./udpgso_bench_rx -t & 

# client:
./udpgso_bench_tx -t -l <transfer time> -4  -D <listener IP>

and avoid dependencies on external tools.

> +	exit $ksft_skip
> +fi
> +
> +needed_mods="act_mirred cls_flower sch_ingress"
> +for mod in $needed_mods; do
> +	modinfo $mod &>/dev/null || { echo "SKIP: Need act_mirred module"; exit $ksft_skip; }
> +done
> +
> +ns="ns$((RANDOM%899+100))"
> +veth1="veth1$((RANDOM%899+100))"
> +veth2="veth2$((RANDOM%899+100))"
> +peer1="peer1$((RANDOM%899+100))"
> +peer2="peer2$((RANDOM%899+100))"
> +
> +function fail() {
> +	echo "FAIL: $@" >> /dev/stderr
> +	exit 1
> +}
> +
> +function cleanup() {
> +	killall -q -9 iperf
> +	ip link del $veth1 &> /dev/null
> +	ip link del $veth2 &> /dev/null
> +	ip netns del $ns &> /dev/null
> +}
> +trap cleanup EXIT
> +
> +function config() {
> +	echo "Setup veth pairs [$veth1, $peer1], and veth pair [$veth2, $peer2]"
> +	ip link add $veth1 type veth peer name $peer1
> +	ip link add $veth2 type veth peer name $peer2
> +	ifconfig $peer1 5.5.5.6/24 up

Please use the modern 'ip addr' syntax. More importantly, it's better
if you move both peers in separate netns, to avoid 'random' self-test
failure due to the specific local routing configuration.

Additionally you could pick addresses from tests blocks (192.0.2.0/24,
198.51.100.0/24, 203.0.113.0/24) or at least from private ranges.

> +	ip netns add $ns
> +	ip link set dev $peer2 netns $ns
> +	ip netns exec $ns ifconfig $peer2 5.5.5.5/24 up
> +	ifconfig $veth2 0 up
> +	ifconfig $veth1 0 up

Please use 'ip link' ...

> +
> +	echo "Add tc filter ingress->egress forwarding $veth1 <-> $veth2"
> +	tc qdisc add dev $veth2 ingress
> +	tc qdisc add dev $veth1 ingress
> +	tc filter add dev $veth2 ingress prio 1 proto all flower \
> +		action mirred egress redirect dev $veth1
> +	tc filter add dev $veth1 ingress prio 1 proto all flower \
> +		action mirred egress redirect dev $veth2
> +
> +	echo "Add tc filter egress->ingress forwarding $peer1 -> $veth1, bypassing the veth pipe"
> +	tc qdisc add dev $peer1 clsact
> +	tc filter add dev $peer1 egress prio 20 proto ip flower \
> +		action mirred ingress redirect dev $veth1
> +}
> +
> +function test_run() {
> +	echo "Run iperf"
> +	iperf -s -D

Depending on the timing, the server can create the listener socket
after that the client tried to connect, causing random failures. 

You should introduce some explicit, small, delay to give the server the
time to start-up, e.g.:

# start server
sleep 0.2
# start client


Thanks!

Paolo

