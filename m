Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8608A626369
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 22:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiKKVKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 16:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbiKKVKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 16:10:38 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2081.outbound.protection.outlook.com [40.107.247.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CCC86D66
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:10:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLvsRRV4rqB9y2EV309lRURjj107TPQdLr/RPA3OpRaj9R51WYWRD0AQYfC73IMVkr1UB8OJ3ixvjDcfc5ugr2Egi8wrVvEPkEyZTOAv/6M1/iYe+7zF9xiqYc6EWEnRLv6lEmI2F9tpND+hFvLfeR23Xzj7zo8g4m+Lpxnpl1p+Mn5ind7p434IuTpwzDuygqB2zgVNhBUjMSACUgjnYopz0Bg+JPjldoYN63OnnKe9XLgbttXjsjAwxibvtDZQX6hSkh8b51aZ5T0CJJTQe8NDF4ZDC7u2VGbx/YTt1qEjE+L41MgI+mER01fw8iu6ZH/cfeNP9ffQ7f0m271D/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wmX71NYUueparYgrUU9dVEM8uMuSqjizM96oBtmcd4=;
 b=YPt/yVEP1dIEEEiCAntwgL2T4BBw8+TJM+uQBAhaaDzOjYCgaiCU30tvB93x8Wn1LCqJuzdRtCxKksg+WuFkIKX7ucYsx7nV5sHV0/FD2TQaWBMjdVXjsfk1mQzrAyvw5bQpV5wtoKG4Sm2paw5ULBcu7RK2IskqnCdQAimWPLorVgApj8AHNyG6T2I0wwQl/F/dwuXCdMst/lNDRW4VkQkjml+Wd+C/V+N9nWNMeK/HM3v6knNNjD2fxWnPYWYiUlGJrMYvFKD0WuiGPRchz4/rKVE5yyRrG0pgAEoVf9Wk9CvYTZKCORuzu5Gazo12fyz4tGMUntxClwBqVmJzRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wmX71NYUueparYgrUU9dVEM8uMuSqjizM96oBtmcd4=;
 b=LjELmQlHFeSXDUha6NR3lBEqZdpTxouvUNboW8Vtu2+wU90AqCO4yKYAkfyonsB+jhDDIuJlCu20ZXG0tD4mBwRYPugVMJhLIwtyw7WveSJdSoUywDUhmcUcwa9aPhNMBEga8lhNLBnIXkHhqh0dANYyewHlgQ/6/jof6uM9Gc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB7058.eurprd04.prod.outlook.com (2603:10a6:208:195::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.15; Fri, 11 Nov
 2022 21:10:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 21:10:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        =?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>
Subject: [PATCH net] net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims
Date:   Fri, 11 Nov 2022 23:10:20 +0200
Message-Id: <20221111211020.543540-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR01CA0073.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM0PR04MB7058:EE_
X-MS-Office365-Filtering-Correlation-Id: cf62d9bb-20a8-4824-7cf4-08dac4292c50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5qKdoemVRskpXfFgNRz5yQWWMGmNQaUT5LrpVqYb57+Nv3BPWKBuYdEVw/0anWhThT1rgko1dQvIZF2+E7L+yOaYx+sGsrKn8FW7UCmsX3Cft/N/7arrHl3S24FOqcOj5mIemXBk9z9HUmobuzRLc66k15jbjnI0V12UvXumjhjcxyJR7tjF/bUoC+kAREkg19CMQ8HCBzwkhhoZ7SHu1odpvM/nkegDAePEC9z/jkmkWNpqklOD/AsGazjlsBzU1nt4JSo7LChZXQrXaA+H8l4GZ73tNtg2mYUVhNHU/Q8rTBIdJ2KAHFGGY+mtijU/TqmE3ofDIU2msxwCOw8bsfDUfwxyL7xySvCvKRRaz9q8rFC+0ILxilWHTgyMLSOGtJEM52RkoW0lcMzzCT8Z5P2CI+dOGBQzGLmH05kHa7p+lHFAJtMBffOPIJfeFHRbqfs9CXxWha29YZAlEN00Q1N1pixA/CkaomPUjxpMjx4nu5WHlF4hGEovIHVjuFf+9k8S6CHQxeYxGyeGNPeJR/axmQ3xvDPo5Zf4ul/1I3ezmIzYu1P2LzUq7FBmpTgg9GYruNXxQvEPmxqP+cwp+r+GmOhvSJOj3glohXJ4eLlPK/OT2g9pMKNGHqSc8GUVERc7mSVFTrqu1AONMYE5Os3eKHAOkXr5pmtEMwUYLzd9o5U8eophgEBv2M6ovepEkpeKamTeupzc51WLr+MDeCngEnpvBxK8uVRYb2Nv93c0PzFVrWQNw7XE9MYhR3rjfkq79DlWsCZj+xNIcs0Dqizx1SBUNToxC6jFVfSnhas=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199015)(66946007)(66556008)(66476007)(36756003)(54906003)(38100700002)(478600001)(6486002)(966005)(38350700002)(1076003)(2616005)(186003)(6916009)(316002)(52116002)(5660300002)(44832011)(26005)(6506007)(6666004)(6512007)(2906002)(7416002)(8936002)(8676002)(4326008)(86362001)(83380400001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTM4TjZIb0VyTnRNc0hLb3RxQTFXbGI2Z3FsNEJoSk1oN1BDRlhlYXdFM3BG?=
 =?utf-8?B?MHgrR3Z5NmswQU50bExUMHNHNTlYZ3k3emJWNnJPUzJwZWpwbVQ5aVNyRHk1?=
 =?utf-8?B?aVg0REdPalFPNVpRbTdLREUzUG9IV2RyOExoYkhBTitQQkNjSFBRTW10aExT?=
 =?utf-8?B?c3BCdlhnMW01ZmZTY3p5R3VXeWs0MUZFV09kdUMzNDFwYW12VUN3VCtHQTVR?=
 =?utf-8?B?bFNtdWpBbmwwUGdibk9hN2hlTDVXMEZ4UEhlMnZCWUV0QmxmdXg0U085blpL?=
 =?utf-8?B?RlM1S0REUXRXeENEbE15a0JyS1p5Y2JRZVRYNldqZVBlUGZjTi90aWZVcytn?=
 =?utf-8?B?eHR5UG9lcW1iWVRHWW1SbkhjWXFDcUhhZ3FhaFQyV0o0WE9BTzNqR1N1N3BO?=
 =?utf-8?B?NTJIcDR6RkFjeGNRR2Myc1AvdWFhYXhMQVlleENWTjA4djg5aWFQOStjcmNZ?=
 =?utf-8?B?ZEwwaEM5U1AvN2NXY2JOL2hUTDFKbFU4TUc3ZVE5WWkzWGU5MFBSSVdmSEI2?=
 =?utf-8?B?QWg5eUpKeGVzdVN6NGdsa05DQUFsd0lUQnA2cFppbStiYWx4bmU2ay9MYkVR?=
 =?utf-8?B?RVlNL2dIeGNQdjQ2czkxRkRRUmZGbVZJeDYxMlJXL3ljdHdDekhpZ3U3NENF?=
 =?utf-8?B?SHpTTjlQd2tYOWJyWk9kU1VBVHFFU2dKdWFGMHZQMzVVNHFBcUlSY1lkMm91?=
 =?utf-8?B?aDR3aERCWm5GczNqODgwdHRNOFlSSGtqUENNNm1UQWx2MzNzajFjWUFMRjBa?=
 =?utf-8?B?Mnk0alJKZTZUcStDMXlRWm91SkFIMUtsbTFGcGJCK3JKODczTnJubnZ6Tk51?=
 =?utf-8?B?c3I1VkNKQ1dKSGoydHU3MXhXMjlEdy95ZXRkMWd2NHdhNS9iVjdQZk44dmJl?=
 =?utf-8?B?OC80WmorbGVWUnFKb0ZoMDNNbnFxK1pUekFGZEoweHU5Ty8wcEx0ejVPR29G?=
 =?utf-8?B?ZUJKeHh3ZEJPR3BlSmo5MXN4aXFSQlRac0NrcEdTSFIwZnREalFFQk5rd2k5?=
 =?utf-8?B?VkJvdVR0VDB6SE1UWUNob2UxcG9QZlBBMm40VTFaSWpUSFZEenFtaUtYRUh5?=
 =?utf-8?B?Z09DRU50S2VWMHFSYVVQNHdxdW5KYnBtK2p6b0lDU096amJtRlVYblhlWlVz?=
 =?utf-8?B?ZndDeVphTnlnUXYrOVVqSXJUeDNHdGd0ZzJJWjQ3ZzNsWjJqQWNoYjk1b050?=
 =?utf-8?B?bVJkTDVlWTM1WmVERUNFTXUrQ1pxSG9wY0U0am1KamEyUU1KUzdINU1CRExL?=
 =?utf-8?B?OWlmaUxIbU0xek9QR3NvVzF2WmFESHlENkg0eEI4WkozY2xPYnR4d0IwTjZo?=
 =?utf-8?B?NzBnODlsRDlhbjlZVFpXai9QUy81NGgxZ3RxZnpVTDJUaEMrRDdIOGlNYlZz?=
 =?utf-8?B?TTJXN3NNcDFWOGg4b3hFWHV4Tm1PbEdBMlI0S0Vqc2cxSGlMOEpjOTVXQVJJ?=
 =?utf-8?B?RXJKRUxjanFUaytrdjR2MWhONGUyQ2kvS0NFTUdCdG15RjY0WDZVNGNZenVl?=
 =?utf-8?B?dGNzMDJGeXE1VjQxTTJZcURxL3NnT01ZSm1YLzVEVDV5N0J1cmo1ZHlFTzQ0?=
 =?utf-8?B?d2ZHdk12UE1BQmhVOFloSXo5czUwTTgrNmU0bVg5dWFwWXZlSThnNEczSUhP?=
 =?utf-8?B?ODArY1NSVFBsUzRPZEZpMS9oOFZ0TllzdkZpTlp5c01lNkxyVDJkSE00cUQx?=
 =?utf-8?B?TmpyU24rckpOTDgwemxRM1dWYndVSWFlRmExODdiL2JkcW1SRzFyR0N1dER4?=
 =?utf-8?B?ZHhRREI3Y2JzS2tBTHFLWUJnbFNCOFQxV0pCSmJSZmpBR2I4ejUxVkg3bmJC?=
 =?utf-8?B?SUo1TG9Cc2V2Q0paN29zVE56WVZHOGtPUFV0NktoQzN1WHppa3JtWDI2OWJ6?=
 =?utf-8?B?Mm1VT3hNem1rdk1GczhFaHNCeDNlMm5qMTVjZkcwa1VSVjlXMkR1dStqaUsy?=
 =?utf-8?B?YW5IMG9TRlRIU0V1Z1NNNXVxSnVJaW4yRjZ6eHg4NHNBRTJCWkkvWmh5YmtV?=
 =?utf-8?B?OHFaNmJOVlBLMlNnd3E5d2NEUEMyQkhwOVFXV1pVOU5zQ1FDSWw3UjZUSC9F?=
 =?utf-8?B?V1JwR1o2bTBlVERQaTZSVUdiYm1FVHBzMFR4NlNaRkN0NUdLaDRkSy9hdVQv?=
 =?utf-8?B?eVg2YnRSMXZCdDFGMklhaTNrNmYxZDliL2FheWw4V041SVNraGhyczZhbzQz?=
 =?utf-8?B?OUE9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf62d9bb-20a8-4824-7cf4-08dac4292c50
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 21:10:34.4553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nu2ix0feve4ILvhYbb0RtlCoNX1uBkjzRE7yHhgHiTXeC9XO98Alpg6lIHXNmQ/J8dt6vx7DAArO6ufmJ/WEDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7058
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are multi-generational drivers like mv88e6xxx which have code like
this:

int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
				struct ifreq *ifr)
{
	if (!chip->info->ptp_support)
		return -EOPNOTSUPP;

	...
}

DSA wants to deny PTP timestamping on the master if the switch supports
timestamping too. However it currently relies on the presence of the
port_hwtstamp_get() callback to determine PTP capability, and this
clearly does not work in that case (method is present but returns
-EOPNOTSUPP).

We should not deny PTP on the DSA master for those switches which truly
do not support hardware timestamping.

Create a dsa_port_supports_hwtstamp() method which actually probes for
support by calling port_hwtstamp_get() and seeing whether that returned
-EOPNOTSUPP or not.

Fixes: f685e609a301 ("net: dsa: Deny PTP on master if switch supports it")
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20221110124345.3901389-1-festevam@gmail.com/
Reported-by: Fabio Estevam <festevam@gmail.com>
Reported-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  1 +
 net/dsa/master.c   |  3 +--
 net/dsa/port.c     | 16 ++++++++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6e65c7ffd6f3..71e9707d11d4 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -210,6 +210,7 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 extern struct rtnl_link_ops dsa_link_ops __read_mostly;
 
 /* port.c */
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr);
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 40367ab41cf8..421de166515f 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -204,8 +204,7 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		 * switch in the tree that is PTP capable.
 		 */
 		list_for_each_entry(dp, &dst->ports, list)
-			if (dp->ds->ops->port_hwtstamp_get ||
-			    dp->ds->ops->port_hwtstamp_set)
+			if (dsa_port_supports_hwtstamp(dp, ifr))
 				return -EBUSY;
 		break;
 	}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 208168276995..750fe68d9b2a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -110,6 +110,22 @@ static bool dsa_port_can_configure_learning(struct dsa_port *dp)
 	return !err;
 }
 
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr)
+{
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	if (!ds->ops->port_hwtstamp_get || !ds->ops->port_hwtstamp_set)
+		return false;
+
+	/* "See through" shim implementations of the "get" method.
+	 * This will clobber the ifreq structure, but we will either return an
+	 * error, or the master will overwrite it with proper values.
+	 */
+	err = ds->ops->port_hwtstamp_get(ds, dp->index, ifr);
+	return err != -EOPNOTSUPP;
+}
+
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 {
 	struct dsa_switch *ds = dp->ds;
-- 
2.34.1

