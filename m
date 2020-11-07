Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB43F2AA7F9
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgKGU4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGU4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 15:56:08 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74093C0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 12:56:07 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id d12so3311116wrr.13
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 12:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=PejjeG+zbwWRUN6vuocV3lUkiAIKQDB/4FnU3VTYJqI=;
        b=jQiRfb3bKW8yRMUM4GhzH5IZfwMfT0/hthqZ7i6XF52BIAllC+9OfOm005NNTF4n8C
         0XoRG70Tax9wHzx1G9MOJeEq5fx1Nd0Nogc2OQCYqkCMCl11kLMwhEFEUMYepziaR9Ub
         nBqIw9oNhvprKwVh1KPUj3vNNoG8blTOj/3i7NIICBv1EllaxfN+KavTwEz14shqbNpC
         LKMzhpgvMEX9WSHo8emECbVq1sY6dk+zhUblXDKIUqg6qebEav8Iyd70/VscY/AXoYsv
         3tVgNK3nh6k2bwaB+oKyFv6kJBd95GNClyL2drGS2lynEtA6cYfsgQTVaQqCpT+xKVvw
         1v3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=PejjeG+zbwWRUN6vuocV3lUkiAIKQDB/4FnU3VTYJqI=;
        b=M43mPvCrtzfMRlVYKnjof61IyTswTGa5kZU9oWChL1XhPElKeVrBBameoo8PL1/mak
         WqvPavHSZzksrhLvWwHuynQ+2q9qr0VARSodjdgfCFXqmqR5VNUe5zWI92PNFGYPNsW9
         zGjda91TNaq8o2ksgyK8aUfThHacmY1ZblpsXg+7ZAAa54LBxnY1aWoFuqkXYG3a3Jya
         C5g32mUx3ZPFbgllNXrnfYZVRGXO6ujee/Fu7oJyZmFbMefszWWcZ0YDTzdW1EQSu8R8
         qgSs5LF7CGVK00eYUvdJ7WTuBlHyuTAQW8sK5m7C2ld+twQOWt6cfptTJmHYrcLaLDfg
         23Aw==
X-Gm-Message-State: AOAM532utjaVt9A2rnbkOgzU7kpYf4F1PfE6EslaBvg90o3GhAJUKZmx
        F879tETpT2BwPB5PW/dXIIY=
X-Google-Smtp-Source: ABdhPJz67P1Dor/5WyKbo0NH5zynGrSvAaCBVCt0ZASUFwHh+xc4w0q6FVXcW7AWuWi4sAOrgVFUCQ==
X-Received: by 2002:a5d:4a50:: with SMTP id v16mr3929247wrs.106.1604782566074;
        Sat, 07 Nov 2020 12:56:06 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7051:31d:251f:edd6? (p200300ea8f2328007051031d251fedd6.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7051:31d:251f:edd6])
        by smtp.googlemail.com with ESMTPSA id o17sm7621838wmd.34.2020.11.07.12.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:56:05 -0800 (PST)
Subject: [PATCH net-next v3 03/10] tun: switch to net core provided statistics
 counters
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, wireguard@lists.zx2c4.com,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Message-ID: <7dbbdd3b-4e99-25b1-273c-232ab34d2e78@gmail.com>
Date:   Sat, 7 Nov 2020 21:50:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch tun to the standard statistics pattern:
- use netdev->stats for the less frequently accessed counters
- use netdev->tstats for the frequently accessed per-cpu counters

