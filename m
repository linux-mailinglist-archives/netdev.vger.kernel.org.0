Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0C546F23C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242747AbhLIRnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:43:24 -0500
Received: from mail-eopbgr140077.outbound.protection.outlook.com ([40.107.14.77]:38495
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242485AbhLIRnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:43:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Irh1z6iV0n6JIz890zIxUspPofws3fdz13/8EKmSWwHWd48XRVAQypPLTdXoFTcCJmv4mBhn7g6JK7pypySx+Z6oqj3wXghwL0CEyaa1pkPZWNlnyNUhPqHGR7oFEEO0f3er/m4ZMPxt4SweY712nNH/AhWP8eNlcCSf1cFwlO2VSdRQ3y95Ii0dxJn1lDQDC50+dDtt4CnfyM01GpNM4VnfRNsoTUj3+yYbSlkPJMiqIO4xYEsJFk17mTBLBV+fuQQKDchbPkZ3XwBrwPfIF564cxXhsHDHrxnj1kcqr24J7hl8nF0l9AGIT/bT5A/QeFVe4yE7JGIwPitB3gpHVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2urq7N5KlBCnScAeNr2XOPwZAUTtqRk25PbmoiDShA=;
 b=GMiaHHUXSQrfp+eU2UlRNmIG68lf4uoYnodZpMP3gwq4nylc9zoXeiy5UsxWkiER8hWsHbH19yAPuLWQ+VP0BTPLQ1Jen4hMryYNRAxjJYvNs+8+Q2an1F3XdhdUgYtzxcvoM1xAgzTJNnKb78EXIGqvJxqwPPYx/Gor20WxlyclGPrzPIZ5P0mDSYDqw6/YbLyQVDXO1nWMz0DodC9sqi7QFaQXHjhiqa4zmBzsp28IKVhRgpVKzhk7nMZL2camqH+hbR8eFWvU/VTj/xUtDgCdHmLcw+pZwRLI6YiXfqg+bOmL18widLCAYx6/rjEgXYGNOmcYCI2/BZ5Di1MWAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2urq7N5KlBCnScAeNr2XOPwZAUTtqRk25PbmoiDShA=;
 b=ATBH/4nt8t7sA7v8e4Y+4FUyZogKaKqgj9SCAEkbJipTJknoHXNfqRTRmuSouGZzUqbZZFY1ZzePlvuNrM41IV592kY2sU3zjdzrmB8grRjn+EJAas/sR3Uc8KAJNDQNLG8EOfR7LSGbhlDiGc1MNNqdzFGwmBgROx2Gq/Vjdng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 17:39:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 17:39:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v2 net-next 4/4] net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
