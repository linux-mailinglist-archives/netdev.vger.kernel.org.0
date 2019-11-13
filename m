Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66EE6FA655
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbfKMC2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:28:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727384AbfKMBuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A4D02245B;
        Wed, 13 Nov 2019 01:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609839;
        bh=m8ERbeqrZ/eUAIPtFx7NLl7oDl1dzP+VpC0SU6Jihsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBsde14r/XdMBjLe5dk8+vmRBILgg60AIHFJw4d5xxxRxCPfboL9UxZ0lzqKY114A
         r3dcQUtF4wV1Lcp+/RvV+h+AJvFsGtDiX8zzpUaHY8xKDH8S0KSORxIQxM9qAN7vIu
         q44qfJQT2LMEs9SMgv2C3dYSSoh8/wnT/J3n7wOE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifeng Sun <pkusunyifeng@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: [PATCH AUTOSEL 4.19 011/209] openvswitch: Use correct reply values in datapath and vport ops
Date:   Tue, 12 Nov 2019 20:47:07 -0500
Message-Id: <20191113015025.9685-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yifeng Sun <pkusunyifeng@gmail.com>

[ Upstream commit 804fe108fc92e591ddfe9447e7fb4691ed16daee ]

This patch fixes the bug that all datapath and vport ops are returning
wrong values (OVS_FLOW_CMD_NEW or OVS_DP_CMD_NEW) in their replies.

Signed-off-by: Yifeng Sun <pkusunyifeng@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 8e396c7c83894..66c726595a95d 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1182,14 +1182,14 @@ static int ovs_flow_cmd_set(struct sk_buff *skb, struct genl_info *info)
 						       ovs_header->dp_ifindex,
 						       reply, info->snd_portid,
 						       info->snd_seq, 0,
-						       OVS_FLOW_CMD_NEW,
+						       OVS_FLOW_CMD_SET,
 						       ufid_flags);
 			BUG_ON(error < 0);
 		}
 	} else {
 		/* Could not alloc without acts before locking. */
 		reply = ovs_flow_cmd_build_info(flow, ovs_header->dp_ifindex,
-						info, OVS_FLOW_CMD_NEW, false,
+						info, OVS_FLOW_CMD_SET, false,
 						ufid_flags);
 
 		if (IS_ERR(reply)) {
@@ -1265,7 +1265,7 @@ static int ovs_flow_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	reply = ovs_flow_cmd_build_info(flow, ovs_header->dp_ifindex, info,
-					OVS_FLOW_CMD_NEW, true, ufid_flags);
+					OVS_FLOW_CMD_GET, true, ufid_flags);
 	if (IS_ERR(reply)) {
 		err = PTR_ERR(reply);
 		goto unlock;
@@ -1389,7 +1389,7 @@ static int ovs_flow_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		if (ovs_flow_cmd_fill_info(flow, ovs_header->dp_ifindex, skb,
 					   NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					   OVS_FLOW_CMD_NEW, ufid_flags) < 0)
+					   OVS_FLOW_CMD_GET, ufid_flags) < 0)
 			break;
 
 		cb->args[0] = bucket;
@@ -1730,7 +1730,7 @@ static int ovs_dp_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	ovs_dp_change(dp, info->attrs);
 
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
-				   info->snd_seq, 0, OVS_DP_CMD_NEW);
+				   info->snd_seq, 0, OVS_DP_CMD_SET);
 	BUG_ON(err < 0);
 
 	ovs_unlock();
@@ -1761,7 +1761,7 @@ static int ovs_dp_cmd_get(struct sk_buff *skb, struct genl_info *info)
 		goto err_unlock_free;
 	}
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
-				   info->snd_seq, 0, OVS_DP_CMD_NEW);
+				   info->snd_seq, 0, OVS_DP_CMD_GET);
 	BUG_ON(err < 0);
 	ovs_unlock();
 
@@ -1785,7 +1785,7 @@ static int ovs_dp_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		if (i >= skip &&
 		    ovs_dp_cmd_fill_info(dp, skb, NETLINK_CB(cb->skb).portid,
 					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					 OVS_DP_CMD_NEW) < 0)
+					 OVS_DP_CMD_GET) < 0)
 			break;
 		i++;
 	}
@@ -2101,7 +2101,7 @@ static int ovs_vport_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_NEW);
+				      OVS_VPORT_CMD_SET);
 	BUG_ON(err < 0);
 
 	ovs_unlock();
@@ -2182,7 +2182,7 @@ static int ovs_vport_cmd_get(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock_free;
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_NEW);
+				      OVS_VPORT_CMD_GET);
 	BUG_ON(err < 0);
 	rcu_read_unlock();
 
@@ -2218,7 +2218,7 @@ static int ovs_vport_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
 						    NLM_F_MULTI,
-						    OVS_VPORT_CMD_NEW) < 0)
+						    OVS_VPORT_CMD_GET) < 0)
 				goto out;
 
 			j++;
-- 
2.20.1

