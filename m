Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4905146B1
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 12:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239092AbiD2KZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 06:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357558AbiD2KXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 06:23:39 -0400
Received: from GBR01-LO2-obe.outbound.protection.outlook.com (mail-lo2gbr01on2098.outbound.protection.outlook.com [40.107.10.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F28731346;
        Fri, 29 Apr 2022 03:20:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7azKTiSbQoKKb+NLSi1gQGixG0RKrM7drNeCppOyMD49tVELMrAECVIu19WptvavM+XnbGlVh7puieFcEdSbMSgXRzmYzQ9M5Zc7k+lNMCUw+PcOEm9fkiikhuJdLbQx5HVgavEv7SsUE8v5fGDuCS2bJ0oGMwX1XQUZCCDlZVaeej4c/6EaC54hJVm5lNziEAvmboua01jOyFPXFBmxNyEAB0CQnedOv1fs8O0XVkKjA5osvnmIzjRdpCj5r4dVOwGvrKxrfDB8fxCdSL3hgiahQsKo2FJYt5RiuoWwEaWjtAKNMI2yh7vmbSxkOHOr3Q1I8jFFj8jyINMh4eMGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNbXHk7fL+FRZYKIuLot1VIOv3irzkr3eOdE4Z1zpLU=;
 b=F2Rf1PWjYkwZo8O4l+JK0+KyvQ/X0SKonEFNulf3Lr8JGaM1SwkteSzCW9VS3Ln+tN2j19tQI6CUQUvhPSAW7CRNKxCXyrI5+KQ1Z2XFVh1s+8V9+eNiuWwA1kgnGbgFTRn5y7t5MArcPB5jLHBzBYG+7uoF1D8dEvHWDwKQnTHh1zfw4Kkzi3hv6rSo1e2v6aGsN9klQmEOgAGRJLuiad18IQmFK17IRSWq/VZUUvFJM8yxrlOeKVplNOiw3qKHi4eztlrAOiQrIVdNnMZN3wm5mJiG/0bgaIHldCAJqvOiNadWwt4rx1BlhpJllh6GpJl4CUlWLRXWea31yUh9pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=purelifi.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNbXHk7fL+FRZYKIuLot1VIOv3irzkr3eOdE4Z1zpLU=;
 b=WMk8NyM8VmmLrX/jr6wjMQoVIa48+ljX8PPtuL1Qnyli51fpQFs03xi7U+n/0poRE6s8PrVQ7dhjqxP5o241/sQQu0GcD0IgrlDuX+dj+9mNnWV7lTF7SviiCl2s1Ym5R5XHQ/TVfalbpETpZBETMdx/JLEKMHWBekZDnfRdiwQ=
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 LO2P265MB2750.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:143::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Fri, 29 Apr 2022 10:20:11 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::9d97:7966:481:5c10]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::9d97:7966:481:5c10%7]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 10:20:11 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix le16_to_cpu warning for beacon_interval
Thread-Topic: [PATCH] Fix le16_to_cpu warning for beacon_interval
Thread-Index: AQHYW7HMb3tdzTJrcUa/Lk1mVof2ow==
Date:   Fri, 29 Apr 2022 10:20:11 +0000
Message-ID: <CWLP265MB3217B3A355529E36F6468A43E0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purelifi.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 456986d8-d3e7-4213-62bc-08da29c9d814
x-ms-traffictypediagnostic: LO2P265MB2750:EE_
x-microsoft-antispam-prvs: <LO2P265MB27504ACD36B4BF2791324F78E0FC9@LO2P265MB2750.GBRP265.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a1Mz/D0AIdB1iZ9mfpL2rmoVbWVsxXQOhvoVrniOJRFYCcy4iMxanATvrG5VTfavc/8ok/1FhEvcpPfpnJ2iRo+3eE2XXC5I8hTQkKm2VjKOB86q+rU52/7+totWUEci0x27yMEOoUAbcE8JalkFIqH7SaNRBprvMHOmrAdhZd9YJF9qKGn9G/biqOw/XgWvMIVxQSMiuDgc+S1yzxBppoaMSsXQtgZ+VPn8aVmd3BdATkM+l6IRXsHhiZ8J0CHey2l2leX7l6IJIEH9MExaMG623PM0iTZrSLNzAQR1F/u7PSSMZ3gt4r8dIpvcFnQllni91Htr5+5omFxWOUbyrG1UeezZDha2KS3a7iqWWa75tLfSM98RO9xlChJPKYG+vFxy9wRr4n5RN+xz7MP7Oz8VqwwwqfjRpJQNOjOlpvca4prEptvIwfl0p9HeU+PAGDHJcs1WjSbSb7ct29gdJn2hqo04UZ0B0sZOJdzyHiTMGBwhktpvEToB1CRYMVENYbrUMMAws96EfDsPvCsexLHYsDLBQpF4q2OtD5WnrrMJ5qxEqkpLOKVG0Oc9/twaxYXiobMHez/3atWER64fi7Ip4o04mJTu38Imh0bKkX1Dn6GzNmopHjja5l/2J1npAsqsRjpP8SVYYni7iG8q1wKZ9uKrqihJPzp2lUPebGXt4Neijn/cZWFFc1gPhTzt21PB/XwP7zmwG17h+YWCSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(376002)(346002)(366004)(396003)(39830400003)(6506007)(7696005)(9686003)(86362001)(2906002)(26005)(508600001)(52536014)(5660300002)(8936002)(186003)(33656002)(38070700005)(83380400001)(38100700002)(122000001)(109986005)(55016003)(316002)(64756008)(71200400001)(66446008)(66476007)(66556008)(54906003)(66946007)(91956017)(76116006)(4326008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?7xtqNdTEhiaamVgtDpSOSwjPBZM5nsjyaDWuG1OF6dAUBHzh9me5EhAGJ6?=
 =?iso-8859-1?Q?7ibiMXmZG6tH+sawl2As/VS52iM5q/0C2EdO5cGQENUsEaQj9VSL34xkJK?=
 =?iso-8859-1?Q?gi4au6qnjVCpqKrvPxU29qdAipgr8CACO/2YfAcMGiPG9BztqkguArkGsr?=
 =?iso-8859-1?Q?vyrQ5oUJyjBP/vLyALNcY60y+x+kfE5+fETDbMq5alFRRG8fmQmUePPmY3?=
 =?iso-8859-1?Q?HB9uLjzuYyDj+roZhSQf9fEEKhEpm56BSLrgoZLsQQgqeqjeQFCLxgugHa?=
 =?iso-8859-1?Q?sKam9eZhfFb51+WDzbIQrOKk1YWrikGuWkoGDzK9k+t8QLOffVhf4BxDUS?=
 =?iso-8859-1?Q?C8PoFABEdDrKY7Nmz7mvt6MVdoBeCLC41ok4opET888AmG4Kmhq8OntFIz?=
 =?iso-8859-1?Q?5nJ9aPXFGVMspkAOWZuK4QwpBC72rxforJ4zz3jwo6tr916Dto3qlU5N17?=
 =?iso-8859-1?Q?s/ixbCmwVamvZp/B1xfkq9/XK2YVaOP+98YII9aSKc4oSfjWAJj8tmatFw?=
 =?iso-8859-1?Q?MWjkJeIK7zmk33rq+ehD040917HOe9z0pKta3xpbgq+JtO9Zf0hA1xM3Cn?=
 =?iso-8859-1?Q?34KT+2bWud2SCAJts1NiHSJ1G6tX4c/eER+/d81BlXpOKuZ0eEbDNDFELY?=
 =?iso-8859-1?Q?pGePLqRxc1fKN+J8zhV4sv+n4+Yh9BECJlMVZhadgfq6btUXU7fCWKPJTV?=
 =?iso-8859-1?Q?aVCOkte/JMZeuhtX0fbizJ7EiCNS0JdDzR+rgtGJp3qfi+BY53zfbOHF/1?=
 =?iso-8859-1?Q?YlbbdluSqIHNpvcY7fsn38cGsGt+5nJiefAul7Gl+0eNyYIqEZVdCH+SHK?=
 =?iso-8859-1?Q?hCWfEHDSY4g3t7LJdIW0+nrRwTiMHhq32Lr6834JQ4LsZ+Qu5VwKea8O6V?=
 =?iso-8859-1?Q?rzzbdHuWmsUGKOO/ZFMAYRuj7aB/fM2k9eo9PLBspfnBTLUQSg/B46PKdt?=
 =?iso-8859-1?Q?k9qEol8oYgTmCMmaxxluAw+8YkwuTy0Wf+uM4pYQIis0NF2Ig/Zp9fmgS+?=
 =?iso-8859-1?Q?pgrYJ0tik5zbxsSUT5UqTO6YbKenOSVVlXZly86jqF3Qr920NAykZR1yV+?=
 =?iso-8859-1?Q?1DpWQ+Y1WZs4Ru1+6I/QTDjfpcYwmVXGZtNtzVHPfFLjivfow6oW0Oynkw?=
 =?iso-8859-1?Q?2R7mfgTbrt+2DNuZeUOLk1yPPeVeE3HKS6+owQt9f/pBPfDOrUAsy3G0kt?=
 =?iso-8859-1?Q?+QwGR6N6iocOnbufsk13eYPRg9l0vmGyvh82Nsd6VX/N/xb4AqYuZ+1GbQ?=
 =?iso-8859-1?Q?3rBojViMEtj6eT1dDYNoUPYuYfPEJkBCCNOQvSQ2As3P9toz9F/DI7XE1f?=
 =?iso-8859-1?Q?VV1ldieDuyRNe0prZXLU//ZqUoPTURcxxAxkk00TrOo7yZtc4XmnLlzWX6?=
 =?iso-8859-1?Q?dAT6Hlzk+mze9nXGUuou8y29ilyy/JH8O8hs5P4V9pdl/PwkJhhhU/9ANn?=
 =?iso-8859-1?Q?OROKu3NyKfdCkfD5fM+X9kPv1Xdm+ca5KNIVDu9qrMqcpajMMgpVIoqzuf?=
 =?iso-8859-1?Q?8zemydazDH5f3vkdZB6HMsJuY4h5M6/xY3jVX8QoakP3GsPeMBIGvtygk7?=
 =?iso-8859-1?Q?z5lgpagr8eBKndeK+c8qxfO9fg7465KN0pALRQ4vnB6LDqiUZmVUSeZm1E?=
 =?iso-8859-1?Q?NtesS64LUYBBNI7t8EOki5Qhpg+CBylrmz0Wamn4oMvzb5++w3HKKqfNGd?=
 =?iso-8859-1?Q?W0UZBy1kyHrfwbpXHXOlfMjzBcK8eg1Q5L/sFFbfHzuYD+ugZqmMaItS9r?=
 =?iso-8859-1?Q?180OekGjbveVfhvT8HKXwijuSYjP0sjShaSZVUf8hcHlXKfvlS5FAuEGH1?=
 =?iso-8859-1?Q?8KzNOPyFsA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 456986d8-d3e7-4213-62bc-08da29c9d814
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 10:20:11.6257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TutvYl3MlQnZMykT4SeS8ZK1+fhBsIll9FKUpDzJnRm77gYKIcwe6L1PBg1RmFe7FMcjgy+TkY00Iab221Ehww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P265MB2750
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed the following warning=0A=
drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: expected unsigne=
d short [usertype] beacon_interval=0A=
drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: got restricted _=
_le16 [usertype]=0A=
=0A=
Reported-by: kernel test robot <lkp@intel.com>=0A=
Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>=0A=
---=0A=
 drivers/net/wireless/purelifi/plfxlc/chip.c | 4 ++--=0A=
 1 file changed, 2 insertions(+), 2 deletions(-)=0A=
=0A=
diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.c b/drivers/net/wire=
less/purelifi/plfxlc/chip.c=0A=
index a5ec10b66ed5..5d952ca07195 100644=0A=
--- a/drivers/net/wireless/purelifi/plfxlc/chip.c=0A=
+++ b/drivers/net/wireless/purelifi/plfxlc/chip.c=0A=
@@ -30,10 +30,10 @@ int plfxlc_set_beacon_interval(struct plfxlc_chip *chip=
, u16 interval,=0A=
 {=0A=
        if (!interval ||=0A=
            (chip->beacon_set &&=0A=
-            le16_to_cpu(chip->beacon_interval) =3D=3D interval))=0A=
+            chip->beacon_interval) =3D=3D interval)=0A=
                return 0;=0A=
=0A=
-       chip->beacon_interval =3D cpu_to_le16(interval);=0A=
+       chip->beacon_interval =3D interval;=0A=
        chip->beacon_set =3D true;=0A=
        return plfxlc_usb_wreq(chip->usb.ez_usb,=0A=
                               &chip->beacon_interval,=0A=
-- =0A=
2.25.1=0A=
