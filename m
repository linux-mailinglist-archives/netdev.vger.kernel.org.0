Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678A05F03E3
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 06:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiI3EsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 00:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiI3Erp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 00:47:45 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26293CAFB7;
        Thu, 29 Sep 2022 21:45:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJZy8RS0eJLREhfQ/iFw/Fm6LlRDKKz6pCicRKCy2Vy3mOD5ctNqFJEbX6/q9JMprNcS33HrNwShtYxpQLXUAuFGqjZYYj0YlW+3O5NlBQamCWtmar665eyyhbHhaJkNsNeREYAVzannebE2RkIhwOtqOcr+va18l9BtKvm867ohn8MHDA21O0HhbksQ2xnwdq+d42qauzOP373L/0PEirClHMvoOw9X8fHZIiyF3f4Ufe5QGZGUhF3QifI1d6Xt/ZuOLugKsZhrk7clE76286RziCPXE3Ls1IqCT6xE5F4nETatY71+owTqK0ZKNVJQhCXU9QbgewR5PtS8bhYPlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V47Klis+aBrXf+VY6DSS1h4nbNbOfynM4EP9DrteonA=;
 b=PtyKxydjxKuo8uAglF7tF2u9JJmaLFjtphl9yhxeBCs4UnJene9mUl+uo3e7rb5O2bQ+U6BwzLYI6ZLmIb93YZRKpsSqSF8VOHh6HvBJ7rfuD9ZIkg1QW3PhKq9V0Fb66df3/QfzM2ygM0eG9azP3bm9Q0D4JMBQC2VjbzOeUnk8jLi5xww4Fz20QgRKTUsUp4SYg9zlouabp4DWv3XsF0KoaQGevtmD5XVZy32qM44NKYiYarHy1oJN+4mrAeB5ca9Gg1y/N+1MRls1mb6QQ2ITbuoqawOEWKOkQeDJ5OhlIAeNPammlCS5fwhCGpV0gba8uRyaQ0q22YSQja47zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V47Klis+aBrXf+VY6DSS1h4nbNbOfynM4EP9DrteonA=;
 b=UrAkenKizWbocp6XLFKp3p/2l5F2IwdlfrZ+fxyVbi4XVd6FBp5aM4qPLFjrGR3FjGmZf5LVCh2/KRnOfGKsT6XDJTqMt0Q9nU+RTl0+nfYIQgAoM6Bq6n8G9yWp52lOuLtWb+SqH79I0uIQQGUmBSxMJ4V9CQOvGWtyqmouhks=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by DM4PR12MB6181.namprd12.prod.outlook.com (2603:10b6:8:a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Fri, 30 Sep
 2022 04:43:14 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::f099:96c9:82e4:600f]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::f099:96c9:82e4:600f%6]) with mapi id 15.20.5676.019; Fri, 30 Sep 2022
 04:43:14 +0000
From:   "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To:     "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
CC:     "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>
Subject: RE: [RFC PATCH] dt-bindings: net: ethernet-controller: Add
 ptimer_handle
Thread-Topic: [RFC PATCH] dt-bindings: net: ethernet-controller: Add
 ptimer_handle
