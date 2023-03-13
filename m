Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16226B75A0
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjCMLOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjCMLOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:14:02 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on20608.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe13::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D8BDBFE
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 04:13:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0ZX66ApwWi+72b0PEguL/lkcNR9Qa3x4H9YJiajV6YcHY6I7h6Iu4Hd1C059v9iDMql+we8ql6kzVTvbgTh0J+eF6Mi614XooGCpx9m05JAbL8mKfKgpdaUBNxjI4b0bNMIoYa6vc+vke6YGXiVceVy09KhHTTPmb828mpRyZxBD5UhqweRIIuj+psXcKLGnY6ttdan5UC2XusVgKv2Yg5/5sPDK59TuXzRuS6tP0mo5D/I11JfD00ccgVtf0KKPypVvUUJVyNMkh9NinSO8AehCLioxyf3lrswtgv+vRzJqaTVWpGyT/0KKmeknjhcAz3zuG4mRUmhTGO5TPLxOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUu+RXcZ/hk7BMXW1VzLDji4aaPVSYsV5wbnFjuT/5M=;
 b=JanycBl2DRuJ2X0tTPEKpH2NofC8H9iK3YO/aV+xFGA2pJVnO9KuVHw+hg1yAdzpd3Oax1QYDBc/eop3Ze1LTeF6Hicc1LxxzOaHsijvn7WywJ4N2m8foCVFXMnrKVnW5QhwX/PU9C//UXjtsle511hhOrpi8nDEc3cX3Drw4Us8M1GtvAkdN+8LjlQGjrA5pzr2eZWE8Z7GutPhcR0INlKmYGMm3iuQN23YIHMc9rMdeek4xZReztPdNxHkNF0y3HjCUwVOSiXhEHpSHI8JE2y4HwmL+OIMdtIPdlQcMbUigA27ewmbBNDnpmev3UwmhbOAleYXe4gNmG8hRHy12Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUu+RXcZ/hk7BMXW1VzLDji4aaPVSYsV5wbnFjuT/5M=;
 b=q1M+02RynpSuX70dAFjQBvRAHFBdWC0uuY5J2gYsfH8bZrO4bib5coonNuhkx+n6rUiALEjjVry0nZNZoZNgAmLLKWWfdWWsJM9Y+oV67UPnqYl6kcPuzBXQ04u/r5HDUi0mqxn9pSb0Pod2HKbnTrL7jRdTTq3lEjkmJupwiBk=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM0PR04MB7137.eurprd04.prod.outlook.com (2603:10a6:208:19c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 11:12:54 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::806:4eb3:88bd:1690]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::806:4eb3:88bd:1690%7]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 11:12:54 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [PATCH net-next 1/9] net: dpaa: Improve error reporting
Thread-Topic: [PATCH net-next 1/9] net: dpaa: Improve error reporting
Thread-Index: AQHZVZe+2gR59o9mEki+ivT0E3yG2q74jRvg
Date:   Mon, 13 Mar 2023 11:12:53 +0000
Message-ID: <AM6PR04MB39768E58DEFE24FB41C107EBECB99@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
 <20230313103653.2753139-2-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230313103653.2753139-2-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR04MB3976:EE_|AM0PR04MB7137:EE_
