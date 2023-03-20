Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4386C0AAA
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 07:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCTGcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 02:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCTGcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 02:32:18 -0400
Received: from cstnet.cn (smtp80.cstnet.cn [159.226.251.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E9937DAC;
        Sun, 19 Mar 2023 23:32:16 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-01 (Coremail) with SMTP id qwCowABnb0ve_RdkMBlgEw--.236S2;
        Mon, 20 Mar 2023 14:31:59 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     simon.horman@corigine.com
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH 1/2] Bluetooth: 6LoWPAN: Modify the error handling in the loop
Date:   Mon, 20 Mar 2023 14:31:55 +0800
Message-Id: <20230320063156.31047-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowABnb0ve_RdkMBlgEw--.236S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZr1DAr1Dtr18GFyxGw13CFg_yoWkKFX_JF
        y8Zayruw4UArWxXrsrta1rury3Zwn5JFyxWwn3tFWUJFyDJayUWr1vqr4rXr1xuas2gFnr
        ArnxXa48Xw4fujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbx8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
        0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUq38
        nUUUUU=
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return the error when send_pkt fails in order to avoid the error being
overwritten.
Moreover, remove the redundant 'ret'.

Fixes: 9c238ca8ec79 ("Bluetooth: 6lowpan: Check transmit errors for multicast packets")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/bluetooth/6lowpan.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 4eb1b3ced0d2..bd6dbca5747f 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -474,22 +474,20 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
 		dev = lowpan_btle_dev(entry->netdev);
 
 		list_for_each_entry_rcu(pentry, &dev->peers, list) {
-			int ret;
-
 			local_skb = skb_clone(skb, GFP_ATOMIC);
 
 			BT_DBG("xmit %s to %pMR type %u IP %pI6c chan %p",
 			       netdev->name,
 			       &pentry->chan->dst, pentry->chan->dst_type,
 			       &pentry->peer_addr, pentry->chan);
-			ret = send_pkt(pentry->chan, local_skb, netdev);
-			if (ret < 0)
-				err = ret;
-
+			err = send_pkt(pentry->chan, local_skb, netdev);
 			kfree_skb(local_skb);
+			if (err < 0)
+				goto out;
 		}
 	}
 
+out:
 	rcu_read_unlock();
 
 	return err;
-- 
2.25.1

