Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101405226A5
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbiEJWJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiEJWJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:09:17 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140084.outbound.protection.outlook.com [40.107.14.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE2428B6AB
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 15:09:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6UkimhnV1RwaAUICNSguKe27RVYx6mxNcmeuE95YlDX0ZHDLRETWJztBJEji6bODRBPxmzfuqmeXOqdqTjjaYks19vH2awrSFnSrIazVXzbEtiF8KQmmNvSFdvZ8J/m6V7JFCeGGj6lFuL2Mk/ae2XQKgCEOENVn0o5DMls88/qaCqbV15hhyxRp+FBSTLwTiz5LmIEI8H8s9jKVXBofqTlR3GoB024ZFm0TrYy60t5+VQukiHaHx6yUpVFGXBM+NBSIxaGlTAt5XMfujcq4d/9VdBGntnOQiGXekGbFE62Q/TSeNpSI+Vwfi+p6B4dKHxMfG2o3lw+7gy4UHCScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CmntwOqWWVy0WbP5I6tND1NP/eqHcBJUkTj+UruJXM=;
 b=Tu6b0XHwQkCGm8P+pg2GYf8qfkyT3Zl6hgGhVtQ3jF1J1HWPiy9VjrbpG2/nb2GOB1E8aIfoHloDUEXUs2+sq50FTMK1zF5N+V/j2S3Ejmnxo+q2DBMqZn7cX2PDBlzT8fECzMt2KguACehq6ockeDfxoXJ669CI6xG7eHivhDzVfZn8RlAqFyDArc3/Yi9CI855Onbr0V/F3aofpFaC4FsY0OoPT0jYPnUhq+5fZNmvtyZDT429C8DdtbZ8XIJC2HExDir5nn6C+Z9eOIpkmffsTVMAAhgXuu57PLxElfELCg2w6nOVZYXuduVyGepUBjLez2DS8ErmtxZ9XVHXdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CmntwOqWWVy0WbP5I6tND1NP/eqHcBJUkTj+UruJXM=;
 b=OFlF26Jbw2t+ZCH1lr0pia72FRTDax8d96Zz6p0lr7axN38kX7VqPZt5GvDZdM7fW7iuqVWxzFN5Ue2lQHmEur3bc6Ni5K3mTizOgE/tsC4znE0euNJOORsl9Q4qlm+DGmsd+29+OxQe4pVhHr2ujH3p2ffClM70yQmoXItHWk8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB6068.eurprd04.prod.outlook.com (2603:10a6:208:140::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 22:09:13 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Tue, 10 May 2022
 22:09:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] selftests: forwarding: tc_actions: allow mirred egress test to run on non-offloaded h2
Date:   Wed, 11 May 2022 01:09:04 +0300
Message-Id: <20220510220904.284552-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0048.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::28) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e376e978-648d-4434-90eb-08da32d1b75d
X-MS-TrafficTypeDiagnostic: AM0PR04MB6068:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6068D6B24986D46C6D2F1F09E0C99@AM0PR04MB6068.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGO+SSYahhvNdkrmn2SFG8mk6kOIxVhFiGnA1HWzhxjcsYHhcovn9tRJo6uRzMKu0oAbp0lyMT3Tu1jn0bVqNTMCiUtzER5+DHXY5v/awrM3pEJLe6t6XHnzhO30hLAO/x4jQZLUd0n0odGN9nBOgFEKAeU6MNbpANkvgv5uAQ4cHHXvFQwqYZWcw+jhJOKikXdGCYy5k9vCTtJQVJnQo2coirwPXgXWMEMcuMLcjZb4bu/BC2FVG63XW6QOX5fgAQa/uIRWuwx99IBlxFBxtFxNhYAnZwHG4i5mpqxqx9b315Y/t9JQ4bL3gcimXLNhe9edQ3mcKNZ8VM1zjCD1WWeXBCuiqRSE8nbquBKq47wL8TxaIV5rz5AVynNnFkd/5fgPSyjhY3AJsuwGmRIElk/ai3gUGesTyrmL7dbeDtg8lZh6CcY8DN6EU6TC+h4QT5NFdW/cDTCWMolcWD7fI2j9UVrjXX+mPDEDmGDhSG8i8Jjw4eTdRUhxXpH0zcoxpCGKnhF+bQ1jdj5E6y5GrAi+xjGj03EQH2crQZ0i1M8cC319BWoJffNJwGJSod7efNEBGoY7Lu7LWLY803Pz5tI+egSqYmxf6ghLwoCEq0aMP0OP10g3pknJjcx5bTyeGw93+HtBNwNYw63Z+AAQnB4w4fM1tlNxKZObLPoznwG7elueApS83OFXgbu3fyexaiAv1lz6WaNc4VMf9WNo6Qj/uUOPIPjsJ2Vaav3lLcg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(2616005)(54906003)(6916009)(8936002)(44832011)(2906002)(36756003)(83380400001)(66556008)(316002)(186003)(5660300002)(1076003)(38350700002)(26005)(6512007)(6506007)(52116002)(4326008)(6666004)(8676002)(508600001)(66476007)(6486002)(38100700002)(66946007)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W+kwxu/K0sC1/I6DMoJg8TXWjfukXbThtUfHnwVVQyLjGDXM/P+dnCeFD1BI?=
 =?us-ascii?Q?zyYFnS8t0DnwbxOlM4x3cNBniRTkhujR0fl88cik4+kwS0j9EN2Lne4aS/Ks?=
 =?us-ascii?Q?yREbDU4EIN+9HFgHpFcJl3e/U2Ft+wKJdzV0O27yfHWHGQzhrow3MkktKHJo?=
 =?us-ascii?Q?FNQmiaEH6Yn8Pn94eBU+958a5blj9wfhj/IJEwtC7e1oTqaijzh2sStZ7PiP?=
 =?us-ascii?Q?jIrpQy2AtpePOPWK3W5rl3whBNEbFkkydHvlVvyaYpaDGilkHmKamByEUzjX?=
 =?us-ascii?Q?qswO2GLmhPe9d0Qo9eR2AGF08rgNhrL0vSMQhiCPo1AKRF3Ys+fB7GR+nnMe?=
 =?us-ascii?Q?VA8uuJzYp+dhw6FzdwLh4tfYeaFi30tCkxG+xMU2DFq5Ktn53h5pRTWrNLiu?=
 =?us-ascii?Q?v7wnzH2IW7D3HGxO/hsgxumiirUWl0oU/Kh+EX0kq0611++21hciaUdEVFze?=
 =?us-ascii?Q?Q5MWohJ04KtSbOTsYo9aGnRD96fAvjRWfOVIVe9eLdJEw1qg1HK0wvgvSb0W?=
 =?us-ascii?Q?0ZzHeONKkyLqOKFljIuxSiN0WcE75arhUxF6of7o7L7QFWf73oPjFSIfoTga?=
 =?us-ascii?Q?fsAeTgbNdilnLoMA4WqMy/VmaHwcz3FOxK/bcVaRqk6UtEZ8dEjUYAtOKIgA?=
 =?us-ascii?Q?VjptV+etxdzsGPstdfLDm0nhKdOBEt4t0IgpS1MqCMoae0oqaeak7aNE6CSF?=
 =?us-ascii?Q?xjfmY0pZoWlP8oLyS1PeBA5vVhdai1xzFy8Q9Z77kIhI+NAKweSWEzjKffPC?=
 =?us-ascii?Q?K2RQrVCweECES5ASCTcla0Mjbz4+0K+hbvGddxVsS1/ckSAZQcvN4kaVBfd5?=
 =?us-ascii?Q?YM09cSMpyoaMEJC0MME4m5Pxups4WLspnG38BMOlQijFAK9llyTl5eL0DmWI?=
 =?us-ascii?Q?R/N//4e4Txz/0K5OqDNgFR2MKRoaaO1Eh2Z7Fo54GPDLxmd/81gL1wQzm9Z/?=
 =?us-ascii?Q?LfQgxQvOuchRNWCFy0xEFgbiuAhGYEjYcvZnsmn5kOFTVcU4LPoyyzc+X6H1?=
 =?us-ascii?Q?obM4eYwswExF3l1iIPYnxj3ZYZ+7RYwZ3+aRyJ3aMBYxEQKp4XLXyEz4GuE8?=
 =?us-ascii?Q?7i8eGxJUMyelLfde8c/xRLwWKSa5cHTa3pnafyFVdfwDvRN2N5LVANhPzpWM?=
 =?us-ascii?Q?+eGIbMu55FgP2fzjAj+POM/WGLWwNGnT5gD6at+MMQUAAyzmFBTW9soY1ehF?=
 =?us-ascii?Q?oBd9J/hrp2GNcwkTqfiEvRAEn6B27KTiIGVi0r1ZIY81hylhIpt33pm0V4S8?=
 =?us-ascii?Q?0fRhHTImMD0PUEAd5mVHv4S16enFiX/jukETv2/1F4iNpMrv0Q/qRItAHvMk?=
 =?us-ascii?Q?Xph9FZn4u2BF9+14LzwGQ1afezLtvuYkW1Wind3tA7y9tK9AiYSpwJwJK7jG?=
 =?us-ascii?Q?zdePIwH4JP9TLBbRqOLWl0pzkhEqGSjY7VXkeE3EhGUbxggDq1VKdYgYwxlO?=
 =?us-ascii?Q?vquiDtMVNLD1beEDCx9SD/kaz8+BzmUzEK1KEqbqemeExsYToWy9upt8lRAB?=
 =?us-ascii?Q?ba0dcjtcYfQwFY6mg9v0YyFMPf4Dnx0YQ0Rt/3ymANyrwcEMmJqccFUkV4F6?=
 =?us-ascii?Q?yKd+ixZ357vh8WiebpzTHKnQ1QTSBrBEkcZjZ37KIANPFXjPOuYqfzSaRoWq?=
 =?us-ascii?Q?ut/aOUnklmqXNO/dl/e66Q1XbWe+Mafo3rMMdTLbrgjDfeeWw/5ubfqJ1LIr?=
 =?us-ascii?Q?4yGWS7RgegGBzm+hhC5zx9mZ+Ycdh/fzU86a7epAsxrTuHwR/YjBWR3lLOnR?=
 =?us-ascii?Q?nxsgR5eeQIfoPbQ+S8ukxIwdywiSibk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e376e978-648d-4434-90eb-08da32d1b75d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 22:09:13.6012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CogDlrRaVsG2sAjf1mAwZjI+uCYas97tKSibNZ5qTnGx3wLDH6I+kBGFHbeakcRQl7LhAW/MPN5Y6xS9TFlIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6068
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The host interfaces $h1 and $h2 don't have to be switchdev interfaces,
but due to the fact that we pass $tcflags which may have the value of
"skip_sw", we force $h2 to offload a drop rule for dst_ip, something
which it may not be able to do.

The selftest only wants to verify the hit count of this rule as a means
of figuring out whether the packet was received, so remove the $tcflags
for it and let it be done in software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/tc_actions.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index de19eb6c38f0..1e0a62f638fe 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -60,7 +60,7 @@ mirred_egress_test()
 	RET=0
 
 	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
-		$tcflags dst_ip 192.0.2.2 action drop
+		dst_ip 192.0.2.2 action drop
 
 	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
 		-t ip -q
-- 
2.25.1

