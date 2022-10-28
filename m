Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ED5610FA9
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiJ1L1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJ1L1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:27:48 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2090.outbound.protection.outlook.com [40.107.114.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694991D0D4A;
        Fri, 28 Oct 2022 04:27:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0rAas5wsDz4rW0ItHhUrVeLeIISpJQ2pUMD6UbYerFb49x2JP1vlBYYtDDGTzS2O3+duRTXyoxMAJF6qsHhHBakQzU7RK7z/xPWvHpXrqcMHKALcyokkswgY/isjFLROzZ/5SNgVL59LGK02GmgUkbV4sM0pa3wr+b8105yI5bdo5IZrMW4oCM/dKS9VwN0hdSrgOw9Q3cc4UAvjhNlSKuQKCV3WsblL833l/i2GlSSX3kny3SjQpuWzql0ZFQGdMphMA9Zv+1NJ3qjUZmDDzppSBoyMxzVZxLQkDmsdrf3OprgDuAKZGiLTPKfnhBSgwsiN//tHtr3q2NcaWQ73w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQl99j/8av2GwiHUl/i7PXZEjBE2S++nfwbfe537kXU=;
 b=Voy4HNRtPpXIaCNpkT12B1zL9nldOtGuiDjcWhwuse0P6EJnRCjttWiXSwLfoXq8+hKWJHdSr2g99gsSq6Rxw5tmBIMJf6w6n3MN95yh733gIJRLdFJK+t/YXMle68x334mJiNBOpWRLIXCtgZHXZfbJPV/CW8eyMyxEZeZ8iQgl1B2SQk6weSt71u7zxU2jSG5L3Y8nMAfa7nK35+7YZRgzsjXq5o+asXzPASkXS0kjCWyb+p17OfIpXyuhVTt/hlF7PRw/7aQB2l9mmIVO/UMccQGwAKTO+w45Y+ThMZdOqphqKTV1pVYr+9HYKvRpo0W/RD5RL0ZRULYFKAqOFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQl99j/8av2GwiHUl/i7PXZEjBE2S++nfwbfe537kXU=;
 b=fbA8KxDeJQIejnSB5NP7JBjuRYPOpWN2gReiR/imgk8cvlvW0nL6dF+iRPOWcao/tCDd4a03n0iFchvbNDTWt+a4ou7xVtXWwocPAF4I/ko/mDrjrLz/UVpO/2J78jD/5syHkwjKIjHrGi+KDTSGLTzEOVI+x3zFk6jTwRzYMGg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB7989.jpnprd01.prod.outlook.com (2603:1096:400:186::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 11:27:45 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2%3]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 11:27:45 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH] can: rcar_canfd: Add missing ECC error checks for
 channels 2-7
Thread-Topic: [PATCH] can: rcar_canfd: Add missing ECC error checks for
 channels 2-7
Thread-Index: AQHY6rWFaf/z+6SkH0edXwWQrfdnaa4jmuoAgAAKYgCAAAO8gA==
Date:   Fri, 28 Oct 2022 11:27:45 +0000
Message-ID: <OS0PR01MB5922E82C35AB042AC155014C86329@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <4edb2ea46cc64d0532a08a924179827481e14b4f.1666951503.git.geert+renesas@glider.be>
 <20221028102932.lfwrm3ahhhgtndsu@pengutronix.de>
 <CAMuHMdVnBiXuSgDtZwkj_uf9U+M5-8oaG_Shr_zAyVb2hJCngg@mail.gmail.com>
