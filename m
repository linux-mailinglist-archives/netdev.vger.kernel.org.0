Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F6046F23F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243126AbhLIRn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:43:26 -0500
Received: from mail-eopbgr140077.outbound.protection.outlook.com ([40.107.14.77]:38495
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234299AbhLIRnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:43:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPyTKtEfVqF36jEMO1kQBEu+H5X1FE3lwJa/G3MPFWujZLp583e8grP303pyHpHqZCvBMO/YJ4EPg35pgHiw9l2RzAQyUUjer554zYzOYkRJgEmViBRz4WQEXwnEdxEFiyJCQ/AMio2vCG6sBgq1c6bxUPrlBlZt2ocPaJ6MUMWjdhKXqgLMk/ZnO8ox9LkBWjkT0l9jNigHo57EgE5zPiEOkGEMIInPcAU42Bz4Ynq2pljOH4wW/jLe2un51GtPFPCNId4uivcYemNvJMl2l2GuclfbD73dB80SpgvTIpBOL0H67RDIiQ0DoR6Sy/aJZ81NOczzxmCOiyAe3C4+ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATWTn5wP6qF6pbtLsK56+/G5laPJmXVELt7Ey13mD9k=;
 b=TxANySGxjJH33+c0MMDjYuKvbsDACb7NBEH0mUshgGbXSzae41wUqgCcoJFh1jTVBHy8uZ8wDyHe97qgyxQ08Zu7BmHQCMGjQXpTvsihMutbskQ2jLCRoi+8paM1ghf2J8rGzO9czuyA62OePMS6uU3qNqK9AIUKwOgHnwuRgGkBVtYdhg7/qSENKKDDyU1fd3J6Qx6AXtzCwm5djcs3SANPRsRY5c5Tmv8KRopVkrRveeVNyUoOI7WjARPPOHTDQCgMFSczS6jVQOP6ge8OyUydOMnE9GgBQSsVw9eUh4ib65VqSuiysFgNLEk3J99IkgDRyz9mVeH+b6cvMORZ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATWTn5wP6qF6pbtLsK56+/G5laPJmXVELt7Ey13mD9k=;
 b=H5VObzCNppV4QIy4PupRXZiytDI4kGTH87sdsjt6MWT2dGHVRqdcXaESgx0LOJTD3zohgglAiVfzxDt8FsfMFaEMfSwdFmeWAsVYI8qZHYPHxuOIjAjto01eA8YPmwyoAWteoz9Mki7V9w9An7W9sOgJD0KUvRg/GiRdrHOm1QI=
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
 17:39:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v2 net-next 2/4] net: dsa: stop updating master MTU from master.c
