Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D0C4BA056
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbiBQMtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 07:49:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiBQMtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:49:17 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2111.outbound.protection.outlook.com [40.107.243.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD5C2A82D7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 04:49:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gS7FP+ijli9lNpgGvlL9XxiYiGsUt7Hshmw+dtU7j2jeDhyRmrKqb61wZEOp2UxXqwPDCTkdOP/ln09mOQGjzjaSE1eoD6BxgcsH0H1wePu0/rOABZfElpIE41vSD4MASOvf9n+PTf5G4PVog7MyOAoSwOjVz1Esq0OokhDxNxq9/LzPLDYcY4SlLTLoeQRT5+/QgHNamSoRmet93XayGNDE+skRmodKmZHr3S5PKyFwAINgYs2SkwkedyLUwPi3jPQXmjejc/Z47FFEaV50Akf72IpZtf4z+QuAkjcoplGHL2rXq43EEV8Ji30GzAYLXYv3KjlvDz+kS3vjwdn0cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaiiPPgSLjNx5tAWVU0DM4Q37BLOyACmwlboCNnRQ8g=;
 b=LXvksMUG4MnxoqvH8hkhjylmg+lsgYMCsCvRRwVP/IlMRg9oafF4+oJdap5gPSybB7j9BM+zU6+dLRc8rMbtEwLgsuBMwjtY6M9nIbEfeny4+1n/TZP0EEFmsz/yvE0qWn0q2PuSL/byJmvN0yarrUBnzZ+pPLWmeW5aO0lPAhGaPsfCc8VMRICh5bcPIU22RPLk9YbkL7J+pU3nNJiVNlVkuktF/FouygpgKcLIJ3biZMVClUX5yzNE1W1bReHBrKFUz94HwES6ZZdsbGkqf/uz8WvTIkt2lEt3vScvbDCdt9TsZPqMqgt/Jw6aCYVMDDk5Ca2o9+o4s4y++eYm2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaiiPPgSLjNx5tAWVU0DM4Q37BLOyACmwlboCNnRQ8g=;
 b=nOJBc4yI7HI3avAxykP9phLPiembUm5bev8/PSEJSQuV0scCA9SBZZ4e41eHo5WygVv80PNM+X4sdk5Xe85jnJP19ha4wQjtr7OMa+XcO9XMHxEAN2D6sHbraeRcsy2tPLhil6D6ApA4veTvPUkg/WUEARfMR/cncn9g6MXf3zI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 BY3PR13MB4884.namprd13.prod.outlook.com (2603:10b6:a03:354::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.7; Thu, 17 Feb
 2022 12:49:00 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::449a:1bf5:333:7d9f]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::449a:1bf5:333:7d9f%6]) with mapi id 15.20.5017.009; Thu, 17 Feb 2022
 12:48:59 +0000
