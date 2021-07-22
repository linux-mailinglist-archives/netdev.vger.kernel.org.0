Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB09F3D1F84
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhGVHSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:18:10 -0400
Received: from mail-sn1anam02on2093.outbound.protection.outlook.com ([40.107.96.93]:59110
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231232AbhGVHSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:18:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZB4Q6vNkALJ1ZtjDtF4nf1rcoRYfSeiqPLHCiX9Bp/7jpmgmbfOrk16Obe7G/tLi67kceVglEASgpOp8SKf61YwQNCSKjWWsoAe/fnh3tq3meQ777pMDUUrdBBsx4sAvmmMgQN/vwQjCWkR68TIAkjR7CvsvuSthlx/UfTbmv0SsZClAMpAanfMValNXgI3jiHmr0xrNiaKrlBdhpssEmMNygavkZP3vwOi49GNwHPa1MFKOGcWwmc/onsuwNZwwLM8RLPl6IAcmHo7jElyrEs1bUInU0XP+5eLmLo7PxpmrSkA8BV797zo1d5Th9OorNTD5/ZSng4U38hIzafE2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ih75NE3OMmaYlyEDREK7dbRe3vakN/2EeVUD3UPxUZ0=;
 b=Uw8JwVt1pSdj7vInGvQyxXGLf32IdtB+hwauyGT9VEyHfvgpmmLnspf9Y7uWVLTlnsRfJFEUKi9CQ1LThzp73WCOhu0NFXSJGCPAPZK3zaDa6eWpYMgJ1s1DKaEKfT4q2XtARSRNkRMRtuA+WDEnPIq4A4yC7DFbUQgLGrlO3Luua4GSIYJ64F8YszzJJ9t9poXPLtlBFCEbjoJh9wkLyvCCC3UNq9QyNA9cr9X7FMqWqtWpnkVv4QsDu9GxZkLSfmSMWr0CWto39ewrQt+Wn5gIPSAj7kZs3D3ohczp88xTMNG7KhjSUU2SLHH5EzB/ob/ZT3jSBAoJZj/wYbr+pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ih75NE3OMmaYlyEDREK7dbRe3vakN/2EeVUD3UPxUZ0=;
 b=dqq/XzBccS3rmtDG8K9vX0UOoHCI4PIUllE+H5MiqGNItleWdEtL+ghBW69kVHhMw8Qy0H9/gfMJRPkpDcyrTSemCIF8hkboI6FFLuFZ9VXn6/QNcgrT8iFE3HBK6pE+8eTUebqZKLl73ZGcXQjao9kuJo3Ujs6Y0+yh5yPLuP8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4778.namprd13.prod.outlook.com (2603:10b6:510:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Thu, 22 Jul
 2021 07:58:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 07:58:34 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 4/9] nfp: flower-ct: calculate required key_layers
Date:   Thu, 22 Jul 2021 09:58:03 +0200
Message-Id: <20210722075808.10095-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210722075808.10095-1-simon.horman@corigine.com>
References: <20210722075808.10095-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0136.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 07:58:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d8383a7-ec2d-42f6-2b95-08d94ce6816d
X-MS-TrafficTypeDiagnostic: PH0PR13MB4778:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB47782C74278393FB5275E767E8E49@PH0PR13MB4778.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xmK4ZTTuYOrhDptAaeS4Ms9RshkyKdDmB6FVTgzP+wywsaTm9bb5yRuVS/INGf3KgjqoSZHP5evwX2yPB3Quxg/F33LRk2KHchNW8NDu1z19tL27wMFYF9ND5U1i4EyzpYQ8dLWd4iSxz3z27C88QKqr0qCu+pZANsBdhMS6RSOas74/NEzzp8wRB7n6Mn3gY005LLd1zpegVBGq8zj0jLEsd0/7iONK0lo7M/zDNHAN3+NchLKcoWaKLSP8NnhlyeYs+ybVlFXueMb0hK3SsNUGPtO+QYxkQD9b42FqUqt1TeHtokriGluMz+/kb7xYP2J32Tmngp/IFQxTuglt85GZ2I5KsdSPYbgl2Fq5QioC6XgKBCOjCUXMal7tRiYqy//aYcwgF/c9raZuLWaGpQowNQBVi+Dm78gzfqM61Ljm9xv/+6Fli1l0HlNaTyrC55U1/xqDHLrHbeDf407FZTCuBz0RfTAXIfkp1prDVfbFmysNOnskrj3bc9pNe7T5ztfWPFs9+oQW4x3We6xTT5ZDH9BMob314U9TU7JXd7qhmskiGa2Ab+eZd6uhjenI+p94GmGebM8UC+f3NAe7nNxEjye73uVrOcZSjiN9wF7wVsiZEnWF7j5sFJ6aW64n+sw7cWbLyUcTzzkA2w2XOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(366004)(39830400003)(44832011)(2616005)(36756003)(66476007)(8936002)(66556008)(8676002)(5660300002)(54906003)(6486002)(107886003)(186003)(38100700002)(6666004)(478600001)(2906002)(66946007)(6512007)(52116002)(1076003)(6506007)(110136005)(83380400001)(86362001)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?99xB/TReXIOsJHM+uJM9AJolUyJQo8GCB4bfuBq99ZhAQCiuzobzgxw19q/l?=
 =?us-ascii?Q?N/4ZJyVO7XJkGs/Hlu6qgzfCRsgZLKvjEhVS7WS5jTyRlELYqRlWzX/av6Gt?=
 =?us-ascii?Q?hfLQP/vvrWLPiX9vAb1NWHSJGd5Ad6SJLKdohxoV1Ec5ovYldR51K4EPvHDl?=
 =?us-ascii?Q?wXiXvvauXz8quhpFNwPeAL3AG0tIWUu04Owp8J9OCgEJhmiXdW1qHcq7ktiT?=
 =?us-ascii?Q?bPghBId5YUZA+PcGF19CZNEkkdGcWT1/mze2IHp3HBndEKqrEAu2kbMjjDBk?=
 =?us-ascii?Q?/u0a/2ZSfsDM/Xu0on+cEWJgGpe7+9bnCZ3ixHf1ktosYaeGAQ4DWuJAf+zH?=
 =?us-ascii?Q?8L5TXooyvTTaObIROqoCmDrUIR14lWsfrB3vy90jnt59Hocs71FGFTz03Sq2?=
 =?us-ascii?Q?jPfMa6fLNovHY+UNws6vK7nKCmIy4G7vwBTjEZw27pT8QnVmbw4y7iKEf8St?=
 =?us-ascii?Q?TOzBrGBWheGA87shZubTK0NW1VnE2a/5fEL8KH2ebgQMVCmZLNtxAlIso0J7?=
 =?us-ascii?Q?iRj/4kRsWXmKzmxBBtGbjw1lDZLde5jgNwZ2lG6+FPOcwONsn2G3+86ICw6c?=
 =?us-ascii?Q?JjKt4+dPLb8ha0gp9f81f8z798HO6MpAXERVZZalxnmjOyiZdT/pEwhCqCzE?=
 =?us-ascii?Q?EQ4/5/runZHuZU3DnGQdo1i8fmnCKW3xtSd2/Fovu9gGG7mHumd2wYUJZB7T?=
 =?us-ascii?Q?hSjabq11GE+Fd3gI/a5b9fzX/IFlZJp+ALnQimlh58Oc4xwy+dxWHF3Llghv?=
 =?us-ascii?Q?zIMCEpndIfMX6ccrUId/XPbDUmK6+7RVQz4dGPh4Yabw1CrbKcc8fqQUdB9n?=
 =?us-ascii?Q?0Lp+K/7P7a9RTpWZNwIcLncS48C5PSwTJqf+L4a7T4pZkDfUHYlLt8nbtg1K?=
 =?us-ascii?Q?3aKzUR1/2ONeJN5gUwnCTQ24P2xL2M277DHD3dQoVrB7uHX990lpSDC0E8V6?=
 =?us-ascii?Q?lgfvDeaZ0It7j6Ae0kW0pqoOEzCnv7dRL9AV2S+Zw9LY9gJbyFiIZ9DX18pQ?=
 =?us-ascii?Q?S3j7oERaN1Phc0PmZguong3ULxjLmE2TgcJ6Dj7w6+mOU/yoD059ayAQS65r?=
 =?us-ascii?Q?Zj3IN3o8PDu2wd3puQChzJE5KDzm5zUoF/fM/SxhwYawfFLGQzuvf06SwXTM?=
 =?us-ascii?Q?Y8wSp2tlnMJjrzXTqYv+cTUF+DKBzmd6gc69V18y/oWF9xNtP6F9kGMsqg+4?=
 =?us-ascii?Q?KG9D9cODOIaOpeVr56EWO7Mt9SgmbJhlcfeMFSfynDclHkbIPrJ/T4EkZlNI?=
 =?us-ascii?Q?yw2BWP/fF/boU+5VNVWoA+DaSRc+gYDzrDIst8MI5hyNU6VSQubnuQneUlt9?=
 =?us-ascii?Q?tmeHbRGXXqT91ek2s7F3Sfb2inUgmiIvfgbASVbDviJV2wyY3k/c0Fnwaquy?=
 =?us-ascii?Q?srtjxbqcUgxIh1hw2zod5Y0hBJDP?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d8383a7-ec2d-42f6-2b95-08d94ce6816d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 07:58:34.8305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZsSMONeMMsRNYEy7MCsx6TFrLJZ67DLe8Fx07roGZrS6JAs4wY23TfSi954kDLrpFTE3hHmasvbTq8S9t13AKGpCXrqr6oZ2oLnjAyHR3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

This calculates the correct combined keylayers and key_layer_size
for the to-be-offloaded flow.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 94 +++++++++++++++++++
 .../ethernet/netronome/nfp/flower/conntrack.h | 18 ++++
 .../net/ethernet/netronome/nfp/flower/main.h  |  9 ++
 .../ethernet/netronome/nfp/flower/offload.c   |  6 +-
 4 files changed, 125 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 128020b1573e..e3fbd6b74746 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -407,8 +407,102 @@ static int nfp_ct_check_meta(struct nfp_fl_ct_flow_entry *post_ct_entry,
 	return -EINVAL;
 }
 
+static int
+nfp_fl_calc_key_layers_sz(struct nfp_fl_key_ls in_key_ls, uint16_t *map)
+{
+	int key_size;
+
+	/* This field must always be present */
+	key_size = sizeof(struct nfp_flower_meta_tci);
+	map[FLOW_PAY_META_TCI] = 0;
+
+	if (in_key_ls.key_layer & NFP_FLOWER_LAYER_EXT_META) {
+		map[FLOW_PAY_EXT_META] = key_size;
+		key_size += sizeof(struct nfp_flower_ext_meta);
+	}
+	if (in_key_ls.key_layer & NFP_FLOWER_LAYER_PORT) {
+		map[FLOW_PAY_INPORT] = key_size;
+		key_size += sizeof(struct nfp_flower_in_port);
+	}
+	if (in_key_ls.key_layer & NFP_FLOWER_LAYER_MAC) {
+		map[FLOW_PAY_MAC_MPLS] = key_size;
+		key_size += sizeof(struct nfp_flower_mac_mpls);
+	}
+	if (in_key_ls.key_layer & NFP_FLOWER_LAYER_TP) {
+		map[FLOW_PAY_L4] = key_size;
+		key_size += sizeof(struct nfp_flower_tp_ports);
+	}
+	if (in_key_ls.key_layer & NFP_FLOWER_LAYER_IPV4) {
+		map[FLOW_PAY_IPV4] = key_size;
+		key_size += sizeof(struct nfp_flower_ipv4);
+	}
+	if (in_key_ls.key_layer & NFP_FLOWER_LAYER_IPV6) {
+		map[FLOW_PAY_IPV6] = key_size;
+		key_size += sizeof(struct nfp_flower_ipv6);
+	}
+
+	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_GRE) {
+		map[FLOW_PAY_GRE] = key_size;
+		if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6)
+			key_size += sizeof(struct nfp_flower_ipv6_gre_tun);
+		else
+			key_size += sizeof(struct nfp_flower_ipv4_gre_tun);
+	}
+
+	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_QINQ) {
+		map[FLOW_PAY_QINQ] = key_size;
+		key_size += sizeof(struct nfp_flower_vlan);
+	}
+
+	if ((in_key_ls.key_layer & NFP_FLOWER_LAYER_VXLAN) ||
+	    (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_GENEVE)) {
+		map[FLOW_PAY_UDP_TUN] = key_size;
+		if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6)
+			key_size += sizeof(struct nfp_flower_ipv6_udp_tun);
+		else
+			key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
+	}
+
+	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_GENEVE_OP) {
+		map[FLOW_PAY_GENEVE_OPT] = key_size;
+		key_size += sizeof(struct nfp_flower_geneve_options);
+	}
+
+	return key_size;
+}
+
 static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 {
+	enum nfp_flower_tun_type tun_type = NFP_FL_TUNNEL_NONE;
+	struct nfp_fl_ct_zone_entry *zt = m_entry->zt;
+	struct nfp_fl_key_ls key_layer, tmp_layer;
+	struct nfp_flower_priv *priv = zt->priv;
+	u16 key_map[_FLOW_PAY_LAYERS_MAX];
+
+	struct flow_rule *rules[_CT_TYPE_MAX];
+	int i, err;
+
+	rules[CT_TYPE_PRE_CT] = m_entry->tc_m_parent->pre_ct_parent->rule;
+	rules[CT_TYPE_NFT] = m_entry->nft_parent->rule;
+	rules[CT_TYPE_POST_CT] = m_entry->tc_m_parent->post_ct_parent->rule;
+
+	memset(&key_layer, 0, sizeof(struct nfp_fl_key_ls));
+	memset(&key_map, 0, sizeof(key_map));
+
+	/* Calculate the resultant key layer and size for offload */
+	for (i = 0; i < _CT_TYPE_MAX; i++) {
+		err = nfp_flower_calculate_key_layers(priv->app,
+						      m_entry->netdev,
+						      &tmp_layer, rules[i],
+						      &tun_type, NULL);
+		if (err)
+			return err;
+
+		key_layer.key_layer |= tmp_layer.key_layer;
+		key_layer.key_layer_two |= tmp_layer.key_layer_two;
+	}
+	key_layer.key_size = nfp_fl_calc_key_layers_sz(key_layer, key_map);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index 170b6cdb8cd0..bd07a20d054b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -83,6 +83,24 @@ enum ct_entry_type {
 	CT_TYPE_PRE_CT,
 	CT_TYPE_NFT,
 	CT_TYPE_POST_CT,
+	_CT_TYPE_MAX,
+};
+
+enum nfp_nfp_layer_name {
+	FLOW_PAY_META_TCI =    0,
+	FLOW_PAY_INPORT,
+	FLOW_PAY_EXT_META,
+	FLOW_PAY_MAC_MPLS,
+	FLOW_PAY_L4,
+	FLOW_PAY_IPV4,
+	FLOW_PAY_IPV6,
+	FLOW_PAY_CT,
+	FLOW_PAY_GRE,
+	FLOW_PAY_QINQ,
+	FLOW_PAY_UDP_TUN,
+	FLOW_PAY_GENEVE_OPT,
+
+	_FLOW_PAY_LAYERS_MAX
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index b5bb13de73df..226bcbf6e5b5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -551,4 +551,13 @@ int nfp_flower_xmit_pre_tun_flow(struct nfp_app *app,
 				 struct nfp_fl_payload *flow);
 int nfp_flower_xmit_pre_tun_del_flow(struct nfp_app *app,
 				     struct nfp_fl_payload *flow);
+
+struct nfp_fl_payload *
+nfp_flower_allocate_new(struct nfp_fl_key_ls *key_layer);
+int nfp_flower_calculate_key_layers(struct nfp_app *app,
+				    struct net_device *netdev,
+				    struct nfp_fl_key_ls *ret_key_ls,
+				    struct flow_rule *flow,
+				    enum nfp_flower_tun_type *tun_type,
+				    struct netlink_ext_ack *extack);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index ad97770fa39c..87a32e9fe4e5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -41,6 +41,8 @@
 	 BIT(FLOW_DISSECTOR_KEY_ENC_OPTS) | \
 	 BIT(FLOW_DISSECTOR_KEY_ENC_IP) | \
 	 BIT(FLOW_DISSECTOR_KEY_MPLS) | \
+	 BIT(FLOW_DISSECTOR_KEY_CT) | \
+	 BIT(FLOW_DISSECTOR_KEY_META) | \
 	 BIT(FLOW_DISSECTOR_KEY_IP))
 
 #define NFP_FLOWER_WHITELIST_TUN_DISSECTOR \
@@ -232,7 +234,7 @@ nfp_flower_calc_udp_tun_layer(struct flow_dissector_key_ports *enc_ports,
 	return 0;
 }
 
-static int
+int
 nfp_flower_calculate_key_layers(struct nfp_app *app,
 				struct net_device *netdev,
 				struct nfp_fl_key_ls *ret_key_ls,
@@ -538,7 +540,7 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 	return 0;
 }
 
-static struct nfp_fl_payload *
+struct nfp_fl_payload *
 nfp_flower_allocate_new(struct nfp_fl_key_ls *key_layer)
 {
 	struct nfp_fl_payload *flow_pay;
-- 
2.20.1

