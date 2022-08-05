Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0A658A787
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 09:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240338AbiHEHy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 03:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbiHEHy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 03:54:56 -0400
X-Greylist: delayed 504 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 Aug 2022 00:54:54 PDT
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6712872EC7;
        Fri,  5 Aug 2022 00:54:53 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:53364.1398039832
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.8.199 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id D69DB280099;
        Fri,  5 Aug 2022 15:46:16 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 2f870a74468f4d4b992006056bb14515 for j.vosburgh@gmail.com;
        Fri, 05 Aug 2022 15:46:22 CST
X-Transaction-ID: 2f870a74468f4d4b992006056bb14515
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, huyd12@chinatelecom.cn,
        sunshouxin@chinatelecom.cn
Subject: [PATCH] net:bonding:support balance-alb interface with vlan to bridge
Date:   Fri,  5 Aug 2022 00:45:56 -0700
Message-Id: <20220805074556.70297-1-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
and dest MAC is eth1's, the linux bridge cannot process it as expected.
The patch fix the issue, and diagram as below:

eth1(mac:eth1_mac)--bond0(balance-alb,mac:eth0_mac)--eth0(mac:eth0_mac)
      		      |
      		   bond0.150(mac:eth0_mac)
      		      |
      	           bridge(ip:br_ip, mac:eth0_mac)--other port

Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
 drivers/net/bonding/bond_main.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e75acb14d066..6210a9c7ca76 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1537,9 +1537,11 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 	struct sk_buff *skb = *pskb;
 	struct slave *slave;
 	struct bonding *bond;
+	struct net_device *vlan;
 	int (*recv_probe)(const struct sk_buff *, struct bonding *,
 			  struct slave *);
 	int ret = RX_HANDLER_ANOTHER;
+	unsigned int headroom;
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
@@ -1591,6 +1593,24 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 				  bond->dev->addr_len);
 	}
 
+	if (skb_vlan_tag_present(skb)) {
+		if (BOND_MODE(bond) == BOND_MODE_ALB && skb->pkt_type == PACKET_HOST) {
+			vlan = __vlan_find_dev_deep_rcu(bond->dev, skb->vlan_proto,
+							skb_vlan_tag_get(skb) & VLAN_VID_MASK);
+			if (vlan) {
+				if (vlan->priv_flags & IFF_BRIDGE_PORT) {
+					headroom = skb->data - skb_mac_header(skb);
+					if (unlikely(skb_cow_head(skb, headroom))) {
+						kfree_skb(skb);
+						return RX_HANDLER_CONSUMED;
+					}
+					bond_hw_addr_copy(eth_hdr(skb)->h_dest, vlan->dev_addr,
+							  vlan->addr_len);
+				}
+			}
+		}
+	}
+
 	return ret;
 }
 
-- 
2.27.0

