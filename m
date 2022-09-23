Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26865E8476
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbiIWVAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiIWVAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:00:42 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD2410D642;
        Fri, 23 Sep 2022 14:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VErHE+EBUJxN9PHVvk6g6rUsc/11cB8jYwiCt6H9IVkvBqevU8JG+djq4o8chHlX3A04fMlhaDahJ95g/PaeaAt3VLQzIxLxbfaU2yU73Zt6JJh73VISiMkLa6y2Y8x5//0zUYxTEpGYEreJAFz5rvq4mBe4fjxFKBw0k3BCdxUsNkNvX0GoapWYDDb0Gz1uRhM4MivlwD0GLDF8BHQncmSuK7qXBLbE2y7QVlmibndEhW4WaKdh6V9ucj3jS5yWfkvW6Vc4aVcYLFAYDF69WmCvnmqxYi4/yc1aIM7siMeMZD8pTbe3hQkcALCRPV6L6ujYrsY/GwiMJ4ciDErmJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VyfS11Cyc8rb62bVngUTCfW3wXRu1NasicJ4gS1yPCk=;
 b=kMQ7mZiqhvYShIzN6rjbuLRgiwcALAlfj6y9gUR5c6DWolo4F1phICQxJnvi35P5/DzNurOG2rVDd891cET43ddV6J3MGRwLQDT8v1C5Jr4T5JFiXaj5BdKcmBiEaG9Y1CEITV9KMBliEXr56TFCADy8yJTQg774moHT3/OqvGQpLQRCvw0kehqHxKwLynsxHBaoDI/xl6hBMmEaKuO9WBfX8irmftnoHL4YZ86oTH5K9ivQs3TBieBlbYjFTGyDw+NXuHPhNbv98qfpu5RF16RirxIbDaIqno0NvgGjRCbF7l8nUoqeHsugJbvszxemlELzWZ7lLrA8YnHDgEPbFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VyfS11Cyc8rb62bVngUTCfW3wXRu1NasicJ4gS1yPCk=;
 b=GzxBD+BmXm7KualBtQJamKI7+1XmFCRjqYn1nTFfypTvrhpiSVT76BuFJx7Rd0hZ39rQ35ZtSurIkT2tT/1jG2Q7y7Qm2w3JSyKNr1HLcCju910QcIaXpNWS0s9FJnNfkJuYSE6Rc9f4PfTXgeO8ZH5/X1UXw962qbMNVcNRW7E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7863.eurprd04.prod.outlook.com (2603:10a6:20b:2a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Fri, 23 Sep
 2022 21:00:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 21:00:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] selftests: net: tsn_lib: don't overwrite isochron receiver extra args with UDS
