Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE8157D6AA
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 00:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiGUWNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 18:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbiGUWMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 18:12:48 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04hn0222.outbound.protection.outlook.com [52.100.18.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1415595B1F;
        Thu, 21 Jul 2022 15:12:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJDOSpsi7sQ8H6mEcjDZrv1/e9chDNjN/8CoUcCz0eb5ux2XdCK/2tNTRu1PvDK0UCtjT8On5TcG6N+fTp7nGnUiCTt4YOnjAXwKNTr75BFgm+LpndDELYsG9fpKPKhkSJovWStmskcvznMdwGlP00uSuoVVorOl6O1il6s+jBQFgQpw40Z6lSucdRlv/4iJlG/4C6tFVz3AMJItAWC1l8zmA1FPenR+QbsRvQTPXTMprXTyq0dK14t9Abpc7bbZQQcr70qMdR0OLdRko3Kpw1q6OGtB1siiZkpSw8PP737FHtlkJx0Rzn3wEYjTOH1ttzXjaUhA5cgReTc04uwDNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=dN//LRUt4LuS7wOKZKUlXsftl+GRJnqSNIcxmT/Ne4hSSIcw++faRVWi2pjCdx5G8Gd2Xh9COpZewAV1YcemJpPiJ7M6N+506Zmv8r5RFholQeG0I1lsdInV+gMn1ekEWxKxntDYUvuuSeLFfaJp7yFvhEeb0y6/yudOCyfZdj5gJHYIoLx9bJzxziJsiAp6RjaV9J7eY//HK07bCAGBOVd5cpa7JzWfi66PPVorr+YxVbADNq8GyYPBJR9wNe0WS0/PPlZ1FvrSE2AZXlvj1BP0kxqBie/ctGC1MlUQYjc0ZhyxwN0GffYY2KnDN+Kg8RR0r2/Zus5AigwCQ2ap7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=KIX3DmLp5LwIYMisO59avcoSRnC6jQ4a23ijOVi8OTaO2S7ryYG+W04hRLGMRG+zbLoLKJqjGc12ysMeOLWWF2seUeqD34AxMGvHtEiwc+sqTPI7OemDrLVOOkdHcfEATRgu2nVOv3YXfhe0DWRPVHVWOFSGGYuEk7YIkcTxGqs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0302.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 22:12:11 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 22:12:11 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v2 5/9] net: marvell: prestera: Add length macros for prestera_ip_addr
Date:   Fri, 22 Jul 2022 01:11:44 +0300
Message-Id: <20220721221148.18787-6-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
References: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0005.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::15) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50248ad7-18ba-496c-ff4e-08da6b660f45
X-MS-TrafficTypeDiagnostic: VI1P190MB0302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:OSPM;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(39830400003)(346002)(8936002)(86362001)(4326008)(54906003)(66556008)(66476007)(8676002)(38350700002)(38100700002)(66946007)(6916009)(36756003)(52116002)(478600001)(44832011)(7416002)(6506007)(41300700001)(26005)(107886003)(186003)(316002)(6486002)(6666004)(2616005)(1076003)(6512007)(66574015)(5660300002)(2906002)(59833002);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cYRUc87W9EDP0QXu9g8G88Sxc0PPT95V7zmcziBjbDxjldoB19UoyJLzdUM0?=
 =?us-ascii?Q?e/JGo0m6a4EeH+PNtUmysYEwg5SHvqBBiQ+JRSIqZqa/XajTDsjdMS9Wlp++?=
 =?us-ascii?Q?WqILLDd82N926CB+ettra0esYp5/ILUUuWBuZ7MUcpKyyqEd6Qr38IpQGSea?=
 =?us-ascii?Q?2sagiCyytZ8PhOJ3RhH/7TvhjG3cyOASO/QwPyP7N9itso05sjbcq36UPD73?=
 =?us-ascii?Q?yczEX/HYIF5E7PQKE4dd37Q8L2/Y4/6f3qoqjbt1QsY+jwtaeCtK0HuRxJCp?=
 =?us-ascii?Q?6z9/cAtT45o4R/U4+lwk2AYpBgIDqS9zQSq2aF6P1AVEoV1ctQzJyIsY5146?=
 =?us-ascii?Q?rkUavXqH29cCoN6cSYqohjcJSYhS22f7RzO+X9bCFhRYRbeJlCx94b85jRJ9?=
 =?us-ascii?Q?1lcAJRp/QiwDD4IBeczbWNUESOfy3+lH6Is5qgga+u2BOaQUSYc54jSSTKFd?=
 =?us-ascii?Q?G3q+IXD7ttI96bAyUV7jCIRzKO3EOZt2qkQlC1moiGVrn/ZKPDLOPwggnVSz?=
 =?us-ascii?Q?z/yQjAOzz0qbjhpuHXQDzE5MtavwJs6Pqv5uZtXZ9cM2CHcfXspWI7TRRpPI?=
 =?us-ascii?Q?gsQ1qnmiFChFxxFxms0jjwEXNDZtakEQWRiQTVb+cgMlLeZHe370TXmIkUQb?=
 =?us-ascii?Q?HurMinz1r7tcQCNg0NNGgyEDybei1YGJ/EgIkGf1uaL1k35Cc5AHYweFHozX?=
 =?us-ascii?Q?gU+7f9jQO1Y/9qR2I08qnNBKOSP0ZSHpCiIBfHsUxFXjtDr99tmqozZZfDZ9?=
 =?us-ascii?Q?E0pvaOC6WsCQqqFRSsXSsz4hDFJHIZMbGpryyiRZ/dCFLMhnliQxa0Fc1rWf?=
 =?us-ascii?Q?1z5VoGGsvJA1qWyXTtxqZOwdHv2GWb+qLObz03HAAURG/k6KPRux+eD5wdFJ?=
 =?us-ascii?Q?2qm3iJGRTRKYO5TARVBE56DCjNX9VIkjRP7S2Pr5nS1Y8U7UnmwKKvPvM+nh?=
 =?us-ascii?Q?1PHKYie+ffQa3/bEl/g+elde5MsAhE2N2FhvC5b5eP/DsZme1Q4PJMdQSJER?=
 =?us-ascii?Q?KP/zngqKLP4G6d/qzvXQCwe1OAPYKjmxxHvHJc9DvGLFeYnbOtodiO7JWpL9?=
 =?us-ascii?Q?R6NB2+SmJdTmac50VDM8myZsrr+gFBZg36MlVKp0elezgVkBxNg5rHdPrSAR?=
 =?us-ascii?Q?Mx6rFf4mIoue?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mdQgwuqnmBIkecsVg1aqblN/BVN7eRh5gK2ZSZn3Ba0jgWnnxl2S++vdIYt2?=
 =?us-ascii?Q?RbotaIhAVRRvxvMfUkRwm0qfdeSdOp8fMPVMQTFIcOm3LBkAiybLYlAEvq1B?=
 =?us-ascii?Q?h9AZ3nMY8bv4XTx1KIBXCeg/JAbIodeTkGLMskUbjlwbHokeL98GULlTKJqW?=
 =?us-ascii?Q?jNQFDVaFoRd0Fb+O52h6F3kUmp5dVA2Hg7Avrm2rkw2m8ZFNzoKb/ByIemsf?=
 =?us-ascii?Q?eVvZg3Xb/svdXDdritjfx08H0Oh+jD6F7BwRLyxSz/fq9iYpjhTPCIjQd52R?=
 =?us-ascii?Q?aw+R7R0HXlzSLQhPatRTlVTGDnXsSbsZt6z7OWxgyAsCnq7aFEnSSYlPT6Y9?=
 =?us-ascii?Q?lh/To5W7IsmRMTO+eiCGNOA2qbQda3/CAWeevVNFugyut2mXSpyRJo8FMuks?=
 =?us-ascii?Q?3xCd14k/4UNpB6lOjoWn0qn7Hch7QW91UfSAkvG7k5XzvrnXnFNF8XT482tT?=
 =?us-ascii?Q?cGQmtD3nQPYikwrOjCN8yrgbzoO0AaSvOeehZazVsx0FxusBpxkjNRQaC/O2?=
 =?us-ascii?Q?GB2UD72M8xZ7O8ibisf2XG+w7nrWW/40BNT19x+EoA/0G117sMcPSnSzunQe?=
 =?us-ascii?Q?0aRibBz0MN6E6pxW5e0oTp2jG4BbO8+mqgFqZA04vXqx1N3JFTmR/36kkoRn?=
 =?us-ascii?Q?6c3gHKmAL5Paqe/KK6iS10VkqvbNdlNK0wAmUCr+4HR7S3E2jjYi07Am11hu?=
 =?us-ascii?Q?qxJU0v/x0+m4Enl0in80V1WxePYYN42tkstEaSDsUAE/Z2XhhFQAxZRCpqtq?=
 =?us-ascii?Q?cYNzF4sgbi28MXds8aGQP65aCSNqrBfj3mnYrSDagcmenFcM+OXQ3wKwnGcj?=
 =?us-ascii?Q?zMQ0x5JRywMiqI/SToAQE3uRBNw+b+CLR5jPfVbXFt1u90Y0NRybhV7SnPnw?=
 =?us-ascii?Q?0ctPsb8qLQ9GuP2KU53qqK1UZEe0wopTaireQ19oB4RR52hxDW2rdcfzKPtG?=
 =?us-ascii?Q?FTRmERDoSwdgao1elb4ZrAytl805vZ6LzJ1/HNP3+/pv7Gbi9yYgQAlyEA+y?=
 =?us-ascii?Q?NGDkn+m2zoVO7C8B75YKgAwg3jim9YPVzR/S68heF1zjyjcKDAu3eiD9wD3x?=
 =?us-ascii?Q?PCGohJlBISLoUfoVv+voB4ZuKHbsku6iOtJFJ2d2RXyYquou70PTciWF+Yh8?=
 =?us-ascii?Q?M3N1huDtEnrjCzSi/oBZB5bgUgnRC9cz1tzSKOSZjB05KEQc6qJML5/lsOXr?=
 =?us-ascii?Q?T/6NehGvG69bg5k6b8/9PRag3emANEeNeUvMOYvWZ8AWVuWAPtD/RF8zSYTS?=
 =?us-ascii?Q?sXqM1kFaYkROwSP4v5X3bYSqq0ntp9MEb1EsaplSU8oVR60AoNylAGjM25Pr?=
 =?us-ascii?Q?ShDIl7NRYFi9tqbhQozaqTD4PjGNU1jqoELhKH9YJY2oYGV3Nfu4n/9qxMdT?=
 =?us-ascii?Q?/vtKPXxDvcouuqUFSdQIgYIKd0DOG9c5NHYYEvXWzJrPNEUhbQ8vbIB/p3U+?=
 =?us-ascii?Q?/VZhboBMWuJasl/liyO15li3UOp1QiU3XRBaYvOL5X7m1/eqDUQxS1urBrJK?=
 =?us-ascii?Q?gzfTuS2ZdBVsEgjWfcZYaAegrJRtKfIys+Dbr4naOar6g/JlWBCpQRnUB5tk?=
 =?us-ascii?Q?yvjDB1SxLyGRsr80dpWSl8b6x257s4H9Mz/m8Lt8WZiDn8afJo8F6yZq9J5B?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 50248ad7-18ba-496c-ff4e-08da6b660f45
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 22:12:11.4521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHaPzMH9AePKq1Eav08LIGdicM32NEoYT11/IajFqjYiz3F8uJnyvHRcJ88ft5Iwe8yoOd0keNov1OmmtiWiUZClyJqD2ejza/9mPaJImWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros to determine IP address length (internal driver types).
This will be used in next patches for nexthops logic.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index 43bad23f38ec..9ca97919c863 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -31,6 +31,8 @@ struct prestera_ip_addr {
 		PRESTERA_IPV4 = 0,
 		PRESTERA_IPV6
 	} v;
+#define PRESTERA_IP_ADDR_PLEN(V) ((V) == PRESTERA_IPV4 ? 32 : \
+				  /* (V) == PRESTERA_IPV6 ? */ 128 /* : 0 */)
 };
 
 struct prestera_nh_neigh_key {
-- 
2.17.1

