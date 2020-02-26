Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B271817068E
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgBZRto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:49:44 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35078 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgBZRto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:49:44 -0500
Received: by mail-pf1-f196.google.com with SMTP id i19so152616pfa.2
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zDbWiU49eM/NMB7xh13OJddo8OiK/Zcqry1cGnudfGw=;
        b=ZN0LZqaKDeWyenyt29/NTVUoJkVJ5p6pLfbWWsiXIw1tXfTNyeBlNG7kT8OJgICsCD
         Uj2Yk58IFr7RZM1p342Jf9aE1t/jfKyJ2G3oMCWiKmtf9A44VMatfWlbh5cPuCGwe+t8
         uJVC7NNUblhMGkwD89gxQIJCx+x5hEI+LjP8CM5r0VlZNAph8JRPbYKc7PkkbaIW7956
         V1obM9z7XrO6pCbKD2nJr+Y/lzF9AAFR5QYRlnPnKCBOvCfJLWQY0xB8ygskhekkZ148
         HhudDdedPHyVgXkbDjeZOIPl5rsHYuihc8qyvxh185v/s3KoYlgll0X65UdDsw6jr59d
         SAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zDbWiU49eM/NMB7xh13OJddo8OiK/Zcqry1cGnudfGw=;
        b=kMX2pL/ZJRSTRPXohxUwF+yb63RQO7JERhlqSR1XFwkyUEQVlrerzvVKkRVSMLNX5v
         ZbC61Y88xjGGdaCf4GVQde/YfXf43g5wDpLd6NsC9/cEhQQsxRaPDSasC8pjGaSCA9xd
         IoWyyBQyL2uYCPuN3gsYYW9Qj7dvp/bKK+xcJ7rFxw/yZW78YZCJpbpeuFddDkva/5nu
         DBHiVgFslYboAp6HXwcowsmtyDG5uD3XXDaKGZm8VeaQTMQEcE4Kkb8iGN3UWeZ4cCBx
         ssE27AroCDjeXw/gvQWMQWizpRGMpIN7t8YuegCquQygKzDl3GdfN5vInmF0fSLMuxoJ
         sa2w==
X-Gm-Message-State: APjAAAUeTDgFFSjz6HCINAM+GPdxRtagUaEaRcDwsgSFVDk6+Zai2SG3
        sxCu2rffJ2n6RbkY0Kkel2g=
X-Google-Smtp-Source: APXvYqzSLyHymTxwK2yWWolPGcTMsFojp2hYkT9+cP1rIH0s+a6KTakoD4/+XsKuEACnPS4BR9D7IA==
X-Received: by 2002:a63:3587:: with SMTP id c129mr39745pga.140.1582739383046;
        Wed, 26 Feb 2020 09:49:43 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id t8sm3343354pjy.20.2020.02.26.09.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:49:41 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 10/10] net: rmnet: fix packet forwarding in rmnet bridge mode
Date:   Wed, 26 Feb 2020 17:49:36 +0000
Message-Id: <20200226174936.6541-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packet forwarding is not working in rmnet bridge mode.
Because when a packet is forwarded, skb_push() for an ethernet header
is needed. But it doesn't call skb_push().
So, the ethernet header will be lost.

Test commands:
    ip netns add nst
    ip netns add nst2
    ip link add veth0 type veth peer name veth1
    ip link add veth2 type veth peer name veth3
    ip link set veth1 netns nst
    ip link set veth3 netns nst2

    ip link add rmnet0 link veth0 type rmnet mux_id 1
    ip link set veth2 master rmnet0
    ip link set veth0 up
    ip link set veth2 up
    ip link set rmnet0 up
    ip a a 192.168.100.1/24 dev rmnet0

    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip a a 192.168.100.2/24 dev veth1
    ip netns exec nst2 ip link set veth3 up
    ip netns exec nst2 ip a a 192.168.100.3/24 dev veth3
    ip netns exec nst2 ping 192.168.100.2

Fixes: 60d58f971c10 ("net: qualcomm: rmnet: Implement bridge mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 074a8b326c30..29a7bfa2584d 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -159,6 +159,9 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 static void
 rmnet_bridge_handler(struct sk_buff *skb, struct net_device *bridge_dev)
 {
+	if (skb_mac_header_was_set(skb))
+		skb_push(skb, skb->mac_len);
+
 	if (bridge_dev) {
 		skb->dev = bridge_dev;
 		dev_queue_xmit(skb);
-- 
2.17.1

