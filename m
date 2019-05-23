Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B456C28207
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731191AbfEWP7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:59:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39924 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730752AbfEWP7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 11:59:22 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NFqHZ1022719;
        Thu, 23 May 2019 08:58:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mPS3QnLyeL4yilpepGuMPeVpA7leH0T4HsfjGIXB3Ks=;
 b=PbptGX9xiBkWZ0VhD9whsvfdJ4xhokiJmF9NeKWJnep42z2zQI4Y1WFu+ZpKRYAq0B6x
 nY16froXl3e2mexx4FVs8PjhUMKiPV6Qi2nJwIo0+ckJlnMIWQyhnTZjgwd9bZxBrQPN
 jzffLugJgPfgWnAAfOkRDmYXi0R9QTAaKCo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2snx7s83eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 May 2019 08:58:53 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 23 May 2019 08:58:51 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 08:58:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPS3QnLyeL4yilpepGuMPeVpA7leH0T4HsfjGIXB3Ks=;
 b=BOLDV0E+uQQutLeggZXYCxcl7qwoWxM0EkSG3zyfwXnO1pbOcpLN4PFC7abp8rnFK7YXpovxf4jfXYCJyVBhIW3TWd9ZPhzAHrBZSdlBW0TA5PREdByfKNc+pICnuxkMWzXe/I6Sy85HFml1iPdyCO2tjNTqBRvskeDsGbU5PfM=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3079.namprd15.prod.outlook.com (20.178.239.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 23 May 2019 15:58:50 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 15:58:49 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>, Kernel Team <Kernel-team@fb.com>,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH bpf-next v2 1/3] bpf: implement bpf_send_signal() helper
Thread-Topic: [PATCH bpf-next v2 1/3] bpf: implement bpf_send_signal() helper
Thread-Index: AQHVEGCw/a92LjZUiEmjMwkqdycEvaZ42yyAgAAE34A=
Date:   Thu, 23 May 2019 15:58:48 +0000
Message-ID: <6041511a-1628-868f-b4b1-e567c234a4a5@fb.com>
References: <20190522053900.1663459-1-yhs@fb.com>
 <20190522053900.1663537-1-yhs@fb.com>
 <2c07890b-9da5-b4e8-dc94-35def14470ad@iogearbox.net>
