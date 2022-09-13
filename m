Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC285B678D
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 07:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIMF4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 01:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiIMF4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 01:56:31 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2093.outbound.protection.outlook.com [40.107.113.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64BF1EAE0;
        Mon, 12 Sep 2022 22:56:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxexUdwex2xVCc6UhZea79kvHCia3N/Bj97uNMC1T7IrkTQ3P3oOXCbEsVEboCbnbxmRiMQFFcKfxwEfsJUweBNyH8xMsPc37FhoK5d2VQs9jCsHX/y5KSEobaMUclTmibllOd0PTDOE/qXD2AEgV5hF+V+AEe4G8T3py4yWD3Ufky+eWC4vyaZ6fHkn5dwhVcdGcrwGJeEO+UagSs+5SvYWT8KJVIa1OpA7BA9ysPaU8fV1Go6SwZJOoW9Viu+Tn0S93ntwu0TbpVJu1UOAuYzEcT0T8IbGKUn1AAxgZf5zooXCESaqBy1lsWUBwwt0163dOYitDsLLbxkdAKsvbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XDA4Niwyn+ugo/aXoiw1815IIm17yFRd2o1HZ5g3ySc=;
 b=KCerxSLvpbnuK8wNw1ayMmbbwY2uA/Dc1NiqeGfbifcWXN03vsEiKA/zVHk/ZDqydXUdU0PreAHrlX0a8t9lgQlKxr/1vRGdMXU1/HSsmq5oCTQmXqPNtw64CFFvCU6ivUl2gjGayHW5fSkH1X0+Jee8/GzQ2rHrlsFFhh0wsd7/rDO+NIthmqUmQYivleNbeuPrt8ttOPLXpYBoGMC62HXrg0hhSIwMGbJeSR5G87VQDpMby0dkd4doXil853WbJg26/O7pMb3Sc1vkQJymZR5Eh59Nm+E2gWtQHmnVQ1u4KQyTPrwI3aai43M+B8Qyhsam26H7K84smFqmpTflyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDA4Niwyn+ugo/aXoiw1815IIm17yFRd2o1HZ5g3ySc=;
 b=HBAV/pG1DirlglLGCvR7A5DR9xjGvN2wh1rjAiCNo5grG68qLlaWCG+CrmeTZi0JUvfJYJsv8GbvAOW8Y8PCf2auiPFU7UJQKtqHcYf37VW3NipxE6IsOerNAA2ESNqSAQX2h9xOBEC5U5eCaTzdqdagR7E9yOfwbKGEhueIi6k=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB9984.jpnprd01.prod.outlook.com
 (2603:1096:400:1e0::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Tue, 13 Sep
 2022 05:56:27 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db%4]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 05:56:27 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 2/5] dt-bindings: net: renesas: Document Renesas Ethernet
 Switch
Thread-Topic: [PATCH 2/5] dt-bindings: net: renesas: Document Renesas Ethernet
 Switch
Thread-Index: AQHYxE/JYHnObnoZ8E2hxqzBhga8oq3cZnEAgAB6qDA=
Date:   Tue, 13 Sep 2022 05:56:27 +0000
Message-ID: <TYBPR01MB53417273B5DE02851CA2DA47D8479@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-3-yoshihiro.shimoda.uh@renesas.com>
 <Yx+zehiPfhEjkw1y@lunn.ch>
