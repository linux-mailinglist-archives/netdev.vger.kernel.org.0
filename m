Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63F6306354
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhA0SaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:30:11 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30908 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234727AbhA0SaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 13:30:06 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10RIGNYL021131;
        Wed, 27 Jan 2021 10:27:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=cG/FpoNvzBhVxn1zh7yAjd6xx/lwyL/CwsL4fWTxdnM=;
 b=bKxW3TCn5PwUP6sMFNn0TuoeBgUIDJxneTAaTQ3+a43Peteow/VbxjSNvBlTWpORqoog
 WXykLMhp3BmV76P+ndvKt2nJa3ilvir6ufoqRGDlZYbiDCf4vJH/zYFNUdUuXbMgiZI4
 6kTNCXXKIFRfznbufgZ+4S+QMcmdipNSGGE4iclTqF1XJFKRC9hLv//Ot50KsqbaOoix
 ZxddP/tiEqGfjC9Y+IxMq3h953P+zBEQtq1/N5uGgwLSp/YI23Tyu9xlWoZVXaKCX38+
 XCUe0typ7YPcfdVDJAMWqxWulrvj6frbEUEyV4qCDKba/0pDAviqbvzNn5zlW+cu6RUR Xw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1uckj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 10:27:12 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 10:27:11 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 10:27:11 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 27 Jan 2021 10:27:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hyvj1tVN0r4G44KQBfeAEoH+qIapKYSvtq31mjxsUpy47TIGrytlkR9kgcQaK9lK8T+wyHmSrSUs4nrSQmgIXYD9mt5z1RSffIUDqWDmvuJd1lhXPdphmyii28EFmKsZ3pmp8BSEIBsBrKb1sq+pcFBFr6QAIObrJzesx9lb5FNeGV3jiq4dTVPc63qPa//8ay7+0x2pko2mxIu0Rq3ksXVRqMA0+A2NV1fvVBVo2S7hWCa/PrQD3nP8V4PmhfZXAhkpU841DiwAt1ObwSwJxfrJ426JcIbojRAT6DUbKMAdt4xMPTxjuIKGNxIX55psk+JteUbmGDe9tfNTdRLQoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cG/FpoNvzBhVxn1zh7yAjd6xx/lwyL/CwsL4fWTxdnM=;
 b=KcFPKF41hh9cugP4r4/Bnhmp5ZoZh+nsCDhBd1+/zYxD6SK514oKC3PYph/ex/FzrFNzsRILtEQSTmB17++Vy3eHdTXregZV1sgbu8TBbatTCnxptVuWs8V3q2XHN5T6A6ejdttMrvp53zcRPCN25FlvJ2jAc734MNlmRvgDj5tSfJo956HcqNb+VV/pFJD1Xx5eUYpisTtUXRuus5wjXzmZ0HvY4LsbDORwJPguZec2YBc9VuvqbSWm44Vy9RSPTtE4hG5stsJU9DFu4uF32m71Xbd52FJSw2mzQoFtdSYQFiZyMShNJHKCXwRX72IRWqQ9QLh3KhXfPizrhi+7mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cG/FpoNvzBhVxn1zh7yAjd6xx/lwyL/CwsL4fWTxdnM=;
 b=UgoJrGUB2wtBBuNhnrjobjlfm+8I1Uj8BM9U8RuvFxh2R6eNnTbX63ikRNVADyI1HPkL4oByEbrv2sJ9ZslpcoP7yqGokeRXV2laFMVi6DCIC5JnxX6lnkEOKvS0NMXKi2otGjerFAND7Vl5qJa5TI1B+wu1gMIZEv2NFCuolWU=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW2PR18MB2313.namprd18.prod.outlook.com (2603:10b6:907:8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Wed, 27 Jan
 2021 18:27:08 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 18:27:08 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Miller <davem@davemloft.net>,
        "Nadav Haklai" <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>, Andrew Lunn <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        Antoine Tenart <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v4 net-next 11/19] net: mvpp2: add spinlock for
 FW FCA configuration path
Thread-Topic: [EXT] Re: [PATCH v4 net-next 11/19] net: mvpp2: add spinlock for
 FW FCA configuration path
Thread-Index: AQHW9KHK87rYitArp0eTTCYw2GfS5qo7vX4AgAAMt7A=
Date:   Wed, 27 Jan 2021 18:27:07 +0000
Message-ID: <CO6PR18MB38734006ECF7D37CC53BBC31B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
 <1611747815-1934-12-git-send-email-stefanc@marvell.com>
 <CAF=yD-JDGg2pxi_EQvuK5iRdVpTovswF6rZ8dvAAmV0xbeimkA@mail.gmail.com>
