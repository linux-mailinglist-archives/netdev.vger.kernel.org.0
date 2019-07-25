Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C383743A8
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 05:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389693AbfGYDJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 23:09:46 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:21108 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389532AbfGYDJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 23:09:46 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.15]) by rmmx-syy-dmz-app11-12011 (RichMail) with SMTP id 2eeb5d391d3f18a-2076e; Thu, 25 Jul 2019 11:08:47 +0800 (CST)
X-RM-TRANSID: 2eeb5d391d3f18a-2076e
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee85d391d3eb26-23857;
        Thu, 25 Jul 2019 11:08:47 +0800 (CST)
X-RM-TRANSID: 2ee85d391d3eb26-23857
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH] ipip: validate header length in ipip_tunnel_xmit
Date:   Thu, 25 Jul 2019 11:07:55 +0800
Message-Id: <1564024076-13764-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need the same checks introduced by commit cb9f1b783850
("ip: validate header length on virtual device xmit") for
ipip tunnel.

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 net/ipv4/ipip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 43adfc1..2f01cf6 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -275,6 +275,9 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb,
 	const struct iphdr  *tiph = &tunnel->parms.iph;
 	u8 ipproto;
 
+	if (!pskb_inet_may_pull(skb))
+		goto tx_error;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		ipproto = IPPROTO_IPIP;
-- 
1.8.3.1



