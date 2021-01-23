Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5B2301822
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAWUC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbhAWUAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:37 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357E3C0612F2
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:39 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id a12so4174675lfb.1
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a8roDgMj60xDlpj02wthqVGznMg0XPB6yLR44gW6uag=;
        b=mnU5eSeuXztQNQc4us7Y8hWpWLm/mVw6c8Yg0nI1Y+mv8rIxSJMX/ux3R1lGy21Yw8
         bnkXNibmhluLDIjlZa0ugmT26WdS8dqlRovC/C7LZmdiO/doJEy8l8h0emnqqXbmwF04
         WC8TgcxQoKlGspNPufd0CnJcjdFOaYWr6jEROJDbjp24sZt5/atw4jlc5kxD8JEA6Rlk
         Y3T6oHm6Z0uW6AKKbf1ooNdMwyNA4EFA34336sGblgouIQFUJ0G9oNB38oKR9StAQYEy
         3PBzIz/NPMaTmA4GVeVmfWqm4rvYDi+ZoUuUYO9A48muTAo+8gS5XcSEuTnkZyTonlk+
         2KcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a8roDgMj60xDlpj02wthqVGznMg0XPB6yLR44gW6uag=;
        b=pDgloct/b/DVxuj5X51ARn90uKBd2BvhamgKpN3Q97QhpC57Rimtx/QKgWNQs3Py73
         p2k9y7//kKedufztsvRm7TyvguaC3DaNRCIR3E2GhW49MRwsOu0W5GIve9NChSFsmV0q
         YR1Q0+xUbwIr6h1HWThx+Boy6zWYWfnJIo2X4gK4RHQtFNKIJVHG9246u8OdmWB5srx9
         Wocx9P6qlmeeYAN6qEz+l9Xe3LvDGvVTr10/6HYfX7MZmrDM2FKMCVYNSuFozzTCcXDN
         2lhEOqLA+3zOmnfVsgWRcD72MZKYTdbg43eEqoHkmYshJ9+lVfzBZvyHXCj25TUJnsxC
         YajA==
X-Gm-Message-State: AOAM533qmdle2Was92LMpLkOSi1FHdFvj55fahHPH4qNVtte/T2Q3JbK
        /ySxLrmXBDX1+Pvl7vYRfwEreD45/jGu5Q==
X-Google-Smtp-Source: ABdhPJz9NeIchUOQQsGVcMHEI51iAkVA3lxTRLRXbf6m8q8Q5RHzzRVYz1H3QHy6u3fXwOSXhXGa3g==
X-Received: by 2002:a19:d07:: with SMTP id 7mr526160lfn.215.1611431977777;
        Sat, 23 Jan 2021 11:59:37 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:37 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 09/16] gtp: support GRO
Date:   Sat, 23 Jan 2021 20:59:09 +0100
Message-Id: <20210123195916.2765481-10-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements GRO callbacks for UDP-tunneled GTP traffic.

iperf3 numbers

Without GRO for GTP tunnels:

Accepted connection from 172.99.2.1, port 48783
[  5] local 172.99.0.1 port 5201 connected to 172.99.2.1 port 46095
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   563 MBytes  576306 KBytes/sec
[  5]   1.00-2.00   sec   681 MBytes  697814 KBytes/sec
[  5]   2.00-3.00   sec   677 MBytes  693612 KBytes/sec
[  5]   3.00-4.00   sec   679 MBytes  695690 KBytes/sec
[  5]   4.00-5.00   sec   683 MBytes  699521 KBytes/sec
[  5]   5.00-6.00   sec   682 MBytes  698922 KBytes/sec
[  5]   6.00-7.00   sec   683 MBytes  699820 KBytes/sec
[  5]   7.00-8.00   sec   682 MBytes  698052 KBytes/sec
[  5]   8.00-9.00   sec   683 MBytes  699245 KBytes/sec
[  5]   9.00-10.00  sec   683 MBytes  699554 KBytes/sec
[  5]  10.00-10.00  sec   616 KBytes  687914 KBytes/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  6.54 GBytes  685853 KBytes/sec                  receiver

With GRO for GTP tunnels:

Accepted connection from 172.99.2.1, port 40847
[  5] local 172.99.0.1 port 5201 connected to 172.99.2.1 port 55053
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   989 MBytes  1012640 KBytes/sec
[  5]   1.00-2.00   sec  1.23 GBytes  1291408 KBytes/sec
[  5]   2.00-3.00   sec  1.26 GBytes  1320197 KBytes/sec
[  5]   3.00-4.00   sec  1.29 GBytes  1350097 KBytes/sec
[  5]   4.00-5.00   sec  1.23 GBytes  1284512 KBytes/sec
[  5]   5.00-6.00   sec  1.26 GBytes  1326329 KBytes/sec
[  5]   6.00-7.00   sec  1.28 GBytes  1338620 KBytes/sec
[  5]   7.00-8.00   sec  1.28 GBytes  1346391 KBytes/sec
[  5]   8.00-9.00   sec  1.30 GBytes  1366394 KBytes/sec
[  5]   9.00-10.00  sec  1.26 GBytes  1323848 KBytes/sec
[  5]  10.00-10.00  sec   384 KBytes  1113043 KBytes/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  12.4 GBytes  1296036 KBytes/sec                  receiver

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 126 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index df2f227680eb..b20e17988bfa 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -361,6 +361,128 @@ static int gtp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	return ret;
 }
 
