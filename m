Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5C8743A4
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 05:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389658AbfGYDJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 23:09:02 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:2114 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389532AbfGYDJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 23:09:02 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.17]) by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee45d391d45286-208c0; Thu, 25 Jul 2019 11:08:53 +0800 (CST)
X-RM-TRANSID: 2ee45d391d45286-208c0
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee95d391d44b50-2307c;
        Thu, 25 Jul 2019 11:08:52 +0800 (CST)
X-RM-TRANSID: 2ee95d391d44b50-2307c
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH] ipip: validate header length in ipip_tunnel_xmit
Date:   Thu, 25 Jul 2019 11:07:56 +0800
Message-Id: <1564024076-13764-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564024076-13764-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1564024076-13764-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
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



