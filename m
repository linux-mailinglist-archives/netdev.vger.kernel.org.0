Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A9824FFF7
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 16:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgHXOiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 10:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgHXOiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 10:38:51 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7057C061573;
        Mon, 24 Aug 2020 07:38:50 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4BZvrN2FGbzKmfC;
        Mon, 24 Aug 2020 16:38:44 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aixah.de; s=MBO0001;
        t=1598279922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lu9Ktp+bySCFRtP7BRL14t8FuxO69qAJr/NQBMQAZ48=;
        b=rrjRoZthRzUL9dU+E60L2oqOFYngU8pq51imshEww5POU7e6+TBNG8U/W6aqwX6dtEG6yR
        svwsKyNS0IVDdW6EBQbMWKJmTriw4rBwGrEwOUG6hk33+nU3QYmS+QjFgh+Mt24Wyv61wZ
        QrXBeFZLtSjchuFBmj/xuMHTzuLA1i4X6N6ipEbwITB6nxDgtcfDuUwv7yorXBsCr5p2gJ
        DsAVsGWAmsf/NqyoNHTqZkS6K1Ay2ItVwoINg4RDLgEcYVt9T6xw8blz5gNXzmA/5acmTQ
        tSAopkJ6NYXil9usLfKReq7fXr5KaHmK1l4s/g6d6/vHD14XjhOBsukEidTpBA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id HVvsVQgvEvFc; Mon, 24 Aug 2020 16:38:41 +0200 (CEST)
From:   Mira Ressel <aranea@aixah.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     Mira Ressel <aranea@aixah.de>
Subject: [PATCH 1/2] veth: Initialize dev->perm_addr
Date:   Mon, 24 Aug 2020 14:38:26 +0000
Message-Id: <20200824143828.5964-1-aranea@aixah.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.46 / 15.00 / 15.00
X-Rspamd-Queue-Id: 242C55FE
X-Rspamd-UID: e6eb65
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the perm_addr of veth devices to whatever MAC has been assigned to
the device. Otherwise, it remains all zero, with the consequence that
ipv6_generate_stable_address() (which is used if the sysctl
net.ipv6.conf.DEV.addr_gen_mode is set to 2 or 3) assigns every veth
interface on a host the same link-local address.

The new behaviour matches that of several other virtual interface types
(such as gre), and as far as I can tell, perm_addr isn't used by any
other code sites that are relevant to veth.

Signed-off-by: Mira Ressel <aranea@aixah.de>
---
 drivers/net/veth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index e56cd562a664..af1a7cda6205 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1342,6 +1342,8 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	if (!ifmp || !tbp[IFLA_ADDRESS])
 		eth_hw_addr_random(peer);
 
+	memcpy(peer->perm_addr, peer->dev_addr, peer->addr_len);
+
 	if (ifmp && (dev->ifindex != 0))
 		peer->ifindex = ifmp->ifi_index;
 
@@ -1370,6 +1372,8 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	if (tb[IFLA_ADDRESS] == NULL)
 		eth_hw_addr_random(dev);
 
+	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
+
 	if (tb[IFLA_IFNAME])
 		nla_strlcpy(dev->name, tb[IFLA_IFNAME], IFNAMSIZ);
 	else
-- 
2.25.4