+static int gtp_gro_complete(struct sock *sk, struct sk_buff * skb, int nhoff)
+{
+	size_t hdrlen;
+	char* gtphdr = skb->data + nhoff;
+	u8 version;
+	__be16 type;
+	struct packet_offload *ptype;
+	uint8_t ipver;
+	int err = -ENOENT;
+
+	version = *gtphdr >> 5;
+	switch (version) {
+	case GTP_V0:
+		hdrlen = sizeof(struct gtp0_header);
+		break;
+	case GTP_V1:
+		hdrlen = sizeof(struct gtp1_header);
+		if (*gtphdr & GTP1_F_MASK)
+			hdrlen += 4;
+		break;
+	}
+
+	skb_set_inner_network_header(skb, nhoff + hdrlen);
+
+	ipver = inner_ip_hdr(skb)->version;
+	switch (ipver) {
+	case 4:
+		type = cpu_to_be16(ETH_P_IP);
+		break;
+	case 6:
+		type = cpu_to_be16(ETH_P_IPV6);
+		break;
+	default:
+		goto out;
+	}
+
+	rcu_read_lock();
+	ptype = gro_find_complete_by_type(type);
+	if (!ptype)
+		goto out_unlock;
+
+	err = ptype->callbacks.gro_complete(skb, nhoff + hdrlen);
+
+	skb_set_inner_mac_header(skb, nhoff + hdrlen);
+
+out_unlock:
+	rcu_read_unlock();
+out:
+
+	return err;
+
+}
+
+static struct sk_buff *gtp_gro_receive(struct sock *sk,
+				       struct list_head *head,
+				       struct sk_buff *skb)
+{
+	size_t off, hdrlen;
+	char* gtphdr;
+	u8 version;
+	struct sk_buff *pp = NULL;
+	__be16 type;
+	struct packet_offload *ptype;
+
+	off = skb_gro_offset(skb);
+
+	gtphdr = skb_gro_header_fast(skb, off);
+	if (skb_gro_header_hard(skb, off+1)) {
+		gtphdr = skb_gro_header_slow(skb, off+1, off);
+		if (unlikely(!gtphdr))
+			goto out;
+	}
+
+	version = *gtphdr >> 5;
+	switch (version) {
+	case GTP_V0:
+		hdrlen = sizeof(struct gtp0_header);
+		break;
+	case GTP_V1:
+		hdrlen = sizeof(struct gtp1_header);
+		if (*gtphdr & GTP1_F_MASK)
+			hdrlen += 4;
+		break;
+	}
+
+	gtphdr = skb_gro_header_fast(skb, off);
+	if (skb_gro_header_hard(skb, off+hdrlen)) {
+		gtphdr = skb_gro_header_slow(skb, off+hdrlen, off);
+		if (unlikely(!gtphdr))
+			goto out;
+	}
+
+	skb_set_inner_network_header(skb, off + hdrlen);
+
+	switch(inner_ip_hdr(skb)->version) {
+	case 4:
+		type = cpu_to_be16(ETH_P_IP);
+		break;
+	case 6:
+		type = cpu_to_be16(ETH_P_IPV6);
+		break;
+	default:
+		goto out;
+	}
+
+	rcu_read_lock();
+	ptype = gro_find_receive_by_type(type);
+	if (!ptype)
+		goto out_unlock;
+
+	skb_gro_pull(skb, hdrlen);
+	skb_gro_postpull_rcsum(skb, gtphdr, hdrlen);
+
+	pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
+
+out_unlock:
+	rcu_read_unlock();
+out:
+
+	return pp;
+}
+
 static int gtp_dev_init(struct net_device *dev)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
@@ -618,7 +740,9 @@ static void gtp_link_setup(struct net_device *dev)
 
 	dev->priv_flags	|= IFF_NO_QUEUE;
 	dev->features	|= NETIF_F_LLTX;
+	dev->hw_features |= NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_SG | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM;
+	dev->features	|= NETIF_F_RXCSUM;
 	dev->features	|= NETIF_F_SG | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM;
 	netif_keep_dst(dev);
 
@@ -814,6 +938,8 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	tuncfg.encap_type = type;
 	tuncfg.encap_rcv = gtp_encap_recv;
 	tuncfg.encap_destroy = gtp_encap_destroy;
+	tuncfg.gro_receive = gtp_gro_receive;
+	tuncfg.gro_complete = gtp_gro_complete;
 
 	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &tuncfg);
 
-- 
2.27.0

