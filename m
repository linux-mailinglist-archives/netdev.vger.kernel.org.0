Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFB6666BA1
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 08:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbjALHdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 02:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbjALHdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 02:33:16 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2134.outbound.protection.outlook.com [40.107.113.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBEABF5A;
        Wed, 11 Jan 2023 23:33:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEyxFEOkOqVAjYVXTOCPO2YVMHSRFeJmSayi0UjgqAbv2qsVWwRECxomBZCiyst7BYl9Fxk6anWFP+W2XcF8wNuxabt2PVfpELQmiE58VT17NFwtO855XVz//USFKnSu9PFX4ub+9XcLUnpqMAWsnhFbB6ZBjiXq00mnuacupfdwzXhVb/K4gEvO0FnNuacZBVfjX+hVAx+b+Unf1tRBLip7VxhaX+9NDlYY8du6EkJr5c0KlQFGBCl9jQ+HtKi0tN/dzBjjPTZzcL5imdSE/s4ttct15SNsP4E/bwOmAQVXM6rrP9mcj1Uga1H/s5F03dcc8HT3n27WeHhOWfwKQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSBRcrSuwn1zytFeB72dxygkBkgMLnv/GYxNMJEqxsg=;
 b=QMaJ3OI3rW0x1KoKSC6u13SvMFgX9wwGffXzToXlkSeW4BOLMYin2Xg0nVZgv+XGKI1H1E2PMBUwVB6hyQfN40cq7QH0E5rmUk0OA111BVptC9CmsTDUqb7UaF4m9GnFveQ2d459ytIcwXEyUrbPfBCuXzzkxDLoB5NqBpV3pztie9SvLO7PUDkq0YPsMm5N5Yx2YkcfawJORsOauaNKbG3gI5tMijEDtRNmtAlzPznqBpp/vc19pFLI/pEi9m8ro7bfqHodWAFUX9q2V0q6UupBfPsGhfN8IzEJurmWCfYHseWNhRKAcuZxQdQKMrMOl6SFL/+UVFaJjwVvxVIAAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSBRcrSuwn1zytFeB72dxygkBkgMLnv/GYxNMJEqxsg=;
 b=mIwq2CBauR+wAyLupV4xqF43ZsdTH94Hn78Cd5hT996e3uTv45d9m1jgSbExgzcAgfq6fiNNyEat+ZDNnlBdLdl13SBhtJrKZdC8ljJNktR4wkf4ncIkD4IAvnarvBRQXhGTLiM/R/aTprrLy+5j1h81+ukrIk2dpd3g4yGuB3I=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB8518.jpnprd01.prod.outlook.com
 (2603:1096:400:154::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 07:33:14 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%8]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 07:33:14 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     "Arun.Ramadoss@microchip.com" <Arun.Ramadoss@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v2 1/4] net: phylink: Set host_interfaces for a
 non-sfp PHY
Thread-Topic: [PATCH net-next v2 1/4] net: phylink: Set host_interfaces for a
 non-sfp PHY
Thread-Index: AQHZJLC4Dx6ik3GqtkiCVbzySOtSTq6XtDoAgAKvURA=
Date:   Thu, 12 Jan 2023 07:33:14 +0000
Message-ID: <TYBPR01MB5341342416E98A8A26E900C3D8FD9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230110050206.116110-1-yoshihiro.shimoda.uh@renesas.com>
         <20230110050206.116110-2-yoshihiro.shimoda.uh@renesas.com>
 <c03cf325b9ab5d0bbf38508336ad0aba6dfbf81b.camel@microchip.com>
