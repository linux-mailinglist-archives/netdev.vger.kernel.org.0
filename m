Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DC44B75CB
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbiBOQyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:54:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbiBOQyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:54:05 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2139.outbound.protection.outlook.com [40.107.22.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA7010F9BF;
        Tue, 15 Feb 2022 08:53:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5Md4JzMpaM4kusniRh5DIpFj21KZVwneDBpcqF3EpxGqwqaZpnwqORnpe3r9RL1OK+WRXrAL8qGpusBkA3MDwV3R3OK6JdTpXJxf3s9qg0J75RfqP12Xf8ZkMvQkSGVT+rpep5npG3w+7duDDqDIdXut/4hzaVCdKOcoGsYZXGqLwF5YlJwguRAq/M+1czWaDa+07emVgK3oSOcJzDXOpivlYbvc8Y2sZaFCnmO9n2P9WRMG5BUNphTVbS9ugNnWGGT5Cb4uaGK/6PkQmNb1S51PltiJcGNtib8TcRixhXsHUfkiqBd2+LzAmv2HlCNBtP9gPwYkUX2hDGO31HF+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30qjie4zvvUR3qiMhl7a9mPuWrV0KrDN7+kIPW4vjOA=;
 b=nSMeK/+J1hBrniznuqQg0gUK6Lgp3xt3li0xvmAyau5uY5Ry6lIrTHmSk29H66CuEcIapB6pnogmMCpj4EaEgVpn9vt4KsYLBufLAWMZ07CFhsDnHgEliNVo5eclHJq7gcwXdTt8nsHi8e2k38RgRKMvZR7oOHP6f9sbprbyup94DJ99g7EKJ0j7wTRmwLEZj47ZR85Wb7LpRF1tV0W5Uz91u7x/kuIjzUGNo2SPuUL/0+OlYVzcKjX+dFpSk0d5VcKnNK9m0Djp2qgGwUUkH+P6kMv4DSST7PB09UoFMFeT7EtBP5KGNuqd6i0100WB6dBwtDGtxsjUKJhAksdBzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30qjie4zvvUR3qiMhl7a9mPuWrV0KrDN7+kIPW4vjOA=;
 b=YcVSs7YNIvdC8HgqBoJsT+2X5vU3a3BFbg+D9pZ9Vdhs+iRGRFBxUtSr+klKtswzB/izY3BHmIVEeiTXW+QNQukwv5LZS/B1PiKpxWJT+sTZqG+lmjoJEx76sLYs8BQsK4l8w4UoXZ7mUw7io42434Py1Q6D5zDDN7QJ69Wd97c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1156.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 16:53:53 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::a807:615f:f392:8ffb]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::a807:615f:f392:8ffb%5]) with mapi id 15.20.4995.014; Tue, 15 Feb 2022
 16:53:53 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Yotam Gigi <yotamg@mellanox.com>,
        Nogah Frankel <nogahf@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        taras.chornyi@plvision.eu, volodymyr.mytnyk@plvision.eu,
        mickeyr@marvell.com, nikolay@nvidia.com,
        bridge@lists.linux-foundation.org, vladimir.oltean@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: bridge: multicast: notify switchdev driver whenever MC processing gets disabled