v3:
- add atomic_long_t member rx_frame_errors for making counter updates
  atomic

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/tun.c | 121 +++++++++++++---------------------------------
 1 file changed, 34 insertions(+), 87 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index be69d2720..3d45d5617 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -107,17 +107,6 @@ struct tap_filter {
 
 #define TUN_FLOW_EXPIRE (3 * HZ)
 
-struct tun_pcpu_stats {
-	u64_stats_t rx_packets;
-	u64_stats_t rx_bytes;
-	u64_stats_t tx_packets;
-	u64_stats_t tx_bytes;
-	struct u64_stats_sync syncp;
-	u32 rx_dropped;
-	u32 tx_dropped;
-	u32 rx_frame_errors;
-};
-
 /* A tun_file connects an open character device to a tuntap netdevice. It
  * also contains all socket related structures (except sock_fprog and tap_filter)
  * to serve as one transmit queue for tuntap device. The sock_fprog and
@@ -207,7 +196,7 @@ struct tun_struct {
 	void *security;
 	u32 flow_count;
 	u32 rx_batched;
-	struct tun_pcpu_stats __percpu *pcpu_stats;
+	atomic_long_t rx_frame_errors;
 	struct bpf_prog __rcu *xdp_prog;
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
@@ -1066,7 +1055,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 drop:
-	this_cpu_inc(tun->pcpu_stats->tx_dropped);
+	atomic_long_inc(&dev->tx_dropped);
 	skb_tx_error(skb);
 	kfree_skb(skb);
 	rcu_read_unlock();
@@ -1103,37 +1092,12 @@ static void tun_set_headroom(struct net_device *dev, int new_hr)
 static void
 tun_net_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
-	u32 rx_dropped = 0, tx_dropped = 0, rx_frame_errors = 0;
 	struct tun_struct *tun = netdev_priv(dev);
-	struct tun_pcpu_stats *p;
-	int i;
-
-	for_each_possible_cpu(i) {
-		u64 rxpackets, rxbytes, txpackets, txbytes;
-		unsigned int start;
 
-		p = per_cpu_ptr(tun->pcpu_stats, i);
-		do {
-			start = u64_stats_fetch_begin(&p->syncp);
-			rxpackets	= u64_stats_read(&p->rx_packets);
-			rxbytes		= u64_stats_read(&p->rx_bytes);
-			txpackets	= u64_stats_read(&p->tx_packets);
-			txbytes		= u64_stats_read(&p->tx_bytes);
-		} while (u64_stats_fetch_retry(&p->syncp, start));
+	dev_get_tstats64(dev, stats);
 
-		stats->rx_packets	+= rxpackets;
-		stats->rx_bytes		+= rxbytes;
-		stats->tx_packets	+= txpackets;
-		stats->tx_bytes		+= txbytes;
-
-		/* u32 counters */
-		rx_dropped	+= p->rx_dropped;
-		rx_frame_errors	+= p->rx_frame_errors;
-		tx_dropped	+= p->tx_dropped;
-	}
-	stats->rx_dropped  = rx_dropped;
-	stats->rx_frame_errors = rx_frame_errors;
-	stats->tx_dropped = tx_dropped;
+	stats->rx_frame_errors +=
+		(unsigned long)atomic_long_read(&tun->rx_frame_errors);
 }
 
 static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
@@ -1247,7 +1211,7 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
 		void *frame = tun_xdp_to_ptr(xdp);
 
 		if (__ptr_ring_produce(&tfile->tx_ring, frame)) {
-			this_cpu_inc(tun->pcpu_stats->tx_dropped);
+			atomic_long_inc(&dev->tx_dropped);
 			xdp_return_frame_rx_napi(xdp);
 			drops++;
 		}
