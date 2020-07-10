Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D1721BF78
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGJV5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:57:22 -0400
Received: from mail-am6eur05on2064.outbound.protection.outlook.com ([40.107.22.64]:49249
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726628AbgGJV5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:57:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5SCFp8rHTJyDdz1d9l3WJdCgSR9YFHChadaYEF/CM3/0GQav4nKtpunQgrhwKWO+Ptt+FTQWoQTLE/zTrYFnbLZaKdLoTDtMmh6grpMbWuGnpZugKj7Oo9Rfrf0egfNDoh1qw+LfwzWMY8jgGtCowF26/i4fRh5o3qqv4DqxSO5EPrJzmfLREiIOdN2L4+biINLz4j65js6qprtrT1F1pa92Ub7aOE3k6GxN5CeHsIC8SX2Zlfyhli6dVC94vWZJYFevzKK8py8YqGc6aR+TYBgTk0XdtofWuw2u/4+WNTYK9sFGgrfMZwEkMUXDlwyQcFo5lUQtLB74RiXTbHTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L921lJgf+xt96VHkj8u4ozGilE6eTB0fOUvilU/pgNs=;
 b=Y7dckIh3P8t/m+wqeZ4n6igst7bhqRl14GhwrQZYSFIXpJ+ekhMEHyV7myleZv0CIPiUluMFbhqg0jLuT+NKve4rhanYl2J3iROv4njq77x2cmn9lMAs+t8URHgmblPmFZ5d67lBaHnN6mFHZeDeyuPnxlgV02cq9GQT/Lf8u3hyOCn/p5OhDAqCLpcjmfSgLYR5XXT3G/QJOzEtjflJ9CZ9mZ3AoCXZ90duJGhRvKuDq8rPSmYD4WsZsbmz6VpG6Pi7BX1fjqBQmEF4jhujs3fMBblJhd9utkaXyONCdfWnf4gZP8gZWvbbgBhmvUf9xx7dwRZ0aYRIFZIPu6aHCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L921lJgf+xt96VHkj8u4ozGilE6eTB0fOUvilU/pgNs=;
 b=sJGoO8B5yGQ8a2lENj16sIMIQ0vN8+G8QUCWRuXRb5sMA9Mgs6RoJoBOZTID1Ti9ydXVMKCvyV6GGydpkL3BXL5nOl9vmbkH/wxNYYCZUvwXkqwCSE/v6ux5iLWQYYAB1sNl9VyHLTaKO/H+pZJE5sSl9LQvRhT5CjpiMu2Vyn0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:57:07 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:57:06 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 11/13] mlxsw: spectrum_flow: Promote binder-type dispatch to spectrum.c
