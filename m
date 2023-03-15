Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FBF6BB33C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbjCOMmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbjCOMmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:42:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC27A54E1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:41:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X13zZfz9RbTRK7e+VtHvNKSSU9lJI6tlVLN85iXn1PKh/01IDto5PDBVvk3ekxNwqpB/MhaHWIrdyIeIyowzQ3nRo4EOAe1kefizj9nLIaJPdvh3OsQcKZ0LXQXAvaXvJeK72eW/4SjWrSbjiy9Q1G62LVU4SfMSr7a5yFiWx+oKy9VG4vFYhWnXeiTm0EGjcJM14P3zI6ERJJcAREdYVBry6n4ofrFCYDHlcFgQZFp0eU77KTcoByj+J1Vy9khR/4lxns9fhO8Bzx2Wc0Lhy7zvlaigFaHgWeAXjoqHr0x431eQGStvl1/TwUoqU/GsBA+lINTUPqLa13MdTr60tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jszCrB9UdzhIkrUsat10Y6gKxNTnIL7mPtYe4Av96dk=;
 b=FoJB0ZBsL2VSQnmUhrO5C0+CoByTEa+YMeXk6MO75yCEyEONO7Ze6J1sRLn6XdncbbOhcWAVLbLytjIlOF67dwXNryZ0svJ2VaU4qtLn59ftJd7SpH6pBX2dPp2aNskHgTi1QwNbOBGF2ctboYXqbmt0k9ESnYZ9IfKVbal3CMce1MbfTOmMM3lVwf7FohycwLw4ElyMgj2N+98cazfMxe3e/hfMmgTSpoLFhFez1/GPs/vao/Ja3AANhF+DvvtDBPtJBzUOa+bexpb21RjQ0tcPcn4wMM63AbHkOItPLOIuMCkUBOqhDxzytkKoxvh+NPJlqiZf4tyjagLxW2i7mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jszCrB9UdzhIkrUsat10Y6gKxNTnIL7mPtYe4Av96dk=;
 b=jogIuT85/IOa5KjbE2QY72NyEkqFcWl3p/ueNReOWauGEpojYZMqr5uU7x84QKK4yv6Fjup2xPSQSmM8ivZDAjR3y7b3fWz6Yj3QRlSq1l9EAkm/6gHB6cTPp2KW07nYQdvd/Pkyx9AUk4iumfckLCQSxs6rgySzsSu/xol6qxHCNCFCPUOhEZywq0FHSquwD/cfgvQEr/fGQ4szUCvaaNG20jRDtXJhTXFdZiXp3POVcriE5KUtiDZYRxK1pXRb1OnB171pkZwnq8pAdTUsJMOkJhEUgd3V+pJFNlzwouaBXy9Hu4W1z0mIP+ytlLSZFTiAzI/vux0rdnfRGb7n1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW6PR12MB8736.namprd12.prod.outlook.com (2603:10b6:303:244::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 12:40:47 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 12:40:47 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@kernel.org,
        mark.tomlinson@alliedtelesis.co.nz, gaoxingwang1@huawei.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] ipv4: Fix incorrect table ID in IOCTL path
