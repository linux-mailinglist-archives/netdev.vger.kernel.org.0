Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D088D6213A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732159AbfGHPLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:11:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21760 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732146AbfGHPLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:11:40 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x68FAiZD030205;
        Mon, 8 Jul 2019 08:11:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/nEbWEPtVr8ackokbZo+Ca8TyEJfWHAsItin4SJI944=;
 b=ZiQfFoYTletkreFopFAmrT3OIkEsN24VhA3o7ZZ3XQzFCQEz5tumBRPD1FYTq/36lQXY
 z1kBJA0Ee6lygOxb7IJpVFqDzCxmTs/T9jDA1yRf90wljjl7hnMIw9XCdfCw/S3pyO3T
 Jr7oGYwKiV1gyLF4JLZAS5+DcZJYhEN1pHc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2tm7jtg4kf-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 08 Jul 2019 08:11:12 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 8 Jul 2019 08:06:33 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 8 Jul 2019 08:06:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nEbWEPtVr8ackokbZo+Ca8TyEJfWHAsItin4SJI944=;
 b=icy886oIKaHukfleZRrzrSyVJU9ZXmrWai2dmJ6mgz2p2kY+IRvjQh2gxAATsfbt4acmkD9Ll1pMT3O9QsKDC2w+TvEGzlD2cnmDf2gAtK6d1TklLHDD231+hLMoOfr2ozE+gfO/RoLrB4fkKVcrMew4RF/fV12XDRqRAJtmj4o=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3477.namprd15.prod.outlook.com (20.179.60.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.15; Mon, 8 Jul 2019 15:06:31 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2052.020; Mon, 8 Jul 2019
 15:06:31 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>
CC:     Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        "Stanislav Fomichev" <sdf@google.com>,
        Song Liu <songliubraving@fb.com>,
        "Mauricio Vasquez B" <mauricio.vasquez@polito.it>,
        Roman Gushchin <guro@fb.com>, Matt Mullins <mmullins@fb.com>,
        Willem de Bruijn <willemb@google.com>,
        Andrey Ignatov <rdna@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] bpf: skip sockopt hooks without CONFIG_NET
