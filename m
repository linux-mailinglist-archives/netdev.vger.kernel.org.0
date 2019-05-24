Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A5294B4
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390048AbfEXJfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:35:16 -0400
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:22992
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389841AbfEXJfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8qClt4G1N1/n+twgVW5ucSMFjUBNphO2NDFFMnHOtQ=;
 b=OjEsMXpZZgaZ4AYhg7XHt27IcMvLQVPCuXVe730EejSt/Z2gPXQZAIQ4YVNl7Yu3ru1ttBBpY2KODLsBrnIxi+wUoM8YlImOELiLw/TPeZXF9yeGzVSmHEhJzwBtMIqHD3AJc4eMup/ZTdb6fgTgUaxRyYzs/ydKYk9I8GpJygE=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4294.eurprd05.prod.outlook.com (52.135.160.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 24 May 2019 09:35:11 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 09:35:11 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next v3 00/16] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Topic: [PATCH bpf-next v3 00/16] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Index: AQHVEhP77EFLAt51B0eS4F+v4SSj1g==
Date:   Fri, 24 May 2019 09:35:11 +0000
Message-ID: <20190524093431.20887-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0126.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::18) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf203175-d841-4a2a-afdc-08d6e02b1df9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4294;
x-ms-traffictypediagnostic: AM6PR05MB4294:
x-microsoft-antispam-prvs: <AM6PR05MB429438A376D1E53063EAFDCED1020@AM6PR05MB4294.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(366004)(346002)(376002)(199004)(189003)(66476007)(99286004)(478600001)(66556008)(66946007)(14454004)(68736007)(6506007)(64756008)(386003)(66446008)(36756003)(316002)(54906003)(110136005)(73956011)(107886003)(26005)(486006)(71200400001)(71190400001)(52116002)(186003)(305945005)(7736002)(2616005)(2906002)(476003)(6436002)(5660300002)(53936002)(50226002)(7416002)(8676002)(102836004)(1076003)(8936002)(256004)(66066001)(86362001)(25786009)(6486002)(6512007)(4326008)(66574012)(81166006)(3846002)(6116002)(81156014)(14444005)(42413003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4294;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nb8vlB2owOTWhvzm2omVmP0o97V8/EtzWLsTwfsmvo5f2FM4eexn7R0pHKGcqiGlhpzpoyN8C6PjQHOzhTivebTKIs+8umgkXVaIAS6vzOASFzX/9S2GF3x2C8XEyoIHCp9+lUDtDfT+3qGmwS9lwxklwQSukVfmum1ILFYzmqj7Z01zLT9UBRqBPXCssMwIh3hNXlXPNn7JyOuFPv1NNyw3yD7SXMWU+bMdgnJiCQ0Jt34lX2zVusPJ7iUdERMxxI5q4TDZovFAHvF9iILhY1nmtPUku1pcKI59va/7WuGQeNLoQSwM1pJ3x9Li5Z2nU5+iWxw0L9/UVIK+3xiRKzBBhsqJxJcgGV1iQyhLgPmwEy8A6K82mCy3YHnXIH/sQo4JX53vh4Tgv/S+t75VRd+cwVDUS4iigB46wnEMXzk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F37DB59039EA7C42ADB4EB83175A72CF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf203175-d841-4a2a-afdc-08d6e02b1df9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:35:11.4180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4294
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBzZXJpZXMgY29udGFpbnMgaW1wcm92ZW1lbnRzIHRvIHRoZSBBRl9YRFAga2VybmVsIGlu
ZnJhc3RydWN0dXJlDQphbmQgQUZfWERQIHN1cHBvcnQgaW4gbWx4NWUuIFRoZSBpbmZyYXN0cnVj
dHVyZSBpbXByb3ZlbWVudHMgYXJlDQpyZXF1aXJlZCBmb3IgbWx4NWUsIGJ1dCBhbHNvIHNvbWUg
b2YgdGhlbSBiZW5lZml0IHRvIGFsbCBkcml2ZXJzLCBhbmQNCnNvbWUgY2FuIGJlIHVzZWZ1bCBm
b3Igb3RoZXIgZHJpdmVycyB0aGF0IHdhbnQgdG8gaW1wbGVtZW50IEFGX1hEUC4NCg0KVGhlIHBl
cmZvcm1hbmNlIHRlc3Rpbmcgd2FzIHBlcmZvcm1lZCBvbiBhIG1hY2hpbmUgd2l0aCB0aGUgZm9s
bG93aW5nDQpjb25maWd1cmF0aW9uOg0KDQotIDI0IGNvcmVzIG9mIEludGVsIFhlb24gRTUtMjYy
MCB2MyBAIDIuNDAgR0h6DQotIE1lbGxhbm94IENvbm5lY3RYLTUgRXggd2l0aCAxMDAgR2JpdC9z
IGxpbmsNCg0KVGhlIHJlc3VsdHMgd2l0aCByZXRwb2xpbmUgZGlzYWJsZWQsIHNpbmdsZSBzdHJl
YW06DQoNCnR4b25seTogMzMuMyBNcHBzICgyMS41IE1wcHMgd2l0aCBxdWV1ZSBhbmQgYXBwIHBp
bm5lZCB0byB0aGUgc2FtZSBDUFUpDQpyeGRyb3A6IDEyLjIgTXBwcw0KbDJmd2Q6IDkuNCBNcHBz
DQoNClRoZSByZXN1bHRzIHdpdGggcmV0cG9saW5lIGVuYWJsZWQsIHNpbmdsZSBzdHJlYW06DQoN
CnR4b25seTogMjEuMyBNcHBzICgxNC4xIE1wcHMgd2l0aCBxdWV1ZSBhbmQgYXBwIHBpbm5lZCB0
byB0aGUgc2FtZSBDUFUpDQpyeGRyb3A6IDkuOSBNcHBzDQpsMmZ3ZDogNi44IE1wcHMNCg0KdjIg
Y2hhbmdlczoNCg0KQWRkZWQgcGF0Y2hlcyBmb3IgbWx4NWUgYW5kIGFkZHJlc3NlZCB0aGUgY29t
bWVudHMgZm9yIHYxLiBSZWJhc2VkIGZvcg0KYnBmLW5leHQuDQoNCnYzIGNoYW5nZXM6DQoNClJl
YmFzZWQgZm9yIHRoZSBuZXdlciBicGYtbmV4dCwgcmVzb2x2ZWQgY29uZmxpY3RzIGluIGxpYmJw
Zi4gQWRkcmVzc2VkDQpCasO2cm4ncyBjb21tZW50cyBmb3IgY29kaW5nIHN0eWxlLiBGaXhlZCBh
IGJ1ZyBpbiBlcnJvciBoYW5kbGluZyBmbG93IGluDQptbHg1ZV9vcGVuX3hzay4NCg0KTWF4aW0g
TWlraXR5YW5za2l5ICgxNik6DQogIHhzazogQWRkIEFQSSB0byBjaGVjayBmb3IgYXZhaWxhYmxl
IGVudHJpZXMgaW4gRlENCiAgeHNrOiBBZGQgZ2V0c29ja29wdCBYRFBfT1BUSU9OUw0KICBsaWJi
cGY6IFN1cHBvcnQgZ2V0c29ja29wdCBYRFBfT1BUSU9OUw0KICB4c2s6IEV4dGVuZCBjaGFubmVs
cyB0byBzdXBwb3J0IGNvbWJpbmVkIFhTSy9ub24tWFNLIHRyYWZmaWMNCiAgeHNrOiBDaGFuZ2Ug
dGhlIGRlZmF1bHQgZnJhbWUgc2l6ZSB0byA0MDk2IGFuZCBhbGxvdyBjb250cm9sbGluZyBpdA0K
ICB4c2s6IFJldHVybiB0aGUgd2hvbGUgeGRwX2Rlc2MgZnJvbSB4c2tfdW1lbV9jb25zdW1lX3R4
DQogIG5ldC9tbHg1ZTogUmVwbGFjZSBkZXByZWNhdGVkIFBDSV9ETUFfVE9ERVZJQ0UNCiAgbmV0
L21seDVlOiBDYWxjdWxhdGUgbGluZWFyIFJYIGZyYWcgc2l6ZSBjb25zaWRlcmluZyBYU0sNCiAg
bmV0L21seDVlOiBBbGxvdyBJQ08gU1EgdG8gYmUgdXNlZCBieSBtdWx0aXBsZSBSUXMNCiAgbmV0
L21seDVlOiBSZWZhY3RvciBzdHJ1Y3QgbWx4NWVfeGRwX2luZm8NCiAgbmV0L21seDVlOiBTaGFy
ZSB0aGUgWERQIFNRIGZvciBYRFBfVFggYmV0d2VlbiBSUXMNCiAgbmV0L21seDVlOiBYRFBfVFgg
ZnJvbSBVTUVNIHN1cHBvcnQNCiAgbmV0L21seDVlOiBDb25zaWRlciBYU0sgaW4gWERQIE1UVSBs
aW1pdCBjYWxjdWxhdGlvbg0KICBuZXQvbWx4NWU6IEVuY2Fwc3VsYXRlIG9wZW4vY2xvc2UgcXVl
dWVzIGludG8gYSBmdW5jdGlvbg0KICBuZXQvbWx4NWU6IE1vdmUgcXVldWUgcGFyYW0gc3RydWN0
cyB0byBlbi9wYXJhbXMuaA0KICBuZXQvbWx4NWU6IEFkZCBYU0sgc3VwcG9ydA0KDQogZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jICAgIHwgIDEyICstDQogZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfeHNrLmMgIHwgIDE1ICstDQogLi4uL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvTWFrZWZpbGUgIHwgICAyICstDQogZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuLmggIHwgMTQ3ICsrKy0NCiAuLi4v
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3BhcmFtcy5jICAgfCAxMDggKystDQogLi4u
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi9wYXJhbXMuaCAgIHwgIDg3ICsrLQ0KIC4u
Li9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hkcC5jICB8IDIzMSArKysrLS0N
CiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuaCAgfCAgMzYgKy0N
CiAuLi4vbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9NYWtlZmlsZSAgICAgICAgfCAgIDEgKw0K
IC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL3J4LmMgICB8IDE5MiArKysr
Kw0KIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL3J4LmggICB8ICAyNyAr
DQogLi4uL21lbGxhbm94L21seDUvY29yZS9lbi94c2svc2V0dXAuYyAgICAgICAgIHwgMjIzICsr
KysrKw0KIC4uLi9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL3NldHVwLmggICAgICAgICB8ICAy
NSArDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svdHguYyAgIHwgMTA4
ICsrKw0KIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL3R4LmggICB8ICAx
NSArDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svdW1lbS5jIHwgMjUy
ICsrKysrKysNCiAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay91bWVtLmgg
fCAgMzQgKw0KIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5jICB8
ICAyMSArLQ0KIC4uLi9tZWxsYW5veC9tbHg1L2NvcmUvZW5fZnNfZXRodG9vbC5jICAgICAgICB8
ICA0NCArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYyB8
IDY4MCArKysrKysrKysrKy0tLS0tLS0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl9yZXAuYyAgfCAgMTIgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl9yeC5jICAgfCAxMDQgKystDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9zdGF0cy5jICAgIHwgMTE1ICsrLQ0KIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW5fc3RhdHMuaCAgICB8ICAzMCArDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fdHhyeC5jIHwgIDQyICstDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9pcG9pYi9pcG9pYi5jIHwgIDE0ICstDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL3dxLmggIHwgICA1IC0NCiBpbmNsdWRlL25ldC94ZHBfc29jay5oICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgMjcgKy0NCiBpbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmggICAg
ICAgICAgICAgICAgICAgfCAgMTkgKw0KIG5ldC94ZHAveHNrLmMgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICA0MSArLQ0KIG5ldC94ZHAveHNrX3F1ZXVlLmggICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAxNCArDQogc2FtcGxlcy9icGYveGRwc29ja191c2VyLmMgICAgICAg
ICAgICAgICAgICAgIHwgIDUyICstDQogdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5o
ICAgICAgICAgICAgIHwgIDE5ICsNCiB0b29scy9saWIvYnBmL3hzay5jICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAxMzEgKysrLQ0KIHRvb2xzL2xpYi9icGYveHNrLmggICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgNiArLQ0KIDM1IGZpbGVzIGNoYW5nZWQsIDIzODkgaW5zZXJ0aW9u
cygrKSwgNTAyIGRlbGV0aW9ucygtKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL01ha2VmaWxlDQogY3JlYXRlIG1vZGUg
MTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svcngu
Yw0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW4veHNrL3J4LmgNCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9zZXR1cC5jDQogY3JlYXRlIG1vZGUgMTAwNjQ0
IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svc2V0dXAuaA0K
IGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW4veHNrL3R4LmMNCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay90eC5oDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svdW1lbS5jDQogY3JlYXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94
c2svdW1lbS5oDQoNCi0tIA0KMi4xOS4xDQoNCg==
