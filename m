Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D9135ED20
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 08:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349193AbhDNGTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 02:19:22 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:55168
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232405AbhDNGTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 02:19:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jas3tnNcNbwNR7Ce48u7pRF+xYUYDdX44mefiH6AcPgEV+S1J5Nlsu/WffMDAsmgraPsYIEiJgbt82BM30NW6WamrdEXsp72E9efGJJ0Jp23bSbmtHwvRKbjDTaHtUYz/32AF+91aSllLucQd36tWOwsvlu6Q42PJOGcu2B8u1mzuXdzyw0a+azgWT4sJcTQKO9yM8tYsdxLLKmxNwutCqQp/Rg9lMnlHkrSPEfFL4RqfZCryhHP1NGaRIxv/oLzrTpHaSHuplh7zXE2JS8ch3jSr3iHF2tC8ZN9G036gKT5uGNiWBwBNCXudtT23UAsO0rDW6RmCcVgmoEbrxOWCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BY78f2GIIO/e3oXRth+JtdHOUKHGfDHBI5Cyu22vEp4=;
 b=MzaEh62lvtYp06ozVslw2hKYSCtl0vYkQ3W96HT9IsI36/SutJ1XbFtwJqHWlnxSoJxGIti11u00iDeIf/EP4wIJZbtAG41VfFt4IusHesIgXwTigvDeK3sLgj7ZZf1ShBajfCvQyhvpHzdUzTPAk6rzdxkRbXNaULDDp3h7DzFcPNRHiZ3WTQWKtFkTymXaCc1wQzA0pV7f5I1yUsJ0P6rLausX3FYd3Ml9Rn9Wh5fq5DQTMGLztjNQNuQZLCLr8vrGTt0IiRRNVwuMVsw40+JLPzc3ljNm5qYsTnVtqAyR1ZSv3vzVg9yaGhy46Njd4FOeEQQZOJm4VK/s/zQIGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BY78f2GIIO/e3oXRth+JtdHOUKHGfDHBI5Cyu22vEp4=;
 b=iyZHKDL3SU2Aqkx5OuKsGnxoTBvAIOd/i8LaEb3G1IeU27AiMn/ZfiOTXV6FTJd3sBTbDd1MHoA8PDGgulw3MNYZ/WGRjJmCc0etoN8Zr3KfeRN6nhYABE5X8JHzVCklNTbBLemMye+KvntaT1WQMZ59wfUoq00iSxfolwB+pKY=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AS8PR04MB8183.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 14 Apr
 2021 06:18:57 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.4042.016; Wed, 14 Apr 2021
 06:18:57 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: [net-next] enetc: fix locking for one-step timestamping packet
 transfer
Thread-Topic: [net-next] enetc: fix locking for one-step timestamping packet
 transfer
Thread-Index: AQHXMBbxUAh74ZmQ7kaFEfOTMU7Q+qqyr7+AgADYi+A=
Date:   Wed, 14 Apr 2021 06:18:57 +0000
Message-ID: <AM7PR04MB6885805B7D5D11DD8DC1CA28F84E9@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210413034817.8924-1-yangbo.lu@nxp.com>
 <20210413101055.647cc156@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210413101055.647cc156@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abab64a9-9d54-4481-b88b-08d8ff0d2fe8
