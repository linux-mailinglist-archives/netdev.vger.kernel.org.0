Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27A91FE629
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgFRBPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729454AbgFRBPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACE5420EDD;
        Thu, 18 Jun 2020 01:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442918;
        bh=rutzPEl2f7cOnbva9y8pjKUQeM2RyFfBKGQFZIhc/3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbFKMkX8jzMmyE6WbLAlzlaS5zk77ITpjjmnJGxsbFDodDg50DEaklLv5IzZ7CiV1
         jRwCJMjouEC/F3fBHyf1C+cLMmnmN9J4cy/WdrEGit0VZSCVOKrXm1jz0sHhU9Oqww
         C6j/2BQVhnGRGxl7tZV9W7k4B7KwcKcav8TACQRQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Benc <jbenc@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 335/388] geneve: change from tx_error to tx_dropped on missing metadata
Date:   Wed, 17 Jun 2020 21:07:12 -0400
Message-Id: <20200618010805.600873-335-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 9d149045b3c0e44c049cdbce8a64e19415290017 ]

If the geneve interface is in collect_md (external) mode, it can't send any
packets submitted directly to its net interface, as such packets won't have
metadata attached. This is expected.

However, the kernel itself sends some packets to the interface, most
notably, IPv6 DAD, IPv6 multicast listener reports, etc. This is not wrong,
as tunnel metadata can be specified in routing table (although technically,
that has never worked for IPv6, but hopefully will be fixed eventually) and
then the interface must correctly participate in IPv6 housekeeping.

The problem is that any such attempt increases the tx_error counter. Just
bringing up a geneve interface with IPv6 enabled is enough to see a number
of tx_errors. That causes confusion among users, prompting them to find
a network error where there is none.

Change the counter used to tx_dropped. That better conveys the meaning
(there's nothing wrong going on, just some packets are getting dropped) and
hopefully will make admins panic less.

Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 6b461be1820b..75266580b586 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -987,9 +987,10 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (geneve->collect_md) {
 		info = skb_tunnel_info(skb);
 		if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX))) {
-			err = -EINVAL;
 			netdev_dbg(dev, "no tunnel metadata\n");
-			goto tx_error;
+			dev_kfree_skb(skb);
+			dev->stats.tx_dropped++;
+			return NETDEV_TX_OK;
 		}
 	} else {
 		info = &geneve->info;
@@ -1006,7 +1007,7 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (likely(!err))
 		return NETDEV_TX_OK;
-tx_error:
+
 	dev_kfree_skb(skb);
 
 	if (err == -ELOOP)
-- 
2.25.1

