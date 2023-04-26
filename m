Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B060B6EF95C
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbjDZR2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbjDZR2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:28:01 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569DD6A58;
        Wed, 26 Apr 2023 10:27:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ym5n25BcxTKUtsm0BaXslxCFVz/LHiV624c5olKMaNY1VQ+GUuTYNg0DrlYax6aVbR7EHJ1dnpx/zvxIuB7huCECbFyPRQzH3hRfliRA7OV6yR0lMgG6j8hsJyK+34g+K5ItkbaTeiw8nwLmHM8wwd5kBO4C4g3ypklM+TRtHbF5KojU8HHU+7a2Ny/4jsANpqth0lENb5yaTyItDlEG9oIWQ3TIc2vQN9eVaRaMBK+UKXWWBTIrSbf2e0jIUZPaACxheKwDumdGhBHz/2qIEfs1WLYJ1eN9nvf8zDGkF1P6GmTcupwCgU2nwt5HtCwkcW/4HaaNO/FTP+9OBifnsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXJG1ZggZEJF9VhhzoJqmYHaPd6EMzOIrOZUcPa1tiA=;
 b=BJUvpfSGcXqazv+J/2qLIHSnkraWLJfPclkOhQMKZzdxf4Mug5xT2nAB3vyDVmDMijxCrZ1pDHuH2mwLeH8DUC86wWBzjkfZokfyda9Uzf4eL89m5ymYYDlsf2V0o3rRw1acB+hLal6k6m5tFst5+pQxvzVjWtwM1aqWzBTnEoO7P33YQoYsS8gdUUZojE9r0+l9VKs1QJyNMgyAfhocMzMKpgBsqfudlry+R09TyTu/Jc1E1mVW7VvKdDgbK6+bf1nBrnjnnbZF6AVObFXWeo2MeB+KafIU2Jk51W6ni9Tj9qRL8evkZ3q0m6nDs8NrINBGRDkACXawe9bh9bTFAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXJG1ZggZEJF9VhhzoJqmYHaPd6EMzOIrOZUcPa1tiA=;
 b=ERsErzyED13yuGGIMgJS5OAZbBYNVmD0RGOHjHrxq/OlJo8Abhm166KLpP0Q0FEZGhknZseQO6ftLESI5Uin8lduGaUUCK2cx6u4tJuQiZBhF0NzhJvmX123UVbzDjZ8xBPnRkRwa0qNCkFvdElfV5JzDbvKiGSNxVkUtLMC+fY=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by DS0PR12MB8041.namprd12.prod.outlook.com (2603:10b6:8:147::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 17:27:51 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::d3f1:81d5:892d:1ad1]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::d3f1:81d5:892d:1ad1%6]) with mapi id 15.20.6340.020; Wed, 26 Apr 2023
 17:27:51 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "wsa+renesas@sang-engineering.com" <wsa+renesas@sang-engineering.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Subject: RE: [PATCH net-next v2 1/3] phy: mscc: Use PHY_ID_MATCH_VENDOR to
 minimize PHY ID table
Thread-Topic: [PATCH net-next v2 1/3] phy: mscc: Use PHY_ID_MATCH_VENDOR to
 minimize PHY ID table
Thread-Index: AQHZeCv01AQKu6wCIUmTin6SYmuMta89mNcAgAA/MSA=
Date:   Wed, 26 Apr 2023 17:27:51 +0000
Message-ID: <BYAPR12MB47737F393790808D3A90A07D9E659@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-2-harini.katakam@amd.com>
 <c120d1bc-4b67-4280-a843-d269fdb27e20@lunn.ch>
