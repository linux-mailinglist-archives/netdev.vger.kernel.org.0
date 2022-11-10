Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE31624715
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiKJQcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiKJQcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:32:43 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80085.outbound.protection.outlook.com [40.107.8.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1227E2F023;
        Thu, 10 Nov 2022 08:32:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDoShrMlIYDhOhwQM7EKT+YLuEgaxoXeKIgqsfe+Bc1kx8vNUmx7rpNs0wHEfXGXPvjK9T1azu/11woR5c3l35wg4MQlCJX3RtNv+w9fAyfi1tNBSKU2KgUTkEmXsid3QC0yYR9rbf+pXnEw/czMQiwDDIjf3QCXfKSnOe18D9g6LNWL/ePA40qXEOMXEfv2wO+vaz3dAhhmkAgsl5eeE2gYKDkSn0YwbPsw0iy0VM+UC2+p2FjPCI+an7aE43zEg3UdehUHk+ED2gGGVF0UbufihO4ZbobI/iqPijXsWbW2kCoKCNuPhvMOLYz3hvbKA4+4PLVVJ8FXqbKNh/m9rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVJp+EJPnXpJpdK7Z8q47NvkYEv5uZ9LKP+UdhuuUYY=;
 b=OWEx2TTFtmwnwnKAob/LEs2nk9x5VTkCYKfkiUxq/VGDQpo/eMagJi84oPvLAoECdlybve2ZXSC/2+KNBGo/wifFFhPizq9/SfhxlUIbnPSoRS8Vxk+0buZX9BPnA8Snyr5tbRfqldyJBquQT61iFOrxR69UFRLf3W316mQdJH7FuktYCLorSAu6Zy0i93M4dxfhoQ82N0UPbRvJbb45P9KG2JKcBiFw2AG/GOmhgOWz0OjhMjdGVtCG4Fty5ysVkL38mmLywCvdbiyxjHAyBDQ3clNXyBjz1BMgFWR67AfWyOToZ4zKHy9v/7++kcV+4FG1ycffPomTLU6DGFMihA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVJp+EJPnXpJpdK7Z8q47NvkYEv5uZ9LKP+UdhuuUYY=;
 b=B+WA3DlhzHVW/58PWt1WHd/HjUH8Z6UTaWugLFB9sqA3qLP7jtStnOCh0ZrvqlfSwWVxjW86GfeLtkhVowexiypGKKvEU/IHm7jROWi/8bops27BjmtIB1zLfO0/PXKyapNR2OG0rF3qcxVldvDmPUM6JCo/XQgTUrp7kvxqWfI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7932.eurprd04.prod.outlook.com (2603:10a6:10:1ef::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 16:32:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d%7]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 16:32:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Sean Anderson <sean.anderson@seco.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Thread-Topic: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Thread-Index: AQHY78g7xxgXmFEQmk+41hVlaLM4fK43OSkAgAEQPACAAAl4gIAACPsAgAAIrYA=
Date:   Thu, 10 Nov 2022 16:32:38 +0000
Message-ID: <20221110163237.vigulusm2c5bepp3@skbuf>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221109224110.erfaftzja4fybdbc@skbuf>
 <bcb87445-d80d-fea0-82f2-a15b20baaf06@seco.com>
 <20221110152925.3gkkp5opf74oqrxb@skbuf> <Y20gXppMemnHSTG9@lunn.ch>
In-Reply-To: <Y20gXppMemnHSTG9@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DBBPR04MB7932:EE_
x-ms-office365-filtering-correlation-id: bf6b5885-6312-4805-3cab-08dac3392e60
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JxZ+usAoCzITtiXZtT7ahQ8fxf49jc+xwCwQvs2Y+iO7AFULGYkgm7UBfZnk9cZJ6JLx11A56rxOXSr/HzGGuEKlN9oY4+AhJ9L49rTIGGzJf8+irXrSCikbrnu/J/SFqgue3pSEAaUAGT//3viRYva1C0IPNDHq0tthRbHLe917+qFnOt4akwxYIn8ddoNLjk2XGYYje869ymkZOF6AZPCMtEuBSHVP3FKNsannbgtNk21BM6x/uB6ePqlYfZvWCQ1J4VIgtvKQyeTuNxadIovSlNZeZoKpMDOdq1jqHkv50nKvymkI9OfXR5siyVk3GN6ciq5ou7Ma5yaGd8e09s7bYJExSxD0DslXu8LUuTCHoOwSeMsvdyLh/LmSlMN+gB1oXJTo+jFeeLVrF6KfJ0OSqletpXlclx55sAtaS/2/1+7C7Ap/VL+SBXE8dBvzCmNkPoewz4ovQjlhoZJ6q/UJLIS7uBlPLuy6irGPBgbwBpVLcyxQ3IfD9K8LRPv0H9wAdKWJ1M1cj1YXt7KgFj3ahu8e0mcnWj5yc2waUxJd1U7ugKUMagoYHAgqfhQtr/NMOyUtz6hp88wAm0RxJrBsPgqxex3Y2uxzuovZrxxuMHQJcAME5suA+PNEFhTHmi7EvhpGeecyTwYoX1pHuQKm+rU+tcsh/0RtsQi2yuTGemPnjeG3RfH08NjzDU2afo2PqiIl0yylZSwP7lNcwc9RIp+pWk1ztyGjWmFySvzgwRunbiV592j4Q1JIQy7GZgJk0AmJaG8Tr6uBI3g9kg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199015)(5660300002)(7416002)(6512007)(44832011)(2906002)(9686003)(6486002)(6506007)(41300700001)(26005)(53546011)(8936002)(478600001)(76116006)(66476007)(66446008)(64756008)(66556008)(4326008)(8676002)(66946007)(86362001)(38100700002)(38070700005)(33716001)(122000001)(1076003)(186003)(83380400001)(6916009)(71200400001)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xYm3L1N+66NTwtEIA39Psb6/4DMW1zmHvXvvRROe6vS5GwiXcJ1mNkts/deZ?=
 =?us-ascii?Q?cTaOrjKrW3aNnH8ZC2HWMuZQhg0n8MJzdsaPZP2aiaOZSKtOi0dXtCS99YG2?=
 =?us-ascii?Q?aMwVQ+Lm7RXCoRv5SeFPSTG4jP3Eym5h8sXZlqPKA2XE3qkjNtt03tuYptEf?=
 =?us-ascii?Q?vCDZo49VFx79U6yJPfpdF+nxrpJGu1qKPVbj9N+HVdtYWePncmF2mhcZ7ha2?=
 =?us-ascii?Q?3JgsVsw3/BM+o6+gn5+0NDC8oBwKoY+a6MetBcGc3c7k/c5SClrU8prO7XC6?=
 =?us-ascii?Q?dbsIAnVSK/JmO/x7d5yypUyBQkWjNggyFh4+4aPchj+vVXvAnADWz9tqvc1o?=
 =?us-ascii?Q?D4hCQN4BF+ZMz2eNnhWJFXDFLGtNfigOXFui7Hw5i6abvmo3airCEowG+Acw?=
 =?us-ascii?Q?2mTkLF2DUmXbVEKytGC6n/z0+fn7IKXCuGXC2Q2R6fkZ63Qeaq8sfmGEY14h?=
 =?us-ascii?Q?2p9sGxA11uw1QRVrNuddb3p3BFLhgfgj7+qdly9h3fJKcRKK4LJ8cwLC3rjt?=
 =?us-ascii?Q?VHHGHg61qx8ECSwgCzkeesSDfHYvaXwyGJ+hy3UwFGzdVceidbjxbsUTRZ0q?=
 =?us-ascii?Q?cC4Hgzy0D15Qn2cdVeYWX+SMQCNSob8vdflY7AukVqbxzf86DV5T7YzkgwFC?=
 =?us-ascii?Q?StobRdjvOCWIzLS+w9jd2dA2/pDB79kbU82HC0JFTp/ACn0w4t/oDJ6sCwaT?=
 =?us-ascii?Q?wIKzdHNMxyuJ9m4c1gQF5+Ay78+Qmx1ajSoM+p6luAumMYyVCtKik85QS7/v?=
 =?us-ascii?Q?ttJNwwNrIKFx+iN3hxiFi4t36tkfzAYAIwHkPYCQeiyj7C1Owjb5t+2qQ76N?=
 =?us-ascii?Q?w2DmZY3i97r1bu1x3mJo4SbrGMHj+D+u8ifvFIRb28Rf87Wc3Y77m7rr9T4h?=
 =?us-ascii?Q?5pOVDKeKaRgHm34Yyd+AcBFLVEzVpnHrZIrpHa9zufK+JsOeLGhwpI17KUyq?=
 =?us-ascii?Q?ikxrfHqWXFzSNpRtaB6Q/A+PU051PJTyo0bBqTfb/o0giSQQXUikXvgv5/aB?=
 =?us-ascii?Q?b1j9+lPy6FQAUuXxG4+6MC0dVPXij0PSFcngDPIeINB7ODYe0UcZhv0xJqh9?=
 =?us-ascii?Q?KBEFMa/DJgvivsqyBMK1VrzbRAEUpk9ly7+Jd+trHorUmUFOHZ13iZA7bgsm?=
 =?us-ascii?Q?PzNce4qlRh+BG2MQeIv7anJh0QHDgFN/7lcdHYsFAiJQiJKLwASORy/KZLvC?=
 =?us-ascii?Q?47u5J4rHYQcOhT8WwrGfsktdnu1iQOMlyC0go6y7M6M2o8bW5hxgUOXpsfOK?=
 =?us-ascii?Q?Ov7GXMBRklO0i6LsAqZL4HuElDo2M/TcsXDDEEzAwb07OIzBdS3wKcsvqTVE?=
 =?us-ascii?Q?mLNtmSwLtsw2V0btCjxyCCYlC9CdsN5SVqg4WlqNwLqMpKqWTyJFxuPUYh+d?=
 =?us-ascii?Q?9lta8hQVj403XVbT4fbSZCJ0S58Y4w2UBHoRCCbyXieNFCmfb0XN+8VnFAs8?=
 =?us-ascii?Q?IHuIdjMwNcjWqYzGCOgbEVR9fLt8QXqC2ZHJeF/CJChkabmRGSsyIDQEP1vV?=
 =?us-ascii?Q?69++5k81AjyHeYecia5nsqqzYKlzf/9yf2hebTg9/D6pIO/B/kYHpCke1wDZ?=
 =?us-ascii?Q?5+1wAK4VfwSXJZ2YckdOi2xgeDLoRrZ3p8UCLMvT39G7FQ4JIGTJAOach6nd?=
 =?us-ascii?Q?yA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4BEF6EDFB4ABFA40B38A693E5EDFFEF8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6b5885-6312-4805-3cab-08dac3392e60
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 16:32:38.4801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ji66M3kLWEh0XMjOgbsJD+lQW4EsbyHAdfK13kZJXZG7MpC/R1O9cVDTqOSkBqfoYSzfws74GDuLOSYelkNC+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7932
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 05:01:34PM +0100, Andrew Lunn wrote:
> On Thu, Nov 10, 2022 at 03:29:26PM +0000, Vladimir Oltean wrote:
> > On Thu, Nov 10, 2022 at 09:55:32AM -0500, Sean Anderson wrote:
> > > On 11/9/22 17:41, Vladimir Oltean wrote:
> > > > On Thu, Nov 03, 2022 at 05:06:39PM -0400, Sean Anderson wrote:
> > > >> Several (later) patches in this series cannot be applied until a s=
table
> > > >> release has occured containing the dts updates.
> > > >=20
> > > > New kernels must remain compatible with old device trees.
> > >=20
> > > Well, this binding is not present in older device trees, so it needs =
to
> > > be added before these patches can be applied. It also could be possib=
le
> > > to manually bind the driver using e.g. a helper function (like what i=
s
> > > done with lynx_pcs_create_on_bus). Of course this would be tricky,
> > > because we would need to unbind any generic phy driver attached, but
> > > avoid unbinding an existing Lynx PCS driver.
> >=20
> > If you know the value of the MII_PHYSID1 and MII_PHYSID2 registers for
> > these PCS devices, would it be possible to probe them in a generic way
> > as MDIO devices, if they lack a compatible string?
>=20
> That is not how it currently works. If a device on an MDIO bus has a
> compatible, it is assumed to be an mdio device, and it is probed in a
> generic way as an sort of mdio device. It could be an Ethernet switch,
> or Broadcom has some generic PHYs which are mdio devices, etc.
>=20
> If there is no compatible, the ID registers are read and it is assumed
> to be a PHY. It will be probed as a PHY. The probe() function will be
> given a phydev etc.
>=20
> It will need some core changes to allow an mdio device to be probed
> via the ID registers.

Yes, it would require extending struct mdio_driver with something like
what struct phy_driver has (u32 phy_id, u32 phy_id_mask), or with a more
generic phy_id_match_table (similar to maybe of_match_table).

I don't see a conceptually simpler way though.=