x-ms-traffictypediagnostic: AS8PR04MB8183:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AS8PR04MB81835B1832C1C66F01E80DA3F84E9@AS8PR04MB8183.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 15ZoFoz826AYBQlgN01yZoADJZl+zW89yfVrzri21bn0/SST4bbSmbegnXLIAmcpyML4le39amJiU0bzEmHG3v3ecJXSnVdf91kuDmDk2rmcbU/NwKWSnABEdIHH+FR34YiBhv8SCTlakwcMvkbb7FORc2dZS1tVUvffuJVaIahUgwb13Jppj/i1d0viQwptj6qyDoRHx4mA/P7/Igl7/TpQCRinLfdmXIMcm3lEmVd/sCOTnTFiYMOJmBZlKmHXcCUaCFxDzTpNGHmOLRoI/mdHihCAVIJACHCo+x4WKV80vM228Sw0RzCr+jsAa3CetJHcBZ73DTipIC6n3/L5FDnt0HMfuOG0QxClZ5d4tFbazwhMQBut6x/SDX6ki3ZoJXT0XKiPeeImfVlslSTmSp62OuEYm1/W8EQydXn8H4w3nJHduU7F2ysAz7+plsCTyBSbQ3aBOzc4m+aDidZ6GuJdjIcisKJ/umknNsr8fkom/I+jqsyUTq0eGf3f1kE6vjaNmqCAVWSw7ZBK/U/waO0vwX1K7S+uewlvZwrYj8i0iiN2Q4pPPtaoSu7pevi4ZbSI9oKPTqKgzkj654kg5pUMjlEEtwyLfB/eG37PBTkLSXGXEJBRd0VPloRij74ozBC4WgpqNKpFkgK0k9IfraZBr//9cZkPYzvEweurhhI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(5660300002)(53546011)(6506007)(7696005)(122000001)(26005)(186003)(83380400001)(38100700002)(4326008)(71200400001)(478600001)(33656002)(9686003)(76116006)(8936002)(55016002)(52536014)(8676002)(66446008)(86362001)(54906003)(966005)(64756008)(6916009)(316002)(2906002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?d2c4aCsyVFlRVFd2a04wdjhJMGlMQmNUMjdRTE9qek03NExZV1phaU5lQkFF?=
 =?gb2312?B?Z3ZHVnlVelVYRXZZSjNaSG9YY2VXcnZ5WUIvR0JYdHc4ZHRiUy9FK3ZDZmJh?=
 =?gb2312?B?T29oemZEb0dTOGF5blpOVWZsenFTb1pxWEZ1UUNveTFDZlBxT2ZkVDB1WnZS?=
 =?gb2312?B?K0ZNNE11Qkt4SWI5Q0ZYU3ZwZDM3alJmeFNwb2h6Q1cwMUNtRFBuQ3d2Nldr?=
 =?gb2312?B?TkR1WEhtcWgzaUFEbVVnckpVZjBWOTRJdXE0RmRVZE0vbGpTS0NNN2ZRRzdy?=
 =?gb2312?B?TnJqNTB0bElpQ28vWVBYemJoa2JPdC9Vcm1zZis2QUJ3anVEQktodm9tNTYz?=
 =?gb2312?B?QnNDdUhRQjN0YTdxSjFtSzlacm5pK05MY2ZZZjkyVUtCMU1iSGVSRW9VTzd3?=
 =?gb2312?B?OVJZWGZRUk1kUzlGTGZnUGV6QkNKZVRoMm1OVjRFQWhuRWRpTHcraHJZcXJI?=
 =?gb2312?B?QnV4ZFJPdTNzS0ZXNmZTeEVIVU5xYVZNalZJSGpJWGl1NW9PbDc1K0swWDZY?=
 =?gb2312?B?OVBHM3poaGhGK0xpQnpRdHJKakZjaWJnUmp4OU9pRTRUa2xYcHVzaktNVS9K?=
 =?gb2312?B?TlJkSkpxdS9jOUNaYnF1cmdXL2FhVm82eTJUazBpZGl5MnFiKyt6enR3bzJs?=
 =?gb2312?B?R0dzRnQraEE0SElyL3diTGFza1V4bEI3bDJoMDN2VWdVanJCM2p3eDQwRWxF?=
 =?gb2312?B?NjZTTzF5a0d4ZXBiUUh3bFpndUcvSm55dU9ScmRLRWs4VVFaYmNPVlY1b1V4?=
 =?gb2312?B?eHFYcUFzVmQ4RjFZTUp2U3JjeURpcVpMZnJzaVp6VC9QZEMvVmNaUXhaUm9M?=
 =?gb2312?B?cEYxajg2aWJCdE1CeDVTWVFNN3ZieEh5Y05NelB4azlmZnJKY1FSaEVKZ3Nh?=
 =?gb2312?B?dFF6KzNxMGFOenhaZlRYN1o2dXp3WFdZVEh5alE5MGU1MlhINXRxNWZMd1l3?=
 =?gb2312?B?WmpIY2wrNm5zZVprOThvUmVTcDFyL0RSbzJVQWJoeDZsTk1ML2pzb0dIT2N4?=
 =?gb2312?B?WXpYSkpLU0FXVEFjRVpHNEd4K1lsR0Q5N0diWk9KZFdDNGpCT0NsK09acDVi?=
 =?gb2312?B?bmRueVhHRE1mU0NldlY5YzFJT0Z4NXpDN3NuV1NKSlhUeTZQczA3aS9ySFd0?=
 =?gb2312?B?cXJGNG5wOE5Jd0txOXAxOE0yU0hVeXY2QjlLd2dxdUE3VGw5UUt0RWxiN0NS?=
 =?gb2312?B?cS9OT2pxTEJGdlM5Wmh6U0Jtek04aThTNmFBbVk0eXBuZml5V3JsdWtPcmNO?=
 =?gb2312?B?ejNSQVNMZkJvaHErbkpyRHhsRGFJdHU2NVNUeG9yblA4UEdqMVBoekFhZVhn?=
 =?gb2312?B?Z3pCSUdWTXpSMWc3akNqMW5jcE1FRHNRdDltSnRYbU1jcXEzTzNSNStmdnpN?=
 =?gb2312?B?UENwQnBqUHR5TWdVenpSMEc0NDNoM0V5NUhsTFhrQitWS3E1MllSM1ZpUTVm?=
 =?gb2312?B?My9aSWhGeXJUZHMyRlRnTGo2UWNrYlZDcmNCV3NGcUttK0o5ZTVDYk9ueE1p?=
 =?gb2312?B?VElEZmdla2w4aEdiOTVhSTNGSC81ZjYxbHdsdmVOaWN1S0tsdWRNWDZVbVdD?=
 =?gb2312?B?bTRqWVFEclJiYWhUcTlSZnFsVFE4NTJwZnUydmM0MmhTVGJIZ0FadTgzMGYr?=
 =?gb2312?B?cU5RTStnUTBFVTlhdjFCeHZ3ZVRwOGNaWUpEenB0TGpsTlFCYmVHUXl1SDlK?=
 =?gb2312?B?L3FGai84Y3YrcnV6U0FML2dLOWkyejRSVlRlSCtNMWUrNkJtWSt3QXJsMWk2?=
 =?gb2312?Q?3gby+RfoiF3j56xP6MSKIdDLfkvC+MyBWB2tlHR?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abab64a9-9d54-4481-b88b-08d8ff0d2fe8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2021 06:18:57.5537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b278x98BJfw9Qpi/dLauxErk0IMFgIpC2RBnGmZNqmgdEus8n3t8ulxqzDHBxj7PHv8aG+VEvLFTp2GSkzcQWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogMjAyMcTqNNTCMTTI1SAxOjExDQo+
IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmc7IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBSaWNoYXJkDQo+
IENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT47IENsYXVkaXUgTWFub2lsDQo+IDxj
bGF1ZGl1Lm1hbm9pbEBueHAuY29tPjsgVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5A
bnhwLmNvbT47DQo+IFJ1c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiBTdWJq
ZWN0OiBSZTogW25ldC1uZXh0XSBlbmV0YzogZml4IGxvY2tpbmcgZm9yIG9uZS1zdGVwIHRpbWVz
dGFtcGluZyBwYWNrZXQNCj4gdHJhbnNmZXINCj4gDQo+IE9uIFR1ZSwgMTMgQXByIDIwMjEgMTE6
NDg6MTcgKzA4MDAgWWFuZ2JvIEx1IHdyb3RlOg0KPiA+ICsJLyogUXVldWUgb25lLXN0ZXAgU3lu
YyBwYWNrZXQgaWYgYWxyZWFkeSBsb2NrZWQgKi8NCj4gPiArCWlmIChza2ItPmNiWzBdICYgRU5F
VENfRl9UWF9PTkVTVEVQX1NZTkNfVFNUQU1QKSB7DQo+ID4gKwkJaWYNCj4gKHRlc3RfYW5kX3Nl
dF9iaXRfbG9jayhFTkVUQ19UWF9PTkVTVEVQX1RTVEFNUF9JTl9QUk9HUkVTUywNCj4gPiArCQkJ
CQkgICZwcml2LT5mbGFncykpIHsNCj4gPiArCQkJc2tiX3F1ZXVlX3RhaWwoJnByaXYtPnR4X3Nr
YnMsIHNrYik7DQo+ID4gKwkJCXJldHVybiBORVRERVZfVFhfT0s7DQo+ID4gKwkJfQ0KPiA+ICsJ
fQ0KPiANCj4gSXNuJ3QgdGhpcyBtaXNzaW5nIHF1ZXVlX3dvcmsoKSBhcyB3ZWxsPw0KPiANCj4g
QWxzbyBhcyBJIG1lbnRpb25lZCBJIGRvbid0IHVuZGVyc3RhbmQgd2h5IHlvdSBjcmVhdGVkIGEg
c2VwYXJhdGUgd29ya3F1ZXVlDQo+IGluc3RlYWQgb2YgdXNpbmcgdGhlIHN5c3RlbSB3b3JrcXVl
dWUgdmlhIHNjaGVkdWxlX3dvcmsoKS4NCg0KcXVldWVfd29yayhzeXN0ZW1fd3EsICkgd2FzIHB1
dCBpbiBjbGVhbl90eC4gSSBmaW5hbGx5IGZvbGxvd2VkIHRoZSBsb2dpYyB5b3Ugc3VnZ2VzdGVk
IDopDQoNClNlZSBteSByZXBseSBpbiB2MiBkaXNjdXNzaW9uDQpodHRwczovL3BhdGNod29yay5r
ZXJuZWwub3JnL3Byb2plY3QvbmV0ZGV2YnBmL3BhdGNoLzIwMjEwNDA4MTExMzUwLjM4MTctMy15
YW5nYm8ubHVAbnhwLmNvbS8NCg0KQW5kIHYzIHBhdGNoIG1lcmdlZCAoNzI5NDM4MGM1MjExIGVu
ZXRjOiBzdXBwb3J0IFBUUCBTeW5jIHBhY2tldCBvbmUtc3RlcCB0aW1lc3RhbXBpbmcpDQpodHRw
czovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbmV0ZGV2YnBmL3BhdGNoLzIwMjEwNDEy
MDkwMzI3LjIyMzMwLTMteWFuZ2JvLmx1QG54cC5jb20vDQoNClRoYW5rcy4NCg0KDQoNCg0KDQoN
Cg0KDQo=
