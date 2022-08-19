Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1CA5999A5
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 12:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346858AbiHSKLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 06:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245098AbiHSKLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 06:11:11 -0400
Received: from eu-smtp-delivery-197.mimecast.com (eu-smtp-delivery-197.mimecast.com [185.58.86.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F137BC83B
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 03:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=camlingroup.com;
        s=mimecast20210310; t=1660903867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=f3aDfiEzr3oWo9ZlEFAXLPCOeanUyK+J1yatEfAt9NM=;
        b=di4ThhzQkvuDWI17+4ahRVPXzmhyxlVIUgbzC5ybc/FurEN0pUrSuEKdRx7nveSz0PVMSg
        WzGvoJplhUQgmrMTFMcAi4pbvnH2vRxKxp3529zZPHchM45Y7vVUb2ALMko3fppB6vZN36
        uqM9zeRkuDTovmylny0wvjZBz2EQEss=
Received: from GBR01-CWL-obe.outbound.protection.outlook.com
 (mail-cwlgbr01lp2055.outbound.protection.outlook.com [104.47.20.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 uk-mta-59-Q_EaTasNPH-78w_-GgjLSg-1; Fri, 19 Aug 2022 11:11:06 +0100
X-MC-Unique: Q_EaTasNPH-78w_-GgjLSg-1
Received: from CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1ba::12)
 by LNXP123MB3721.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:133::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Fri, 19 Aug
 2022 10:11:04 +0000
Received: from CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c1af:60b8:39a8:75cd]) by CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c1af:60b8:39a8:75cd%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 10:11:04 +0000
From:   =?UTF-8?q?Tomasz=20Mo=C5=84?= <tomasz.mon@camlingroup.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Krzysztof=20Drobi=C5=84ski?= 
        <k.drobinski@camlintechnologies.com>,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <tomasz.mon@camlingroup.com>
Subject: [PATCH ethtool v2] ethtool: fix EEPROM byte write
Date:   Fri, 19 Aug 2022 12:10:49 +0200
Message-ID: <20220819101049.1939033-1-tomasz.mon@camlingroup.com>
X-Mailer: git-send-email 2.25.1
X-ClientProxiedBy: LO2P265CA0290.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::14) To CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:1ba::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71f6ab8c-2519-4092-b3ae-08da81cb2038
X-MS-TrafficTypeDiagnostic: LNXP123MB3721:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: fWruwAeI2Lb7unzRY7zbwNs5SdCRT9GzVpsFoNe5aZUKP8bIYH/3cHv6B7OnLzJNDy11sEWcLwtNc2G/MAlPMD/V12Eui+RA0mTMJWloZtapbWdrnEzcsgzGIz7Uyr2i2xq7BkdOUdfvRyqxULbyDWMrCRkbpwEzZA0+h8BVx6SsTMfqcfXt58uz8i2Vs7ecOU3IpE9nHRxRlLWiAkcG5JyaOTZWg2g5lQZNY8djIIXDTipRL2NWai004htT7fTQQ16stQ9sgjnZh0dV6rGkcMAYYB9GUw0XisXt49WsmsaDNSF8tkVmMkyikpJJ8QLh/X5Ffgu/L6/CZGDiIDRZYSV9eX3J9p6pykH0wGOYAG/tWiYyqIY4cBLxMDugTycaZDQinoAnhKbzjdaCo6FSSZzZhXzT2bWA2aH87fTu3v2XUIN3D/1F58Pp8yoAtmD/TAUYYI7BqhGVQxJsJ8eXSUpsONDBE6mIjyfmGtyhJ4MguCmHc662czE8CRfyzX7/GxlszPfBWG9b1M6H87GsIRGTgmyCgnP5kyI2urptgbhCAOoNMBq81elt5kFDatkMMEKIpbm4Fcl7e5ZAQ0LhCtuzjh800yxfPOLTdj4yYSz1I0N+Hm9VLCRd4mO3UuX+6UZcJrlXESZ/0fAC2E74+8tA9s8Th0Kcv2cn2sH9yXkahGoaJnCp+fHg8n8meOCAG/V8f3aROCyX/VchBMFbi9xO4aFP7yewTuOt19K5vkVjLPW1tPmMgb7GtcygmkyTuj1D9F39k+p4uB5yvpReVWIsFxQStZJ3Q9wG7AW4V0w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(376002)(346002)(136003)(396003)(366004)(2906002)(41300700001)(8936002)(5660300002)(316002)(6916009)(6512007)(54906003)(6666004)(966005)(107886003)(478600001)(52116002)(26005)(6506007)(36756003)(6486002)(38100700002)(2616005)(86362001)(83380400001)(186003)(1076003)(8676002)(66476007)(66556008)(4326008)(66946007)(38350700002);DIR:OUT;SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?klSoxEFfIn/A7j/wWORJe9fMAN3Z8WLZVZPc+gAY0jdOky0gAOo1tttiFfB+?=
 =?us-ascii?Q?bClJpE0iBMQGLng2tLaQ1ITJZVa5sqgasMPNRgWKWwRNT28xvchG39rpf3iY?=
 =?us-ascii?Q?obQoQ4l8af/JEfuf3By/gV9YpMlzOaBbm+BhAcwI4KTdpX+P1xlqDmKrlfBA?=
 =?us-ascii?Q?6cO9tNh/BGUSwPusNoo0bvRCimDWdwCBDHLyPbU9Mtv2B7sAxexK5HwGmZUA?=
 =?us-ascii?Q?DWX8MaIw2OCyfinMa8q774hIGZUgfP3NpBU3dlgRlVeXt8qtgkq7+UlDIpzZ?=
 =?us-ascii?Q?uxbqleXz3RkvtcbB/RcFZRSUs/iJwAa7WPrxLrY+wE8lDWHn3Ew8FC56ry3P?=
 =?us-ascii?Q?/7NtGncGBzfQa305LxtMFWHtd1bX9PVWq15lDpeIF868LiOaqWgCk7fbp7fm?=
 =?us-ascii?Q?toYA4R2cP0Os+fS8A9eoZF0Qg6S0MDillXAQZgPMG3xfWlRMBMf9/HZfdKKz?=
 =?us-ascii?Q?uHJXuT6Njq8UIqpoXlYX2M3voY/6Cr0KTSYHWCG88rz/waE0jT1Nhl2gqmQJ?=
 =?us-ascii?Q?lVPFXLHqObgoBdjMvYBM93XU46yYYquWRvdknVmjTkB5ZL/yEElNBGq9I87v?=
 =?us-ascii?Q?19IOZJd2BcxbdZtuKXX3TlBzLSLaAreRmn+sBlix5mBnueFcn3VTKrbsCi5Q?=
 =?us-ascii?Q?buk8/rtISoTKIJf2IjN19BVArZ3Sm+nq4smE1XY+lIevrzlwCvmbfBO8cIJz?=
 =?us-ascii?Q?RP2139msxBhEFZwzyhoL3qSt8G32D4vMHz8oSOdy0RBi1xsrgY4ayziPmnMW?=
 =?us-ascii?Q?kDumWGVqDmaKYK+V+UqQbm1NDY7lb5W96we64ja58KJ8AZLF+tjo77GTX1qu?=
 =?us-ascii?Q?j9KznqsucAAnOZiAnUbhrXa5KwT39EcfBgrHGRHzYG6puG07L77iXWat7BOC?=
 =?us-ascii?Q?z7I+H8K+83HhfuvAP1pKs0e8/tvg33o8lNemhhDvnxDkbai/MZEKcCh8jl0t?=
 =?us-ascii?Q?w9wC8kN4PVVufxkJ3O4+t9bYs9o7ffWPlrdm67v3mmV1aKKHCRznRmIBRqCR?=
 =?us-ascii?Q?+yAByEyAJ7n3IAIKQYW4cXWEXYyseYeHCNxgnUhWYEf6gfD7GSfBjmSgJNQm?=
 =?us-ascii?Q?w6yJboONZJjLyLsHRnQhf2V6YxELkH+QqC8h2qJy1FV4WEmiYJllHKHhupMR?=
 =?us-ascii?Q?mS1lnlk8btX2imenHIFox1iDggc0VUKqotc8NgYDMHNHYhs/tzlNTFsOu3uj?=
 =?us-ascii?Q?90f1IQ0A2LQKF/fAJSA6Nsi5sT378F3eW3Nq0rUBzIqjpk+0990ST5C0Sr82?=
 =?us-ascii?Q?JGN3zMlrWJDdIWL6Cnry5DMnl7Z/7/bie8CfUfrMjY9spobWFrlXtw56Cuel?=
 =?us-ascii?Q?3wqiutHNXwQ1KpIX/XVpt1oeWlr+6I8OQV1QmLg1YpdoOV1RYZ6+of/O5UL9?=
 =?us-ascii?Q?kkkMMVUMtCulAIy49GHYZjzvLx9rqxceXhPznC8pTnETweiOOfmb4P40j6jx?=
 =?us-ascii?Q?qs1mVOkhlIJMqKKDzyvaacMLs/oa+Tn43nfPZjD5Ff8tvgb0nHUhiMMLOJOJ?=
 =?us-ascii?Q?FD7XgWYQQ4ObS/F/0jPDUtAsI93siZ+5eguA8MMHSlEXjCUW0xCUT34KMBP3?=
 =?us-ascii?Q?s3FNzysJiPbkxn/5d9KBuOFI6SPwUlA+EfHNcsrfuEqF8/sSK23aRVUzd+58?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: camlingroup.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f6ab8c-2519-4092-b3ae-08da81cb2038
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 10:11:04.7465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XW4Kcod6FSet0Eb2IQitzBCmfQ2aRN0beB69ZdNe+DJQtAeAJaavZJrFF3zWiX719BmvoxgwN0ofslR98I26l3s9rZgrpA/e2DoNVer8QdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB3721
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

