Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B70246C138
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 18:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbhLGREU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 12:04:20 -0500
Received: from mail-bn8nam08on2122.outbound.protection.outlook.com ([40.107.100.122]:58464
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239681AbhLGREQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 12:04:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhjennag0QbhP/YZkR1KCjU8DPmGJ63dItvQpF/ZHVWO+ezxUbxYQii87Tqq5MLp6KcaFjOD3LLL6+dwBT+4Batuv+kOJ+7Uq+l16W7gNVCsjudgsJQTk3VpgbwzGEPcvhsOpAqGBfBMUkPlT+A/IxI4MZ0bXKtoDDx0u3OgoQ3gYj7LSZCzjhlu2bi5DznlW0RtxEgz6wu3niJGLY68c9lziwheE8PP/PgPh1XWp8z/u2rMPmBpmnBS1O8gkkECPq8sz2SnOgdBP+CSrW//KGv/z89wJKeYZYjfsYO0+EVuep0Fpcmdwq3lAgEZ5ordiMpVX59iAvXFj8vxgs6RMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHmqs7jtXlyl5vT34Rh21MJulNwRKv0aEp3a8Ind7mo=;
 b=PAIuzGHF5qZXQHcNwWiQaHumZVbqrpY5VptwKQDI5yPR8dHeix8e0wk4ZYMP/DBgNt6rBZ3eberTxNH/59MTUOhRZ/Gk4yOCyytDhpFZ4h16EN5kcldNFt8LMv2WF6HYOXqhnsCFD3mbiJIZRCCTyAZyVNXgoDcQ+UheE3ZnF4Y88sXKTGe1BC0T8T35XcNINcyiCUeujosAWNYlIaQyC8BebeEBc9hVR2pIdOqzvurkDhrdc+WoTn7lrisoQwmJMh5FhHlGDPbRjliIBofadWJRcBKrgiwyGavKKtQvi9axA1yQxF4ZgJmNEcYWH22jM5fdt4CYvjfD1gsBY7iQGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHmqs7jtXlyl5vT34Rh21MJulNwRKv0aEp3a8Ind7mo=;
 b=Q6Z+CcGXnLvN1NnaAFGZ9ugUOYNmSOTkzFIyIWEDWdPN3UmS0+5hkYFmBs/uj5/njmGSyXNYMleFHZTjy7n44wFZ3fpKfF0CHXDt+4zVMjXeV9Ht+SqH5NWdJTSr45Puc3zlUVHkGEqsykiif8mVTQI4VWjQpzfu9VrDcxWHkWA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5441.namprd10.prod.outlook.com
 (2603:10b6:5:35a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Tue, 7 Dec
 2021 17:00:42 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 17:00:42 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v5 net-next 2/4] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
Date:   Tue,  7 Dec 2021 09:00:28 -0800
Message-Id: <20211207170030.1406601-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207170030.1406601-1-colin.foster@in-advantage.com>
References: <20211207170030.1406601-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0059.namprd16.prod.outlook.com
 (2603:10b6:907:1::36) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW2PR16CA0059.namprd16.prod.outlook.com (2603:10b6:907:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 17:00:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3161152-e32e-4db6-92e1-08d9b9a31a3d
X-MS-TrafficTypeDiagnostic: CO6PR10MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB544192A963827C013E81BEB4A46E9@CO6PR10MB5441.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DCbWXIH1NNog8GMCZrEaJMomr7/Ow9AMG20LqkstV8cQww1K1ka6dqQ1/aVHpwltatiZh31JMtmS6zNfrwRK1wei0U2TrHaK2Ajy8kva/HcAofGb6OuGxLKMGDgJ5v6kWjC4gPoRreP0v9ywc9oeaaro4qs3wsgMbBm8z7V9Q5sxu2Ul9jNjQ0ogt3DHRurreKLL/bpfvaC8/21+yRetSkPprCQ9OZ9ti2dpRT1+TJpZe56mlJcTpJI0C0QbNHQHIV9bYbbKHdWun3hkEaHH8qmcS8C+OJ452R7FuueLwO6/Xu1I8L6i4vR70JdmL9OLMj4rtoudZ0SUNxmUIVQja9KTXMp4ciwzrfx5AWESfGOqe6cASwkHVzqsKV5WMfXf/i4O2cX/TiJIPth2zJ4woar2GlcZ7DCVITh3uY15SRdC0EPNreIp6PqVqOOmWOe+uRzK8qy8iATHbOuXWOjeuYbjcsX9zsV+DJTikV6trt8cp4QBXx92fxpZsuxG24x626UUAKNjSSC+u3Bzyi4k/Q5eojylyeNd41IFx1qaLpVHRbts0gd92/Q79yvqkQWdZ+cE87NS6vzIJ3uG+GegLd8sZvJyM1nylc+46+EB34N1vIETSi0tbBq/XzFLT4lhDm1v3EJ/5B1+LAf5pj/KnXbSW48bQTRYX4LMyNgQ3k/s2a5wUjbdsS4kwzq4OM7HRpCzeNl8WW7SmSknMEC7lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(39830400003)(376002)(4744005)(508600001)(316002)(7416002)(5660300002)(8936002)(8676002)(83380400001)(1076003)(54906003)(186003)(4326008)(66556008)(6512007)(66476007)(66946007)(6666004)(86362001)(36756003)(6486002)(26005)(2906002)(52116002)(44832011)(6506007)(2616005)(38350700002)(38100700002)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FRLXpGTyXne/nTmZIGfs3GQYa4WXjb+LVQl6AUwqjuWbTm8HwaqXAXcHFjtm?=
 =?us-ascii?Q?rTYa+nj610s8Uzmrk228V2SCMj77CfOXjL7s2hacE5eDXDOlx6nDmwgSZpYb?=
 =?us-ascii?Q?NvJe+ulth0VZdWZhmUqHI+OMcWxlZ/zhJQDVr3+GGE9KXw34S4e37CBu39F7?=
 =?us-ascii?Q?viOqhMQMXSK3vVvJ83dG5h/cKNB3H0YSH7Ahi3kBfKcjgsSq0BmwG6ZaZFRt?=
 =?us-ascii?Q?cQtZwIPIpxaGkioIDxgxslOzOyefRohJ7H8IL7OYFgFBidsGhWt7BuECobUV?=
 =?us-ascii?Q?T9sx3RlpG8rqEgGQzBFGiSd5FUo+HSaRhu8aSgI84D5N6hXWDGoAeYgs6cbi?=
 =?us-ascii?Q?MV8mzAZF7LFRt7skZ6O9pyYsny8EKcDiVix3z0qVSM5ejzmqUwnOFlgD7aqP?=
 =?us-ascii?Q?aaLxfMFelzbf4rqfnC3c+3Wh8LygoiEb1NF+ubAUeMx+0gNOJ3p2owlB73GZ?=
 =?us-ascii?Q?I64ETPmNi8Gte99dDoO1UwSX8rGIySSIihi0vEFeg6XGbirFjun+6arvjvtH?=
 =?us-ascii?Q?vf6KMoylqFoJI4825zJPZmrkLZYKyJsy3vWYw0lkJSPAQ7gxBkDij99JX5gW?=
 =?us-ascii?Q?FJbviyCmo6V+Q6Voi2cnH9qx91egqrMioeg8sRzF1GTZ+SyfJjGLnmpPw1+X?=
 =?us-ascii?Q?9G+ZlP03JpyrwsVhMjPHdupFR9FO+hzoIKHEiD+x6y6niTkoNl3KukTrLSG3?=
 =?us-ascii?Q?jlAo0GYLozojAEzYYwbHOkanriPblhkQSt/oXnhu/s/SjBFOXyk0MN8F0BDh?=
 =?us-ascii?Q?Hm32BQXcm9mRdvce851dClZKoKhEBtvdPWbWZu3SLrfbKtv2iTyE4VhyaQnM?=
 =?us-ascii?Q?qugmgZGdefwcVXJvCL26lluHL26k4y0A17HBOwAeBrgl7fQHin1ax1zLjT2S?=
 =?us-ascii?Q?kZq1Pt0VsY3Tn/jwkvdWxYTZRQImOHv3RNzeYRUdvdV3CtGRikE2gqHo5Mae?=
 =?us-ascii?Q?ggCDmEbnNp1BfMaUGKqR9kewTv2ft6L3bjcskqPWf2snMZrZAm9s1vlxcDUz?=
 =?us-ascii?Q?EbePClGk3SZSsYl6wFPUdogefk2SQ1gPTD1dDHfLtBFeVirA94cXEBhCM0ll?=
 =?us-ascii?Q?j8Z4oWHJ/CKvLpRrF7imxQJ7QlGm0Fnwfqy5Nrna41WaRNHLypXRgZ2E1YYp?=
 =?us-ascii?Q?PaI5qgtbcKOb4VbLr1HnMVk9YSLsZMVn0WfcdTGvmb4S9dxWIwTJ80F1WTIU?=
 =?us-ascii?Q?Ti5Si8QpRRby7r/lUiWUAVHfR5bX7e3GSVMGHb3nPFTk29PGw94Jhpm6aeIV?=
 =?us-ascii?Q?z0K1Pdza0mEj9Ml+wJkhQNnPZ93KYJ1uJoJMozzCRmtK6ApcUUKhnZggCIa9?=
 =?us-ascii?Q?UYb/z4hTkQhEyzoSdTtq2Dro/CVsT1eTspUCMcCcWpqcXC4l837F4xDoOGwR?=
 =?us-ascii?Q?ECVppOK0Nzfy0W2O9yQnj7QhcVUFVGfALIBh0WXofjtsZYWzQnFAEDmsaFW8?=
 =?us-ascii?Q?cgUqdkypEU4qLHBFfOX/BV7DsPPoqMYIrGV1pZ0MGg/eCXFsJ23IQkESuvad?=
 =?us-ascii?Q?3eBBFYpFoISJBnsEvD5Zirtbm8EPxyWWuZror9Yt/CFdi4xlklSrY5fzFz36?=
 =?us-ascii?Q?bDe4WCg2LXSTWuvjgnaYR/+lqRboe0wDZXtcE0hN3hWrLUOY1Ug0INYC6g8E?=
 =?us-ascii?Q?Vw1FjP6HkUsfX+on89rnZ5/dfc7m0wvlQPMITayJHBT9VW8Iz47CftYzOGus?=
 =?us-ascii?Q?0bYQ7w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3161152-e32e-4db6-92e1-08d9b9a31a3d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 17:00:42.3135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DjJG1GTydxn8cG4Bv1cd7/PT4zgusI+87dhb36RwE1revH1OJk/fLk8a2prN0rj6BgBeVlhtKYn4QrpxSCasSW/NN8+NJBR5B6I7IPT6yf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing felix devices all have an initialized pcs array. Future devices
might not, so running a NULL check on the array before dereferencing it
will allow those future drivers to not crash at this point

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0e102caddb73..4ead3ebe947b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -828,7 +828,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
-	if (felix->pcs[port])
+	if (felix->pcs && felix->pcs[port])
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
-- 
2.25.1