Date:   Wed, 15 Mar 2023 14:40:09 +0200
Message-Id: <20230315124009.4015212-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0147.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::40) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW6PR12MB8736:EE_
X-MS-Office365-Filtering-Correlation-Id: ee69f7d8-e92f-4200-249c-08db2552802d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EAY6+O1vh3Bdm6rr0RJf9Q9UTDbjo6LUfx73MSivok6tE2L+8ljmC45hInyxmvBTbEB0wfA+wATIyYOcWSB102fv0JYPtR941QUAlYCSXI0KzVuFC383akge9rGmm1ryoGQ5zwiZ06VzFbna88gef1UKFJ0Atsz4qkf7DTbmZKA+WFLCtL8Kcz6qy/dEpHGJTGfoOTcp8gtR+rK/m8vXmS969A3pH8Mu7r2s7HUdlxy1k44eWj2pU6VXC3ZybxEm4ItXU9oAnStD+Sn740Ca+OdqGmHzRU6lyIeI8V+AjzMa6u2/hl6biaweYsHFMsqPcSyC92+6guLfQ2CSTiU5qHu1px6JWQJKwdlaJDagABg+9xbEB8OymIVhqcZAuc4HsblVx/yX6IAvwXuL6oU6ksSPbwJAWzMBrVIg2SAOSygOtIzgrpZ/+5jXVyj1Z1iTgdsgJi0cmw567G1ws71dLvuWKvPBrliSkQhKOp1EDqzMQqHHn3oCvqpQljbMN2zTxAQzEst27jgPzdmGu+mjmI+jB6rWCzRR4KdkLy1n2ughY341OxFM1dfg0fKBtw1IfKC5d5x5nfCy7CUOVlVOwgG9NEVqWnhbKthcIOOqbji/1XtUZ00t5KXVTqyX6jMyEf65iWbE6j9BaZyxJANIf989PrxtwsvM9k6XzShd2YFYQt+vdW6SY1pA2q1Ckg40
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199018)(5660300002)(36756003)(83380400001)(186003)(6916009)(107886003)(8676002)(66556008)(2616005)(86362001)(1076003)(478600001)(6506007)(26005)(6486002)(6512007)(966005)(6666004)(4326008)(38100700002)(66476007)(66946007)(41300700001)(8936002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2EFGtvSHIOsk3HTK679A8acmfa1tlvPIngCtQdcLWW+6h8wQVHM/j10RHXKk?=
 =?us-ascii?Q?SRzRsZcH0OrTU0FjQuAxZjMb8V55i9gaD4bzSMlHbpkDNR0k58DLsb2NJqRm?=
 =?us-ascii?Q?mhCSghSCqH/twDzvY31KMy9mxVLQBOyiRm3fvbd9o0FYh3R4hfCuxjh9P/9l?=
 =?us-ascii?Q?wJf3kHu2p0jpQ4FT3DCs49RpjDvp1fwSVyqevhciU5ai4SkmGyVsQ40WB9F+?=
 =?us-ascii?Q?lj8go8IHiCi+pF3TtdppWCiY8Kg76cNoErjFNfd5seDdDk6XMZ5L3AVVm5fM?=
 =?us-ascii?Q?nQTstqHS5j2GXRvTNmPvUju4QEeWWBWI7+7VqSEATuqZiZQ5wbSl2S7ibxiF?=
 =?us-ascii?Q?EN1TztTFMbCX9pMu+NvS9HtI84tF5WciysX2XrLO27CUMwPBPNGhwrrwewOu?=
 =?us-ascii?Q?5TxIpMCHhyMSLwq+AmzebD2U17LVHt8uKz6JBJyR3MhuRRfkw5X3Pq68JQE6?=
 =?us-ascii?Q?Ep9pbcIfFN0sRFwFTetXRWkuiHcOk+96QO86AgdUUYATHvFKCMKsw1hYQg75?=
 =?us-ascii?Q?6b7vvueyuEw3XonOPp2tq4xlPHjK7O1PoXXSdtuPPkEFL6/ARjco9UGc9M7A?=
 =?us-ascii?Q?lks/pz+5he2G6Rq1Jqi6B4CHzE2nL0qPTljsX1PK/n9C1ZswmkWh++KtGwJH?=
 =?us-ascii?Q?AGB9mmJDw/KF9hepW6YexiwCPC35XlDKUZFqhMdb89xN4sDQfMNMal8doR93?=
 =?us-ascii?Q?F6lPpmShGKwTcogBcbDdNq2iKIzNiQmTditNaivjlZynrhwl6v6Qa3UsB/QB?=
 =?us-ascii?Q?qulSZeUCqtPAM2+T7zlc+UxcEq8E29KG64ajwv+9hOoRyCo7Qs0Bfp97HQ+l?=
 =?us-ascii?Q?dQrWndc1T7I9b1XZeYm2f7EhXTh/jFQ5x4LLnOWwopQ/FB7HyDVwmiuC+05O?=
 =?us-ascii?Q?bMNECZ08mIeSYggJatR8V7r9x/IiQDbbyr+Hf9OoDletzCswtrYtdvkHcIFc?=
 =?us-ascii?Q?HwgVSqClHz741RTPGuhx9g17X8Kk1nqBajM/L7oc5kAMhyuHTriwitEGqfmB?=
 =?us-ascii?Q?OjtAb4myXXX30Ze3S3OkZHAA/xqIdBKPfYmCjwEpxlsyZJUZF1PUW+edJXJr?=
 =?us-ascii?Q?xW/S/sDZGlTCEmCyaBfMnNlTeYSCun6AEq1amVpiTqRrxWGcSHuz0bhLaCPq?=
 =?us-ascii?Q?1mbM3V6Sa1kOR17bX9TCG9FkkZu4Y3SjE4Vl2EzOklyI/pfxw8oRp0SdqpH/?=
 =?us-ascii?Q?KSMPLGyRzSdOfhurZGheveExVEzKzZs+55vFeUgICxWOzGFsx/40NEPoSoct?=
 =?us-ascii?Q?/Pidm1Q1oHSwEYNUhe9V/rLUP+qpgIwG0PKocw2ThAY6jQyEXCzIjCbwrvb1?=
 =?us-ascii?Q?UWKubGBTQaOuZDSH2QS9kf2P7piDzqXzv9FML+hgeEoTsskUyRyCU4NT5ueQ?=
 =?us-ascii?Q?/EipBFysniCmC8pRcoEp2M735OUvHViJohImdqJuxJhOR2/fw+r+fiFlWhj2?=
 =?us-ascii?Q?1AAF8RJRoi4PVWTWxQW3cAlugCoCALqT1ZXw7Tv6XWfFhDkeRUJITpX7csRg?=
 =?us-ascii?Q?aIRwadWto7DWS0U07DY+PEb3AVvUCXhYCICwmq160q6AuU9wnaiL2Me966DV?=
 =?us-ascii?Q?xwAVNFloK7YC8C0H5LU0jyK7k2tTSuV8uv2/ewqi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee69f7d8-e92f-4200-249c-08db2552802d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:40:47.2450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rl/NHfAeFbJ6e5ro3lCQutFDvcsRdOGK0hqv8lIPSA4c56uzYvlMcioloZDrH5zeuk5I9Bo+YyyUh+BfQioSug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8736
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit f96a3d74554d ("ipv4: Fix incorrect route flushing when source
address is deleted") started to take the table ID field in the FIB info
structure into account when determining if two structures are identical
or not. This field is initialized using the 'fc_table' field in the
route configuration structure, which is not set when adding a route via
IOCTL.

The above can result in user space being able to install two identical
routes that only differ in the table ID field of their associated FIB
info.

Fix by initializing the table ID field in the route configuration
structure in the IOCTL path.

Before the fix:

 # ip route add default via 192.0.2.2
 # route add default gw 192.0.2.2
 # ip -4 r show default
 # default via 192.0.2.2 dev dummy10
 # default via 192.0.2.2 dev dummy10

After the fix:

 # ip route add default via 192.0.2.2
 # route add default gw 192.0.2.2
 SIOCADDRT: File exists
 # ip -4 r show default
 default via 192.0.2.2 dev dummy10

Audited the code paths to ensure there are no other paths that do not
properly initialize the route configuration structure when installing a
route.

Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
Fixes: f96a3d74554d ("ipv4: Fix incorrect route flushing when source address is deleted")
Reported-by: gaoxingwang <gaoxingwang1@huawei.com>
Link: https://lore.kernel.org/netdev/20230314144159.2354729-1-gaoxingwang1@huawei.com/
Tested-by: gaoxingwang <gaoxingwang1@huawei.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/fib_frontend.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b5736ef16ed2..390f4be7f7be 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -576,6 +576,9 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
 			cfg->fc_scope = RT_SCOPE_UNIVERSE;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	if (cmd == SIOCDELRT)
 		return 0;
 
-- 
2.37.3