Date:   Thu,  9 Dec 2021 19:39:27 +0200
Message-Id: <20211209173927.4179375-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0059.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by VI1P195CA0059.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 17:39:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7931528-0a44-4f24-b1e3-08d9bb3ae3f6
X-MS-TrafficTypeDiagnostic: VE1PR04MB7216:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB72161DFADBDC1B1F35F9E3BDE0709@VE1PR04MB7216.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jamSenpkffN5k5BlxYPKrgCYRbEScozMDL+bn9ar6soyXDgjFx2aYA5INWRBf/Z7Z/CUKlvL3DkSGmaOVYDaHXcUO1iuqry5sYvMzo2TOhfKTB9e9sPcj3agFEQeAes2PgeBmU64zfO/M0VnMlolWlXddREzpZlJDBYSa1I+i9F/9iES3QIozfXDO3kVtbgWgeXM6PheOA8vZ3Hy7e3aFV0rGUR2XSURxGHY829e4yIKSIhk0JRFjypbmlvyxmj6HfQH+Yc0rPEApFAaN0ZypIvdp+I5nz4S6uuOuMQycodOMnPITeDehudnehysqVbGA9xv17KbccCcfEcJy+NVyJNRTPvLe7Dd8T1bojwL78WlGF8xEUFKcXUWxVbBN10HqQzRS2H/O3eL1HdJo+oPtHGQRs3dbIvpdVtZEpaWaYjTrMVIiq6HcjAJOrj1LBTKpPVnCeh2DvMn/MwCzxvMnxDvMFSlv0+V0Q6x7RFS133Zsknc53Bbyc4hqrVX+BplYjeM6+yBcbUrbYeIXx2BNbetObYSXROBCmeku5sy5LKoAKRIyyF9bWux8QwZDRlAfrCnaqx5uXiLcFPlHPOVP5H+Y1LY83hg1918PsKQrbVClADqhXfTgYzFqrESpK2JKpTRTqqHh3UcBslMAGpEMnirhzrawI1yzuG5J7WblclsPGbZBUsXwrvEelQA862HVe61aFV2vw8H0Ec72ohVEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6666004)(5660300002)(1076003)(44832011)(508600001)(6916009)(8936002)(956004)(8676002)(66946007)(4326008)(66476007)(66556008)(86362001)(2616005)(6486002)(26005)(186003)(83380400001)(6512007)(54906003)(38100700002)(38350700002)(2906002)(36756003)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D8Hs/QcVJDtAQC3s48XbKw3YXOD5Oof/Mr19DPXSP3szmbX8Z0dJ4Iib4Rs2?=
 =?us-ascii?Q?4OAlrTO0rUKVMvS/JLLctxmwDa+XKf4Ci0xdBfVqnp00D5k9sXvTuHArCS33?=
 =?us-ascii?Q?5eHyI+ECd1wT7PdCkWcljlEQiEioc8jERkK3agOy+dsv242b+EUoFNS10xDr?=
 =?us-ascii?Q?HgxAyVzL3MWgqozSmPmSo1gzdp+4R6QGzbXRiiKvf9mUIWAdeBBxRPAg3oDj?=
 =?us-ascii?Q?5D7u6lMjEojK8MZzeGH+n2po1RwQlCaEMOlPWHbjn2KYggKMkP37V6qK5Kxv?=
 =?us-ascii?Q?XHTHk0u6F5w1mhhrmkF+ehfnZB0CJVCNNyGtYxIOwgSJ0+7CSZcPKToCDpU4?=
 =?us-ascii?Q?hP/FoR3tVJwBlfO5OlKhs6GDV1Enl5ZWpwlXW4qthJlPwHETaevsuut2Ynxl?=
 =?us-ascii?Q?gMYTt0i9ArRJc83spg1P+EHw+eRlLQrAHSrQJ3YQjlEO5Km6c6JVPR+6UXTB?=
 =?us-ascii?Q?mJEqcxKj+ghFqr4XqNLjfanaLbs8ZwG/gvOwbojy8rpM2ulcyPIZWULKK5bW?=
 =?us-ascii?Q?RAkGWBYD1LQMEFw7yC79E7mgDBzm+mPzcDecgDjI0Tl0G2/0UwcfV8eTMvl7?=
 =?us-ascii?Q?2Ye3T644QoeDp5toFiLXkCSdKHrUqqEv6CejWaqV3dB/lGRGIEcnxWvFn1aB?=
 =?us-ascii?Q?onHJ1OTxS8gtPJ6u3G0k025s38AIR7itCTwOwxUvEK0K39W2UGOmcadUCy4T?=
 =?us-ascii?Q?kEEbO1UgMovoDXjrO6GeFfhsuepnzwvfnDXrqY9oE4myVy3zxM3XyxBkUJs4?=
 =?us-ascii?Q?izLqTJcKcKnIBV5+3gdeIfE6cjXani3T2pWlytTgThdOdXFp68ZLuDdHcFp1?=
 =?us-ascii?Q?DkzHXmXFpkdmm+Ai3b6luDSnEtliHyWPoArjWyp+3xJVGQMraGhC5ISAIiXB?=
 =?us-ascii?Q?VKWvlI9ORDgWx6DfMrCSUzE/zYqCCWI/3vfy6pUPFbZ84ON7S+9X1Wrl7QH8?=
 =?us-ascii?Q?8xaf7DvQOCAdsma+306XiCHtkB1gth+4C2xY2xF0K8Fy0sQjT0xON4AFGmyv?=
 =?us-ascii?Q?I0pi+GixK5eQ8bepx6cGCNIZoljwItc7BJ0r7dlP20wF74v+y8tnL251DXDS?=
 =?us-ascii?Q?rRvVMRj1zwQEZmn+6Vhgf4N1JFeCC9N3Nv/E9Cq4NSoRR9JNz4vKCs7ISKQi?=
 =?us-ascii?Q?QdLK9tobreGK5jR+aSkO8ssftcOqOuHp9btDws1qB+YuzS2gJzLPbxNb/SyA?=
 =?us-ascii?Q?BgwgTCfO431FOro8MOohxtc+VRjNZRLpq42aNnCh5nHawb46nmjuLx5InRhj?=
 =?us-ascii?Q?tekUG7mxo/N2CWaPtGfoO1tfPr9GVc/t4elI3gWfrRVPbLIo+q1Q0/58NYRy?=
 =?us-ascii?Q?z35vuld92KRfFlw7phOqMFkIM3Cn3updTaASwRehnF8LMmBtoz0BMC69pTmM?=
 =?us-ascii?Q?Tr/xt18aKO63nIwFI8ACCN60zXbDovCnxfjUcf7UaqY7/RjjwX+02SdWwSbP?=
 =?us-ascii?Q?8vtbW3VDjzLOzAfxinq+Z5UAm2lvxFx5Tlc4WO8JNK8A1/ldaWwMO9vF25N8?=
 =?us-ascii?Q?+xZZ+QK97wg/G8egCum9ytPly8e0TVPA1AKS6PTOy5BKELk+dHinOuTrnJ/v?=
 =?us-ascii?Q?qA7t7SgeqOP/nscU+HaAp3Mz4xi7HzPExaCBSzTouXftGPVhigIG19y7wfTs?=
 =?us-ascii?Q?o+7gUxEqb+zzHA9CNDqvYCY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7931528-0a44-4f24-b1e3-08d9bb3ae3f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 17:39:45.7978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHv749v/oZuVjItiCkKmLHkahOgwHZVsApmtq69wvWwQIME8tFwlMFRRlrF15W+jymeg8StvlxWID4Wk4M/dVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for switch driver to be able to make simple and reliable use of
