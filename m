Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565A62A11A
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404371AbfEXWVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:21:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404332AbfEXWVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:21:23 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4OMIjnB032163;
        Fri, 24 May 2019 15:20:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OI/CiWJp/HaWC9mkQ78YrKjbmPPavAbvq4SqpgWAAXc=;
 b=Nlq1yPn8ZC7Kr5LqdbVT40zqD6M3mvf4thaNNWJWPR3Fi9NyTjzaPRkcYyfEae25F2bH
 djBT39GTtvfh3SZ/luJ+MZZlnGktuBJDv4efGWbAAdesqKFCkOzCb2sBV3TOFo8MTtUo
 w4dbuL8g1VirUV3NlUrGco9XZrk/G704N3I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2sphggsrnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 May 2019 15:20:56 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 May 2019 15:20:55 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 24 May 2019 15:20:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OI/CiWJp/HaWC9mkQ78YrKjbmPPavAbvq4SqpgWAAXc=;
 b=RSdDH+kIQ7zecfnB/z0xpiV5RzGs1SthDcF6cVWimeD2xAOTOVwbhZ79tKrUyvoHEbwVrYx3HQgwjxKj89Qsh7VK0PZQHPnxQECvqckfPxc/VXafIVRblPwWPObMHUCZ+eiPTT7fKr6zaEG9ICn5YPOV2RqMFftvV5Z7iZowBjI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2792.namprd15.prod.outlook.com (20.179.158.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 22:20:54 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Fri, 24 May 2019
 22:20:54 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>, Kernel Team <Kernel-team@fb.com>,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: implement bpf_send_signal() helper
Thread-Topic: [PATCH bpf-next v5 1/3] bpf: implement bpf_send_signal() helper
Thread-Index: AQHVEbFAdcZbQBZzEE6RKT6takmR46Z6zu2AgAALkwA=
Date:   Fri, 24 May 2019 22:20:53 +0000
Message-ID: <fe5ed98c-0cc2-b126-25e6-84774c03bcb9@fb.com>
References: <20190523214745.854300-1-yhs@fb.com>
 <20190523214745.854355-1-yhs@fb.com>
 <54257f88-b088-2330-ba49-a78ce06d08bf@iogearbox.net>
In-Reply-To: <54257f88-b088-2330-ba49-a78ce06d08bf@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0050.namprd04.prod.outlook.com
 (2603:10b6:300:6c::12) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:f644]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1158998d-ce6d-450a-95ff-08d6e09615ce
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600147)(711020)(4605104)(1401326)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2792;
x-ms-traffictypediagnostic: BYAPR15MB2792:
x-microsoft-antispam-prvs: <BYAPR15MB279241CD83C26C6D7AF2F440D3020@BYAPR15MB2792.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(396003)(366004)(346002)(136003)(189003)(199004)(86362001)(11346002)(64756008)(73956011)(66446008)(6116002)(256004)(2616005)(25786009)(14444005)(6436002)(186003)(229853002)(2906002)(2201001)(476003)(66556008)(66476007)(446003)(6512007)(36756003)(31696002)(53936002)(46003)(6246003)(4326008)(6486002)(486006)(7736002)(14454004)(66946007)(68736007)(8676002)(478600001)(6506007)(102836004)(71200400001)(305945005)(53546011)(71190400001)(386003)(76176011)(8936002)(99286004)(52116002)(54906003)(316002)(110136005)(2501003)(81156014)(5660300002)(81166006)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2792;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VJ1SIbUwIXbDBiOxMlqS3m26ukkXOtlRDk3R02/LMnIZ1rggxJlykHE6hOIGCMHuBzWyxyB5OZ+WrOgdJhqw+1u++vp+tYhdLFGe4jC7WAFU5Zg+80uR93RM2e0zhTSo29Rbz3M5jS+JVAsxlqw2tn6Y62DLw6diiHZaA7OXotzCP89GG4zIACSLYd4+Nv2+Fig17WSus4Xhzr5/YANe7XpO9JspTxPhDZ/RqTbdbnue4627zJ0farZlxHVx/FHHBObnXdTl846YQWV1cqPUd5DHrcA6XRmdUPzw76myESmoW4f7RLv/UD4PSt4nwYhBSXLsk8LAAICcJdvV8xtmExsp7Sg0ny7zRxi7ZeaH7nR5WUV2d4DMXIzX0kXClVMAspr+gy5quAwIWKpn0H2EVEE4Bfmmw7/43fpWP0zCd5g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <599456AADA99984CA0A993FB5CC22136@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1158998d-ce6d-450a-95ff-08d6e09615ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 22:20:53.8478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2792
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

