Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57E02A4C51
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKCRIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:08:48 -0500
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:15817
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726581AbgKCRIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:08:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WasWMUHFuipCoteF4Db89CgjKUS86AZeZY2ch3nIqCviMg05nJIR7XEJQurC+zQjSi1PQUJV+l+IZieGaSgdf1sFnWMbuK53q86PJ+UNH0Wg9P8wtEOuH6ucwKtTfmrbGuOWmPXljWx+zjq54y+BCIgJQ4twHDZ4VDQP4QLeT/V1LTrlZD5h+ti74fxEWYyF110E3wWCGu3BVfccu6QftZjmS5453gHoG6FkPihiLancB+BbjqL7ETkHqrOvZW8HiN0EaoEkNEeO35TsqMYNTSGPn24AjgsVcfBHjZqUwoFX42EJpEPsTIofVRD+tsSsp77t31zWHn7fQAjAmH5cBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8zXj6Fn+QdSMNAmrIMEwMeVkiTENJ2+DFkZkkT+C9Y=;
 b=eKuNS6Au3FZfz828I/npbV2+rUftcFYpUZCCstGToGEZ11Sz6vR1tcTCJFtVr76XFQgbTRUTggrQLY5x3MB3p3YahOo5b2L26xaoHwWc5/yKdJke4ZUMhrnLRuglxV5rAHyUBBM1yNhcLkCKp0uVWAtJlEnHJbBtNVxhSBFqG5ZoqsALEeNuo8nGEbcpujIApUMTE5A7V8PEZMG5F3uYPy2aenAn0WKyIsoxSpreEWFiePB7pQF8HDfdP2NJJCL2460oXBYERIvRk43IOhoAfMpwm+/No1PTFAVUbpSPQu8rxvoZ8e5sPJVJbHXDHfnrxN1AAyhtoaLsoNUjOW9w4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8zXj6Fn+QdSMNAmrIMEwMeVkiTENJ2+DFkZkkT+C9Y=;
 b=hFcXFl4qpqdaF+Eykc6ss7prgizaZJePj8E7ndIBWNvCRjlZkN5KupzkQRhzHLEaX0BdRvhGQp9yGppNDmwdiuJEZ/GIdnEo8ZI17tjTk/PuREsPpBSNbnJe/0+DZxa8vQqfnSvaQ2GKInhcJglzSvxiM+VtcBNrTM41M9CkJEE=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB4579.eurprd04.prod.outlook.com (2603:10a6:208:6f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 17:08:43 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 17:08:43 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: RE: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Thread-Topic: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Thread-Index: AQHWrcsPyv6BypdD30yr6oyPLeI0Tqm2nOaAgAAGegCAAAhwAA==
Date:   Tue, 3 Nov 2020 17:08:43 +0000
Message-ID: <AM0PR04MB67540916FABD7D801C9DF82496110@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <2b0606ef-71d2-cc85-98db-1e16cc63c9d2@linux.ibm.com>
In-Reply-To: <2b0606ef-71d2-cc85-98db-1e16cc63c9d2@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7dd6bee3-5ef8-4e3d-8c62-08d8801b1e98
x-ms-traffictypediagnostic: AM0PR04MB4579:
x-microsoft-antispam-prvs: <AM0PR04MB457977F4080C7AC9D394BF2896110@AM0PR04MB4579.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uVFTkWbkobdofwbMv8oHS0dN3aQcSSdPNkEQ/rnV1zxqzyWwGZ0tzTs9y9h76l6gBaM+lRX1FWQ9tAgTQOmBEpAQ1/vuxmQjU+uhxq3JIIN6oX4yv1UeOCHKaqgBaVuVCPywAUXHE5mDbIwbAH7GLMDYkvvpvWmfPEtfNYwNtIxpTkzde3HshcpBlBTB5TmZAFMevOGffEcBJlleg0XLeJED8LozyBCGCwmoy6v64fPohW+454aHanpCvtuMXoEB7WMpQAya5RqzVKCXhwg7tPnWtFJV7YlwXyq8Nkml9NuV5el8PnPc8vL2/i0TLq4IQRNqbaK+kFGjCTBic32y9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(8936002)(4744005)(9686003)(54906003)(5660300002)(316002)(8676002)(52536014)(55016002)(7696005)(44832011)(2906002)(86362001)(110136005)(64756008)(66556008)(71200400001)(4326008)(66946007)(66446008)(26005)(6506007)(66476007)(186003)(83380400001)(478600001)(33656002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iLOOYRk37cfzShBKP/mwEfTRgJQeeSGR9WgEGlAxJi1LRtRdSnpGVWB5XVnmsTWHJYIoNJc3KLMtxaUnAG5NJFQA000YTbNeQuzVV3khBahjIkHdTrAKTRMaPqL+p/szUSxNUxN+5/Qv0UvRVT78ifdA63hXVgk08faChacXYqk8IfYme9tGOnL2wH3gv01OY7rpE5B2CqG3Bp362QRQR9D40bzGAwLIg3xeXS1nJeTyy3njzITOhbbKO3fB0+HSdYUa6pY6Uw0hv4FvU9BY/hCR3yoTY9+Tu/NqosHtn7GUuJzyDHU8TpCjO9IfN9vGnP/whCaTANwZXuX1lUK7nx54avDnrdKr8sf3Thy/BdVqZ6T3i/My+XXWbqFKpLhHUHX49R12gv8TEC3pB6bgRECYq6dlPnFx+CGXgDXMC75efIjSH7sMm+zpXNMfmDcQq4HYDKJwqMAxTyHjbOPcE3z6aT8/bkUt185jeN9hKLdBIpe4i7skASKMRlEiVcL5Nr8lO7aY418R3um1/e9YIqJqBs0W3E5LwLjDmiXdIBdzgZIf1wpsWWus9gBDuFQ5DNNu70M/YwJnxp7Vc6i0p96a8yXy3GraGW5m416rPWA4Tz08NQ/+dMSxXV/QowiQcHtw8JFxros/wWSZnndRLg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd6bee3-5ef8-4e3d-8c62-08d8801b1e98
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 17:08:43.8191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +S07DvZpOcp8SXctTY3dMgydJfXuRDs2xeVJz5bliJ3E8INWCY/EoJIq+Gkrmcp/lWt1giglAxl9VQHJdJWwbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4579
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogSnVsaWFuIFdpZWRtYW5uIDxqd2lA
bGludXguaWJtLmNvbT4NCj5TZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAzLCAyMDIwIDY6MzcgUE0N
Cj5UbzogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT47IENsYXVkaXUgTWFub2ls
DQo+PGNsYXVkaXUubWFub2lsQG54cC5jb20+DQo+Q2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1Yg0KPktpY2luc2tp
IDxrdWJhQGtlcm5lbC5vcmc+OyBqYW1lcy5qdXJhY2tAYW1ldGVrLmNvbQ0KPlN1YmplY3Q6IFJl
OiBbUEFUQ0ggbmV0IHYyIDEvMl0gZ2lhbmZhcjogUmVwbGFjZSBza2JfcmVhbGxvY19oZWFkcm9v
bSB3aXRoDQo+c2tiX2Nvd19oZWFkIGZvciBQVFANCj4NCj5PbiAwMy4xMS4yMCAxODoxMywgVmxh
ZGltaXIgT2x0ZWFuIHdyb3RlOg0KWy4uLl0NCj4+DQo+PiBTdGlsbCBjcmFzaGVzIGZvciBtZToN
Cj4+DQo+DQo+R2l2ZW4gdGhlIHZhcmlvdXMgc2tiIG1vZGlmaWNhdGlvbnMgaW4gaXRzIHhtaXQg
cGF0aCwgSSB3b25kZXIgd2h5DQo+Z2lhbmZhciBkb2Vzbid0IGNsZWFyIElGRl9UWF9TS0JfU0hB
UklORy4NCg0KSGkgVmxhZGltaXIsDQpDYW4geW91IHRyeSB0aGUgYWJvdmUgc3VnZ2VzdGlvbiBv
biB5b3VyIHNldHVwPw0KVGhhbmtzLg0K
