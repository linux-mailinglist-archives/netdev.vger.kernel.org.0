Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1526264C8
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbiKKWxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbiKKWxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:53:46 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2083.outbound.protection.outlook.com [40.107.103.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B18053EE4
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 14:53:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TH1jdi0lq5TVKv3kQ550YSHZnO9XSakDAVIjCiYr52psX/BAk3Z0zwdB85MYnuJ/mV/1e/M1ce9IVaUUcwyexRAEep/UbuOL0w/nraBd5kZdO4DK5sOWKLku+Xk5kyCGYRv2bG48BN7lP/sDG9sBB13V/vqBX/dveCFxwGiBMhVte4j25UrIdOl+1E+MQuaFU+FeVcAMdS9fgVqxfTpPS3p+ONv/o2UIsRQvBlOE9UWluVvB2NMyDoEVVAc9Im5953jik52A29h+fyy/vn+HluBSkvh9EZd0IORKvSQKitiWz2rz8sn/I4K//rBPfJe5IPHoC0GPjEMddWGZkeutNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQ8vTJxaaJIUHqZjJmHKzYr0PXnE7JG8a3JL84gn+Iw=;
 b=E//QOPDxlhqhkiCCGce+yHzWK3aPaYUh3jF41ANHt9V+UzW8hQ5SWN2DisrWRUCjc4ItUfaQvH24qjZpPyK5kymo+Ni85Ys6DuR/9Oci2wAagIkeWgs8DylgeJTOJwn0yjhPCxJC+8DeoCxLjoyFg+VfMfxr1OS99g+JinLNLNXVR72gJ39iDCt07wKAuqdLPsJTReFxBpmOqnMSf2sfNzh91QisK0pBf/o4bf0dfj3WGl1Jms1AFEoevXAOMlfLvfBm5XSYfSLif86e143MnPJsy7vx5DaVVG6SaOhLFZkPbskY6ccF+bFE9P/HgkXJMytPr+3OldiR/e82gfgxiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQ8vTJxaaJIUHqZjJmHKzYr0PXnE7JG8a3JL84gn+Iw=;
 b=oriFeC6ueXlPqetO8N8VXH9WCCES9bkJV54tYk08+RTsnegjxwFAukxNHW1INP8kGYj+CuY5ACGadXib6sVYknAoXZ9WwN7gh1+3bAq4iBcPo9DWQJQ20zeoEfpOZ1f9NA+Rxnx3DDuCNyhPL9e9cWdt07NjrkWm7tOvSJD/QbY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8579.eurprd04.prod.outlook.com (2603:10a6:20b:426::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 22:53:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 22:53:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] Autoload DSA tagging driver when
 dynamically changing protocol
Thread-Topic: [RFC PATCH net-next 0/3] Autoload DSA tagging driver when
 dynamically changing protocol
Thread-Index: AQHY6khKXSRkT65VOUC0q3byqGpP9a4jh7AAgAADEwCAA+wVgIAS9XqA
Date:   Fri, 11 Nov 2022 22:53:42 +0000
Message-ID: <20221111225341.2supj4ejtfohignw@skbuf>
References: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
 <2bad372ce42a06254c7767fd658d2a66@walle.cc>
 <20221028092840.bprd37sn6nxwvzww@skbuf> <Y17rEVzO2w1RslrV@lunn.ch>
In-Reply-To: <Y17rEVzO2w1RslrV@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8579:EE_
x-ms-office365-filtering-correlation-id: 363e1b19-b427-41ef-3cc0-08dac43794dd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QbKzfNhtFjlERIpf+IveubA7hFUgpXNFBmkK4JuyA93OrX0WudH1F+qLPE5oD5T5AwQ8k92TOvVdvvuaVLW/wXcvlVinAVn2mzXiGOaYCKtmi2AUWuWFHFvw/0p6HeFPow/R8x6N1VhXNGCVaXc4pA5CokMN9BriYNjV/YDen3jDCR0we2s+yNCeXV7lZEv9F7KTEqpg5S4lEZ4a+F+cJFV2Y6RPU8EjCnSKUmuFMnZdghLpovTC26tbIeevAypC/AupeApjKarmHxN1gLxtTfMjiIlRga6WdqJqbd0/bCjbP6kU0RRXNh3575lE6orVOO0qwhmrl4f/DwrkvPzhFDGIJJG/v7F9OM9f9mRsPKR8mzGrezBIeoltGqXg0zutRsi01wOfF8e8NMMt1v/cVADso3jbUoroTjrdmho9Pnqh8Z8AgZ2s/DqYRK6mSqHrL5L2D7eL/MQIOJW3DEh21mjZTXsIrhsyR3UCoL9E51WNcBURlSviRbiSqLJH2cefGJenOsWOIju69cYazcJDdMO4pE1O4YwXXurFoU67d3UZtLbyPzYnVrGjKwzmq2wrFWk31HqW9cioWHoPmPRZgn378ZeLv807glbjDoZDSNsoTCibb5rwCxOdPn9hnqf5qebri9reeTsHd+VB0FJPJAq/fNuKqA+6vEWVzkUN92u4ri9U9J3r7wivfgnf4I+wG+Vgr5QkTB5b15hM3xULzPw5dnMmniGEKJY4ChHVNusL9jMW5OwlU6FWloyfgqIt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199015)(76116006)(44832011)(122000001)(2906002)(6486002)(1076003)(186003)(86362001)(38070700005)(4744005)(4326008)(66946007)(66446008)(6512007)(66476007)(71200400001)(8676002)(316002)(110136005)(54906003)(38100700002)(6506007)(26005)(66556008)(64756008)(33716001)(41300700001)(9686003)(8936002)(91956017)(478600001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1Q2ZP/gjiOKMQqPhh7uWlS2KvChS6u+o1eH4LZKUW8IuObWNio0Ny5DEh/MP?=
 =?us-ascii?Q?7ExsMq08YXCDBdfNR+N3fiZUtGZxU/KyhtMxk3FhLON6oZUHo9Q2lIL5Mff9?=
 =?us-ascii?Q?rqgSYDxqnB+CBCsFt2GPpFvocr/oAiT+9U8+9ebNhmQQ4o2ob/TA2Ange6e3?=
 =?us-ascii?Q?5aaTKqUsu88j6+OPolrpcjf48UhdsmYdTUJx5dMSuT5f1NvpqzCOIcRfvRgl?=
 =?us-ascii?Q?Kvtynqziz4VrayiYAQljLOkMlZhWmfK7Puwm1xgHxbNRSEPo9KX6mhicJpTc?=
 =?us-ascii?Q?3oGVoZSuOt6hRZnmFVyxCD4QWjzAP/9dB5XdIEUZz6ZmO9pmXomi0TtI8l3X?=
 =?us-ascii?Q?AvhWfWYtDF5eb6C3pJDQuzduwzA8TPeEkSjvGheifO5iKqc61QEPQ8u0lEZJ?=
 =?us-ascii?Q?g1KPWfL97av3QnAR3Ks5erjMXQ9znfo7B4JD8E3biIpru0NyhdzojAQvK30O?=
 =?us-ascii?Q?y9SYIDkfBCtRVwWfpDwL/thEBA3SOvgiiYtzsb0QmxFbbFxG9wVWs/8INgMr?=
 =?us-ascii?Q?Nuchvt8Ta/kJwVbi+0j1Y7r6W52Lt3wecTTX6iosZm4i0OfU45QiI8zGW2fI?=
 =?us-ascii?Q?zZWpf7WDh0CYxCX5sC7HNsWcaUWWeAM4pUPEXmVHrJ5i0CCd5IqsjMG2oq5H?=
 =?us-ascii?Q?AKxjpp0a3dgPSBKw4aCIrytU+kQFLnmJIVjLoF02QcQQmNY5aoXDu40ZPpdL?=
 =?us-ascii?Q?nQTNIAmXnxK2VvHESYsqv1SgNOqyAVnO6ybleyz6qTTAZyzd9ElC+LWd8zOv?=
 =?us-ascii?Q?sU93DeXFBQ/VQpHlRaNRhvyG/5vXM/gIVKER41MNPKDz714IUyIJo47Kbc+U?=
 =?us-ascii?Q?JPxN2sc/NcQAedZ+AtewCnNwkowv29xHWSkBUBqj4JXMoqr1o2smzsvxmRQO?=
 =?us-ascii?Q?OiuC2wbiS5PZjUeDds5pTFWUzlMSMx52pfNbO+WkA37WZgeRx1kwvxaQWlMe?=
 =?us-ascii?Q?1RRF5ehaOGKKJhGJ8Y9ZU1JvqOffj7ScDLt+sN0aDpyVDd6LrOcGT8w0Y8YR?=
 =?us-ascii?Q?cSxkZQhom9OsDjABmYByYuSkHHwJF7Q2h9FZ2Wd1Cwg7h5TytAQzUzMCIG3N?=
 =?us-ascii?Q?oWbd1/P82sfEAaN0EL/caMo1pQ6Zla420Nio3hI78ghPU9HfjzoQl5YJGWzC?=
 =?us-ascii?Q?m4GPB38+j7B0CPGEoSG1XTtQyKHNxZzjZVx53fgOFbfKoppqfO2eBeCdjvuB?=
 =?us-ascii?Q?PvVO5Kr8A4/F5kA5+4tz5ZRXlCfVo5B+mk18Lv0+8JiDmqDzHyOHjA19U7+U?=
 =?us-ascii?Q?so3QWZLPc718NEFY/Kga2cws7/Gm2zPfL92DrQxIgotiadksxNH3jqJnmk1x?=
 =?us-ascii?Q?wxcdnJLs1K23hiLaCbj6kjkuLi7YebjJqsT9Vli8hkm10xdjbn0vCEc5fhdc?=
 =?us-ascii?Q?mdkVAOrv6k5ZeL6/zx3D2eYQfn36fH7rU1JkDjelm3BOsJ2KA9a9OfC7TAkX?=
 =?us-ascii?Q?VGsTnOg9BGAKMweTp7yyoxzes7dfIBp0kMi8UG0RZNsNMV15sKFe/WZXKW6k?=
 =?us-ascii?Q?d7uXphRTgzXVrFBnWbjK6dfZrINsC6T7hQ3MVgu15kE/tRrSHxkNuJwklnpc?=
 =?us-ascii?Q?CTUAIiEB0fHmBjEEHHccoW1FspInciNdN2HwISqpEj2PeWFZ0Oze3q/4WDM2?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6CAFDFE4A76BE4F9572AA6F24A05C1B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 363e1b19-b427-41ef-3cc0-08dac43794dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 22:53:42.5806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mY7AI63xeeSwl4kM15q5MkKT5wGjSTStTlBI5t9dF1Pa5BA9Zb+F8YY1XYQ+8zkuZqGzKwi0mzpYFqwF5zUjOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8579
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 30, 2022 at 10:22:25PM +0100, Andrew Lunn wrote:
> On Fri, Oct 28, 2022 at 09:28:41AM +0000, Vladimir Oltean wrote:
> > On Fri, Oct 28, 2022 at 11:17:40AM +0200, Michael Walle wrote:
> > > Presuming that backwards compatibility is not an issue, maybe:
> > > dsa_tag-id-20
>=20
> I don't think they are meant to be human readable.
>=20
> I do however wounder if they should be dsa_tag:ocelot-8021q,
> dsa_tag:20 ?

dsa_tag:20 or dsa_tag:id-20?=