DQoNCk9uIDUvMjQvMTkgMjozOSBQTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPiBPbiAwNS8y
My8yMDE5IDExOjQ3IFBNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4gVGhpcyBwYXRjaCB0cmll
cyB0byBzb2x2ZSB0aGUgZm9sbG93aW5nIHNwZWNpZmljIHVzZSBjYXNlLg0KPj4NCj4+IEN1cnJl
bnRseSwgYnBmIHByb2dyYW0gY2FuIGFscmVhZHkgY29sbGVjdCBzdGFjayB0cmFjZXMNCj4+IHRo
cm91Z2gga2VybmVsIGZ1bmN0aW9uIGdldF9wZXJmX2NhbGxjaGFpbigpDQo+PiB3aGVuIGNlcnRh
aW4gZXZlbnRzIGhhcHBlbnMgKGUuZy4sIGNhY2hlIG1pc3MgY291bnRlciBvcg0KPj4gY3B1IGNs
b2NrIGNvdW50ZXIgb3ZlcmZsb3dzKS4gQnV0IHN1Y2ggc3RhY2sgdHJhY2VzIGFyZQ0KPj4gbm90
IGVub3VnaCBmb3Igaml0dGVkIHByb2dyYW1zLCBlLmcuLCBoaHZtIChqaXRlZCBwaHApLg0KPj4g
VG8gZ2V0IHJlYWwgc3RhY2sgdHJhY2UsIGppdCBlbmdpbmUgaW50ZXJuYWwgZGF0YSBzdHJ1Y3R1
cmVzDQo+PiBuZWVkIHRvIGJlIHRyYXZlcnNlZCBpbiBvcmRlciB0byBnZXQgdGhlIHJlYWwgdXNl
ciBmdW5jdGlvbnMuDQo+Pg0KPj4gYnBmIHByb2dyYW0gaXRzZWxmIG1heSBub3QgYmUgdGhlIGJl
c3QgcGxhY2UgdG8gdHJhdmVyc2UNCj4+IHRoZSBqaXQgZW5naW5lIGFzIHRoZSB0cmF2ZXJzaW5n
IGxvZ2ljIGNvdWxkIGJlIGNvbXBsZXggYW5kDQo+PiBpdCBpcyBub3QgYSBzdGFibGUgaW50ZXJm
YWNlIGVpdGhlci4NCj4+DQo+PiBJbnN0ZWFkLCBoaHZtIGltcGxlbWVudHMgYSBzaWduYWwgaGFu
ZGxlciwNCj4+IGUuZy4gZm9yIFNJR0FMQVJNLCBhbmQgYSBzZXQgb2YgcHJvZ3JhbSBsb2NhdGlv
bnMgd2hpY2gNCj4+IGl0IGNhbiBkdW1wIHN0YWNrIHRyYWNlcy4gV2hlbiBpdCByZWNlaXZlcyBh
IHNpZ25hbCwgaXQgd2lsbA0KPj4gZHVtcCB0aGUgc3RhY2sgaW4gbmV4dCBzdWNoIHByb2dyYW0g
bG9jYXRpb24uDQo+Pg0KPj4gU3VjaCBhIG1lY2hhbmlzbSBjYW4gYmUgaW1wbGVtZW50ZWQgaW4g
dGhlIGZvbGxvd2luZyB3YXk6DQo+PiAgICAuIGEgcGVyZiByaW5nIGJ1ZmZlciBpcyBjcmVhdGVk
IGJldHdlZW4gYnBmIHByb2dyYW0NCj4+ICAgICAgYW5kIHRyYWNpbmcgYXBwLg0KPj4gICAgLiBv
bmNlIGEgcGFydGljdWxhciBldmVudCBoYXBwZW5zLCBicGYgcHJvZ3JhbSB3cml0ZXMNCj4+ICAg
ICAgdG8gdGhlIHJpbmcgYnVmZmVyIGFuZCB0aGUgdHJhY2luZyBhcHAgZ2V0cyBub3RpZmllZC4N
Cj4+ICAgIC4gdGhlIHRyYWNpbmcgYXBwIHNlbmRzIGEgc2lnbmFsIFNJR0FMQVJNIHRvIHRoZSBo
aHZtLg0KPj4NCj4+IEJ1dCB0aGlzIG1ldGhvZCBjb3VsZCBoYXZlIGxhcmdlIGRlbGF5cyBhbmQg
Y2F1c2luZyBwcm9maWxpbmcNCj4+IHJlc3VsdHMgc2tld2VkLg0KPj4NCj4+IFRoaXMgcGF0Y2gg
aW1wbGVtZW50cyBicGZfc2VuZF9zaWduYWwoKSBoZWxwZXIgdG8gc2VuZA0KPj4gYSBzaWduYWwg
dG8gaGh2bSBpbiByZWFsIHRpbWUsIHJlc3VsdGluZyBpbiBpbnRlbmRlZCBzdGFjayB0cmFjZXMu
DQo+Pg0KPj4gQWNrZWQtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+PiBT
aWduZWQtb2ZmLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KPj4gLS0tDQo+PiAgIGlu
Y2x1ZGUvdWFwaS9saW51eC9icGYuaCB8IDE3ICsrKysrKysrKy0NCj4+ICAga2VybmVsL3RyYWNl
L2JwZl90cmFjZS5jIHwgNzIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kw0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDg4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4+DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS91
YXBpL2xpbnV4L2JwZi5oDQo+PiBpbmRleCA2M2UwY2Y2NmYwMWEuLjY4ZDQ0NzA1MjNhMCAxMDA2
NDQNCj4+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPj4gKysrIGIvaW5jbHVkZS91
YXBpL2xpbnV4L2JwZi5oDQo+PiBAQCAtMjY3Miw2ICsyNjcyLDIwIEBAIHVuaW9uIGJwZl9hdHRy
IHsNCj4+ICAgICoJCTAgb24gc3VjY2Vzcy4NCj4+ICAgICoNCj4+ICAgICoJCSoqLUVOT0VOVCoq
IGlmIHRoZSBicGYtbG9jYWwtc3RvcmFnZSBjYW5ub3QgYmUgZm91bmQuDQo+PiArICoNCj4+ICsg
KiBpbnQgYnBmX3NlbmRfc2lnbmFsKHUzMiBzaWcpDQo+PiArICoJRGVzY3JpcHRpb24NCj4+ICsg
KgkJU2VuZCBzaWduYWwgKnNpZyogdG8gdGhlIGN1cnJlbnQgdGFzay4NCj4+ICsgKglSZXR1cm4N
Cj4+ICsgKgkJMCBvbiBzdWNjZXNzIG9yIHN1Y2Nlc3NmdWxseSBxdWV1ZWQuDQo+PiArICoNCj4+
ICsgKgkJKiotRUJVU1kqKiBpZiB3b3JrIHF1ZXVlIHVuZGVyIG5taSBpcyBmdWxsLg0KPj4gKyAq
DQo+PiArICoJCSoqLUVJTlZBTCoqIGlmICpzaWcqIGlzIGludmFsaWQuDQo+PiArICoNCj4+ICsg
KgkJKiotRVBFUk0qKiBpZiBubyBwZXJtaXNzaW9uIHRvIHNlbmQgdGhlICpzaWcqLg0KPj4gKyAq
DQo+PiArICoJCSoqLUVBR0FJTioqIGlmIGJwZiBwcm9ncmFtIGNhbiB0cnkgYWdhaW4uDQo+PiAg
ICAqLw0KPj4gICAjZGVmaW5lIF9fQlBGX0ZVTkNfTUFQUEVSKEZOKQkJXA0KPj4gICAJRk4odW5z
cGVjKSwJCQlcDQo+PiBAQCAtMjc4Miw3ICsyNzk2LDggQEAgdW5pb24gYnBmX2F0dHIgew0KPj4g
ICAJRk4oc3RydG9sKSwJCQlcDQo+PiAgIAlGTihzdHJ0b3VsKSwJCQlcDQo+PiAgIAlGTihza19z
dG9yYWdlX2dldCksCQlcDQo+PiAtCUZOKHNrX3N0b3JhZ2VfZGVsZXRlKSwNCj4+ICsJRk4oc2tf
c3RvcmFnZV9kZWxldGUpLAkJXA0KPj4gKwlGTihzZW5kX3NpZ25hbCksDQo+PiAgIA0KPj4gICAv
KiBpbnRlZ2VyIHZhbHVlIGluICdpbW0nIGZpZWxkIG9mIEJQRl9DQUxMIGluc3RydWN0aW9uIHNl
bGVjdHMgd2hpY2ggaGVscGVyDQo+PiAgICAqIGZ1bmN0aW9uIGVCUEYgcHJvZ3JhbSBpbnRlbmRz
IHRvIGNhbGwNCj4+IGRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMgYi9rZXJu
ZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4+IGluZGV4IGY5MmQ2YWQ1ZTA4MC4uNzAwMjllYWZjNzFm
IDEwMDY0NA0KPj4gLS0tIGEva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+PiArKysgYi9rZXJu
ZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4+IEBAIC01NjcsNiArNTY3LDYzIEBAIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX3Byb2JlX3JlYWRfc3RyX3Byb3RvID0gew0KPj4g
ICAJLmFyZzNfdHlwZQk9IEFSR19BTllUSElORywNCj4+ICAgfTsNCj4+ICAgDQo+PiArc3RydWN0
IHNlbmRfc2lnbmFsX2lycV93b3JrIHsNCj4+ICsJc3RydWN0IGlycV93b3JrIGlycV93b3JrOw0K
Pj4gKwlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2s7DQo+PiArCXUzMiBzaWc7DQo+PiArfTsNCj4+
ICsNCj4+ICtzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IHNlbmRfc2lnbmFsX2lycV93b3Jr
LCBzZW5kX3NpZ25hbF93b3JrKTsNCj4+ICsNCj4+ICtzdGF0aWMgdm9pZCBkb19icGZfc2VuZF9z
aWduYWwoc3RydWN0IGlycV93b3JrICplbnRyeSkNCj4+ICt7DQo+PiArCXN0cnVjdCBzZW5kX3Np
Z25hbF9pcnFfd29yayAqd29yazsNCj4+ICsNCj4+ICsJd29yayA9IGNvbnRhaW5lcl9vZihlbnRy
eSwgc3RydWN0IHNlbmRfc2lnbmFsX2lycV93b3JrLCBpcnFfd29yayk7DQo+PiArCWdyb3VwX3Nl
bmRfc2lnX2luZm8od29yay0+c2lnLCBTRU5EX1NJR19QUklWLCB3b3JrLT50YXNrLCBQSURUWVBF
X1RHSUQpOw0KPj4gK30NCj4+ICsNCj4+ICtCUEZfQ0FMTF8xKGJwZl9zZW5kX3NpZ25hbCwgdTMy
LCBzaWcpDQo+PiArew0KPj4gKwlzdHJ1Y3Qgc2VuZF9zaWduYWxfaXJxX3dvcmsgKndvcmsgPSBO
VUxMOw0KPj4gKw0KPj4gKwkvKiBTaW1pbGFyIHRvIGJwZl9wcm9iZV93cml0ZV91c2VyLCB0YXNr
IG5lZWRzIHRvIGJlDQo+PiArCSAqIGluIGEgc291bmQgY29uZGl0aW9uIGFuZCBrZXJuZWwgbWVt
b3J5IGFjY2VzcyBiZQ0KPj4gKwkgKiBwZXJtaXR0ZWQgaW4gb3JkZXIgdG8gc2VuZCBzaWduYWwg
dG8gdGhlIGN1cnJlbnQNCj4+ICsJICogdGFzay4NCj4+ICsJICovDQo+PiArCWlmICh1bmxpa2Vs
eShjdXJyZW50LT5mbGFncyAmIChQRl9LVEhSRUFEIHwgUEZfRVhJVElORykpKQ0KPj4gKwkJcmV0
dXJuIC1FUEVSTTsNCj4+ICsJaWYgKHVubGlrZWx5KHVhY2Nlc3Nfa2VybmVsKCkpKQ0KPj4gKwkJ
cmV0dXJuIC1FUEVSTTsNCj4+ICsJaWYgKHVubGlrZWx5KCFubWlfdWFjY2Vzc19va2F5KCkpKQ0K
Pj4gKwkJcmV0dXJuIC1FUEVSTTsNCj4+ICsNCj4+ICsJaWYgKGluX25taSgpKSB7DQo+PiArCQl3
b3JrID0gdGhpc19jcHVfcHRyKCZzZW5kX3NpZ25hbF93b3JrKTsNCj4+ICsJCWlmICh3b3JrLT5p
cnFfd29yay5mbGFncyAmIElSUV9XT1JLX0JVU1kpDQo+IA0KPiBHaXZlbiBoZXJlIGFuZCBpbiBz
dGFja21hcCBhcmUgdGhlIG9ubHkgdHdvIHVzZXJzIG91dHNpZGUgb2Yga2VybmVsL2lycV93b3Jr
LmMsDQo+IGl0IG1heSBwcm9iYWJseSBiZSBnb29kIHRvIGFkZCBhIHNtYWxsIGhlbHBlciB0byBp
bmNsdWRlL2xpbnV4L2lycV93b3JrLmggYW5kDQo+IHVzZSBpdCBmb3IgYm90aC4NCj4gDQo+IFBl
cmhhcHMgc29tZXRoaW5nIGxpa2UgLi4uDQo+IA0KPiBzdGF0aWMgaW5saW5lIGJvb2wgaXJxX3dv
cmtfYnVzeShzdHJ1Y3QgaXJxX3dvcmsgKndvcmspDQo+IHsNCj4gCXJldHVybiBSRUFEX09OQ0Uo
d29yay0+ZmxhZ3MpICYgSVJRX1dPUktfQlVTWTsNCj4gfQ0KDQpOb3Qgc3VyZSB3aGV0aGVyIFJF
QURfT05DRSBpcyBuZWVkZWQgaGVyZSBvciBub3QuDQoNClRoZSBpcnFfd29yayBpcyBwZXIgY3B1
IGRhdGEgc3RydWN0dXJlLA0KICAgc3RhdGljIERFRklORV9QRVJfQ1BVKHN0cnVjdCBzZW5kX3Np
Z25hbF9pcnFfd29yaywgc2VuZF9zaWduYWxfd29yayk7DQpzbyBwcmVzdW1hYmx5IG5vIGNvbGxp
c2lvbiBmb3Igd29yay0+ZmxhZ3MgbWVtb3J5IHJlZmVyZW5jZS4NCg0KSWYgd2l0aG91dCBSRUFE
X09OQ0UsIGRvIHlvdSBzdGlsbCB0aGluayBhIGhlbHBlciBpcyBuZWVkZWQ/DQoNCj4gDQo+PiAr
CQkJcmV0dXJuIC1FQlVTWTsNCj4+ICsNCj4+ICsJCS8qIEFkZCB0aGUgY3VycmVudCB0YXNrLCB3
aGljaCBpcyB0aGUgdGFyZ2V0IG9mIHNlbmRpbmcgc2lnbmFsLA0KPj4gKwkJICogdG8gdGhlIGly
cV93b3JrLiBUaGUgY3VycmVudCB0YXNrIG1heSBjaGFuZ2Ugd2hlbiBxdWV1ZWQNCj4+ICsJCSAq
IGlycSB3b3JrcyBnZXQgZXhlY3V0ZWQuDQo+PiArCQkgKi8NCj4+ICsJCXdvcmstPnRhc2sgPSBj
dXJyZW50Ow0KPj4gKwkJd29yay0+c2lnID0gc2lnOw0KPj4gKwkJaXJxX3dvcmtfcXVldWUoJndv
cmstPmlycV93b3JrKTsNCj4+ICsJCXJldHVybiAwOw0KPj4gKwl9DQo+PiArDQo+PiArCXJldHVy
biBncm91cF9zZW5kX3NpZ19pbmZvKHNpZywgU0VORF9TSUdfUFJJViwgY3VycmVudCwgUElEVFlQ
RV9UR0lEKTsNCj4+ICt9DQo+PiArDQo+PiArc3RhdGljIGNvbnN0IHN0cnVjdCBicGZfZnVuY19w
cm90byBicGZfc2VuZF9zaWduYWxfcHJvdG8gPSB7DQo+PiArCS5mdW5jCQk9IGJwZl9zZW5kX3Np
Z25hbCwNCj4+ICsJLmdwbF9vbmx5CT0gZmFsc2UsDQo+PiArCS5yZXRfdHlwZQk9IFJFVF9JTlRF
R0VSLA0KPj4gKwkuYXJnMV90eXBlCT0gQVJHX0FOWVRISU5HLA0KPj4gK307DQo+PiArDQo+PiAg
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gKg0KPj4gICB0cmFjaW5nX2Z1bmNf
cHJvdG8oZW51bSBicGZfZnVuY19pZCBmdW5jX2lkLCBjb25zdCBzdHJ1Y3QgYnBmX3Byb2cgKnBy
b2cpDQo+PiAgIHsNCj4+IEBAIC02MTcsNiArNjc0LDggQEAgdHJhY2luZ19mdW5jX3Byb3RvKGVu
dW0gYnBmX2Z1bmNfaWQgZnVuY19pZCwgY29uc3Qgc3RydWN0IGJwZl9wcm9nICpwcm9nKQ0KPj4g
ICAJY2FzZSBCUEZfRlVOQ19nZXRfY3VycmVudF9jZ3JvdXBfaWQ6DQo+PiAgIAkJcmV0dXJuICZi
cGZfZ2V0X2N1cnJlbnRfY2dyb3VwX2lkX3Byb3RvOw0KPj4gICAjZW5kaWYNCj4+ICsJY2FzZSBC
UEZfRlVOQ19zZW5kX3NpZ25hbDoNCj4+ICsJCXJldHVybiAmYnBmX3NlbmRfc2lnbmFsX3Byb3Rv
Ow0KPj4gICAJZGVmYXVsdDoNCj4+ICAgCQlyZXR1cm4gTlVMTDsNCj4+ICAgCX0NCj4+IEBAIC0x
MzQzLDUgKzE0MDIsMTggQEAgc3RhdGljIGludCBfX2luaXQgYnBmX2V2ZW50X2luaXQodm9pZCkN
Cj4+ICAgCXJldHVybiAwOw0KPj4gICB9DQo+PiAgIA0KPj4gK3N0YXRpYyBpbnQgX19pbml0IHNl
bmRfc2lnbmFsX2lycV93b3JrX2luaXQodm9pZCkNCj4+ICt7DQo+PiArCWludCBjcHU7DQo+PiAr
CXN0cnVjdCBzZW5kX3NpZ25hbF9pcnFfd29yayAqd29yazsNCj4+ICsNCj4+ICsJZm9yX2VhY2hf
cG9zc2libGVfY3B1KGNwdSkgew0KPj4gKwkJd29yayA9IHBlcl9jcHVfcHRyKCZzZW5kX3NpZ25h
bF93b3JrLCBjcHUpOw0KPj4gKwkJaW5pdF9pcnFfd29yaygmd29yay0+aXJxX3dvcmssIGRvX2Jw
Zl9zZW5kX3NpZ25hbCk7DQo+PiArCX0NCj4+ICsJcmV0dXJuIDA7DQo+PiArfQ0KPj4gKw0KPj4g
ICBmc19pbml0Y2FsbChicGZfZXZlbnRfaW5pdCk7DQo+PiArc3Vic3lzX2luaXRjYWxsKHNlbmRf
c2lnbmFsX2lycV93b3JrX2luaXQpOw0KPj4gICAjZW5kaWYgLyogQ09ORklHX01PRFVMRVMgKi8N
Cj4+DQo+IA0K
