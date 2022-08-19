Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E6C599563
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 08:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346256AbiHSGen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 02:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiHSGem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 02:34:42 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 18 Aug 2022 23:34:40 PDT
Received: from eu-smtp-delivery-197.mimecast.com (eu-smtp-delivery-197.mimecast.com [185.58.85.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25A1D276D
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 23:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=camlingroup.com;
        s=mimecast20210310; t=1660890879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=shrDe5SX39fYJH5myDFudILHnQ0XRJAb2pOnEsWm2Eg=;
        b=gol88VYOT8Te7DZIXvdUhIgV1OY1lhJAiha1kydop9eYZ7XeEIek2rGijN+gO6DPWCtF+C
        DAAbACWn3BbBu3kY0AKrNx4MWwIVEXHmcGteEHQivP9B+z7Yv3z9nH3HcNFruCHD18AYxL
        xhfIqEBJmm/T1KyEymR2BVy94ECxJu4=
Received: from GBR01-LO2-obe.outbound.protection.outlook.com
 (mail-lo2gbr01lp2058.outbound.protection.outlook.com [104.47.21.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 uk-mta-304-W2OJ1X7kPsOXMvPyuwWLRg-1; Fri, 19 Aug 2022 07:33:33 +0100
X-MC-Unique: W2OJ1X7kPsOXMvPyuwWLRg-1
Received: from CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1ba::12)
 by LO0P123MB4171.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:15d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Fri, 19 Aug
 2022 06:33:32 +0000
Received: from CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c1af:60b8:39a8:75cd]) by CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c1af:60b8:39a8:75cd%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 06:33:32 +0000
From:   =?UTF-8?q?Tomasz=20Mo=C5=84?= <tomasz.mon@camlingroup.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Krzysztof=20Drobi=C5=84ski?= 
        <k.drobinski@camlintechnologies.com>,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <tomasz.mon@camlingroup.com>
Subject: [PATCH ethtool] ethtool: fix EEPROM byte write
Date:   Fri, 19 Aug 2022 08:29:33 +0200
Message-ID: <20220819062933.1155112-1-tomasz.mon@camlingroup.com>
X-Mailer: git-send-email 2.25.1
X-ClientProxiedBy: LO4P265CA0221.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::20) To CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:1ba::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1c233fd-7bf8-4325-172d-08da81acbc91
X-MS-TrafficTypeDiagnostic: LO0P123MB4171:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 7Ct4lbgHdG1gkE8yOmzBn4iqjlkgDE4sb04qqc4eKxZVcSuLc9/1AniS2haZlwAeAoOw51LP3TrAKJWLCJdovGkDz5p4FCkFTCsxPz5goaqWtyuQgqp4DfEb7uc4rPasFRyQE4Fz3hGmHcQuAjucg6ow1/RhLTN89CqgooNHypolmumwGVRtGFPrdnAPOwZpjiMAHFf5VkYAcgu1iJGNbEo3nOtUtxxn0CTSRPnEUbIJtwPYMc8eowQcIl+15I2DbNSGxSGBb40ZRRVhcbJ7PbKvXAq9CxA8W++Sdq5FNINi1N+Nc4kRBmxejBZ2h4+rGR42lhq5VOcxwQbujba+Tpsp2hSVqH36H5dXfnTjs+M9ZjqmjJ9DmXbdpeEf0mpPZXu4d7Hc28a9qomMMNBb8DGBNbFUKwCO3N9nEg9U3EIGYc8DSI8osti5KXi/OGeAqzFq9a9FUc6tDUpcMNIQ9rbAx3A3h1pDJxB9cQbkmaPcVl9RlX/vlFcFNHwl+RYc/RFhQKsFApi0pR0N1Nz5Hn+Vy6cKZ0HppbAZmoIGYsPcJPFYlx7pQm1G9wMQjS+6g2Gr1xYPenfAUZ0gNe2UQ9VlHCwJ9DnZWROKBAHL/kgcTPLc6XBst9C0JPjO09qbgpf/GzFZM5Tn8ubRQJcNdoAMx36U2hzGjjtHmE8EJqKSxC1wF95AqkaMNpsFfxUWe39iJgELVrNth/wSLRbGqofXPetr3qXuyaPtkJQv1YffrVlh9qWtGdN2RkUq9y8Y99s40c/QWRNbOUV4qxbO5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(346002)(39830400003)(396003)(136003)(366004)(376002)(316002)(26005)(41300700001)(66946007)(52116002)(38100700002)(6506007)(66556008)(6512007)(8676002)(4326008)(2906002)(2616005)(66476007)(1076003)(36756003)(6916009)(5660300002)(6486002)(478600001)(83380400001)(8936002)(38350700002)(107886003)(54906003)(86362001)(186003);DIR:OUT;SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k6MwJMuuo97EpmgZ9lls0axJuN+0c+q//Ka45opJFwzLiJMkNek+Itq9exOS?=
 =?us-ascii?Q?vXz/mMJn7TYQpuwP6VTtVvtJyo7tnbc561VzFNeoHCBheiHWJraAdhZYjiwJ?=
 =?us-ascii?Q?nuEpWCs8jA93kv1aQw3KDUAltETznCHi+5Srb/qXwztdyrW0r2rYuzOLkHHO?=
 =?us-ascii?Q?DLTKz18haWowteRxjMunNmSmrZPieMYQ7k8Fl8w9l5+wesfQGM9qRJ0KH5BN?=
 =?us-ascii?Q?9myAIZaetg0JW4ibfyk/MKiLXIAU9nQ52K6iFVKoONc1O9YUHWMg4ULIp2kO?=
 =?us-ascii?Q?7eau9CkuExb4W4jQQC0vcDmsES7kvWF8tqidp5pHYoOrf+O/x6aye6NVmWda?=
 =?us-ascii?Q?0FxWzzkSaHnz8plA+Ui+YN/ALYKAFLKJlszk0IJ68rtj6OsBp79xQouh7PKQ?=
 =?us-ascii?Q?0zFEsOZO/RhJtNnoFHtZ6BLb8jazuHDVGPzvxYY48poq0UxHozUOQcQ4i2uj?=
 =?us-ascii?Q?t0JpxRb9f2eDNn10R8NGYNJVNUruqBTrOkR2VAcb8BrmItu+vyhsQjDRuoW0?=
 =?us-ascii?Q?jkNj+q0kV4w48wg/WN8Jnx5I8ejntt7Gd3kMbRE011VidQrCrV92HHTFCy96?=
 =?us-ascii?Q?2VtrriAd/uIqpOsAncqmLjodMAH4zPVTP4Hz3QFVFlJf62s+47vTkcnNPCCJ?=
 =?us-ascii?Q?H/nzNvm7CQaqKyZurWcp9WzZqt3aytaMzD20YFvX3a5BVzvRiBhyLpkJsC3z?=
 =?us-ascii?Q?VHbF+axK8L/usThRWKL/fa2i+pBg+3X0zv/iDGHDnUPGWGfve1mifh1slMEz?=
 =?us-ascii?Q?G6fXMWOOh4TTAd1HEHqWgBWf2Ura7RQgvDPx6p5dvmCHrSrMUvtHR62gO5Tx?=
 =?us-ascii?Q?l9RHz09LQzZcGiKSFKEyugTfQLiOV4/z3OeYDa8w9BMANye0pO/YRjn8UZFH?=
 =?us-ascii?Q?wi0WU9dTFWexIdwehiIintb8S8aYJDnVrcVERAjTzhe+u4EgvvUbB4iQN4ad?=
 =?us-ascii?Q?l0Ip7j8//ZRzvPA1pOfQxf5fYWlUR+GulXxsSdEU1RQmEEZZBDBLfBjFPRdY?=
 =?us-ascii?Q?pTmLgnZ2pgIdWzs2fRMnb3q8ldBr8gaHQKSBFDC+qnzhQA+RTUPxPOabGx49?=
 =?us-ascii?Q?1ErKS/UX4VPeYcv2Lgi7v389uypFn/E4j0xmp+4OecY6WEok9ac9lK0l+lqY?=
 =?us-ascii?Q?2TDgUdzMTos81JYQh8tf0Bp2GxgiG+erQuPEUCuIxie92U0DS9gkQjIKjLGI?=
 =?us-ascii?Q?qjZUT2NFZWSCbZ4avAD6IwW4rHHf+fcQZD2tEOt3GeTCv6kDPrdTpDyWt+dQ?=
 =?us-ascii?Q?T7hYgc0+drnncLn+OecyKpatzwWkqTbID60Y3KGpvBQ3etXepWRQHUoFYaUh?=
 =?us-ascii?Q?eSC2xerKhh4lHmF391Ifp0FKcVO8yfW9eaup1FpNVqqtBsGQoT5sA8r7SvIe?=
 =?us-ascii?Q?xCFFYOX23zjj8Xwjw1CoN1uRTM08BW6XtbJVXvgLgS6FOK8tGA1wmggJmD3k?=
 =?us-ascii?Q?qrwHES/ImFe/qrxgIKuF8peNQzJDKKuwKXDe0+L8cCiGGArRIxR8uQ7BDxre?=
 =?us-ascii?Q?45lZkJi+Q8cR2cgmWDgbpP5fXADnuqJ5hG2wW7UM0KB0nH5TB/sdFz9RI0O2?=
 =?us-ascii?Q?/ws3QU0m0O6q/01f6dhhihyV3t5WK+4wUsCEXIKpuQfNCC95kRRgu42uLgdI?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: camlingroup.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c233fd-7bf8-4325-172d-08da81acbc91
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 06:33:32.5891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aoBjF6CWZesSLrkfksS0OOt9ykQXWoMpEN9626rj+09Odvpxy4mZAGtUL/7ptf8d5cubuLrQ3rP0gSbV/nzTPPKfCpYSlmJcCdn/0fct7Ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB4171
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: camlingroup.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool since version 1.8 supports EEPROM byte write:
  # ethtool -E DEVNAME [ magic N ] [ offset N ] [ value N ]

