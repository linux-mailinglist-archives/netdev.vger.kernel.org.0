Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7C1D79B8
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 17:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733173AbfJOP0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 11:26:14 -0400
Received: from mail-eopbgr810083.outbound.protection.outlook.com ([40.107.81.83]:42688
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726523AbfJOP0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 11:26:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cV+tz9pJut2Xlfwncftdox1SKvguhokGFgII9eU0mnLdP3kusP21l486wTN7hi5RLuyuEJAJ9gc2s1wWFnr50tQl3hJ33BctSfutjsw6AwqC8OPoDYt7mCfhbh8DpA6fpiWp/7DwSa/wezmihhhs4Ae7LGRNJELORqYfDeXOaok324rCdVYQ+I31lI3nS7XSP26brgE4Y2pLwAh104ueFCGeqK5Rqqr2Afi14QGQ0lLOM7o9PiC5RWSTAxGyVNsHnXx5JITwi/hZui8jVIwNqRiF4lNMRv/lBEaaPnfMGmnQl0jMSdZFRBbpw7gD0ro67SqUf49vhxWmyam03Msubg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akHMhuCi6HGUTwIUIgkijvhWD3Mm7o/bkZRXdLMuzfI=;
 b=ZU8oCOKZS9OznRlf911MTDTn1x1hqvmPbskAp3X9Z9BPi3s9bJQdUWYs6BZw7/1Gj3BkZCjYjZmyPTpDzH38CCimjPxE2fOi3eVyG1CT+m+B5upeBFNFb6NQ92QrZep3uxJb90a09PHyJl/zTiCrxlrtsM0yy6vy1jEJkqEAfo322JKRokXKIpcy8ZKbpd6IFivPmcAsigOJe4Hht0ULpT4qIw6TrFevIzduFVaoLDL6ITqr0HDFp4E0ryHvV4RYaUYcL9mbb+MY0t7sRIvoeOYWZCH3+HaMAFzFze4u0BHMmCZx5q/CVXr9T4ku+rSBRoPr/UsXYIJwJCalC7nDFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akHMhuCi6HGUTwIUIgkijvhWD3Mm7o/bkZRXdLMuzfI=;
 b=hbtts6DFp5SxQ2agCyDuCyrwzwIsQdEzIY02ZNP573tZrXhpTMLNG5ZfVDxzaz8pgwlitAQFwO4A3kD/YNBEyFaw9J24nV9OJdd6JoLOy31u5e7r9FWRP0DTJ0/0aspAZQARTw5hbLa6ddrjjHqvRcHTAIe0k68O8Hc/xNwsSJg=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3787.namprd12.prod.outlook.com (10.255.173.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Tue, 15 Oct 2019 15:26:07 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 15:26:07 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     James Morse <james.morse@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Dave S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH net 1/2] amd-xgbe: Avoid sleeping in flush_workqueue()
 while holding a spinlock
Thread-Topic: [RFC PATCH net 1/2] amd-xgbe: Avoid sleeping in
 flush_workqueue() while holding a spinlock
Thread-Index: AQHVg19aSc3ZV3n0Vk+Z2Y4Pg3NcCqdb0voA
Date:   Tue, 15 Oct 2019 15:26:07 +0000
Message-ID: <934557d0-0c5a-76d5-e8f6-a8683210b0ed@amd.com>
References: <20191015134911.231121-1-james.morse@arm.com>
 <20191015134911.231121-2-james.morse@arm.com>
In-Reply-To: <20191015134911.231121-2-james.morse@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR2101CA0009.namprd21.prod.outlook.com
 (2603:10b6:805:106::19) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: beb134f3-a8d6-4f7f-eb14-08d751840018
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3787:
x-microsoft-antispam-prvs: <DM6PR12MB37870B32053CF1ABE0F9FE54EC930@DM6PR12MB3787.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(189003)(199004)(6512007)(256004)(3846002)(36756003)(2501003)(8676002)(7736002)(110136005)(305945005)(81166006)(81156014)(71200400001)(52116002)(66556008)(76176011)(6116002)(71190400001)(99286004)(2906002)(66946007)(64756008)(66446008)(66476007)(8936002)(14444005)(478600001)(26005)(186003)(316002)(229853002)(14454004)(102836004)(53546011)(6506007)(386003)(6246003)(66066001)(5660300002)(446003)(476003)(31696002)(4326008)(2616005)(11346002)(25786009)(486006)(6486002)(86362001)(31686004)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3787;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IfkuXwxM0iJQzaCLburvUOrX/0B1aUmJJ/5ApgnKcowi7fh0mX1Z8W0eL9u+TeWrGu2Hn5tS6JhQLv3qu/Gt+jst1dz/0QRdh1cqPr8dmn7UegeHCuVrIUTR+qoexqdWYUXH1hFjNiFYCU5wkxJUFu5zsHBeq96CF9osPEqo+cBLSOlXWgtTdsbn4kEkgw7ej695LFrgJtUTM4Ri/cAAqWOOtsDIEoN/FEnuIOg75/vBeglzoI99HWwWPKsKw4n3b5wQlK+6KIQfpANJ8Aa4K4XQSSH5qm186cEgK8I3UfpYTy6X1Z6xVk4hEj5Esca7yEj7eNIHXdWnlED61WVGhUBFLVK96XRRjDjvpl/fraCx6NNIbFy44/CGsfno3ggAmHQ2SVOyvp7OdFajE6WFweXmFOv3fX8mqGlN7HuNK74=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <392CD160F7863B4DBA22D2AECAFB26E7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beb134f3-a8d6-4f7f-eb14-08d751840018
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 15:26:07.7489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FGFYrujL5WGJt6xaaZze/J2AXNMBEOfczeRrDGMjHNIJJ8dCS1AMWpOyvpZlFbydbk8xxsWEEAQFEUHg0QeEEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3787
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTUvMTkgODo0OSBBTSwgSmFtZXMgTW9yc2Ugd3JvdGU6DQo+IHhnYmVfcG93ZXJkb3du
KCkgdGFrZXMgYW4gaXJxc2F2ZSBzcGlubG9jaywgdGhlbiBjYWxscyBmbHVzaF93b3JrcXVldWUo
KQ0KPiB3aGljaCB0YWtlcyBhIG11dGV4LiBERUJVR19BVE9NSUNfU0xFRVAgaXNuJ3QgaGFwcHkg
YWJvdXQgdGhpczoNCj4gfCBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGludmFs
aWQgY29udGV4dCBhdCBbLi4uXSBtdXRleC5jOjI4MQ0KPiB8IGluX2F0b21pYygpOiAxLCBpcnFz
X2Rpc2FibGVkKCk6IDEyOCwgbm9uX2Jsb2NrOiAwLCBwaWQ6IDI3MzMsIG5hbWU6IGJhc2gNCj4g
fCBDUFU6IDQgUElEOiAyNzMzIENvbW06IGJhc2ggVGFpbnRlZDogRyAgICAgICAgVyAgICAgICAg
IDUuNC4wLXJjMyAjMTEzDQo+IHwgSGFyZHdhcmUgbmFtZTogQU1EIFNlYXR0bGUgKFJldi5CMCkg
RGV2ZWxvcG1lbnQgQm9hcmQgKE92ZXJkcml2ZSkgKERUKQ0KPiB8IENhbGwgdHJhY2U6DQo+IHwg
IHNob3dfc3RhY2srMHgyNC8weDMwDQo+IHwgIGR1bXBfc3RhY2srMHhiMC8weGY4DQo+IHwgIF9f
X21pZ2h0X3NsZWVwKzB4MTI0LzB4MTQ4DQo+IHwgIF9fbWlnaHRfc2xlZXArMHg1NC8weDkwDQo+
IHwgIG11dGV4X2xvY2srMHgyYy8weDgwDQo+IHwgIGZsdXNoX3dvcmtxdWV1ZSsweDg0LzB4NDIw
DQo+IHwgIHhnYmVfcG93ZXJkb3duKzB4NmMvMHgxMDgNCj4gfCAgeGdiZV9wbGF0Zm9ybV9zdXNw
ZW5kKzB4MzQvMHg4MA0KPiB8ICBwbV9nZW5lcmljX2ZyZWV6ZSsweDNjLzB4NTgNCj4gfCAgYWNw
aV9zdWJzeXNfZnJlZXplKzB4MmMvMHgzOA0KPiB8ICBkcG1fcnVuX2NhbGxiYWNrKzB4M2MvMHgx
ZTgNCj4gfCAgX19kZXZpY2Vfc3VzcGVuZCsweDEzMC8weDQ2OA0KPiB8ICBkcG1fc3VzcGVuZCsw
eDExNC8weDM4OA0KPiB8ICBoaWJlcm5hdGlvbl9zbmFwc2hvdCsweGU4LzB4Mzc4DQo+IHwgIGhp
YmVybmF0ZSsweDE4Yy8weDJmOA0KPiANCj4gRHJvcCB0aGUgbG9jayBmb3IgdGhlIGR1cmF0aW9u
IG9mIHhnYmVfcG93ZXJkb3duKCkuIFdlIGhhdmUgYWxyZWFkeQ0KPiBzdG9wZWVkIHRoZSB0aW1l
cnMsIHNvIHNlcnZpY2Vfd29yayBjYW4ndCBiZSByZS1xdWV1ZWQuIE1vdmUgdGhlDQo+IHBkYXRh
LT5wb3dlcl9kb3duIGZsYWcgZWFybGllciBzbyB0aGF0IGl0IGNhbiBiZSB1c2VkIGJ5IHRoZSBp
bnRlcnJ1cHQNCj4gaGFuZGxlciB0byBrbm93IG5vdCB0byByZS1xdWV1ZSB0aGUgdHhfdHN0YW1w
X3dvcmsuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKYW1lcyBNb3JzZSA8amFtZXMubW9yc2VAYXJt
LmNvbT4NCj4gDQo+IC0tLQ0KPiBSRkMgYXMgSSdtIG5vdCBmYW1pbGlhciB3aXRoIHRoaXMgZHJp
dmVyLiBJJ20gaGFwcHkgdG8gdGVzdCBhIGJldHRlciBmaXghDQo+IC0tLQ0KPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYW1kL3hnYmUveGdiZS1kcnYuYyB8IDIyICsrKysrKysrKysrKysrKysrKy0t
LS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtZC94Z2JlL3hnYmUtZHJ2
LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hbWQveGdiZS94Z2JlLWRydi5jDQo+IGluZGV4IDk4
ZjhmMjAzMzE1NC4uYmZiYTdlZmZjZjlmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9hbWQveGdiZS94Z2JlLWRydi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Ft
ZC94Z2JlL3hnYmUtZHJ2LmMNCj4gQEAgLTQ4MCw2ICs0ODAsOCBAQCBzdGF0aWMgdm9pZCB4Z2Jl
X2lzcl90YXNrKHVuc2lnbmVkIGxvbmcgZGF0YSkNCj4gIAlzdHJ1Y3QgeGdiZV9jaGFubmVsICpj
aGFubmVsOw0KPiAgCXVuc2lnbmVkIGludCBkbWFfaXNyLCBkbWFfY2hfaXNyOw0KPiAgCXVuc2ln
bmVkIGludCBtYWNfaXNyLCBtYWNfdHNzciwgbWFjX21kaW9pc3I7DQo+ICsJdW5zaWduZWQgbG9u
ZyBmbGFnczsNCj4gKwlib29sIHBvd2VyX2Rvd247DQo+ICAJdW5zaWduZWQgaW50IGk7DQo+ICAN
Cj4gIAkvKiBUaGUgRE1BIGludGVycnVwdCBzdGF0dXMgcmVnaXN0ZXIgYWxzbyByZXBvcnRzIE1B
QyBhbmQgTVRMDQo+IEBAIC01NTgsOCArNTYwLDE0IEBAIHN0YXRpYyB2b2lkIHhnYmVfaXNyX3Rh
c2sodW5zaWduZWQgbG9uZyBkYXRhKQ0KPiAgCQkJCS8qIFJlYWQgVHggVGltZXN0YW1wIHRvIGNs
ZWFyIGludGVycnVwdCAqLw0KPiAgCQkJCXBkYXRhLT50eF90c3RhbXAgPQ0KPiAgCQkJCQlod19p
Zi0+Z2V0X3R4X3RzdGFtcChwZGF0YSk7DQo+IC0JCQkJcXVldWVfd29yayhwZGF0YS0+ZGV2X3dv
cmtxdWV1ZSwNCj4gLQkJCQkJICAgJnBkYXRhLT50eF90c3RhbXBfd29yayk7DQo+ICsNCj4gKwkJ
CQlzcGluX2xvY2tfaXJxc2F2ZSgmcGRhdGEtPmxvY2ssIGZsYWdzKTsNCj4gKwkJCQlwb3dlcl9k
b3duID0gcGRhdGEtPnBvd2VyX2Rvd247DQo+ICsJCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
cGRhdGEtPmxvY2ssIGZsYWdzKTsNCj4gKw0KPiArCQkJCWlmICghcG93ZXJfZG93bikNCj4gKwkJ
CQkJcXVldWVfd29yayhwZGF0YS0+ZGV2X3dvcmtxdWV1ZSwNCj4gKwkJCQkJCSAgICZwZGF0YS0+
dHhfdHN0YW1wX3dvcmspOw0KDQpIbW0sIEkgdGhpbmsgdGhpcyBjb3VsZCByYWNlLiAgWW91IHBy
b2JhYmx5IHdhbnQgdG8gcHJvdGVjdCBxdWV1ZV93b3JrKCkNCndpdGggdGhlIHNwaW4gbG9jaywg
dG9vLCBpbiB3aGljaCBjYXNlIHlvdSB3b24ndCBuZWVkIHRoZSBwb3dlcl9kb3duIHZhci4NCg0K
PiAgCQkJfQ0KPiAgCQl9DQo+ICANCj4gQEAgLTEyNTYsMTYgKzEyNjQsMjIgQEAgaW50IHhnYmVf
cG93ZXJkb3duKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsIHVuc2lnbmVkIGludCBjYWxsZXIp
DQo+ICANCj4gIAluZXRpZl90eF9zdG9wX2FsbF9xdWV1ZXMobmV0ZGV2KTsNCj4gIA0KPiArCS8q
IFN0b3Agc2VydmljZV93b3JrIGJlaW5nIHJlLXF1ZXVlZCBieSB0aGUgc2VydmljZV90aW1lciAq
Lw0KPiAgCXhnYmVfc3RvcF90aW1lcnMocGRhdGEpOw0KPiArDQo+ICsJLyogU3RvcCB0eF90c3Rh
bXBfd29yayBiZWluZyByZS1xdWV1ZWQgYWZ0ZXIgZmx1c2hfd29ya3F1ZXVlKCkgKi8NCj4gKwlw
ZGF0YS0+cG93ZXJfZG93biA9IDE7DQoNCllvdSBjYW4gcHJvYmFibHkgbW92ZSB0aGlzIHVwIGV2
ZW4gZnVydGhlciwganVzdCBhZnRlciBncmFiYmluZyB0aGUgbG9jay4NCg0KPiArDQo+ICsJLyog
ZHJvcCB0aGUgbG9jayB0byBhbGxvdyBmbHVzaF93b3JrcXVldWUoKSB0byBzbGVlcC4gKi8NCj4g
KwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwZGF0YS0+bG9jaywgZmxhZ3MpOw0KPiAgCWZsdXNo
X3dvcmtxdWV1ZShwZGF0YS0+ZGV2X3dvcmtxdWV1ZSk7DQoNClJhdGhlciB0aGFuIGRyb3BwaW5n
IGFuZCByZWFjcXVpcmluZyB0aGUgbG9jaywgSSB0aGluayB5b3UgY2FuIGdldCBhd2F5DQp3aXRo
IG1vdmluZyB0aGlzIHRvIGFmdGVyIGRyb3BwaW5nIHRoZSBsb2NrIGJlbG93Lg0KDQpUaGFua3Ms
DQpUb20NCg0KPiArCXNwaW5fbG9ja19pcnFzYXZlKCZwZGF0YS0+bG9jaywgZmxhZ3MpOw0KPiAg
DQo+ICAJaHdfaWYtPnBvd2VyZG93bl90eChwZGF0YSk7DQo+ICAJaHdfaWYtPnBvd2VyZG93bl9y
eChwZGF0YSk7DQo+ICANCj4gIAl4Z2JlX25hcGlfZGlzYWJsZShwZGF0YSwgMCk7DQo+ICANCj4g
LQlwZGF0YS0+cG93ZXJfZG93biA9IDE7DQo+IC0NCj4gIAlzcGluX3VubG9ja19pcnFyZXN0b3Jl
KCZwZGF0YS0+bG9jaywgZmxhZ3MpOw0KPiAgDQo+ICAJREJHUFIoIjwtLXhnYmVfcG93ZXJkb3du
XG4iKTsNCj4gDQo=
