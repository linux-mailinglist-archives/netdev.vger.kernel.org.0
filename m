Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A11B3D22AB
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhGVKot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:44:49 -0400
Received: from mail-mw2nam12on2135.outbound.protection.outlook.com ([40.107.244.135]:13313
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231286AbhGVKos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:44:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZR/HzZpCq07pZHdOfGpbc9Sirb4CjcSs/eX39Tnc0ueMnwRCQd/gWOaG4jQykVIB69o5byPUHfjgXCoYkcIF/qMUw5oIV/L2Oe0heyK5Dup3CQfn22OYZBHbEVNfHB/OPLVMRj4BShDxjoIMkSuhJJsDSroHa2sjeRr/EcovD+txB4OtP+wJCNien+cmjMayN1Zg5I+0JXVm6dw0hEwb6zVtj8UWzYE7TbYEMLo4lRpFScACf65UVc08BnGm7mdCPcBqlnRzLaRaT5waZrRLtEIRMToau+fzKxLFrgWTV3jtimb9SQgjA4bIc3AzIr4+qT8VgzYAvl6SPL8/zmpBIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Df260Gzj4AukDhsjZAPvoQl9x1ZvQ4VnaNpctJWhrWM=;
 b=W1hvEvUX/857unPHvkMwBF681uVfDcpkoy0efmWeELWevah0A1yqBNHhOF/+NnVG/Ai+WsIpfLSuMnZz6tdpYHRF0kojaYFPYvr6cdh1BRFAWPLKK6ls7kkAboHNVbHQilswQdhM0FI1UON9pwOjPo3s98ujI5EtQkY12zBC6q8jtIKCbjiSJ48UbYN4CqicCkfbztzX7qqvx8ehOOGfOhIUq2FELCzr/NdYI1jlLK5bAGU57cdcJozqYDw1iePwWIYTqvJRV2fX7EmKXR7JBNNFnGJrTadWr5L86LqApuXFBcQetP7RUpQOUTN0Cn7MUkTm3li6kCzGNEA8UxnHhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Df260Gzj4AukDhsjZAPvoQl9x1ZvQ4VnaNpctJWhrWM=;
 b=hIYUX2X7RrCHc6gSzf4FWOWVJfMdARxZMUoBsgLxoj+1u7I5J2itO/iLbM/gmnsYZZ8q8BZrJ5i4CiA8a2ZxaVPwPsGZaYs0g6prfFJnOLLlfKR2Zi0O5JFLobC932KdSoft4ae2cpMRw3vy/UIvw1MIE4kUB9XXkQ0Zrf4FpDU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4874.namprd13.prod.outlook.com (2603:10b6:510:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7; Thu, 22 Jul
 2021 11:25:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 11:25:21 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: fix return statement in nfp_net_parse_meta()
Date:   Thu, 22 Jul 2021 13:25:02 +0200
Message-Id: <20210722112502.24472-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Thu, 22 Jul 2021 11:25:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5397bf7a-73ca-434b-6163-08d94d036433
X-MS-TrafficTypeDiagnostic: PH0PR13MB4874:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48746456F6E64DE156CDF234E8E49@PH0PR13MB4874.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A/249ZUvKRn0Q+jv+Pcbl60avVkNKRx627xhF9ua7V1kJUeJqUjs6f4sRFSH4b6nINDItV4OJZSDQsAh2vBdi7gR+eOiJgm8tUecF23kATVJfCbgwHmqQLDqIzOBRYtiwn+DFJp5yt68/Bnp4UUOwy/+fOun2lmjvbdx8ImL2UXjw2E6zgh6eR63dBLhTh023ZjQV6MPASYPDhFIGZbJyzuO8owS0BZH1uNZ9V3O+NJo2HRcSPs+DKWifQYnoRxMM3AMBnkRPjLkAtWVG8SCeGvuhsv+UXKcjjCuJXetSpbyXkoT0tgoNkJs/R/HgfisXMIrJ31rYfDHrdfSFfnCBvFE5E78bKA9xK/Il0oF/VYTaDe9JWhCWWsVivMlXncXc8VdFkAEReyP3RwNgLMICTQsjT2fEEn7QjKe77qCzZm/ekr7OpDS9/82EENPyZKQaUICWdfHCCqXHcTrXRZtq4cxk59NceS7Ag4S4/uxrZ8KfJc65tKPrZfdzMuzjtqpvXTxdzReF7J1Capy8x6IpSb8ZKrsnxAr7c8gBd5BkCmGfpRtpl3txnkcnXd1+6n5Fo10spAnwDz+JWKeLSvbmP6dWxOX+bUVqD0CcgIX9vraPLSlDMWJVSut7hAb+47yea0ZmsLLotGosLILP9TeIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(136003)(396003)(366004)(376002)(346002)(316002)(83380400001)(2616005)(6506007)(2906002)(52116002)(6486002)(4326008)(5660300002)(44832011)(6512007)(8676002)(6666004)(1076003)(36756003)(8936002)(66556008)(66946007)(478600001)(107886003)(186003)(66574015)(110136005)(86362001)(66476007)(38100700002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3QxNldkbjNDcWlYT1o2enIvQVREeUJyUjY5UFdwVDdjaHM4L1RHZUxkWnh2?=
 =?utf-8?B?S2gwQzU2TnB3azFkYUgvbHR4NnpWUWYyTjlEUzZnblNlamk4bVV3bU1QR09S?=
 =?utf-8?B?Rlhjc0VaRU9ES2JqLzBIMG9IbFExVllLK2N4NkRnczh5RlpYRHRhcXNVS0FH?=
 =?utf-8?B?Ym85VlNEM0VDdzdYQ1dyK0p4ZjZYSUppajZReTFGWTVQNjlOQmV1dloxMkhk?=
 =?utf-8?B?ZkRtVS9YZGJWZ2hjSWNMY05jMC91MVROaWE1V1ViMXV1TmI5UXZHUXRDVUhM?=
 =?utf-8?B?dUpndVZmSlVhaDNzTnhla0lqUXArYXVNUnNhS3NnRklJUlhJZ3lhRE9VZDZw?=
 =?utf-8?B?VVBRWkRXVi93OXNPRXM2UFdoc3hkdmxpK3NpRG1MclRwdlNHR2JjM2Q4by9p?=
 =?utf-8?B?U041dmtscy9EOXFrb1g1N0RxbEs1ZW8xcFowVDZOWTl3WG5hNDZFQzZuUGpy?=
 =?utf-8?B?N3pzc0dieGtVeDJvOVEreWx5d25IWVNQc3lTUVhWY2xMeEMvZXlXVEZKK3Jo?=
 =?utf-8?B?amxmemxlSDZGNXJ3cEh3Z2dSWi9sRk5ZVkJCYnpGUGlNaUkzUzREWnFrelhM?=
 =?utf-8?B?RzNKSFpzcjM2NGZwVTlBaFFsL0hJZGlTQWRQdStqQmdpWGFmOWRoZmQ4eHdK?=
 =?utf-8?B?RHRvY3JJdlAxUi9mcyt6d2dDbytkNjRaQU5sSE5JSXJ6S2E1ek9vVUl4ZlNz?=
 =?utf-8?B?Q3N5UmdGc0h0bUtoNTVSQXFKVTd5Z2NaN1VMK0h1Tm50eGxudnpQakdKSVkz?=
 =?utf-8?B?RlF2MW1BdUxXQ2Q1N0JpVVpKcEdqSjh6TnRQL25HSmlwcVZaTUJsb3FhdHFO?=
 =?utf-8?B?eXFWZWdLcEZwZ1hjRkRFR2NKWTlNbGpmZy81K2F5YmQzamJFcFlONWhiQk9r?=
 =?utf-8?B?anNMaXpWTGwwR1ZvUWFmT3VOcGhOZDRIdjlCblBJTytJS2RNMEZ0QVFnckNy?=
 =?utf-8?B?d25pZHN0WFJURnkvSE9vUkpGb2ZSaVhoeHovMk8vd1ZFRzN2eURYUEhzaUt5?=
 =?utf-8?B?U1l6L1Y4QkFVVDRzbEdwK1ZGRXBQeXpmZnpZVnpKZmN4S3B4TzZOWitsU2xx?=
 =?utf-8?B?TlBUWTZtZEpMbnF5SUxRV3Y5ZmFJSWVNcXhQY0xqeHZOWHFoNFlGbHp0WXpS?=
 =?utf-8?B?VDhvOEQzTkczVjltVDF3QkNZWjB2Q1NydjJEYkllVVZWeVNjRDMrWDhsUmFX?=
 =?utf-8?B?TjZNdTdiQkQ0MDI2dHc4YUdyUnJTMmVFZnU4NGhSS1FmeVpQb1VhUXIwdWhv?=
 =?utf-8?B?U2UzM0hjYU5WdlVJVVVwWVJ3TkVhZ2JaanFVYzdQMUxNUWxRWXNVS3hxUUdT?=
 =?utf-8?B?YVF2bzZFcFUwaUdVMWNxL1pHWmVXZlIwR0lpbW1YVWlUWWRuWUxwc2dqU1BF?=
 =?utf-8?B?TEhkTWl0SWZ5b2YzeW1VVmI2WnFyU0JOQlYzVU9kaVd3dUF6TVc0MEFQbmcz?=
 =?utf-8?B?TklCNG91Z1RSMVVpa2x5aUF0NXBhKzJOYVE0aHplMkZydUFBTkw2TzRqRGds?=
 =?utf-8?B?Y0tuRWhtbUFhQklEQVA1RVU3L0JLOENJRkRkY01kYnRSZ1kvdyt1RTRkV0dy?=
 =?utf-8?B?SW8vOXdlaWN1R3E0Zml0TTN0TVlYamxkWW1HWkcwcUtkV2tBTzE4enVhUEtt?=
 =?utf-8?B?ekp2UUNGWFM3V0t2L3Vtbmk5M3VJWTNKTHZQb0QwbnVJeXhmb0liTjN5SXJF?=
 =?utf-8?B?Sk0yMjFyS2drbkxtb3BCMkc5blo2N05zdmN6NkRWcEovRkdrczZoMHBTS0M2?=
 =?utf-8?B?WHhoc3U1YWZRMHBYLzZwMVF5b1dGOFBQWSs2VU9BY1Y0K3FUTitWWGNZMmNQ?=
 =?utf-8?B?TUg0aGJxZnZSVWlZcXY0VUQ3OGN2UVBVeEFoaHFIV2lRYUkzZ3djVWs5Wngy?=
 =?utf-8?Q?oN5FGBH5Zta0C?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5397bf7a-73ca-434b-6163-08d94d036433
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:25:21.4270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0PoXYWenJHsgRO4s0foYY3NDkvcUIXpapteYQjgK489vzTuuK0HRouPD0cFSdCAilmugVHkygncj6LFtuyMDJ5c2nwaQJu+4S+Du6zihuzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4874
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund@corigine.com>

The return type of the function is bool and while NULL do evaluate to
false it's not very nice, fix this by explicitly returning false. There
is no functional change.

Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 5dfa4799c34f..ed2ade2a4f04 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1697,7 +1697,7 @@ nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		case NFP_NET_META_RESYNC_INFO:
 			if (nfp_net_tls_rx_resync_req(netdev, data, pkt,
 						      pkt_len))
-				return NULL;
+				return false;
 			data += sizeof(struct nfp_net_tls_resync_req);
 			break;
 		default:
-- 
2.20.1

