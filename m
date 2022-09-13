Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755305B768B
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 18:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiIMQd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 12:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiIMQdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 12:33:00 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on0610.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe02::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181A9B3B07
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 08:27:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5l6DfTq7fAjdSZ3PiQ/03Vltr7tBb4sRxdR+wuhddZ2GCwVZekrd/mYgDFr4ojnOsNebHY7QtKKTTlkpW87bgZT46USiVtj0LfkfjzTOVqtONgpm5CLeU0Br5DKGahmVZelL5hRpFSnA1Rlr1MaYZxNlPjP/dJPBleomt8V+9VwSuKJxjjbYD9t9kfvEPZ6t8O2t9autcOrB2F3JGZGMkqRpDENfmFpz+38D5Cv7IyYfatStWka6jNREKNqBcpP2BmpjI++ZdsvrovAbiUk4ZJjj8ZrZTFmLv+2XiEtxNsdFj7luZzfiqtAMcqUJjI/StH3fhVIhJ2KYWa4t+ZRTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2NCnWdkO/pKkxCoFEh3g0qCTo9977EnW2KzXQaFDN0=;
 b=ieBM4AuVi9QbFhLojIx2hLQ0o/MM/2Aeb5jmNqjUDS3PcSmP9IkguqljCkb6PCZF5YB2KYB96PZtZQvsjlxTx8vmebKqbP9QrO1ws8zqccsx0OHoTinUIxX6ZAQyuUJqXmb7j4Z2yqEETh1/kZ9DVHIOun1cNT6FKKNe1RUr7ijaewx14hjhwfOZUACJk2Ah6nD+vOUmDljv07rsMQsMOBEVpKWeEaXTGQiRhpFhwe25wLp7/0XDpH5inuaboLhqWC4lzd8UBjewAny6p5NUM9O1UgzvKzj9n4Bm6mvGjFIXMOiZ4NZt3fcBfkm0vpye1YDAVnMGdoJEMsp44ICemw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2NCnWdkO/pKkxCoFEh3g0qCTo9977EnW2KzXQaFDN0=;
 b=lSx2/lofUwm0JyR/emNjPaM+bFVOHoz6bSmeA+uM1W3jFRhDD1I0wBM+OwEq0siuEvcPeIrxYm5VWM3oUbNSMfAydKYlFyzfbpzYrCZNWGf9+fLKgmCmUwJgmE7tckbEnYa/yzRvxiphisQrZfiuF4Jt7oAMA9EGNHj1Hlo07oY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8192.eurprd04.prod.outlook.com (2603:10a6:102:1cd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 15:09:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 15:09:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Arun.Ramadoss@microchip.com" <Arun.Ramadoss@microchip.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xiwcAgAADgwCAADWXAIABvT8AgADAlYCAACQfAIAArH+AgAiqFACAAEpcAIABMN2AgABlhQCABKhugIAAHr0AgAx97gCAACSfAIBLUNgAgAADegCAAUK0AIAARl8A
Date:   Tue, 13 Sep 2022 15:09:36 +0000
Message-ID: <20220913150936.rue4e2cuv2fkdf7b@skbuf>
References: <20220714151210.himfkljfrho57v6e@skbuf>
 <3527f7f04f97ff21f6243e14a97b342004600c06.camel@microchip.com>
 <20220715152640.srkhncx3cqfcn2vc@skbuf>
 <d7dc941bf816a6af97c84bdbb527bf9c0eb02730.camel@microchip.com>
 <20220718162434.72fqamkv4v274tny@skbuf>
 <5b5d8034f0fe7f95b04087ea01fc43acec2db942.camel@microchip.com>
 <20220726172128.tvxibakadwnf76cq@skbuf>
 <262ef822025a205b1b4975c967cc5e5bd07faa16.camel@microchip.com>
 <20220912154244.azn3roke3rxyqdcb@skbuf>
 <66fee4c617dc073ce355addd19a9543cd1b344d8.camel@microchip.com>
In-Reply-To: <66fee4c617dc073ce355addd19a9543cd1b344d8.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB8192:EE_
x-ms-office365-filtering-correlation-id: fbef91c0-c203-4561-d447-08da9599f923
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RsOWAhD4QPsof0dWy8G0E51sSYABEcRZ/8Tbo6JS3EwluJPV/oGeOpqk9j2Xorl6lCa4NzMwkVrjCfVfzcsksGBzSlKb4ypD1xpilcW0WAatY2R7TITgoIgOJVoXH7OCqyWtqPtrlwE5kaGbKPCczmVQIbnj13UqR0DEkBhmR0mmk6daS1msdhNWVsHTI9UjdNnFnPnr+tx1xd4joxPSP9DXIAdEOf7NdHGt01xm3TlJ4uPS30OZ7DpccwtbeHKoUuUa3eFDrU/M8Uggq5nEsIkqTIsPb0+AENC4bZ9MLXl38qoepfSR53t2vJQPzya50Qm54Zyj3mvixP0eaWnRai6kPrU1WdLjpDdwh3GdfqRsrIf6PI75yxCFKPILMWxJvox1drGzEVIopiS1LM/MXy/owKirNgDjDvwwwdNoL4P+3ZRsRjVHy0QroyUxpCrkQVqV5eA20xGzgX1a3lYeoy5tnX+XmA45/mLaDSIBu41oLDn/aOC9pqHy2oe7aiuBxyOU7lj3bW/rqkqkGAbeKYPAdXtKuRUPjgjvUy8FpkAYhaX4Jx1GHHRU2MEjkiyMAf6bVPCeBVn5yf/P0N06s31zhelAyxREYJYWZ2fC8vfkkcKvO5Aro1pPCFuF4oTksucPNH55vfy5YJwMd4NjnI18MIImpW0vJ9MO+7OATWcBpY7f8WVB9jBu8niq+Wh+yPf4GzvDnGTP1LPpN1XvRAVyTn7dOJOVY2wn5TGMOPevCabLQCWnS4bOdM8pzfDo+5M0VY0UkUXj6Ql7oFJOHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199015)(6916009)(7416002)(54906003)(8936002)(6486002)(76116006)(41300700001)(9686003)(71200400001)(478600001)(186003)(38100700002)(4326008)(83380400001)(26005)(38070700005)(1076003)(2906002)(5660300002)(6512007)(8676002)(86362001)(122000001)(44832011)(91956017)(64756008)(66446008)(33716001)(66556008)(6506007)(316002)(66946007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pFrGBkrufH5CpmHQVLNulw3uWRFIp5BgTZVg3O5Fo6hsyoaiUL32CIgcypOq?=
 =?us-ascii?Q?laRTZPiGRKomzxxFmSaRPDFHd2dw6HMGbIoOP/Fo9IINfMIpejJJ2MFY/VTc?=
 =?us-ascii?Q?lIxb/mMjaiZwsCNTvaIVz8BkqetspNhLbHHq4BGOVIdk3jr563REDgQ4PVSC?=
 =?us-ascii?Q?6ZM/Rfyb13PVhfEmMGO+04cglUvMOjG0aZQGBodxK9hY51cqasj3KhfKybWO?=
 =?us-ascii?Q?XwgdIKg/k5f7WcQ1vkxYd75D8hsWctuzaCUh/FLkkIzsOY7cKhF3X0Bxu8gh?=
 =?us-ascii?Q?+zsTzCweo/YTAl3w+57OKar6g2Ozuuczxd0isGIGBPTw5u1QEjlDwFHtooBk?=
 =?us-ascii?Q?s986EUtK4lPixjyjL3toRIVCH2i5KyKkEMR9hKMSd2NXnV/pBOrCv3OEuQzf?=
 =?us-ascii?Q?TCOky2J/xzPNBqi148BQTx0/XDHIczp5SXxQ38jB7eq2+N+3+T8QnbVhE6ZL?=
 =?us-ascii?Q?RPSthSXfkoUaoCPw59RwQ5WMHETuNw7dYSzaHXcWlA4AFiFhE7keTTmmsr8X?=
 =?us-ascii?Q?gEgbDVjPhPKGJwMQ3Ldv+qycNMt8YdornV4iv31LN33s2QYOcaAH//kPJQbu?=
 =?us-ascii?Q?lT2Ls12aMK/4o1ID1jFK3Nime4cFqswDUgZBFVEgsqZlvw4G/rZuTyvNIWt7?=
 =?us-ascii?Q?CvzWjJbjkuh6LnWofm+wWFh58Yrhs664q4Dxbrud0dlSq7Vh/QkUeR8MB1th?=
 =?us-ascii?Q?yRLtK7iVt7U/74YbAEL506nD7QpsWSnNOYm6VmQrY9oUNnG8xgzs5I5hQRV5?=
 =?us-ascii?Q?SsAhj24M3ye+R8ITujj2RG9veG9Hq2vdul5VWxAUApMq+tBYkm5gzYF99gXF?=
 =?us-ascii?Q?kl2JaQ1e732hriKienheeBZC1mvLLI8eRWW35dL8BqXgx2/FAdbp7grlvVNT?=
 =?us-ascii?Q?PqQbTvIjMxLcNYPFGzv+2z8HLg/FBf3IIG/0an7W02DRQkit3sXdVZdRHXIE?=
 =?us-ascii?Q?6jivq/CcoXDPL+PrJ24/5+CAdp+7DOY64F7W+5HMDf3AQcWi3pmdvxNhckUh?=
 =?us-ascii?Q?MS47Cu6VD2TEYEm/wuyTP25RPSCsVe3RY7oPrpwnUlmmPg9R2Dlu0yGg6Cbu?=
 =?us-ascii?Q?0htWZiryk88To/znVfZ+2MWKJOKDI8Bw5cgbrZVS73YQQKWXpvFBjvEe2CdN?=
 =?us-ascii?Q?/LU/fNSpm3ZZv+7otLmylkaqER6/YAsbMV8fyDFFskkKh1Up1iugE2V3Oer6?=
 =?us-ascii?Q?CqlE7GhPMlVMuuLwD76zbWxxq2hWmL7xEYwnWFxrXvNFunu1ciYu5NXj6xMS?=
 =?us-ascii?Q?9aD7J20koVsT8NJaTh0hie+Hoyj7ITkzi75gmslfguwjDJyl14zXlrYBji7S?=
 =?us-ascii?Q?QUpOLN3dI7w6zkTSa3tGQDgfouQrWNkU9R+O32ewSRY5VFmYSkDJz4mhqBjf?=
 =?us-ascii?Q?JZ+sYUu94tOPOJf33tYEhfT9KYFp7W3mo6O+EI9hELsTMcfT9z7bMvrH0k40?=
 =?us-ascii?Q?UAaavK76jtMdK181vwZVVS6Uz+wtRelXExDAJ41cb52JVqhYZsyOlhRRxbtK?=
 =?us-ascii?Q?+PuqRgmr56e7vDVeitY4jcnYouFbwGcEF7PWhkUsxt395sWtd3gv85wyijmq?=
 =?us-ascii?Q?1ESIAYybzcl/oXP8SXOMH50rjw27+af36zrGD0fV/0JJI+4RTF82/pozQ85P?=
 =?us-ascii?Q?rQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <851E1EE5A0B66A42919F776BF6AB0BC6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbef91c0-c203-4561-d447-08da9599f923
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 15:09:36.8600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vC9Eo1Kx9KaIkzoFnFu3kkJCNxqROozk9nukbXc6wcPzGVKQIsZ892Kqr7bIDjUHbNrHmmzbAUHoUL0AmCo+6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8192
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 10:57:44AM +0000, Arun.Ramadoss@microchip.com wrote=
:
> In addition to above config, I had set CONFIG_NAMESPACES=3Dy, then the
> above error message disappered.
> But the ping is not successful.=20
>=20
> If I change the setup like
> Linux laptop 1 --> DUT1 (Lan2) --> DUT1 (Lan3) --> Linux laptop 2
> then ping is successful.
>=20
> If I use the standard kselftest setup=20
> lan1 --> lan2 --> lan3 --> lan4, ping is not success.
>=20
> I went through the comments given in this thread to bring up ping for
> openwrt, is that applicable to kselftest also.=20
>=20
> ip netns add ns0
> ip link set lan2 netns ns0
> ip -n ns0 link set lan2 up
> ip -n ns0 addr add 192.168.2.2/24 dev lan2=20
> ip netns exec ns0 tcpdump -i lan2 -e -n
> ping 192.168.2.2

You meant to put lan4 in a namespace and ping it and not lan2, since
lan2 will be a bridge port, right?

> I am struck with the ping test bringup. It would be helpful, if you can
> give some suggestion to bring it up.

Well, do you have unique MAC addresses for lan1, lan2, lan3, lan4? The
kselftests will ensure you do, via the STABLE_MAC_ADDRS variable, but
otherwise you may not.

Then, can you tell us what packets you do see reaching lan4 in the ping
setup? If none, can you show us the output of ethtool -S lan2 | grep -v ': =
0'
to figure out what is the drop reason (supposing the packets are dropped
at the ingress of lan2)? Or even tcpdump -i lan2, maybe the packets are
forwarded to the termination plane of the bridge, instead of being
autonomously forwarded to lan3.=