Thread-Index: AQHY0/zQrGhXct8GIk+5NMkHMGtsKK33YQmw
Date:   Fri, 30 Sep 2022 04:43:14 +0000
Message-ID: <MW5PR12MB5598297D122DC7E2220EF1D887569@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20220929121249.18504-1-sarath.babu.naidu.gaddam@amd.com>
In-Reply-To: <20220929121249.18504-1-sarath.babu.naidu.gaddam@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|DM4PR12MB6181:EE_
x-ms-office365-filtering-correlation-id: 3e361c9f-2818-4667-0316-08daa29e4955
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fu0SR4W7K7XuFzbWeS8eJeUVdsa51ELYQqSc6pBmtkKCs/W9rkcUXG8zyMf4QxbtaiSmwymHVzp+cav9G6rBvurP0zRigDNubmNkBXa+ti3GrWNFjacXT0Bpxs7op4dhXIFYH2Mgdm3pf5n1p66ezTxeO7Pk0GM2thqtLpPww36041APWxWaQAntLL+g7n2heDitgMVrgGEHg/JtN4Tef9yB5xNDYuXz78WG45xUw/kPPNUsftQZ8nUlCgaQ8jRdbHbfvgxxBNaEAo4LidiVrceJjjTScOf9e6NdH2vnxWqhWgw5Zc48/GT/OwCXIqtiHYsnaWfS1vWpNGINs2HskHLj+MY5+P7DS/eHbHNEQKl4rmBk9IhS//+TX+yrWhvDeF01jeHwSwjEI74OkQkofPwKmm1f6QX5/l6ArLAqLQJu7tnNRCfUhAntGQCHf5tCCDb1pUTsyyQKVnir+ES7w3owjrE1hchi+HwPE090WTFW39XtVkzpTupSb++crbmQfg9C+8MbwRs/Gbdd/brPMlcbG7VPf2Eu8n0045QdjaiM7FeHttQExbQ17z+qFUZI3yu1omxD2BkKPVfBYx8SxabMl5Hkvx0u8bP5FlfCkVpq3eZk389Xfx8hr/XRwE/PodZP5YfHZOlr58AJlMj73Z4ggsPbOcJAYCmb5IVXpHnfnf3qQqOTuRXji5VESEbOT6UIcqsX/H2gkEai0kvuEc7Q2gIfjUKuv/AC2i1+dlHrWGU7hXuSGfRNDH0jQF7r4w+k8XOp1yGebUA7AoEk+Hw0Tu19HyaAIzPWEO7B4As=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199015)(9686003)(26005)(6506007)(53546011)(66899015)(122000001)(54906003)(110136005)(8676002)(71200400001)(4326008)(316002)(76116006)(86362001)(38100700002)(38070700005)(33656002)(55016003)(186003)(83380400001)(478600001)(7696005)(66556008)(66476007)(2906002)(7416002)(966005)(5660300002)(66946007)(52536014)(8936002)(66446008)(64756008)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DuSatZb6Obt8nuWQxftY4oZDbCuT82WBZiAg5rWSs5kq2YM9maV7kmjrqqIq?=
 =?us-ascii?Q?DznOUuSyqYaqU8Zutgv+ReeMKXMD0W5eSBW47BmDtXjMvOw1iPgCiKb6y0Th?=
 =?us-ascii?Q?URP7Rj8dzZE86q/MQpdkSp2ADA21nwrWVYIx2JlfdqJOBSjKKOyEX5ltR9HM?=
 =?us-ascii?Q?dYUno7xIYcgVMYVF5EcVRhBvoP+C/RQ6yJ02wWRcaLDWh5glMh8XbO4/zE6A?=
 =?us-ascii?Q?xQcoiDfkI6GVnL8s5QOEO8Zm0zqdRP/1k7NL29nlNWOu7o5xe6Fi8cy3u91i?=
 =?us-ascii?Q?+Qtybnx6vZjJKRgjO/U+ysR03n25XlmNKJ/BsbYZfsXyE4iT0CqkgdmeXfAI?=
 =?us-ascii?Q?zge86eo9aiyv7oNCL2z9Fihsg4nLhVLAmxJe/C8UaU9HvHe1jm7SGfVdmhGc?=
 =?us-ascii?Q?GXVTOS/afqlpiFbK8kms+mpnUUYaYm8y8kHVorjDf07YDoTFJwRZHmuaQQxy?=
 =?us-ascii?Q?of8IktvUHffbn4N+po6wPcwRMQh59Tc4uga/wNcI+LsIqRfGj1dmJLT9Vk0f?=
 =?us-ascii?Q?8O8cTGXH/+kSidkz5pEUdnl/re/qBNFZnwlPa+b1SfgP1ItIa6wSgzOgcfNq?=
 =?us-ascii?Q?NzOQD72EoWFIPSJ9DpB2aVrrh44VKQg56UC2csrIo8jAT5kWObvjDFcteyXc?=
 =?us-ascii?Q?vNiEoybuGmQSuRn8AGgZjM+IUsb7FcTW8hMiJi4Y2fbJsY0yVRadknsQUIrJ?=
 =?us-ascii?Q?J6SidBJd++BXUFDpCjLJWbcQJeC9bDs6ALwbaRgV9ElPxIFbb8VpQ2+pflcG?=
 =?us-ascii?Q?5S+xK+IVxHpYCYC3uvMwPRTIEPYc95mht9OjiBpN56fTqGVVnAyS9PHuO5P4?=
 =?us-ascii?Q?PfbrjVrwOEjgKqOu8+KT1u4boIFnM9eFD99k1f5F+MS2HfpEMEcRn0wLZ5hQ?=
 =?us-ascii?Q?0zQU2HwUMBK1NMXMC6Xae7Rg7HhUCth0USMs1BfiRc1SbTlXQJU04m21+GKa?=
 =?us-ascii?Q?hm9fMdIlEK+mWDcTTuorn/UsDTutqI79OIrD+8dXtKD+hyweQ2OP9nF4fzgt?=
 =?us-ascii?Q?wgDyohTQBQ1QkMMBT23SwNmvQzN1jgIc7FBctNgAzuPiItevzpwiVv14Kac8?=
 =?us-ascii?Q?bcov2Y/STNtvN+hHbjU5SvJK2MjLmQTC9FVx6ZsBWOdUKlwl5Uk7gMMMJxBj?=
 =?us-ascii?Q?aqZFilDN8NoJgrjHb3IX9aXY5TXqAAyGMawnye8g1JyJILqdMMhu0JvF/aeu?=
 =?us-ascii?Q?7z2k83iEbpfPgCTzvjgvy9VtqgP1L78BUSU2d+b8I75p/d6CHOgzwiyMWg+M?=
 =?us-ascii?Q?fBWPIGIE4pIkNQcV92irPos0N1gg2imq5byY9nbwS+P6neE5tp9YfgHIwrnp?=
 =?us-ascii?Q?fr7XEN2lcSMF3ckS1GIl5GnSP6A0/HRMpFjBSUkGDrChqitNgAGKu2CSMb+z?=
 =?us-ascii?Q?Iy30wUQx7veXmxSXfHc7XqYOh34h/Nm87f4cC1Ivm2ZET6n1+LXUzsW7bN+l?=
 =?us-ascii?Q?YYGyVaOyPdRz3cOJQE1oBLeULIZyg2NohU2KbazeNB1nbX0nz7PbTB1S0KsH?=
 =?us-ascii?Q?xPKexcm5p07JStginM6eJOWuLoLEPIxWP1kDkpFxyulaJ4eyDLFGYYZkGLkP?=
 =?us-ascii?Q?2xhDPNjuajnfGxg6lsI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e361c9f-2818-4667-0316-08daa29e4955
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 04:43:14.5030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BTuqdm4DILnAKmQ2qKPG2Bnzt5D1QS39Ek10OhK22mkd+3N/PWbcQL+kIl/gi9NEyzm7gfpMo46unHs0iqYa5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6181
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> Sent: Thursday, September 29, 2022 5:43 PM
> To: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; robh+dt@kernel.org
> Cc: krzysztof.kozlowski+dt@linaro.org; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org;
> yangbo.lu@nxp.com; Pandey, Radhey Shyam
> <radhey.shyam.pandey@amd.com>; Sarangi, Anirudha
> <anirudha.sarangi@amd.com>; Katakam, Harini
> <harini.katakam@amd.com>; Gaddam, Sarath Babu Naidu
> <sarath.babu.naidu.gaddam@amd.com>
> Subject: [RFC PATCH] dt-bindings: net: ethernet-controller: Add
> ptimer_handle
>=20
> There is currently no standard property to pass PTP device index informat=
ion
> to ethernet driver when they are independent.
>=20
> ptimer_handle property will contain phandle to PTP timer node.
>=20
> Freescale driver currently has this implementation but it will be good to=
 agree
