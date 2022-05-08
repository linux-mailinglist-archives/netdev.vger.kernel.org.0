Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C68051EE87
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiEHPbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbiEHPb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:31:27 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10053.outbound.protection.outlook.com [40.107.1.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A05AC0D
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:27:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSvZrKurQaTgKQPkQ5jN1sIWgXWmLpQ8kpAmVX8jcbLAd8ZKPKt4KbtF26kWQHV3NY+kFIP5yIc9i8QLu2Yywf6DeygiUiwxtwNf97WTEx18W5C8pdd4zOCDuB3bBZX+H5bK1vhom/n7TomyNTXd67B4JNGiCVYfuCQ6aFCuTYXhPd4mIslooOQR3+gvOl30ylhNO7/PIw0j7jtoF7LGAohotNKnfKT+ILqtD7AgMP9tWPE3AwN3O5p6lscfBlrYgQ2gJoRM29ANjzKMUV/xYmxmFX7JLDiNPbO4CC1tgC76+DND/a/A1WoV1n5vyG8dGiHd6Je2xiZfX4jSQ1O+dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0jKayjEB9RCJ0Ke0DzWBk3Uq0Vi/Q8bWe1EJJPzSKc=;
 b=OHUof/GdsLJfqZGK4A0Anan6o7mZMoBmZqgTGKQJ2pbPaAWa3nvBTNToegY11zlyB45JyCXT4cy0Qg4lDzE8EHkn+ZaPAlYuzhzMtveZR1NVIQ51tkGf/q6tVSoy1ROGKMhLoIOkVmKa+miIaU9cWP001+FH/XMKBp8cRr6Wftrca308DylDgaNtCYOM6oGkmgHTU9dzPqYdG3PCuDEOEJaEhfyKp5K8ZR/t0GmghvCBZSazdvChSOZa+Ab+PYUUhbRMuFt519qNN2sFYOq/DE4Bsz5PSzocmo9LZ5pnL/3Bea4ifO3NCw3QadxQWU8nNk2+5upxBqlKK2ltKMIrhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z0jKayjEB9RCJ0Ke0DzWBk3Uq0Vi/Q8bWe1EJJPzSKc=;
 b=APKMTVCIir8sXSFW3J4b5xfDkf8a5d1ItRHKWpg1Qz4jfiZjEdnaZqX2O8lnq/xptx6I8kBKbKV2/wc0MV6FWds8dv0Ay48oBXZOMb3QVG8jJVvCT+V0fB4YjQwKiyFHdJkYdJgllsP+fQXA65Ys7IbG4LxcldcnZBubApgXogQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:27:33 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Sun, 8 May 2022
 15:27:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [RFC PATCH net-next 4/8] net: dsa: introduce the dsa_cpu_ports() helper
Date:   Sun,  8 May 2022 18:27:09 +0300
Message-Id: <20220508152713.2704662-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
References: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0205.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::30) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfab62f4-ae65-4fba-012e-08da31074603
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2806518833A873BD556D84F0E0C79@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a5ozmiYfGFFTa6C6AI10UiaTp4yTB+Gc4EAxZ3cVTTYc/faUQWGZyCfoojY3yYY27x+6zz8SwB14R6OFRdK/Ob056h6qFtpag0+YY4zz4BeSL3EL12SU8YNmdYbcWeAVLlcOyo174aUHCM6l4p9g8j75m4nQ7nEoqBMVj6XAAuw+RTmvc8NtA2fxoWMt7RUgwcJCAgQDYw0N5Rf8zYOt8NicfjcB89Fz0zYMu79BfOtx0nMAO5qucE0q0L9ffb0d7OAYi5jQKWs5tGoMw+czmv3ztbd3kuEGeI+Jf/8AzxW3pjVgXppS7ISnRa3pY7hkvOb34ovtPlXUMKUwrQctPAsBz7qn/itmS//SywhMoBPuyAhePumlB7B3lL8RcehdxGuCyD6IpKl2e8aFOBeZMWWxtkoM4etVGJ8HtUvk5j7WTkA/dQgCd3Nw3tTbb7IIwkrUR600oeB62flhenaM1Cl5Lo1mrekX4YMr1oGfxjy8IbrVhGhR1UdHI0sOQ0XtSIuOjq2Mw3GW7pYfqfNsGclw8VhBF3uZXTLHluyfJf8P5vIJnjYwRcin2H3fBnGa8+5H572p3+0KsO7aZ0MOL6j8uWUzj7sA8jrhbkcepNIuKgTJBzjqNRwfINOaNYkMCDi22/E0aKqJ9z0eel6YpqGuX5+0P2LTAtctgy58/tdeszeTjWHWCQdWg5xnBwCc1iQMkLEBY9MvqE2jk67BBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6666004)(6506007)(36756003)(186003)(508600001)(6486002)(2906002)(38100700002)(38350700002)(5660300002)(4744005)(6916009)(66946007)(26005)(1076003)(44832011)(7416002)(8936002)(54906003)(66556008)(8676002)(4326008)(86362001)(66476007)(6512007)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AU9yhPUHPIfHcm1Wc2co+oZF0a6nmPr/ju1QlyigpCwfLcP+fsdAKA47YBfl?=
 =?us-ascii?Q?FyHiR7oNd9ymeUMYjM0BUlP75MUNo6tRXX/sUF9FVz1nIGOOQ5CcdHxKnGqh?=
 =?us-ascii?Q?7DbCoJKl0gVcVGkCVoqfLXnJZB72eA5GN3YfjLN9bdgT3570IcOIwUbHdvI0?=
 =?us-ascii?Q?BxM91J7YKHDM9Xeqe0+iZjM8n4Qzaa3BxIte1ZbsjUUTypgXUHvwajOVq2lx?=
 =?us-ascii?Q?qgHCKBOUPAgrX5ZygGiR1X+uBCza6h31RpJqEbQvZypBdgpOwwl//zzrpKtj?=
 =?us-ascii?Q?NwkeRFtIlskI4LS+NKo9IgaWtsPSmb/pgrh/FMl5jEIHJLbt23l1/0JLKUNx?=
 =?us-ascii?Q?9c3sTVI+4sDEkoqs5P2ceW+PGiUUDseM9WpH2+jML4m5k6cuWPz/1o066tfn?=
 =?us-ascii?Q?lw9ftirFNSbPtTfmjeem0Chg2MnVNsf9gqBLz5ASN5jagjTAIgMLE1sHAKiq?=
 =?us-ascii?Q?8Lw3i4L3O0Nhz5hp3z3hUpIwn4Y+xSxpnTJrHWHtzjttm5viz89sIpBpxnTW?=
 =?us-ascii?Q?4C2MZWRTKqkx820K2OGo6cTCjPlFtRPR5kHgxAMKM7mKYTYXpCeW1YsNA7TH?=
 =?us-ascii?Q?WkcY9OD8Zh3T1j7gJF2gEmYEucXOLylF9JGUbUxUaeyAqgaOMdnzFrSsf4f+?=
 =?us-ascii?Q?rSRF2JDOivyoVTkqE3Y+Jd0xHWvKazZYnwUe6FHl3b8Ny17CFcCWuhIPNBg8?=
 =?us-ascii?Q?SWPvGMGRO5DNwxrRQ7AWN5//C/mW02TqcznfBFKWUOcoPspswlb3v9YAOdG0?=
 =?us-ascii?Q?GJ5LiVU+1fMNhwtQz4jC2UBlXyol6uKMCXanuQf5Bs5sK8zaLsH5pflogioX?=
 =?us-ascii?Q?z9BqxVR9+tQkQ4qqCjmse+l70vkciuzDSiiiCXlBRlbog5ASX8mokcBTvMSW?=
 =?us-ascii?Q?y+LTk4Alp7NFDm8NIkmCjWyznTG9nykV9qlQN6s1Xk2Vxs5lXBvw+ExWTMeG?=
 =?us-ascii?Q?mlLmqBS3pwD9EQzwSqzwJQWTSdDhmM0xQnF8vIS7JLLW6Oh5pLtpPB1W8Lnx?=
 =?us-ascii?Q?+BSFlg1tf85DbK4htzcuYpJky5Dv0tVfNvl1SfApO6ljSDml68yoYYHb2g+e?=
 =?us-ascii?Q?gt/avO0ZvPj6hA5HVDPHB2DshAuyL2jJ85Fp8EqZZg8MN8hQJSCiUqoC0LoM?=
 =?us-ascii?Q?kljgJuGorgjGVYVyy8Du8ywovtZzeKDWbY0hrdpyXcAS9emTJHhJABN0p9nN?=
 =?us-ascii?Q?JZ7ZR/NXw7AnGEZgZefZKmtatws6aKjK+rNFXNYTSpq7KondKlAQJfCRSVcY?=
 =?us-ascii?Q?8ZBUFSPOfRXSvvmIob8am5UeUPBec735djO5IjhhghgQ5GTtBb1pE2c3hQwU?=
 =?us-ascii?Q?jDeEqNmcbjC9tKYrjFhhVU6JioWBs7BPmBJdJWuZInJi972axMAXHeWZiG0V?=
 =?us-ascii?Q?vnxkQ9rXdoHUASEdJSbj+OdzSeQer5krAguvXbnfXstZ/g95HnuT8g4LjPkk?=
 =?us-ascii?Q?lKo61Agepc4W1NJRvVUTMUFUL7cEpsL5RUCxWR1kvOECcnM0yUE8wfgmkyog?=
 =?us-ascii?Q?CTtf9a+vdEARQUcNMFIe31opEQlM4FQrBOSlZ5ltUsa8arBoM/rljR/iYCUy?=
 =?us-ascii?Q?eDj7fym+ekb981TpIY9uDrG2rOFwwaxR71cF0rq2L0dEEQYj84rYx/pbO9gh?=
 =?us-ascii?Q?vA6qQUy5uPpjUMTNQ3MOKM0VgHvDTK0Nfyy4UG3XfxwPGUMu9WQ/iVGCyIge?=
 =?us-ascii?Q?ngNNLam/wxtK9n4l8PFDNR3dWC22qgbRNX9rbOpyi+lOHlSy4sPnZ67nuFPz?=
 =?us-ascii?Q?qbfTC60XpdCL8NwLRkWByNHnhwgXpWs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfab62f4-ae65-4fba-012e-08da31074603
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:27:33.7043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JOV801uMK7MSQDFZZC5wKZ91sOqmbOm5jiMAS5qqCPYRWh+8GG+L96bKgLwxGq1iWsueC8AMnCBdY1aQWlyIqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to dsa_user_ports() which retrieves a port mask of all user
ports, introduce dsa_cpu_ports() which retrieves the mask of all CPU
ports of a switch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index efd33956df37..76257a9f0e1b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -590,6 +590,17 @@ static inline u32 dsa_user_ports(struct dsa_switch *ds)
 	return mask;
 }
 
+static inline u32 dsa_cpu_ports(struct dsa_switch *ds)
+{
+	struct dsa_port *cpu_dp;
+	u32 mask = 0;
+
+	dsa_switch_for_each_cpu_port(cpu_dp, ds)
+		mask |= BIT(cpu_dp->index);
+
+	return mask;
+}
+
 /* Return the local port used to reach an arbitrary switch device */
 static inline unsigned int dsa_routing_port(struct dsa_switch *ds, int device)
 {
-- 
2.25.1

