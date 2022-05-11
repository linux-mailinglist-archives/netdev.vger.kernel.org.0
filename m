Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8318C5236DC
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245628AbiEKPO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245622AbiEKPOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:14:55 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10067.outbound.protection.outlook.com [40.107.1.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E1920CDAE
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:14:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSb2OiPd6VGk+/SdzLsu4L83SBvIIQrM1ky6pyN5oOnFhdB3K4P7hDDcSVusA12VzldkvOAFgyFAnziU6Rw/5d+QqvzkT+ewM3fUvfuUyQtxQ+akpP3CtDIStkq6oOoRQ7HhMg0cJR28SnFYfMWvrpyb3qRcSrDjgacSjE5BOkj7C/SpVQHl3HiyjCRagJfzUaw9gP64n4c1iQXeF8c6LXWSgJkKscWN0JYwPMY4uI1y51gRH+XwucpcRzJIkQMdkVX/i+adXqDGHfGjbFJgc6WX9nEJoPENuGl6g7+cSE/p+ofRXVYUUyhsB187m6sZ7JkykLIRNt/+/V2hP8DR6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uMVSrGe+PNHQtjKcMpsP8JNAi9rf2ErzQhv/I5IGoE=;
 b=Fw+krl8+r3sAjpWE7P17tMRWXubccddKkHyqnfYoUlaUM4Rk1dIDmMOtgPatx84jrZdst4erxie3go0BKu9PB4/vbugFFvvaLe036TWX+2ao6NLCrakHGHvTwcwHV4YD9oQtv331zUGsehHC/OMlH4XkEmK6RemlDhYfsW2I2Nxhsg85MNiuOExI50xuSF3Qhx4FQvce+h7OAXdlbk3EHrXbISq3vn0P7I4lev7GIJA/5NA6PWzrBnWFzn+8l+8wHtird6MSfeRpvpNT8TONKRt8M0pnwcqJ6v1mFKgzJ0vmBLjEEZ0OUiMpUhK0Q306vnVfNA955whCnKTAVuFehg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uMVSrGe+PNHQtjKcMpsP8JNAi9rf2ErzQhv/I5IGoE=;
 b=CopQCBvpqmDecgfuXzEw4WOf+TSTv5iGxSD+sR3JYPPa1oM8IL1c6eFr8uW8DCGQ59GISbuH3mmmk1vG1zwRU0aZ3l+Caip5KMT9gjVWycuoPjLOYELw/VIsRnTVEsJ161Kksd8tgWVp7tQVaUtLqKOHHQfw6rViZOyHjrsS80s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0401MB2300.eurprd04.prod.outlook.com (2603:10a6:3:29::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 15:14:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 15:14:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 5/5] net: dsa: tag_brcm: use dsa_etype_header_pos_tx for legacy tag
Date:   Wed, 11 May 2022 18:14:31 +0300
Message-Id: <20220511151431.780120-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511151431.780120-1-vladimir.oltean@nxp.com>
References: <20220511151431.780120-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95fb6c54-4412-4b24-b127-08da3360fde3
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2300:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0401MB23007154705583530D00982CE0C89@HE1PR0401MB2300.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s6gUk9jFyAe/Un5ZcWdE6cvUpIcj6G3qb8NuYyzDeRx4P6HtlIhrGDuiXj22vDX41IiOpR1YZQQTHJAzBOzxuYIuNsWMEKx5Zjz+UxpZN69mr8RdAORgH0kywqIVX78srLJwfiSM6+JagAsuQHnxvmYK436aTPUmFFjuG6ntsnXqUBsuPQH5KkjCqDuRo5XdChL5IogKOY3YiqxwIXgcvxv/t/CHPK0QyegANCO4pQwYT0NQAIfpl587mRHWWr+N5b2srCGYO+kNvi5Bgf93KEgaWbMvme6+B2eVqgny4+1l1sPPo6bCayl16uTrAws3DSkHoAjvhBSwo7yyfQTAQnROf0Iw2J6Ao2tav3o7GvewUdbqjYrTq9XGISXzolsuWHM4s6qXnaOVPPWKNBNThbtUi/AZGDF66fhPjMYfTOMLwKcnddyQUUOfGJCBHnfJ497R3tRM+E7CZdm++QUAFlKE3qcZyb+hJp2XYpUZko7RsypC4x5Dj8ON4Z0JfJfS9cVcIJ/6T+25Xj+XM9qmPaShGagFFUCimXfXFcZcHA4DNPLOSYLbe8KGRsTBsA/wInJjrnLxUd+VYdAlYWyR32y4mGkCoWy/Dp/EpHCcKaOmT6RTo20V0Ed5Hx8R/4NH6KKAgpgvRHcat82Jxb8oDPNWAJt9ySdcMoXhDVKkL2Hf65p2QLt+vqhekj/iaWpawLATeO5RHqJpD94dtjiZGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6916009)(26005)(6512007)(316002)(4744005)(38350700002)(2906002)(54906003)(83380400001)(508600001)(8936002)(8676002)(5660300002)(7416002)(38100700002)(186003)(6486002)(86362001)(2616005)(66556008)(36756003)(1076003)(6506007)(66946007)(6666004)(66476007)(44832011)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o3GhOibmkgKQp6VACPd9dqCUpMxLc3QdjyUZbebSYDYDNLDaFaze9mLHqb8m?=
 =?us-ascii?Q?PQ/pQgq4iKON6rI62+uJvdYSFsDf1utCxGu6I5wlMCTNAWtqBwj78YGERRDN?=
 =?us-ascii?Q?QkuUAkFDY45mfcps0f7WyTy0es8DppWT8R1zg6UL912gKknKnH1hsrfYnz+B?=
 =?us-ascii?Q?CABEdp4afLD/b08K5SxxuRNNt5In7fKI9mBvXk6PU1bits8tP2euUDI6I3Xb?=
 =?us-ascii?Q?RfXJHcP+LCCr5MvlqMm4vWS27O2/JuKDi2Z/PNUK+dULxTYDVJg0tE6tUqE5?=
 =?us-ascii?Q?/hqms5sxmN6oGQQfJg0CysJi0uYKvWHIPPXM2QWdUoUxnw36ZPrm9PXg9N0j?=
 =?us-ascii?Q?FglwzcsO0uQUkhHI6S/S4uoeHavu6AkeiPo90Ucai/Pv/SNpfiOKQAQ7oajo?=
 =?us-ascii?Q?ZdJkADbMDptdx4oYJnDDa56bMPCuzmGnhMS3YY7UizAHpz15KnBtB1UlpzTa?=
 =?us-ascii?Q?UETGLbhThWx/JdYwWGQHqenID64clpIsFkgkUCa8Bdh64j53T4/3jytW2R3a?=
 =?us-ascii?Q?Zg5n1ZxtxQ+5tg9HEbLyjxEBpITiA4U4FMGCds5c5HPyeyFFrZHQ0kW764oZ?=
 =?us-ascii?Q?tNA/5rQQ+Cnka/UsZwKskGavYOYqDCSWOiEaKLW5bnsft+jmrvfyaKzWae6x?=
 =?us-ascii?Q?42rlUsP7x5lh9qXf7lwW9kUIGjwTZRT2L70lMeEuQFbDv5DZxVpYz7yTgGIR?=
 =?us-ascii?Q?7sw3COv2sFawwqB6PgQmQJiRUFHynTA09D99EL2gR/+e6JVuiciwg5Py59B7?=
 =?us-ascii?Q?ZpF3t93925zxYZ7s1p/0suKYgg6mpjlIlduQnwtxsOpmGQYnWZsNWFLAYy0L?=
 =?us-ascii?Q?oP+dg2E1MuQE/FvL2sV/TsSSpIbfOYz2/PAIZ9fuD8Z2wZZFORHSQIg/02Nk?=
 =?us-ascii?Q?kJhgSE+S6nVDdKlXW7PkSyh+I5+4mnXy1jt3bJJdh2nDbMGy4bEgV6h1hn7Z?=
 =?us-ascii?Q?I+1ylGDFn+0rd3Fw+umHZbnJrG0irjRsJDq1Ns5ySDLuFLDbR4SbEJa8ytPD?=
 =?us-ascii?Q?AwdNJRSSUkkHZND/HrRBEK7WlPf1EtcJC4kVww5s+m2fpKUE9Ko2hn1F905F?=
 =?us-ascii?Q?rSoHqmXGr6ZnKQQdbpNYVMGrUD0fIPRZrKSok/el7cT8qeSO7++S04LnwNFh?=
 =?us-ascii?Q?BDJQllKRSRUvjZacglrEmjLHPwCCbOhV4pdHwyCG3L6ObH9BoK0GYW/GmfoS?=
 =?us-ascii?Q?PQS4nD+sd8IYiwPK8ohMYY+jJv3nznE366XgPDr8BD9+T6zcVUXTO28Gp1Pn?=
 =?us-ascii?Q?ixf50QTwGV37i+3ks6F+NFXBNvCCTYZeQC5hYKk9wQD9Yni6fN3jGXaVi2hm?=
 =?us-ascii?Q?wyAveX1OkW2mvefvdBi23k2QnXOIOIzAM+GoSJ34GrG+3+FbJfZNv8uNTMxj?=
 =?us-ascii?Q?iryLmulba0x55L7Ihd4XU8Y1L6/POD0lEo2Mt39AGLtmcMDn1rt/+n5tQqqf?=
 =?us-ascii?Q?YB5pbE0ImiX2+Twi3bPjWC0/k1iScRicb6DLDLmR3wCMHfxMs5d3Q7JY0BEY?=
 =?us-ascii?Q?E90NeuPzGAG7tQAfxXF4xXW/d7OV50CfAhza+8dcmrHaAiMCUz0wkQXRvK+7?=
 =?us-ascii?Q?PGoJps88dmsaDZewknkIX5NkzWz8zluGTeWJkQNmEXW4X65FbW2THYsk6DVI?=
 =?us-ascii?Q?1inQjLHL3QKlUqjC7EFCRsOZbCr4j0fFCGzCGOI5x5bA8aQXcyCyg9fA1cFy?=
 =?us-ascii?Q?Th4ZOGeSxo1TICNf4tNDgUAhDdYMLmmUSLj/Fz8zGlD/DjDVukHYPMLjZZck?=
 =?us-ascii?Q?YjvL/z/g1g0YSypoD55PJBX/VjnLhLI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fb6c54-4412-4b24-b127-08da3360fde3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 15:14:49.7812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m74VG2aFCXhX+FfClPHJzp8Mjy9TXfP6pC/VgBzoTfTk12kOIIxsjBr5ZFU6ScULXRzkRe12JxPXVMXAG70Q8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2300
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the dedicated DSA helper for identifying the header position for the
legacy Broadcom tagger.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_brcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index ac9cfd418948..9c33eea96007 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -218,7 +218,7 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
 
 	dsa_alloc_etype_header(skb, BRCM_LEG_TAG_LEN);
 
-	brcm_tag = skb->data + 2 * ETH_ALEN;
+	brcm_tag = dsa_etype_header_pos_tx(skb);
 
 	/* Broadcom tag type */
 	brcm_tag[0] = BRCM_LEG_TYPE_HI;
-- 
2.25.1