the master tracking operations, they must also be notified of the
initial state of the DSA master, not just of the changes. This is
because they might enable certain features only during the time when
they know that the DSA master is up and running.

Therefore, this change explicitly checks the state of the DSA master
under the same rtnl_mutex as we were holding during the
dsa_master_setup() and dsa_master_teardown() call. The idea being that
if the DSA master became operational in between the moment in which it
became a DSA master (dsa_master_setup set dev->dsa_ptr) and the moment
when we checked for master->flags & IFF_UP, there is a chance that we
would emit a ->master_up() event twice. We need to avoid that by
serializing the concurrent netdevice event with us. If the netdevice
event started before, we force it to finish before we begin, because we
take rtnl_lock before making netdev_uses_dsa() return true. So we also
handle that early event and do nothing on it. Similarly, if the
dev_open() attempt is concurrent with us, it will attempt to take the
rtnl_mutex, but we're holding it. We'll see that the master flag IFF_UP
isn't set, then when we release the rtnl_mutex we'll process the
NETDEV_UP notifier.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 6d4422c9e334..c86c9688e8cc 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1019,9 +1019,17 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
-			err = dsa_master_setup(dp->master, dp);
+			struct net_device *master = dp->master;
+
+			err = dsa_master_setup(master, dp);
 			if (err)
 				return err;
+
+			/* Replay master state event */
+			dsa_tree_master_admin_state_change(dst, master,
+							   master->flags & IFF_UP);
+			dsa_tree_master_oper_state_change(dst, master,
+							  netif_oper_up(master));
 		}
 	}
 
@@ -1036,9 +1044,19 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_is_cpu(dp))
-			dsa_master_teardown(dp->master);
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dsa_port_is_cpu(dp)) {
+			struct net_device *master = dp->master;
+
+			/* Synthesizing an "admin down" state is sufficient for
+			 * the switches to get a notification if the master is
+			 * currently up and running.
+			 */
+			dsa_tree_master_admin_state_change(dst, master, false);
+
+			dsa_master_teardown(master);
+		}
+	}
 
 	rtnl_unlock();
 }
-- 
2.25.1

