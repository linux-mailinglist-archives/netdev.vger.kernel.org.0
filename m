Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF4760B5F5
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiJXSom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiJXSoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:44:07 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on20727.outbound.protection.outlook.com [IPv6:2a01:111:f403:7010::727])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1912339A9;
        Mon, 24 Oct 2022 10:26:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRF6vhwYNfM2uyK7UYbqN44B229+s+lvn4crTbqAde9lXkjwx2GUSME3z7fEEH2dsNou8NLm8xpp7qK2h30tjixU8KHzlc2BE49mhs5Sqxfi78Jj85NzbODI/86YcENSg2wtnJooq8tIQuPGa0WThYwghVMmEsB2Y9X3G7NOUIWAxn/CujgdjaRFlzEiTlyn0VFwhbrtL+PKJxgGvLfuBHtOVCuO6Bu+hjuCINLPM7/lhikl9RnO3tVPxpWd/V+2g5wZqdFYhmJeBwzm+8csJ5eT7AqQIt5eUgMJGLdAnebHYaqpyPbbmSiGXh6gihbqdGiLbB4Ent4RMomfNy+mMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jfC8N+nhSZ4fY7Xuwh5JTkQ46ki3EAvuOSVsfCczUc=;
 b=VaVRaBXTB+/JbVyQtb4XpsfFJ2DZwEbDLeV5XGGjKePET/LqSz8h+jZb6d/1L8IyKWXIcPCdiMvlFPUw4fu9Dk0CL6//EjbEFx3tftXY6G0tFCKZcMdy7MNTmA+nb+q4e3yR42cYl6lC8gp6dLRaCg8sp7ABY4rAJ2WKvVN+MtEXAPla21eGMJOrL2qAWH+xsbKlVsLY9ta76hJ9u1jywX62sSTyCL9Gq/kOsYExoTxHdJn3wTiVkXhlLr7hhSK/yRh8BYTwadZUpEwrFotpuNdz4yVY5NpVji4kev0Z6fPW0P0cJhw5sUIGYluXLzPtz9GQgmBpjEQVPSJ/3F5/FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jfC8N+nhSZ4fY7Xuwh5JTkQ46ki3EAvuOSVsfCczUc=;
 b=UB2REBl3v6r1+MKk+TtVuYk+mI36/jbPenZpwUGEqcaDLoHn912xSmpinTOfYXlBjWDowWy6UWNxSdCCyqz7OFw8sLZXgENuSnrJkez7/QS9j9foDO+FS4RKWTCJsYU7FZ7sLJ0s3p3hhmCCQwsgpXW2Lg7Ucp4pOj+4sRQg7Y4=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5670.jpnprd01.prod.outlook.com (2603:1096:604:c7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 24 Oct
 2022 17:17:15 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Mon, 24 Oct 2022
 17:17:14 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 2/6] can: rcar_canfd: Add max_channels to struct
 rcar_canfd_hw_info
Thread-Topic: [PATCH 2/6] can: rcar_canfd: Add max_channels to struct
 rcar_canfd_hw_info
Thread-Index: AQHY5gXXPE+jciOF2kmDRUgjP8N/lK4doVMAgAArIbA=
Date:   Mon, 24 Oct 2022 17:17:14 +0000
Message-ID: <OS0PR01MB5922EB78C4AB41CEBF082C29862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com>
 <20221022104357.1276740-3-biju.das.jz@bp.renesas.com>
 <CAMuHMdWczrC=WsDF6SchD=GwtG_OA+gAC4frF5i+qX5mpXEUfQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWczrC=WsDF6SchD=GwtG_OA+gAC4frF5i+qX5mpXEUfQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB5670:EE_
