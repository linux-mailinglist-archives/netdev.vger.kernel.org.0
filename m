Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4F61D147
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 23:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfENV2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 17:28:39 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37519 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfENV2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 17:28:38 -0400
Received: by mail-qt1-f195.google.com with SMTP id o7so873368qtp.4
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 14:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vmw/rQrN2kj/vyNXwf+0fudriczXXNEzgY6Y8N85oOI=;
        b=lUZhvRXBXej8dS2ip9gZVAvCm/uCv0WeVRXkYpNOLgAAGDKDhN1RAVWAriHVyMVvvT
         kcObQWdfSvaW7CvZln9yC8DgoTeTtn8Bf4Iq5sh24NnLKdglAqJghME1n18GhYak3Tso
         BAVThHGVMv3D2/NNFSUxj+X7FqFrwIuVZDxUt6VXURQhCNBjD2I24zvVVksItvO+AWnb
         2ivjmg7dTQ2h9nqBM53j2yDYU8GIft+EeyvxLWInjwPe5HTp7VEZ5o2fi9FIKCoOVWJv
         3d2UeEGPT1+vLE9CGGO72/cvj7s+TlT6qIWg8boXpzb3mjas45RWzmA0uq6z18Be67r8
         s6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vmw/rQrN2kj/vyNXwf+0fudriczXXNEzgY6Y8N85oOI=;
        b=R6xeLJatyE5rwJ60cY4jDqO5h7g8sSdneBlNUz/D4y2PDoe8xUylsuxdjqSu+Ni0aU
         whQ/joS1aL+0I8H/ahtDjOU0NMbAspqcRJy0zflJ3Ma8FPYOWWQ00EpHoWpJxk9Y/JAF
         ysCqWYHso7g27PK8d0lxcoE0E/RLIfdLydxvZlbc4VdqLLGZbnlvetEz8UE7/4E4jnb3
         IJTQDaS3fW7Bbe4ohU0R5Pcm3hXNTX4I/vw4ZORZfhSXzaxyL1EBT+ak3M0t4z06FE4x
         YnHlW4qGw0EJxc6UyI3bXbb2NPxYMftQm1qkzFKI73n/5d3VIgCLazYVdhI9AI0KH9bo
         c7xA==
X-Gm-Message-State: APjAAAVWXaZJw0nr5HBqbMiqGY3nTsbqmsINTXxTcDQ/YW/m24PxoF3+
        PM9Fi2U+Cq7L3HO2uF/9sag9jQ==
X-Google-Smtp-Source: APXvYqz6dSFmc4dm0iBXMUaJ3REbxhwqfwm2cw0MkwnQrmkIC4rCKzJM1AEkIg2chqBGqHkMG9poEw==
X-Received: by 2002:ac8:641:: with SMTP id e1mr31597648qth.76.1557869317868;
        Tue, 14 May 2019 14:28:37 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f21sm7425021qkl.72.2019.05.14.14.28.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 14:28:36 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net] nfp: flower: add rcu locks when accessing netdev for tunnels
Date:   Tue, 14 May 2019 14:28:19 -0700
Message-Id: <20190514212819.7789-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Add rcu locks when accessing netdev when processing route request
and tunnel keep alive messages received from hardware.

Fixes: 8e6a9046b66a ("nfp: flower vxlan neighbour offload")
Fixes: 856f5b135758 ("nfp: flower vxlan neighbour keep-alive")
Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
---
 .../ethernet/netronome/nfp/flower/tunnel_conf.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index faa06edf95ac..8c67505865a4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -168,6 +168,7 @@ void nfp_tunnel_keep_alive(struct nfp_app *app, struct sk_buff *skb)
 		return;
 	}
 
+	rcu_read_lock();
 	for (i = 0; i < count; i++) {
 		ipv4_addr = payload->tun_info[i].ipv4;
 		port = be32_to_cpu(payload->tun_info[i].egress_port);
@@ -183,6 +184,7 @@ void nfp_tunnel_keep_alive(struct nfp_app *app, struct sk_buff *skb)
 		neigh_event_send(n, NULL);
 		neigh_release(n);
 	}
+	rcu_read_unlock();
 }
 
 static int
@@ -367,9 +369,10 @@ void nfp_tunnel_request_route(struct nfp_app *app, struct sk_buff *skb)
 
 	payload = nfp_flower_cmsg_get_data(skb);
 
+	rcu_read_lock();
 	netdev = nfp_app_dev_get(app, be32_to_cpu(payload->ingress_port), NULL);
 	if (!netdev)
-		goto route_fail_warning;
+		goto fail_rcu_unlock;
 
 	flow.daddr = payload->ipv4_addr;
 	flow.flowi4_proto = IPPROTO_UDP;
@@ -379,21 +382,23 @@ void nfp_tunnel_request_route(struct nfp_app *app, struct sk_buff *skb)
 	rt = ip_route_output_key(dev_net(netdev), &flow);
 	err = PTR_ERR_OR_ZERO(rt);
 	if (err)
-		goto route_fail_warning;
+		goto fail_rcu_unlock;
 #else
-	goto route_fail_warning;
+	goto fail_rcu_unlock;
 #endif
 
 	/* Get the neighbour entry for the lookup */
 	n = dst_neigh_lookup(&rt->dst, &flow.daddr);
 	ip_rt_put(rt);
 	if (!n)
-		goto route_fail_warning;
-	nfp_tun_write_neigh(n->dev, app, &flow, n, GFP_KERNEL);
+		goto fail_rcu_unlock;
+	nfp_tun_write_neigh(n->dev, app, &flow, n, GFP_ATOMIC);
 	neigh_release(n);
+	rcu_read_unlock();
 	return;
 
-route_fail_warning:
+fail_rcu_unlock:
+	rcu_read_unlock();
 	nfp_flower_cmsg_warn(app, "Requested route not found.\n");
 }
 
-- 
2.21.0

