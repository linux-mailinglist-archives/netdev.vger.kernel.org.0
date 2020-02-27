Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24262171722
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgB0M0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:26:24 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43428 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbgB0M0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 07:26:24 -0500
Received: by mail-pl1-f196.google.com with SMTP id p11so1073955plq.10
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 04:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BuwmLWsXaZpRdIYQwCY0BtEp7EeVTZTKq3J85lL3RNQ=;
        b=HwBE1EUIBorJvrLHw2VwPtSgHLGpxuh6BCuC/bGdXOOYKBFRKlCXZCkxy3y9hNEcXw
         GLRDv+7YuAJl3EwOav0u94t3nqjVwHP5KQlIF23F4b3N/ZYPh5lFMKIHJh+FL0Ri+YSG
         sN2ttnyTe/ppy/+SRTmRttaVuwNIbpfASU2jhfegd+AARAEVusg5v4JrS48D4dO7N+ZE
         Xpnj0eSaosUK87VVuTToPJyXxjDLC0OWP3+0M9e2ltlVm8EOGmjfoZbGOC899M6E8PXk
         I8wtqnmCULYOwCxXkrv6BO6wCWyKmRDPsBx+Ox0126w67hsiBsp3Cah2a8sBra4czZZz
         BkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BuwmLWsXaZpRdIYQwCY0BtEp7EeVTZTKq3J85lL3RNQ=;
        b=ntrOyC9jJXkjbkY38xUPMErXaw5H7E1LWaLfbjc3GPrVsSsReR02JyufJruq1pBz8h
         gYdf3uDF0mYTelskql8msinKWzvtnPjdrnTDwEN0enIDVFQiRG15PrLR4PFyKsrClDOU
         X01Hniu012EiKXXbqoloAb6USkpRjcNVFLFBHQu8Mdwp9fzNMPWs9/pblisP5rWZVNhq
         AdLqE2ptNS1m0NGbCghnVxyb20IccbwMgPLDGX1/M/Ii5Zjd7+1gGFOJgWHvK+4a1spZ
         cvKjiBFcHuLarkxOqjcvqyIzYEMapC5P8g0qoRzQw8V7yWnJemEedleycmWmw9oejjqf
         Klhw==
X-Gm-Message-State: APjAAAWaWUwvTlUOxpmghXV3S6D08BMd1zmSRN4MMQiPj9bLDwBdsv8M
        2K9o3wGsGp8MeFKzXHbWtLM=
X-Google-Smtp-Source: APXvYqzkj6hjvXx8N8yIjo/CbFX2yIKwvp7mcVn3dwswxWwtFra8cTzAM5URQROYhPlf/EuSDtNdFg==
X-Received: by 2002:a17:902:9a94:: with SMTP id w20mr4454047plp.6.1582806382747;
        Thu, 27 Feb 2020 04:26:22 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id v184sm7031109pfc.67.2020.02.27.04.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 04:26:21 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 8/8] net: rmnet: fix packet forwarding in rmnet bridge mode
Date:   Thu, 27 Feb 2020 12:26:15 +0000
Message-Id: <20200227122615.19593-1-ap420073@gmail.com>
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
    modprobe rmnet
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

v1 -> v2:
  - this patch is not changed.

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