In-Reply-To: <CAMuHMdVnBiXuSgDtZwkj_uf9U+M5-8oaG_Shr_zAyVb2hJCngg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYCPR01MB7989:EE_
x-ms-office365-filtering-correlation-id: ed2c1595-97e3-45b5-607f-08dab8d76f79
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A9EMKb/n6xjrqqBR1CUE1CC/B76KuB+yVffZdTv7C7BIYNhd6vWRG9cZRP7gZVCyQOWvyMXi9T4B8QA6WqYMcQLlGxJmY/CMFAdWc2ucm7Ds62Sy0f+N9ECTx/g8eJtCmLPcL8E/GKlZqJk3746qCegoeTZtPE7qCvF/hDMdpibH2AdruN8iOlUM70QdMUD1jX4VtOBREawME5v9Z0RdCgTL1e84NtMWmUpSDKzqfBxyjrO3bHY8StLQSR47hLzexClDEXkkV/KHew/DjSe9dyIXTGigS4yoK8aCga/Y5FQRhCkSfD+LIs6X5JJ2y5tuKfNMBmBYjmniQaFENio/eTa/a26SdWyzVQ626lwi4ne8E4WZA1MlTNLz6WKgfVBs2OlpCz4HdwT+wF1tbm6HT96n9GPWQ4JK/SrXqCXtH3PJVWYAED0h0Pzx8abB6oaO7A1d/gMRs1LLtczFCrgmJYGG+GCtySyGyVxeqYW1Qlj3x2wD3fDfc1JNmZ3RVKubAe+mmy8PRyxXu+kS+MCbMUxe6mCmOykPd2cWgyr+RPuyjWEiXfKoHjkeL2SFZYFhj0Sf8nPiiRGRPk0mz79jqOm17nzeL5PSVC/F4//GFzqEETJOC7Mw3tUXs36+K7mRDhdFqu9xubMKIJKzsJx5Qsvfr/G5TwKuO6+aNNfjoLbTiQYzSItRXbmbCkd2vjLSXtFsW50Cviw0RsbLH3U/i+BZ5j63t76dFDCfKmxJ1pvgVhBOZQcgVbqx+0pJu+8VVETsL3GT4PAZrTbRoXMC9uVY6puEZJT15e6gz2C40rA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199015)(41300700001)(52536014)(5660300002)(8936002)(86362001)(26005)(38100700002)(38070700005)(122000001)(186003)(33656002)(9686003)(2906002)(83380400001)(966005)(66446008)(71200400001)(66556008)(54906003)(478600001)(66476007)(316002)(110136005)(4326008)(8676002)(66946007)(76116006)(64756008)(6506007)(7696005)(53546011)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEtwVFNyYVFhZ1Y4c05pWTlrMU1EdlBXWCtRTkpEQmpYS2FDbThkTUJveFN6?=
 =?utf-8?B?akdQK0MrVjlYdFhHdXR1V3Q1Rk5pSUR5MXJiSHlLVlBrc0svUGJQVS92UkhR?=
 =?utf-8?B?d0g3bEV1ZkZUdU1iYUJrUG5zdzJpblBPUjRjbGhXek5KL3VPMUtaOU1MQmI4?=
 =?utf-8?B?RWZ0NVdrUnRFaUpGVm5vUmp0MUJqQVhDbWx6ZEMwR2pOK0I0K3VnNTR0UlUw?=
 =?utf-8?B?cXdVR0U1THpOSHFlZ0tpcUtYZkE5ZTFBa3pVeTQzMk5sWnN0U0JyZG43NFI0?=
 =?utf-8?B?RGIxbmdtSStVMFBCR1FlVlNGWm5LM0pwVjl2bGNVazVZbzJGbUtlTEtLaXV1?=
 =?utf-8?B?QVNLeW1RWUxYWDJGR2pSN3BEaWxSR0szNE0yMjlxMnkrdytUL1AzeFBHVzBV?=
 =?utf-8?B?bmtwWmRVWW9ieGNqazloQUhHRmd6R3JtcnBZN2FJa3RBejhqTzlmVDQ1L1dy?=
 =?utf-8?B?ckFlTUNYMjRhNy9lTmFDOGpqRWlrMkxDYWJDWDFiaUkrcUZSaUZzZ1A0TjBV?=
 =?utf-8?B?OWk2a0lYakpWSmF3ZkZuZnp0aXhtUlJXRThocDFJMUxRR21sNlllZFhGcmhL?=
 =?utf-8?B?VFlqemwxNUI2aGNXUjlnOHI5QXYybnlEUS9hOW1HT1krSnRUcUo1WWFyS0Fi?=
 =?utf-8?B?N0w2TjFDbVBlbXN0dVRlZVBoeFJFNUh6YXltRVhaQjgzcVJPeHpUR2RZSjA2?=
 =?utf-8?B?Qk5oSFpBU2RxYUNLTmRPWkpRa2ttQndrRFZwd1dQNmVSNW1ETGJ6M2ZVWVF1?=
 =?utf-8?B?ajlxY2lLb0d2b2RPMFdveGRiWDErQ1B0RVBWMW01OEVBWDZNS0wzT2lEMHQw?=
 =?utf-8?B?aUtHdGtRK21xU1RjWmZlVCs1UnM3K2ptMGQ0aHYzVGk1b0tzMzNGa0o3VVRI?=
 =?utf-8?B?d1A2MHJzMWJ3cWhRWFNiVUhaL2oxME1LUlRGckxNcmpwQWVBWVJEaFZwYjJr?=
 =?utf-8?B?Tm5xd0FxeUJhM2RkMG5ucG5Jc2x1VmFaMnU4T2U5WjA1andpUVQ1NmxmdVF2?=
 =?utf-8?B?SlJrd2Y0dGVubkoxb2dXWVBwK0w4ekkvRURKcU9JNFBCQ0R3UUlIMFFTZDlC?=
 =?utf-8?B?Y0x5TktrLzVMQ0NoMHNkNTExU284cFdDM25CUW1xczBSUUVzbUY1cXZzN0h2?=
 =?utf-8?B?aVBjNktIbUp0SWxrMW42ZHAva2gzV1l3UWpCNTBlRGd3UVB2RmZaOWVMdW45?=
 =?utf-8?B?UEZPOUw1N21jVyt1K0U0TW9oL1lUYmpiMXNGazNTVTI2MGwvdWNZTUtGTTFZ?=
 =?utf-8?B?VjVtR3RhUXgzMlRJdHk5Wml5bFlGWWpWSDduZEdEVi9iTXppTE5oWGJ0ZmNu?=
 =?utf-8?B?bmJIVGV0SUdGR2pXVXhIMkpWSjZoM29PSDBJOWxjK1ZjM1RTdHNSNWN0Y3p1?=
 =?utf-8?B?dHBSam5UK1JkbDZDcFN2bERjS1habzZkRGkvTHlXQi81b1VwUlBHWjFRc0dn?=
 =?utf-8?B?SjNUUjlkZTZxNWkxTnFpM0liSVFhRWhGdFQzOVBlZHN1MjhxdFpTOHN2NmlD?=
 =?utf-8?B?MmNvNTJhUEJmVkdmVVIwQjJHTjA3VFpIMFlrYzh4Ylowcmd6bGtyWS82RXN5?=
 =?utf-8?B?b3JqOVlvYW9sMC9wSnpNYXJhOWtaR2gzb1BuVFFXbm1rQ3lDU01YTEl4dkV2?=
 =?utf-8?B?dk1iVXJKb1FVWm5aQXZmbUlRZEhaSVpTWTlQRHMvTWJIR0g2MGx3RklNS1pD?=
 =?utf-8?B?UTVCbjNORjZyTDV4eUNMU2JRK3B5U0FhNW5TQk5QSEVyYUxSYkRqQVk2SkFr?=
 =?utf-8?B?MGh5RGQ3QkZJVks2a2toMDBJVC8zUDc4eEN6cGFRWWx2MGg5ditqS0plWWN6?=
 =?utf-8?B?U2RRMUZKZW9IeVM4VWxaL0RFM3JnTGdISEJSRW1UcmF5eVJmR3NsRVlNRzds?=
 =?utf-8?B?Mm9BNTZUOERyMTJvcXIxeVIrOWdtbXBtWUYwM0ZDOHZzZFA5clFiSy9ZNVRH?=
 =?utf-8?B?d0VHOUx3N01DUlo1d2l4ZG5HMmVUQmxrdlZRaEl5SlA0b3gva3hKVWZ2WDdD?=
 =?utf-8?B?djhHdHUxeFN3RTc2eERPQzdOZXBueEorbVd5OU8yUWFxNG05SGVuRVd1YzBP?=
 =?utf-8?B?SmxESzhlRVZSdGZpVE94ZFJOdGRVUm83eUk3ekZXNFRXMEU3UVZ3R2ZHTlN2?=
 =?utf-8?B?R3JJQnB3UFF0RHFKV2Yyeitxa2l1dEQ5V2lzQnQ2NjhGeDZUdXNFZExpN2Z5?=
 =?utf-8?B?eFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed2c1595-97e3-45b5-607f-08dab8d76f79
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 11:27:45.3895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yKdNBNXQBtro3chsRlkzuEGYlNGAR7uBx++fAU6bJ0YEn8sO+5cyAIUM2Mq4nS2xyOlEjCkqWRR6B7afQ8QU4edeFZv3pJPT/02XqKaCecI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB7989
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gY2FuOiByY2FyX2NhbmZkOiBBZGQg
bWlzc2luZyBFQ0MgZXJyb3IgY2hlY2tzIGZvcg0KPiBjaGFubmVscyAyLTcNCj4gDQo+IEhpIE1h
cmMsDQo+IA0KPiBPbiBGcmksIE9jdCAyOCwgMjAyMiBhdCAxMjoyOSBQTSBNYXJjIEtsZWluZS1C
dWRkZQ0KPiA8bWtsQHBlbmd1dHJvbml4LmRlPiB3cm90ZToNCj4gPiBPbiAyOC4xMC4yMDIyIDEy
OjA2OjQ1LCBHZWVydCBVeXR0ZXJob2V2ZW4gd3JvdGU6DQo+ID4gPiBXaGVuIGludHJvZHVjaW5n
IHN1cHBvcnQgZm9yIFItQ2FyIFYzVSwgd2hpY2ggaGFzIDggaW5zdGVhZCBvZiAyDQo+ID4gPiBj
aGFubmVscywgdGhlIEVDQyBlcnJvciBiaXRtYXNrIHdhcyBleHRlbmRlZCB0byB0YWtlIGludG8g
YWNjb3VudA0KPiA+ID4gdGhlIGV4dHJhIGNoYW5uZWxzLCBidXQgcmNhcl9jYW5mZF9nbG9iYWxf
ZXJyb3IoKSB3YXMgbm90IHVwZGF0ZWQNCj4gdG8NCj4gPiA+IGFjdCB1cG9uIHRoZSBleHRyYSBi
aXRzLg0KPiA+ID4NCj4gPiA+IFJlcGxhY2UgdGhlIFJDQU5GRF9HRVJGTF9FRUZbMDFdIG1hY3Jv
cyBieSBhIG5ldyBtYWNybyB0aGF0IHRha2VzDQo+ID4gPiB0aGUgY2hhbm5lbCBudW1iZXIsIGZp
eGluZyBSLUNhciBWM1Ugd2hpbGUgc2ltcGxpZnlpbmcgdGhlIGNvZGUuDQo+ID4gPg0KPiA+ID4g
Rml4ZXM6IDQ1NzIxYzQwNmRjZjUwZDQgKCJjYW46IHJjYXJfY2FuZmQ6IEFkZCBzdXBwb3J0IGZv
cg0KPiByOGE3NzlhMA0KPiA+ID4gU29DIikNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEdlZXJ0IFV5
dHRlcmhvZXZlbiA8Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+DQo+ID4NCj4gPiBJcyB0aGlzIHN0
YWJsZSBtYXRlcmlhbD8NCj4gDQo+IFVwc3RyZWFtIERUU1sxXSBoYXMgb25seSB0aGUgZmlyc3Qg
dHdvIGNoYW5uZWxzIGVuYWJsZWQsIHNvIGl0J3Mgbm90DQo+IGNyaXRpY2FsLiBCdXQgaXQgbmV2
ZXIgaHVydHMgdG8gZW5kIHVwIGluIHN0YWJsZSwgaGVscGluZyBlLmcuIENpUC4NCg0KWWVzLCBU
aGF0IHdpbGwgYXZvaWQgYmFja3BvcnRpbmcgZWZmb3J0IGlmIGl0IGdvZXMgdmlhIHN0YWJsZS4N
Cg0KRllJLCAgV2UgaGF2ZSBhIHBsYW4gdG8gYmFja3BvcnQgdGhlIHdob2xlIENBTiBGRCBmaXhl
cy9lbmhhbmNlbWVudCBzZXJpZXMgdG8NCjUuMTAgY2lwIFsyXSBvbmNlIGl0IGhpdHMgTGludXgg
bWFpbmxpbmUtcmMuDQoNClsyXSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9jaXAvbGludXgtY2lwLmdpdC9sb2cvP2g9bGludXgtNS4xMC55LWNpcA0KDQpD
aGVlcnMsDQpCaWp1DQoNCg==
