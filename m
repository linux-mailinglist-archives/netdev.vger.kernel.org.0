Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E6D49DBE6
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 08:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbiA0HuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 02:50:17 -0500
Received: from mail-dm6nam10on2133.outbound.protection.outlook.com ([40.107.93.133]:13153
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229949AbiA0HuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 02:50:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qbu0+ig/5gog5gN8Sbe5bP4U8hdsHNeqPguHCeorW9enLLgorS2ufsy9p9nT0d7TmFGNOih3J9kHWB5uq2GA8V6pcyz/OtUA6/wOZwDFBuJ3GXPW+JZ1qUw5g1AmWPohVFoU4DVdZDqIqg7ZQpFLe5i56jP3aobiKtgWI+0Rdi2wxjRGCEJBVjbWHng1nogxL/tec24RwjWOO9PRbl3EXETgq36flmQzbd44K3YWKT8mz1TR/LOnh2X7xKI6gI8vLTzqGT97+rIsSpFimNFisFIAL1HhcRJYBCKdt4Vj6kh/FWu/y5eCWYgnV7MNI3BGuO4kc7ozwecC0AwDQ2PN+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8iMB/tKXYAzchAuHpJxAZjpz3NDUudrGkTXPiq2oa4=;
 b=SwQRBmIMf3q/BmV1VEAmS3n0fF1RQIsOrmhZ860+sRhUZWj5UW8Glrk4jYXCZgHl//szJgMhxRbgWvHzk8DdiDy5zVj3OLNMRCJtFNhZXlskXIJDH4h/8DJzm6myfMQ7GiOPdiWWrFX/7QIOafwdZWDWGKzFcJIPQ0vvJsLx6FBhRYuKlI28VpYei5/ns/oETXM4OrhL88R3N6ovsh/eaDGz0d/RiEXtnIyl5VUoTrEZYZuSHcSlF/FLK3mRXMd+6sRuxj0qAT/EcnKAkSmMF9N8F+nOzCljce9o1WFGoilGY6r8Jb8i5nO9JcN6bJTAITjvye3/rueVv4q2x9Hh8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=pica8com.onmicrosoft.com; s=selector2-pica8com-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8iMB/tKXYAzchAuHpJxAZjpz3NDUudrGkTXPiq2oa4=;
 b=ZeZ0gbiYQnKHbRWFW6rWC9oIK9zImLsFk89Gi40P7WEzBdzJtd+usYcDaLT+8v9+bs+PEfuOQ+PqD6NDnM9RdcrcQAP+v8hzBp0spgdfYhvPxms4l+2zp1IL/5byyzSMihpcvcsEiiGU/neFqA1HLlLuAdukGFYjbHSNrPaqEwg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=pica8.com;
Received: from DM6PR12MB4601.namprd12.prod.outlook.com (2603:10b6:5:163::16)
 by PH7PR12MB5620.namprd12.prod.outlook.com (2603:10b6:510:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 07:50:14 +0000
Received: from DM6PR12MB4601.namprd12.prod.outlook.com
 ([fe80::b4e3:1aaf:91f5:7cb7]) by DM6PR12MB4601.namprd12.prod.outlook.com
 ([fe80::b4e3:1aaf:91f5:7cb7%3]) with mapi id 15.20.4930.017; Thu, 27 Jan 2022
 07:50:14 +0000
From:   Tim Yi <tim.yi@pica8.com>
To:     nikolay@nvidia.com
Cc:     roopa@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        Tim Yi <tim.yi@pica8.com>
Subject: [PATCH] net: bridge: vlan: fix memory leak in __allowed_ingress
Date:   Thu, 27 Jan 2022 15:49:53 +0800
Message-Id: <20220127074953.12632-1-tim.yi@pica8.com>
X-Mailer: git-send-email 2.28.0.618.g9bc233ae1c
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0062.apcprd03.prod.outlook.com
 (2603:1096:202:17::32) To DM6PR12MB4601.namprd12.prod.outlook.com
 (2603:10b6:5:163::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27d336a9-232a-492c-4ed3-08d9e169a6bc
X-MS-TrafficTypeDiagnostic: PH7PR12MB5620:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB562033DC8D740E3108419875D8219@PH7PR12MB5620.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yI4dV0o1kGf0+AxV5xqU77z7OtnOiXHRypQ9icxwNZt8dQXz3jtVV4YzxtvCrr91utOl2buMNSTamNzoTWRZ362nLRIvU2DIAAJYNdhOwRPAQ4FmH+8+4mRTnXQIc80+t9g/z7Wpxb3HePEDdui+pOy8pFbz+EHOM3hmT/46VTjDvjkponGQyYybWjUwYVZmfO/9/9K/+gd3iwnWCqZ5wjW0i67w1wtfBQiLPMpkRmmasmpAL/YBzHDJz4Z9Xg2px7T6rYuZN3qDka0A8YrrUpgYtMSw9EWmXx9sANNoR+5oJptHjNx6lmxKJZroQdSCMTfvUu1d4L+XtPC61V5emJJdzEWueXAXAj3M0zT1mLtRQcuaQqYoPNtPClxK1YGHOmLE2x4c6zteVTNyaRCvMEa/QRrVXjPwYCFoBn8wA/DUc5274C+k4Myepwrox3km8h5PeDKMeSxqB0kfYcNFNbAb9Qq9Rdg3nmVHBj3bAPzt/jNqlTtJCEmFKZeikzrtLwGQ90Hir1QYmkspS0rWCN1MnPSjcHzkJF08DQ0o6MYoze+N4VTi2uGt28uw9dpZ0MXNyt72vP1Spzvh09KrwhKFGMjn31sKWEtg1Wz+dJIy2cX71p9B/tQORMA0TjDUQ0PylexpORn9WsQRvZQu5dDYK8rkJaDrFy+eMlrDJMRr4J8JhqRzNuFEkyQmuoPGPCxn1PAS7tNVQUJtT12zmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(136003)(39830400003)(366004)(346002)(376002)(508600001)(52116002)(38350700002)(107886003)(38100700002)(44832011)(2906002)(86362001)(5660300002)(6666004)(6506007)(6512007)(4326008)(66946007)(66476007)(316002)(1076003)(36756003)(26005)(6916009)(8676002)(6486002)(8936002)(66556008)(2616005)(186003)(83380400001)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o8YMUNVYCE2UFVgePjjF5VEok1yqxRwhqjGOJUMDK1mN8U8kBA7RuKB1fIBU?=
 =?us-ascii?Q?OLBbfgp6jH1q5NadKIqhA88n2Pmc3ZYJDAGiXEcAcAP+jt6coQKyE2stWpH/?=
 =?us-ascii?Q?VxjHmPu8hNBA98x8pp2B/cszc1MVnNtDieZLzkS7SQiJ40cCGWCfgPOSbjKH?=
 =?us-ascii?Q?z+Q5rsp2WoOmS5t25VAdrF62hRbAZaZ55oDt0PNby3XidrxxIhf4Wcg7s4ob?=
 =?us-ascii?Q?u/uNZU14ZexQh1pl9QaNCc6bXvYd/mclj768ICQJYV4MJqpqg2//QIXWU+tT?=
 =?us-ascii?Q?ftK+4AiwDqVUeKFQ3A9VkHKr4/z8GTUnQr09j+uZ98Klt4eHgPFEHIBrimQq?=
 =?us-ascii?Q?TUZrRhMqqTe/yN2u7W53nmzCzrAJy7olrQRoXmxKOvLjv1i4befINQojdku1?=
 =?us-ascii?Q?7DEY8GZCp0jehV4ZTV9O459N/w+hwAVEf5EyiMWnLG9+wNAvxv4WS09o8LIS?=
 =?us-ascii?Q?/HexhAtilkagzHopU+ykl9BXNV3bx35SSpyFDyWHlWf+ZCTmkYEkcjz2wFB0?=
 =?us-ascii?Q?kf2eV3eMvA1aHOblHfYqg9GOFydxwRslPr+A+kk0bDa/X5xYAsMLQCP0sTO/?=
 =?us-ascii?Q?98IRsMSUEyl56zoskE+PUzRPrQmMGfiCI/vdYMyYK/5Jez37L/E+22U9kHum?=
 =?us-ascii?Q?4uQRAx3i2bnchsBq5rJ7om31kS64SY/rcXsnM8HOMI3Py24VMKvp+jhI2bAJ?=
 =?us-ascii?Q?WrbTSCQAt/qWiuk62gvB1GfhjeNyxRaWnP4YClhFdrOTlLN9iexgmBvG3T3J?=
 =?us-ascii?Q?h1nCXxtx7naMKL38aL/xMA7WezGAxjCXeEcMCDnvXGVYHIkqB0Io9Uw9nUOD?=
 =?us-ascii?Q?3P7hIcEOSOxOkQtDWusNxhMd6DgGLlTFGPNRKGnugL7KY8RboRtBtN0V+/sR?=
 =?us-ascii?Q?9InLAa5KJ8vxt3Y6NfmJFCvi6RN6EVRv3dV3/tFZwGz3haiAvumbNvsU9yX2?=
 =?us-ascii?Q?dEVUKaFtcXan6wT6s9541PwHfa5i4wG/Ixkw5w7tB+5U1DTSdHXiDXGGUA7A?=
 =?us-ascii?Q?n/wTYOPWEzMg2QOXfrHVbFBpLfDmDfDtbPh/SABjE6wjJV6dokZ4e7nRp2Yx?=
 =?us-ascii?Q?zQtf+WC/vbnRRVrR0DJSWgCEWCGG9/a0ZY5r2KlfvGOVyRe93Vvlu0sa5FIX?=
 =?us-ascii?Q?mq3EjNEbVI+ot9/BoKFQbo0GDIuHNyAI8OJSEuhTc1W5BUe/EOChwxeGv+8x?=
 =?us-ascii?Q?Ig3r21zij6riB+uifMSGZs79uUqq8ytriwZUUjhxpFFtvoaYQJKn8SzYW6sh?=
 =?us-ascii?Q?jMNzecTh/ne2t/a0wOWgmE9Y6j2e5oRWcZlXzGQKViiXZnOG1nyRZ9cDtnWU?=
 =?us-ascii?Q?YIw0CuFNKhP5Klxlk3pO4O/nVXcUZHnv9tHnjUt9qBn0Zt+5lAvT3KBTrQqO?=
 =?us-ascii?Q?GvGFWNferVuTGycBU8rr9G/zwudDveynrCyKxh0xkN7QBXew5JC35UNg7E9j?=
 =?us-ascii?Q?tFKpFMUY8Q+r2BEFIs4yX5f4UW/l+ZMnh/WwuDt56xn805KIfCdGZYjH0aA/?=
 =?us-ascii?Q?63RS7sshPy9HxBGBv+5glx6xpy3B63l5yvmb2pR8npmcExm32n4/b5p7llce?=
 =?us-ascii?Q?NYspvdIKgYXkD9ytemf+eg2bMekF4mNgl3IwjhpBe0H7DKmIh/YE71fg/gZl?=
 =?us-ascii?Q?tz1rL1QL27+4e2JpLWBH+ME=3D?=
X-OriginatorOrg: pica8.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d336a9-232a-492c-4ed3-08d9e169a6bc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 07:50:13.8716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1649697f-e494-4b71-8227-3f383d0979ad
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uigfEnUIAkWVPiQj8QDQCKMm2rTUz5kxegXPG/WtJHxzIWgqXnV3jCHQsREsK4RGzjnnB1f+Vr30A8et64BzdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5620
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using per-vlan state, if vlan snooping and stats are disabled,
untagged or priority-tagged ingress frame will go to check pvid state.
If the port state is forwarding and the pvid state is not
learning/forwarding, untagged or priority-tagged frame will be dropped
but skb memory is not freed.
Should free skb when __allowed_ingress returns false.

Signed-off-by: Tim Yi <tim.yi@pica8.com>
---
 net/bridge/br_vlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 84ba456a78cc..88c4297cddee 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -560,10 +560,10 @@ static bool __allowed_ingress(const struct net_bridge *br,
 		    !br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
 			if (*state == BR_STATE_FORWARDING) {
 				*state = br_vlan_get_pvid_state(vg);
-				return br_vlan_state_allowed(*state, true);
-			} else {
-				return true;
+				if (!br_vlan_state_allowed(*state, true))
+					goto drop;
 			}
+			return true;
 		}
 	}
 	v = br_vlan_find(vg, *vid);
-- 
2.28.0.618.g9bc233ae1c

