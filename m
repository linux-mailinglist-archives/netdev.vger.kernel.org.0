Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D721E13BB9D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 09:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgAOI5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 03:57:07 -0500
Received: from fd.dlink.ru ([178.170.168.18]:58070 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729138AbgAOI5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 03:57:06 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 570701B20EA4; Wed, 15 Jan 2020 11:57:04 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 570701B20EA4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579078624; bh=kFoiqF0w3QZg3K17qOi1DHkbwUbvxnM+DJ7ecUc6PjI=;
        h=From:To:Cc:Subject:Date;
        b=Q+SjqO1TvUyFnPjxy2bWM5ZaM8vJ1JJIq2l7h9bOBiJrGQkhgMKwUblqMMR2FeU5p
         4BlEWBPpNk4hdM2+9+BlVwoIduATkEZXpCktTDvbJp2zitC8zu8T9fvhBq94WltRnw
         wwi0u1g3SHc+T8kahrYlRm8v9t/YXNq8BHwKW4YQ=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 3D0D91B2025C;
        Wed, 15 Jan 2020 11:56:58 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 3D0D91B2025C
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 862361B21422;
        Wed, 15 Jan 2020 11:56:57 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 15 Jan 2020 11:56:57 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Lobakin <alobakin@dlink.ru>
Subject: [PATCH net] net: dsa: tag_qca: fix doubled Tx statistics
Date:   Wed, 15 Jan 2020 11:56:52 +0300
Message-Id: <20200115085652.12586-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA subsystem takes care of netdev statistics since commit 4ed70ce9f01c
("net: dsa: Refactor transmit path to eliminate duplication"), so
any accounting inside tagger callbacks is redundant and can lead to
messing up the stats.
This bug is present in Qualcomm tagger since day 0.

Fixes: cafdc45c949b ("net-next: dsa: add Qualcomm tag RX/TX handler")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_qca.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index c95885215525..c8a128c9e5e0 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -33,9 +33,6 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u16 *phdr, hdr;
 
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
-
 	if (skb_cow_head(skb, 0) < 0)
 		return NULL;
 
-- 
2.25.0

