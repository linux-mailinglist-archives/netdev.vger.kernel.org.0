Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1D64681A9
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383972AbhLDBEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:04:36 -0500
Received: from mail-dm6nam11on2113.outbound.protection.outlook.com ([40.107.223.113]:36640
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1383945AbhLDBEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 20:04:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L++YLKdmLH5gxSRNEcog8PNs3u34AJSxbdmJvOrPhpVI87HQRw0u3mIIWYBKcpt7nQAjlUjKIX9ad2L01uR3NIMRs4MncgA+oWETeTMAGdUS39G8UQ4zMsHrSLQa1SevW3uujmTePUNAVKd6kI/wxNK5OP6o+lC8F2f3tEtCqzf8pLGWV5wBdIwhdaJ7J73J6NvaK0D3StXSkpIXM2c2XAGy7kovXu82HAlpWScDAXlQUBUe+jcXKkcperHOmVbMgavRg5AsQ/H6WxgDhrCKjo9+wWws1AMGczGbBpWz1jmS9Ze9nYWNDlc/26EaZ3L2luA3Qw5ear8IQDDQis2UrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6E97xQpLHdXc4y/GuYyoYK2mXx9cdmEpPZhyBlKjk8=;
 b=TCuAAaAk/REwhvTIKQM0bDejgmrphORDL6dT44rhkOjNXQ08FwPf1QcTDV4RqCeUH5FoNN3lN56Bp5v5PG7f91MbKTVmwEdFcGx3Al4SnrDYm/+AqFW5Y7iAuvEVs55EVw/d4RRoB/lOV6NyziceBcYrpLa3MtSR3BnkoFqlnmBG+NRmBwl1PGJnCBXja+yTtbWIkPtpVyYsHtTiEywlo4W9a9E8xW0Ejw6TUjp8mtlNDP4R9CKsW26FZ6kENfC7fGxmUF+H6hlDZgBNA2e9I1j9C6n2lTgivnAeyfVLjdNyuxf8xq08gox+dPxJuLxlAJPImTa+WgtegQFu862dNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6E97xQpLHdXc4y/GuYyoYK2mXx9cdmEpPZhyBlKjk8=;
 b=0Kf2hEHSbOg/6TRhKXXYSJ7R4yXQo7qQQkvDbisF0qjUKiPuk/UOBcUG2TbftnTSHfyGrJRc9YzFZ/4Zf4LZvBeUeBZIumD4O5D4gMwMk7fnDuuUURx784d20vvzbaPmCRKGdhoMBJQz3uIImtmx4dJ08+DLmgpJJf4c+sOnlXA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Sat, 4 Dec
 2021 01:01:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.028; Sat, 4 Dec 2021
 01:01:03 +0000
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
Subject: [PATCH v2 net-next 2/5] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
Date:   Fri,  3 Dec 2021 17:00:47 -0800
Message-Id: <20211204010050.1013718-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204010050.1013718-1-colin.foster@in-advantage.com>
References: <20211204010050.1013718-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:300:4b::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR02CA0020.namprd02.prod.outlook.com (2603:10b6:300:4b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sat, 4 Dec 2021 01:01:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c82dc95-0883-41c8-cf70-08d9b6c18b91
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:
X-Microsoft-Antispam-PRVS: <MW4PR10MB57012D78BDD0D23DA8027B11A46B9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8VD0J3BVjtm0PMsko4ml7UFtt/XREnV8Z6TjJalaSSmc7lxP39UOz3Ai86d4Ob4LBbeO8rz1Q2ILKkzNAbVr73IzzgowvUSwUrOi+Ta8Zmv4IfNhu3C84fRPQcLpdTGZAOjSFamI1CF20SUtRLGard941V96wMBMvXxUuh6SPAFS1bgSZbDLkWFQMUwWmbH6rAIJr7w7RgZIF8TraV207gvqmnOCupBLZJ5ugbFC6zzB/W12514+ryqvazA1wqjq4c1nY4rr/EOUo5Fzx8FdGCgEhuWj8mFiDHUrwqPbWoIqNsezjFbJEcH/pO9KKaUdgEXnXV02/Wnn7HxyCEdCz6Y83LBpY5Lvvo7oUubttosm+Dk9OLoM0GYWB606yVxfjKCtdmgsdTtpuzcbv3r9lm1GDQWACvYG5SITE3+cmE1j1rU8L1s0/ob/ly3Fa6RNhovZ8kwCH2FF6NHGHGmth2BnFj0+Y6IUbAihsPJiwUri5sNBGd/cBaSo9ZtT9XdhrIxlya9BzZkwuhr2AwqfbWG99lDss7c5+AkBUrckcOVN7XYSg7lie687iccHi2D+lZ3sAJNPwZ/KDred+hnfjAV8x+9KHhOY9sCt/luBtMhxZ/psb93RipnIjYWKzRM96vvMoQ2817xT3y+1Elv2RLA4K4YFxW/D227K93sCzpwFLZh/FHpuecuVvDU3xJvhn/Db0LEaxm4hFvLZdOXCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39830400003)(376002)(346002)(5660300002)(7416002)(4744005)(6666004)(83380400001)(6512007)(2906002)(8936002)(66946007)(6486002)(66556008)(1076003)(66476007)(316002)(186003)(8676002)(4326008)(54906003)(36756003)(86362001)(38100700002)(44832011)(956004)(52116002)(508600001)(26005)(38350700002)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+icTlKLnYIHQ/Nt1VrPu9US7AwQOJhWH6xHEDgF4zK6yxA7FKqrQfYNfHAwP?=
 =?us-ascii?Q?1iD65AJ57+B6kqKFJAjpahT11t6seLUtUJg8x5j3o9Mn9wpG8IlJJ5/1lswB?=
 =?us-ascii?Q?iVZ1/44nKwgkHHW2BjpvI2GHKH7chALEH/8J2yqp6CVf2Fcnbp+sQUEmo18n?=
 =?us-ascii?Q?/jklWENqNKH2StULE2mEuYkYaT9g7xpaiOuREP1iNmwyWSEhIpGxo57WQAVc?=
 =?us-ascii?Q?6FKogH/e0NYlvvo4Zg8q0Sf9+uveus7qq/82O/dRxJioIdd5PDeRun1lBG+z?=
 =?us-ascii?Q?OBzsf0uRQZBJA/HU8qsO1+DkiLTIUvRWabpxadu+rZKhJKDNkaRsBb8rXKFq?=
 =?us-ascii?Q?pUJD/LV9FkefUgVWE7t/sV9GQnwHHBuY0RT7Mn5yXEQ1GITU2hhZliJgExTq?=
 =?us-ascii?Q?egH729lMkD7V14/wMono5JM3FvqBI9k+53ycakSaEBymVV4CdAh9JGRaHAet?=
 =?us-ascii?Q?rfsptr6TCQsZGOPg9a5BEzXjHZai41LPsZ8MTtbFL31xlwMQ31F6kow/S16K?=
 =?us-ascii?Q?eDmxCKYzVoEhVpkl2V8X36hwIerKJq7QEp67qFaxcNPp+E8DvDT6WjiFgyPB?=
 =?us-ascii?Q?0LnQjT/HgqcOfOTilF67gXLFySw5O2EOaZzxFl2ag2qFO261XYsP8AQ69Qwe?=
 =?us-ascii?Q?yHYiPnoeN9DiCZ4VK6fJk4iEsd9I8G6z8NgMjWyfmzJZJQqWxLUX5KTN/RJ+?=
 =?us-ascii?Q?/hVa3rHmp/pYlFzYaRG6f3ApmFnXxAJqAQE2jvV/HXqhYn9ehqSMtDVG8vTm?=
 =?us-ascii?Q?6ehHSMPMbguhmnb0u/9nAU/gA1OW/cyQAatjdmL6yDzpHAPld5kH8mvozxUY?=
 =?us-ascii?Q?T7bwfssuESm43o5kiPt7KygfH107xF8F6iRyYAtkySMYJqEQn/USIg30mAKM?=
 =?us-ascii?Q?WPiy6vMf8ZdPtrWDSwS9LPThNBsc9knTgoMxjBbDBITMjCcNkRhQyidxt6Ft?=
 =?us-ascii?Q?N3fd91FsEMX/HIQ+NYidU2QkorUvHVn0l0GshiaECvfgTDz7NvVysZgnMXxO?=
 =?us-ascii?Q?7NfSSdQzCjG2D04gXjMIMURVcXt1zZPADcOZEqGESguNmGSupx4VnGK4KeVp?=
 =?us-ascii?Q?ehCVYmbcoUcrWJkAtF2AXjDREVaocoFjM3hXf2aWDS27WXnc3cmCJ3pinzxK?=
 =?us-ascii?Q?yAFQ6dK/f8rkagnE0ygmpDFUNiVm34NzIjug4E86ViBwt3r2SaBD3nrOzaif?=
 =?us-ascii?Q?WapT96OaOSvd0QBoodf3InH8RIHUgOE77MFALFXFLqMnCW7+8Iw4n/uqNhZi?=
 =?us-ascii?Q?qD0sfH8W7dLcSj0TctMtbVUZAb8DfZ4OM5qWLGO7+hVyYX3EzsGJaj2MYEry?=
 =?us-ascii?Q?wvhotmyL3Z6GMT10xBt8QhZ2xQgapUbTkCLSe9WwPjWd8DLdOiZAV/xKN6Tv?=
 =?us-ascii?Q?oSj8L9m/PPXvYGwiem4lNzGL4Tmbl0PG+MXDgADUPKSEKJ28brWIRwr5ugof?=
 =?us-ascii?Q?mMTczK+zoEfu4ZCK+H2ysPHcAvrUPjmjuF3jrm48bxFaWMxi1P+hlYPZbIU7?=
 =?us-ascii?Q?8PfEBGZnICda+qwwjnR4Su1GUBSDNfJjR9dYVA8TIY8GByKtuqQTUW+dPCqp?=
 =?us-ascii?Q?/Y9IzVcXW2R5EAR8tgCUblK3L3TRJWwWcINc0LutPtVV+iVZvzpuXAdI02b1?=
 =?us-ascii?Q?1u5YG+si2NZSxw/izr4/R/1h9hnneE+QkQW2PprAuQdVEjqVxGHhbng5D9At?=
 =?us-ascii?Q?FBP3tg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c82dc95-0883-41c8-cf70-08d9b6c18b91
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 01:01:03.7787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l8G0FSAJCz7yTJja5bLQGr3jdZJ+UcbcUzje/9Eq7TjJAVZyfkpRAZ3O3gnCgCAKNxbzIgEiLs4cVc+FxqR+YR8u/hIaOAwZqCbl4rf/1aU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing felix devices all have an initialized pcs array. Future devices
might not, so running a NULL check on the array before dereferencing it
will allow those future drivers to not crash at this point

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
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

