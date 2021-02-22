Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DC9321CF4
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhBVQ2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:28:33 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:60986 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231687AbhBVQ1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 11:27:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614011158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gFwSZ76WjdQwNEdZs4h/2Dxi/0tIAwu6oGqtiB8pQwM=;
        b=XKfDFBab9A641iF9hH3I/9/qnhX4gjYFFb2iJaASnDdDG0ipCjTVDb8zJXI/L3c5n/kISd
        +Rje0v3X6DCHc+ZDlk8dGBMBkSJCzEKFHzo/ZGxW62LddtAqz0ZzJH3Pk6GE3UlfXYBNmk
        4lhMThOBK5W4QZeTMWd0S0K0DV1CnW4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8caa1da0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 22 Feb 2021 16:25:58 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH net 3/7] wireguard: selftests: test multiple parallel streams
Date:   Mon, 22 Feb 2021 17:25:45 +0100
Message-Id: <20210222162549.3252778-4-Jason@zx2c4.com>
In-Reply-To: <20210222162549.3252778-1-Jason@zx2c4.com>
References: <20210222162549.3252778-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to test ndo_start_xmit being called in parallel, explicitly add
separate tests, which should all run on different cores. This should
help tease out bugs associated with queueing up packets from different
cores in parallel. Currently, it hasn't found those types of bugs, but
given future planned work, this is a useful regression to avoid.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/netns.sh | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index 74c69b75f6f5..7ed7cd95e58f 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -39,7 +39,7 @@ ip0() { pretty 0 "ip $*"; ip -n $netns0 "$@"; }
 ip1() { pretty 1 "ip $*"; ip -n $netns1 "$@"; }
 ip2() { pretty 2 "ip $*"; ip -n $netns2 "$@"; }
 sleep() { read -t "$1" -N 1 || true; }
-waitiperf() { pretty "${1//*-}" "wait for iperf:5201 pid $2"; while [[ $(ss -N "$1" -tlpH 'sport = 5201') != *\"iperf3\",pid=$2,fd=* ]]; do sleep 0.1; done; }
+waitiperf() { pretty "${1//*-}" "wait for iperf:${3:-5201} pid $2"; while [[ $(ss -N "$1" -tlpH "sport = ${3:-5201}") != *\"iperf3\",pid=$2,fd=* ]]; do sleep 0.1; done; }
 waitncatudp() { pretty "${1//*-}" "wait for udp:1111 pid $2"; while [[ $(ss -N "$1" -ulpH 'sport = 1111') != *\"ncat\",pid=$2,fd=* ]]; do sleep 0.1; done; }
 waitiface() { pretty "${1//*-}" "wait for $2 to come up"; ip netns exec "$1" bash -c "while [[ \$(< \"/sys/class/net/$2/operstate\") != up ]]; do read -t .1 -N 0 || true; done;"; }
 
@@ -141,6 +141,19 @@ tests() {
 	n2 iperf3 -s -1 -B fd00::2 &
 	waitiperf $netns2 $!
 	n1 iperf3 -Z -t 3 -b 0 -u -c fd00::2
+
+	# TCP over IPv4, in parallel
+	for max in 4 5 50; do
+		local pids=( )
+		for ((i=0; i < max; ++i)) do
+			n2 iperf3 -p $(( 5200 + i )) -s -1 -B 192.168.241.2 &
+			pids+=( $! ); waitiperf $netns2 $! $(( 5200 + i ))
+		done
+		for ((i=0; i < max; ++i)) do
+			n1 iperf3 -Z -t 3 -p $(( 5200 + i )) -c 192.168.241.2 &
+		done
+		wait "${pids[@]}"
+	done
 }
 
 [[ $(ip1 link show dev wg0) =~ mtu\ ([0-9]+) ]] && orig_mtu="${BASH_REMATCH[1]}"
-- 
2.30.1

