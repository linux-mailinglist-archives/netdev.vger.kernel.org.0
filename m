Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E44628C520
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 01:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391013AbgJLXR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 19:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388602AbgJLXR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 19:17:27 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E1BC0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 16:17:26 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id 1so3724835ple.2
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 16:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vqq/90dufHK5F5T3ZJzPZgAr/JjrnqcZr5YqiK1bgSA=;
        b=FA2NWViahy4vO0j5qdzpNMBDsisIeqDRtePtVCMAeAftJkHK2Dm/nKOMt/X1QuVjBB
         m6ARKoNkYdJw5CHSak2OFt45WMXF9IRaFtqcttAmEbo3jhMBpXzyAhqDYAi6+zk5CNx7
         YcF5DeBbMxymXSrFjZSGlzd8os0+3voebTecam7Q7XrJhakNFxpMszqOUra3d2OnaVZu
         vY65Zz+fIIjuRpDaJN9pEHH4jLpz2D8xLcqTA1isRVTIdgn1udcXiaVwsKSpSQQ0auV0
         BwQU/Sldjuduy9pZu0FOsnCKiZX5aaqswS6ysoMtIq4nGRSe7zTXtTG3MXFy7djABD2K
         ZQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vqq/90dufHK5F5T3ZJzPZgAr/JjrnqcZr5YqiK1bgSA=;
        b=qJwq0FzknqmYZrz40vp2IWR3TvY8XPWJrquwVmP+lQxbhJpyp1wQeXs0hVrApRiYqN
         Sk07WfRhO3P3pGx/7+3yUKT7adPvkuRYhGcROtez5yrd5fRieQfOfsBxsHtGfOejVlMz
         8WZG6ZKk+ex8jpV4oD2sWSpcTTlXHEt2hasFSqzIvAij/RnNFoNmNpcRib4ZbVDIqL7R
         iFdIVupAOlaNLwPlSqhGvpcUaYOdtW6PfWSz8+Ti7jkvSTzlENgUkWjQigRNCfy+iUnB
         7UIzp3HmTAekOJBXOwTUDqLe5z4ximxEKUKo5hQNgoHz4gXbeNyMrO1pYVnQxjB/eINe
         KPOA==
X-Gm-Message-State: AOAM532SOCPOVWpzDaZHjH2PqHLbNLz4IX1F86Sn6vIDTUGNV6ETc28F
        40tuq//069cLlzi1B/OM3o4bRMDpcz98UWo0
X-Google-Smtp-Source: ABdhPJzGuKw11kNmMQv7UcnSD+6wYjty6gnLOf4vNHpoChsY/ccrJNwl2MpnFMUrF4gd2lVzCdcjAw==
X-Received: by 2002:a17:902:204:b029:d3:9c43:3715 with SMTP id 4-20020a1709020204b02900d39c433715mr24683259plc.74.1602544646048;
        Mon, 12 Oct 2020 16:17:26 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:65a0:ab60::46])
        by smtp.gmail.com with ESMTPSA id x18sm21555847pfj.90.2020.10.12.16.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 16:17:25 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com,
        Xie He <xie.he.0141@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [Patch net v3] ip_gre: set dev->hard_header_len and dev->needed_headroom properly
Date:   Mon, 12 Oct 2020 16:17:21 -0700
Message-Id: <20201012231721.20374-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
conditionally. When it is set, it assumes the outer IP header is
already created before ipgre_xmit().

This is not true when we send packets through a raw packet socket,
where L2 headers are supposed to be constructed by user. Packet
socket calls dev_validate_header() to validate the header. But
GRE tunnel does not set dev->hard_header_len, so that check can
be simply bypassed, therefore uninit memory could be passed down
to ipgre_xmit(). Similar for dev->needed_headroom.

dev->hard_header_len is supposed to be the length of the header
created by dev->header_ops->create(), so it should be used whenever
header_ops is set, and dev->needed_headroom should be used when it
is not set.

Reported-and-tested-by: syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com
Cc: Xie He <xie.he.0141@gmail.com>
Cc: William Tu <u9012063@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
Note, there are some other suspicious use of dev->hard_header_len in
the same file, but let's leave them to a separate patch if really
needed.

v2: pass 0 to skb_cow_head()
v1: fix dev->needed_headroom and update ipgre_link_update()

 net/ipv4/ip_gre.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 4e31f23e4117..e70291748889 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -625,9 +625,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 	}
 
 	if (dev->header_ops) {
-		/* Need space for new headers */
-		if (skb_cow_head(skb, dev->needed_headroom -
-				      (tunnel->hlen + sizeof(struct iphdr))))
+		if (skb_cow_head(skb, 0))
 			goto free_skb;
 
 		tnl_params = (const struct iphdr *)skb->data;
@@ -748,7 +746,11 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 	len = tunnel->tun_hlen - len;
 	tunnel->hlen = tunnel->hlen + len;
 
-	dev->needed_headroom = dev->needed_headroom + len;
+	if (dev->header_ops)
+		dev->hard_header_len += len;
+	else
+		dev->needed_headroom += len;
+
 	if (set_mtu)
 		dev->mtu = max_t(int, dev->mtu - len, 68);
 
@@ -944,6 +946,7 @@ static void __gre_tunnel_init(struct net_device *dev)
 	tunnel->parms.iph.protocol = IPPROTO_GRE;
 
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
+	dev->needed_headroom = tunnel->hlen + sizeof(tunnel->parms.iph);
 
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
@@ -987,10 +990,14 @@ static int ipgre_tunnel_init(struct net_device *dev)
 				return -EINVAL;
 			dev->flags = IFF_BROADCAST;
 			dev->header_ops = &ipgre_header_ops;
+			dev->hard_header_len = tunnel->hlen + sizeof(*iph);
+			dev->needed_headroom = 0;
 		}
 #endif
 	} else if (!tunnel->collect_md) {
 		dev->header_ops = &ipgre_header_ops;
+		dev->hard_header_len = tunnel->hlen + sizeof(*iph);
+		dev->needed_headroom = 0;
 	}
 
 	return ip_tunnel_init(dev);
-- 
2.28.0

