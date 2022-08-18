Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4303D5984EB
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245236AbiHRNyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243220AbiHRNyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:54:17 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A33B27FDC
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:53:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QpbCo7jep6+qUnbeqglzRBL8RMgOdo2y3ODSGXYcpJRA5LDok3KvVLmAMC36sPvksTys5ELGzG2i9/aD19IXbZqp4ZOP/Vpn1/p3C3iDzwbmib5JCv2wmc68p/FpQ9gA+PBKV+XFbu78yEXGs7NSu3n+x5nofTLr34HVUknJXJkDmg42lwZd5lud9KCRVnypkzbqRCSHVDbGZ86fuxZ0VW4zLTMVJ70DywWv3NeMf67x/+t3d/jj4Qr4IjLdSnBRXenRShNMTYgfbLbUaPQ2Q5UhM/167UarmSqSdIfJEnoyyLTgzrzpy/T+Vjx6MSJe4yKWzQ2ZknnRHnQOXt9RQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2VdL/nmLDPmHl2TzqzECdizZoAzilstNzZiWmWFfjn0=;
 b=Hes3I027uoXIgbSCskT6V+AUKT5Cv4bLGXwdFuza1XOViE3OpzOxEbpvuGSlu3YuQv6LiDYT1OnPqe2m44qo68gH1wR4+2GgsBIeposkrcYiZwMVJVDwTBxnwzrGFyUVp+KIsfOgtDHLAVyeKmAMWktqBPg3klxKQOxAAEgK04OgNn1h5P8fgzdctKNkHx3Hvz3bP9l+XGTaLByhzfp/v3ujNpuZd0OjNayVRPH5clkxIA4jt5d3HVC23+UqTh4ihzw+qokmE0Kx8AEx4eSuf8RbZ1NlfqPmpyvz1eQ+6TewrEdutBJE4vXRv/OfBOtAjaiTkHviEpnUe/dhi+tjTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VdL/nmLDPmHl2TzqzECdizZoAzilstNzZiWmWFfjn0=;
 b=aW6mAQgOCUWV33pf8hocuV1mGEJPktho2YQ2ljKVrpw3kfIlQ8WQvH6g0GWiLB4zWz7AdFE+1M7pTb6FmwmwRnbg35UAHOT3jREo1m6hANOCRxTf9ro5hSmy7/G4b3x9AWclSAVH6zF2+WrmLOqhIkXFAhcsdBXA0ujlhGjsxOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 13:53:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 13:53:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 net-next 4/9] net: dsa: existing DSA masters cannot join upper interfaces
