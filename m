Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A45E4CBF8E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiCCOJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiCCOJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:09:38 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2080.outbound.protection.outlook.com [40.107.21.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D2C10CF34
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:08:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLVGxVoaNoAJN04vyDyQXS9YCEjHok+EOUU9LCSmgNhChN5S6Cd3o9pBHehYCSubhWEedhwHINszA4tYSxEIBAg25BQZ/8z/jrYwxOSmS02H47ray6YRlO/CPbS7kcT8dtvfmd9pVdNqtrky6iM1UGJ65VRt6jSP8mT5cdUoKN0R57pDgxI2pdees4zYaPWdP5NbVdmYPex1qajBtBwaJ8jubYJwSXjaMkC9TIUJxbcrsqLfjCa+DXIVvHHcSYmFgEmmWizh4f19vkZjmLcM8MBwWq8ur9mEh/7rD+wihmlD5tViCpBLX9R0C2uuntv5N4aeMCM9r1P06Vt/opiXbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlXGkSGW5heLDr4/jr5h/PYKf9j/dmGdRVn2fkTB9xo=;
 b=Uqjh60OkSIfSTveSR8s1w3nF4QhbpT5GO57IuyKp/OObbszwnMP1uBOR0te2qbMGo1ZRf3r1TpJ5oS1d1vOMUHdSIArKp59LNpD1gzlclk4pjB5ne1RJknY6uehqwfMVyZm1uHTXLE4pcHe5VS+JCzPpUnO2p7rH1AhWuqvJZAkTHlAnBag4RLSXhmb4TiX0CSBwU2bSWhYXRGa+oaea+/GBBMWtncPwRsukeaebTNfLqYBW850yqoiJB1NfjX6z6F7mJmlKPRe7q9Uomdrdh12OpRZJBPhgAVjVroit0VuOSaqwbaTAT0xH+i494CIDMUDUqPVRjO5PGW6XSH6EEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlXGkSGW5heLDr4/jr5h/PYKf9j/dmGdRVn2fkTB9xo=;
 b=qfGbHMpc1KiA/BlgNoUhszYIeHuyjQp5RYwzRqkTQCdhDHrkM0ox4B8dmcsGTFeDT3bDB9qM6yvFdYKFvhSkEyfP4LlBrEOrEgRl/ula9YwbOKyIsiM7EEyTWAOUfOEykOHwO7Ff72hiC+eTaI51d1GYWTvZO3y3O0JAUrd/7Os=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6994.eurprd04.prod.outlook.com (2603:10a6:208:188::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Thu, 3 Mar
 2022 14:08:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 14:08:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next] net: dsa: unlock the rtnl_mutex when dsa_master_setup() fails
Date:   Thu,  3 Mar 2022 16:08:40 +0200
Message-Id: <20220303140840.1818952-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0009.eurprd08.prod.outlook.com
 (2603:10a6:803:104::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 316c19cd-f3fb-4a42-b3a4-08d9fd1f56bd
X-MS-TrafficTypeDiagnostic: AM0PR04MB6994:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB69941AAB1CA8964B95320EFFE0049@AM0PR04MB6994.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kLnHOEIhmJh0/QJ7EfzDtcya099X3nYYY4ppAQRdRQqCRVuhecQirKk+o9mxCBPD0OLrjnlqT9qGq2sTH2r0ZLYliO3cSqbGOg/BEJcFfBDy5LBEYYmvSJsTVmvXxdKpxMKV6/GKT0eHxY6vIpmMM658z58j8eRHeU7u+eSdlqIaTYSAm8lMdVgydnRSpqVehI55tHJv9ne7fDYJDegCUQQGgyEat+EWUhkVsumd/U/vwPY+LUhGwutdU24665Min6x2UbpRKOhf2/w3w7dJvuBZKsTiK0ih+NB3TtAZuvA6VRjxp4FjO764FE7sIfdg4doc61bV1hpcO1SDKDUbqdjOqwNYZzniv/ijy/d2UTsh4xyrmKsTCIUIhxtVUtAD4OUk3Im8iInILguvXbuDVBrkb9++DPnkYo7SNrrkMfFvcH9EV2xEBzxDp7S+N7XKjLg/DcRmgcOhKa3UEEW/zbyJdD17NAp0FhdfUHYyNgI0CGBU+csL6JBbMONssUjlf0AE0ZoilDQ1jJ93OhZjqnO1PvBnqpT+2a+v51RLAbAJl1egvm887F2AenOi3MbLr2wUlOwtIzzTVV5E+Jgg6AMQdGpdBtsblB3oE3+hgJvot3vuLtJ6ei/QY9kiEf8AVKATqrAkPZjO+StdBeFeAQ7v3bhaEHmYhSyRtaGhaPi1LU78ifXinRtDcbfRqWdqWCaaJadM0OJPHOHYgfKW3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(498600001)(6486002)(66476007)(52116002)(66946007)(66556008)(4326008)(2616005)(5660300002)(8936002)(6506007)(83380400001)(6512007)(36756003)(44832011)(26005)(38350700002)(38100700002)(8676002)(6916009)(54906003)(2906002)(1076003)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u8bZxWb64NG6q7/QNfyjsJVpGBmPCzF7cmNt1eXdEt+GqUlyz0/GheTB0psq?=
 =?us-ascii?Q?HScZoGBBNPATItcO/wirjfCbjm33ixNp+iVpODPSHUi/p9m4LgqvjIzhHsdo?=
 =?us-ascii?Q?lVIMsIjqzQeGpj+W6Mkp+d6Z74H/ZCa713xaIrS1fBvGWmUR9ZbVazRzs3EJ?=
 =?us-ascii?Q?je41lPyRhw0vagvBxx5U6AntEQ2INZ76mN0STfAnYlwAbQnaqXtUAhpQJCh4?=
 =?us-ascii?Q?8zelggSA5Rb61MKaQfWSoLNM2z4cchCEC010nN/E7FmJ36u9NYd4BVFcSGnT?=
 =?us-ascii?Q?UCTlc9un0Gz76fP85519yRDrxaXo8Url/bohCmsBoI2gUEiJHfKaZKDTueQy?=
 =?us-ascii?Q?z0velIWYfNe1UNsl3HUecvKts+Hi1Rc91QVYh0wvQfRlXamaOeRw8xD1o5/p?=
 =?us-ascii?Q?yJu0j1ytioNpJK8d0zRPAI+jzBrODR38P166ePLKBe2TUK6EgyKc4KiCOCnr?=
 =?us-ascii?Q?7i90QxC8bmxiYite7JMW4MBlJbCdZUU11DOYYt0WgzSwzSltWcm+YmqAjRKL?=
 =?us-ascii?Q?n8J621Zch/j2si5BFdYOGJKAooDAK3D+8C5UgwTlSAxQIPOMV59yW7q3uQGx?=
 =?us-ascii?Q?eCegx9bZbxwkB13GK962jE47er0L/y2d9U5KERlspL5sdjiRhMQdFeMoZaXU?=
 =?us-ascii?Q?ORJmgYe7abEC5Fylx9L18HTUJvuZyqw4BpxNLM4PI8khH7NL2db49inEGAcA?=
 =?us-ascii?Q?XrCKmSEk1UBI+t1L6TALTxSmTEVcpnFAmNNWHergKiBrWJMKU/j1Gqgj++TK?=
 =?us-ascii?Q?rJBQhsgyXorS5OOCfnZ8DXXcSOifHA3mfnNfGCtyoRiqUL8tHj3rZ4kDNXmn?=
 =?us-ascii?Q?iK+Ef2WsnvwCepFXDppcfjr/Kg4Zolg2Oe8VPobSWZkGxMG0FOyIoMFPTagb?=
 =?us-ascii?Q?pkdQjK7h4qlNDUzOknrPWrIiU8cKKeGt8Yy3gUxoyZRQ7O3HzRgCvrRCeqq9?=
 =?us-ascii?Q?xdEBAWIRM2LyAXaWNvzME8Kk09gu78JCaFb+NRklecGx11EEP5mDPZPVIlzg?=
 =?us-ascii?Q?bR//N2Rej7oOB5WN0jUap8LnjB2ZTZGHsjS99suwq0RN+DbW57VzXBGeey2h?=
 =?us-ascii?Q?L7V1s+ErN7EHCyHMHue1ReiO1h+/BN1x7zgjeoe681r/khlOmrHXutgOgWYd?=
 =?us-ascii?Q?CMAChc65XX7fz85WHbbmpdLXuIEYXuWf/TsPKvvlxi7qS52wcOHw8JyOUarz?=
 =?us-ascii?Q?eIca80S5s4vgDeMOriUmWiVUilVM7IOSXAhOpbqqw4H9U8nypnJWIBRqeNdV?=
 =?us-ascii?Q?RirmNaav4bSsI+RnAtX9iLvk8kSn2KfN4OjMGDMJ5sVXiDTo4Zv+FaV26N0o?=
 =?us-ascii?Q?JK4eZ6BS9w4bPbJVYDh94O3nswXWkjJYg02MbCOonRKvkjXBDDBxw7KyDCfU?=
 =?us-ascii?Q?TCejw4hfmvmtoYRZMY7sNBp92bGhtZjBBKAVOMlfBynatdvmyiNpuNdHDJ10?=
 =?us-ascii?Q?OQXpcxX6YSGBcTAz1Zv3rmrnTzcL6y8N+/TCT1sMTRzJYFuESNCkL2l7i4Oi?=
 =?us-ascii?Q?/0tngy6jPbw8u90RjAT2866DdHK+sXgLxjLf+9PkEV4DmkvWYCvpibdbuXZy?=
 =?us-ascii?Q?jz9GAtWUutN/SrtafGcng3OTR32XqLtXLLK07VP7rK1d0EALxfGRIs+f1N3g?=
 =?us-ascii?Q?Ap4H5Ldmj0LNU5O1kx8muM4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 316c19cd-f3fb-4a42-b3a4-08d9fd1f56bd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:08:49.1815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqlXNbTX6+48cY5LUe/XURiD2XcwMlL52G0MQGm4jt7EajXlGsrh9fYH97oMId0kcMzvdIMO/xdrN9NsGso8Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6994
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the blamed commit, dsa_tree_setup_master() may exit without
calling rtnl_unlock(), fix that.

Fixes: c146f9bc195a ("net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: actually propagate the error code instead of always returning 0

 net/dsa/dsa2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 030d5f26715a..d26430e33096 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1072,7 +1072,7 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
-	int err;
+	int err = 0;
 
 	rtnl_lock();
 
@@ -1084,7 +1084,7 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
 			err = dsa_master_setup(master, dp);
 			if (err)
-				return err;
+				break;
 
 			/* Replay master state event */
 			dsa_tree_master_admin_state_change(dst, master, admin_up);
@@ -1095,7 +1095,7 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
 	rtnl_unlock();
 
-	return 0;
+	return err;
 }
 
 static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
-- 
2.25.1