In-Reply-To: <CAF=yD-JDGg2pxi_EQvuK5iRdVpTovswF6rZ8dvAAmV0xbeimkA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.11.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67bfc11f-b7e6-4365-6aa8-08d8c2f12796
x-ms-traffictypediagnostic: MW2PR18MB2313:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB23133A80BF36344CB62C3E11B0BB9@MW2PR18MB2313.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D+3QTBjle1WXT/eLu+bxdpA5rSfdWmP7V0bRGnE/11Te9QhT6a3bxAF2tijUGVR0lglh+MhWABGrAtMn5XG0IUHZWBqqkcu9S2YWz0GkpPnBIMX4CAo5xyQe425PzdtvwyPT+ajVskYXODaol//zXwmfVfnXnnwupRrbvC22Dk4McmzcoztJ3kHNFpczVTX63B7UI6zwj6KxQjNix4Q1Jf1paNJA2KYQ4VUG2bRoYZfIMD8x4H8f5rqP3K0mo8Jl2bPGzCDrAEjhGjpirTNg9WQkykx0TuWwiLMqKFK+SdfIXe5gH5RLF6EfrFXTI9WU9r3EvamzWktlbQNGgvhsl++AqSCPsD0gLGxfRgF4qBArONh2mGP7cJ0WZmzQNVR9OCbC11uRPDygah7jMl4zYGuZeZagK6XZ79twwxaogM6W2ujOq1mcCfDo4Bah28wBukOhTAuac3oxC/Fem5rC/StrybcagxHMdd7XEvPjj6jgaW2nLFyJJgYl4pI/fPZVmuS8kNYTGD2p5WSCChFBZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(4744005)(76116006)(4326008)(186003)(66446008)(71200400001)(66946007)(66476007)(64756008)(66556008)(2906002)(478600001)(86362001)(9686003)(55016002)(6916009)(8936002)(33656002)(52536014)(5660300002)(54906003)(6506007)(316002)(83380400001)(26005)(7416002)(8676002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?T2JBVjNRY09oNExaS2NrSHMvREh3aWQycTJOMVdZb1VhSEI2cllVYS80Z3Av?=
 =?utf-8?B?bUpLY3A1SGZsK1NwaGMxeWdqMG9aZm13T3B5NzYvYlMvaXEwMjdxSk8xaFJw?=
 =?utf-8?B?NFVlK0R0YVQ3Q0JkMTYySnBPakJON1JiQWczQ01BbHpCNGJ6OUc0U0FxaGIr?=
 =?utf-8?B?UmlwMmc2U0xsNUNnWHhacFRwZ3p6ZDdsYkhwUHRXNlpvUkJ2WHZES3RPU1pl?=
 =?utf-8?B?NDBFWG1yRDdobUIrNzd3eUJ0Y2dxRTJPY1RHeG5LMXZQclpTKzRpdWFTNUc4?=
 =?utf-8?B?bWtMeUpsWHVmKzNqZmMzWXJPKzBEMHloYzZtSXR4VEVIL1dKa3Y3WGgzTzBl?=
 =?utf-8?B?dGRqV3F6M3Y1YkFyZjNBT2s5RDZsOXdtVTZqYXJiNGNZdFZ6d1Irb0IxbWJW?=
 =?utf-8?B?c3gzWllRZmdqeUJ1TllPc1NzSC8weDhVZmdYVWlLazRCbisrM1pQSWJHTDRF?=
 =?utf-8?B?dW5BR3c0elgrUVh5VkxEazU5aklpZXpkS1kxOC9uZGUyM2FmL2tNOFd2TUtx?=
 =?utf-8?B?SitQemx0eHdZWlRMUUtiVk5vaXdqOElNczZuOXIya0JaakVXZzljQ05UUWJl?=
 =?utf-8?B?WUM2cUxQaGpZd1JtZTJzS25JVzhoMkk5S25LSU9udXBQK2UrYVA1VmVYUGFM?=
 =?utf-8?B?QWxBZmMrMXdCRkhic3BPdmVzNEduMVl6cWlsUE56SWJpcmZiWTFhOXBSQ25x?=
 =?utf-8?B?TyttZWVwdkg1bmNVQTFFcHJqeENxbW9wTWlRd3RjbnU2MmVZbjNGUWtSRjZO?=
 =?utf-8?B?NXhkenZaT2FyV1ZLWG1wd3hkbDQzb3BHSG9tNS96NENjMjRxcERubExFako2?=
 =?utf-8?B?aU1yTHhCdno5RytRa0VzSFBiMG5xTVRkeE5BWUFPYzY2SlRsek85Q0ozN25G?=
 =?utf-8?B?MnpremhyYW1TYzhXWHlJZlFnTTFnTHlrNHAzTFJmVE1EeHN6N3BDeFZVcGNU?=
 =?utf-8?B?Z1JZREFlN0lvVUU5aFRQbkt0azU1ZStkTFI2SEdTRGJVYWo4anVPSTZaMjVn?=
 =?utf-8?B?WHF3MmhJL0ZMZWZjQ2pHN2h3MkltT3YvSHJ2YmtXY2E1VFd0M09RNWliYlNt?=
 =?utf-8?B?WDRlWFVkNHk3U0pDd1VKVEFWQlk5Y1dzdGwzNGlDeTNxY1J6R3VJSnk5eEpq?=
 =?utf-8?B?NGRTQ0VYSDFoVlkrNFhuc0IzcUdISUxoaVk5VThkQVFuUDNkVEkyR2gzNnQw?=
 =?utf-8?B?S2grUXRzeTNZSjhjSkdsYnJLMXlDM2NBelJYd0Z1WEJ4L3o5VEJpanBjTG5V?=
 =?utf-8?B?Y3dpbXFmT09DbnVSYnVjVTlVZzlxUzF1SGtHVFA4dVRqS3Z0R2hxTWtIbGp4?=
 =?utf-8?B?RlRZUnhDR0NXMHViUXBibWx2QlVlOVIyZzB3Z3JWTVppNU9ZUGY1SSsxOU5Z?=
 =?utf-8?B?MmRBaHZqMGQranU4Ym4vdERQUW5lVS9ydnE1YVUyTVlwU3NJVEdVN1YyN0Rn?=
 =?utf-8?Q?r7aPpYSD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67bfc11f-b7e6-4365-6aa8-08d8c2f12796
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 18:27:07.8368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vGzUjnJHSaPT5mCiK4dyYg+5S+YvoBFvOTM1Bu6h6LSWfpaG/oLeuotP/cQVZFno6CTIzE9T8QZmp4vzPxVWwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2313
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_06:2021-01-27,2021-01-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IGluZGV4IDlkODk5M2YuLmYzNGUyNjAgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMi5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMi5oDQo+ID4gQEAgLTEwMjEsNiArMTAyMSwxMSBAQCBz
dHJ1Y3QgbXZwcDIgew0KPiA+DQo+ID4gICAgICAgICAvKiBDTTMgU1JBTSBwb29sICovDQo+ID4g
ICAgICAgICBzdHJ1Y3QgZ2VuX3Bvb2wgKnNyYW1fcG9vbDsNCj4gPiArDQo+ID4gKyAgICAgICBi
b29sIGN1c3RvbV9kbWFfbWFzazsNCj4gPiArDQo+ID4gKyAgICAgICAvKiBTcGlubG9ja3MgZm9y
IENNMyBzaGFyZWQgbWVtb3J5IGNvbmZpZ3VyYXRpb24gKi8NCj4gPiArICAgICAgIHNwaW5sb2Nr
X3QgbXNzX3NwaW5sb2NrOw0KPiANCj4gRG9lcyB0aGlzIG5lZWQgdG8gYmUgYSBzdGFuZC1hbG9u
ZSBwYXRjaD8gVGhpcyBpbnRyb2R1Y2VzIGEgc3BpbmxvY2ssIGJ1dA0KPiBkb2VzIG5vdCB1c2Ug
aXQuDQo+IA0KPiBBbHNvLCBpcyB0aGUgaW50cm9kdWN0aW9uIG9mIGN1c3RvbV9kbWFfbWFzayBp
biB0aGlzIGNvbW1pdCBvbiBwdXJwb3NlPw0KDQpJIHdvdWxkIGFkZCB0aGlzIGNoYW5nZSB0byBh
bm90aGVyIHBhdGNoLiBjdXN0b21fZG1hX21hc2sgc2hvdWxkIGJlIHJlbW92ZWQuDQoNClRoYW5r
cywNClN0ZWZhbi4NCg==
