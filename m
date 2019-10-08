Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628FFCF693
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 11:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbfJHJ4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 05:56:45 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:2991 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730177AbfJHJ4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 05:56:30 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee95d9c5d3b0c4-f0114; Tue, 08 Oct 2019 17:56:11 +0800 (CST)
X-RM-TRANSID: 2ee95d9c5d3b0c4-f0114
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee55d9c5d3a26f-8c8c6;
        Tue, 08 Oct 2019 17:56:10 +0800 (CST)
X-RM-TRANSID: 2ee55d9c5d3a26f-8c8c6
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH] ip6erspan: remove the incorrect mtu limit for ip6erspan
Date:   Tue,  8 Oct 2019 17:56:03 +0800
Message-Id: <1570528563-8062-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip6erspan driver calls ether_setup(), after commit 61e84623ace3
("net: centralize net_device min/max MTU checking"), the range
of mtu is [min_mtu, max_mtu], which is [68, 1500] by default.

It causes the dev mtu of the erspan device to not be greater
than 1500, this limit value is not correct for ip6erspan tap
device.

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 net/ipv6/ip6_gre.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index d5779d6..787d9f2 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2192,6 +2192,7 @@ static void ip6erspan_tap_setup(struct net_device *dev)
 {
 	ether_setup(dev);
 
+	dev->max_mtu = 0;
 	dev->netdev_ops = &ip6erspan_netdev_ops;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = ip6gre_dev_free;
-- 
1.8.3.1