Date:   Sat, 11 Jul 2020 00:55:13 +0300
Message-Id: <59d5683793eeff88ef3bf1f2c7697e54e498d5bf.1594416408.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:57:03 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 76d99dcb-9168-48a8-b728-08d8251c2f69
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3354B0EBE9FE6306AA3CDBDFDB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RKH5ggm2sa7Ec6AG2JXWr5Ntw0LpyrD30nbOuoLLs2eZQ5BwKTYMxc+4p4QKaJ/5qGau7eZglB+RGvbyCv7yEv87ONbKZfcGyBNJs73ALS6ycsbrribL+Wyu0xb3CXCz9I1QkfdLI6yA63eW3yjxxptaXaNdy4u1jCog0njKEjCUbnMGpCYRM/Rf40tCrANX49KmFX9iNck2hUqFEUC/ukhDXsXbpC5abU/9X9OzhDu+55oI938WBc+/G9lXCKQj+9+P97iy2wyCBYu5tEb1jS51ql4fcV2ujV4IcD2sRviwS0wNEj50LBC/agu34nQzAtmrLzd7xAhZQlXTW/AqwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I65Yz4KyNzvcFvUnhGpBTcZXfobIOdTJjRZ66eQbMFdYbwu2KN8rwMEsbDTW//0G971/XN7P0mIOEfKgE3r2rq/bSAkDFBT9eALXA3Su/Vwe/x8OpmCuexQ5Ub9QSbPmv+QNZEN5WJSXB4o3wyxL9MQ9xkdqtgMsOrYdUZq6IjIVSH21nEOJY2h0yMjJmiQWhg1vxUeAVNmTrZrLahQMoKTDijEmBT9DPBv12x65eXj2jYOXljuib/e84lvmPQDw8ewH0SomzTh6UqjLnCFU4nv24Tk9gTsPtF5LvGY3w2bPqyF2Z+TeDCfGQMFNwamXP0cUl1XSm/HiShxbTxq+ns4Pkf6ZOWAgcC3StJsHaj9l1zcNa5Lx3Rqjo8TKFkYu5tWsWkGhOE/NCyjwDzOnIkj+ixF2rpQVciyuUi2Th8nk2B35ymfv4dW63Fo8od6HRXqwiDcbSUt3dZxJXdQyubScvD6ceIRHGThd5UK4J/M=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76d99dcb-9168-48a8-b728-08d8251c2f69
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:57:06.0782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKX3x7XKm6THeqsvatNTXYYTbgWJ8WzBfirRSenTTa/upGstn39cJ0NCGtb2jpUOFUqwR481f9JY/A83HLkPgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two RED qevents have been introduced recently. From the point of view of a
driver, qevents are simply blocks with unusual binder types. However they
need to be handled by different logic than ACL-like flows.

Thus rename mlxsw_sp_setup_tc_block() to mlxsw_sp_setup_tc_block_clsact()
and move the binder-type dispatch from there to spectrum.c into a new
function of the original name. The new dispatcher is easier to extend with
new binder types.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 13 +++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |  5 +++--
 .../net/ethernet/mellanox/mlxsw/spectrum_flow.c    | 14 +++-----------
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 636dd09cbbbc..2235c4bf330d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1329,6 +1329,19 @@ static int mlxsw_sp_port_kill_vid(struct net_device *dev,
 	return 0;
 }
 
+static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
+				   struct flow_block_offload *f)
+{
+	switch (f->binder_type) {
+	case FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS:
+		return mlxsw_sp_setup_tc_block_clsact(mlxsw_sp_port, f, true);
+	case FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS:
+		return mlxsw_sp_setup_tc_block_clsact(mlxsw_sp_port, f, false);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int mlxsw_sp_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			     void *type_data)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 51047b1aa23a..ee9a19f28b97 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -767,8 +767,9 @@ mlxsw_sp_flow_block_is_mixed_bound(const struct mlxsw_sp_flow_block *block)
 struct mlxsw_sp_flow_block *mlxsw_sp_flow_block_create(struct mlxsw_sp *mlxsw_sp,
 						       struct net *net);
 void mlxsw_sp_flow_block_destroy(struct mlxsw_sp_flow_block *block);
-int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct flow_block_offload *f);
+int mlxsw_sp_setup_tc_block_clsact(struct mlxsw_sp_port *mlxsw_sp_port,
+				   struct flow_block_offload *f,
+				   bool ingress);
 
 /* spectrum_acl.c */
 struct mlxsw_sp_acl_ruleset;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
index 421581a85cd6..0456cda33808 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
@@ -277,18 +277,10 @@ static void mlxsw_sp_setup_tc_block_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
-int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct flow_block_offload *f)
+int mlxsw_sp_setup_tc_block_clsact(struct mlxsw_sp_port *mlxsw_sp_port,
+				   struct flow_block_offload *f,
+				   bool ingress)
 {
-	bool ingress;
-
-	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		ingress = true;
-	else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
-		ingress = false;
-	else
-		return -EOPNOTSUPP;
-
 	f->driver_block_list = &mlxsw_sp_block_cb_list;
 
 	switch (f->command) {
-- 
2.20.1

