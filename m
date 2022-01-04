Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57609483E18
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbiADI2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:28:34 -0500
Received: from mail-bn8nam11on2052.outbound.protection.outlook.com ([40.107.236.52]:38759
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232221AbiADI2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 03:28:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cv0vbBqxKP4/GqgKY14lZLnXKhBCW7EOk4JEI9aMCPcuIzbBnWH/Oghn8gIMyNGn/F0FSfPqnhverXkA+yi59gE8Pj9w2LtUdHko8HY4s/PB80w6yGtpbhIIsc4I8PeuvkPQ7F4+OGAnixHBtw+lcXLfAk7Zr68T4ZH+X5uGycasw1sAK2gNp12XY65MnsGrZNqktn5mHWX5U4dVQe6ZvuFV8xsxDs5e56AoSf3rj9bnlCyvVjzsNP2ecHxgn3Q9t6C6ONPyOqa4VLJOFKVwcCdy4OOT67BgmDpFDUJVZ3OPG8jXDINTNUaL/Md8sQ/0P0tOEPsaFe61oXHCG0ppSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPQbm+2PWgGYccHIfmNJAIheRY/0eapW42oc+pjB2gc=;
 b=E2Lppmn6DpoS+0iBerwwLPFJhwHXQW1FNDsGfMvu+fHPE7zeSjPd/NKa6QA8HI+AQRAU9apL0ZEe+ZRR3ZKYwAXx+M7I/LMQlvqupli+R+Jb9604VNX+yS30lXyFMN3ysdxcuqQrIjI16rfi9oQTWtAhUguCSi8WWXK120RfkItXHWsEboenfwOn0qJswwaNWx38ANq+1TWLkK+jm3+Jnyb4wGPPQwiQeU7X0zvwU3si7Yf9znSih4UM6zztDQFMzS7c1ZpZfkAeYvL00cWPASkTvlq6j+55mmALz872Lt5CngazpajLJgH/UCtT0eZ/Ow70UqE6SKuc8MlFgfazfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPQbm+2PWgGYccHIfmNJAIheRY/0eapW42oc+pjB2gc=;
 b=YdjsgPxE6Ht28BJ3aHLXQrjSGjkG4QO5I5dtGmOpVi6GZ4Jx98IKqdNVwOA3Ovelw/reTxTZ91xCAavmAC27ZyK1X8MuJhwreHw5/VrO/z6UMaSRZZWDN+uUUPon9ZKtlgyWTiIteQVFDTgQyLj5GB3eNBIk248PAyXcg4xa7Wkwugt6gAveSHnAnRliOqJwDi9xE7eRXqRQfwigqTBJuD/CbsKWh04YuvwATP7WTeG7Y5RFiixUKKZDF/p22wUXwfCfNHNKs7l+rf5wolR2ypkDq37iy5TwDg+uP2C1ymjilnfGGYoTx+KX/5qx9mX8NTzHBbP5TbB2llY1zeDg/Q==
Received: from DM6PR07CA0067.namprd07.prod.outlook.com (2603:10b6:5:74::44) by
 CH2PR12MB4246.namprd12.prod.outlook.com (2603:10b6:610:a9::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Tue, 4 Jan 2022 08:28:32 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::e5) by DM6PR07CA0067.outlook.office365.com
 (2603:10b6:5:74::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13 via Frontend
 Transport; Tue, 4 Jan 2022 08:28:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 08:28:31 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 08:28:30 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 00:28:29 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Tue, 4 Jan 2022 08:28:27 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        "Vlad Buslov" <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net 1/1] net: openvswitch: Fix ct_state nat flags for conns arriving from tc
Date:   Tue, 4 Jan 2022 10:28:21 +0200
Message-ID: <20220104082821.22487-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11f7d6c6-daf7-4585-9cf6-08d9cf5c3102
X-MS-TrafficTypeDiagnostic: CH2PR12MB4246:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB42469657BE3D3AEA05275F45C24A9@CH2PR12MB4246.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UFJghGGpZ+ZfjhY8sIpmxggmkAtA439kRFQQZEBGL2R5bIpp/gdyofs9ePl1D/m/S4MyibpwtTk76S80hf7SfpNRF1sIcrRtS3hbQFRsaI/UzE0um4BwafCwjDzZ668NHIorNFuoXaWI0zxurouKwibgH1kXwJLepDktJj32VRtBAAijgfXg2DzHNehFZuDGcv0akRWOn1gma9wkaEAn/Xf6+TA9dh5Irh8Otdhgzs0Ue1tN2qVkog9c4ESpRrdAhOJCYNEx1MKc8yYBzt//8p8LZOBvpLFRDYhf8sOMlhwp5Dmeyq+zl9f2GanZIPTAAn7onvhCmszFLlS22pH8T5QPyuP+cvPCGoKqdqBwnKuE6sZDJlmgV1GIzKro/U5QglVsI0Teat3PlDKVPinZ1mZ0KVENI1x1hB/+SSs7KfZg+qKIUOuY1O+HakIgQNHhPTWGXMo/rf+xfwCbK6QjmZ8xvhCxr6yko4hwH3aN72rUnIKNv7mWJ56TGtI0S1Trd73FEjaM5FI+mf2GYxQ4NFRQV9hAAolbpHFRkVeROrc4HnwyT35Zx+mFlUDvZt9HaMoOLG2fsX0G/Kb+Q0tUwpT3Jc/K05wh40U3aNINAq3o1XrDm04aN57EWbbA7SQEWw8peks94XkJyGhAULeZlYolQiJrMMb8eMi5HvdcJsTdVSWDJCAXGERppol7pvcpkawEJ186CViahA9rf/CaIEIGln1JGyMpZAao4ySVFCgonCycsy/ogjNHXwEIuhCZNyCc3h39aYNw36b0MgWZxP+z5A9UEQMSAXjwAWB9PyA=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(36860700001)(2616005)(47076005)(82310400004)(336012)(81166007)(1076003)(107886003)(40460700001)(83380400001)(186003)(6666004)(356005)(508600001)(8676002)(26005)(2906002)(5660300002)(426003)(70586007)(316002)(86362001)(8936002)(4326008)(110136005)(70206006)(54906003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 08:28:31.4737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f7d6c6-daf7-4585-9cf6-08d9cf5c3102
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4246
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netfilter conntrack maintains NAT flags per connection indicating
whether NAT was configured for the connection. Openvswitch maintains
NAT flags on the per packet flow key ct_state field, indicating
whether NAT was actually executed on the packet.

When a packet misses from tc to ovs the conntrack NAT flags are set.
However, NAT was not necessarily executed on the packet because the
connection's state might still be in NEW state. As such, openvswitch wrongly
assumes that NAT was executed and sets an incorrect flow key NAT flags.

Fix this, by flagging to openvswitch which NAT was actually done in
act_ct via tc_skb_ext and tc_skb_cb to the openvswitch module, so
the packet flow key NAT flags will be correctly set.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 include/linux/skbuff.h  |  4 +++-
 include/net/pkt_sched.h |  4 +++-
 net/openvswitch/flow.c  | 16 +++++++++++++---
 net/sched/act_ct.c      |  6 ++++++
 net/sched/cls_api.c     |  2 ++
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4507d77d6941..bab45a009310 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -287,7 +287,9 @@ struct tc_skb_ext {
 	__u32 chain;
 	__u16 mru;
 	__u16 zone;
-	bool post_ct;
+	bool post_ct:1;
+	bool post_ct_snat:1;
+	bool post_ct_dnat:1;
 };
 #endif
 
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 9e71691c491b..a171dfa91910 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -197,7 +197,9 @@ struct tc_skb_cb {
 	struct qdisc_skb_cb qdisc_cb;
 
 	u16 mru;
-	bool post_ct;
+	bool post_ct: 1;
+	bool post_ct_snat:1;
+	bool post_ct_dnat:1;
 	u16 zone; /* Only valid if post_ct = true */
 };
 
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 6d262d9aa10e..02096f2ec678 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -859,7 +859,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	struct tc_skb_ext *tc_ext;
 #endif
-	bool post_ct = false;
+	bool post_ct = false, post_ct_snat = false, post_ct_dnat = false;
 	int res, err;
 	u16 zone = 0;
 
@@ -900,6 +900,8 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
 		post_ct = tc_ext ? tc_ext->post_ct : false;
+		post_ct_snat = post_ct ? tc_ext->post_ct_snat : false;
+		post_ct_dnat = post_ct ? tc_ext->post_ct_dnat : false;
 		zone = post_ct ? tc_ext->zone : 0;
 	} else {
 		key->recirc_id = 0;
@@ -911,8 +913,16 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 	err = key_extract(skb, key);
 	if (!err) {
 		ovs_ct_fill_key(skb, key, post_ct);   /* Must be after key_extract(). */
-		if (post_ct && !skb_get_nfct(skb))
-			key->ct_zone = zone;
+		if (post_ct) {
+			if (!skb_get_nfct(skb)) {
+				key->ct_zone = zone;
+			} else {
+				if (!post_ct_dnat)
+					key->ct_state &= ~OVS_CS_F_DST_NAT;
+				if (!post_ct_snat)
+					key->ct_state &= ~OVS_CS_F_SRC_NAT;
+			}
+		}
 	}
 	return err;
 }
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ab3591408419..2a17eb77c904 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -839,6 +839,12 @@ static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
+	if (err == NF_ACCEPT) {
+		if (maniptype == NF_NAT_MANIP_SRC)
+			tc_skb_cb(skb)->post_ct_snat = 1;
+		if (maniptype == NF_NAT_MANIP_DST)
+			tc_skb_cb(skb)->post_ct_dnat = 1;
+	}
 out:
 	return err;
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 35c74bdde848..cc9409aa755e 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1625,6 +1625,8 @@ int tcf_classify(struct sk_buff *skb,
 		ext->chain = last_executed_chain;
 		ext->mru = cb->mru;
 		ext->post_ct = cb->post_ct;
+		ext->post_ct_snat = cb->post_ct_snat;
+		ext->post_ct_dnat = cb->post_ct_dnat;
 		ext->zone = cb->zone;
 	}
 
-- 
2.30.1

