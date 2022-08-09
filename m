Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E122B58D3AC
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 08:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiHIGXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 02:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbiHIGXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 02:23:21 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 721801FCC8;
        Mon,  8 Aug 2022 23:23:19 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:50634.2011200144
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.8.199 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 1F5EF2800B9;
        Tue,  9 Aug 2022 14:23:09 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 1e91304342df415f95cdfdc294bf4188 for j.vosburgh@gmail.com;
        Tue, 09 Aug 2022 14:23:15 CST
X-Transaction-ID: 1e91304342df415f95cdfdc294bf4188
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        razor@blackwall.org, huyd12@chinatelecom.cn,
        sunshouxin@chinatelecom.cn
Subject: [PATCH v2] net:bonding:support balance-alb interface with vlan to bridge
Date:   Mon,  8 Aug 2022 23:21:03 -0700
Message-Id: <20220809062103.31213-1-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In my test, balance-alb bonding with two slaves eth0 and eth1,
and then Bond0.150 is created with vlan id attached bond0.
After adding bond0.150 into one linux bridge, I noted that Bond0,
bond0.150 and  bridge were assigned to the same MAC as eth0.
Once bond0.150 receives a packet whose dest IP is bridge's
and dest MAC is eth1's, the linux bridge will not match
eth1's MAC entry in FDB, and not handle it as expected.
The patch fix the issue, and diagram as below:

eth1(mac:eth1_mac)--bond0(balance-alb,mac:eth0_mac)--eth0(mac:eth0_mac)
                      |
                   bond0.150(mac:eth0_mac)
                      |
                   bridge(ip:br_ip, mac:eth0_mac)--other port

Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---

changelog:
v1->v2:
  -declare variabls in reverse xmas tree order
  -delete {}
  -add explanation in commit message
---
 drivers/net/bonding/bond_alb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 007d43e46dcb..60cb9a0225aa 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -653,6 +653,7 @@ static struct slave *rlb_choose_channel(struct sk_buff *skb,
 static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 {
 	struct slave *tx_slave = NULL;
+	struct net_device *dev;
 	struct arp_pkt *arp;
 
 	if (!pskb_network_may_pull(skb, sizeof(*arp)))
@@ -665,6 +666,12 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 	if (!bond_slave_has_mac_rx(bond, arp->mac_src))
 		return NULL;
 
+	dev = ip_dev_find(dev_net(bond->dev), arp->ip_src);
+	if (dev) {
+		if (netif_is_bridge_master(dev))
+			return NULL;
+	}
+
 	if (arp->op_code == htons(ARPOP_REPLY)) {
 		/* the arp must be sent on the selected rx channel */
 		tx_slave = rlb_choose_channel(skb, bond, arp);
-- 
2.27.0

