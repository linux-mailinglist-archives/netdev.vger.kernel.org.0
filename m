Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C04651739
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 01:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiLTArK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 19:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiLTArI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 19:47:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEB6E005;
        Mon, 19 Dec 2022 16:47:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C84FF611CD;
        Tue, 20 Dec 2022 00:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5B1C433F1;
        Tue, 20 Dec 2022 00:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671497227;
        bh=ye2paRStv9zXMRE9BONKB0vAifGW0JXnBqg9eXYK66U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTtWQOfTe8LD7T2hV9gY6BlCY4fgyiiBQREKlyvnhk0LafUE0B5fwHnaOMf/7UqMG
         Ffa8JGTsqQEZ3TLaGnc8eSIu/RG8pg1NqnHoGiZ5UZGNc4b1UwY5O7d9G1kKjUahir
         AQgslQCdi4Ei2zPEWovo363noOkZLC9IUNZTmhXKUTOcAoWpH0+20xZkVeTDVQbKyc
         /G5JGA9phlLLf2x+RoluFnr2bJ5FNM7eYJJfVPsw7NoPeXORqv9GoZ7fWtyJRCESKq
         k//ei/HLW2H/LwAt3wer+NSUXOPBZsq+QM1IVHtuZSt2P+ntptiWzQ5qyGTzdzdstL
         a0toXaluPxbgg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf 2/2] selftests/bpf: tunnel: add sanity test for checksums
Date:   Mon, 19 Dec 2022 16:47:01 -0800
Message-Id: <20221220004701.402165-2-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220004701.402165-1-kuba@kernel.org>
References: <20221220004701.402165-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple netdevsim based test. Netdevsim will validate xmit'ed
packets, in particular we care about checksum sanity (along
the lines of checks inside skb_checksum_help()). Triggering
skb_checksum_help() directly would require the right HW device
or a crypto device setup, netdevsim is much simpler.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/netdev.c                |  5 ++++
 tools/testing/selftests/bpf/test_tc_tunnel.sh | 27 +++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 6db6a75ff9b9..e4808a6d37a4 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -33,6 +33,11 @@ static netdev_tx_t nsim_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (!nsim_ipsec_tx(ns, skb))
 		goto out;
 
+	/* Validate the packet */
+	if (skb->ip_summed == CHECKSUM_PARTIAL)
+		WARN_ON_ONCE((unsigned int)skb_checksum_start_offset(skb) >=
+			     skb_headlen(skb));
+
 	u64_stats_update_begin(&ns->syncp);
 	ns->tx_packets++;
 	ns->tx_bytes += skb->len;
diff --git a/tools/testing/selftests/bpf/test_tc_tunnel.sh b/tools/testing/selftests/bpf/test_tc_tunnel.sh
index 334bdfeab940..4dac87f6a6fa 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -15,6 +15,7 @@ readonly ns1_v4=192.168.1.1
 readonly ns2_v4=192.168.1.2
 readonly ns1_v6=fd::1
 readonly ns2_v6=fd::2
+readonly nsim_v4=192.168.2.1
 
 # Must match port used by bpf program
 readonly udpport=5555
@@ -67,6 +68,10 @@ cleanup() {
 	if [[ -n $server_pid ]]; then
 		kill $server_pid 2> /dev/null
 	fi
+
+	if [ -e /sys/bus/netdevsim/devices/netdevsim1 ]; then
+	    echo 1 > /sys/bus/netdevsim/del_device
+	fi
 }
 
 server_listen() {
@@ -93,6 +98,25 @@ verify_data() {
 	fi
 }
 
+decap_sanity() {
+    echo "test decap sanity"
+    modprobe netdevsim
+    echo 1 1 > /sys/bus/netdevsim/new_device
+    udevadm settle
+    nsim=$(ls /sys/bus/netdevsim/devices/netdevsim1/net/)
+    ip link set dev $nsim up
+    ip addr add dev $nsim $nsim_v4/24
+
+    tc qdisc add dev $nsim clsact
+    tc filter add dev $nsim egress \
+       bpf direct-action object-file ${BPF_FILE} section decap
+
+    echo abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz | \
+	nc -u 192.168.2.2 7777
+
+    echo 1 > /sys/bus/netdevsim/del_device
+}
+
 set -e
 
 # no arguments: automated test, run all
@@ -138,6 +162,9 @@ if [[ "$#" -eq "0" ]]; then
 		$0 ipv6 ip6udp $mac 2000
 	done
 
+	echo "decap sanity check"
+	decap_sanity
+
 	echo "OK. All tests passed"
 	exit 0
 fi
-- 
2.38.1

