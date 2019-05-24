Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2608C2A11D
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404358AbfEXWYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:24:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52802 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404176AbfEXWYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:24:17 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4OMJ7KW001457;
        Fri, 24 May 2019 15:23:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=trGEL6PegSo5bjvj+/vnOEvDK+FTDivnj/6BqGhZyf4=;
 b=U5MHd2KTu1x/NCYs9aPibNLOBUa2/cPBbHjM+kEfZAeNus1Cf9P9baaky3z2tgSoMGe8
 kehKhjmziZB0jVY4S/JyBS6g5p7iIiYmkhy+MVhAEN9GHDB4miVVwJNXs2z1/o+iFK8Q
 AcgYRHKwG/KyixvglvdXe+XmldvfUt4kZ6c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2spmbjh3cp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 May 2019 15:23:52 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 May 2019 15:23:47 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 24 May 2019 15:23:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trGEL6PegSo5bjvj+/vnOEvDK+FTDivnj/6BqGhZyf4=;
 b=ZVHDlzzGZEYLR2TO9KljnOd5NzeT8pVLYYFIBT9hbcKp9aKN+iDwggPZnXQcQ2E8WlfgfSVVETnx/dx4m5ioJrhb1xo445MtxwDBghxaM40DqJQpi7km0HsnkLxplKguUDyWsVIFiRBfTeHHmFxDmbekdYH6HQD/cnCOhoXpBWM=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2839.namprd15.prod.outlook.com (20.178.206.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Fri, 24 May 2019 22:23:46 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Fri, 24 May 2019
 22:23:46 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>, Kernel Team <Kernel-team@fb.com>,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: implement bpf_send_signal() helper
Thread-Topic: [PATCH bpf-next v5 1/3] bpf: implement bpf_send_signal() helper
Thread-Index: AQHVEbFAdcZbQBZzEE6RKT6takmR46Z6zu2AgAAFv4CAAAahAA==
Date:   Fri, 24 May 2019 22:23:45 +0000
Message-ID: <816d5531-2a4c-3f73-040b-0c46d3961980@fb.com>
References: <20190523214745.854300-1-yhs@fb.com>
 <20190523214745.854355-1-yhs@fb.com>
 <54257f88-b088-2330-ba49-a78ce06d08bf@iogearbox.net>
 <2f7fe79b-0e3f-2be3-aede-bd8eb369c91e@iogearbox.net>
In-Reply-To: <2f7fe79b-0e3f-2be3-aede-bd8eb369c91e@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:102:1::22) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:f644]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc8d926d-5dfe-4b26-0ae2-08d6e0967c72
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600147)(711020)(4605104)(1401326)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2839;
x-ms-traffictypediagnostic: BYAPR15MB2839:
x-microsoft-antispam-prvs: <BYAPR15MB2839B70CDC35FDE79569D5FBD3020@BYAPR15MB2839.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(6246003)(476003)(2906002)(6436002)(7736002)(8676002)(53936002)(81166006)(81156014)(99286004)(31686004)(4326008)(14444005)(256004)(229853002)(186003)(71190400001)(71200400001)(316002)(2201001)(6116002)(31696002)(86362001)(110136005)(54906003)(52116002)(8936002)(102836004)(2501003)(446003)(478600001)(486006)(46003)(5660300002)(2616005)(14454004)(11346002)(76176011)(305945005)(73956011)(6486002)(36756003)(6512007)(6506007)(25786009)(53546011)(386003)(68736007)(66946007)(64756008)(66446008)(66476007)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2839;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yer4DyoKYzs7igu1qA+OFDk3Z2wS6dGdWn/v9VblMjNAm0E+BygmliFA6EngSa7eGfctAxozGVnP+xgZDzNa/hC7pEA2GBnIYtTIkyskKBOGKeIim1mnB53X8IIHBZ38EZMnAWMwvjL0pXx/bitkf051D84Sjx8w+v5PpKoYZkl+Fe4Yrhyb/PRFznNFpwPUDT5FVyJ56v0g8zbnmMG3FTVjfLA7IGzGPlAO/08fcKS2kueQNHvxDQQEKPrTDFdyrdjM7kcAh109N5mJBzfsqMbPJaMbYL3TBwalhYvaaXk+LFRd6FLmTmCicxaqqH+SlR+O1t4WqtIutQZwr1lB3ASuLu+7n9sg2rOoEnHGdngeVPvhImriWgFZIC4AzAHwxd3go/3DYwnHOvZKrPgVoom9+wnjJdGyYNQOzHscZjg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <46D3B18A63409B46A52F149FE11381AA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8d926d-5dfe-4b26-0ae2-08d6e0967c72
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 22:23:45.9857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2839
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905240146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjQvMTkgMjo1OSBQTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPiBPbiAwNS8y
NC8yMDE5IDExOjM5IFBNLCBEYW5pZWwgQm9ya21hbm4gd3JvdGU6DQo+PiBPbiAwNS8yMy8yMDE5
IDExOjQ3IFBNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4+IFRoaXMgcGF0Y2ggdHJpZXMgdG8g
c29sdmUgdGhlIGZvbGxvd2luZyBzcGVjaWZpYyB1c2UgY2FzZS4NCj4+Pg0KPj4+IEN1cnJlbnRs
eSwgYnBmIHByb2dyYW0gY2FuIGFscmVhZHkgY29sbGVjdCBzdGFjayB0cmFjZXMNCj4+PiB0aHJv
dWdoIGtlcm5lbCBmdW5jdGlvbiBnZXRfcGVyZl9jYWxsY2hhaW4oKQ0KPj4+IHdoZW4gY2VydGFp
biBldmVudHMgaGFwcGVucyAoZS5nLiwgY2FjaGUgbWlzcyBjb3VudGVyIG9yDQo+Pj4gY3B1IGNs
b2NrIGNvdW50ZXIgb3ZlcmZsb3dzKS4gQnV0IHN1Y2ggc3RhY2sgdHJhY2VzIGFyZQ0KPj4+IG5v
dCBlbm91Z2ggZm9yIGppdHRlZCBwcm9ncmFtcywgZS5nLiwgaGh2bSAoaml0ZWQgcGhwKS4NCj4+
PiBUbyBnZXQgcmVhbCBzdGFjayB0cmFjZSwgaml0IGVuZ2luZSBpbnRlcm5hbCBkYXRhIHN0cnVj
dHVyZXMNCj4+PiBuZWVkIHRvIGJlIHRyYXZlcnNlZCBpbiBvcmRlciB0byBnZXQgdGhlIHJlYWwg
dXNlciBmdW5jdGlvbnMuDQo+Pj4NCj4+PiBicGYgcHJvZ3JhbSBpdHNlbGYgbWF5IG5vdCBiZSB0
aGUgYmVzdCBwbGFjZSB0byB0cmF2ZXJzZQ0KPj4+IHRoZSBqaXQgZW5naW5lIGFzIHRoZSB0cmF2
ZXJzaW5nIGxvZ2ljIGNvdWxkIGJlIGNvbXBsZXggYW5kDQo+Pj4gaXQgaXMgbm90IGEgc3RhYmxl
IGludGVyZmFjZSBlaXRoZXIuDQo+Pj4NCj4+PiBJbnN0ZWFkLCBoaHZtIGltcGxlbWVudHMgYSBz
aWduYWwgaGFuZGxlciwNCj4+PiBlLmcuIGZvciBTSUdBTEFSTSwgYW5kIGEgc2V0IG9mIHByb2dy
YW0gbG9jYXRpb25zIHdoaWNoDQo+Pj4gaXQgY2FuIGR1bXAgc3RhY2sgdHJhY2VzLiBXaGVuIGl0
IHJlY2VpdmVzIGEgc2lnbmFsLCBpdCB3aWxsDQo+Pj4gZHVtcCB0aGUgc3RhY2sgaW4gbmV4dCBz
dWNoIHByb2dyYW0gbG9jYXRpb24uDQo+Pj4NCj4+PiBTdWNoIGEgbWVjaGFuaXNtIGNhbiBiZSBp
bXBsZW1lbnRlZCBpbiB0aGUgZm9sbG93aW5nIHdheToNCj4+PiAgICAuIGEgcGVyZiByaW5nIGJ1
ZmZlciBpcyBjcmVhdGVkIGJldHdlZW4gYnBmIHByb2dyYW0NCj4+PiAgICAgIGFuZCB0cmFjaW5n
IGFwcC4NCj4+PiAgICAuIG9uY2UgYSBwYXJ0aWN1bGFyIGV2ZW50IGhhcHBlbnMsIGJwZiBwcm9n
cmFtIHdyaXRlcw0KPj4+ICAgICAgdG8gdGhlIHJpbmcgYnVmZmVyIGFuZCB0aGUgdHJhY2luZyBh
cHAgZ2V0cyBub3RpZmllZC4NCj4+PiAgICAuIHRoZSB0cmFjaW5nIGFwcCBzZW5kcyBhIHNpZ25h
bCBTSUdBTEFSTSB0byB0aGUgaGh2bS4NCj4+Pg0KPj4+IEJ1dCB0aGlzIG1ldGhvZCBjb3VsZCBo
YXZlIGxhcmdlIGRlbGF5cyBhbmQgY2F1c2luZyBwcm9maWxpbmcNCj4+PiByZXN1bHRzIHNrZXdl
ZC4NCj4+Pg0KPj4+IFRoaXMgcGF0Y2ggaW1wbGVtZW50cyBicGZfc2VuZF9zaWduYWwoKSBoZWxw
ZXIgdG8gc2VuZA0KPj4+IGEgc2lnbmFsIHRvIGhodm0gaW4gcmVhbCB0aW1lLCByZXN1bHRpbmcg
aW4gaW50ZW5kZWQgc3RhY2sgdHJhY2VzLg0KPj4+DQo+Pj4gQWNrZWQtYnk6IEFuZHJpaSBOYWty
eWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+Pj4gU2lnbmVkLW9mZi1ieTogWW9uZ2hvbmcgU29uZyA8
eWhzQGZiLmNvbT4NCj4+PiAtLS0NCj4+PiAgIGluY2x1ZGUvdWFwaS9saW51eC9icGYuaCB8IDE3
ICsrKysrKysrKy0NCj4+PiAgIGtlcm5lbC90cmFjZS9icGZfdHJhY2UuYyB8IDcyICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+PiAgIDIgZmlsZXMgY2hhbmdlZCwg
ODggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvdWFwaS9saW51eC9icGYuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPj4+IGlu
ZGV4IDYzZTBjZjY2ZjAxYS4uNjhkNDQ3MDUyM2EwIDEwMDY0NA0KPj4+IC0tLSBhL2luY2x1ZGUv
dWFwaS9saW51eC9icGYuaA0KPj4+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPj4+
IEBAIC0yNjcyLDYgKzI2NzIsMjAgQEAgdW5pb24gYnBmX2F0dHIgew0KPj4+ICAgICoJCTAgb24g
c3VjY2Vzcy4NCj4+PiAgICAqDQo+Pj4gICAgKgkJKiotRU5PRU5UKiogaWYgdGhlIGJwZi1sb2Nh
bC1zdG9yYWdlIGNhbm5vdCBiZSBmb3VuZC4NCj4+PiArICoNCj4+PiArICogaW50IGJwZl9zZW5k
X3NpZ25hbCh1MzIgc2lnKQ0KPj4+ICsgKglEZXNjcmlwdGlvbg0KPj4+ICsgKgkJU2VuZCBzaWdu
YWwgKnNpZyogdG8gdGhlIGN1cnJlbnQgdGFzay4NCj4+PiArICoJUmV0dXJuDQo+Pj4gKyAqCQkw
IG9uIHN1Y2Nlc3Mgb3Igc3VjY2Vzc2Z1bGx5IHF1ZXVlZC4NCj4+PiArICoNCj4+PiArICoJCSoq
LUVCVVNZKiogaWYgd29yayBxdWV1ZSB1bmRlciBubWkgaXMgZnVsbC4NCj4+PiArICoNCj4+PiAr
ICoJCSoqLUVJTlZBTCoqIGlmICpzaWcqIGlzIGludmFsaWQuDQo+Pj4gKyAqDQo+Pj4gKyAqCQkq
Ki1FUEVSTSoqIGlmIG5vIHBlcm1pc3Npb24gdG8gc2VuZCB0aGUgKnNpZyouDQo+Pj4gKyAqDQo+
Pj4gKyAqCQkqKi1FQUdBSU4qKiBpZiBicGYgcHJvZ3JhbSBjYW4gdHJ5IGFnYWluLg0KPj4+ICAg
ICovDQo+Pj4gICAjZGVmaW5lIF9fQlBGX0ZVTkNfTUFQUEVSKEZOKQkJXA0KPj4+ICAgCUZOKHVu
c3BlYyksCQkJXA0KPj4+IEBAIC0yNzgyLDcgKzI3OTYsOCBAQCB1bmlvbiBicGZfYXR0ciB7DQo+
Pj4gICAJRk4oc3RydG9sKSwJCQlcDQo+Pj4gICAJRk4oc3RydG91bCksCQkJXA0KPj4+ICAgCUZO
KHNrX3N0b3JhZ2VfZ2V0KSwJCVwNCj4+PiAtCUZOKHNrX3N0b3JhZ2VfZGVsZXRlKSwNCj4+PiAr
CUZOKHNrX3N0b3JhZ2VfZGVsZXRlKSwJCVwNCj4+PiArCUZOKHNlbmRfc2lnbmFsKSwNCj4+PiAg
IA0KPj4+ICAgLyogaW50ZWdlciB2YWx1ZSBpbiAnaW1tJyBmaWVsZCBvZiBCUEZfQ0FMTCBpbnN0
cnVjdGlvbiBzZWxlY3RzIHdoaWNoIGhlbHBlcg0KPj4+ICAgICogZnVuY3Rpb24gZUJQRiBwcm9n
cmFtIGludGVuZHMgdG8gY2FsbA0KPj4+IGRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvYnBmX3Ry
YWNlLmMgYi9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4+PiBpbmRleCBmOTJkNmFkNWUwODAu
LjcwMDI5ZWFmYzcxZiAxMDA2NDQNCj4+PiAtLS0gYS9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMN
Cj4+PiArKysgYi9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4+PiBAQCAtNTY3LDYgKzU2Nyw2
MyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9wcm9iZV9yZWFkX3N0
cl9wcm90byA9IHsNCj4+PiAgIAkuYXJnM190eXBlCT0gQVJHX0FOWVRISU5HLA0KPj4+ICAgfTsN
Cj4+PiAgIA0KPj4+ICtzdHJ1Y3Qgc2VuZF9zaWduYWxfaXJxX3dvcmsgew0KPj4+ICsJc3RydWN0
IGlycV93b3JrIGlycV93b3JrOw0KPj4+ICsJc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrOw0KPj4+
ICsJdTMyIHNpZzsNCj4+PiArfTsNCj4+PiArDQo+Pj4gK3N0YXRpYyBERUZJTkVfUEVSX0NQVShz
dHJ1Y3Qgc2VuZF9zaWduYWxfaXJxX3dvcmssIHNlbmRfc2lnbmFsX3dvcmspOw0KPj4+ICsNCj4+
PiArc3RhdGljIHZvaWQgZG9fYnBmX3NlbmRfc2lnbmFsKHN0cnVjdCBpcnFfd29yayAqZW50cnkp
DQo+Pj4gK3sNCj4+PiArCXN0cnVjdCBzZW5kX3NpZ25hbF9pcnFfd29yayAqd29yazsNCj4+PiAr
DQo+Pj4gKwl3b3JrID0gY29udGFpbmVyX29mKGVudHJ5LCBzdHJ1Y3Qgc2VuZF9zaWduYWxfaXJx
X3dvcmssIGlycV93b3JrKTsNCj4+PiArCWdyb3VwX3NlbmRfc2lnX2luZm8od29yay0+c2lnLCBT
RU5EX1NJR19QUklWLCB3b3JrLT50YXNrLCBQSURUWVBFX1RHSUQpOw0KPj4+ICt9DQo+Pj4gKw0K
Pj4+ICtCUEZfQ0FMTF8xKGJwZl9zZW5kX3NpZ25hbCwgdTMyLCBzaWcpDQo+Pj4gK3sNCj4+PiAr
CXN0cnVjdCBzZW5kX3NpZ25hbF9pcnFfd29yayAqd29yayA9IE5VTEw7DQo+Pj4gKw0KPiANCj4g
T2gsIGFuZCBvbmUgbW9yZSB0aGluZzoNCj4gDQo+IAlpZiAoIXZhbGlkX3NpZ25hbChzaWcpKQ0K
PiAJCXJldHVybiAtRUlOVkFMOw0KPiANCj4gT3RoZXJ3aXNlIHdoZW4gZGVmZXJyaW5nIHRoZSB3
b3JrLCB5b3UgZG9uJ3QgaGF2ZSBhbnkgc3VjaCBmZWVkYmFjay4NCg0KR29vZCBhZHZpY2UhIERv
IHlvdSB3YW50IG1lIHNlbmQgYSBmb2xsb3d1cCBwYXRjaCBvcg0KcmVzZW5kIHRoZSB3aG9sZSBz
ZXJpZXM/DQoNCj4gDQo+Pj4gKwkvKiBTaW1pbGFyIHRvIGJwZl9wcm9iZV93cml0ZV91c2VyLCB0
YXNrIG5lZWRzIHRvIGJlDQo+Pj4gKwkgKiBpbiBhIHNvdW5kIGNvbmRpdGlvbiBhbmQga2VybmVs
IG1lbW9yeSBhY2Nlc3MgYmUNCj4+PiArCSAqIHBlcm1pdHRlZCBpbiBvcmRlciB0byBzZW5kIHNp
Z25hbCB0byB0aGUgY3VycmVudA0KPj4+ICsJICogdGFzay4NCj4+PiArCSAqLw0KPj4+ICsJaWYg
KHVubGlrZWx5KGN1cnJlbnQtPmZsYWdzICYgKFBGX0tUSFJFQUQgfCBQRl9FWElUSU5HKSkpDQo+
Pj4gKwkJcmV0dXJuIC1FUEVSTTsNCj4+PiArCWlmICh1bmxpa2VseSh1YWNjZXNzX2tlcm5lbCgp
KSkNCj4+PiArCQlyZXR1cm4gLUVQRVJNOw0KPj4+ICsJaWYgKHVubGlrZWx5KCFubWlfdWFjY2Vz
c19va2F5KCkpKQ0KPj4+ICsJCXJldHVybiAtRVBFUk07DQo+Pj4gKw0KPj4+ICsJaWYgKGluX25t
aSgpKSB7DQo+Pj4gKwkJd29yayA9IHRoaXNfY3B1X3B0cigmc2VuZF9zaWduYWxfd29yayk7DQo+
Pj4gKwkJaWYgKHdvcmstPmlycV93b3JrLmZsYWdzICYgSVJRX1dPUktfQlVTWSkNCj4+DQo+PiBH
aXZlbiBoZXJlIGFuZCBpbiBzdGFja21hcCBhcmUgdGhlIG9ubHkgdHdvIHVzZXJzIG91dHNpZGUg
b2Yga2VybmVsL2lycV93b3JrLmMsDQo+PiBpdCBtYXkgcHJvYmFibHkgYmUgZ29vZCB0byBhZGQg
YSBzbWFsbCBoZWxwZXIgdG8gaW5jbHVkZS9saW51eC9pcnFfd29yay5oIGFuZA0KPj4gdXNlIGl0
IGZvciBib3RoLg0KPj4NCj4+IFBlcmhhcHMgc29tZXRoaW5nIGxpa2UgLi4uDQo+Pg0KPj4gc3Rh
dGljIGlubGluZSBib29sIGlycV93b3JrX2J1c3koc3RydWN0IGlycV93b3JrICp3b3JrKQ0KPj4g
ew0KPj4gCXJldHVybiBSRUFEX09OQ0Uod29yay0+ZmxhZ3MpICYgSVJRX1dPUktfQlVTWTsNCj4+
IH0NCj4+DQo+Pj4gKwkJCXJldHVybiAtRUJVU1k7DQo+Pj4gKw0KPj4+ICsJCS8qIEFkZCB0aGUg
Y3VycmVudCB0YXNrLCB3aGljaCBpcyB0aGUgdGFyZ2V0IG9mIHNlbmRpbmcgc2lnbmFsLA0KPj4+
ICsJCSAqIHRvIHRoZSBpcnFfd29yay4gVGhlIGN1cnJlbnQgdGFzayBtYXkgY2hhbmdlIHdoZW4g
cXVldWVkDQo+Pj4gKwkJICogaXJxIHdvcmtzIGdldCBleGVjdXRlZC4NCj4+PiArCQkgKi8NCj4+
PiArCQl3b3JrLT50YXNrID0gY3VycmVudDsNCj4+PiArCQl3b3JrLT5zaWcgPSBzaWc7DQo+Pj4g
KwkJaXJxX3dvcmtfcXVldWUoJndvcmstPmlycV93b3JrKTsNCj4+PiArCQlyZXR1cm4gMDsNCj4+
PiArCX0NCj4+PiArDQo+Pj4gKwlyZXR1cm4gZ3JvdXBfc2VuZF9zaWdfaW5mbyhzaWcsIFNFTkRf
U0lHX1BSSVYsIGN1cnJlbnQsIFBJRFRZUEVfVEdJRCk7DQo+Pj4gK30NCj4+PiArDQo+Pj4gK3N0
YXRpYyBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX3NlbmRfc2lnbmFsX3Byb3RvID0g
ew0KPj4+ICsJLmZ1bmMJCT0gYnBmX3NlbmRfc2lnbmFsLA0KPj4+ICsJLmdwbF9vbmx5CT0gZmFs
c2UsDQo+Pj4gKwkucmV0X3R5cGUJPSBSRVRfSU5URUdFUiwNCj4+PiArCS5hcmcxX3R5cGUJPSBB
UkdfQU5ZVEhJTkcsDQo+Pj4gK307DQo+Pj4gKw0KPj4+ICAgc3RhdGljIGNvbnN0IHN0cnVjdCBi
cGZfZnVuY19wcm90byAqDQo+Pj4gICB0cmFjaW5nX2Z1bmNfcHJvdG8oZW51bSBicGZfZnVuY19p
ZCBmdW5jX2lkLCBjb25zdCBzdHJ1Y3QgYnBmX3Byb2cgKnByb2cpDQo+Pj4gICB7DQo+Pj4gQEAg
LTYxNyw2ICs2NzQsOCBAQCB0cmFjaW5nX2Z1bmNfcHJvdG8oZW51bSBicGZfZnVuY19pZCBmdW5j
X2lkLCBjb25zdCBzdHJ1Y3QgYnBmX3Byb2cgKnByb2cpDQo+Pj4gICAJY2FzZSBCUEZfRlVOQ19n
ZXRfY3VycmVudF9jZ3JvdXBfaWQ6DQo+Pj4gICAJCXJldHVybiAmYnBmX2dldF9jdXJyZW50X2Nn
cm91cF9pZF9wcm90bzsNCj4+PiAgICNlbmRpZg0KPj4+ICsJY2FzZSBCUEZfRlVOQ19zZW5kX3Np
Z25hbDoNCj4+PiArCQlyZXR1cm4gJmJwZl9zZW5kX3NpZ25hbF9wcm90bzsNCj4+PiAgIAlkZWZh
dWx0Og0KPj4+ICAgCQlyZXR1cm4gTlVMTDsNCj4+PiAgIAl9DQo+Pj4gQEAgLTEzNDMsNSArMTQw
MiwxOCBAQCBzdGF0aWMgaW50IF9faW5pdCBicGZfZXZlbnRfaW5pdCh2b2lkKQ0KPj4+ICAgCXJl
dHVybiAwOw0KPj4+ICAgfQ0KPj4+ICAgDQo+Pj4gK3N0YXRpYyBpbnQgX19pbml0IHNlbmRfc2ln
bmFsX2lycV93b3JrX2luaXQodm9pZCkNCj4+PiArew0KPj4+ICsJaW50IGNwdTsNCj4+PiArCXN0
cnVjdCBzZW5kX3NpZ25hbF9pcnFfd29yayAqd29yazsNCj4+PiArDQo+Pj4gKwlmb3JfZWFjaF9w
b3NzaWJsZV9jcHUoY3B1KSB7DQo+Pj4gKwkJd29yayA9IHBlcl9jcHVfcHRyKCZzZW5kX3NpZ25h
bF93b3JrLCBjcHUpOw0KPj4+ICsJCWluaXRfaXJxX3dvcmsoJndvcmstPmlycV93b3JrLCBkb19i
cGZfc2VuZF9zaWduYWwpOw0KPj4+ICsJfQ0KPj4+ICsJcmV0dXJuIDA7DQo+Pj4gK30NCj4+PiAr
DQo+Pj4gICBmc19pbml0Y2FsbChicGZfZXZlbnRfaW5pdCk7DQo+Pj4gK3N1YnN5c19pbml0Y2Fs
bChzZW5kX3NpZ25hbF9pcnFfd29ya19pbml0KTsNCj4+PiAgICNlbmRpZiAvKiBDT05GSUdfTU9E
VUxFUyAqLw0KPj4+DQo+Pg0KPiANCg==