@@ -1283,7 +1247,7 @@ static const struct net_device_ops tap_netdev_ops = {
 	.ndo_select_queue	= tun_select_queue,
 	.ndo_features_check	= passthru_features_check,
 	.ndo_set_rx_headroom	= tun_set_headroom,
-	.ndo_get_stats64	= tun_net_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_bpf		= tun_xdp,
 	.ndo_xdp_xmit		= tun_xdp_xmit,
 	.ndo_change_carrier	= tun_net_change_carrier,
@@ -1577,7 +1541,7 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 		trace_xdp_exception(tun->dev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-		this_cpu_inc(tun->pcpu_stats->rx_dropped);
+		atomic_long_inc(&tun->dev->rx_dropped);
 		break;
 	}
 
@@ -1683,7 +1647,6 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	size_t total_len = iov_iter_count(from);
 	size_t len = total_len, align = tun->align, linear;
 	struct virtio_net_hdr gso = { 0 };
-	struct tun_pcpu_stats *stats;
 	int good_linear;
 	int copylen;
 	bool zerocopy = false;
@@ -1752,7 +1715,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		 */
 		skb = tun_build_skb(tun, tfile, from, &gso, len, &skb_xdp);
 		if (IS_ERR(skb)) {
-			this_cpu_inc(tun->pcpu_stats->rx_dropped);
+			atomic_long_inc(&tun->dev->rx_dropped);
 			return PTR_ERR(skb);
 		}
 		if (!skb)
@@ -1781,7 +1744,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		if (IS_ERR(skb)) {
 			if (PTR_ERR(skb) != -EAGAIN)
-				this_cpu_inc(tun->pcpu_stats->rx_dropped);
+				atomic_long_inc(&tun->dev->rx_dropped);
 			if (frags)
 				mutex_unlock(&tfile->napi_mutex);
 			return PTR_ERR(skb);
@@ -1795,7 +1758,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		if (err) {
 			err = -EFAULT;
 drop:
-			this_cpu_inc(tun->pcpu_stats->rx_dropped);
+			atomic_long_inc(&tun->dev->rx_dropped);
 			kfree_skb(skb);
 			if (frags) {
 				tfile->napi.skb = NULL;
@@ -1807,7 +1770,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	}
 
 	if (virtio_net_hdr_to_skb(skb, &gso, tun_is_little_endian(tun))) {
-		this_cpu_inc(tun->pcpu_stats->rx_frame_errors);
+		atomic_long_inc(&tun->rx_frame_errors);
 		kfree_skb(skb);
 		if (frags) {
 			tfile->napi.skb = NULL;
@@ -1830,7 +1793,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 				pi.proto = htons(ETH_P_IPV6);
 				break;
 			default:
-				this_cpu_inc(tun->pcpu_stats->rx_dropped);
+				atomic_long_inc(&tun->dev->rx_dropped);
 				kfree_skb(skb);
 				return -EINVAL;
 			}
@@ -1910,7 +1873,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 					  skb_headlen(skb));
 
 		if (unlikely(headlen > skb_headlen(skb))) {
-			this_cpu_inc(tun->pcpu_stats->rx_dropped);
+			atomic_long_inc(&tun->dev->rx_dropped);
 			napi_free_frags(&tfile->napi);
 			rcu_read_unlock();
 			mutex_unlock(&tfile->napi_mutex);
@@ -1942,12 +1905,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	}
 	rcu_read_unlock();
 
-	stats = get_cpu_ptr(tun->pcpu_stats);
-	u64_stats_update_begin(&stats->syncp);
-	u64_stats_inc(&stats->rx_packets);
-	u64_stats_add(&stats->rx_bytes, len);
-	u64_stats_update_end(&stats->syncp);
-	put_cpu_ptr(stats);
+	preempt_disable();
+	dev_sw_netstats_rx_add(tun->dev, len);
+	preempt_enable();
 
 	if (rxhash)
 		tun_flow_update(tun, rxhash, tfile);
@@ -1979,7 +1939,6 @@ static ssize_t tun_put_user_xdp(struct tun_struct *tun,
 {
 	int vnet_hdr_sz = 0;
 	size_t size = xdp_frame->len;
-	struct tun_pcpu_stats *stats;
 	size_t ret;
 
 	if (tun->flags & IFF_VNET_HDR) {
@@ -1996,12 +1955,9 @@ static ssize_t tun_put_user_xdp(struct tun_struct *tun,
 
 	ret = copy_to_iter(xdp_frame->data, size, iter) + vnet_hdr_sz;
 
-	stats = get_cpu_ptr(tun->pcpu_stats);
-	u64_stats_update_begin(&stats->syncp);
-	u64_stats_inc(&stats->tx_packets);
-	u64_stats_add(&stats->tx_bytes, ret);
-	u64_stats_update_end(&stats->syncp);
-	put_cpu_ptr(tun->pcpu_stats);
+	preempt_disable();
+	dev_sw_netstats_tx_add(tun->dev, 1, ret);
+	preempt_enable();
 
 	return ret;
 }
@@ -2013,7 +1969,6 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 			    struct iov_iter *iter)
 {
 	struct tun_pi pi = { 0, skb->protocol };
-	struct tun_pcpu_stats *stats;
 	ssize_t total;
 	int vlan_offset = 0;
 	int vlan_hlen = 0;
@@ -2091,12 +2046,9 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 
 done:
 	/* caller is in process context, */
-	stats = get_cpu_ptr(tun->pcpu_stats);
-	u64_stats_update_begin(&stats->syncp);
-	u64_stats_inc(&stats->tx_packets);
-	u64_stats_add(&stats->tx_bytes, skb->len + vlan_hlen);
-	u64_stats_update_end(&stats->syncp);
-	put_cpu_ptr(tun->pcpu_stats);
+	preempt_disable();
+	dev_sw_netstats_tx_add(tun->dev, 1, skb->len + vlan_hlen);
+	preempt_enable();
 
 	return total;
 }
@@ -2235,11 +2187,11 @@ static void tun_free_netdev(struct net_device *dev)
 
 	BUG_ON(!(list_empty(&tun->disabled)));
 
-	free_percpu(tun->pcpu_stats);
-	/* We clear pcpu_stats so that tun_set_iff() can tell if
+	free_percpu(dev->tstats);
+	/* We clear tstats so that tun_set_iff() can tell if
 	 * tun_free_netdev() has been called from register_netdevice().
 	 */
-	tun->pcpu_stats = NULL;
+	dev->tstats = NULL;
 
 	tun_flow_uninit(tun);
 	security_tun_dev_free_security(tun->security);
@@ -2370,7 +2322,6 @@ static int tun_xdp_one(struct tun_struct *tun,
 	unsigned int datasize = xdp->data_end - xdp->data;
 	struct tun_xdp_hdr *hdr = xdp->data_hard_start;
 	struct virtio_net_hdr *gso = &hdr->gso;
-	struct tun_pcpu_stats *stats;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
 	u32 rxhash = 0, act;
@@ -2428,7 +2379,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	skb_put(skb, xdp->data_end - xdp->data);
 
 	if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
-		this_cpu_inc(tun->pcpu_stats->rx_frame_errors);
+		atomic_long_inc(&tun->rx_frame_errors);
 		kfree_skb(skb);
 		err = -EINVAL;
 		goto out;
@@ -2451,14 +2402,10 @@ static int tun_xdp_one(struct tun_struct *tun,
 
 	netif_receive_skb(skb);
 
-	/* No need for get_cpu_ptr() here since this function is
+	/* No need to disable preemption here since this function is
 	 * always called with bh disabled
 	 */
-	stats = this_cpu_ptr(tun->pcpu_stats);
-	u64_stats_update_begin(&stats->syncp);
-	u64_stats_inc(&stats->rx_packets);
-	u64_stats_add(&stats->rx_bytes, datasize);
-	u64_stats_update_end(&stats->syncp);
+	dev_sw_netstats_rx_add(tun->dev, datasize);
 
 	if (rxhash)
 		tun_flow_update(tun, rxhash, tfile);
@@ -2751,8 +2698,8 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		tun->rx_batched = 0;
 		RCU_INIT_POINTER(tun->steering_prog, NULL);
 
-		tun->pcpu_stats = netdev_alloc_pcpu_stats(struct tun_pcpu_stats);
-		if (!tun->pcpu_stats) {
+		dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+		if (!dev->tstats) {
 			err = -ENOMEM;
 			goto err_free_dev;
 		}
@@ -2807,16 +2754,16 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 	tun_detach_all(dev);
 	/* We are here because register_netdevice() has failed.
 	 * If register_netdevice() already called tun_free_netdev()
-	 * while dealing with the error, tun->pcpu_stats has been cleared.
+	 * while dealing with the error, dev->stats has been cleared.
 	 */
-	if (!tun->pcpu_stats)
+	if (!dev->tstats)
 		goto err_free_dev;
 
 err_free_flow:
 	tun_flow_uninit(tun);
 	security_tun_dev_free_security(tun->security);
 err_free_stat:
-	free_percpu(tun->pcpu_stats);
+	free_percpu(dev->tstats);
 err_free_dev:
 	free_netdev(dev);
 	return err;
-- 
2.29.2