In-Reply-To: <c120d1bc-4b67-4280-a843-d269fdb27e20@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|DS0PR12MB8041:EE_
x-ms-office365-filtering-correlation-id: 436d7364-c3ea-41c2-b237-08db467b8fdb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uAdew9HdP8Cj+KuwLBrYVuAI6UKR7ArH6Hl4RGOj6VrvfB0p+KRBjkZ+LJi33+z1dKIShgXxhnp1W3mtB01ktluotzrlfFt3HNRN/8ljuG/IRnW9Y4KFPvcbid+lQDrHGffMQmG90QnkenvzqvcsR5cp+JRxLf3B5jPPxa1yXFVCmsxoIsouYamVp+xCybA3jw0eHlp+BPVNL8CV+v7PgZSkvtuUkLnFE8M6Gy3+bruTZNsa/es70sBDaxXDzklt9wGHj2zzD6/P5IagB4qSbrX69Bg3xVVp+WzF4OoWrp0dbukfiY1wFUiQqacaCySQchndBiNjhmUKBVszX/LnIuPS5erNVuTHyP5FSiqrWybfTTJqKzQ8ArqKNDAUt11IaCbDmh1S1+OXQqYcpwn4HsrAMaJbqS5nL/lt1Jc29U0CobQZD+1G+38UZCcUYdl0a5xqo5YjoEMpMzPHgVyZRS1AReL5JJOTKAUBEk6fWN6NN7nri7sGip3PfYESGZ4rGXQXV8Q37cIvAzuylo6TD5ywi6I0hU3rw/q2jrbPad/kApPNhPlSKAL0UMUvbrzL7CYWw6xi//PA5d25yS7zhODjaX3xlSOBmFsjBlHe/5454lCm505wnMQDzmXu6sc0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199021)(83380400001)(33656002)(86362001)(9686003)(53546011)(6506007)(26005)(7696005)(71200400001)(478600001)(54906003)(7416002)(316002)(66476007)(76116006)(64756008)(66946007)(66556008)(66446008)(4326008)(6916009)(8936002)(8676002)(38070700005)(41300700001)(38100700002)(186003)(2906002)(122000001)(55016003)(5660300002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UP6rrwQdioNd6bnB1DqwmbX3HT7GZYi4jYnoUvS965D/Dj8p8uI1ssBYEnpH?=
 =?us-ascii?Q?8kAsetX6vgB3m0ZW0xkJvrIwKdl3VsY/Oe4cBtgBFAHPQp5aDDzjLBHpTSMy?=
 =?us-ascii?Q?GPcBzjZOzJY37Tc1rH5rgSpIn8vsdf8QNq2oAo25eeD1QdxzfnRrGGNzx/aY?=
 =?us-ascii?Q?R7FDAYHlSAZLL3SJfTc334FYFokGEeKsOWH+O9p5enH7P907k9wocE3/AAve?=
 =?us-ascii?Q?RZOonTSs2TK1xl2TOrzhqgjYRoba4o+bv7H80xUUDiD8lBsYmc7oVWaXVGg3?=
 =?us-ascii?Q?J+2/titr/XQxxQ5VIF82/Xu41CnRS28LOJjse6mkGgbFEGqWCeQ8fl+CZ1Gv?=
 =?us-ascii?Q?JI2lyaL/HcnDo7W6qJxlHF4CpJOATYRnPCbfd1MA3fRCM+oAtw8kjuzxtQVF?=
 =?us-ascii?Q?ilmQFq9cRLQWX6ImkP2AGR4k+buXAVUUsVkG5dHGzJkc1ZO8vtiiEpDkU0pr?=
 =?us-ascii?Q?TQdj8h9Vynb+c9/MDrEba6xlEP0CkSlsoYE1GGPM6Lkz5plFBAAvBTsEchjG?=
 =?us-ascii?Q?xf3R59DtsfXqj3HHYQ4H2TGcC1sxMtr4xClu4Kr6zGfKPP4xH7zcjK4zNBG2?=
 =?us-ascii?Q?iL3bhOdOJf3E9233wo4TEgZNP0toZbDPdRlGVdDUJ2DcALWM7AGcqFrSeXpb?=
 =?us-ascii?Q?Q0VuINbCxzapCgpxMlzhU3ZCy4Y0KrKQziWc8biJf8YfZhAvXJs5dj0W0lSu?=
 =?us-ascii?Q?IAXBBc47A0fATuuFlIKYtgAO+bXiIHCVq4u29NeH5o6xRZTTGZJkguN8z78A?=
 =?us-ascii?Q?9+hYUpHZGp+gfYHliJkg2Z6j2SUdr8ArHne9YuxfMd+WG6yIvb0uG6VN9dVc?=
 =?us-ascii?Q?Vnmg9Kn9zkrpBmxwXzZ0j6QZgjHnUgLldNsBo9u+AhxhVHs1bJKwHGrO35Ie?=
 =?us-ascii?Q?fccYbdfAIbcply0X9g7Q6E3Jp59R4VrWNmo/FNOwwRbBWucji/PhMphUefio?=
 =?us-ascii?Q?A1S7ZHQOREMujWfkj3KTTDU1h/mmzInVKwo/7bjFIaJ0WDEBv6Ctscmp5mTS?=
 =?us-ascii?Q?giMC7vMzBX58cKvVV64FFOP9qJNjLSSpdSHoa9yFryfJpnAz678q8gg3gZlH?=
 =?us-ascii?Q?tY0JU+8C+sPNTx5Zrmf4mqGKIgz2rHo0U2j3bYjnASxHX9y9ebJHGwSJvpTs?=
 =?us-ascii?Q?hUZSuD5AXkKwZ7eSwypWc4pPudGuaCpSa1/U+xqeApQuIQxgjJgNsUZ289G8?=
 =?us-ascii?Q?zb4YFzodUOZulyjxEr+rH8o8R9TD4qNrSJ6xFctjwkj/FOCO4wq3X1fX7JYz?=
 =?us-ascii?Q?mH8N0RYC7CgnCvGN/NxRo4UBo8jqmOp0UPyRK53ZLGeZ2csJ7kS5zc9YSDah?=
 =?us-ascii?Q?fFY3BDWp/GwhCC+pNbrvZW6d8gy/YifFpr/FRr82sqerEXnbHIaptyGh1OU6?=
 =?us-ascii?Q?03rmNDuZJpt85+WE6sLxsr2XFoMAQW2NfMWDQTz+mBwSIaEzweO9bAdXc8uw?=
 =?us-ascii?Q?inoXIa4z1p30LEA5CyNThZw4PSzFUq85an+j7CeRXvNbDT5tdPfiM3nSFlE+?=
 =?us-ascii?Q?65Tznz2lFYizLi8NG7Yrov4HDNdEPh1nMOCv7E/UF8P94RG4Cn0GdzJqM1G5?=
 =?us-ascii?Q?ZNAEVmeLl9Il10YCLfo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436d7364-c3ea-41c2-b237-08db467b8fdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 17:27:51.1276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R7jbl9iZc2ecoJncqNS3Qi7IrGukk4O+KaQOQMW5bivfIJiPgTFeIS3w0uZASesM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8041
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, April 26, 2023 7:10 PM
> To: Katakam, Harini <harini.katakam@amd.com>
> Cc: robh+dt@kernel.org; hkallweit1@gmail.com; linux@armlinux.org.uk;
> davem@davemloft.net; kuba@kernel.org; edumazet@google.com;
> pabeni@redhat.com; vladimir.oltean@nxp.com; wsa+renesas@sang-
> engineering.com; krzysztof.kozlowski+dt@linaro.org;
> simon.horman@corigine.com; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org;
> harinikatakamlinux@gmail.com; Simek, Michal <michal.simek@amd.com>;
> Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Subject: Re: [PATCH net-next v2 1/3] phy: mscc: Use
> PHY_ID_MATCH_VENDOR to minimize PHY ID table
>=20
> On Wed, Apr 26, 2023 at 04:13:11PM +0530, Harini Katakam wrote:
> > All the PHY devices variants specified have the same mask and hence
> > can be simplified to one vendor look up for 0xfffffff0.
> > Any individual config can be identified by PHY_ID_MATCH_EXACT in the
> > respective structure.
> >
> > Signed-off-by: Harini Katakam <harini.katakam@amd.com>
>=20
<snip>
> > +	{ PHY_ID_MATCH_VENDOR(0xfffffff0) },
>=20
> The vendor ID is 0xfffffff0 ???

Sorry this is supposed to be 0x00070400 (Microsemi OUI).
Will fix in the next version.

Regards,
Harini

