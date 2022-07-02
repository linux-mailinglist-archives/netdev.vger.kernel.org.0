Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFF856421A
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 20:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiGBSft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 14:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiGBSfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 14:35:48 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2136.outbound.protection.outlook.com [40.107.114.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE3BDF64;
        Sat,  2 Jul 2022 11:35:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giMMQsloGuGhbODapgLTCm/z4fSkzCKkgb3ouCmmE7qDwiHALV21NP2qDFZsmM/ysRkTou3kq9iyATza5CTj0V/0tAuqrIi7txvp9Zm+CRWTczKnqNiVsHwJlZHYQP5ZI+l+ZlTHcPebny8BfrRHJf9B3zBtOdrei1OtYfkpsD4ouuYV2thRBeGCquEtUfg+CGBtYAM7a11N3knt6RdkzAB4lcHs5MtjQyAZ3/r9aKQm7fl0ZzXlnw0BcRT+Ns8Iu/QgYjhR/oJ+/GSUtYsdyEhhdsouN9wo+KyR+jcDYsv6egm68EcFBJV+bNKMoisPbfFVC/x7NvZFhXohAGi9Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIl/RTnHqJqsFShFfKJFQvvPENlA4FZJcGgSfpqaVyo=;
 b=cYmvafrwtRR5bHtO7ECLTg9iSAFBc7hgfRezS1omfvQl8OK3/iXfP+TswY81ujtpHhNyuUvL+6TztFuQWhDIY0eiw+xwsD0f5hY7j9F36eK1z3ZXzaJw28USNQl38OrMGbAwF9yCDVhyqEpekmTq7e13Wg1bSTxiT7EhefOVSB0Tk6TbcUmYKkEuF/0E/1/UHg5yhAyd+06jPGC4LU0h4RtGzU8X0ffEw811iOOOP/BMqqih6uey8PxBCIT00GvV7dTrTKOv60DAadQ3szQgAuxZmbYFPOFZSVCw/8Yzd9NS6Z3w20XWLy8ME7wSFzSejBOBd85alCmtYUrWvzPAgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIl/RTnHqJqsFShFfKJFQvvPENlA4FZJcGgSfpqaVyo=;
 b=touHhYYxcPfmSf9EJvxWzTVtqYW7Z0DUkzh4MnLStwmddmdgkERD2MRVQhMr3L5ck4xp0P3FOL04yOFLjR+Vc+4Hxv2ahuaXZ+91BWFizVXnERQtY+9OZh3EBh1N4cqhsyzhE8LsXyTXaNaYs/6TnT2hMraUIqKQ2coA2yEiV64=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYAPR01MB3117.jpnprd01.prod.outlook.com (2603:1096:404:90::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Sat, 2 Jul
 2022 18:35:43 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.018; Sat, 2 Jul 2022
 18:35:43 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 4/6] can: sja1000: Use of_device_get_match_data to get
 device data
Thread-Topic: [PATCH 4/6] can: sja1000: Use of_device_get_match_data to get
 device data
Thread-Index: AQHYjhxMn8ffribN60eurRHn6Ps3mK1rQooAgAAmAcA=
Date:   Sat, 2 Jul 2022 18:35:43 +0000
Message-ID: <OS0PR01MB5922396ED77D1D2EF3D19DF486BC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-5-biju.das.jz@bp.renesas.com>
 <20220702161836.zuixkwjbbo5li7o5@pengutronix.de>
In-Reply-To: <20220702161836.zuixkwjbbo5li7o5@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4aa6c2f0-ef76-433c-58e4-08da5c59abee
x-ms-traffictypediagnostic: TYAPR01MB3117:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pZ2G2h1PAwE5vF07w4LKikWiPzxDxP19YZwKc3GH6mmBiumFXo49wmK5fNj6U4++3rxfz7VL9Gtr2yEoTMblSBSXKvMX3EMWBdlgRSZwlMwkJuLpbqsO8UJaLP9LNitmhiQNmlC9CQNXM9fvAwcY7C1CkaH4m7MwcSMVKEROtvB7pVCeWDc0rEbCFVm00A1REbU+XTF88EEByof1Im1ayHWEteYmCCOdBz8HbYxyJRwevkNPuILCw9cLfusaEa2w8VfsRbLRKF1ElJ0KplNC9V7WX7KtmCuYr4aM3G6qTsQacQ1cdkOFo5/mzAcLIMP3f31hGppUsLKffQztHUcQDbvi83CV8eVQsyYthZD2l0O1ERuzb/3ZhfsHpyaNXqcrbWUPGrkXkLkeapKSkgYXhSBelBrL6NEYMAELnNCpegIYf2aOOg5XMrPdceqD/+hyoUFjPKbZraM0daPFZEYBTnEFNyLBmnOOBeef3L2k8JpM+shFPjsPHG5g1E/vxm8Ot66K+n+E9QspDFSXfxfHnLUOKqfO/YUsmtJaCSAI02TTpTivsBO7c3OvpcnlsbaOzIdyt/wEB5IbKQ6aYBL5HLANtzjZpMyj3SlaJ74EgUK4ZMNmFj90+4O/7MshiN/l4KT836GuGoxQ9U6enNxZWlXAkf8HHR68654FyEoFmRTpXLQPrng2CGo0a9Ru3QJm4qJ6ZzF4s825uPd969Uvg1OFnMxWOnQqzqG6LQ/izwiwkRw/zauHfcvGsWkuXiTeAE9aZEHuHVS0JocSlqqLow2oFq8HRCA4wqPXFlIq+ygfRvWNcNHNuwkQ02p/3ztl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(53546011)(71200400001)(38070700005)(86362001)(6506007)(41300700001)(7696005)(2906002)(54906003)(316002)(186003)(52536014)(6916009)(66476007)(66446008)(26005)(83380400001)(9686003)(76116006)(7416002)(64756008)(8676002)(66556008)(66946007)(55016003)(4326008)(478600001)(8936002)(5660300002)(33656002)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qm5FSGY0REU3anNLM1hVZDVBMm5RRlNLazVLWjBIV3RVQ052Q0JXTjVyZVBJ?=
 =?utf-8?B?ZXFhdHcwVFFtM1YvTFJPQmdGM3lZMjdFK1IvaTBMZ1QwT01ncVBaeG1wMmJP?=
 =?utf-8?B?NEF2TC95UW5nc2Z6UGRxQndaSmtpVkdoSFVoQkI4ZGxWbTFZL3lzNnM1QnJU?=
 =?utf-8?B?Tlhsak9xRDNDcHlCVkNJMG82MjViSEVxQnp5TTV6ODJMK1JaRjBxUTcwMmpq?=
 =?utf-8?B?Q1NkNWpRdmJFZ0hkSDlrTTNTTEZZRmNTN1ZZOXg2TEJtbk8xRWtTMURTL0tQ?=
 =?utf-8?B?WGJ2YmQvdnVrK2RTUmowdHRybmNsclRuak1WT3duYzk2SzByRGRqbjFvTUgw?=
 =?utf-8?B?OC9MWkxUTmtTUlpRcEs0YlJHYUY0RTZ1ZWJBUTJSUGRVcWw3OU5PQ0tuclZu?=
 =?utf-8?B?MFlGTkFNRWNjS1g2dEZKcWw5MG9KcXNpODByMDdKSmJGRGVjbVEwclEvVDdp?=
 =?utf-8?B?WHRwMzFpTnpHZWZ2UkpBei9OeFlrQjl4VU1HK1U2M3J1M3Y3YklPYzlOaXpv?=
 =?utf-8?B?SGVvaHFyZ2NBZldhOGVXSFZzYnF0djFyOHllYW1idHNDQW45Z1lJM0ZHbHRr?=
 =?utf-8?B?UTQyd3pub1BsS3NDOVhkNDRsNE1ZZ1gwTVphV2RlOFp2VHAyVGVMV0YxNitr?=
 =?utf-8?B?VVRXSG1RcDhxU1lsS2Fwb0RyNWJ0YzhCbjhRbVFvcFQ2Z2kzU21rbFQzTWhF?=
 =?utf-8?B?RkxlM0dvUkZyOXRqYWgwa2lRZ0RpbnptZWNVemxNMUN2VTEwbW1FUWxxb3FD?=
 =?utf-8?B?SHJhRDNVOEsyV3dHRTNyNHVZWFVMMmQ2aFZ0cFh6R0lSVWRLc0IwWjZvZ3pR?=
 =?utf-8?B?RitNbDVpcDg1dUFBRDZEbVFtQkxLQy95RUhLQ3doRXdiTmZLVGxJYTl6S0dQ?=
 =?utf-8?B?NG1QOXUycGJFRGpqdDc5TlR3UDU3TzZHNEJ0aDZraTdzWUZEdEZ0Q1E5eTdP?=
 =?utf-8?B?UUpmcGxSMDRaK3VURFNLd3dFRUVOanpqN3JhRDJOTWdTMnViV0RUL2NqYU5D?=
 =?utf-8?B?cVhKdkxyZWkrNmFVSkJHd2trTHBEWjN2OWV5UnA2L2ZHcmxwYmRsMjJVdmNr?=
 =?utf-8?B?ZHI1U0dtaEh2N0Y1S044dmpvUXZ3a1RvclNTcjVranQ4WlFTdFdzUjNkdWdF?=
 =?utf-8?B?R1ZzcUdrVVpTNUZiUXlLOEhIOWNwMWRyYVRZVkUzY2NGODBXMWZpV1cvYmo3?=
 =?utf-8?B?MzI5V3hIVFhXUzlVNTBYSXBDSldqdHMwN1BJWjJzMGV5RVFSM3liUzFYS1NS?=
 =?utf-8?B?N1EreEgwcWp0cmNOWGJvZWEzYTFQNG02a1loTndjcFlyeTdvdEJKZWdxNEMz?=
 =?utf-8?B?amdYUnJna2RnMmNpWnp5WDRCRmdzZTdzL1JYOUROVnVhTHhyS0w0VmlWQ2JP?=
 =?utf-8?B?enlKUHRSZW5acFJDeDdnLzdqY1JsT3VBZVZYTEVNTDRpeEkyWmU4Yk5sWWJJ?=
 =?utf-8?B?bC9aN1greU9KL1pPWU5PRlkzbG1IbDg2NWdCelJvSEE2a0NodlpERWhrTEl6?=
 =?utf-8?B?QXd0VE1DUFU1S1hCdU9tOFpIWThGYXQ2K29JejI1cTlya1NxT1Q0WmFxVlh0?=
 =?utf-8?B?R3hiNFdCajdpZzZ3a1VOQkhpZjVUS05LMDY3U3dEOHk4eStzWXlObGNPek9O?=
 =?utf-8?B?UDFENDN1RkJ0QjhqbGxUY0g4cjRxMHk1ZlRmQkRXUmNwYzBmUEQwY1FPdzJ3?=
 =?utf-8?B?TnZDWFpnbWhpcndnamN5QnNvcmhyR1JQcTFzL20wVGFPUVdodEFESXBQeklD?=
 =?utf-8?B?Rk5VT0FBSHlxVitISENBL1Zmd3pmRElpdGtieWJkQmJYbnNnNUZYT0V0ZHIy?=
 =?utf-8?B?NTBFWFNPMUc1SEs3TmN4TGxSYUZHVVBGdFc0N2hubDJZa29yc0w1dkx1YlZO?=
 =?utf-8?B?SHdlN2owYldJUnBrMFJheDZRdUhrR2FVb2xkVnQwQ1FSRlM3ZksraW5RdVpY?=
 =?utf-8?B?Z08wanZPN2x0ZEp2VzVhWDg4Z0lWSUkycFcwczRzYlJhZ0czYmNVaEIzYzVC?=
 =?utf-8?B?UWlrY2tPaS9jUDdodVpBVTQvM016M2hLc1JjVk9yUk0zc09uY3NCbE14bnJK?=
 =?utf-8?B?a2l3ZkVkU2txek94NFNNaHhDL2diWVQ2c1N2aE5kaGNWKzlvMkl1c1BVWm1i?=
 =?utf-8?Q?V5WKzxHS2FKt9GkADauWyIPa7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa6c2f0-ef76-433c-58e4-08da5c59abee
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 18:35:43.2090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eeifZfPfWDCUwcwjwTLrsTLS5D7FcoDlSuqFtANfEFsgTahsP687RqMBf+5buIBSzLslohmuFgfHCD8vc7a9wOTU+oCPV1VMf5eNv9CoQHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3117
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIDQvNl0gY2FuOiBzamExMDAwOiBVc2Ugb2ZfZGV2aWNlX2dldF9tYXRjaF9kYXRhIHRv
DQo+IGdldCBkZXZpY2UgZGF0YQ0KPiANCj4gT24gMDIuMDcuMjAyMiAxNTowMToyOCwgQmlqdSBE
YXMgd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCByZXBsYWNlcyBvZl9tYXRjaF9kZXZpY2UtPm9mX2Rl
dmljZV9nZXRfbWF0Y2hfZGF0YQ0KPiA+IHRvIGdldCBwb2ludGVyIHRvIGRldmljZSBkYXRhLg0K
PiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMu
Y29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9jYW4vc2phMTAwMC9zamExMDAwX3BsYXRm
b3JtLmMgfCA3ICsrLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
NSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4vc2ph
MTAwMC9zamExMDAwX3BsYXRmb3JtLmMNCj4gYi9kcml2ZXJzL25ldC9jYW4vc2phMTAwMC9zamEx
MDAwX3BsYXRmb3JtLmMNCj4gPiBpbmRleCBmOWVjN2JkOGRmYWMuLjI0ZWEwZjc2ZTEzMCAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vc2phMTAwMC9zamExMDAwX3BsYXRmb3JtLmMN
Cj4gPiArKysgYi9kcml2ZXJzL25ldC9jYW4vc2phMTAwMC9zamExMDAwX3BsYXRmb3JtLmMNCj4g
PiBAQCAtMjEwLDcgKzIxMCw2IEBAIHN0YXRpYyBpbnQgc3BfcHJvYmUoc3RydWN0IHBsYXRmb3Jt
X2RldmljZSAqcGRldikNCj4gPiAgCXN0cnVjdCByZXNvdXJjZSAqcmVzX21lbSwgKnJlc19pcnEg
PSBOVUxMOw0KPiA+ICAJc3RydWN0IHNqYTEwMDBfcGxhdGZvcm1fZGF0YSAqcGRhdGE7DQo+ID4g
IAlzdHJ1Y3QgZGV2aWNlX25vZGUgKm9mID0gcGRldi0+ZGV2Lm9mX25vZGU7DQo+ID4gLQljb25z
dCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkICpvZl9pZDsNCj4gPiAgCWNvbnN0IHN0cnVjdCBzamExMDAw
X29mX2RhdGEgKm9mX2RhdGEgPSBOVUxMOw0KPiA+ICAJc2l6ZV90IHByaXZfc3ogPSAwOw0KPiA+
DQo+ID4gQEAgLTI0MywxMSArMjQyLDkgQEAgc3RhdGljIGludCBzcF9wcm9iZShzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlICpwZGV2KQ0KPiA+ICAJCQlyZXR1cm4gLUVOT0RFVjsNCj4gPiAgCX0NCj4g
Pg0KPiA+IC0Jb2ZfaWQgPSBvZl9tYXRjaF9kZXZpY2Uoc3Bfb2ZfdGFibGUsICZwZGV2LT5kZXYp
Ow0KPiA+IC0JaWYgKG9mX2lkICYmIG9mX2lkLT5kYXRhKSB7DQo+ID4gLQkJb2ZfZGF0YSA9IG9m
X2lkLT5kYXRhOw0KPiA+ICsJb2ZfZGF0YSA9IG9mX2RldmljZV9nZXRfbWF0Y2hfZGF0YSgmcGRl
di0+ZGV2KTsNCj4gDQo+IENhbiB5b3UgdXNlIGRldmljZV9nZXRfbWF0Y2hfZGF0YSgpIGluc3Rl
YWQ/DQoNCkFncmVlZCwgV2lsbCB1c2UgZGV2aWNlX2dldF9tYXRjaF9kYXRhKCkNCg0KQ2hlZXJz
LA0KQmlqdQ0K