In-Reply-To: <c03cf325b9ab5d0bbf38508336ad0aba6dfbf81b.camel@microchip.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB8518:EE_
x-ms-office365-filtering-correlation-id: 0bec9de4-d0ff-4570-db27-08daf46f43b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OdHTKJhO/VQHe/SDz6Jctgh1ytz3Uc/cmNuqP820hRwukJ5lOc9DPaiS8A2x4F2ubuKXKNcZ11ukGucIsBS+9/8WlQRjgEpXI6+yXn1RTdjx6kysRE4+EQB02ByrECHCb80OzyW+j0OZ8TlsYa4YJZMClQfrbGEzYXo2ia0ECZ7XESAHTmqQQg7xaucB1Xm+IYpDIxAeA71J2K4gUGy95l+VNfv/36s/EJOZvMGMClicTsVulR85+6yYmuT9AQU8jjPsK00tWinqMQ3iV7xV/aIWKitIGsEMS84KcbM9y8vjC4eoNyro20AAhSNOhSfqaErfCmb97+ZMSdDgMbpbu5tMoRcV2lXc4R+rhGUsOwwxgrG6FdJF5UM5DK5jHx8g5deNWgsq2vOKF6zljlkcWkn7y6RAF0v+nM5uQqLhDE18ZlftMGbEbyTzobZrL5qi055rKZR17bcob3aJfhyi5COYGbPHReHv7Zaj8N5DdFQLKg3k/4SdJpEAasV9m7vMHE+LU32VcOtTvs2v+UMOedZuaztIMcy5UcnKjMrCvp0iMILLk013M10Cyul9WwWsGVEM0i+cD+b9oBpaItC8n1lXyUc6cPdQUFjsyUyDVrCBV5IusLROgZFjOjCaTEclSAkSpVE78inGY5gvvf0ufXwxeWG1wNNL8vdLFt86fuf+Z59cnAYum6rt3Mj5GPRc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(71200400001)(7696005)(2906002)(38100700002)(86362001)(33656002)(83380400001)(9686003)(55016003)(6506007)(186003)(26005)(66476007)(122000001)(5660300002)(7416002)(64756008)(66446008)(8676002)(66946007)(52536014)(4326008)(76116006)(41300700001)(66556008)(316002)(8936002)(110136005)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amtkdlArVWV0ZWxIK0lNd3NhKzU5ekxQS0Znbk5PVjdOQ3BlQjVha1dSM0w3?=
 =?utf-8?B?UzBpcjdDMy9DU2FiTDFTMnh3M3M4Q29XZ3JEenRxQ0lwS2dxVkVHRlZVWHlW?=
 =?utf-8?B?VUhaSHlaOHk4aGxBSEwyenZoaXZ3SmVuRHRjUzNycTA4WFlrWjFrM2kzQWwz?=
 =?utf-8?B?ZmVuWWxqWUprVTBoNTFhNnNXWExKdy9NSlc1SUJDbmlLTW80Y29oSW1pZ1Bw?=
 =?utf-8?B?WkVKdVhjOGlDQjhHbTdTMFFXWUI0ajFTOW8wQ3p4MGdmcVhHa08ycGFoMTZk?=
 =?utf-8?B?eFZMUjZ5NXR2bS9RSXVKRzJ2eDg5Q2Y0bkM1YXZqcmJWcGhESUt5Y2llY1du?=
 =?utf-8?B?UVpCMlh2UU8yNWFWMmoyZ2dLOTQxcEhrOFdYcVFlS0YzMGovZmR4MjZueVdj?=
 =?utf-8?B?MlB3dDllaHpmWGs3R0JtNkE2dHZYNFh1Q2xGWCtEcHFFclhqdk1qL28yTllx?=
 =?utf-8?B?WXpnWFVMNkFkaUtWblJxYXp4cDJmNTNhdGJ1dkRBT0c5eXpVbW9MS01xU3py?=
 =?utf-8?B?SHczd0NpV1QwMlhzaitBOXZ2NFFnSVBEK1Y4YmxmMUZvNG1xQW0xYVFzRXRi?=
 =?utf-8?B?UXp3TEFsNGR0OSt4VnJUazZJZ01qSTN5dE54WndLaTZ6Z2NWYVV2bjFHU1Vu?=
 =?utf-8?B?MDh6VTBhMlZiallLODJ2SkYrTGY4aWQ5bTM0ajU3aitISEE0K2R2cXpUTkpP?=
 =?utf-8?B?KzNwMEhRTE5VcUdyZjZqck5NTDgyWmhpTG5VVTc3d0NCWEVWREo2RTM5cmFx?=
 =?utf-8?B?OUJrU3JsekJoMVVCZXp2S3E0MTkvYTRSdHdrdUZ5R1g1SlA0TkQ1dW1QekZm?=
 =?utf-8?B?N0duSHJtNFMrQUJiUm95M1E5L2lyb2hKRnlDYUFEM2xmN2hGbUdYV2JmYUNv?=
 =?utf-8?B?Z0djNG9BU3Nyd3cyeFNWRlo4bEExUW9hT3RkSVpONjFtN0haVmd6OFQyMmQz?=
 =?utf-8?B?T2t4ZkFnVFhic2Evcnh3UmhsRkpzcDQ2QWlzWnJndXZMcEM3ZklIN056a20z?=
 =?utf-8?B?b25ZZ05LY0k2RzQvUmo1Z0dKNnpNOE1Ca0ZRM1YxVTNjaWFyQTV1OFdzcFlQ?=
 =?utf-8?B?K1VSbWtwTEJPU3JDSFVibFBGM0hoYjJIb0pncGRZMXJsbHp3VlRiSGg1cWNm?=
 =?utf-8?B?VzlSaVE4b0t6N0ZzVkZOZTlFUmQ5Tlhtd2ViRjNuY2Q1UGlGWThCdGJEMWts?=
 =?utf-8?B?SklvVVB5MDdBVnhjY2U0UUhGd0lIS0JJZCtLWHI3MTRHUnlxUzMyeWE3b1da?=
 =?utf-8?B?TXFJSDR1am84M1VTZmNuMlZEa0FCNWVKWUlTVVBoYXgvUnBrWUI4OXZ3MU5R?=
 =?utf-8?B?WEZRaEFQcHBmbHlZZEpROHR4Tllzd28yazJ3bFdlOXVpakVVUnh0bDYwN1pp?=
 =?utf-8?B?OGhjS29laHFmZm1vUW5yL3VEcmhMS2Z5RW1GSmFvU3RDbDBKWjA5MHB1a3hT?=
 =?utf-8?B?TUx0N2R3YlVQVjRONjd5MkNFbm83MndGbHFud3pEQ1BpeGZNTDlOcTF3TzFD?=
 =?utf-8?B?WHZBVXMzelBzektCK1dDc1ZuUTBYaGhaV2hjSUNHVFYrUHJwTnFFNEZZcFlJ?=
 =?utf-8?B?Zm1ZRy90MUhZVUkyRFNIRjJzRVcyUmhwVXZZMHZ1VWNzZjRJMnA1TytnMHp5?=
 =?utf-8?B?eEtSN0x4TGs0TDQ4K0h6RG0reHd6OSszYmYrSTluY2czaG10OTFCWWJkQ2hV?=
 =?utf-8?B?WnpIWndUMHNqNmxRZTM2QnhUbkZnMGU0SXdNTG1KK3V4ZThvWDcrZlJ5S05q?=
 =?utf-8?B?TlVuc05GWkpETkt6ODhQMGlqd3ZHSUhlWHZhdk5lcjhqbG9XNlovUWIxekd3?=
 =?utf-8?B?d3pqMXNXclFIRTNrRmpCYmNveGVHKzBSdStoRFp3b2t0aURPVG1qMS9YQW5I?=
 =?utf-8?B?MGdnRVJrY3RqK0Foa2N6ay9BSDFYOFdlNk5sY2VMWEVOL25waFdhRHN6bUZ4?=
 =?utf-8?B?T0dpNndCWmRCc2tkRUJ2SFdTOVRVYXNKTXp0R0NPSmdUYlpnWE1TUVdnenhw?=
 =?utf-8?B?djkwZjQ1WFB3NTBhMmVXaWxvSjJjRkEvWGpDVUZZdFpDcnJsRTROS25hZ1JW?=
 =?utf-8?B?aklrbXYzT29BM2xiVUp6c09MeUpBWjcwNkdQZUZlQUZ0d1ZtMW5qM3N0QzF5?=
 =?utf-8?B?dVFHR291YSsxRnBSWmMzcmt4ZXRMaHBPejBJaDdDTlo4QkxjY2ZUeGVQc254?=
 =?utf-8?B?M2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bec9de4-d0ff-4570-db27-08daf46f43b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 07:33:14.0834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pys2yQ7gyEvFs8H42nQ1UAnAgPe4QmUZ2iyGVgrHm0oft/uDNwihR5WNUoM1wpLRsNdLZPjlJCqbhVaM4wurC9Gr1cXgc5VgGd8awHZD2I/YuSpYNVS1lFRdlmsY5+1+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB8518
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQXJ1biwNCg0KPiBGcm9tOiBBcnVuLlJhbWFkb3NzQG1pY3JvY2hpcC5jb20sIFNlbnQ6IFR1
ZXNkYXksIEphbnVhcnkgMTAsIDIwMjMgMTE6MjEgUE0NCj4gDQo+IEhpIFlvc2hpaGlybywNCj4g
T24gVHVlLCAyMDIzLTAxLTEwIGF0IDE0OjAyICswOTAwLCBZb3NoaWhpcm8gU2hpbW9kYSB3cm90
ZToNCj4gPiBJZiBhIG5ldyBmbGFnIChvdnJfaG9zdF9pbnRlcmZhY2VzKSBpbiB0aGUgcGh5bGlu
a19jb25maWcgaXMgc2V0LA0KPiA+IG92ZXJ3cml0ZSB0aGUgaG9zdF9pbnRlcmZhY2VzIGluIHRo
ZSBwaHlfZGV2aWNlIGJ5IGxpbmtfaW50ZXJmYWNlLg0KPiA+DQo+ID4gTm90ZSB0aGF0IGFuIGV0
aGVybmV0IFBIWSBkcml2ZXIgbGlrZSBtYXJ2ZWxsMTBnIHdpbGwgY2hlY2sNCj4gPiBQSFlfSU5U
RVJGQUNFX01PREVfU0dNSUkgaW4gdGhlIGhvc3RfaW50ZXJmYWNlcyB3aHRoZXIgdGhlIGhvc3QN
Cj4gPiBjb250cm9sbGVyIHN1cHBvcnRzIGEgcmF0ZSBtYXRjaGluZyBpbnRlcmZhY2UgbW9kZSBv
ciBub3QuIFNvLCBzZXQNCj4gPiBQSFlfSU5URVJGQUNFX01PREVfU0dNSUkgdG8gdGhlIGhvc3Rf
aW50ZXJmYWNlcyBpZiBpdCBpcyBzZXQgaW4NCj4gPiB0aGUgc3VwcG9ydGVkX2ludGVyZmFjZXMu
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZb3NoaWhpcm8gU2hpbW9kYSA8eW9zaGloaXJvLnNo
aW1vZGEudWhAcmVuZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L3BoeS9waHls
aW5rLmMgfCA5ICsrKysrKysrKw0KPiA+ICBpbmNsdWRlL2xpbnV4L3BoeWxpbmsuaCAgIHwgMyAr
KysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L3BoeWxpbmsuYyBiL2RyaXZlcnMvbmV0L3BoeS9waHls
aW5rLmMNCj4gPiBpbmRleCAwOWNjNjVjMGRhOTMuLjBkODYzZTU1OTk0ZSAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC9waHkvcGh5bGluay5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvcGh5
L3BoeWxpbmsuYw0KPiA+IEBAIC0xODA5LDYgKzE4MDksMTUgQEAgaW50IHBoeWxpbmtfZndub2Rl
X3BoeV9jb25uZWN0KHN0cnVjdCBwaHlsaW5rDQo+ID4gKnBsLA0KPiA+ICAJCXBsLT5saW5rX2lu
dGVyZmFjZSA9IHBoeV9kZXYtPmludGVyZmFjZTsNCj4gPiAgCQlwbC0+bGlua19jb25maWcuaW50
ZXJmYWNlID0gcGwtPmxpbmtfaW50ZXJmYWNlOw0KPiA+ICAJfQ0KPiA+ICsJaWYgKHBsLT5jb25m
aWctPm92cl9ob3N0X2ludGVyZmFjZXMpIHsNCj4gPiArCQlfX3NldF9iaXQocGwtPmxpbmtfaW50
ZXJmYWNlLCBwaHlfZGV2LQ0KPiA+ID5ob3N0X2ludGVyZmFjZXMpOw0KPiANCj4gQmxhbmsgbGlu
ZSBiZWZvcmUgY29tbWVudCB3aWxsIGluY3JlYXNlIHRoZSByZWFkYWJpbGl0eS4NCg0KSSBnb3Qg
aXQuDQoNCj4gPiArCQkvKiBBbiBldGhlcm5ldCBQSFkgZHJpdmVyIHdpbGwgY2hlY2sNCj4gPiBQ
SFlfSU5URVJGQUNFX01PREVfU0dNSUkNCj4gPiArCQkgKiBpbiB0aGUgaG9zdF9pbnRlcmZhY2Vz
IHdoZXRoZXIgdGhlIGhvc3QgY29udHJvbGxlcg0KPiA+IHN1cHBvcnRzDQo+ID4gKwkJICogYSBy
YXRlIG1hdGNoaW5nIGludGVyZmFjZSBtb2RlIG9yIG5vdC4NCj4gPiArCQkgKi8NCj4gDQo+IENv
bW1pdCBtZXNzYWdlIGRlc2NyaXB0aW9uIGFuZCB0aGlzIGNvbW1lbnQgYXJlIHNhbWUuIGZvbGxv
d2luZyBjb2RlDQo+IHNuaXBwZXQgaW1wbGllcyBpdCB0ZXN0IHRoZSBTR01JSSBpbiBzdXBwb3J0
ZWQgaW50ZXJmYWNlcyBhbmQgc2V0IGl0IGluDQo+IHBoeV9kZXYuDQoNClRoYW5rIHlvdSBmb3Ig
eW91ciBjb21tZW50ISBZb3UncmUgY29ycmVjdC4NCkJ1dCwgSSBkb24ndCB1bmRlcnN0YW5kIHdo
YXQgSSBzaG91bGQgZml4Lg0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0KDQo+
ID4gKwkJaWYgKHRlc3RfYml0KFBIWV9JTlRFUkZBQ0VfTU9ERV9TR01JSSwgcGwtPmNvbmZpZy0N
Cj4gPiA+c3VwcG9ydGVkX2ludGVyZmFjZXMpKQ0KPiA+ICsJCQlfX3NldF9iaXQoUEhZX0lOVEVS
RkFDRV9NT0RFX1NHTUlJLCBwaHlfZGV2LQ0KPiA+ID5ob3N0X2ludGVyZmFjZXMpOw0KPiA+ICsJ
fQ0KPiA+DQo+ID4gIAlyZXQgPSBwaHlfYXR0YWNoX2RpcmVjdChwbC0+bmV0ZGV2LCBwaHlfZGV2
LCBmbGFncywNCj4gPiAgCQkJCXBsLT5saW5rX2ludGVyZmFjZSk7DQo+ID4NCg==
