Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BF513B3E4
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 22:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgANVAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 16:00:40 -0500
Received: from mail-qk1-f202.google.com ([209.85.222.202]:45724 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANVAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 16:00:40 -0500
Received: by mail-qk1-f202.google.com with SMTP id 143so9188201qkg.12
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 13:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PuoqIYg2h4GAkf+klWzahAc5y/3k74tDlxUvlYyB17A=;
        b=GRapa6W89Z+2pGH3/UTK2qE4+ht7YFjRBmRiaOLVNveT7vU3HWgI7zaqdw2DqgSdr+
         qBh3xNvwWhWyIarkUiZPEqVabRha0o8rhlBFTIQk4L9mRvcggasSBjjEUCGuYm0GOQ3M
         FS7yfeQlDAr7nbutPuUT2Y3+9e6dNszERJ8O4hr+4QBov6mDjK41a4DdU9sOYMVGdBTN
         zb77zS8Zmmn8MlwOEjJmgUi+KXuHUrGq1xWR2+zV5sMS4l0IP9dtS2nduJh6uz3iqBRM
         RfD0Se5fABvh91vDAkafokpdgNUOYdGzNbc6TSHuVzy3xQcSCg4wnHO/wh5oQKTctcJY
         EZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PuoqIYg2h4GAkf+klWzahAc5y/3k74tDlxUvlYyB17A=;
        b=qHaluxf2ei/sTVCLqt1XQOYIZWFyTOCuZ+M76Wy7e266TsT6ijijFdIKUP6vUI/VYB
         v0PBYS1e2hewIysPvntFCUWMRhbHC98sBEVlluxXyH+bnFpHdrcfNCKmrGQ6TFYQD+fL
         R6pncKf3lNSY3tLuGQRqzX+4PRVjVt5s26uZrhv9cwPLlyRDQmcMDNauv7wfNScvcOuf
         1NalHJB1gQODrSPW7j+/6jsAyf98Cz3TNS7s4xDJvzzPu2IauEaYC1I5qMx1899tY64N
         nFy2QY4jLlYHlovVVj0blfUIvjNHNv5aIoC/VaD7UwgtGtkKg4QmqsUx8K/vccRLbfk0
         sUHQ==
X-Gm-Message-State: APjAAAUv7g5tuxSM3jKHDHG1dy9Rx2UsBi7Cd64j8+ouw2Zgmrjqkfkp
        XZ10r0VNAlNd96DT9b7LcfpyHXbj0zsxWQ==
X-Google-Smtp-Source: APXvYqzqFx0MnT9SRvbO/YfNA3BgSyVXJ5XlZX0UCr6NL2bJkidROqseDKZOhAUN7BSNOc7DYVkXjKrL6j48DQ==
X-Received: by 2002:ac8:4456:: with SMTP id m22mr490829qtn.362.1579035638818;
 Tue, 14 Jan 2020 13:00:38 -0800 (PST)
Date:   Tue, 14 Jan 2020 13:00:35 -0800
Message-Id: <20200114210035.65042-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH net] macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jurgen Van Ham <juvanham@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I missed the fact that macvlan_broadcast() can be used both
in RX and TX.

skb_eth_hdr() makes only sense in TX paths, so we can not
use it blindly in macvlan_broadcast()

Fixes: 96cc4b69581d ("macvlan: do not assume mac_header is set in macvlan_broadcast()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jurgen Van Ham <juvanham@gmail.com>
---
 drivers/net/macvlan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 747c0542a53c763676d491c91a5b704f0eb9848e..c5bf61565726b15aa1ea63590d7d8627b0c20d4a 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -259,7 +259,7 @@ static void macvlan_broadcast(struct sk_buff *skb,
 			      struct net_device *src,
 			      enum macvlan_mode mode)
 {
-	const struct ethhdr *eth = skb_eth_hdr(skb);
+	const struct ethhdr *eth = eth_hdr(skb);
 	const struct macvlan_dev *vlan;
 	struct sk_buff *nskb;
 	unsigned int i;
@@ -513,10 +513,11 @@ static int macvlan_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 	const struct macvlan_dev *dest;
 
 	if (vlan->mode == MACVLAN_MODE_BRIDGE) {
-		const struct ethhdr *eth = (void *)skb->data;
+		const struct ethhdr *eth = skb_eth_hdr(skb);
 
 		/* send to other bridge ports directly */
 		if (is_multicast_ether_addr(eth->h_dest)) {
+			skb_reset_mac_header(skb);
 			macvlan_broadcast(skb, port, dev, MACVLAN_MODE_BRIDGE);
 			goto xmit_world;
 		}
-- 
2.25.0.rc1.283.g88dfdc4193-goog