Thread-Topic: [PATCH net-next 1/2] bpf: skip sockopt hooks without CONFIG_NET
Thread-Index: AQHVNYzDbnvqiSRlzUOESszKQb6SnabA0lKA
Date:   Mon, 8 Jul 2019 15:06:31 +0000
Message-ID: <0e7cf1b5-579f-5fcd-0966-8760148b00de@fb.com>
References: <20190708125733.3944836-1-arnd@arndb.de>
In-Reply-To: <20190708125733.3944836-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:a03:40::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:34ce]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4e9b64f-6f00-4aad-7241-08d703b5dbff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3477;
x-ms-traffictypediagnostic: BYAPR15MB3477:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB34777D3680CEF87538A47A3BD3F60@BYAPR15MB3477.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(366004)(376002)(39860400002)(346002)(136003)(396003)(189003)(199004)(52314003)(31686004)(53936002)(6306002)(6512007)(110136005)(99286004)(54906003)(6436002)(229853002)(6486002)(316002)(966005)(46003)(2616005)(11346002)(476003)(486006)(14444005)(256004)(5024004)(6506007)(386003)(6246003)(52116002)(8676002)(66476007)(14454004)(6116002)(76176011)(86362001)(186003)(446003)(102836004)(53546011)(66946007)(4326008)(73956011)(5660300002)(36756003)(66446008)(64756008)(66556008)(81166006)(81156014)(7736002)(31696002)(25786009)(71190400001)(71200400001)(68736007)(8936002)(478600001)(2906002)(305945005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3477;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OoYW6sygFIArLok8ZLt8EAP6wOUfKZccot5LkgSVXwd63cdi4yiM8vK3lE9cA5qA4tMCtR/BpWfbuoGTlcgknJzs6bGEmNJO+blhXJF/K8yVyCJh/wlEzeqpA998QMFAhsTbpAw9XBjXHuXb2yGg8OI5HUUxnHtrt31uhsdMgFxE8+0x6iNUllsNHIEWdcgph2p7cetcA6T0xnww29xGJlizDCowsk4KOBdT76a4rlt3gYSGWjiK6KymtWYVYyzP14dM8S2Yb7f3LxQEN6ZfGbJSPM0sEj2pBBRbLfbwliSVCcMD72HWP1ekcJZ5NoLQ9b9RW8NyoDi6mYArMWYJmgCN2n0hS1uHrkq5gPvRaaJLjmglrfgeoYl7SrUxXQPCgBqNqi7TFS6orQikLBJd60rM8tbHXovQXxpA7luvnW4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E1806D1C344524C92038F3B8EDE225C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e9b64f-6f00-4aad-7241-08d703b5dbff
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 15:06:31.4697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3477
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvOC8xOSA1OjU3IEFNLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0KPiBXaGVuIENPTkZJ
R19ORVQgaXMgZGlzYWJsZWQsIHdlIGdldCBhIGxpbmsgZXJyb3I6DQo+IA0KPiBrZXJuZWwvYnBm
L2Nncm91cC5vOiBJbiBmdW5jdGlvbiBgX19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJfc2V0c29ja29w
dCc6DQo+IGNncm91cC5jOigudGV4dCsweDMwMTApOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBs
b2NrX3NvY2tfbmVzdGVkJw0KPiBjZ3JvdXAuYzooLnRleHQrMHgzMjU4KTogdW5kZWZpbmVkIHJl
ZmVyZW5jZSB0byBgcmVsZWFzZV9zb2NrJw0KPiBrZXJuZWwvYnBmL2Nncm91cC5vOiBJbiBmdW5j
dGlvbiBgX19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJfZ2V0c29ja29wdCc6DQo+IGNncm91cC5jOigu
dGV4dCsweDM1NjgpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBsb2NrX3NvY2tfbmVzdGVkJw0K
PiBjZ3JvdXAuYzooLnRleHQrMHgzODcwKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgcmVsZWFz
ZV9zb2NrJw0KPiBrZXJuZWwvYnBmL2Nncm91cC5vOiBJbiBmdW5jdGlvbiBgY2dfc29ja29wdF9m
dW5jX3Byb3RvJzoNCj4gY2dyb3VwLmM6KC50ZXh0KzB4NDFkOCk6IHVuZGVmaW5lZCByZWZlcmVu
Y2UgdG8gYGJwZl9za19zdG9yYWdlX2RlbGV0ZV9wcm90bycNCj4gDQo+IE5vbmUgb2YgdGhpcyBj
b2RlIGlzIHVzZWZ1bCBpbiB0aGlzIGNvbmZpZ3VyYXRpb24gYW55d2F5LCBzbyB3ZSBjYW4NCj4g
c2ltcGx5IGhpZGUgaXQgaW4gYW4gYXBwcm9wcmlhdGUgI2lmZGVmLg0KPiANCj4gRml4ZXM6IDBk
MDFkYTZhZmM1NCAoImJwZjogaW1wbGVtZW50IGdldHNvY2tvcHQgYW5kIHNldHNvY2tvcHQgaG9v
a3MiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KDQpG
WUkuDQoNClRoZXJlIGlzIGFscmVhZHkgYSBwYXRjaCB0byBmaXggdGhlIHNhbWUgaXNzdWUsDQpo
dHRwczovL2xvcmUua2VybmVsLm9yZy9icGYvZTllNDg5ZmUtZmVlYy1hMjExLTgyYWEtNWRmMGM2
YTMwOGQxQGh1YXdlaS5jb20vVC8jdA0KDQp3aGljaCBoYXMgYmVlbiBhY2tlZCBhbmQgbm90IG1l
cmdlZCB5ZXQuDQoNCj4gLS0tDQo+ICAgaW5jbHVkZS9saW51eC9icGZfdHlwZXMuaCB8IDIgKysN
Cj4gICBrZXJuZWwvYnBmL2Nncm91cC5jICAgICAgIHwgNiArKysrKysNCj4gICAyIGZpbGVzIGNo
YW5nZWQsIDggaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgv
YnBmX3R5cGVzLmggYi9pbmNsdWRlL2xpbnV4L2JwZl90eXBlcy5oDQo+IGluZGV4IGVlYzVhZWVl
YWY5Mi4uM2M3MjIyYjJkYjk2IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2JwZl90eXBl
cy5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvYnBmX3R5cGVzLmgNCj4gQEAgLTMwLDggKzMwLDEw
IEBAIEJQRl9QUk9HX1RZUEUoQlBGX1BST0dfVFlQRV9SQVdfVFJBQ0VQT0lOVF9XUklUQUJMRSwg
cmF3X3RyYWNlcG9pbnRfd3JpdGFibGUpDQo+ICAgI2lmZGVmIENPTkZJR19DR1JPVVBfQlBGDQo+
ICAgQlBGX1BST0dfVFlQRShCUEZfUFJPR19UWVBFX0NHUk9VUF9ERVZJQ0UsIGNnX2RldikNCj4g
ICBCUEZfUFJPR19UWVBFKEJQRl9QUk9HX1RZUEVfQ0dST1VQX1NZU0NUTCwgY2dfc3lzY3RsKQ0K
PiArI2lmZGVmIENPTkZJR19ORVQNCj4gICBCUEZfUFJPR19UWVBFKEJQRl9QUk9HX1RZUEVfQ0dS
T1VQX1NPQ0tPUFQsIGNnX3NvY2tvcHQpDQo+ICAgI2VuZGlmDQo+ICsjZW5kaWYNCj4gICAjaWZk
ZWYgQ09ORklHX0JQRl9MSVJDX01PREUyDQo+ICAgQlBGX1BST0dfVFlQRShCUEZfUFJPR19UWVBF
X0xJUkNfTU9ERTIsIGxpcmNfbW9kZTIpDQo+ICAgI2VuZGlmDQo+IGRpZmYgLS1naXQgYS9rZXJu
ZWwvYnBmL2Nncm91cC5jIGIva2VybmVsL2JwZi9jZ3JvdXAuYw0KPiBpbmRleCA3NmZhMDA3NmYy
MGQuLjdiZTQ0NDYwYmQ5MyAxMDA2NDQNCj4gLS0tIGEva2VybmVsL2JwZi9jZ3JvdXAuYw0KPiAr
KysgYi9rZXJuZWwvYnBmL2Nncm91cC5jDQo+IEBAIC01OTAsNiArNTkwLDcgQEAgaW50IGNncm91
cF9icGZfcHJvZ19xdWVyeShjb25zdCB1bmlvbiBicGZfYXR0ciAqYXR0ciwNCj4gICAJcmV0dXJu
IHJldDsNCj4gICB9DQo+ICAgDQo+ICsjaWZkZWYgQ09ORklHX05FVA0KPiAgIC8qKg0KPiAgICAq
IF9fY2dyb3VwX2JwZl9ydW5fZmlsdGVyX3NrYigpIC0gUnVuIGEgcHJvZ3JhbSBmb3IgcGFja2V0
IGZpbHRlcmluZw0KPiAgICAqIEBzazogVGhlIHNvY2tldCBzZW5kaW5nIG9yIHJlY2VpdmluZyB0
cmFmZmljDQo+IEBAIC03NTAsNiArNzUxLDcgQEAgaW50IF9fY2dyb3VwX2JwZl9ydW5fZmlsdGVy
X3NvY2tfb3BzKHN0cnVjdCBzb2NrICpzaywNCj4gICAJcmV0dXJuIHJldCA9PSAxID8gMCA6IC1F
UEVSTTsNCj4gICB9DQo+ICAgRVhQT1JUX1NZTUJPTChfX2Nncm91cF9icGZfcnVuX2ZpbHRlcl9z
b2NrX29wcyk7DQo+ICsjZW5kaWYNCj4gICANCj4gICBpbnQgX19jZ3JvdXBfYnBmX2NoZWNrX2Rl
dl9wZXJtaXNzaW9uKHNob3J0IGRldl90eXBlLCB1MzIgbWFqb3IsIHUzMiBtaW5vciwNCj4gICAJ
CQkJICAgICAgc2hvcnQgYWNjZXNzLCBlbnVtIGJwZl9hdHRhY2hfdHlwZSB0eXBlKQ0KPiBAQCAt
OTM5LDYgKzk0MSw3IEBAIGludCBfX2Nncm91cF9icGZfcnVuX2ZpbHRlcl9zeXNjdGwoc3RydWN0
IGN0bF90YWJsZV9oZWFkZXIgKmhlYWQsDQo+ICAgfQ0KPiAgIEVYUE9SVF9TWU1CT0woX19jZ3Jv
dXBfYnBmX3J1bl9maWx0ZXJfc3lzY3RsKTsNCj4gICANCj4gKyNpZmRlZiBDT05GSUdfTkVUDQo+
ICAgc3RhdGljIGJvb2wgX19jZ3JvdXBfYnBmX3Byb2dfYXJyYXlfaXNfZW1wdHkoc3RydWN0IGNn
cm91cCAqY2dycCwNCj4gICAJCQkJCSAgICAgZW51bSBicGZfYXR0YWNoX3R5cGUgYXR0YWNoX3R5
cGUpDQo+ICAgew0KPiBAQCAtMTEyMCw2ICsxMTIzLDcgQEAgaW50IF9fY2dyb3VwX2JwZl9ydW5f
ZmlsdGVyX2dldHNvY2tvcHQoc3RydWN0IHNvY2sgKnNrLCBpbnQgbGV2ZWwsDQo+ICAgCXJldHVy
biByZXQ7DQo+ICAgfQ0KPiAgIEVYUE9SVF9TWU1CT0woX19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJf
Z2V0c29ja29wdCk7DQo+ICsjZW5kaWYNCj4gICANCj4gICBzdGF0aWMgc3NpemVfdCBzeXNjdGxf
Y3B5X2Rpcihjb25zdCBzdHJ1Y3QgY3RsX2RpciAqZGlyLCBjaGFyICoqYnVmcCwNCj4gICAJCQkg
ICAgICBzaXplX3QgKmxlbnApDQo+IEBAIC0xMzgyLDYgKzEzODYsNyBAQCBjb25zdCBzdHJ1Y3Qg
YnBmX3ZlcmlmaWVyX29wcyBjZ19zeXNjdGxfdmVyaWZpZXJfb3BzID0gew0KPiAgIGNvbnN0IHN0
cnVjdCBicGZfcHJvZ19vcHMgY2dfc3lzY3RsX3Byb2dfb3BzID0gew0KPiAgIH07DQo+ICAgDQo+
ICsjaWZkZWYgQ09ORklHX05FVA0KPiAgIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJv
dG8gKg0KPiAgIGNnX3NvY2tvcHRfZnVuY19wcm90byhlbnVtIGJwZl9mdW5jX2lkIGZ1bmNfaWQs
IGNvbnN0IHN0cnVjdCBicGZfcHJvZyAqcHJvZykNCj4gICB7DQo+IEBAIC0xNTMxLDMgKzE1MzYs
NCBAQCBjb25zdCBzdHJ1Y3QgYnBmX3ZlcmlmaWVyX29wcyBjZ19zb2Nrb3B0X3ZlcmlmaWVyX29w
cyA9IHsNCj4gICANCj4gICBjb25zdCBzdHJ1Y3QgYnBmX3Byb2dfb3BzIGNnX3NvY2tvcHRfcHJv
Z19vcHMgPSB7DQo+ICAgfTsNCj4gKyNlbmRpZg0KPiANCg==