Date:   Thu, 18 Aug 2022 16:52:51 +0300
Message-Id: <20220818135256.2763602-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22047e6d-c6c4-4746-f450-08da8120ff58
X-MS-TrafficTypeDiagnostic: AM6PR04MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R2UNVC05UHd3QcOsyMjrPDILMQ20aj0zwiKOOoxh0SMmV/c9H2PWADq8LF1Vb8b7U/SD6+8N+F7Ucoin9AI0cZJV8C2pDU4VMT0wplaoI0rluveVDvQOQiDdJybCCbwyLr/bh4/RzMkXg/8MhIn/J8aDoBFlUjB7jtDCUGrR8nWwEQRX8IzXfNnkjjy4vIYE5Mt/9iRTjyhBey3gueMAULJLARxTpt9bcQDFO2FfkND9/PiLyxc+xZacB0WJFqw6ru6h00c9lpvVogXYDXWFFbg9CHbX6tb3KhBAbajvEGwgtzRBxNZEjGO7AT+KqnbgjKJnjxz+zYjvR9Fhop1yh93tvRW1kONMqBADdGa5e8uywmiz7kLgrmmIMWB5C0uGzV85SOtBTE2dJTxiks9ywOzvVilfdU82k1NJPvezL8UwG4b31eIILarihBvPVxRGRD7EHQDfbd6TFGdnXRTBqwFH2/mbnVOapgS6F5/Ef6AGEapn0/G3tX+205Afj5fsGVezhzl9xzpxvEUSYMMhH5jRqqYFME8ubh+pYc661uFGizQNlzJmF+uuZ8pJiDn1Udx1L+cT+sErxOybo+Ns7tLHBWztUWC7GJT+4aLFLYVbqVNIpdGBGx6VgxpyZvzJjSfEzUMcHJjkOmKXfeGPs2TEz9xF9lIrSdON28q/wvQqnZoRe42FHzObWq7c8saLMhjOM3MEBq7KEpNPw4iDg3HhRdfjT+KPdRjAhy2luRdZtBMLRFITyj4gAUcr9ctvE4E8wzrGBYwCxPQI2FGZ6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(66476007)(5660300002)(6916009)(4326008)(54906003)(66556008)(316002)(2906002)(44832011)(8936002)(38100700002)(66946007)(8676002)(38350700002)(7416002)(36756003)(478600001)(6506007)(52116002)(6666004)(83380400001)(6486002)(26005)(186003)(2616005)(6512007)(41300700001)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HrwTl69SZyKgijkX267YzLFLNvv3/qUNWE8eBuhXC8+vokv5nT/EbH1rnxt2?=
 =?us-ascii?Q?kwUZxsx69ySDvFCqc0VqlxqnN+SwBse0fgokA4tkSkC8GW7oziq9zR1EilJd?=
 =?us-ascii?Q?nNGLfoIFuGoyr0U0sp4BxTVubSJIw0KmC5ygDyULUsTm2ticp3TDMpFhREuJ?=
 =?us-ascii?Q?yb+9LPr+pzRk4sZINCke8L8Tys/yQnaQN0djsx2KoSmxehchZHpwztDjKAFt?=
 =?us-ascii?Q?CJdFAzwpLeYv0KfO4LOQM5tl52wBaEVYIOLjQBNgNDY6bIOkpqxJOR0YJnB9?=
 =?us-ascii?Q?hDhAvcRdtFARe4RZynLoeaVBYQYUxXzPaxvM6FWWACm90Qi0/6eXPPRBNqxo?=
 =?us-ascii?Q?+6DTYCM1YEMFLY4FrJp9IBLNxKChunqoSdVYClDEoqjzpGQbteDp+oGhFZIZ?=
 =?us-ascii?Q?HjqsaRCy8HietWbXzdbao6QpxnWzdCWM0GFfalrtWNTCtQ5IbGBZx2XSH5NV?=
 =?us-ascii?Q?ebYbb8tz9s60x0J/8nHDL+7O1I3DQXq74SVSige7Zq/1ISSeN7RSBboYjEQ8?=
 =?us-ascii?Q?7aMTOm6PY8gKQ0TwuKCrLgKnnBnfnV/zS7DALl8aOlm9N1tPNBkVEhBwOJL2?=
 =?us-ascii?Q?J/IkQypCZFLpKowzbiTANr+tdIQz7+3UaOXHOzrNCB2QVIxXlpV04GMuURSx?=
 =?us-ascii?Q?cj5EltAa3ZOlPh8fBd5fKPr+6YMxrig9PMxaMJXBb0iQUYZs6iwcxxmpVls1?=
 =?us-ascii?Q?We9LeHfdrn+4VXBVHPISr+PliqQJ3nIU42D1JOs3ji/JztYRsPdE5hQZ0Ht/?=
 =?us-ascii?Q?KdTcHczMBTag3GyWEIIhv2K0Bqweb6hmHQx+COw8knUZlxeTxvL2QbZAjMfL?=
 =?us-ascii?Q?ewCJOxFlh2du25qow+bU3dQlK+1KbDVQgkONXKqBjcintstS7kbKD+RsZ1xT?=
 =?us-ascii?Q?Dm+K3Vspvq8l71Jk2h0Zq/6frnx9xeFL0T67k63v45WvPTPh90Bk2zlbcF3m?=
 =?us-ascii?Q?ZvSeFUOKrjFTD3bvs0ZXXVdPNsf5UiV1Ppehnf6wWKN5Y4E3U2z8+mOh9huM?=
 =?us-ascii?Q?gZQzpf3GPc3/BQ2J9drh1mlcMHKWNXuodIWJqQWrLShjJhzamy/+lPT8eBHc?=
 =?us-ascii?Q?5Mn8AVA+2p+X04F3GSnrWLsrLnIns5RxNyJ35Irw5E/uNpTdhYhlCVTM+gWp?=
 =?us-ascii?Q?TlJ9xa6ZSubRul3SuVi/5RsvpgpbNp/qeaEM/YiZ8NUGB8dkbrw0kQBkJkFx?=
 =?us-ascii?Q?WyMWztLI4Eg+U+nwJ86pS/PsalmMDxU3B+b2ZlkhroNbqvcZkjEb36oZrZDQ?=
 =?us-ascii?Q?DZ7bhOILOnMbYyPjl/FGJwvS3/HMBj0/vClrwTe8m8bIrVt65znNeWnLsxst?=
 =?us-ascii?Q?AAdrDy1NJzEAXhiZub9cl+avZcKNsUeny04wROrzUPnDoqpzmO8YsCrA8rpR?=
 =?us-ascii?Q?WpOZnonMTQ6A6y65CkbCwosdzq5W/DLVoMcpz5QnoLPH4Va6jqLbPkmYv/Vo?=
 =?us-ascii?Q?GEBmM3z/cCzJEIROKM13SfATYBuPy2509UyTRhxcU1MltdIvpTBRiB/rKZdF?=
 =?us-ascii?Q?RSRQbeITnGOJUqOFgRZFKSmVaoNNKaOQbI9UHhm2hf9OHETSX4SPdwSdDO63?=
 =?us-ascii?Q?roiK2X2JQzQaAx+aBP3uL2HC7jD1G2GUp9HC9jikX4AbGRJ6Upz+BcbjFBaM?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22047e6d-c6c4-4746-f450-08da8120ff58
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:53:15.0552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZMugSR5Q4KFEWsPUuYOI0BmRvdZEV2R1PYBYsrWdgWHtmForPkSfVKL2iXDuqBwn4pasSZqyZOEs2/Wvpd4Asg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the traffic to/from a DSA master is supposed to be distributed among
its DSA switch upper interfaces, so we should not allow other upper
device kinds.