In-Reply-To: <2c07890b-9da5-b4e8-dc94-35def14470ad@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0033.namprd11.prod.outlook.com
 (2603:10b6:300:115::19) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::d011]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66666c1a-1229-4148-cbe1-08d6df978a69
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3079;
x-ms-traffictypediagnostic: BYAPR15MB3079:
x-microsoft-antispam-prvs: <BYAPR15MB3079266C50C0A93A75859CD5D3010@BYAPR15MB3079.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(366004)(136003)(396003)(199004)(189003)(68736007)(6116002)(14454004)(2501003)(99286004)(446003)(2906002)(86362001)(31696002)(6486002)(53546011)(476003)(2201001)(53936002)(81156014)(71200400001)(71190400001)(316002)(52116002)(8936002)(110136005)(81166006)(11346002)(6436002)(102836004)(76176011)(54906003)(4326008)(25786009)(305945005)(8676002)(66946007)(36756003)(66476007)(2616005)(66446008)(73956011)(64756008)(66556008)(46003)(486006)(478600001)(6512007)(186003)(6506007)(386003)(5660300002)(256004)(14444005)(7736002)(229853002)(31686004)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3079;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5MXaAUDq1Ot5bUr6w6QhD/C30T2M2/P5lmthZxwh1jKbyXWYFjY98uD/lj/v/V418sPoa74xJsN6vTp5DBbIpV0lLcOgODf6uNDct8mpCm2blFG0f3dWOaSv1LvQPDo9FtVF3GquYnIz1FG8qc8hkLeyhHXwG64dAO6K8xgjX5ip3TbbWyj/7kn0e+w3ZWeRbtF6/S7u7lyfj5WFTYThFWwDcgVSj03dHdbETcalSEBvMahP4vbUOGHfKAhU45tm1SOkkMk5Hxd8RsucbAaeB8kdPRj0B6WP0eQUNWuwE4cvw03KwEEFWacJBdBSJs6tAkxK27gvxg/0fJ+MrOZEuOOs3ncS2MEjX7UeG3XOQ31Xc5ZTHT1B/w1m1uDG3ovTv4jXe181lSczUivW7P4oQfSw+X4wtNihZ2Io+7jN6Bs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BD707FAB1167244A03840708C3A3C84@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 66666c1a-1229-4148-cbe1-08d6df978a69
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 15:58:49.3188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3079
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230108
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjMvMTkgODo0MSBBTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPiBPbiAwNS8y
Mi8yMDE5IDA3OjM5IEFNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4gVGhpcyBwYXRjaCB0cmll
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
DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCj4+IC0t
LQ0KPj4gICBpbmNsdWRlL3VhcGkvbGludXgvYnBmLmggfCAxNyArKysrKysrKystDQo+PiAgIGtl
cm5lbC90cmFjZS9icGZfdHJhY2UuYyB8IDY3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4+ICAgMiBmaWxlcyBjaGFuZ2VkLCA4MyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaCBi
L2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPj4gaW5kZXggNjNlMGNmNjZmMDFhLi42OGQ0NDcw
NTIzYTAgMTAwNjQ0DQo+PiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4+ICsrKyBi
L2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPj4gQEAgLTI2NzIsNiArMjY3MiwyMCBAQCB1bmlv
biBicGZfYXR0ciB7DQo+PiAgICAqCQkwIG9uIHN1Y2Nlc3MuDQo+PiAgICAqDQo+PiAgICAqCQkq
Ki1FTk9FTlQqKiBpZiB0aGUgYnBmLWxvY2FsLXN0b3JhZ2UgY2Fubm90IGJlIGZvdW5kLg0KPj4g
KyAqDQo+PiArICogaW50IGJwZl9zZW5kX3NpZ25hbCh1MzIgc2lnKQ0KPj4gKyAqCURlc2NyaXB0
aW9uDQo+PiArICoJCVNlbmQgc2lnbmFsICpzaWcqIHRvIHRoZSBjdXJyZW50IHRhc2suDQo+PiAr
ICoJUmV0dXJuDQo+PiArICoJCTAgb24gc3VjY2VzcyBvciBzdWNjZXNzZnVsbHkgcXVldWVkLg0K
Pj4gKyAqDQo+PiArICoJCSoqLUVCVVNZKiogaWYgd29yayBxdWV1ZSB1bmRlciBubWkgaXMgZnVs
bC4NCj4+ICsgKg0KPj4gKyAqCQkqKi1FSU5WQUwqKiBpZiAqc2lnKiBpcyBpbnZhbGlkLg0KPj4g
KyAqDQo+PiArICoJCSoqLUVQRVJNKiogaWYgbm8gcGVybWlzc2lvbiB0byBzZW5kIHRoZSAqc2ln
Ki4NCj4+ICsgKg0KPj4gKyAqCQkqKi1FQUdBSU4qKiBpZiBicGYgcHJvZ3JhbSBjYW4gdHJ5IGFn
YWluLg0KPj4gICAgKi8NCj4+ICAgI2RlZmluZSBfX0JQRl9GVU5DX01BUFBFUihGTikJCVwNCj4+
ICAgCUZOKHVuc3BlYyksCQkJXA0KPj4gQEAgLTI3ODIsNyArMjc5Niw4IEBAIHVuaW9uIGJwZl9h
dHRyIHsNCj4+ICAgCUZOKHN0cnRvbCksCQkJXA0KPj4gICAJRk4oc3RydG91bCksCQkJXA0KPj4g
ICAJRk4oc2tfc3RvcmFnZV9nZXQpLAkJXA0KPj4gLQlGTihza19zdG9yYWdlX2RlbGV0ZSksDQo+
PiArCUZOKHNrX3N0b3JhZ2VfZGVsZXRlKSwJCVwNCj4+ICsJRk4oc2VuZF9zaWduYWwpLA0KPj4g
ICANCj4+ICAgLyogaW50ZWdlciB2YWx1ZSBpbiAnaW1tJyBmaWVsZCBvZiBCUEZfQ0FMTCBpbnN0
cnVjdGlvbiBzZWxlY3RzIHdoaWNoIGhlbHBlcg0KPj4gICAgKiBmdW5jdGlvbiBlQlBGIHByb2dy
YW0gaW50ZW5kcyB0byBjYWxsDQo+PiBkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL2JwZl90cmFj
ZS5jIGIva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+PiBpbmRleCBmOTJkNmFkNWUwODAuLmY4
Y2QwZGI3Mjg5ZiAxMDA2NDQNCj4+IC0tLSBhL2tlcm5lbC90cmFjZS9icGZfdHJhY2UuYw0KPj4g
KysrIGIva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+PiBAQCAtNTY3LDYgKzU2Nyw1OCBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9wcm9iZV9yZWFkX3N0cl9wcm90
byA9IHsNCj4+ICAgCS5hcmczX3R5cGUJPSBBUkdfQU5ZVEhJTkcsDQo+PiAgIH07DQo+PiAgIA0K
Pj4gK3N0cnVjdCBzZW5kX3NpZ25hbF9pcnFfd29yayB7DQo+PiArCXN0cnVjdCBpcnFfd29yayBp
cnFfd29yazsNCj4+ICsJdTMyIHNpZzsNCj4+ICt9Ow0KPj4gKw0KPj4gK3N0YXRpYyBERUZJTkVf
UEVSX0NQVShzdHJ1Y3Qgc2VuZF9zaWduYWxfaXJxX3dvcmssIHNlbmRfc2lnbmFsX3dvcmspOw0K
Pj4gKw0KPj4gK3N0YXRpYyB2b2lkIGRvX2JwZl9zZW5kX3NpZ25hbChzdHJ1Y3QgaXJxX3dvcmsg
KmVudHJ5KQ0KPj4gK3sNCj4+ICsJc3RydWN0IHNlbmRfc2lnbmFsX2lycV93b3JrICp3b3JrOw0K
Pj4gKw0KPj4gKwl3b3JrID0gY29udGFpbmVyX29mKGVudHJ5LCBzdHJ1Y3Qgc2VuZF9zaWduYWxf
aXJxX3dvcmssIGlycV93b3JrKTsNCj4+ICsJZ3JvdXBfc2VuZF9zaWdfaW5mbyh3b3JrLT5zaWcs
IFNFTkRfU0lHX1BSSVYsIGN1cnJlbnQsIFBJRFRZUEVfVEdJRCk7DQo+PiArfQ0KPj4gKw0KPj4g
K0JQRl9DQUxMXzEoYnBmX3NlbmRfc2lnbmFsLCB1MzIsIHNpZykNCj4+ICt7DQo+PiArCXN0cnVj
dCBzZW5kX3NpZ25hbF9pcnFfd29yayAqd29yayA9IE5VTEw7DQo+PiArDQo+PiArCS8qIFNpbWls
YXIgdG8gYnBmX3Byb2JlX3dyaXRlX3VzZXIsIHRhc2sgbmVlZHMgdG8gYmUNCj4+ICsJICogaW4g
YSBzb3VuZCBjb25kaXRpb24gYW5kIGtlcm5lbCBtZW1vcnkgYWNjZXNzIGJlDQo+PiArCSAqIHBl
cm1pdHRlZCBpbiBvcmRlciB0byBzZW5kIHNpZ25hbCB0byB0aGUgY3VycmVudA0KPj4gKwkgKiB0
YXNrLg0KPj4gKwkgKi8NCj4+ICsJaWYgKHVubGlrZWx5KGN1cnJlbnQtPmZsYWdzICYgKFBGX0tU
SFJFQUQgfCBQRl9FWElUSU5HKSkpDQo+PiArCQlyZXR1cm4gLUVQRVJNOw0KPj4gKwlpZiAodW5s
aWtlbHkodWFjY2Vzc19rZXJuZWwoKSkpDQo+PiArCQlyZXR1cm4gLUVQRVJNOw0KPj4gKwlpZiAo
dW5saWtlbHkoIW5taV91YWNjZXNzX29rYXkoKSkpDQo+PiArCQlyZXR1cm4gLUVQRVJNOw0KPj4g
Kw0KPj4gKwlpZiAoaW5fbm1pKCkpIHsNCj4gDQo+IEhtLCBiaXQgY29uZnVzZWQsIGNhbid0IHRo
aXMgb25seSBiZSBkb25lIG91dCBvZiBwcm9jZXNzIGNvbnRleHQgaW4NCj4gZ2VuZXJhbCBzaW5j
ZSBvbmx5IHRoZXJlIGN1cnJlbnQgcG9pbnRzIHRvIGUuZy4gaGh2bT8gSSdtIHByb2JhYmx5DQo+
IG1pc3Npbmcgc29tZXRoaW5nLiBDb3VsZCB5b3UgZWxhYm9yYXRlPw0KDQpUaGF0IGlzIHRydWUu
IElmIGluIG5taSwgaXQgaXMgb3V0IG9mIHByb2Nlc3MgY29udGV4dCBhbmQgaW4gbm1pIA0KY29u
dGV4dCwgd2UgdXNlIGFuIGlycV93b3JrIGhlcmUgc2luY2UgZ3JvdXBfc2VuZF9zaWdfaW5mbygp
IGhhcw0Kc3BpbmxvY2sgaW5zaWRlLiBUaGUgYnBmIHByb2dyYW0gKGUuZy4sIGEgcGVyZl9ldmVu
dCBwcm9ncmFtKSBuZWVkcyB0byANCmNoZWNrIGl0IGlzIHdpdGggcmlnaHQgY3VycmVudCAoZS5n
LiwgYnkgcGlkKSBiZWZvcmUgY2FsbGluZw0KdGhpcyBoZWxwZXIuDQoNCkRvZXMgdGhpcyBhZGRy
ZXNzIHlvdXIgcXVlc3Rpb24/DQoNCj4gDQo+PiArCQl3b3JrID0gdGhpc19jcHVfcHRyKCZzZW5k
X3NpZ25hbF93b3JrKTsNCj4+ICsJCWlmICh3b3JrLT5pcnFfd29yay5mbGFncyAmIElSUV9XT1JL
X0JVU1kpDQo+PiArCQkJcmV0dXJuIC1FQlVTWTsNCj4+ICsNCj4+ICsJCXdvcmstPnNpZyA9IHNp
ZzsNCj4+ICsJCWlycV93b3JrX3F1ZXVlKCZ3b3JrLT5pcnFfd29yayk7DQo+PiArCQlyZXR1cm4g
MDsNCj4+ICsJfQ0KPj4gKw0KPj4gKwlyZXR1cm4gZ3JvdXBfc2VuZF9zaWdfaW5mbyhzaWcsIFNF
TkRfU0lHX1BSSVYsIGN1cnJlbnQsIFBJRFRZUEVfVEdJRCk7DQo+PiArDQo+IA0KPiBOaXQ6IGV4
dHJhIG5ld2xpbmUgc2xpcHBlZCBpbg0KVGhhbmtzLiBXaWxsIHJlbW92ZSB0aGlzIGluIHRoZSBu
ZXh0IHJldmlzaW9uLg0KPiANCj4+ICt9DQo+PiArDQo+PiArc3RhdGljIGNvbnN0IHN0cnVjdCBi
cGZfZnVuY19wcm90byBicGZfc2VuZF9zaWduYWxfcHJvdG8gPSB7DQo+PiArCS5mdW5jCQk9IGJw
Zl9zZW5kX3NpZ25hbCwNCj4+ICsJLmdwbF9vbmx5CT0gZmFsc2UsDQo+PiArCS5yZXRfdHlwZQk9
IFJFVF9JTlRFR0VSLA0KPj4gKwkuYXJnMV90eXBlCT0gQVJHX0FOWVRISU5HLA0KPj4gK307DQo+
PiArDQo+PiAgIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gKg0KPj4gICB0cmFj
aW5nX2Z1bmNfcHJvdG8oZW51bSBicGZfZnVuY19pZCBmdW5jX2lkLCBjb25zdCBzdHJ1Y3QgYnBm
X3Byb2cgKnByb2cpDQo+PiAgIHsNCj4+IEBAIC02MTcsNiArNjY5LDggQEAgdHJhY2luZ19mdW5j
X3Byb3RvKGVudW0gYnBmX2Z1bmNfaWQgZnVuY19pZCwgY29uc3Qgc3RydWN0IGJwZl9wcm9nICpw
cm9nKQ0KPj4gICAJY2FzZSBCUEZfRlVOQ19nZXRfY3VycmVudF9jZ3JvdXBfaWQ6DQo+PiAgIAkJ
cmV0dXJuICZicGZfZ2V0X2N1cnJlbnRfY2dyb3VwX2lkX3Byb3RvOw0KPj4gICAjZW5kaWYNCj4+
ICsJY2FzZSBCUEZfRlVOQ19zZW5kX3NpZ25hbDoNCj4+ICsJCXJldHVybiAmYnBmX3NlbmRfc2ln
bmFsX3Byb3RvOw0KPj4gICAJZGVmYXVsdDoNCj4+ICAgCQlyZXR1cm4gTlVMTDsNCj4+ICAgCX0N
Cj4+IEBAIC0xMzQzLDUgKzEzOTcsMTggQEAgc3RhdGljIGludCBfX2luaXQgYnBmX2V2ZW50X2lu
aXQodm9pZCkNCj4+ICAgCXJldHVybiAwOw0KPj4gICB9DQo+PiAgIA0KPj4gK3N0YXRpYyBpbnQg
X19pbml0IHNlbmRfc2lnbmFsX2lycV93b3JrX2luaXQodm9pZCkNCj4+ICt7DQo+PiArCWludCBj
cHU7DQo+PiArCXN0cnVjdCBzZW5kX3NpZ25hbF9pcnFfd29yayAqd29yazsNCj4+ICsNCj4+ICsJ
Zm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkgew0KPj4gKwkJd29yayA9IHBlcl9jcHVfcHRyKCZz
ZW5kX3NpZ25hbF93b3JrLCBjcHUpOw0KPj4gKwkJaW5pdF9pcnFfd29yaygmd29yay0+aXJxX3dv
cmssIGRvX2JwZl9zZW5kX3NpZ25hbCk7DQo+PiArCX0NCj4+ICsJcmV0dXJuIDA7DQo+PiArfQ0K
Pj4gKw0KPj4gICBmc19pbml0Y2FsbChicGZfZXZlbnRfaW5pdCk7DQo+PiArc3Vic3lzX2luaXRj
YWxsKHNlbmRfc2lnbmFsX2lycV93b3JrX2luaXQpOw0KPj4gICAjZW5kaWYgLyogQ09ORklHX01P
RFVMRVMgKi8NCj4+DQo+IA0K