From:   louis.peens@corigine.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Danie du Toit <danie.dutoit@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: flower: netdev offload check for ip6gretap
Date:   Thu, 17 Feb 2022 14:48:20 +0200
Message-Id: <20220217124820.40436-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0006.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::11)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8218346-6316-4837-7f2d-08d9f213dda7
X-MS-TrafficTypeDiagnostic: BY3PR13MB4884:EE_
X-Microsoft-Antispam-PRVS: <BY3PR13MB488448A74AEBEBB6323B6FE788369@BY3PR13MB4884.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lZPYQ8q8ABmQRmy4psZNyffiRkt6g8lFB66bksShHhyIxxgV2DNLG54gpO/JR6tlKr8p2uX4wNn+fijxOOjsGXgWoIMGaeLe1smUHNsvb9dyVQDJp8xNjQ8W1lMYOP7J9atOLYtYfyLT+Xv7aAykKpigG/U9Bv1AoqeyTqGU30ObVpS6TdRxOXzETR/w1Q/CSnhj7jYTdjVUVCvSDwSUS4tQTJRwqy/UBYV2Z3y0MNbdWMZ790NInkHtWTKSYY+4J1CXtW7Up8SZ2iEK4dWn3v51V5+FNUi4XjNAMWqXbfAeQqfSgl+ZqAqkPXGdkyWa6mAeefpPv+S+70v8TTB8Pc40cm+dYK7FyAzQdPt10RjgrJKBzq0M579H9ZRtobsXlpzzFVuRYthlxlK9IkH1LVJ1SXx/2+CNhWm/qBLzGoqOtoOdU/oDoikql8sLun0RWXPZBy0+Il5Gxmi4agi6vi6T/qjBECtvpTVhnMdouJMiTWblFM0vUSC2O3ZyoBeLwxiiS4pXcO+RBARLXUYjipQ9FHwCsaJnGwsurm4uxUmIH2y1B4hj4DYKPj9ztakyPaB7Mn57SB4g4zPbGLUO1a9lTkEKfLqfIH2TiKrNLvL3/tMJvOoZ0anF/qmwCeBBH3vT/miaTYojx4OlNBdfJQgH8KrGfy99UnYphuuaX58TQWC2DlLfkHmU5J6P5Wg+EcNNSFdI0n2d20bkZBI4mnIAwxzZmTXYuOkC7CAzsPAtvzLE6ZLUlUIQ9c+9qgcrgvN5kO6UiHTdi+ph3vydKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(136003)(376002)(366004)(346002)(39830400003)(6506007)(52116002)(8936002)(2616005)(6486002)(4326008)(8676002)(86362001)(54906003)(66556008)(66946007)(316002)(508600001)(6666004)(38350700002)(2906002)(186003)(9686003)(38100700002)(6512007)(5660300002)(36756003)(26005)(1076003)(107886003)(66476007)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FSxhWp/Zali+TbbTqU5RETWKH+6lL3YjL3EEdtVWqBC4SOuBHnfCHq836k3x?=
 =?us-ascii?Q?dX3wm2kVoZ8jtKrYU8uw7QjxBl1pl3i1BxZWpLFjH6b99Rs42BuM+sQdG8uN?=
 =?us-ascii?Q?w0VHp/FrDRHnyc1iZf0dZl5B3Hyiaf6BnaR7yz5X48uOHwcsqFk7RUIlZDP7?=
 =?us-ascii?Q?tlrnQt5ngxQP1j0t0jd+bmHuyh2ayoz94O8l3rZP6V+osgVmptqptRvsX1qW?=
 =?us-ascii?Q?DO7zHzsSRBmmLEpDsavckIPb1kpdW9dw51LR3ypZWyAFnuK5get8GkgZOWaT?=
 =?us-ascii?Q?X3o5rIQHJgqyL4Tu9IZTpmQ/ePALgWPvRIP/35mhHgE3XRG3KLogp+QiQpWS?=
 =?us-ascii?Q?LdKmaAA3zdpOgt+Wqdpe826urRb+QfeltpHMlGK/uoFajC8NOsCnId4Mgqg9?=
 =?us-ascii?Q?8RSsSbpyKhse/Et32B8NaxNfECKnXW5UJIQpm7BheubQ6vmqHWs3Ya92bsjQ?=
 =?us-ascii?Q?o8aq5KGfjt+0eoX+vR9tu7qD2hVvc7PmJaAelGb9w5MxCnmL8LLVmt+gR/dw?=
 =?us-ascii?Q?ZWJq3dAqxsLcHM1/WAmBtuAH3akBysdLigTnivN7qr7QqICd16pWK8b9qUs/?=
 =?us-ascii?Q?/0RQHAThWqTnExXXwH4vqq2HSX2vIVcGUqtXz4yA0JSGttZpjAqqywIAPVZ7?=
 =?us-ascii?Q?Llf3JEtoYDy9PM3cW/PvEgo5LWYxKPVMuvfUpRa9QiQAmkQzISGMYivAQ7Ss?=
 =?us-ascii?Q?1K7gyEDumlW6YGdVIB08yHPwCWgq7S+ArypoXMC2eOKOFkciQtw5s+em9C6q?=
 =?us-ascii?Q?Ayh7WQvVYKTNwidJ1dKCPq9v+KtrdpWMVqt9jf3IaObK0uEhHlOlRDSi8G4C?=
 =?us-ascii?Q?jmGEbyZrKefBJGllw/R7kUPQCRitJJUb/5Od5fGpcwVmQBOeXogO4szUdnRZ?=
 =?us-ascii?Q?bcktFO3yHEaHP/pETQRJU2i8KIXaBfE0XK9Zau4LCtTZmU45+3iLJXvQaDUZ?=
 =?us-ascii?Q?h2vyyDuWh/ys9UWvpsoTeyMknDfDF/lPngCitfXNtwEo+KvdY8dEojpHlJtJ?=
 =?us-ascii?Q?3rHWOP5r07e47NWw6iHwlB1po5TVuu2NqJ0jM5LuuJS7Th6cXMTwtfUz/9dW?=
 =?us-ascii?Q?j8zZs7QICMbDANy5VVHFCo+xRKmMj3Pg25Nkb0d1axCR+tSVWLmzIIRoABFF?=
 =?us-ascii?Q?hFnpBqtJY7OEyzNWEmfjJZyKAWP/78D9sw4y7rIQw25u9F6oFfLzB83RD47u?=
 =?us-ascii?Q?vuAAEPCCAbRMu5L8kJ0SMOAOcHdGBleInyvEcOMwi2A/p8ZFYZbm8rQXCfQz?=
 =?us-ascii?Q?8IKKA3w/AdGToeb4HpCBrTrrsW8h/CBLtMFsal0r01UG47LHEDse6JKEUEff?=
 =?us-ascii?Q?GrqOw7Dm/ptFJbBiuXhAIOC6ZReKqLmw+PRz+UGG/bybyfemPCfYxPRbZIhn?=
 =?us-ascii?Q?o8gcRrnbAzTJtZIE6/EI8W1VFcPa479Dixyhmi8j1kbBlZP4+PQcZqtgKk1B?=
 =?us-ascii?Q?W/GT63nBplAFzc++CPHSfD3RFn2Bfe3EVpipMds88PTwZhUIIXfoClztwS/s?=
 =?us-ascii?Q?HSGuMifqIxnAiu86empXBsDOFpp/fdaCCefo/IDAPkgzxAnpN8NOUBKsX66+?=
 =?us-ascii?Q?+rOIJcbMhz+VYTx3KTfXf9FX6FgQoRpNZpqchCJbdFfddgFjggFQ1c1DcJRN?=
 =?us-ascii?Q?D4aE75OO/kqWolD7QYlO7ufBx/AmjImAzhMZKg8Ub/5vQ/isGU50kjtyEpaV?=
 =?us-ascii?Q?eFYIEQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8218346-6316-4837-7f2d-08d9f213dda7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:48:59.1052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LZbkUuyONLlKaGcc7K3z4wb7rtcFwqU0JIIiI5/sP+ewlx/BLfBoG64mgaTb5ja+56zuYGJnC5PsqKfSRv751f+B0/+ZUhMkAaSxFtcl1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4884
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danie du Toit <danie.dutoit@corigine.com>

IPv6 GRE tunnels are not being offloaded, this is caused by a missing
netdev offload check. The functionality of IPv6 GRE tunnel offloading
was previously added but this check was not included. Adding the
ip6gretap check allows IPv6 GRE tunnels to be offloaded correctly.

Fixes: f7536ffb0986 ("nfp: flower: Allow ipv6gretap interface for offloading")
Signed-off-by: Danie du Toit <danie.dutoit@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 784292b16290..1543e47456d5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -723,6 +723,8 @@ static inline bool nfp_fl_is_netdev_to_offload(struct net_device *netdev)
 		return true;
 	if (netif_is_gretap(netdev))
 		return true;
+	if (netif_is_ip6gretap(netdev))
+		return true;
 
 	return false;
 }
-- 
2.25.1

