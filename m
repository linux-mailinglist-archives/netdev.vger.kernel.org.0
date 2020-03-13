Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8647E184114
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCMGub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:50:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45086 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgCMGub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 02:50:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id m15so4405923pgv.12
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 23:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MChUGtY/VgoOSm3/jJPQL1b+4SXDeYcdDyRAjaA7370=;
        b=dSvNhZTWMgAvsEQ5y579jVwe/nWZ4ozwGi3Y7NJ5UHfEdVtzmoIyd48n7lhnyp9GUd
         CevN+jnj+bZdMD2S8jmkrfD3ImpQcmgVD9l4UcfcaALbSKCLqnqlvVZQmsgM593fDcdF
         iDkb9zAW/yzlIg9unw1SW6Vaxb7YbtXScEsBA4d8rUxFTxoN6tTFN51RKiOK5fKMvrVU
         r2gouBk+vxtZIi2rGGaA6UKRCYg3qQzGaC3bMRRVZO1Bzi4rNvf9xHMnejLLv+ttyuoW
         df3J+cWYDWYu3FNGnjMdnsl8PkTADZiCWI7fBgz7Zp1oINmYMTpKWJRoAUHT+myVLUCl
         2M8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MChUGtY/VgoOSm3/jJPQL1b+4SXDeYcdDyRAjaA7370=;
        b=BawqgyBG+Oqyl8TuRImCWITuLJXjZ7PQxkXj56SbYe4HfDtkS1IEY1SCtnGn/8ObOI
         +SeeUsJQ2GCbTzrqD/hyB4rkQLhQC5TEL8FZEZ3vttCH0hNi3S/gmnNYi27yGkmDGmtj
         kT+Rpuo/dmbiJL6hfFG6BPBLiJ1uR0bjA7XGcQc9tPlBts75Tz1wcpEBa6AD4rGSRviW
         XfuSazoJPqeBNdsrLZOvI8KDN9TuwC+OGp2mBm/n0QrbV32K1k/CfxYvBj0rtB1bGkw6
         h7nLUdQbA/QwxkyfceWn4ERMauRAH3UejiN/hQEPLIglAIJk6j2U0ULOqqFRdpG7Pwuh
         1+Tw==
X-Gm-Message-State: ANhLgQ0FT3iIL3pQXtgOOyc/3FCvVOXX5aJIPB5Iz4Ivb6C0bBvbWYao
        HEqAbJjg4dLp9bNtEPZGkVs=
X-Google-Smtp-Source: ADFU+vsbbtfrtTcEPcBnwDVoJjOhnY3Btye0NMC1YqgV/ccOYoLLVgFnoyawzXia49IdkdLbm4Putw==
X-Received: by 2002:a62:ae0f:: with SMTP id q15mr1356340pff.72.1584082230069;
        Thu, 12 Mar 2020 23:50:30 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id e12sm41713197pff.168.2020.03.12.23.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 23:50:29 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 2/3] hsr: add restart routine into hsr_get_node_list()
Date:   Fri, 13 Mar 2020 06:50:24 +0000
Message-Id: <20200313065024.32247-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hsr_get_node_list() is to send node addresses to the userspace.
If there are so many nodes, it could fail because of buffer size.
In order to avoid this failure, the restart routine is added.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1->v2:
 - Preserve reverse christmas tree variable ordering

 net/hsr/hsr_netlink.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index d6760df2ad1f..726bfe923999 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -360,16 +360,14 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
  */
 static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 {
-	/* For receiving */
-	struct nlattr *na;
+	unsigned char addr[ETH_ALEN];
 	struct net_device *hsr_dev;
-
-	/* For sending */
 	struct sk_buff *skb_out;
-	void *msg_head;
 	struct hsr_priv *hsr;
-	void *pos;
-	unsigned char addr[ETH_ALEN];
+	bool restart = false;
+	struct nlattr *na;
+	void *pos = NULL;
+	void *msg_head;
 	int res;
 
 	if (!info)
@@ -387,8 +385,9 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	if (!is_hsr_master(hsr_dev))
 		goto rcu_unlock;
 
+restart:
 	/* Send reply */
-	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	skb_out = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!skb_out) {
 		res = -ENOMEM;
 		goto fail;
@@ -402,17 +401,28 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 		goto nla_put_failure;
 	}
 
-	res = nla_put_u32(skb_out, HSR_A_IFINDEX, hsr_dev->ifindex);
-	if (res < 0)
-		goto nla_put_failure;
+	if (!restart) {
+		res = nla_put_u32(skb_out, HSR_A_IFINDEX, hsr_dev->ifindex);
+		if (res < 0)
+			goto nla_put_failure;
+	}
 
 	hsr = netdev_priv(hsr_dev);
 
-	pos = hsr_get_next_node(hsr, NULL, addr);
+	if (!pos)
+		pos = hsr_get_next_node(hsr, NULL, addr);
 	while (pos) {
 		res = nla_put(skb_out, HSR_A_NODE_ADDR, ETH_ALEN, addr);
-		if (res < 0)
+		if (res < 0) {
+			if (res == -EMSGSIZE) {
+				genlmsg_end(skb_out, msg_head);
+				genlmsg_unicast(genl_info_net(info), skb_out,
+						info->snd_portid);
+				restart = true;
+				goto restart;
+			}
 			goto nla_put_failure;
+		}
 		pos = hsr_get_next_node(hsr, pos, addr);
 	}
 	rcu_read_unlock();
@@ -429,7 +439,7 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	return 0;
 
 nla_put_failure:
-	kfree_skb(skb_out);
+	nlmsg_free(skb_out);
 	/* Fall through */
 
 fail:
-- 
2.17.1

