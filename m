Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EECF1C7C7E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgEFVd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:33:27 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55147 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgEFVdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 17:33:24 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3b160a1e;
        Wed, 6 May 2020 21:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=mail; bh=GX+qeqDmtxLd
        su2oJ5Cozz99w6I=; b=lVGsHR3DoT45UczqxBZ3Q3+K84+nlgaNQ2BiZtyQZutm
        Ng44p3zRVWblNqcuLfZS4v51cwUdOlJ5/l0eJt45p8xy+OG2W2kRTCzCLZIawA2s
        INTyP8pzGPToWS9+ovpwK4ODoMmOs8smKwMS7iwqppGvItvB4yWU2DL22rfh/4yy
        0Ue2OF8QIIjYdeFkffxFkzpHVxx0Bo5O05KVIApYk4X6V+jFC3LTkFXXObTywf3e
        9k2utGMjKzRCzMUFXtVt5tsSsCNd0wPISnMTbboC5apTqAVrLyzxFue+INkjTO3R
        BzwHxS9GJ25cnS/ofY/0Jde8FI3MmOl8S8HEw0cJ/w==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 170a1984 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 6 May 2020 21:20:38 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 2/5] wireguard: socket: remove errant restriction on looping to self
Date:   Wed,  6 May 2020 15:33:03 -0600
Message-Id: <20200506213306.1344212-3-Jason@zx2c4.com>
In-Reply-To: <20200506213306.1344212-1-Jason@zx2c4.com>
References: <20200506213306.1344212-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's already possible to create two different interfaces and loop
packets between them. This has always been possible with tunnels in the
kernel, and isn't specific to wireguard. Therefore, the networking stack
already needs to deal with that. At the very least, the packet winds up
exceeding the MTU and is discarded at that point. So, since this is
already something that happens, there's no need to forbid the not very
exceptional case of routing a packet back to the same interface; this
loop is no different than others, and we shouldn't special case it, but
rather rely on generic handling of loops in general. This also makes it
easier to do interesting things with wireguard such as onion routing.

At the same time, we add a selftest for this, ensuring that both onion
routing works and infinite routing loops do not crash the kernel. We
also add a test case for wireguard interfaces nesting packets and
sending traffic between each other, as well as the loop in this case
too. We make sure to send some throughput-heavy traffic for this use
case, to stress out any possible recursion issues with the locks around
workqueues.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/socket.c             | 12 -----
 tools/testing/selftests/wireguard/netns.sh | 54 ++++++++++++++++++++--
 2 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index b0d6541582d3..f9018027fc13 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -76,12 +76,6 @@ static int send4(struct wg_device *wg, struct sk_buff *skb,
 			net_dbg_ratelimited("%s: No route to %pISpfsc, error %d\n",
 					    wg->dev->name, &endpoint->addr, ret);
 			goto err;
-		} else if (unlikely(rt->dst.dev == skb->dev)) {
-			ip_rt_put(rt);
-			ret = -ELOOP;
-			net_dbg_ratelimited("%s: Avoiding routing loop to %pISpfsc\n",
-					    wg->dev->name, &endpoint->addr);
-			goto err;
 		}
 		if (cache)
 			dst_cache_set_ip4(cache, &rt->dst, fl.saddr);
@@ -149,12 +143,6 @@ static int send6(struct wg_device *wg, struct sk_buff *skb,
 			net_dbg_ratelimited("%s: No route to %pISpfsc, error %d\n",
 					    wg->dev->name, &endpoint->addr, ret);
 			goto err;
-		} else if (unlikely(dst->dev == skb->dev)) {
-			dst_release(dst);
-			ret = -ELOOP;
-			net_dbg_ratelimited("%s: Avoiding routing loop to %pISpfsc\n",
-					    wg->dev->name, &endpoint->addr);
-			goto err;
 		}
 		if (cache)
 			dst_cache_set_ip6(cache, dst, &fl.saddr);
diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index 936e1ca9410e..17a1f53ceba0 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -48,8 +48,11 @@ cleanup() {
 	exec 2>/dev/null
 	printf "$orig_message_cost" > /proc/sys/net/core/message_cost
 	ip0 link del dev wg0
+	ip0 link del dev wg1
 	ip1 link del dev wg0
+	ip1 link del dev wg1
 	ip2 link del dev wg0
+	ip2 link del dev wg1
 	local to_kill="$(ip netns pids $netns0) $(ip netns pids $netns1) $(ip netns pids $netns2)"
 	[[ -n $to_kill ]] && kill $to_kill
 	pp ip netns del $netns1
@@ -77,18 +80,20 @@ ip0 link set wg0 netns $netns2
 key1="$(pp wg genkey)"
 key2="$(pp wg genkey)"
 key3="$(pp wg genkey)"
+key4="$(pp wg genkey)"
 pub1="$(pp wg pubkey <<<"$key1")"
 pub2="$(pp wg pubkey <<<"$key2")"
 pub3="$(pp wg pubkey <<<"$key3")"
+pub4="$(pp wg pubkey <<<"$key4")"
 psk="$(pp wg genpsk)"
 [[ -n $key1 && -n $key2 && -n $psk ]]
 
 configure_peers() {
 	ip1 addr add 192.168.241.1/24 dev wg0
-	ip1 addr add fd00::1/24 dev wg0
+	ip1 addr add fd00::1/112 dev wg0
 
 	ip2 addr add 192.168.241.2/24 dev wg0
-	ip2 addr add fd00::2/24 dev wg0
+	ip2 addr add fd00::2/112 dev wg0
 
 	n1 wg set wg0 \
 		private-key <(echo "$key1") \
@@ -230,9 +235,38 @@ n1 ping -W 1 -c 1 192.168.241.2
 n1 wg set wg0 private-key <(echo "$key3")
 n2 wg set wg0 peer "$pub3" preshared-key <(echo "$psk") allowed-ips 192.168.241.1/32 peer "$pub1" remove
 n1 ping -W 1 -c 1 192.168.241.2
+n2 wg set wg0 peer "$pub3" remove
+
+# Test that we can route wg through wg
+ip1 addr flush dev wg0
+ip2 addr flush dev wg0
+ip1 addr add fd00::5:1/112 dev wg0
+ip2 addr add fd00::5:2/112 dev wg0
+n1 wg set wg0 private-key <(echo "$key1") peer "$pub2" preshared-key <(echo "$psk") allowed-ips fd00::5:2/128 endpoint 127.0.0.1:2
+n2 wg set wg0 private-key <(echo "$key2") listen-port 2 peer "$pub1" preshared-key <(echo "$psk") allowed-ips fd00::5:1/128 endpoint 127.212.121.99:9998
+ip1 link add wg1 type wireguard
+ip2 link add wg1 type wireguard
+ip1 addr add 192.168.241.1/24 dev wg1
+ip1 addr add fd00::1/112 dev wg1
+ip2 addr add 192.168.241.2/24 dev wg1
+ip2 addr add fd00::2/112 dev wg1
+ip1 link set mtu 1340 up dev wg1
+ip2 link set mtu 1340 up dev wg1
+n1 wg set wg1 listen-port 5 private-key <(echo "$key3") peer "$pub4" allowed-ips 192.168.241.2/32,fd00::2/128 endpoint [fd00::5:2]:5
+n2 wg set wg1 listen-port 5 private-key <(echo "$key4") peer "$pub3" allowed-ips 192.168.241.1/32,fd00::1/128 endpoint [fd00::5:1]:5
+tests
+# Try to set up a routing loop between the two namespaces
+ip1 link set netns $netns0 dev wg1
+ip0 addr add 192.168.241.1/24 dev wg1
+ip0 link set up dev wg1
+n0 ping -W 1 -c 1 192.168.241.2
+n1 wg set wg0 peer "$pub2" endpoint 192.168.241.2:7
+ip2 link del wg0
+ip2 link del wg1
+! n0 ping -W 1 -c 10 -f 192.168.241.2 || false # Should not crash kernel
 
+ip0 link del wg1
 ip1 link del wg0
-ip2 link del wg0
 
 # Test using NAT. We now change the topology to this:
 # ┌────────────────────────────────────────┐    ┌────────────────────────────────────────────────┐     ┌────────────────────────────────────────┐
@@ -282,6 +316,20 @@ pp sleep 3
 n2 ping -W 1 -c 1 192.168.241.1
 n1 wg set wg0 peer "$pub2" persistent-keepalive 0
 
+# Test that onion routing works, even when it loops
+n1 wg set wg0 peer "$pub3" allowed-ips 192.168.242.2/32 endpoint 192.168.241.2:5
+ip1 addr add 192.168.242.1/24 dev wg0
+ip2 link add wg1 type wireguard
+ip2 addr add 192.168.242.2/24 dev wg1
+n2 wg set wg1 private-key <(echo "$key3") listen-port 5 peer "$pub1" allowed-ips 192.168.242.1/32
+ip2 link set wg1 up
+n1 ping -W 1 -c 1 192.168.242.2
+ip2 link del wg1
+n1 wg set wg0 peer "$pub3" endpoint 192.168.242.2:5
+! n1 ping -W 1 -c 1 192.168.242.2 || false # Should not crash kernel
+n1 wg set wg0 peer "$pub3" remove
+ip1 addr del 192.168.242.1/24 dev wg0
+
 # Do a wg-quick(8)-style policy routing for the default route, making sure vethc has a v6 address to tease out bugs.
 ip1 -6 addr add fc00::9/96 dev vethc
 ip1 -6 route add default via fc00::1
-- 
2.26.2