x-ms-office365-filtering-correlation-id: cb1b0864-b14c-4577-5313-08db23b3e452
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cV7D4P3aiNQL+AQLT6gLJWSi2aBj8DFLyVeu9fXjLJiCTUzQ1dZ5y2xk9n+YyPkzeAqY/DPlA+kHHFDO+OXzIPM56uN5Px8B83/zEhPg+5hjgtqE/C9kVJMsmqwY05ejMot+5rzpNBXALe2GA0AnVpqau6quiJla3p37e7GNQEFL9yuRQr812hi7LVRkHc5J9oGQkXFgIZsY03co149C0Rl/WrSxuBAMduQMPBQF3S62pOzmt30prXGTZ0EgIMxwmapOONGg/JF1S0L2QB8nef24reVoY8JlvzxtWx32IBZNGzGtyPomYlzvz9qnv97GEbz97LeekH36cAXNVsFB+54qklRbI7xaD+aiOg2okhPBIQ5J0z/UjBdFwcV+FT75tK+w+TdkrbIwLSuERDTbpeaQfKYtgpBfQpd6WArQD9s5Y2T5AYtka5fX4q4KBLt+AvEzPqYqCcesRJIII2hAdY/LhoNIY749VW0mV9EJky8Fc8fQwC4QyeKY7M42WMwZmLAIGsrpsWPitwiCtACyFn7yMIorUa9SFOMlHAsBlnHczDrKbyFwyfcUXN06iKyLMGC3QzEsRbDfI5G88Y2nWVFfgxL4KPzMhKUKlEiwwds/oqt2DovZeg6eDG4zfD693JaZk5zrBsD5L0ZEqBRwjeZfUq/00JRbQo1RhVQ9nP5DRFlBYDDmOteJXmaSqeL16tHF0fn7HAEGpEyaMjccjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199018)(86362001)(33656002)(38070700005)(38100700002)(122000001)(44832011)(41300700001)(2906002)(52536014)(8936002)(5660300002)(55016003)(4326008)(6506007)(26005)(83380400001)(9686003)(53546011)(55236004)(110136005)(54906003)(66574015)(316002)(6636002)(186003)(66446008)(8676002)(66946007)(66556008)(66476007)(64756008)(478600001)(71200400001)(7696005)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDhXUFNpd1VUd1UvdWNnRXRNUFZORmZRSEJXc3hHMmg2UVorTzhXODRlNGhY?=
 =?utf-8?B?TDVBU09PUU5jTURGTjE3UXdrZnFyRXlJeTVueHJZTEdXK21MdTlwN3dHOXIr?=
 =?utf-8?B?aWIxd1o1ek40SG1YMjBNTDFwR3pUbzJ2cUVoNCtVaG5sUTZVYVRNRzVzTW9M?=
 =?utf-8?B?RzkrL1JZejNvbmRGdWxsQW5DMnY4SDgrQ2x6dk1oc2tVenZ0cURXWlo1VFU4?=
 =?utf-8?B?cG1PUVdBeVFWTnV6WXJmb2pYSjhPL2FtWnpvV1c4QU12OGxHVWUyZkd4bjBo?=
 =?utf-8?B?ZEhrMTQ3blNIc3B2bjVsVzlzRUNVb29rN2pTQUJKK2VkZjBOU0ZXT0xyMWZm?=
 =?utf-8?B?b3JhRDV6RHMzUEUxdnh4ck9wUVozRHd4bkZqR2dJU1hsaGZTVFN3OWF1azlM?=
 =?utf-8?B?dWp0ZzdDMWFhV0dhYXdKR3lPZnozekdqdTZES3VuRGc1ZGlRMzBnQ1ZhendJ?=
 =?utf-8?B?cHBQZW9Xb0hRaTI4NHZCeTB1MjZYV3VFaVQyeXR1Mlh1ZkJmaEVpK2pvQWNq?=
 =?utf-8?B?UUNsMWNNOHhaRHc0UjgvNVY3OEFBRnlmV0dvS2VHUzlPVG1Fb0RHQXlvMVVZ?=
 =?utf-8?B?aFNOUlpUS1hCREk3UWRmWldUc2lTVGJCWlBaR1pFZ09ZVFowcEdPN1VQMllp?=
 =?utf-8?B?Tm1hWlR5eVA3aTNhQU9qMno2SU9iYW1VWklXQS9lRVdiWWluYTFYclpsc0Fi?=
 =?utf-8?B?c3U4bnhaUmZTSDRzaDFsdmtlNWRKT1V6eE9qenJ2ekhtNUYrdUZDZDUyWnhi?=
 =?utf-8?B?b1Q0TUlPM09KcmszbXg1N2FSMjRpNnk3WTJpQXFzMjE4MnhSRHhyeCtUZmVP?=
 =?utf-8?B?UTNyVjRDa2lNWjNMTkZKbE5DZ3E4ZFhLTjVSak9oODZycXc3MTlnVWFxejEx?=
 =?utf-8?B?OG1BeTJZWUNENWVGOUZCN2l3dHFUR0o2dlA2aUpTWWhBcW1ZdkEzaFovMmJw?=
 =?utf-8?B?ZmNIcXJGdk5yMnVWOFpxYnRMd05QLzNyYjNPTE1Jc09DbXBSOC9TTXFHY1Fq?=
 =?utf-8?B?K0JHL2xLU2pqUXkwZUpFTnZzWFJ5ZlVsVXNBb2IyL3dZTGdXTzA4ZDY0bzdp?=
 =?utf-8?B?U3ZWSE8yUXlqMWdEZ1dUd1FFTnA2aUNrd0RiZElzL0M4eUsyRFNiNVR2S3VW?=
 =?utf-8?B?RTBNRlZodWlyR3RHMGZ2MnRDa0MyWnBuay9rdkxCOEFrVkI4ZWVsajhPM0dw?=
 =?utf-8?B?YmdDckN2ZUxkb0JyRHlzYWRVZWV1OVpOSkRqeHE1bndtMTJIQUVzQ2J3QW5z?=
 =?utf-8?B?Z1QxRmMrdVZGRFF6eWdtNlZIVWVFRFF1S1FXSFhHL2lmL25yZjI4QmgrOUN2?=
 =?utf-8?B?b2pzSlQ4bmhyMTRPQ2tlUjQ0cytCNVQ0N3I4MDNyZEJ6ZjVkaUUrRkM4eksw?=
 =?utf-8?B?MFVrVi9ERkttREE0VjdlMm9DZitGNjYza1pWaDl6VnU5VnMxcmcvWng0cDVx?=
 =?utf-8?B?K1ZrM0M1bi9RcmMwMk9EdldBUXlVRHI2L29pNTlSb3hvTUFDNDJ0enNzdUUz?=
 =?utf-8?B?cXlvNDBGTXBYL2xpUFlsb1YwUFVmb2ZWWFl0NHE5YmxUY0src3haK2p5bTdk?=
 =?utf-8?B?L2FraWRaSzV1YlpFN0xqZ1pwV3Nobkl3aGo1NUhWNVI5SUhQVkZuVXVYWnZX?=
 =?utf-8?B?c29pMVRscWo4Z21nK0ZWbnlmQml5a1A5VlNEbkxpZWg1U1k2ZGJmTnBMSEVP?=
 =?utf-8?B?U0h6aGFtL0xMV01VamhXL292YXJFa05WZU14NTh0dWZ5T2ZKVzBMcit0MWQv?=
 =?utf-8?B?bWtsaW1OVTI4VjF5Z0oxdEZsT2V5eEl4T1FsTVdueGhMc25Lc1ZQd29yalJZ?=
 =?utf-8?B?elg4VU56VGgxM2lKVVArN2VnSFdHN0JMSGVudzhETy9YUHE0L3JCcGU1NFF5?=
 =?utf-8?B?WTFLVk9XM1U3UWlLZmRmODZCblE2N3lPK2Vla3JvdDJ4WlFtVXlYWjJQK2Jv?=
 =?utf-8?B?TFMrWUd4VjRIWjc5RVVvRWVzWXpwUnRHa1k2RDZSZ20weDJrRXgxM2o1cE1y?=
 =?utf-8?B?WWlHTko5MzdwK2JLQUpyRVhiQkc4RW1JL1lzSGVpcW16WnhWbWdSaldBR2Jk?=
 =?utf-8?B?OEtyYURnMDVQRklkbGdXMENPQk5xNW5qNFd2ZWxuV0FjMksrRHBNNVVFekRj?=
 =?utf-8?Q?knYjhqY5sIrX5udfoVX0NZur8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1b0864-b14c-4577-5313-08db23b3e452
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 11:12:53.9150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o/2wAJJrvgFb3U7IHov0uQU9NiLyEz0ZqAty6YNImTGYbWHzAAIhSC3S0p78RirQZbnWKWyI0CAjhlVcI0svIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7137
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFV3ZSBLbGVpbmUtS8O2bmln
IDx1LmtsZWluZS1rb2VuaWdAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDEzIE1hcmNoIDIwMjMg
MTI6MzcNCj4gVG86IE1hZGFsaW4gQnVjdXIgPG1hZGFsaW4uYnVjdXJAbnhwLmNvbT47IERhdmlk
IFMuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6
ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tpDQo+IDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9s
byBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+OyBSdXNzZWxsIEtpbmcNCj4gPGxpbnV4QGFybWxp
bnV4Lm9yZy51az4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGtlcm5lbEBwZW5ndXRy
b25peC5kZQ0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHQgMS85XSBuZXQ6IGRwYWE6IEltcHJv
dmUgZXJyb3IgcmVwb3J0aW5nDQo+IA0KPiBJbnN0ZWFkIG9mIHRoZSBnZW5lcmljIGVycm9yIG1l
c3NhZ2UgZW1pdHRlZCBieSB0aGUgZHJpdmVyIGNvcmUgd2hlbiBhDQo+IHJlbW92ZSBjYWxsYmFj
ayByZXR1cm5zIGFuIGVycm9yIGNvZGUgKCJyZW1vdmUgY2FsbGJhY2sgcmV0dXJuZWQgYQ0KPiBu
b24temVybyB2YWx1ZS4gVGhpcyB3aWxsIGJlIGlnbm9yZWQuIiksIGVtaXQgYSBtZXNzYWdlIGRl
c2NyaWJpbmcgdGhlDQo+IGFjdHVhbCBwcm9ibGVtIGFuZCByZXR1cm4gemVybyB0byBzdXBwcmVz
cyB0aGUgZ2VuZXJpYyBtZXNzYWdlLg0KPiANCj4gTm90ZSB0aGF0IGFwYXJ0IGZyb20gc3VwcHJl
c3NpbmcgdGhlIGdlbmVyaWMgZXJyb3IgbWVzc2FnZSB0aGVyZSBhcmUgbm8NCj4gc2lkZSBlZmZl
Y3RzIGJ5IGNoYW5naW5nIHRoZSByZXR1cm4gdmFsdWUgdG8gemVyby4gVGhpcyBwcmVwYXJlcw0K
PiBjaGFuZ2luZyB0aGUgcmVtb3ZlIGNhbGxiYWNrIHRvIHJldHVybiB2b2lkLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogVXdlIEtsZWluZS1Lw7ZuaWcgPHUua2xlaW5lLWtvZW5pZ0BwZW5ndXRyb25p
eC5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFh
X2V0aC5jIHwgNCArKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNj
YWxlL2RwYWEvZHBhYV9ldGguYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9k
cGFhL2RwYWFfZXRoLmMNCj4gaW5kZXggOTMxOGEyNTU0MDU2Li45N2NhZDM3NTAwOTYgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2RwYWFfZXRoLmMN
Cj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGguYw0K
PiBAQCAtMzUyMCw2ICszNTIwLDggQEAgc3RhdGljIGludCBkcGFhX3JlbW92ZShzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgCXBoeWxpbmtfZGVzdHJveShwcml2LT5tYWNfZGV2LT5w
aHlsaW5rKTsNCj4gDQo+ICAJZXJyID0gZHBhYV9mcV9mcmVlKGRldiwgJnByaXYtPmRwYWFfZnFf
bGlzdCk7DQo+ICsJaWYgKGVycikNCj4gKwkJZGV2X2VycigmcGRldi0+ZGV2LCAiRmFpbGVkIHRv
IGZyZWUgRlFzIG9uIHJlbW92ZVxuIik7DQoNCllvdSBoYXZlIGEgYml0IGJlZm9yZSBkZXYgPSAm
cGRldi0+ZGV2OyBzbyB5b3UgY2FuIHdyaXRlIGp1c3QgYXMgd2VsbDoNCisJCWRldl9lcnIoZGV2
LCAiRmFpbGVkIHRvIGZyZWUgRlFzIG9uIHJlbW92ZVxuIik7DQoNCldpdGggb3Igd2l0aG91dCB0
aGlzIG1pbm9yIG5pdCBwaWNrIGZpeGVkLA0KDQpBY2tlZC1ieTogTWFkYWxpbiBCdWN1ciA8bWFk
YWxpbi5idWN1ckBvc3MubnhwLmNvbT4NCg0KPiANCj4gIAlxbWFuX2RlbGV0ZV9jZ3Jfc2FmZSgm
cHJpdi0+aW5ncmVzc19jZ3IpOw0KPiAgCXFtYW5fcmVsZWFzZV9jZ3JpZChwcml2LT5pbmdyZXNz
X2Nnci5jZ3JpZCk7DQo+IEBAIC0zNTMyLDcgKzM1MzQsNyBAQCBzdGF0aWMgaW50IGRwYWFfcmVt
b3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+IA0KPiAgCWZyZWVfbmV0ZGV2KG5l
dF9kZXYpOw0KPiANCj4gLQlyZXR1cm4gZXJyOw0KPiArCXJldHVybiAwOw0KPiAgfQ0KPiANCj4g
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlX2lkIGRwYWFfZGV2dHlwZVtdID0g
ew0KPiAtLQ0KPiAyLjM5LjENCg0K
