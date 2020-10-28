Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B655029E079
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgJ1WEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:04:53 -0400
Received: from mail-vi1eur05on2113.outbound.protection.outlook.com ([40.107.21.113]:47168
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729474AbgJ1WBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:01:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1iV107LhiBY1XW5kvWWXHyIznpKFykEsKMadVbzyq+7Mpb14bHQBwmfUce5YBlPVo93ihVosNKvY38yOGfQMJEhl9oDsOQKGWUzGzdYiM1GV5QcWzucGHlBNPVGdAX/BQOq4MBTA93Vt7znxHlQhElcKs1+c7kYZgEyHQ7N5bM49U6j9w8RYvlcgY8pt7fKrP4GfU4lyLSg0TuCG17wcP3nlqWSk5NPvsOBSK0vaRteQrSoSn8WBzDZKlLbu9qtgcb1rWpbo1rf8ymw0NnNof13Ct8F9P/lDBSgysuQSVu+nMB4tbEPd88mnFGPagZlol4mYuMuUOt1XcZIOjaijA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeexZfz4IIIXjM7qQCd0CQZb2lCAE2McbRf+Agmzy4w=;
 b=OlcvpKsRYxHwt75xT8RbLDmHUuKiJSNpEzngWQ9PbvZRHBDM6umyMKL5AAVMgHkBiSL3Wda/2LM7+wh+Woaevt15wLa81NCAmNuPe03N0fNIt2e0MMnxW5aX/c54ctfGf4s6GCbRwJToepw0ksbNVsYHn836fJIdjLzETgEYC0CKaXqWVNOTv29Xl8KPDbeUwofMTemCkhXi1E672KxgKOGUdYhOpyA8rjT0+jYzfShJTPZgaScW7b1twTSM9OO0VMvEBr5BaUIlwCgd32PsVXS5hGnhzm44sbSq5YfZkb5jgwSd2ibaCkjmksyrgwy/ixWKUn3clBgLiRgPtseZ8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeexZfz4IIIXjM7qQCd0CQZb2lCAE2McbRf+Agmzy4w=;
 b=h67loJ4D+LtS/qXFSQhzi8RbPiafKRQvn9aETiiNHTh+JT5uae9gjV4C2SMgcqfKmqYKnv4weFaHtgAP6grZPdfvQ4JDGHXyFs8/oeP2v0rwPbRs+igfB1Im2W2+466MeBqAbO6V42bay5bqVrDeeBhHIeBNCjJtCZRJhDaQTsc=
Received: from DB7PR05MB4315.eurprd05.prod.outlook.com (2603:10a6:5:1f::18) by
 DB7PR05MB4473.eurprd05.prod.outlook.com (2603:10a6:5:1b::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.27; Wed, 28 Oct 2020 05:23:23 +0000
Received: from DB7PR05MB4315.eurprd05.prod.outlook.com
 ([fe80::c04f:dae3:9fa4:ff56]) by DB7PR05MB4315.eurprd05.prod.outlook.com
 ([fe80::c04f:dae3:9fa4:ff56%4]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 05:23:23 +0000
From:   Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        Xin Long <lucien.xin@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: RE: [tipc-discussion] [net v3 1/1] tipc: fix memory leak caused by
 tipc_buf_append()
Thread-Topic: [tipc-discussion] [net v3 1/1] tipc: fix memory leak caused by
 tipc_buf_append()
Thread-Index: AQHWrBCm58JZTVLJmkGUoOeheDCtC6mr7XKAgABhSqA=
Date:   Wed, 28 Oct 2020 05:23:23 +0000
Message-ID: <DB7PR05MB431592FDCD6EEB96C8DB0EE688170@DB7PR05MB4315.eurprd05.prod.outlook.com>
References: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
 <CAM_iQpWsUyxSni9+4Khuu28jvski+vfphjJSVgXJH+xS_NWsUQ@mail.gmail.com>
In-Reply-To: <CAM_iQpWsUyxSni9+4Khuu28jvski+vfphjJSVgXJH+xS_NWsUQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=dektech.com.au;
x-originating-ip: [14.161.14.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20aa00a1-0318-4fa3-fa33-08d87b01974f
x-ms-traffictypediagnostic: DB7PR05MB4473:
x-microsoft-antispam-prvs: <DB7PR05MB44737F63F6DA8362EF255D5E88170@DB7PR05MB4473.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pAkJR/aU5ggEPlj/Cqhmh7iE/gTp+1cz+0nqUQLavrx2KI5ywNYacxqouzIHEhNjp6q7guzLbFdr7MAm7nCOzp+4ChWxOZUH0O2g2ddy04qnt0yVmr0P5EGTySQykfMYYicer1YcHrJeysZrq8pe43Rc9EmmI/ZI3j0uO5tCSUeQgiq0YVZmN93zn+3tqA2HgV6pYkw3FP+fyyZVl4nGf96aTdxe/rnEIJf3FnfY5LI6WFQ3plRgrO/N/5YcHnbsu1oJS3hgWxOaRP4FA89GcExrLpJIKzMFZ+zMJFCamMV6UmtSWc2sVsuu0ZHZCsMViOrOcV8h9dexqq/6qptbQXNUYNEz2qUWWXoY8l8HJRE89yfD5+csx+D+RkG+rZNKIRdUyYGwD2CatE8SMeS+vA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4315.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39840400004)(346002)(366004)(396003)(316002)(110136005)(52536014)(66476007)(66946007)(5660300002)(66446008)(76116006)(66556008)(64756008)(53546011)(71200400001)(26005)(186003)(6506007)(7696005)(8936002)(8676002)(2906002)(9686003)(33656002)(86362001)(55016002)(966005)(478600001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fmRwQNelbRTIjs/mXI6UWRaZuwZZ0b+PzpA7qNIxx5DNUE/SR1haw7eg6Lfiw1Wte6HXNAAFJ1A154g3aE3ctXwI28dwdEUKaY9vQvUQJaK+vKO8V8XauWypbaSmAjMYWRLrgqTx2lKVW/EC5yGwbCyzcD6YSJTA8tLn3ANIEwygRpBByTSPeKv8xSsu2IlwfzW0RXcR5OYrA0eBx/9z5hsaYW3e4d+Sbd7EcTAVyO8PgM2U59k6xMsLV8d462XC0dqVdb1EqpcM8oV9nsAohr4OEUf3NA3SIGm/HnFYdgRoIc2Y1yNqWphf00XeNwBfb7GC6u/Guldij/q/FmnAHES0am6SmldVzaU+aoaocGQWTvRcjBDdDSdmYjgN2icYUsobQEDY0JGxfMuULrkXutbPEmVOLsmzHhcASJqr2HRd0aLz9SB1AJbIy59agleHfjP4fmW41OX04Xg6xED1rdZ48Fnz84St1h1nkAvbJzmSIzWq9qwNMizfN1369cYDGOiJy7mwhIUc0cdCRSeoP8y5WL8gNw+8AdA1zLjQtUoMKU86juk46E94E8dLNvQw0PJekEmwzH46Uzs/Gk9X6tbJXLOwmmYwFWLmS/A4c+CWkjmX4mxrFhwD3wfDnTp+mDx7COgipTKJNhXL/soJcA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4315.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20aa00a1-0318-4fa3-fa33-08d87b01974f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2020 05:23:23.3681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/EHy6OsM8G8H/ZCMjmHk4PvluePGm4XqiSjECeDvJAPqcHRnn0DJ0EUHJiqJ5RwHADw6uip3p5RWhI5Dnt8JITQ1k7vmVQAOseiP/zWrsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ29uZywNCg0KTm8sIEkgaGF2ZSBuZXZlciBpZ25vcmVkIGFueSBjb21tZW50IGZyb20gcmV2
aWV3ZXJzLiBJIHNlbnQgdjIgb24gT2N0IDI2IGFmdGVyIGRpc2N1c3Npbmcgd2l0aCBYaW4gTG9u
ZywgYW5kIHYzIG9uIE9jdCAyNyBhZnRlciByZWNlaXZpbmcgY29tbWVudCBmcm9tIEpha3ViLg0K
SSByZWNlaXZlZCB5b3VyIDMgZW1haWxzIG5lYXJseSBhdCB0aGUgc2FtZSB0aW1lIG9uIE9jdCAy
OC4gSXQncyB3ZWlyZC4gWW91ciBlbWFpbHMgZGlkIG5vdCBhcHBlYXIgaW4gdGhpcyBlbWFpbCBh
cmNoaXZlIGVpdGhlcjogaHR0cHM6Ly9zb3VyY2Vmb3JnZS5uZXQvcC90aXBjL21haWxtYW4vdGlw
Yy1kaXNjdXNzaW9uLw0KDQpBbnl3YXksIEkgYW5zd2VyIHlvdXIgcXVlc3Rpb25zOg0KMS8gV2h5
IGl0IGlzIG5vdCBjb3JyZWN0IGlmIG5vdCBkZWNyZWFzaW5nIHRoZSBkYXRhIHJlZmVyZW5jZSBj
b3VudGVyIGluIHRpcGNfYnVmX2FwcGVuZCgpDQpJbiBteSBjaGFuZ2Vsb2csIEkganVzdCBwaW5w
b2ludGVkIHRoZSBwbGFjZSB3aGVyZSB0aGUgbGVhayB3b3VsZCBoYXBwZW4uIEkgc2hvdyB5b3Ug
dGhlIGRldGFpbHMgaGVyZToNCnRpcGNfbXNnX3JlYXNzZW1ibGUobGlzdCwtKQ0Kew0KIC4uLg0K
IGZyYWcgPSBza2JfY2xvbmUoc2tiLCBHRlBfQVRPTUlDKTsgLy8gZWFjaCBkYXRhIHJlZmVyZW5j
ZSBjb3VudGVyIG9mIHRoZSBvcmlnaW5hbCBza2IgaGFzIHRoZSB2YWx1ZSBvZiAyLg0KIC4uLg0K
IElmICh0aXBjX2J1Zl9hcHBlbmQoJmhlYWQsICZmcmFnKSkgLy8gZWFjaCBkYXRhIHJlZmVyZW5j
ZSBjb3VudGVyIG9mIHRoZSBvcmlnaW5hbCBza2IgU1RJTEwgaGFzIHRoZSB2YWx1ZSBvZiAyIGJl
Y2F1c2UgdGhlIHVzYWdlIG9mIHNrYl9jb3B5KCkgaW5zdGVhZCBvZiBza2JfdW5zaGFyZSgpDQog
Li4uDQp9DQpUaGUgb3JpZ2luYWwgc2tiIGxpc3QgdGhlbiBpcyBwYXNzZWQgdG8gdGlwY19iY2Fz
dF94bWl0KCkgd2hpY2ggaW4gdHVybiBjYWxscyB0aXBjX2xpbmtfeG1pdCgpOg0KdGlwY19saW5r
X3htaXQoLSwgbGlzdCwgLSkNCnsNCiAuLi4NCiBfc2tiID0gc2tiX2Nsb25lKHNrYiwgR0ZQX0FU
T01JQyk7IC8vIGVhY2ggZGF0YSByZWZlcmVuY2UgY291bnRlciBvZiB0aGUgb3JpZ2luYWwgc2ti
IGhhcyB0aGUgdmFsdWUgb2YgMy4NCi4uLg0KfQ0KDQpXaGVuIGVhY2ggY2xvbmVkIHNrYiBpcyBz
ZW50IG91dCBieSB0aGUgZHJpdmVyLCBpdCBpcyBmcmVlZCBieSB0aGUgZHJpdmVyLiBUaGF0IGxl
YWRzIHRvIGVhY2ggZGF0YSByZWZlcmVuY2UgY291bnRlciBvZiB0aGUgb3JpZ2luYWwgc2tiIGhh
cyB0aGUgdmFsdWUgb2YgMi4NCkFmdGVyIHJlY2VpdmluZyBBQ0sgZnJvbSBhbm90aGVyIHBlZXIs
IHRoZSBvcmlnaW5hbCBza2IgbmVlZHMgdG8gYmUgZnJlZWQ6DQp0aXBjX2xpbmtfYWR2YW5jZV90
cmFuc21xKCkNCnsNCiAuLi4NCiBrZnJlZV9za2Ioc2tiKTsgIC8vIG1lbW9yeSBleGlzdHMgYWZ0
ZXIgYmVpbmcgZnJlZWQgYmVjYXVzZSB0aGUgZGF0YSByZWZlcmVuY2UgY291bnRlciBzdGlsbCBo
YXMgdGhlIHZhbHVlIG9mIDIuDQp9DQoNClRoaXMgaW5kZWVkIGNhdXNlcyBtZW1vcnkgbGVhay4N
Cg0KMi8gV2h5IHByZXZpb3VzbHktdXNlZCBza2JfdW5jbG9uZSgpIHdvcmtzLg0KVGhlIHB1cnBv
c2Ugb2Ygc2tiX3VuY2xvbmUoKSBpcyB0byB1bmNsb25lIHRoZSBjbG9uZWQgc2tiLiBTbywgaXQg
ZG9lcyBub3QgbWFrZSBhbnkgc2Vuc2UgdG8gc2F5IHRoYXQgIiBza2JfdW5jbG9uZSgpIGV4cGVj
dHMgcmVmY250ID09IDEiIGFzIEkgdW5kZXJzdGFuZA0KeW91IGltcGxpZWQgdGhlIGRhdGEgcmVm
ZXJlbmNlIGNvdW50ZXIuDQpwc2tiX2V4cGFuZF9oZWFkKCkgaW5zaWRlIHNrYl91bmNsb25lKCkg
cmVxdWlyZXMgdGhhdCB0aGUgdXNlciByZWZlcmVuY2UgY291bnRlciBoYXMgdGhlIHZhbHVlIG9m
IDEgYXMgaW1wbGVtZW50ZWQ6DQpwc2tiX2V4cGFuZF9oZWFkKCkNCnsNCiAuLi4NCiBCVUdfT04o
c2tiX3NoYXJlZChza2IpKTsgLy8gVXNlciByZWZlcmVuY2UgY291bnRlciBtdXN0IGJlIDENCi4u
Lg0KYXRvbWljX3NldCgmc2tiX3NoaW5mbyhza2IpLT5kYXRhcmVmLCAxKTsgLy8gVGhlIGRhdGEg
cmVmZXJlbmNlIGNvdW50ZXIgb2YgdGhlIG9yaWdpbmFsIHNrYiBoYXMgdGhlIHZhbHVlIG9mIDEN
Ci4uLg0KfQ0KVGhhdCBleHBsYWlucyB3aHkgYWZ0ZXIgYmVpbmcgcGFzc2VkIHRvIHRpcGNfbGlu
a194bWl0KCksIGVhY2ggZGF0YSByZWZlcmVuY2UgY291bnRlciBvZiBlYWNoIG9yaWdpbmFsIHNr
YiBoYXMgdGhlIHZhbHVlIG9mIDIgYW5kIGNhbiBiZSBmcmVlZCBpbiB0aXBjX2xpbmtfYWR2YW5j
ZV90cmFuc21xKCkuDQoNCkJlc3QgcmVnYXJkcywNClR1bmcgTmd1eWVuDQoNCi0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBDb25nIFdhbmcgPHhpeW91Lndhbmdjb25nQGdtYWlsLmNv
bT4gDQpTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIgMjgsIDIwMjAgMzo1MCBBTQ0KVG86IFR1bmcg
UXVhbmcgTmd1eWVuIDx0dW5nLnEubmd1eWVuQGRla3RlY2guY29tLmF1Pg0KQ2M6IERhdmlkIE1p
bGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IExpbnV4IEtlcm5lbCBOZXR3b3JrIERldmVsb3Bl
cnMgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyB0aXBjLWRpc2N1c3Npb25AbGlzdHMuc291cmNl
Zm9yZ2UubmV0DQpTdWJqZWN0OiBSZTogW3RpcGMtZGlzY3Vzc2lvbl0gW25ldCB2MyAxLzFdIHRp
cGM6IGZpeCBtZW1vcnkgbGVhayBjYXVzZWQgYnkgdGlwY19idWZfYXBwZW5kKCkNCg0KT24gVHVl
LCBPY3QgMjcsIDIwMjAgYXQgMTowOSBQTSBUdW5nIE5ndXllbg0KPHR1bmcucS5uZ3V5ZW5AZGVr
dGVjaC5jb20uYXU+IHdyb3RlOg0KPg0KPiBDb21taXQgZWQ0Mjk4OWVhYjU3ICgidGlwYzogZml4
IHRoZSBza2JfdW5zaGFyZSgpIGluIHRpcGNfYnVmX2FwcGVuZCgpIikNCj4gcmVwbGFjZWQgc2ti
X3Vuc2hhcmUoKSB3aXRoIHNrYl9jb3B5KCkgdG8gbm90IHJlZHVjZSB0aGUgZGF0YSByZWZlcmVu
Y2UNCj4gY291bnRlciBvZiB0aGUgb3JpZ2luYWwgc2tiIGludGVudGlvbmFsbHkuIFRoaXMgaXMg
bm90IHRoZSBjb3JyZWN0DQo+IHdheSB0byBoYW5kbGUgdGhlIGNsb25lZCBza2IgYmVjYXVzZSBp
dCBjYXVzZXMgbWVtb3J5IGxlYWsgaW4gMg0KPiBmb2xsb3dpbmcgY2FzZXM6DQo+ICAxLyBTZW5k
aW5nIG11bHRpY2FzdCBtZXNzYWdlcyB2aWEgYnJvYWRjYXN0IGxpbmsNCj4gICBUaGUgb3JpZ2lu
YWwgc2tiIGxpc3QgaXMgY2xvbmVkIHRvIHRoZSBsb2NhbCBza2IgbGlzdCBmb3IgbG9jYWwNCj4g
ICBkZXN0aW5hdGlvbi4gQWZ0ZXIgdGhhdCwgdGhlIGRhdGEgcmVmZXJlbmNlIGNvdW50ZXIgb2Yg
ZWFjaCBza2INCj4gICBpbiB0aGUgb3JpZ2luYWwgbGlzdCBoYXMgdGhlIHZhbHVlIG9mIDIuIFRo
aXMgY2F1c2VzIGVhY2ggc2tiIG5vdA0KPiAgIHRvIGJlIGZyZWVkIGFmdGVyIHJlY2VpdmluZyBB
Q0s6DQoNClRoaXMgZG9lcyBub3QgbWFrZSBzZW5zZSBhdCBhbGwuDQoNCnNrYl91bmNsb25lKCkg
ZXhwZWN0cyByZWZjbnQgPT0gMSwgYXMgc3RhdGVkIGluIHRoZSBjb21tZW50cw0KYWJvdmUgcHNr
Yl9leHBhbmRfaGVhZCgpLiBza2JfdW5jbG9uZSgpIHdhcyB1c2VkIHByaW9yIHRvDQpYaW4gTG9u
ZydzIGNvbW1pdC4NCg0KU28gZWl0aGVyIHRoZSBhYm92ZSBpcyB3cm9uZywgb3Igc29tZXRoaW5n
IGltcG9ydGFudCBpcyBzdGlsbCBtaXNzaW5nDQppbiB5b3VyIGNoYW5nZWxvZy4gTm9uZSBvZiB0
aGVtIGlzIGFkZHJlc3NlZCBpbiB5b3VyIFYzLg0KDQpJIGFsc28gYXNrZWQgeW91IHR3byBxdWVz
dGlvbnMgYmVmb3JlIHlvdSBzZW50IFYzLCB5b3Ugc2VlbSB0bw0KaW50ZW50aW9uYWxseSBpZ25v
cmUgdGhlbS4gVGhpcyBpcyBub3QgaG93IHdlIGNvbGxhYm9yYXRlLg0KDQpUaGFua3MuDQo=
