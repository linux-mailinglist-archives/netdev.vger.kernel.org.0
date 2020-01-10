Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E2E137926
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 23:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgAJWG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 17:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbgAJWG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 17:06:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB0E3206ED;
        Fri, 10 Jan 2020 22:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693986;
        bh=PCWAB6L5Vsbefwr/ez1Wa0h1klyfxdyI5ew0MmL1jhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXUSbAbrp42giAK2Mu6y5Xou7EFSSWJ93RGyWddmRgA07QKQhkj5YnPcQ2UUMsVju
         vmNl/5ZVEUcbja95ZHzFJO7PHtqQgeiUMThP2+uXVQ7RFYjoK1ZRpcbUA/sZD1ZLgp
         WXMvp0lNIKm6B5or2poRZUJoPFlPLmCCvP8N2ocU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/8] hsr: reset network header when supervision frame is created
Date:   Fri, 10 Jan 2020 17:06:17 -0500
Message-Id: <20200110220621.28651-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220621.28651-1-sashal@kernel.org>
References: <20200110220621.28651-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 3ed0a1d563903bdb4b4c36c58c4d9c1bcb23a6e6 ]

The supervision frame is L2 frame.
When supervision frame is created, hsr module doesn't set network header.
If tap routine is enabled, dev_queue_xmit_nit() is called and it checks
network_header. If network_header pointer wasn't set(or invalid),
it resets network_header and warns.
In order to avoid unnecessary warning message, resetting network_header
is needed.

Test commands:
    ip netns add nst
    ip link add veth0 type veth peer name veth1
    ip link add veth2 type veth peer name veth3
    ip link set veth1 netns nst
    ip link set veth3 netns nst
    ip link set veth0 up
    ip link set veth2 up
    ip link add hsr0 type hsr slave1 veth0 slave2 veth2
    ip a a 192.168.100.1/24 dev hsr0
    ip link set hsr0 up
    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip link set veth3 up
    ip netns exec nst ip link add hsr1 type hsr slave1 veth1 slave2 veth3
    ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
    ip netns exec nst ip link set hsr1 up
    tcpdump -nei veth0

Splat looks like:
[  175.852292][    C3] protocol 88fb is buggy, dev veth0

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index cfe20f15f618..c962c406d7b1 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -281,6 +281,8 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 			    skb->dev->dev_addr, skb->len) <= 0)
 		goto out;
 	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
 
 	if (hsrVer > 0) {
 		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
-- 
2.20.1

