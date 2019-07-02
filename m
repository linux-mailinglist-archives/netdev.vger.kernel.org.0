Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C0B5C7E5
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 05:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfGBDkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 23:40:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44661 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGBDkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 23:40:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so7537210pfe.11
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 20:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m4N3JIdLui2XTYPoFeMKsDJq7OUD6aQPWupKoVO6UnQ=;
        b=LTgEhPadSZd0I0KDUcGbiT19UYBO8ib0lXe0s0DVfqL7fPCfNJsHYZQuP6rq9WZ9FW
         fA5d4dNe+J7hotn3AC9ldnU5PMvCPSJd5/AC98rtaoCFbgtAvWy0aiaaVfFL031b+DK5
         SUcQxkZg7PZttCc0Ae3NP1Vxu5Xfqc9LkVJJcltozQNHsYU0tnnq0DXcFYX1j8OKWf7k
         uH5iTF1lIoERkIX65GkWZhWp4Y46M4M1Iywfx5as4/FR9kvIHEI3GBJ1sdraRz+K7zgU
         CuQ3k43kul8pfcWH03I3d1kW1F96ovzrSdTBmTTNmoD6+g5yuDExuRDQbnStPyfT2klL
         V2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m4N3JIdLui2XTYPoFeMKsDJq7OUD6aQPWupKoVO6UnQ=;
        b=r1m564CVANOyyYw7yb7byZJlMUrMz4BHZrd2jj91GOPoSYFupCk+pObNo2pDVASSY1
         wI3wMJ7qx7nrvbBWaHhHKboX6axnjlLgJB3wsrnTSkUfgrgwAOi/JFulDPusyWQ4z0Jd
         mMsI9iDffRHmW/aqvwdglVcFYK9q0Xfz75HeqW+h8oKtipX64zOyLH3Rzni2YWwQfe/Y
         rfVCPcMrYBI4kfq3CGtHMAQmpe11I9q59WnRrXrT/NBo49w3VnUZDHDHl/Xz8/CHGYXY
         v5c7R33Zq93LmwubD5cnkOz7Y6qmvLxrPvTlBrRMfWSZhQ8IKzJgZTh0fLPYE681AaOu
         DFXg==
X-Gm-Message-State: APjAAAVdNKI/gtnzJtNWfhDVvkzCiRFZTSs52VPvCAK4YgdQmHplhk3u
        qYjn9jjoqzaVfHuq67fk8uz9au8f4oc=
X-Google-Smtp-Source: APXvYqwRbtBEoZ3v5Gq9J/hbxSM6jJqci4yP0pv703CuyOjnVDH+CmcpKfCoccwmMGzLqJ7KOesVGQ==
X-Received: by 2002:a17:90a:8c0c:: with SMTP id a12mr3022974pjo.67.1562038841885;
        Mon, 01 Jul 2019 20:40:41 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id c69sm869905pje.6.2019.07.01.20.40.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 20:40:41 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+e5be16aa39ad6e755391@syzkaller.appspotmail.com,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [Patch net] bonding: validate ip header before check IPPROTO_IGMP
Date:   Mon,  1 Jul 2019 20:40:24 -0700
Message-Id: <20190702034024.25962-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bond_xmit_roundrobin() checks for IGMP packets but it parses
the IP header even before checking skb->protocol.

We should validate the IP header with pskb_may_pull() before
using iph->protocol.

Reported-and-tested-by: syzbot+e5be16aa39ad6e755391@syzkaller.appspotmail.com
Fixes: a2fd940f4cff ("bonding: fix broken multicast with round-robin mode")
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/net/bonding/bond_main.c | 37 ++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 799fc38c5c34..b0aab3a0a1bf 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3866,8 +3866,8 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 					struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct iphdr *iph = ip_hdr(skb);
 	struct slave *slave;
+	int slave_cnt;
 	u32 slave_id;
 
 	/* Start with the curr_active_slave that joined the bond as the
@@ -3876,23 +3876,32 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 	 * send the join/membership reports.  The curr_active_slave found
 	 * will send all of this type of traffic.
 	 */
-	if (iph->protocol == IPPROTO_IGMP && skb->protocol == htons(ETH_P_IP)) {
-		slave = rcu_dereference(bond->curr_active_slave);
-		if (slave)
-			bond_dev_queue_xmit(bond, skb, slave->dev);
-		else
-			bond_xmit_slave_id(bond, skb, 0);
-	} else {
-		int slave_cnt = READ_ONCE(bond->slave_cnt);
+	if (skb->protocol == htons(ETH_P_IP)) {
+		int noff = skb_network_offset(skb);
+		struct iphdr *iph;
 
-		if (likely(slave_cnt)) {
-			slave_id = bond_rr_gen_slave_id(bond);
-			bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
-		} else {
-			bond_tx_drop(bond_dev, skb);
+		if (unlikely(!pskb_may_pull(skb, noff + sizeof(*iph))))
+			goto non_igmp;
+
+		iph = ip_hdr(skb);
+		if (iph->protocol == IPPROTO_IGMP) {
+			slave = rcu_dereference(bond->curr_active_slave);
+			if (slave)
+				bond_dev_queue_xmit(bond, skb, slave->dev);
+			else
+				bond_xmit_slave_id(bond, skb, 0);
+			return NETDEV_TX_OK;
 		}
 	}
 
+non_igmp:
+	slave_cnt = READ_ONCE(bond->slave_cnt);
+	if (likely(slave_cnt)) {
+		slave_id = bond_rr_gen_slave_id(bond);
+		bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
+	} else {
+		bond_tx_drop(bond_dev, skb);
+	}
 	return NETDEV_TX_OK;
 }
 
-- 
2.21.0

