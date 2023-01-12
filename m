Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355C0666B9F
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 08:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbjALHdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 02:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbjALHdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 02:33:01 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2116.outbound.protection.outlook.com [40.107.113.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FAE23D;
        Wed, 11 Jan 2023 23:32:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpK34CgW8tg7FCTz8lYx6VcNZn7mBOjUIfeu47B11RBwC2xCFqyoYWDb8jPqv6IFjZFAQ7fVtA6aYRBSXD8fJbX+qNlRNbqpOznh+2OgsYHcnMJGfWFydboFZcOfsKcVkxTTMoX+kxRqjYZuAFM/C3/P57P+uca3lbgEb4y+GZiI93BZgKw3o5gSBUdO40TVGj9JrydQQwLtQpcyW3rSHVUBMtfpyNgMTpmBTo2ZTDtC4QCM5p8I4fjQGRVqNrn2d4tWnYALUCMycgaNUYZbcqbBZ7Ep6l8Scf6xBtQ6VrPDpT34f8H9bHemQMImmxDWM3THambIfEzFiQvhVX/35w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWoSZWJTvB5WC9DoMZ7b0tDdof513+lSgFydhyFKx5s=;
 b=HhxMU4jsT9a1Skp+mvxeCqqIXfqSPFTdFb9Si5g11y6ceUmVfFAffXTsMAoT8ohLHtkN8bFOPMNFBogNHp5HKUJ5/WyxoGkdiGmU8awNCk05IBVgYVPWU2MZyEU33PdwBFRmcCaCR2k4xo8/uCXIA556hmIBxZGdC25UCovFkrHIxxIM5y5QKnr60OIpguoramrjAi8BWKrUMfU2lYb7/nfRN05VQwH55A5Fn/NHFTIGVJkT8v8CowWHLbDtHLXvkPuucoCq/X1kS5LI1QlcTwkI+LjcsN2APeVf4uhqA9qedRPbhw2aLxKTHm7MeVVbD9muuUQEYESzGWNChP3Dzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWoSZWJTvB5WC9DoMZ7b0tDdof513+lSgFydhyFKx5s=;
 b=imhBkOsgRDv5/1f7nYxMyGSv/mz8+2xmDbf6RtHH3SoCbajgH6I0TnkOHQQuMSmn9xpCzCCAQNgoDzNdBBGIR6h8Ez9W7Qb8CaO9phwpWhW7sZx9m0FDYakQGqnYuRrTUnLbAZ5naKI5mp1nT5LLHShgGtMhk41lGUGLkXNw1GY=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB8518.jpnprd01.prod.outlook.com
 (2603:1096:400:154::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 07:32:57 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%8]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 07:32:57 +0000
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
Subject: RE: [PATCH net-next v2 2/4] net: ethernet: renesas: rswitch: Simplify
 struct phy * handling
Thread-Topic: [PATCH net-next v2 2/4] net: ethernet: renesas: rswitch:
 Simplify struct phy * handling
Thread-Index: AQHZJLC3tuGSHRoBJki5icyy6ZM7XK6XspqAgAKsTgA=
Date:   Thu, 12 Jan 2023 07:32:57 +0000
Message-ID: <TYBPR01MB53414AB270D1CF061379F229D8FD9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230110050206.116110-1-yoshihiro.shimoda.uh@renesas.com>
         <20230110050206.116110-3-yoshihiro.shimoda.uh@renesas.com>
 <8f29ef6f855d965cf86fc776cbfc463c7d20258f.camel@microchip.com>
In-Reply-To: <8f29ef6f855d965cf86fc776cbfc463c7d20258f.camel@microchip.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB8518:EE_
x-ms-office365-filtering-correlation-id: 50868ded-991c-40f1-10ea-08daf46f39cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JbZtWXQy4e8GXYryFTzq2WZbtJ3JD0g0ZkgRvRzdNeEAQi9HjCe/OvBMUCDljZf7bUcUxyXBpxtxumA93bpgA1Fh8cF1JaHOXzyCnL5UJxl12LPi8GoB4cqtnLna80foHx394iS7uJovnj7DQo662tKzK8UG7WXEJ30/1GJtl78S/iANwsmx2wNY0FAn52mqnc8N7kEZwreZ3tblnz+2xgSiSCz60YmWFtVAK+O31T39/kK0QFcrQXeCQ5qaov3V8rYUqKNfN7xQ1I6ZaDOeIrDLzBeBdHodmxFy65lyDUEu8EGaFzgh6MKNqS+3+bv+7+dEvq7tGcMpZPStwR3tVT4nqg+Z7ujHpo/pZRJOB/FGlqZ9LCgbtPbXVKN/+KDiEfOoVydOVKJMt+a6wMF+FU5vKJuCMPQsqAPvV+oaWdzJIVdrhcnUzF9Er3xwHRZc8Qny/Fi+vwbKCyyz+vALbMycn5UMvSDnqyrsrHHpnfPCnPHBd4KgMKk6VN/9eniSnWPhv+ZEzQGqUSx9XNlS7gn6yTHveg1i52y6vXm83MUBaitkyR9OqWXjFhHCNAAq/jnL0JyybuPiRRuJRt3lOmC/QQSm6NBoW72qFwEgbfHEcED5uovJ7GngZnt13dFMIj/7XVi5ozG9T8/ISKVFUee2InWh0fbmSiw/QZa6bl6k5xHzCdMb/vrWJcPFVZONyxi+Y2bttYp9fQ/FwY9qdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(71200400001)(7696005)(2906002)(38100700002)(86362001)(33656002)(83380400001)(9686003)(55016003)(6506007)(186003)(26005)(66476007)(122000001)(5660300002)(7416002)(64756008)(66446008)(8676002)(66946007)(52536014)(4326008)(76116006)(41300700001)(66556008)(316002)(8936002)(110136005)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVJqREUyZlZkdUs5MXZZTmRVWmNRRDUzVERBY0dpeWdVeDE2bkN5ZVNxYTd0?=
 =?utf-8?B?ZTJWNFBIQVhhWHp1NUdsa1dGc2JUQXE0eHFpbFdvQUROdUlkdzRNZ2pQVW82?=
 =?utf-8?B?WGtxQ0loakZxMGJUYTFNMlFlUE0rNTNPSm9KbDJ1amRPejg4RWRuWi9NM1Nx?=
 =?utf-8?B?dkFTanhJTU5NaVZiYmxrZjhRRHNIMFJDdS9LOEFhb2xRZDNKNDdGQjNBKzhF?=
 =?utf-8?B?RExOcjRSSWt1UHJJTkFoUWFNZEhyVHVveUxvcXcwa0tTOWI5NFJhb2luR0VS?=
 =?utf-8?B?MDFFOWRaNmFLQnRPYXZ2SjVSUHZFNE5XRk9EdXI3cWdVdFNjTTRTY2JkNmcz?=
 =?utf-8?B?SVJrSk9MZGJ2Nlc3akhQZmlKYXZYMjRuWEtiNXhtcVZkMmNWcXo1MFJ0bEVU?=
 =?utf-8?B?ZE9xcjEvSXg3bmg5QUNIc3VLcUw1M2NyZVVsK0dyRWZVM1drV2w5KzNzT1N1?=
 =?utf-8?B?UERQdVh1UStVaHJFendTVjFkVmU3MVEvRDVjVFBuS1pTMytTTW4rQjNhL3Nu?=
 =?utf-8?B?RWdTamdoWE15Wm0xT3lBZ2FPanZDNkJlTVRlbU1Rek9QT1NJcHJEdzJOUXRl?=
 =?utf-8?B?eVByemdSM0NzdWxlRGRaZkpyZ05BUEhLQXBJRW9rWE5vVkU3MlBBQTdSQUZ0?=
 =?utf-8?B?TjJJL2pzWk5LeURuQzZsUjg2dWlQcXl3aFdCVVFXejVabzd6Q29uTy91L1dL?=
 =?utf-8?B?bUcxZ2c1TUNvMVNGSnhva0I4OThPeWZXdm1oZEQ1MXh5NHozUXBocW9aWnBw?=
 =?utf-8?B?ZGorOTF0aHJKVjVLNjVZbG1CYXh5MWpMU3ZueWxlemI0N3FuclZGMzhFeWpz?=
 =?utf-8?B?WHRGRW5Hb25yNmlYSWhaaWVGcnBMbXpTaC9YZTlWK0N1LzYyY0YwVnFmT1I0?=
 =?utf-8?B?SkRIWkpqc010bzhSUk5maE9xSU4wRTRNL0lnSGlwbFlpZHZHSjNQbDBNcVQx?=
 =?utf-8?B?YllNUTlMaTFUUXFuQUtLSFd0U1lTcmFNeitEUDFsTHl0RmdSblZkRElNeDJt?=
 =?utf-8?B?OGFHZWlwR1pNUmM3clUxZWtXeE5yYWw5UFc0SExHQlpLL1BFcW9rUFcvZVJV?=
 =?utf-8?B?ME9iSjBmcnM4RkFqWnpLeHpBZjZ1emRodkJUcGw1TWVjTm9ZM3FKOWFaczFm?=
 =?utf-8?B?NkREd1lZR3paaThISFp2SmQwT0tFVjhlM20vU0lydDIzb3NXWlpUTnBSRlpX?=
 =?utf-8?B?YUlKaDlGVnZjQWZ3LzU1UmRtSGo1Ty9BNFZTOWVoRHhkYWVlSWJHdmJhMHhP?=
 =?utf-8?B?NlpwK2xKWGFrZ1lVY1htSVVmVjd1SHhlNVNrZmlzQm1UYkdSKzdBRk1tSmhs?=
 =?utf-8?B?Mzg3KzBRK1VFZy9kYkxWektCVzdTUjZwbWtLeGtCWmdzRmVHbzljdGQ5R1J4?=
 =?utf-8?B?d3NHajhtaHE5Umtobmw2WE5tVFdsYXlNUnBQTno1bCs3MmdsM3NmN3pEcGZL?=
 =?utf-8?B?MmJUMUNPN3ZEVHJlSjdqMDVEMmxkSUErSDRnYkJNMWJDcnBNamE0Z054U3JX?=
 =?utf-8?B?bUc1cUxLWUpYRDZIUVdNcThJWldYREVtUWVQWVZ0K2pFQzZHSzBEeG9EU0tR?=
 =?utf-8?B?bFR0MEZDcGRNZ1dzUVE5U1NJQW43UXJoem8wRFNUYW5OUzFZQXhFMjFoMllR?=
 =?utf-8?B?NnVXZlljVVM2R2dFNVBQRFJkTFVDRzJFQnlMcE9NZXkrRWxFbUxrdjlMb2Vk?=
 =?utf-8?B?dzZqcnRIUEI1RFlidERqbjc0b0FxS1dQTG1URjhVTkFuNkRjZzlwQ2NDMDND?=
 =?utf-8?B?c0ZNR2JXczFqeWtPZjVlWHp0YW5jdlhzN016eFBiN2ZxSmNnOUJ1cWU2TGVw?=
 =?utf-8?B?TmJpLzhVWFZHOU14SFNJaWVJRzBtSnpiVitwZWQxOE1jVmlSVVY4aVdqa1V2?=
 =?utf-8?B?WlN3aUxzS2V3SVFjdHozQ3p6ejVjclBFYkN2dS84TWxkRGRYelRzR01LTFlh?=
 =?utf-8?B?WCs5b2lQcTNRNytZaWdWZEtNZ2hNOXg0Qk5rb0E5dkNBeGdZUEhNZU5tT2lt?=
 =?utf-8?B?WXJKcGRYam8wME1BZHNNa0FPbXFPblF0N2F0cWsvN3creCt6anY2ZWRHUG1R?=
 =?utf-8?B?cmMwQnVBQ2NZT1RpdDA5c0x0ZWEvVHZQRGVwL2w4Q1JGSlR4TDB2Um9lSHR2?=
 =?utf-8?B?QjFPNXo3TjBOTWZ2RWptZ2l1MmNhSDVsa2JDMitwc1VwOUpNcm9SMXdYc2pz?=
 =?utf-8?B?RWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50868ded-991c-40f1-10ea-08daf46f39cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 07:32:57.3878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e/69XVAHs8VA6Oo0LYGopRsL3x6/leaFrY1r/9FYm9Wny6m7gscxKc8yX9kADE4yrOpEnDfl3/tTw1y7ZHpOfssnZmkVRelu2pn3PwjSANH4BymkAPewIjxh/0F8taal
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
ZXNkYXksIEphbnVhcnkgMTAsIDIwMjMgMTE6MTUgUE0NCj4gDQo+IEhpIFlvc2hpaGlybywNCj4g
T24gVHVlLCAyMDIzLTAxLTEwIGF0IDE0OjAyICswOTAwLCBZb3NoaWhpcm8gU2hpbW9kYSB3cm90
ZToNCj4gPiBTaW1wbGlmeSBzdHJ1Y3QgcGh5ICpzZXJkZXMgaGFuZGxpbmcgYnkga2VlcGluZyB0
aGUgdmFsaWFibGUgaW4NCj4gPiB0aGUgc3RydWN0IHJzd2l0Y2hfZGV2aWNlLg0KPiA+DQo+ID4g
U2lnbmVkLW9mZi1ieTogWW9zaGloaXJvIFNoaW1vZGEgPHlvc2hpaGlyby5zaGltb2RhLnVoQHJl
bmVzYXMuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jz
d2l0Y2guYyB8IDQwICsrKysrKysrKysrKy0tLS0tLS0tLS0NCj4gPiAtLS0tDQo+ID4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcnN3aXRjaC5oIHwgIDEgKw0KPiA+ICAyIGZpbGVzIGNo
YW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDIyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4NCj4gPg0K
PiA+IC1zdGF0aWMgaW50IHJzd2l0Y2hfc2VyZGVzX3NldF9wYXJhbXMoc3RydWN0IHJzd2l0Y2hf
ZGV2aWNlICpyZGV2KQ0KPiA+DQo+ID4NCj4gPiAgc3RhdGljIGludCByc3dpdGNoX2V0aGVyX3Bv
cnRfaW5pdF9vbmUoc3RydWN0IHJzd2l0Y2hfZGV2aWNlICpyZGV2KQ0KPiA+IEBAIC0xMjk5LDYg
KzEyOTAsMTAgQEAgc3RhdGljIGludCByc3dpdGNoX2V0aGVyX3BvcnRfaW5pdF9vbmUoc3RydWN0
DQo+ID4gcnN3aXRjaF9kZXZpY2UgKnJkZXYpDQo+ID4gIAlpZiAoZXJyIDwgMCkNCj4gPiAgCQln
b3RvIGVycl9waHlsaW5rX2luaXQ7DQo+ID4NCj4gPiArCWVyciA9IHJzd2l0Y2hfc2VyZGVzX3Bo
eV9nZXQocmRldik7DQo+ID4gKwlpZiAoZXJyIDwgMCkNCj4gPiArCQlnb3RvIGVycl9zZXJkZXNf
cGh5X2dldDsNCj4gDQo+IEkgdGhpbmssIHdlIGNhbiB1c2UgKmVycl9zZXJkZXNfc2V0X3BhcmFt
cyogaW5zdGVhZCBvZiBjcmVhdGluZyBuZXcNCj4gbGFiZWwgZXJyX3NlcmRlc19waHlfZ2V0LCBz
aW5jZSB0aGUgbGFiZWwgaXMgbm90IGRvaW5nIGFueSB3b3JrLg0KDQpUaGFuayB5b3UgZm9yIHlv
dXIgY29tbWVudC4gSG93ZXZlciwgdGhpcyBkcml2ZXIgYWxyZWFkeSBoYXMgYSBzaW1pbGFyDQps
YWJlbCBhbmQgZXJyb3IgaGFuZGxpbmcgbGlrZSBiZWxvdzoNCi0tLQ0KICAgICAgICBlcnIgPSBy
c3dpdGNoX2d3Y2FfcmVxdWVzdF9pcnFzKHByaXYpOw0KICAgICAgICBpZiAoZXJyIDwgMCkNCiAg
ICAgICAgICAgICAgICBnb3RvIGVycl9nd2NhX3JlcXVlc3RfaXJxOw0KDQogICAgICAgIGVyciA9
IHJzd2l0Y2hfZ3djYV9od19pbml0KHByaXYpOw0KICAgICAgICBpZiAoZXJyIDwgMCkNCiAgICAg
ICAgICAgICAgICBnb3RvIGVycl9nd2NhX2h3X2luaXQ7DQouLi4NCmVycl9nd2NhX2h3X2luaXQ6
DQplcnJfZ3djYV9yZXF1ZXN0X2lycToNCiAgICAgICAgcmNhcl9nZW40X3B0cF91bnJlZ2lzdGVy
KHByaXYtPnB0cF9wcml2KTsNCi0tLQ0KDQpUaGUgZXJyXyBsYWJlbHMgYXJlIHJlbGF0ZWQgdG8g
dGhlIGZ1bmN0aW9ucy4NClNvLCBJIHRoaW5rIGtlZXBpbmcgc2FtZSBmdW5jdGlvbiBuYW1lcy9s
YWJlbCBuYW1lcyBpcw0KYmV0dGVyIGZvciByZWFkYWJpbGl0eS4NCg0KQmVzdCByZWdhcmRzLA0K
WW9zaGloaXJvIFNoaW1vZGENCg0KPiA+ICsNCj4gPiAgCWVyciA9IHJzd2l0Y2hfc2VyZGVzX3Nl
dF9wYXJhbXMocmRldik7DQo+ID4gIAlpZiAoZXJyIDwgMCkNCj4gPiAgCQlnb3RvIGVycl9zZXJk
ZXNfc2V0X3BhcmFtczsNCj4gPiBAQCAtMTMwNiw2ICsxMzAxLDcgQEAgc3RhdGljIGludCByc3dp
dGNoX2V0aGVyX3BvcnRfaW5pdF9vbmUoc3RydWN0DQo+ID4gcnN3aXRjaF9kZXZpY2UgKnJkZXYp
DQo+ID4gIAlyZXR1cm4gMDsNCj4gPg0KPiA+ICBlcnJfc2VyZGVzX3NldF9wYXJhbXM6DQo+ID4g
K2Vycl9zZXJkZXNfcGh5X2dldDoNCj4gPiAgCXJzd2l0Y2hfcGh5bGlua19kZWluaXQocmRldik7
DQo+ID4NCj4gPiAgZXJyX3BoeWxpbmtfaW5pdDoNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcnN3aXRjaC5oDQo+ID4gaW5kZXggZWRiZGQxYjk4ZDNkLi5kOWEwYmU2NjY2ZjUg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmgN
Cj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jzd2l0Y2guaA0KPiA+IEBA
IC05NDEsNiArOTQxLDcgQEAgc3RydWN0IHJzd2l0Y2hfZGV2aWNlIHsNCj4gPg0KPiA+ICAJaW50
IHBvcnQ7DQo+ID4gIAlzdHJ1Y3QgcnN3aXRjaF9ldGhhICpldGhhOw0KPiA+ICsJc3RydWN0IHBo
eSAqc2VyZGVzOw0KPiA+ICB9Ow0KPiA+DQo+ID4gIHN0cnVjdCByc3dpdGNoX21md2RfbWFjX3Rh
YmxlX2VudHJ5IHsNCg==