> on a generic (optional) property name to link to PTP phandle to Ethernet
> node. In future or any current ethernet driver wants to use this method o=
f
> reading the PHC index,they can simply use this generic name and point the=
ir
> own PTP timer node, instead of creating seperate property names in each
> ethernet driver DT node.
>=20
> axiethernet driver uses this method when PTP support is integrated.
>=20
> Example:
> 	fman0: fman@1a00000 {
> 		ptimer-handle =3D <&ptp_timer0>;
> 	}
>=20
> 	ptp_timer0: ptp-timer@1afe000 {
> 		compatible =3D "fsl,fman-ptp-timer";
> 		reg =3D <0x0 0x1afe000 0x0 0x1000>;
> 	}
>=20
> Signed-off-by: Sarath Babu Naidu Gaddam
> <sarath.babu.naidu.gaddam@amd.com>
> ---
> We want binding to be reviewed/accepted and then make changes in
> freescale binding documentation to use this generic binding.
>=20
> DT information:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> tree/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi#n23
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> tree/Documentation/devicetree/bindings/net/fsl-fman.txt#n320
>=20
> Freescale driver:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> tree/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c#n467
>=20
> Changes in V2:
> 1)Added links to reference code snippets.
> 2)Updated commit msg.
>=20
> Comments, suggestions and thoughts to have a common name are very
> welcome...!
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/ethernet-
> controller.yaml b/Documentation/devicetree/bindings/net/ethernet-
> controller.yaml
> index 4b3c590fcebf..7e726d620c6a 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -155,6 +155,11 @@ properties:
>        - auto
>        - in-band-status
>=20
> +  ptimer_handle:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Specifies a reference to a node representing a IEEE1588 timer.
> +
>    fixed-link:
>      oneOf:
>        - $ref: /schemas/types.yaml#/definitions/uint32-array
> --
> 2.25.1

+Richard Cochran for PTP; apologies for missing earlier.

Thanks,
Sarath