Fix the issue by setting length to 1 when value is specified and length
is omitted. Exit with error if length is specified to value other than 1
and value is specified.

Fixes: 923c3f51c444 ("ioctl: check presence of eeprom length argument prope=
rly")
Signed-off-by: Tomasz Mo=C5=84 <tomasz.mon@camlingroup.com>
---
changes in v2:
  - set the length to 1 only if not specified by user
  - exit with error if length is not 1

v1: https://lore.kernel.org/netdev/20220819062933.1155112-1-tomasz.mon@caml=
ingroup.com/
---
 ethtool.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 89613ca..7b400da 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -3529,12 +3529,16 @@ static int do_seeprom(struct cmd_context *ctx)
 =09=09return 74;
 =09}
=20
-=09if (seeprom_value_seen)
+=09if (seeprom_value_seen && !seeprom_length_seen)
 =09=09seeprom_length =3D 1;
-
-=09if (!seeprom_length_seen)
+=09else if (!seeprom_length_seen)
 =09=09seeprom_length =3D drvinfo.eedump_len;
=20
+=09if (seeprom_value_seen && (seeprom_length !=3D 1)) {
+=09=09fprintf(stderr, "value requires length 1\n");
+=09=09return 1;
+=09}
+
 =09if (drvinfo.eedump_len < seeprom_offset + seeprom_length) {
 =09=09fprintf(stderr, "offset & length out of bounds\n");
 =09=09return 1;
--=20
2.25.1