ethtool 2.6.33 added EEPROM block write:
  # ethtool -E ethX [ magic N ] [ offset N ] [ length N ] [ value N ]

EEPROM block write introduced in 2.6.33 is backwards compatible, i.e.
when value is specified the length is forced to 1 (commandline length
value is ignored).

The byte write behaviour changed in ethtool 5.9 where the value write
only works when value parameter is specified together with length 1.
While byte writes to any offset other than 0, without length 1, simply
fail with "offset & length out of bounds" error message, writing value
to offset 0 basically erased whole EEPROM. That is, the provided byte
value was written at offset 0, but the rest of the EEPROM was set to 0.

Fix the issue by forcing length to 1 when value is provided.

Fixes: 923c3f51c444 ("ioctl: check presence of eeprom length argument prope=
rly")
Signed-off-by: Tomasz Mo=C5=84 <tomasz.mon@camlingroup.com>
---
 ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 89613ca..b9602ce 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -3531,8 +3531,7 @@ static int do_seeprom(struct cmd_context *ctx)
=20
 =09if (seeprom_value_seen)
 =09=09seeprom_length =3D 1;
-
-=09if (!seeprom_length_seen)
+=09else if (!seeprom_length_seen)
 =09=09seeprom_length =3D drvinfo.eedump_len;
=20
 =09if (drvinfo.eedump_len < seeprom_offset + seeprom_length) {
--=20
2.25.1