x-ms-office365-filtering-correlation-id: 0d417a22-3162-4707-9fce-08dab5e398a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pGGeXMFMBRIOUZRfLlmelmkUlcUV8WjJ9Hq42aRcwPmMWOybuhdtjsuaGdpzC0gictYmSXP/f+yImhoZmu8fBnOB3IiAr+5S5RBcACNV2rCsJPgV150dwinBNdYxzNRI5FcipS2y9pHr045leES9rb+ZroaJxfIzk4wSwLHcqEhPV3Rjx99C5pXRi+u22zLRzDVeQBzwWom5CoIi8vyRs5otX4eup42WWvZGK6SrVMpJ6SJqTs1KDsklrnGLgAUZbZiyZJ+DqFriy5pc2CDu590+ZexbrtEek9dE62Ii3/Uae/cAFBSZF9WV6O4c4rEOkZMicj1EBYh1oUZsdFvX7hZqelugT/UoH+qDDT3+0bdLot+Ci3GGfkqt57bNWyBMiNBNvyYyNlQijoieYZjt0d4GPpZxv/XBGGFkJoZDjbWOWfTfh4X/jdE/kyS8T1VXMFyXbZJyyxP3PRZro0gIPKD840LxkxIAhndgtFA84Wg0FFGTryFp9qSX2iriW5Y1CGxD0s8hj0ta+qDkRHsaQvoObnp4plMBdNkHW1S03feGasWdAu4s6bqW3IjsqWW/qhOC4JsIJIkz7NWp+0f4V8vbWAiwuaAF/LGO0tZiHLdB6DJdxX5IizW2uDHPH9k9w7UyE69brMbexpLZkolNcIp5DJJeMF6IBfeeCDH3gBJOEcCxPIajRXIg5B4NzLe258mRHKeCXcU/LNE5v/QHzQuQbK0MBmvNd/yXuWr447HqW8R8s8Ok0pM/Z1Yi1tN4qCASwk9WZBM+m/nqWYmdxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(7416002)(86362001)(71200400001)(38070700005)(122000001)(4744005)(54906003)(26005)(186003)(5660300002)(38100700002)(6916009)(2906002)(52536014)(41300700001)(55016003)(8936002)(8676002)(64756008)(7696005)(53546011)(316002)(76116006)(66476007)(9686003)(478600001)(66946007)(66446008)(4326008)(66556008)(6506007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXR1WVZFd0FSZTBPaGZUUXhGU1VDSnQvVWNtODdUSFN4WFh4bXRhY05aQklL?=
 =?utf-8?B?U1BIOHhTYnJUUWZldFZZS1F4L1M3MDRYWVc2cXRmaWxCblhoelJBdmxsT3h6?=
 =?utf-8?B?SzZTM1NDYVcxNndRTUF6L0NPUXZuSkVDbFl6SEQ5dkRTSUpMWHhxUDlvb3Zw?=
 =?utf-8?B?WU84Tk5BaVNuUEpsS3JnZmtWQm03RUxFKzlKTTJZVkFWQmc0ZnZueWVzY2p6?=
 =?utf-8?B?Tnh3N3VqejBKWWR3a2J2SlZvU2o0QU53NWpTMnVxR01Od0E4eVpEa2lSYXBG?=
 =?utf-8?B?VG9ZRkRqOExBUTBZQmxsTS9LSHpJY3FlQTliTy9HSU5jcit4dExTclJtOWZz?=
 =?utf-8?B?ajVySHFydi8reElVckNnNEJCOFBaWWs4em5mN2xiU0EyUTk2a3dMU2JJdTRm?=
 =?utf-8?B?Sm5iL1NFaDhNa1hLWkdHeVEvNGlMaXZ0YmlSVG9vVXMyRlFJWEN0bThNM1hp?=
 =?utf-8?B?c0Q5RWJxb3Z4clZQR1hjVEJYdVRKb3lsMzh4OWd3Y0tXRFE0M2tjVDJtMnVq?=
 =?utf-8?B?NzB6RDdCRjJQQ0Fua1czSVdackhoTkVza3AwSms3cjF6bkVKL2JNcWFWd1pY?=
 =?utf-8?B?eTd5SUs4M0R6ZWU5MVBBcExmRldEcTIwaUhGSFY4aTg1TG5CZm10YUd4V1du?=
 =?utf-8?B?VVdhSjZUdlN3ZkNSUkN3Y1JPdUpnRE05bVlUL1NjVDlZbnhHVUhRUFAycW5m?=
 =?utf-8?B?cmxHMXNwazg4bythRHNCZDJiRWRiMDR3Y2NtNXdUc0NmSVR2eW5SNDd5YWJ1?=
 =?utf-8?B?NC81RzVTUU01VFFBQ3A4YkoxclhMeTFGOEFVbFlBdUdBT0g4aTIraFRPZ0kw?=
 =?utf-8?B?cFBxWWY2ZVB5VVZoc1NEaHN4ckRtQ3NoUUVsWVNWY3E5aFlidU53SGM3THF2?=
 =?utf-8?B?MkhXdnZWM3RYWlg0dTYxK01kMlBKK1BpbEcrWTR0dUIyazdsODZmdG9lRlJS?=
 =?utf-8?B?OGVnWFc2NlJhSHN1Y29KOTEvTlZqSTgxaHprTTZPeDVIUWtxVUJDVWgzbEd6?=
 =?utf-8?B?YllTYmhxWlNWTUdodWxoZ2ZVWTY4NUdHalUyRGtKYUZBa0FCa3ZvZE80NHlS?=
 =?utf-8?B?LzdKbmhuUnMyYjkwTnNRbjVmZjR4bi9Vc00zTUIzeU5NMG1QVzR6TUwvcVZu?=
 =?utf-8?B?RXFJTEh6alRpbFFwVEtGbjhBMG4vd25HTFdPVnUvNUpBbWFPd0lPVVphQmhK?=
 =?utf-8?B?aWJBWXpxKzZWQ0lEV3Uwd1VubitScVZlMWMvdEpBbUtHNHB4cTRRV1JSR1Vm?=
 =?utf-8?B?eUdYVlRnejRnM05aaGd6NmhyUUpydlVzRXdXUWxmWkV6Mm1CVzJNK08xbDM3?=
 =?utf-8?B?RXFYVmlSSG9ZdlpjQ0NLbHBRc0MxaW1BZlozQ2FlVUpvdlBoYkwwVDhsU0g1?=
 =?utf-8?B?blFOM1I0LzNlNGlwUUljUlQ4VUsxOXkrTXBkWHZOalI3YWNEVmZNeWNIcGl3?=
 =?utf-8?B?QUp5SHlRV2tTUkdrS0FXWCs5RTBxVnZRYUZkTkV4Z2VPeVM0WUVrWjFwVGJD?=
 =?utf-8?B?U3ZxNThISEt1NE1DRitGTEsrM050QlF2bVU3VWNZelRtRlpkK09LdEQvQ243?=
 =?utf-8?B?QXVRRHhBakc2OWx0THl2bHFjUXBSdHRMc1NGWERqaG11aVc0K3dySjU0bTNr?=
 =?utf-8?B?L01iNWZiV1VqMkhxdDNoUExxWi9DZXlGT0plYytZN2cxNUpJTEVDaEFJWUF2?=
 =?utf-8?B?TmIwT2pCTXU3VGs5akRMZVF4MmZrKzZpelRHaERVdXlUcnA5OVA4NVlmeWdE?=
 =?utf-8?B?eTNIRTlaWVBJUFVHbys5LzBHOUE0eUdZckRKQ2Z1bERlZjZuTkllZTdkaklo?=
 =?utf-8?B?YStDRG4vUGhnSWxjNzBVd1g4eGR3TDdsRDdXRGNqRk9DSGtWMXBGd0ZjbDQ5?=
 =?utf-8?B?TmRyS2RKNFRhYjBWa1pIekViYnhBZjEyRUhrY1FLVHp4MGZ2WGFnQnVBeEZY?=
 =?utf-8?B?bWtmdVMyaGxSbnQ5SzZKOEl3MUxOWmFhY1hobkVaUFBvWUZVU0pKNSt1TDZ4?=
 =?utf-8?B?K2Q3bVZrb1B5TjRSSFNRRWFySWF2WHl5dEE4Y1hiZjBlb2RSQldtMjN1TUt0?=
 =?utf-8?B?UmdGeDNKaEwyVzdYVjdmVktGemRGZXJMSGQrbTUzSGllTVZhbks0RjZhMCtC?=
 =?utf-8?B?QVdpREFybFVsUFNJdy9DTFJENGFzYzF0bDBxR2xzNkJ1MDNrK2xsNHo1U3Fj?=
 =?utf-8?B?RVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d417a22-3162-4707-9fce-08dab5e398a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 17:17:14.9007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h5Tt0E8UTquLLemApOqJbg5d5c+r3gplWUBPtoNxY7aoj0LZ4W6cevATJAbGcAXBE6Y0rhoYUnv3Acqpxx5Z/BTpxpFAo9v4EbNIMX3FCrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5670
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IDxiaWp1LmRhc0BicC5y
ZW5lc2FzLmNvbT47IGxpbnV4LXJlbmVzYXMtc29jQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIDIvNl0gY2FuOiByY2FyX2NhbmZkOiBBZGQgbWF4X2NoYW5uZWxzIHRvIHN0
cnVjdA0KPiByY2FyX2NhbmZkX2h3X2luZm8NCj4gDQo+IE9uIFNhdCwgT2N0IDIyLCAyMDIyIGF0
IDE6MTMgUE0gQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiB3cm90ZToN
Cj4gPiBSLUNhciBWM1Ugc3VwcG9ydHMgYSBtYXhpbXVtIG9mIDggY2hhbm5lbHMgd2hlcmVhcyBy
ZXN0IG9mIHRoZSBTb0NzDQo+ID4gc3VwcG9ydCAyIGNoYW5uZWxzLg0KPiA+DQo+ID4gQWRkIG1h
eF9jaGFubmVscyB2YXJpYWJsZSB0byBzdHJ1Y3QgcmNhcl9jYW5mZF9od19pbmZvIHRvIGhhbmRs
ZQ0KPiB0aGlzDQo+ID4gZGlmZmVyZW5jZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUg
RGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gDQo+IFJldmlld2VkLWJ5OiBHZWVy
dCBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNAZ2xpZGVyLmJlPg0KPiANCj4gPiAtLS0gYS9k
cml2ZXJzL25ldC9jYW4vcmNhci9yY2FyX2NhbmZkLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9j
YW4vcmNhci9yY2FyX2NhbmZkLmMNCj4gPiBAQCAtNTI1LDYgKzUyNSw3IEBAIHN0cnVjdCByY2Fy
X2NhbmZkX2dsb2JhbDsNCj4gPg0KPiA+ICBzdHJ1Y3QgcmNhcl9jYW5mZF9od19pbmZvIHsNCj4g
PiAgICAgICAgIGVudW0gcmNhbmZkX2NoaXBfaWQgY2hpcF9pZDsNCj4gPiArICAgICAgIHUzMiBt
YXhfY2hhbm5lbHM7DQo+IA0KPiBBbHRob3VnaCBJIHdvdWxkbid0IG1pbmQgInVuc2lnbmVkIGlu
dCIgaW5zdGVhZC4uLg0KDQpPSy4gQWdyZWVkIHdpbGwgY2hhbmdlIGl0IHRvIHVuc2lnbmVkIGlu
dC4NCg0KQ2hlZXJzLA0KQmlqdQ0K