In-Reply-To: <Yx+zehiPfhEjkw1y@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB9984:EE_
x-ms-office365-filtering-correlation-id: 803ff787-68d0-4bed-ae74-08da954cb2d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7spvdsuvxjYWwo/WiEp5D72egjUT7qSBqFeiCeguvAGmDC1C/YmbXJvl7rW15a0T4kBn3+6BLm/xEjHNgrrgPDHAwHXFT7dwQsElYuiL+WP6uVmOCq5dj4kp9IMoPQWchgX8QCVHDX7PutQ8J85x0RRSjm7zFbmMFYF0GYuBXb82lxNZy5fDF1oVDBU3mEwdrlBR3cA/fhYAo7s9trgUU2+HERZFl0e6RBjQuy9bzqfUM7sB+muRwMtxm+SJEGJcaXNjjEazpMRaxnm+XZRcWecAu7Wpbj0r1q3VQV5ET9+qP4i/Qy2uzFQPScyECBPJKaeEEAf5ubff8NDQArDiIZlyCjxuhDol0RzXYGcIVZPA+H4RIdOmVHNY5gSpvWXYM3k0sNfcX1FKP7hK7uwzVP0VbsOQClc3e6FKJ5dWflwUcjUAV68JuHufsIMKcAPsF4IyqRSnMmaikQoSaKz71BaLMoxPcWFpou2QUVGaqZQT+/LJBqHWJeHLgpJlw0varHZSvMgu8oJw0ngJW//sqImYJhVOwyBdtEeIu9McTutXmQ9l+QxFV0GsDVND1qsd3pAu5Alj2vBBM2yTTXV0mmlcp1h365wTglishh5++RZ04a4tmey5D9ijnwKr9zoVyJMYMwJTmP4WK/HbzEXUKCHBOFQxDflPs6sKtLIIfc0xePA+Dnmu5l5MAowvN01u6SxBQxoLhuspZeeaaupRbaG/8UdtwMtJA3SfdOntNYj9GZ0THEopyzYN5oY4FR2NnwRjvDMe09d+id1FA9rvyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199015)(38070700005)(8936002)(8676002)(76116006)(66946007)(9686003)(66476007)(54906003)(7416002)(83380400001)(2906002)(86362001)(55016003)(38100700002)(6916009)(41300700001)(122000001)(5660300002)(52536014)(186003)(66446008)(66556008)(4326008)(64756008)(316002)(33656002)(6506007)(478600001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Zy07bejbGQnUpZ32QVxzbJA6p/LoOzGho8CezCwP3I0tpT1tQpCu1tYiG/JF?=
 =?us-ascii?Q?9SJXJaE9Tc7o5ImZbWxTBfxTL/ZuUHa5SnNYhQ0ydESbQE0CIXfcH05y9IVS?=
 =?us-ascii?Q?rocM4WBPuw3p0OO4SuNpCOwykiqRWMWn6f2yA8kSehXd1ziwW7DzvNoqiGiQ?=
 =?us-ascii?Q?szutnAYucJ1nf7li3gVOzJkf6ZuXwvSBDvl2y2OoxJWDOls8bBU8Zr2QiOUy?=
 =?us-ascii?Q?sybPuJzF/JgXbFwwYwGDdd1NWAV1pbUnEff7yHNkXYncLzLNQjMzOeIzQ3DQ?=
 =?us-ascii?Q?s3bfoSR7MYRLMtAme0IaeXvVQkeAQSDgYki/VsB4C1NGDqaFAzGISw1guDLu?=
 =?us-ascii?Q?VAm0SGTOjGmcndq+aSgUP0tnAiGnGEtCx0pWQRaqzkMcXZ1faN5AltQfHBNc?=
 =?us-ascii?Q?A935Psdv4JRXRPHsgAJk1gy1sSc5e820JXNXbaHXunCpXFHWUW/9R+EXsNzi?=
 =?us-ascii?Q?JcytOfghLHNT+HzAYpyDlkoriqKU55ngyDK/ddTSBDG5fJjmCK29IaFC6yW6?=
 =?us-ascii?Q?Kho17otRkZXshZfs+zX9pkMxyk9o9x5KJBu7aEQpUyFFh1BePQWLN10cooOZ?=
 =?us-ascii?Q?pIuqCpsZ4sBu1D0baGlvdX+KG5iZ3jUPg5IMloVSJJXQI27wJ5NwQPELxB49?=
 =?us-ascii?Q?Lss20ieRj5fQ1l9uWn3tIImremn7fqsIHtDvSHNGVPTgelJNXvyyqHYShbM8?=
 =?us-ascii?Q?soBlEmAdbsrZowDSZa246zobp6treke6sj1TbIbVC+QyWj/SzGQnWuSCWswv?=
 =?us-ascii?Q?tn6/T25CB4sBjMMOBWKqkm9JB+s/WCIYgzeLea0tF/79wiW2BOVBorS6X8nr?=
 =?us-ascii?Q?sC2mhbpikLa3NxyfemD4FFuMyo2QzDgAkrZ+IpclUTXyAyh33BF7ZUPlQDpr?=
 =?us-ascii?Q?s0dqWpR2HZMBtdolOLI5/Tj+R8WlsJyd9BQnYv/H//XmwknuiBT2U5UOFOBr?=
 =?us-ascii?Q?YX4Lv823NhIMipLG3ujzU/Y+NrF4oE5GGbb8HnsqL4DBXTWnJ7vCbleg8pwh?=
 =?us-ascii?Q?DqjWUnwMEyB14c/msGfPEzEsHKxfQpdAcTIiY2Z+vSiwigmrFECHMBBKXXtD?=
 =?us-ascii?Q?b0XJHw4H6uPjU4fmJUJUBRM7ajnhV4w/EhLCtcmWnRH+xRCl5q9wHYOFJbb2?=
 =?us-ascii?Q?7kIDUBIvnsMFbnvMI/qhyjzZsTN7pMNZauykYYlkbJaybKeU3ZbygZR6+Nz9?=
 =?us-ascii?Q?Pcj6FvtYLy3mEzE0lCWonZv3di6To3Wh6J9zkUrvPIisa4A0tjKGrlXfGZlp?=
 =?us-ascii?Q?Evn4cpdm99C1L3ioIm1JZ9zhoQjHTBdo7rSfAxfc613W60WTd3n/2DPAqtzH?=
 =?us-ascii?Q?F8HfMcZaVF184ZIyVCham9nT5DShiL/MfrDOavO1vk70lMdrLJVQqTtsEgUB?=
 =?us-ascii?Q?YPnGazt51EMVK6UKHWGPJs0T32tSZvtYRbdNwR0hCEzxe0bKNQAoLGMUKJTW?=
 =?us-ascii?Q?fA89phK8lSrkJklJi4eDAgK9cArmiXGW4A2CCzSvU+Pg2EFTqPB9fq35JVO8?=
 =?us-ascii?Q?l1fQdM0POACxxZNS37vEkOZpDHuloKwdJzw/liAMKeSSiDajSdxPI8JT+IYk?=
 =?us-ascii?Q?Tf+0gYQy490ezof6SIKzdmqtfbS+pgoAve9T9ts3Shru18TB3oioPXewnGZu?=
 =?us-ascii?Q?C999fPzE7pWaecmxhQeQJYugeNiXd9x8QPi4VirmlcJurk2jGb4GJpZQGO8Z?=
 =?us-ascii?Q?I18nJA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 803ff787-68d0-4bed-ae74-08da954cb2d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 05:56:27.6697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uwVYgpM0hgIzGPwnmqDMCspYs5NEAJ+F4t9GY2K9cERmVavLphXc9vcb4/FRW3/uwMKjHYXbg+USubL/DDfr9INfy5WzVpWmI/rlFkR27T/0yJzODQ6iiDOcZK6FUfhK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9984
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for your review!

> From: Andrew Lunn, Sent: Tuesday, September 13, 2022 7:32 AM
>=20
> > +  '#address-cells':
> > +    description: Number of address cells for the MDIO bus.
> > +    const: 1
>=20
> Please could you explain this a bit more.

I realized that the property is completely wrong.
This #address-cells here (out of "port") is not needed.
So, I'll drop it.
Instead of that, I'll add a description of "#address-cell"
in the port as " Port number of ETHA (TSNA)".

> > +
> > +  '#size-cells':
> > +    description: Number of size cells on the MDIO bus.
> > +    const: 0

Also I'll drop this.

> > +  ports:
> > +    type: object
>=20
> I think ethernet-ports is the preferred name.

OK. I'll rename it.

> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - reg-names
> > +  - interrupts
> > +  - interrupt-names
> > +  - clocks
> > +  - clock-names
> > +  - resets
> > +  - power-domains
> > +  - '#address-cells'
> > +  - '#size-cells'
>=20
> So ports are not required? You can have a 0 port switch?

Thank you for pointed it out. I'll add "ethernet-ports" and
drop '#address-cells' and '#size-cells'.

Best regards,
Yoshihiro Shimoda

>    Andrew
