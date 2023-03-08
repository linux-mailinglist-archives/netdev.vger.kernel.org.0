Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F3D6B0C6B
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 16:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjCHPT1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Mar 2023 10:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjCHPTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 10:19:03 -0500
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2112.outbound.protection.outlook.com [40.107.135.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C5F5C9C3;
        Wed,  8 Mar 2023 07:18:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9PBKhxZlnG7Zo4RrCPkG7xZRase0qZCzCMmJVM3zttDx1mpMtd/X/nRDzh0VCgN9mcHapRSPT5jvf/veovL4P4T1Q1lSwGQRrSoZ3p5dGNw86hKx/mbmKW3/pVpReToKY/8knUUJZGw6vUqS8JD8/ML7aT5XmVqCVpD53vHNpj+uhXSH7wWohuaitmpkR6cKQRz6+WrqMSSFmCePJ5prBZiV/Neh6yO9O66WhIIIaWhKMWNuFtVhtzGVnIBeshI6PphzzAKvrrRLdiPAXn5eoocTvkVcF0PhB1Icnb3OaAY5nNb4b1yddbDvN5FDLwq55IlGcqI19U1nxtB1S7Q5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uoY6ynpPmvLaHSleObisjGDUY1ESdg1vSY6p1WAXrRk=;
 b=LFewOpamZP32rQEckU0rTOMRUgMAznSg2jXX/5ut0FQIQMLNNYFVZN4FSF0T++ud6BYtzLUxFpLqw+zwtxBnd1wkwfZiSB4cWAm7VM6rXAt9PPDlSvBhsfSiIgF+BNTcs+GmRMspBtK3OKomPfjJJDdbISZW+7bzWkphhjI/ro6O/ESZ2NlFEYP+pAmfZLAAzvK+7qmvtlWxi0JyKIxTeNUIWqu3C+dIJeoEa6QYdrrwtP6+yVnVJ3EfcddZSDZ6iBX0o2I9EDHHpWRMNKOep8Qqt/i/tDNh+DbHOA02Ycd7TJdj66GVXPUA0C59F61HDveqjk6rn3U9jZura9dCXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eks-intec.de; dmarc=pass action=none header.from=eks-intec.de;
 dkim=pass header.d=eks-intec.de; arc=none
Received: from BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:31::10)
 by BEZP281MB2566.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:2b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 15:18:55 +0000
Received: from BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7331:4276:a6d7:4924]) by BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7331:4276:a6d7:4924%8]) with mapi id 15.20.6178.016; Wed, 8 Mar 2023
 15:18:55 +0000