Date:   Thu,  9 Dec 2021 19:39:25 +0200
Message-Id: <20211209173927.4179375-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0059.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by VI1P195CA0059.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 17:39:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19b81136-ca4c-482b-8081-08d9bb3ae360
X-MS-TrafficTypeDiagnostic: VE1PR04MB7216:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB7216CF2EFECDDA364D88DF8AE0709@VE1PR04MB7216.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vOMuo/mkzJOF6TrsfZok7Y3FcFJG2yPljfMMSt3TvINrJtl4SAGcaFJBy0SghBBeUH0foQTWUekb02w2uXRfBHBhCsBvdHFM1IIjxEyRH31/l5P6WgVg2PKRS3Ug+OGH4wSe67m5fmONuckmptcDO0F4rmi2MecDyTuE5Z/FBpRhS3fz5fM0fjtHmiyUXY7i/cofYiyvMDa9iZqQ3P+na4+dpjlM8pigWOTs/ccxqpHqdYqvVHqfM2LMJAX1js5MoMTWm3P50Ppx21JPP+XpA8zx45U4T6mYoMZm8vlFlG+KnjQpiH1K7aIa3QJoSIau9cpAuO9vUnIb0YL0bxyWjw0VBf2M8/MenU2wQcIcVgyzeu6vljIAto0IcoOBgfJGpYSqx2U2vawo2byQA9qcvllQALX6kcNNKdWRpfMOXTgRSqdOnHSYE4mzGxa7wuiTuA1A/WXaIe07leo9J0rl1wHR68NH6n5t3Y/FVBLpvDdD8p3Q/uB0Zg7FYzcDu3UPaUl5oQbUXSaXPO765/6f9rnzYLnkiJtMvKMk0myEr7f7bFm30PjWm3rjzEhYNwNgHznTzKrgRq45fM/tT8MjAe5hWQGJVhLOjdP6o71fqvA1m557jkVcoObTn1EZwa8YbrJsq/kHDj514ZlfzQkhSP0L4pLGKUbjU4nvTd/69feL1AcGxRZyS/kbXblKtmMqKX4xwvj7QPArOc56T59YHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6666004)(5660300002)(1076003)(44832011)(508600001)(6916009)(8936002)(956004)(8676002)(66946007)(4326008)(66476007)(66556008)(86362001)(2616005)(6486002)(26005)(186003)(83380400001)(6512007)(54906003)(38100700002)(38350700002)(2906002)(36756003)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VIeoeE/Gq+GPCrzx/vepC7+A7sT7mJQKRHtzbbU2taLH8qmwuC6NCmf18RwY?=
 =?us-ascii?Q?eYvcKAF9T15GqHCJ2sh6CMZGeUdo930WSSBHd/UQh2BOKLgBxFAOw3rsd1J4?=
 =?us-ascii?Q?IauLA3/8uOjyaCAHqqwYzh4PorkxCNwOLx1/gzSMHUVkKkFeHXB9Nw10YccD?=
 =?us-ascii?Q?bawowJxOLrB+XIiEXuu4ku8X/+DlGI/YY9VFo0BbMmQlhmXZNUDo244dTt2w?=
 =?us-ascii?Q?4yWzPcm533PmKcz/InX29dgQRkl6V2OrzpJT+7YNg6SA2V7dEK11ucj1dn/M?=
 =?us-ascii?Q?PR2bnIDIRGe+MRsgQuqttPmdls1MhwcuXG1BFNq8AFJVX4HC80fggy5QkTcx?=
 =?us-ascii?Q?GxjsZCyqc3M3UDv6PbjfmeA10PLewD0vH3bBIZV7Mj6gME7wYr3t4NgtTled?=
 =?us-ascii?Q?y4dWsRwRdYJ7EZfSCEKbGx6WNlvqFuqQDBwKFpzCq1/ZR5VW9igS7+GzcZWE?=
 =?us-ascii?Q?LZeJ81Ye/myFwjivY6A5IpeT3z+otCJobC4jSSP5ECbbyOjaBZBZY6T9J1SO?=
 =?us-ascii?Q?G3SwF8HaoymOPWpuouZFuf/9W3jGh7zv+X6KTiBo3HDleBfuxaxihG1JxTC9?=
 =?us-ascii?Q?9k4QbOIEc+ZXvOiKgZeUcC0OtnA7G+UYEKthf+sF+3LopIsiKaFkmOoCeHr/?=
 =?us-ascii?Q?JAANo9wF54FFJxfr+fpAwRUaTVHTrurHlT/jccseUktamRvLqYoK6sgvA/uv?=
 =?us-ascii?Q?l0Pv5Xqg3s5TS/kpgRPQ30ObsMetbv+o3GAJ1ioxR2kk1oZtzCuz+gFM/Yve?=
 =?us-ascii?Q?a9NXbsch23SoVo0jK0+VbZ5rMLxJqcSINeLy+AXUX96/2Tmy00JalpRngpa+?=
 =?us-ascii?Q?c22qzFBDIMcjFizhJjY5vpIau1OBZ2Ll/UmhSdzfUiFxeMxgvTtgH3cpOw8A?=
 =?us-ascii?Q?dmBzxsPDcxuHw0Q/ZAUSgq6XGoM7Sddk46xmIwE4e9cdvAMkyB8gNFpSyps0?=
 =?us-ascii?Q?bMfMKA9z3tkIa2HiSKxc8Qrmq/9lBXNXLf+QpX6gkBVxvxshVAqQ46pmeytS?=
 =?us-ascii?Q?Qe8Zmpr/JEPysDQnuRijamuHjqB8+pKqzxMhSy4d1HkD8QasgvFAuC4oU08S?=
 =?us-ascii?Q?+4EGPPRj7cBVXCjVDMVrrTciJ4VIXmW/Wjxeb6W1P1M8ALA45rw/I/GWQpFn?=
 =?us-ascii?Q?VuclJYOn/Wb/Aa58oZD/YDpXY6LU0H579+38nxM3bnPW5hjSM/xlZcC+E21/?=
 =?us-ascii?Q?aZ4+Gc1gxKUGuO3Xa1Qtv9G+t9fltuGdRlcyuM7AGLNLX7X8oJVrriEI9DMz?=
 =?us-ascii?Q?+zI78kjIlSm/mE6dbklD8dGqdGfQmnblnWdHx5QdIC43hOythCilPz5+Wg3h?=
 =?us-ascii?Q?zehDLBdUx89CPxDsog6hVxMRbu3juW81kXVW9QBGFRabQbspjrrP1Qfl+6kY?=
 =?us-ascii?Q?WJAmpx9W74HRa0/l8Ie1IMJ8bsrI4fj17UpCnCTLTRaVyJy3pZ6RN+AtYs2W?=
 =?us-ascii?Q?3/KAkUGdnKQiiQJlfIFRXdExvCn0Rk+2WJRTcJdQdGbCLEIbha2Y3ar9cJT0?=
 =?us-ascii?Q?2GTfni/5dgv3aZ4mRBxRgUZAzhnb7i/sksQM3J8BeVVJHAsweb2c2HEi4dkX?=
 =?us-ascii?Q?CTHRaHXuiEg5tl7LkDWP92C3qPWuId/Ug11RLuYUU1KFv1+2TlQEwpDLEPJI?=
 =?us-ascii?Q?hewWPtDa8jw1XwajOWqY/YQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b81136-ca4c-482b-8081-08d9bb3ae360
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 17:39:44.8291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJJ75R2LSTO/KfTppv3vpE6Y2X9qxpPziEV4gT7tlBRf4V4cVFjW9mDPntpmqpe08m8QEu2WyRHw/wZajTD+xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_set_mtu() call from dsa_master_setup() has been effectively
superseded by the dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN) that is
done from dsa_slave_create() for each user port. This function also
updates the master MTU according to the largest user port MTU from the
tree. Therefore, updating the master MTU through a separate code path
isn't needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index e8e19857621b..f4efb244f91d 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -330,28 +330,13 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
-static void dsa_master_reset_mtu(struct net_device *dev)
-{
-	int err;
-
-	rtnl_lock();
-	err = dev_set_mtu(dev, ETH_DATA_LEN);
-	if (err)
-		netdev_dbg(dev,
-			   "Unable to reset MTU to exclude DSA overheads\n");
-	rtnl_unlock();
-}
-
 static struct lock_class_key dsa_master_addr_list_lock_key;
 
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
-	const struct dsa_device_ops *tag_ops = cpu_dp->tag_ops;
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct device_link *consumer_link;
-	int mtu, ret;
-
-	mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
+	int ret;
 
 	/* The DSA master must use SET_NETDEV_DEV for this to work. */
 	consumer_link = device_link_add(ds->dev, dev->dev.parent,
@@ -361,13 +346,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 			   "Failed to create a device link to DSA switch %s\n",
 			   dev_name(ds->dev));
 
-	rtnl_lock();
-	ret = dev_set_mtu(dev, mtu);
-	rtnl_unlock();
-	if (ret)
-		netdev_warn(dev, "error %d setting MTU to %d to include DSA overhead\n",
-			    ret, mtu);
-
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
 	 * sent to the tag format's receive function.
@@ -405,7 +383,6 @@ void dsa_master_teardown(struct net_device *dev)
 	sysfs_remove_group(&dev->dev.kobj, &dsa_group);
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
-	dsa_master_reset_mtu(dev);
 	dsa_master_set_promiscuity(dev, -1);
 
 	dev->dsa_ptr = NULL;
-- 
2.25.1

