Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F1F13FB17
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 22:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388491AbgAPVJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 16:09:07 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35961 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgAPVJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 16:09:07 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so5338835wma.1;
        Thu, 16 Jan 2020 13:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Y8T0LPhXvEEKrjw1/813oRPUBDyZ1NO53dcb34gWG50=;
        b=ZONZ2su5htyGzqzsSoWZND02u190pKEn8e1VmFC+Ql8vpcUP2lmL6u9WsJFsbGZL+V
         Gcb3dbHp4H/hg5SohXJOi7F3BQUaCBbAAvAOJCKUnH37m3UOuU1pSFg6mh5A59AmK9wn
         1m5ZMXq+JI6XypKEY/Y8Fcsy2csEJvKmmFkZ2EFtQ4oWJzB6dZTBOy971QZoTEs8/GCT
         LWDQPTSYVc7s4AcmDvbVbuo4lnUQai2UeKp90vcwR+0TgpCLAtKtqo97puzIlmglofZO
         jGoWLvsVdAhEG3oDWxlJtwtQ8r8VSkISj70vulkOuii9nRSYAj6WhoZ8XhTW8TGefo1G
         HoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Y8T0LPhXvEEKrjw1/813oRPUBDyZ1NO53dcb34gWG50=;
        b=EP96z/xW8FkUYF+r+h3Vj9J1BQg9ndj3DQCwM/AZD2+L4TZufygfLNkifjVUwF1Y1L
         Jql5yy8Oa55QmYufZdHIIFrbplcbxUBpe/1tVG5sImubKxTtCwMps/CW8AjagqM0T0oW
         FyGinBWhraJZt8y2JJN6MxPXcqZHp2BEPVMSoDYy+GMi+Njs8onHzvbFZsmLOVwOxwkH
         GVaBkj86CEGkIW2FRe8VDLfOfWVITkxib/M2mFw5jKgnLj7s75GdjkHfFID/Bo1UDdWs
         hzCVHhvo4wE8HBeIvMRQDjOnZNHRq29FTSlhcWOuh5ONlxxO9F4om0FN/ctKiTuoUO6Y
         CnpQ==
X-Gm-Message-State: APjAAAXP4ukWiQdyR3c+fyztm+paVgsUNb5zNHyVgJRVwPPEVZeUOYLQ
        sFikhA6wPqUcSjILqhlMcHXdEh/o
X-Google-Smtp-Source: APXvYqwyv4SG3Uf4CY7AOxxtXVuskSozIyEQ8JRkPfq6a9aN3a0w7So5f0rOyhQmfD8q9LuSTzjHYg==
X-Received: by 2002:a1c:9e4c:: with SMTP id h73mr983990wme.177.1579208944348;
        Thu, 16 Jan 2020 13:09:04 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d10sm31744282wrw.64.2020.01.16.13.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 13:09:03 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: systemport: Fixed queue mapping in internal ring map
Date:   Thu, 16 Jan 2020 13:08:58 -0800
Message-Id: <20200116210859.7376-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We would not be transmitting using the correct SYSTEMPORT transmit queue
during ndo_select_queue() which looks up the internal TX ring map
because while establishing the mapping we would be off by 4, so for
instance, when we populate switch port mappings we would be doing:

switch port 0, queue 0 -> ring index #0
switch port 0, queue 1 -> ring index #1
...
switch port 0, queue 3 -> ring index #3
switch port 1, queue 0 -> ring index #8 (4 + 4 * 1)
...

instead of using ring index #4. This would cause our ndo_select_queue()
to use the fallback queue mechanism which would pick up an incorrect
ring for that switch port. Fix this by using the correct switch queue
number instead of SYSTEMPORT queue number.

Fixes: 3ed67ca243b3 ("net: systemport: Simplify queue mapping logic")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 825af709708e..d6b1a153f9df 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2323,7 +2323,7 @@ static int bcm_sysport_map_queues(struct notifier_block *nb,
 		ring->switch_queue = qp;
 		ring->switch_port = port;
 		ring->inspect = true;
-		priv->ring_map[q + port * num_tx_queues] = ring;
+		priv->ring_map[qp + port * num_tx_queues] = ring;
 		qp++;
 	}
 
@@ -2338,7 +2338,7 @@ static int bcm_sysport_unmap_queues(struct notifier_block *nb,
 	struct net_device *slave_dev;
 	unsigned int num_tx_queues;
 	struct net_device *dev;
-	unsigned int q, port;
+	unsigned int q, qp, port;
 
 	priv = container_of(nb, struct bcm_sysport_priv, dsa_notifier);
 	if (priv->netdev != info->master)
@@ -2364,7 +2364,8 @@ static int bcm_sysport_unmap_queues(struct notifier_block *nb,
 			continue;
 
 		ring->inspect = false;
-		priv->ring_map[q + port * num_tx_queues] = NULL;
+		qp = ring->switch_queue;
+		priv->ring_map[qp + port * num_tx_queues] = NULL;
 	}
 
 	return 0;
-- 
2.17.1

