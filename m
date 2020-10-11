Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A0528A993
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgJKTLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbgJKTLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:11:36 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EB4C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 12:11:36 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t18so7272427plo.1
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 12:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1KetGy40ERK0V6+twwjePiHzbJKqm870Uk7Y8d/2PWc=;
        b=L51vuIuyBmiaLJ4MK2ycvZq3fdbx45VGc79X7kmAWWKBUcs4hmj78xJX/JUbWbLdzs
         fzdzwqPues8X9Eths+lxWDqOC177SXWuyEnDqb0m05gqs5M/I6VYlTqBc4wuytzG4hoh
         Ya+JKR4BKKcm4/cc+d1WVtEjGjqIERrlhVpnBEW2K1pmf8bpo/d8tc0nBQTZcvTjSqLV
         gDDTCQt3+AYN5JYVBAMTV5Tg+8WNDiK3j+aDjSmBfmMhi/W2akg7/bTnfgq5e6/21J58
         ZR0YYLrr6LNUzC/NT8691PZM/qhb7D6NcHkWG0WakfRvU+SKNHYxntTHmpITwvshsbEo
         298A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1KetGy40ERK0V6+twwjePiHzbJKqm870Uk7Y8d/2PWc=;
        b=mBM2iaeBQAnpWdXy/pw6kdTsXnFgsS7FtG0mtFPxjrQ5w1mwLs3NfNHWIQJ3dco0/i
         0DPlrqIiOSaxy6jv84k2W+au84Ksd1+9Uhz/s/xvqSRVlCLte7BKyxGQsAceqndiYufq
         iZLo2ojtuDKJx5rZnYJNiw0AmUO+9u4pbvZXJ0SsQwsUsQM+UunRNoD/Uq3lmgbVLjFF
         2ccrZrolrZse7YTltKZ+N2/STTxZNx4zrDAM2jU74h59a4F9eQD/dOUmOV564iDBzo5A
         ieTuGdRVvpbwNdNwcF3UuAWD3Tbn3sllmFl9tAo5N7WdBSFNLS1r/kw7KcBef5QvIgcR
         AWvw==
X-Gm-Message-State: AOAM533jkDe8NqS0SIDdy0fmKIorifVo2LcBZLccoDceUMib6v0T6vFL
        DR/KAWXyaOIgy/YgJquEdFAKttM496v2rgzH
X-Google-Smtp-Source: ABdhPJzjpOliv0vNNPyArmxBBCC80b/oRQ3uF80V155M/GNM8grLUyrsgbMvm8/Mfd3r/mMBB3s5Fg==
X-Received: by 2002:a17:902:b096:b029:d3:e6c5:507c with SMTP id p22-20020a170902b096b02900d3e6c5507cmr21089144plr.71.1602443495308;
        Sun, 11 Oct 2020 12:11:35 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:65a0:ab60::46])
        by smtp.gmail.com with ESMTPSA id r16sm20292078pjo.19.2020.10.11.12.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 12:11:34 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com,
        Xie He <xie.he.0141@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [Patch net v2] ip_gre: set dev->hard_header_len and dev->needed_headroom properly
Date:   Sun, 11 Oct 2020 12:11:29 -0700
Message-Id: <20201011191129.991-1-xiyou.wangcong@gmail.com>
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
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
Note, there are some other suspicious use of dev->hard_header_len in
the same file, but let's leave them to a separate patch if really
needed.

 net/ipv4/ip_gre.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 4e31f23e4117..82fee0010353 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -626,8 +626,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 
 	if (dev->header_ops) {
 		/* Need space for new headers */
-		if (skb_cow_head(skb, dev->needed_headroom -
-				      (tunnel->hlen + sizeof(struct iphdr))))
+		if (skb_cow_head(skb, dev->hard_header_len))
 			goto free_skb;
 
 		tnl_params = (const struct iphdr *)skb->data;
@@ -748,7 +747,11 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
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
 
@@ -944,6 +947,7 @@ static void __gre_tunnel_init(struct net_device *dev)
 	tunnel->parms.iph.protocol = IPPROTO_GRE;
 
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
+	dev->needed_headroom = tunnel->hlen + sizeof(tunnel->parms.iph);
 
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
@@ -987,10 +991,14 @@ static int ipgre_tunnel_init(struct net_device *dev)
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

