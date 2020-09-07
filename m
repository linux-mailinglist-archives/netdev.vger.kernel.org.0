Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8486E260040
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbgIGQpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730836AbgIGQfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:35:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2936822204;
        Mon,  7 Sep 2020 16:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496532;
        bh=WR+g6BJmosRtwJSoMvEhD8ZZWYEATjLLIsh6e4mzX3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3IaHXs2wsYi896xT3GLhPTv2XknHHH0u5BuJFaZdeb4KSq7vAe3C4AySPj1qG6pP
         HwlSK7ZDCVD0pGGXFo6uCuPg5e2KItoLTGOy7FKl/rg63LKLOECdAyyptLmq4CVJys
         ZiifZh0vGcOtKJl+0/w8Un47ra1TOacv1rXTUxp8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/13] drivers/net/wan/lapbether: Set network_header before transmitting
Date:   Mon,  7 Sep 2020 12:35:16 -0400
Message-Id: <20200907163524.1281734-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163524.1281734-1-sashal@kernel.org>
References: <20200907163524.1281734-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 91244d108441013b7367b3b4dcc6869998676473 ]

Set the skb's network_header before it is passed to the underlying
Ethernet device for transmission.

This patch fixes the following issue:

When we use this driver with AF_PACKET sockets, there would be error
messages of:
   protocol 0805 is buggy, dev (Ethernet interface name)
printed in the system "dmesg" log.

This is because skbs passed down to the Ethernet device for transmission
don't have their network_header properly set, and the dev_queue_xmit_nit
function in net/core/dev.c complains about this.

Reason of setting the network_header to this place (at the end of the
Ethernet header, and at the beginning of the Ethernet payload):

Because when this driver receives an skb from the Ethernet device, the
network_header is also set at this place.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 5befc7f3f0e7a..c6db9a4e7c457 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -213,6 +213,8 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 
 	skb->dev = dev = lapbeth->ethdev;
 
+	skb_reset_network_header(skb);
+
 	dev_hard_header(skb, dev, ETH_P_DEC, bcast_addr, NULL, 0);
 
 	dev_queue_xmit(skb);
-- 
2.25.1