An exception to this is DSA_TAG_PROTO_NONE (switches with no DSA tags),
and in that case it is actually expected to create e.g. VLAN interfaces
on the master. But for those, netdev_uses_dsa(master) returns false, so
the restriction doesn't apply.

The motivation for this change is to allow LAG interfaces of DSA masters
to be DSA masters themselves. We want to restrict the user's degrees of
freedom by 1: the LAG should already have all DSA masters as lowers, and
while lower ports of the LAG can be removed, none can be added after the
fact.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 net/dsa/slave.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 09767f4b3b37..5b2e8f90ee2c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2699,6 +2699,35 @@ dsa_slave_prechangeupper_sanity_check(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+static int
+dsa_master_prechangeupper_sanity_check(struct net_device *master,
+				       struct netdev_notifier_changeupper_info *info)
+{
+	struct netlink_ext_ack *extack;
+
+	if (!netdev_uses_dsa(master))
+		return NOTIFY_DONE;
+
+	if (!info->linking)
+		return NOTIFY_DONE;
+
+	/* Allow DSA switch uppers */
+	if (dsa_slave_dev_check(info->upper_dev))
+		return NOTIFY_DONE;
+
+	/* Allow bridge uppers of DSA masters, subject to further
+	 * restrictions in dsa_bridge_prechangelower_sanity_check()
+	 */
+	if (netif_is_bridge_master(info->upper_dev))
+		return NOTIFY_DONE;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	NL_SET_ERR_MSG_MOD(extack,
+			   "DSA master cannot join unknown upper interfaces");
+	return notifier_from_errno(-EBUSY);
+}
+
 /* Don't allow bridging of DSA masters, since the bridge layer rx_handler
  * prevents the DSA fake ethertype handler to be invoked, so we don't get the
  * chance to strip off and parse the DSA switch tag protocol header (the bridge
@@ -2753,6 +2782,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_master_prechangeupper_sanity_check(dev, info);
+		if (notifier_to_errno(err))
+			return err;
+
 		err = dsa_bridge_prechangelower_sanity_check(dev, info);
 		if (notifier_to_errno(err))
 			return err;
-- 
2.34.1

