Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A995B2D7595
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405899AbgLKM2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405460AbgLKM1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:27:40 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013DAC06138C
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:24 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id 23so13059249lfg.10
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjyu2kzXzjFlV5SiNsnxkSgTKn4vgsNhKYRUSqrh5SM=;
        b=OSXgQ+OWQ22nsiZMDN4YIhCkRPR9Wjvxa2WaNhET5d7SBGq5dXkX6wLeyGmnvStUjE
         ycjaXbEmSP+8FndrvHQJpSLmo1ztwG2gaYH0QSvHf9GqUoqlGsO8UZepeMoPvTfb5f/8
         SEybQpTVylVm0rfDSJz7mQH6PHOMGbGoeZfYRsshDMZlcFQ3yCUWv34cvheAGpbYCPz4
         lWkLqtop8zYZVUXAPb0UqfSPV1rTDA2q6Jjv6og1+A+QeNhjgrz7ZyCpJi7xFBy+g7hx
         hkVvPSNgl/nQgdlGA2hs0ftuISFldVaVQXHTWqCCR9TjpU0GDR2Ma/IFo7CQfxKSc79O
         PHnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjyu2kzXzjFlV5SiNsnxkSgTKn4vgsNhKYRUSqrh5SM=;
        b=N9vD2JZMVd7Fdo9YMbJ6Wpr3U/CPfaps5i/wJxYwypFzIL5bd3BLTdwd+eZB3je0H1
         L4nbrzowIeeDYShJQwx5cp3oXpjwUwmxvtESE0VEaSNj1FkF2rOifVTglmBdVGn2SM6X
         k++rni1O4UUh3yVAU7m/Gpb6+RLMVotvToTV6ovmXWB2t4OWt+s+QSQo2Q7cBUzQNAE2
         z+LmS7r1Xeh0YYf373xTte8dB7mQBCre5FQij7IRWfikMDJWsXNJh75RzlvoalnoTvXV
         1jFNTbEXMMARfVWe6tXrSBtNESvf3ZbF6wsow3VfPO7IQGh3ZV7fghAogT7a39GSUbBR
         LrMQ==
X-Gm-Message-State: AOAM5339+TS+ngd0EgaupoD+cghriFEdIVyJvQaUYsYYRnaxIoADjyhM
        YS/rS64FiAISVdI29PRg0Qdteh0rmAhLZQ==
X-Google-Smtp-Source: ABdhPJwMWWIyCltmSRx4cnTVud54k+XgIh3lVIFG9kMPTw8WxVTc2jvV/RRFDXalBU6YARfcxJi/UQ==
X-Received: by 2002:ac2:48ad:: with SMTP id u13mr4333194lfg.416.1607689582295;
        Fri, 11 Dec 2020 04:26:22 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:21 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 09/12] gtp: support GRO
Date:   Fri, 11 Dec 2020 13:26:09 +0100
Message-Id: <20201211122612.869225-10-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
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
index 7bbeec173113..86639fae8d45 100644
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
+	int err;
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
@@ -622,7 +744,9 @@ static void gtp_link_setup(struct net_device *dev)
 
 	dev->priv_flags	|= IFF_NO_QUEUE;
 	dev->features	|= NETIF_F_LLTX;
+	dev->hw_features |= NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_SG | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM;
+	dev->features	|= NETIF_F_RXCSUM;
 	dev->features	|= NETIF_F_SG | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM;
 	netif_keep_dst(dev);
 
@@ -818,6 +942,8 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	tuncfg.encap_type = type;
 	tuncfg.encap_rcv = gtp_encap_recv;
 	tuncfg.encap_destroy = gtp_encap_destroy;
+	tuncfg.gro_receive = gtp_gro_receive;
+	tuncfg.gro_complete = gtp_gro_complete;
 
 	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &tuncfg);
 
-- 
2.27.0