From:   Adnan Dizdarevic <adnan.dizdarevic@eks-intec.de>
To:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/packet: Allow MSG_NOSIGNAL flag in packet_recvmsg
Thread-Topic: [PATCH] net/packet: Allow MSG_NOSIGNAL flag in packet_recvmsg
Thread-Index: AdlR0Ka7ViCRuFYNTDm8ZA0ECs1Fww==
Date:   Wed, 8 Mar 2023 15:18:55 +0000
Message-ID: <BE1P281MB18589C91B10886A86B26EB6BA3B49@BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eks-intec.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BE1P281MB1858:EE_|BEZP281MB2566:EE_
x-ms-office365-filtering-correlation-id: 0c1d280e-934b-477f-5b5b-08db1fe86ec5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YXlwszA0gYpvkrXcOLcjHpzinxtJKDc+jZnbaxGUOm0jjbd4XsdBiF1WUKfZCou1v+ms+KRDQo0EHN5jVQZyBiJvmflyIrirX6Mb9NbsPDh2/nyAzAirOd6kKhw7gDmIdCUIudDPEsmQEbW5k+KJsfFOGnAhsd79qLY9dskB3J+mT552W10VX8LKKAownN1HQeSKyMvy1X5XPZtDbNEB24ndW/frDMd6DF/8VMjQ4nJBDOHrP7r25RFpF438QB00Vd1IzOOOGPQT7XoXSrfezH6jbKBRhm6HRbLi+lK3l/23B/GjYITrSVlqyuYynCCoI0OnqYOB4qIp5w2F466IY5Wi2t/r7VoT1e5Oz0jxhIsVcLGWOcGGlr3NMUoJSCog8NglsaQSUKcfk+BGRghaM9+j86HKOX3S25l3BMB0zmM3oj2sPkyjeAqdpPQSMLK8L6aZTJpwAKXvjgKNkPSW6Y95xeHM/8dhZhj/sStvaBTrCiB8rnAdC/oVwkryaMCO0A9+Dl78sDV32pKRtRKZBa7ys470aMJWuAglrHiYXTakbcoBx2n63NpZmHjKquEXTPECsc7wq639HIv7273HYD63JKx8QFqt617d/gD/dKKybdMznnyfqMhAM1Pd+PbNNs3S8n5UGjNSpYk7k4S0kUZ7W++FR/uXYnAoOUTm6s+R+Xe0H6PW/TFcRYY6zIdcHuHInGYPNK+YsNUJuA1phA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199018)(44832011)(5660300002)(2906002)(8936002)(52536014)(41300700001)(8676002)(66446008)(64756008)(66946007)(76116006)(83380400001)(4744005)(316002)(54906003)(4326008)(478600001)(6506007)(7696005)(71200400001)(6916009)(33656002)(66476007)(55016003)(122000001)(26005)(9686003)(186003)(86362001)(66556008)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/3tzcMWp7neOv2U9wenUhLvi5XiSxv3Fdpnk7eL499wl27IbppUacAtJfz+5?=
 =?us-ascii?Q?+zi1isEqAo0jFgDwSoUnP0UubMkUDxzKNu6S+h3tsGjJ+S1H45iKQf9VsfKu?=
 =?us-ascii?Q?dWR2ofJikFH2Eiir73DiqsPuZqQzB+hWbwXL3IphNqzNJOJegbN01D8Nj2mo?=
 =?us-ascii?Q?m8o24S0Pu/e5DCoqyci+fB4vYftWLsVyo2z31M5x5b38HU5qxtomRhnhy2mt?=
 =?us-ascii?Q?edjJPv4MZlRFdlDPYH8MY1tseD7FyagDqKNGPNa/NA08L0s8a9A8oPFk/+n7?=
 =?us-ascii?Q?czdeSTHd6b8E+sWX7WKIc9m0xdbaRVwD0A/LVvgej4fznIvjr890Z28TqDWA?=
 =?us-ascii?Q?vgg2W/QMISHkW4faWx6v4oabMY4yfHZT1TOZAS8ipRu1ufhAG6p+j2lRTLcx?=
 =?us-ascii?Q?flC1WAzEgaf6+eKto3jgrR/MRj3mDEKfmaZ5WRa1C/aug7GXoKXqASBTAHch?=
 =?us-ascii?Q?uyDyFLixSElMdhdUIdIX9zbv6t2rHP168HOYd+euyNF9miR4oHwjItywct7T?=
 =?us-ascii?Q?pTVbft8laRBE0PWz9vfxQXNqigVSWa+CU0m+I26c9Q8jmW7ZGTMuDbOzq78V?=
 =?us-ascii?Q?84VABzqTX1iVcFP+rNH4SDaOhVAT29RQKFU8uU0+Ek6fJZUEj4OfKcOqqDbZ?=
 =?us-ascii?Q?6mb84NQwfEz50VkD2fvjJ3L0061g1rHDyu1+xG5AjPw8KsI+Dfpw/BThtRpw?=
 =?us-ascii?Q?u9rsZ2LSVKTYNeW6LuXp1Q6euGmSdzq+0R3NaM7mEkON3dPN1fSiF2rTILXg?=
 =?us-ascii?Q?YyQORoUST7SYodLUwzVN+F8m3xxZQBUa2Qb+XmvJfC1EV5bX6jrbZynsX7Zb?=
 =?us-ascii?Q?EQWlKTvqxlMjjco/6J6pQd64d1D+LPjeRDD6iq4hr6jqmWlcyk/zMK6kAAwF?=
 =?us-ascii?Q?3Auviu8VXjMcKmEtDueTrBzaj5oa2WmFeW4W0KffPTWcIZqdZjaCdB0X/pHG?=
 =?us-ascii?Q?6zrGfCer3JsWLxhtzWd75qAfo/57aP+nSWkato7FajS3J03XpvKygIMZ6Iaw?=
 =?us-ascii?Q?2gpa1sEpQtJjk907FNdxZ2ygPBcUyc5MsISiv++qya2puoK9VaR6VzkZWEVW?=
 =?us-ascii?Q?VmHi0OvbtWjdfXsy3bc29ZC20J30r+pr66r8DSzve+r/v6uhdxdlXu3CoPnH?=
 =?us-ascii?Q?tCFWKEQbikBwV6j3VPiFpIBvImVxXTVSmxMGFs4vlDT07QXlxyyO9Cb3tVor?=
 =?us-ascii?Q?Lr72R142zVy5DS17+uSLGi75953OFZZ8P6Op8yMaopVfaBgTsaRRQhwutDPI?=
 =?us-ascii?Q?TvjHBubMxmORzofuwJ2h/APKJmXsRKgWsPbNrW9OPfnnUd3vmdqxo2rub3ca?=
 =?us-ascii?Q?LC0o7bM2/MShtApi8UK4/JpTHpgk2Rp2aA/jvuQQYH3x/hhUgsltXYYlo1W9?=
 =?us-ascii?Q?TugS3Nq82mZevkdbcsnE0UUkT370rXE39pg/AecjFo9rTGrumQ33gRIHm9M4?=
 =?us-ascii?Q?mp2YF/jPHFhOI305160iJJ/U84SqMsvVrZESb0x32tsX8Vjd1E3NESRO27rE?=
 =?us-ascii?Q?QA/f9bNcvy0ssP9j9IR8itfW4+OobjGbTjUhJZy++/HbGoU0oeom2BPedFXz?=
 =?us-ascii?Q?ytbXUCznQiJzstV6N+/kyautyO6lM6CQn0zBcGQ58y50N4XYMZpYf7pRBqdE?=
 =?us-ascii?Q?NA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: eks-intec.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1d280e-934b-477f-5b5b-08db1fe86ec5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 15:18:55.4202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 24a4746e-2db7-4bee-9bc1-9d6f336af481
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xZH0V6+wTS1vOR0UNOOJIcqh6AG6vkYjXUO25Cii6QrAe6bmAtrcm5SKLehGxxVpJIv3EJGysOfGbrt6GMOtGTFv8nYE8pPvkQc7/N46v9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB2566
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By adding MSG_NOSIGNAL flag to allowed flags in packet_recvmsg, this
patch fixes io_uring recvmsg operations returning -EINVAL when used with
packet socket file descriptors.

In io_uring, MSG_NOSIGNAL flag is added in:
io_uring/net.c/io_recvmsg_prep

Signed-off-by: Adnan Dizdarevic <adnan.dizdarevic@eks-intec.de>
---
 net/packet/af_packet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d4e76e2ae153..5ce62194af9e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3410,7 +3410,8 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	unsigned int origlen = 0;
 
 	err = -EINVAL;
-	if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE))
+	if (flags & ~(MSG_PEEK | MSG_DONTWAIT | MSG_TRUNC | MSG_CMSG_COMPAT |
+			MSG_ERRQUEUE | MSG_NOSIGNAL))
 		goto out;
 
 #if 0
-- 
2.37.2


