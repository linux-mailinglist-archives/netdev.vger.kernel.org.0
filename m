Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C9B1521CC
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 22:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgBDVSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 16:18:07 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:54783 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbgBDVSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 16:18:07 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d035ba62;
        Tue, 4 Feb 2020 21:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=k96nb7MvprZh+3rtgopHHQc0D
        3s=; b=Qh6Gs2BK/dNCdhtFWwm7VL/EfR8c/NXzd6mdmeHt3L/YCnBj0vGbXJusY
        4likX9dZ2dfSTjd5nWxfAcry6Ads+Z46aGk9QEiEyz7BlFx/ZJWI1xvlwRrX3niq
        IIDNgs5GOI0+/Minms+Jkz33dN1aZbGBWM4mb+z0zs3Ohkqs2hbGEv5js2ykGC3O
        /eaw/nY4WmYBgI+WPoazMQGTUsIuTufJYV0WP/ntLflNn3PaLgY5TzMJVt/44q88
        fLsQtI8c0LkBQuCNMzvAmEfGrSbcSAUFWUXtzBMLFmO4a+Emzq9i2cc7N4JNZ0Uy
        iRwcbZ3bpPrQv8aigiXVzxORxMnxw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8a666ba8 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 4 Feb 2020 21:17:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 5/5] wireguard: selftests: tie socket waiting to target pid
Date:   Tue,  4 Feb 2020 22:17:29 +0100
Message-Id: <20200204211729.365431-6-Jason@zx2c4.com>
In-Reply-To: <20200204211729.365431-1-Jason@zx2c4.com>
References: <20200204211729.365431-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this, we wind up proceeding too early sometimes when the
previous process has just used the same listening port. So, we tie the
listening socket query to the specific pid we're interested in.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/netns.sh | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index b03647d1bbf6..f5ab1cda8bb5 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -38,9 +38,8 @@ ip0() { pretty 0 "ip $*"; ip -n $netns0 "$@"; }
 ip1() { pretty 1 "ip $*"; ip -n $netns1 "$@"; }
 ip2() { pretty 2 "ip $*"; ip -n $netns2 "$@"; }
 sleep() { read -t "$1" -N 1 || true; }
-waitiperf() { pretty "${1//*-}" "wait for iperf:5201"; while [[ $(ss -N "$1" -tlp 'sport = 5201') != *iperf3* ]]; do sleep 0.1; done; }
-waitncatudp() { pretty "${1//*-}" "wait for udp:1111"; while [[ $(ss -N "$1" -ulp 'sport = 1111') != *ncat* ]]; do sleep 0.1; done; }
-waitncattcp() { pretty "${1//*-}" "wait for tcp:1111"; while [[ $(ss -N "$1" -tlp 'sport = 1111') != *ncat* ]]; do sleep 0.1; done; }
+waitiperf() { pretty "${1//*-}" "wait for iperf:5201 pid $2"; while [[ $(ss -N "$1" -tlpH 'sport = 5201') != *\"iperf3\",pid=$2,fd=* ]]; do sleep 0.1; done; }
+waitncatudp() { pretty "${1//*-}" "wait for udp:1111 pid $2"; while [[ $(ss -N "$1" -ulpH 'sport = 1111') != *\"ncat\",pid=$2,fd=* ]]; do sleep 0.1; done; }
 waitiface() { pretty "${1//*-}" "wait for $2 to come up"; ip netns exec "$1" bash -c "while [[ \$(< \"/sys/class/net/$2/operstate\") != up ]]; do read -t .1 -N 0 || true; done;"; }
 
 cleanup() {
@@ -119,22 +118,22 @@ tests() {
 
 	# TCP over IPv4
 	n2 iperf3 -s -1 -B 192.168.241.2 &
-	waitiperf $netns2
+	waitiperf $netns2 $!
 	n1 iperf3 -Z -t 3 -c 192.168.241.2
 
 	# TCP over IPv6
 	n1 iperf3 -s -1 -B fd00::1 &
-	waitiperf $netns1
+	waitiperf $netns1 $!
 	n2 iperf3 -Z -t 3 -c fd00::1
 
 	# UDP over IPv4
 	n1 iperf3 -s -1 -B 192.168.241.1 &
-	waitiperf $netns1
+	waitiperf $netns1 $!
 	n2 iperf3 -Z -t 3 -b 0 -u -c 192.168.241.1
 
 	# UDP over IPv6
 	n2 iperf3 -s -1 -B fd00::2 &
-	waitiperf $netns2
+	waitiperf $netns2 $!
 	n1 iperf3 -Z -t 3 -b 0 -u -c fd00::2
 }
 
@@ -207,7 +206,7 @@ n1 ping -W 1 -c 1 192.168.241.2
 n1 wg set wg0 peer "$pub2" allowed-ips 192.168.241.0/24
 exec 4< <(n1 ncat -l -u -p 1111)
 ncat_pid=$!
-waitncatudp $netns1
+waitncatudp $netns1 $ncat_pid
 n2 ncat -u 192.168.241.1 1111 <<<"X"
 read -r -N 1 -t 1 out <&4 && [[ $out == "X" ]]
 kill $ncat_pid
@@ -216,7 +215,7 @@ n1 wg set wg0 peer "$more_specific_key" allowed-ips 192.168.241.2/32
 n2 wg set wg0 listen-port 9997
 exec 4< <(n1 ncat -l -u -p 1111)
 ncat_pid=$!
-waitncatudp $netns1
+waitncatudp $netns1 $ncat_pid
 n2 ncat -u 192.168.241.1 1111 <<<"X"
 ! read -r -N 1 -t 1 out <&4 || false
 kill $ncat_pid
-- 
2.25.0