Date:   Tue, 15 Feb 2022 18:53:03 +0200
Message-Id: <20220215165303.31908-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::17) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eff0d246-7d2e-458f-4078-08d9f0a3bf36
X-MS-TrafficTypeDiagnostic: AM9P190MB1156:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB11563447AB4693C2EE723EA4E4349@AM9P190MB1156.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I2fByklnatS3HNVNW9gw+ZFjRByVnb/9gcH3c1CiBVld4hXYidUPRwYDY0+zZFZxuuAxuo+OFEae0mVSluUF+Hcs20IUoicaRiACWkuY3uuQNGIRz6gPZqA+4+GBD968+83fp3Ji3jv+q4qFPw5QsDWn9uiagiDmBdUn8XxLYloQfSsQ4F0TNJEa9sOwOoNA7VAuGcdaarg/XbB1j1YDEHU7V+LD3CXllbyk8i6TsCm/tRw9TAUVtwDAvu+eu8bfRpP9OH8Rg5gGZ5u6mwaDAG1bmoygPzeioCPITpRvm8N0gMoxh2SKm5nWgB049d/409QfufaOEhBX+DCFRn6QwXBnMUT9Yyh5neEObX/kcYyFEvFd27GfuxVBnXfNwls6EHkSSEo6wYbcej9DSorcgfqBH9pR2zEQg1KQBGH6aHfed8IyGdUBud6GJgkqbm3f70n419Re2MjpiC1F5s902ZEY9073J1mL3AVZ6WWwNk3oLS08FQF2tEA+fI6wNjMIoHN3FaGEqTNqD1dFBVVGdvFAoPWPmxggijfB5cXhaYTtrau2e4q8PlCeUo3Dx1V5gjJC60QXQub2+LL/LW2FPcfJcs46ecV5ie7hu5w8WTq7qj6jfOenXMhjmkupmoa3egl3rTTYARbjU8qO8KC5Xjj139WdwpgpFr9zNyvHL0rS8OmE5fv/hOV5sEZy3zJ5sb+BBbKlBtAcyqJjN5+qxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(39830400003)(396003)(376002)(136003)(38100700002)(38350700002)(316002)(110136005)(83380400001)(36756003)(6486002)(44832011)(7416002)(5660300002)(52116002)(6512007)(6506007)(8936002)(508600001)(2906002)(1076003)(6666004)(26005)(186003)(8676002)(86362001)(66476007)(66556008)(66946007)(4326008)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7amFpU5OoZbSbUNV+CM8p4ZGZ+pt+X8scXZDTifhbzF/2wwkZXoUe8qtuE42?=
 =?us-ascii?Q?3Qq+jM7HkRiY/0/jWNdmBWCJaQfvZ+VwslPY1yjppNrbuzFLhrFaYDKUSB2g?=
 =?us-ascii?Q?AUmqeecSatYikw8VXLOncBst5y9eIxHVq7MIUbhmqvfgUZlf2a6AMNM939SK?=
 =?us-ascii?Q?srnGiztoeYr0EP36kC2h7Pd2J5SColsLCzM/nmpso/m1kDwRHq0G4sy4cTOC?=
 =?us-ascii?Q?zC74o+473z/XwgeSO8yGGA16xIHpTUvCr3ZjuEG7yWKL722ZgcYVtOdE8QHa?=
 =?us-ascii?Q?+von5HA8UPgNc9TAa5PUceXRuTSIe/adxQ4XJ04eh5B/FdmqJ9J8OM/EOujq?=
 =?us-ascii?Q?tUosV+rUC88XCdpLswdZ/c2AxMhR7Eu8dLvew9rIefUDoDwiBkNwmHJ22Sj/?=
 =?us-ascii?Q?qwbaVfJmw0ehA9CdE/fJlUfkEyom5fStY9EXC5Ik4F+Rq6+DJ65oTsZnFQPf?=
 =?us-ascii?Q?33zEMl7lHEOcPFgpv2MR9UkJ6oaIjZ9CBdmjG40j1zBrADGz9zaFDJ1vW7T9?=
 =?us-ascii?Q?Sp+V/DgaaPRVrpvTU3wPCEeGuEF7oAvo3EVx2U4sm9pzzkbkSPLCwo1tNRe8?=
 =?us-ascii?Q?bVGEGRTN6ZOwZCiS31Q4Rg2jCgqw02pnfm0GLCU5uLWRkF+sXi1jRvQswDaJ?=
 =?us-ascii?Q?YoxLaKnFQDnVwCDDkBGaqyis1MTO+4xxdqbwKMAieyWy1H1XFM30qZqtD3Rk?=
 =?us-ascii?Q?x6v5Mev2zwZ1ax7eZ4AAD+Ki6pcHCeCTIZXWfONPdVRAsfmliqpW+YWgojBF?=
 =?us-ascii?Q?BJ77JQ7f5GeQJS0JFZlnP0TkkZbDTiDvk86SQ3gdQqAZIRW1APEuazMYxP5H?=
 =?us-ascii?Q?K3uNcRaBkCVG0MNry/Wwsqv/UjTJ5qY3ao5flzR19ykcWORoSjASw+1sT830?=
 =?us-ascii?Q?Rx7zi/My7wnPNT0P2cXrsUOXzIbmnEEirrR626+Bwfz6Jjhzd9pFPAE1Wvon?=
 =?us-ascii?Q?rBV7AsLuMT0SDxy/wsrNJvozTF7UVy7uRQRkVerovIs0IGm/CYHk8dyc5KCK?=
 =?us-ascii?Q?oxe48Ts7/cd3Gs7K5RTbkD0gFruNWa79zVX2Zjq+uALarouWF/C1FGMsxK3M?=
 =?us-ascii?Q?etXYwZrevl/gXoqhoWxs4qDgiYWMVYrNnyeMly+y0TmUUsOArwk+Lou37E58?=
 =?us-ascii?Q?3+mhkUVt9Fg9eyk/VuolWrMF4DH7g4fdnmK8Hznnd3QXtl5mRkmLdtoicaBD?=
 =?us-ascii?Q?4dOddsE7VBAgzWZx+YHf5N4S+fpDG/+gpVLAYVv9IOTKmeJDjHwhZDTOT//G?=
 =?us-ascii?Q?6gDhrWOHNjmTcT92I8syboaqUv7A3lBFFACBpORA0Lp4VWUBG6wR6JFMVBfk?=
 =?us-ascii?Q?Jof/nLTNUnjkA/0tXYSPeI6+pxduTFp5Fv+gIg/Rp3D9t4vIIBsZ3mjGf4F+?=
 =?us-ascii?Q?RcgXZkEha8WA9at5JrcH4RPm+wdJsveYtvv0VjAFNAsK2M+SrpzwoCb4MCpI?=
 =?us-ascii?Q?OobLOlwuIi2iuvKD1xxdq89uRDm9dAT5duraS0bb/Cjw1hbboHz9WHOsID2m?=
 =?us-ascii?Q?vzvZp6H7h5ohIS9LXgeTLB9/hDzlObXE/rVs9UDO1MJefK9ky4cUG7ARVWze?=
 =?us-ascii?Q?W7x0qf9DGD1Jqqn92FOUGn9pPvVFL3bJ0XE95Iz/wboVp4zB/BvAAwHJo6cG?=
 =?us-ascii?Q?jMygOdYyrD8g3e0w9LgX2sHuwl5QbWw+yZ/rvhKSsTHOKCkUNFudr7hg6lnD?=
 =?us-ascii?Q?VG5W2A=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: eff0d246-7d2e-458f-4078-08d9f0a3bf36
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 16:53:52.9068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdH2qpHm3fUd4O8o2ECAL1HCQrWD3bFfkeEj18gLE7Bpu+3xGV85Fo9fzR3zvpnee8nsMkRVlMx+k6t1cd9EIbar9B3w+RfaZKS5VWSY4o0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1156
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever bridge driver hits the max capacity of MDBs, it disables
the MC processing (by setting corresponding bridge option), but never
notifies switchdev about such change (the notifiers are called only upon
explicit setting of this option, through the registered netlink interface).

This could lead to situation when Software MDB processing gets disabled,
but this event never gets offloaded to the underlying Hardware.

Fix this by adding a notify message in such case.

Fixes: 147c1e9b902c ("switchdev: bridge: Offload multicast disabled")

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
V2:
  - target 'net' tree;
  - add missed 'Fixes' tag;
  - remove mc_disabled retcode check, as well as WARN_ON in case of err;
---
 net/bridge/br_multicast.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index de2409889489..db4f2641d1cd 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -82,6 +82,9 @@ static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg);
 static void __br_multicast_stop(struct net_bridge_mcast *brmctx);
 
+static int br_mc_disabled_update(struct net_device *dev, bool value,
+				 struct netlink_ext_ack *extack);
+
 static struct net_bridge_port_group *
 br_sg_port_find(struct net_bridge *br,
 		struct net_bridge_port_group_sg_key *sg_p)
@@ -1156,6 +1159,7 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 		return mp;
 
 	if (atomic_read(&br->mdb_hash_tbl.nelems) >= br->hash_max) {
+		br_mc_disabled_update(br->dev, false, NULL);
 		br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
 		return ERR_PTR(-E2BIG);
 	}
-- 
2.17.1