Date:   Sat, 24 Sep 2022 00:00:12 +0300
Message-Id: <20220923210016.3406301-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
References: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0270.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7863:EE_
X-MS-Office365-Filtering-Correlation-Id: ac6aff18-cb6d-453e-c073-08da9da6aa84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lHNjeXOXUci98WazNeK4jREXNoPYoCSRTiJ0cHmOH1SPjEL6UPIsGiEQzsp2EUVCjzW78+eEUD/E0mq02Yq9z0ql5pT49UlUfEDHp6oHQjSoBdx5kuwfAJAi8m+luLpo8XnBmC/mHPfNVWkdOUqK9U/hHvKW7NKWwDM3pvzLAB6vJ+gdDrxJgNpx8MEus+bGMmIo8PVwAJyG8wYZ1IPkQhKw/9pMj+cUDbwvGFAhEh0G/NI+IFjuJnEJo6d5WIDNzttDIkA+0Nu7JGlYq2d7dgIWNtRH6bvTxr0R/8yO2XKFzhcfiN1XlEVsxR+apsHMj1f7v9vf7nliqWrRnAxaxSQ+TBoDmd13ZgJeMvQvMvLPrzEn6RXSi8m1vd6ZxVMQUBCPiYTxGEU5eyDyMxa9vxpdHy+jIRDEm53/LD9iaA3nXYjpfZVbkMSLZ0kX243UB2BFeNxDqUelZGGc1gSzXIa9W1c3uW6Jiw0Xl9cc82ymLjdkB0Z6+ol9/bMSoKCMRPStvOa6U7OPgNSTJUXTSiTczMTPLkp/iiaKRAmR795Uoo6SASiXuhJ4wxx3CByLch0BRJwIBpv3XJv1Vz0Gr9NETkxm73s2+p2uBeccze6fZh/Lx6XPGfZklQ2nBsZMbLMRSDkJkQp7eku1d1d09jCp9/K5myhLcZN0L2rwuxOLPH6x+9x3vuyZvR1YGEpo6mzqHMbo0ejfXkRpJU3VAVcCBq1cSdtN6jt+yygGwZG5b4tDtOKyZG6twoty4V9IO1g5HsyCR3pbf+tjd+/yCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(6486002)(38100700002)(66476007)(52116002)(316002)(6916009)(8676002)(4326008)(66556008)(66946007)(6506007)(36756003)(6666004)(1076003)(478600001)(8936002)(4744005)(5660300002)(54906003)(41300700001)(86362001)(44832011)(2906002)(38350700002)(6512007)(26005)(186003)(2616005)(83380400001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?382NZ4LGr7NeybzV6rGGCO4MLSKHhVFny6VCB8MZlh7qjrfRiHRVjPWTd4nW?=
 =?us-ascii?Q?wKGmKoMbnkMguE3Okc4/4q6amLO9bXlQZY9KjGVK/Q27FoPKQWT10mX45en1?=
 =?us-ascii?Q?bN5achA7MO8CCsBZ3B2fwlsRTbwVHo4Q/3Dm3yxtptfPiy61n55LspIveUEr?=
 =?us-ascii?Q?CcqF3FxLhq5nDug1CLU2vRzJnFOVLLSV/nWkHb7MUKGiQWtG8hpYR+DCc/zd?=
 =?us-ascii?Q?w1qKXRt7fbh+qASkw3P6j7l7ijIwLOzhwwuKuIlTLzVRAvTrx7Tp885vvjGA?=
 =?us-ascii?Q?0O2UHa6jjzdohkhvtPIp04ClYP769xe9WUOL3EFbH/lpfCd8cJ+nSYkzhM7l?=
 =?us-ascii?Q?zWeG9Bsyj/M3hfWYzleXnmwZa9kfdkUW81dZIApX5YrlYaLB92XlpS/5lBLR?=
 =?us-ascii?Q?G2fdb5E/TG0Crz76OyPXpFsnlJbEf+gyOK9S31TKNjp0uz+ecwPZRG4L4cOh?=
 =?us-ascii?Q?Hc4yq3ECFm4oedgov3TsNzEyV6H5x7BDp6RuyW1xhdFT4kzKSFvUXKtOJaZS?=
 =?us-ascii?Q?ziw24Wxhu7zvo85qdnQL8S+lLpYPdZWBX2PQNuOqIPyJALm9dYAzmeDBBaTv?=
 =?us-ascii?Q?tRsADdi64lJVmxMu22qiXwr2j5VES1ogRpeU4ID8zw7yJm35LlwVd3YfQu7V?=
 =?us-ascii?Q?EzAZ8ZuH4BIon/Mbi0M4Lip6ysGkoxyFiAhyNexNviLCzVBfjCpsEX3olAIn?=
 =?us-ascii?Q?YUpZaAXuZ5NUr5ORCQXh7Aj8a+IG0odAZ5pz2Et5vga+vlEh2N0TisLaXEli?=
 =?us-ascii?Q?JLJcSGq/2xisngrNT2pzNrYEnC3++PBJL21uvecs9cZCyX7cCgoqCrwfcd8g?=
 =?us-ascii?Q?FVJW/drkM3EgeX4g1Idd39eQK+tjXtkplbtOAYb7Vpa6pYCoivDNoLnLyHzM?=
 =?us-ascii?Q?ug2674HXMRrKR1HfjRGZ4GaTuDZs5/DWXJr+6y8/cjWUi1DAxtOoOywcaZ2C?=
 =?us-ascii?Q?KEaW9nrNBxzAvMMje6FmkPjpl7pRnjyaEsZ+Ohl51Cy+l2xTiheNa1r3oQ3M?=
 =?us-ascii?Q?jAdaE+HnYod8RkjMg2atpHMCR763KSfxDpHKQHki4TLngkmDAdE/a2/4NH4k?=
 =?us-ascii?Q?xBbrw6cYWjGbjaEWyaNpf/EXDWnpgMXwjTKvtJG7sgO48NLGE5WLH0aVtMQT?=
 =?us-ascii?Q?uNCbjgN82pV6GIrxzJEF3rDVrrwMcX+G0PJrBUfqd0zMjDjJHm7hhpnio5i0?=
 =?us-ascii?Q?SfWvryKDiLII1x0he8dI3fmhpBQG7FWxBwS/+XxAuVxzdHGfmkjJGAFQEKQ6?=
 =?us-ascii?Q?RRiBnuFn3WaOxit6Mi+lPnI3hzzTUIi0XfQ9XSuwkRLLC5A5M6PXlzhELDoX?=
 =?us-ascii?Q?WF1GGzAi7aauSqpQbgL9uV6aG+p5RmDRf/gEDL9s7QkMQffsAFAe33ecuT6l?=
 =?us-ascii?Q?C0/BlCFIIINtLpgLTyCrKxDjAlR+ofHfpNu83UvBkWvcZBc/ML2/kiJ7mwWH?=
 =?us-ascii?Q?gzBiUp3mi4qM8GpJ3v+Ru85DAP3A7USsqhZ5qBf3zEHfk/sWAq1KkPTa7N7U?=
 =?us-ascii?Q?dwfIWUujn/U6Wgi6rLuBhr8FZR0UAJNQEbMHIViOhW5T78cXHVFOJrXdliQ0?=
 =?us-ascii?Q?xAQnLdTFusHD96rMbVeHpz0ABd4B8Za2CPW3CjbDzH5ZqGc+6gYm0HtaN86U?=
 =?us-ascii?Q?KA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac6aff18-cb6d-453e-c073-08da9da6aa84
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:00:39.1522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0IsZ0UMdehReekdVAwwlGCSVUR3OusojoDX+mVal4/9ruXdlbHNw1wwjdnz8/4JSYbz071+oNzXjDRItexSKOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7863
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The extra_args argument ($3) of isochron_recv_start is overwritten with
uds ($2), if that argument exists.

This is currently not a problem, because the only TSN selftest
(ocelot/psfp.sh) omits remote sync so it does not specify to the
receiver a UNIX domain socket for ptp4l. So $uds is currently an empty
string.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/tsn_lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/tsn_lib.sh b/tools/testing/selftests/net/forwarding/tsn_lib.sh
index 60a1423e8116..1c8e36c56f32 100644
--- a/tools/testing/selftests/net/forwarding/tsn_lib.sh
+++ b/tools/testing/selftests/net/forwarding/tsn_lib.sh
@@ -139,7 +139,7 @@ isochron_recv_start()
 	local extra_args=$3
 
 	if ! [ -z "${uds}" ]; then
-		extra_args="--unix-domain-socket ${uds}"
+		extra_args="${extra_args} --unix-domain-socket ${uds}"
 	fi
 
 	isochron rcv \
-- 
2.34.1

