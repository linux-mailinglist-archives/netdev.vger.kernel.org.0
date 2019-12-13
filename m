Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E748311EA75
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbfLMSgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:36:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31398 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728845AbfLMSgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:36:44 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDILSxI017801;
        Fri, 13 Dec 2019 10:34:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yv04d3FgGZl4tSNemlPl4/bKg/HnEUPqW5Fac6/oiXE=;
 b=GKY4whD9jT0lj7MmjW6Xsv7utxIBnYIevqKhJIF6K4gcmJ/oNNxoEfOuIe9AU09SUYoJ
 LLLc4x6Bsl4TNWmnZdTWP3afo3HzS3R/x/udbElJDS+3eF3utC5hdJFx1gPqVLR9YMr5
 NxGYd64q/7utMSAogN0LUevwl/bTVH9JSBY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wusrmwvee-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Dec 2019 10:34:26 -0800
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 10:34:23 -0800
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 10:34:23 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 10:34:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKxIVSwzS909n0IfUG/J01BB3joJQi/ceRCNQrQSXaZXpHc6pQhs6DvJxENoHjQYsdOwPN+2BpgAS8c5UajGG8HjfFR7/oVVwsNEE2tGMMpakdMgW+dmMsoA5yGOQYERzoWfN3qa/MAltzz+FxmoEwIuahxyZZJoecn6UlPJYP3reFwDifv45Bb52gHSMdGhEbnd1xjD7HYdMucbhKNPARxPWr5Nrhl0wT0BBMXiUG1vSfutafiO/zLqRH/44EzGC5Eu7iVRNt+83jHtW5rFYTeJeWeBcLrLwbvd9Q0hhQUKlgJJ08TaE+xegKtDmdHkWvCud/roo68KmFZVaLN0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yv04d3FgGZl4tSNemlPl4/bKg/HnEUPqW5Fac6/oiXE=;
 b=hvruh2vRUgCQE+6QJJTMbVZA+IvvSY2T0hUuT4oE8xrdmvW05zazRXfNMmXR+j88i+SFzvt835Ib32ZYG0xeXLrOAHCh9qlIF7JNkHV9MMHsqZ7qMpoOUoyKV7JAxF7+pRgzFtuJBXxZlswNsyCcXO2u5Oy94o6mJu/UpkigvXGyC6R8mYZfPnsA6a5cfZaztBz4bwRozPTMPuME7MLxVMFIcpnCSAH4ZF7mqmBK+0dvGvPOMFI104cBcPBbXML/JfTvsn/6ipF1UT9T760+OOhT8pR3Jcei8OAozlzJYALc5VN8YsotL64g3McHX32NCTVCDf6vhqvXlbxxl79fYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yv04d3FgGZl4tSNemlPl4/bKg/HnEUPqW5Fac6/oiXE=;
 b=eg4fXVbUzMM+0J5jkaXLJ7zPOMXOb6ajDuH4ybJ0QOgHeei2UtnomhE/loPYeO4xc/dMrXB9MvJthbIpaQJecjn91rsfGMaaBQcyhoXtNJf4IV1H1cb8Fj31Pi86DzBgX7PFR7vci0VQx7h5UJEANdhZDZMnUm0Gc6k1pQoioPQ=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1564.namprd15.prod.outlook.com (10.173.224.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Fri, 13 Dec 2019 18:34:22 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 18:34:22 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 09/11] selftests/bpf: add batch ops testing
 for htab and htab_percpu map
Thread-Topic: [PATCH v3 bpf-next 09/11] selftests/bpf: add batch ops testing
 for htab and htab_percpu map
Thread-Index: AQHVsHM7yfbqfNzkC0GsbvFzTjuF76e4ZvaA
Date:   Fri, 13 Dec 2019 18:34:22 +0000
Message-ID: <051f7239-a53e-0683-a2df-5fa66912128c@fb.com>
References: <20191211223344.165549-1-brianvv@google.com>
 <20191211223344.165549-10-brianvv@google.com>
In-Reply-To: <20191211223344.165549-10-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0042.namprd21.prod.outlook.com
 (2603:10b6:300:129::28) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e8f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5fda425-7fa4-4b27-6495-08d77ffb1287
x-ms-traffictypediagnostic: DM5PR15MB1564:
x-microsoft-antispam-prvs: <DM5PR15MB156432918E6C3441F925A2B5D3540@DM5PR15MB1564.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:361;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(366004)(376002)(396003)(199004)(189003)(186003)(8676002)(53546011)(4326008)(71200400001)(5660300002)(36756003)(6506007)(31686004)(2616005)(110136005)(316002)(54906003)(52116002)(31696002)(66446008)(6486002)(66476007)(86362001)(2906002)(66556008)(81156014)(66946007)(81166006)(8936002)(6512007)(7416002)(64756008)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1564;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wc9xkXwJVSqZnsod1AaSSSb7BB7tpmLU+gUFGIzd41jPuFeLR5EN3akmU5yth6Dq/KbD04xqR65JPlNWNVOnrVHs6ngr/6sl3aLPIeAKZawbbXrHV4HDPCmK0if6FvmvAx5KVNxbdaTf/yz6SLKleRUGttMNBjGc1GIddQnSW9c5bnC39MH5glWNIirl6oJ7aYcKlDRu+JS8rO8kV7umE8w4HKDwMnZMmT6qNS9KrzKx+ph+qA3pWZPqn9/jznZiGBjEXdz9sTZMuXxkoMwFUfOwVKE7lZ3MqQ5vJVyp8bzlXsfQxdS/7CRLXr5J2+pt3ukm33vyVA4DMqDi8cFhoTXKuvSX2e0T16s3UQwpS+YHt9Lv69rtA1mtP3QdSiEXMQ433VIxlFtmH6xsPVLHmYrVd/uLzWL8SyzY8YR0aVSbtisY353O26fvfoWCUAu0
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8DD2316D267354785B3EC7E53B67545@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a5fda425-7fa4-4b27-6495-08d77ffb1287
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 18:34:22.1925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xLjLXZ5H92DfTJRX+fzlTJqHQV1iJOu3bQam5Zip1jj/UcKqmKJUlppbpEQWIZko
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1564
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_05:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912130143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzExLzE5IDI6MzMgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IEZyb206IFlv
bmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+IA0KPiBUZXN0ZWQgYnBmX21hcF9sb29rdXBfYmF0
Y2goKSwgYnBmX21hcF9sb29rdXBfYW5kX2RlbGV0ZV9iYXRjaCgpLA0KPiBicGZfbWFwX3VwZGF0
ZV9iYXRjaCgpLCBhbmQgYnBmX21hcF9kZWxldGVfYmF0Y2goKSBmdW5jdGlvbmFsaXR5Lg0KPiAg
ICAkIC4vdGVzdF9tYXBzDQo+ICAgICAgLi4uDQo+ICAgICAgICB0ZXN0X2h0YWJfbWFwX2JhdGNo
X29wczpQQVNTDQo+ICAgICAgICB0ZXN0X2h0YWJfcGVyY3B1X21hcF9iYXRjaF9vcHM6UEFTUw0K
PiAgICAgIC4uLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogQnJpYW4gVmF6cXVleiA8YnJpYW52dkBnb29nbGUuY29tPg0K
PiAtLS0NCj4gICAuLi4vYnBmL21hcF90ZXN0cy9odGFiX21hcF9iYXRjaF9vcHMuYyAgICAgICAg
fCAyNjkgKysrKysrKysrKysrKysrKysrDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDI2OSBpbnNlcnRp
b25zKCspDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2Jw
Zi9tYXBfdGVzdHMvaHRhYl9tYXBfYmF0Y2hfb3BzLmMNCj4gDQo+IGRpZmYgLS1naXQgYS90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvbWFwX3Rlc3RzL2h0YWJfbWFwX2JhdGNoX29wcy5jIGIv
dG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL21hcF90ZXN0cy9odGFiX21hcF9iYXRjaF9vcHMu
Yw0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAwLi5kYWJjNGQ0
MjBhMTBlDQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
YnBmL21hcF90ZXN0cy9odGFiX21hcF9iYXRjaF9vcHMuYw0KPiBAQCAtMCwwICsxLDI2OSBAQA0K
PiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gKy8qIENvcHlyaWdodCAo
YykgMjAxOSBGYWNlYm9vayAgKi8NCj4gKyNpbmNsdWRlIDxzdGRpby5oPg0KPiArI2luY2x1ZGUg
PGVycm5vLmg+DQo+ICsjaW5jbHVkZSA8c3RyaW5nLmg+DQo+ICsNCj4gKyNpbmNsdWRlIDxicGYv
YnBmLmg+DQo+ICsjaW5jbHVkZSA8YnBmL2xpYmJwZi5oPg0KPiArDQo+ICsjaW5jbHVkZSA8YnBm
X3V0aWwuaD4NCj4gKyNpbmNsdWRlIDx0ZXN0X21hcHMuaD4NCj4gKw0KPiArc3RhdGljIHZvaWQg
bWFwX2JhdGNoX3VwZGF0ZShpbnQgbWFwX2ZkLCBfX3UzMiBtYXhfZW50cmllcywgaW50ICprZXlz
LA0KPiArCQkJICAgICB2b2lkICp2YWx1ZXMsIGJvb2wgaXNfcGNwdSkNCj4gK3sNCj4gKwl0eXBl
ZGVmIEJQRl9ERUNMQVJFX1BFUkNQVShpbnQsIHZhbHVlKTsNCj4gKwlpbnQgaSwgaiwgZXJyOw0K
PiArCXZhbHVlICp2Ow0KPiArDQo+ICsJaWYgKGlzX3BjcHUpDQo+ICsJCXYgPSAodmFsdWUgKil2
YWx1ZXM7DQo+ICsNCj4gKwlmb3IgKGkgPSAwOyBpIDwgbWF4X2VudHJpZXM7IGkrKykgew0KPiAr
CQlrZXlzW2ldID0gaSArIDE7DQo+ICsJCWlmIChpc19wY3B1KQ0KPiArCQkJZm9yIChqID0gMDsg
aiA8IGJwZl9udW1fcG9zc2libGVfY3B1cygpOyBqKyspDQo+ICsJCQkJYnBmX3BlcmNwdSh2W2ld
LCBqKSA9IGkgKyAyICsgajsNCj4gKwkJZWxzZQ0KPiArCQkJKChpbnQgKil2YWx1ZXMpW2ldID0g
aSArIDI7DQo+ICsJfQ0KPiArDQo+ICsJZXJyID0gYnBmX21hcF91cGRhdGVfYmF0Y2gobWFwX2Zk
LCBrZXlzLCB2YWx1ZXMsICZtYXhfZW50cmllcywgMCwgMCk7DQo+ICsJQ0hFQ0soZXJyLCAiYnBm
X21hcF91cGRhdGVfYmF0Y2goKSIsICJlcnJvcjolc1xuIiwgc3RyZXJyb3IoZXJybm8pKTsNCj4g
K30NCj4gKw0KPiArc3RhdGljIHZvaWQgbWFwX2JhdGNoX3ZlcmlmeShpbnQgKnZpc2l0ZWQsIF9f
dTMyIG1heF9lbnRyaWVzLA0KPiArCQkJICAgICBpbnQgKmtleXMsIHZvaWQgKnZhbHVlcywgYm9v
bCBpc19wY3B1KQ0KPiArew0KPiArCXR5cGVkZWYgQlBGX0RFQ0xBUkVfUEVSQ1BVKGludCwgdmFs
dWUpOw0KPiArCXZhbHVlICp2Ow0KPiArCWludCBpLCBqOw0KPiArDQo+ICsJaWYgKGlzX3BjcHUp
DQo+ICsJCXYgPSAodmFsdWUgKil2YWx1ZXM7DQo+ICsNCj4gKwltZW1zZXQodmlzaXRlZCwgMCwg
bWF4X2VudHJpZXMgKiBzaXplb2YoKnZpc2l0ZWQpKTsNCj4gKwlmb3IgKGkgPSAwOyBpIDwgbWF4
X2VudHJpZXM7IGkrKykgew0KPiArDQo+ICsJCWlmIChpc19wY3B1KSB7DQo+ICsJCQlmb3IgKGog
PSAwOyBqIDwgYnBmX251bV9wb3NzaWJsZV9jcHVzKCk7IGorKykgew0KPiArCQkJCUNIRUNLKGtl
eXNbaV0gKyAxICsgaiAhPSBicGZfcGVyY3B1KHZbaV0sIGopLA0KPiArCQkJCSAgICAgICJrZXkv
dmFsdWUgY2hlY2tpbmciLA0KPiArCQkJCSAgICAgICJlcnJvcjogaSAlZCBqICVkIGtleSAlZCB2
YWx1ZSAlZFxuIiwNCj4gKwkJCQkgICAgICBpLCBqLCBrZXlzW2ldLCBicGZfcGVyY3B1KHZbaV0s
ICBqKSk7DQo+ICsJCQl9DQo+ICsJCX0gZWxzZSB7DQo+ICsJCQlDSEVDSyhrZXlzW2ldICsgMSAh
PSAoKGludCAqKXZhbHVlcylbaV0sDQo+ICsJCQkgICAgICAia2V5L3ZhbHVlIGNoZWNraW5nIiwN
Cj4gKwkJCSAgICAgICJlcnJvcjogaSAlZCBrZXkgJWQgdmFsdWUgJWRcbiIsIGksIGtleXNbaV0s
DQo+ICsJCQkgICAgICAoKGludCAqKXZhbHVlcylbaV0pOw0KPiArCQl9DQo+ICsNCj4gKwkJdmlz
aXRlZFtpXSA9IDE7DQo+ICsNCj4gKwl9DQo+ICsJZm9yIChpID0gMDsgaSA8IG1heF9lbnRyaWVz
OyBpKyspIHsNCj4gKwkJQ0hFQ0sodmlzaXRlZFtpXSAhPSAxLCAidmlzaXRlZCBjaGVja2luZyIs
DQo+ICsJCSAgICAgICJlcnJvcjoga2V5cyBhcnJheSBhdCBpbmRleCAlZCBtaXNzaW5nXG4iLCBp
KTsNCj4gKwl9DQo+ICt9DQo+ICsNCj4gK3ZvaWQgX190ZXN0X21hcF9sb29rdXBfYW5kX2RlbGV0
ZV9iYXRjaChib29sIGlzX3BjcHUpDQo+ICt7DQo+ICsJaW50IG1hcF90eXBlID0gaXNfcGNwdSA/
IEJQRl9NQVBfVFlQRV9QRVJDUFVfSEFTSCA6IEJQRl9NQVBfVFlQRV9IQVNIOw0KPiArCXN0cnVj
dCBicGZfY3JlYXRlX21hcF9hdHRyIHhhdHRyID0gew0KPiArCQkubmFtZSA9ICJoYXNoX21hcCIs
DQo+ICsJCS5tYXBfdHlwZSA9IG1hcF90eXBlLA0KPiArCQkua2V5X3NpemUgPSBzaXplb2YoaW50
KSwNCj4gKwkJLnZhbHVlX3NpemUgPSBzaXplb2YoaW50KSwNCj4gKwl9Ow0KPiArCV9fdTMyIGJh
dGNoLCBjb3VudCwgdG90YWwsIHRvdGFsX3N1Y2Nlc3M7DQo+ICsJdHlwZWRlZiBCUEZfREVDTEFS
RV9QRVJDUFUoaW50LCB2YWx1ZSk7DQo+ICsJaW50IG1hcF9mZCwgKmtleXMsICp2aXNpdGVkLCBr
ZXk7DQo+ICsJY29uc3QgX191MzIgbWF4X2VudHJpZXMgPSAxMDsNCj4gKwlpbnQgZXJyLCBzdGVw
LCB2YWx1ZV9zaXplOw0KPiArCXZhbHVlIHBjcHVfdmFsdWVzWzEwXTsNCj4gKwlib29sIG5vc3Bh
Y2VfZXJyOw0KPiArCXZvaWQgKnZhbHVlczsNCj4gKw0KPiArCXhhdHRyLm1heF9lbnRyaWVzID0g
bWF4X2VudHJpZXM7DQo+ICsJbWFwX2ZkID0gYnBmX2NyZWF0ZV9tYXBfeGF0dHIoJnhhdHRyKTsN
Cj4gKwlDSEVDSyhtYXBfZmQgPT0gLTEsDQo+ICsJICAgICAgImJwZl9jcmVhdGVfbWFwX3hhdHRy
KCkiLCAiZXJyb3I6JXNcbiIsIHN0cmVycm9yKGVycm5vKSk7DQo+ICsNCj4gKwl2YWx1ZV9zaXpl
ID0gaXNfcGNwdSA/IHNpemVvZih2YWx1ZSkgOiBzaXplb2YoaW50KTsNCj4gKwlrZXlzID0gbWFs
bG9jKG1heF9lbnRyaWVzICogc2l6ZW9mKGludCkpOw0KPiArCWlmIChpc19wY3B1KQ0KPiArCQl2
YWx1ZXMgPSBwY3B1X3ZhbHVlczsNCj4gKwllbHNlDQo+ICsJCXZhbHVlcyA9IG1hbGxvYyhtYXhf
ZW50cmllcyAqIHNpemVvZihpbnQpKTsNCj4gKwl2aXNpdGVkID0gbWFsbG9jKG1heF9lbnRyaWVz
ICogc2l6ZW9mKGludCkpOw0KPiArCUNIRUNLKCFrZXlzIHx8ICF2YWx1ZXMgfHwgIXZpc2l0ZWQs
ICJtYWxsb2MoKSIsDQo+ICsJICAgICAgImVycm9yOiVzXG4iLCBzdHJlcnJvcihlcnJubykpOw0K
DQpTb3JyeSwgSSBtaXNzZWQgaXQuIHRoZSBtYWxsY29lZCBrZXlzL3Zpc2l0ZWQgbWVtb3J5IHJl
Z2lvbiBzaG91bGQNCmJlIGZyZWVkIGF0IHRoZSBlbmQgb2YgdGhlIHRlc3QuIFRoZSBzYW1lIGZv
ciBvdGhlciB0ZXN0cy4NCg0KPiArDQo+ICsJLyogdGVzdCAxOiBsb29rdXAvZGVsZXRlIGFuIGVt
cHR5IGhhc2ggdGFibGUsIC1FTk9FTlQgKi8NCj4gKwljb3VudCA9IG1heF9lbnRyaWVzOw0KPiAr
CWVyciA9IGJwZl9tYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2gobWFwX2ZkLCBOVUxMLCAmYmF0
Y2gsIGtleXMsDQo+ICsJCQkJCSAgICAgIHZhbHVlcywgJmNvdW50LCAwLCAwKTsNCj4gKwlDSEVD
SygoZXJyICYmIGVycm5vICE9IEVOT0VOVCksICJlbXB0eSBtYXAiLA0KPiArCSAgICAgICJlcnJv
cjogJXNcbiIsIHN0cmVycm9yKGVycm5vKSk7DQo+ICsNCj4gKwkvKiBwb3B1bGF0ZSBlbGVtZW50
cyB0byB0aGUgbWFwICovDQo+ICsJbWFwX2JhdGNoX3VwZGF0ZShtYXBfZmQsIG1heF9lbnRyaWVz
LCBrZXlzLCB2YWx1ZXMsIGlzX3BjcHUpOw0KPiArDQo+ICsJLyogdGVzdCAyOiBsb29rdXAvZGVs
ZXRlIHdpdGggY291bnQgPSAwLCBzdWNjZXNzICovDQo+ICsJY291bnQgPSAwOw0KPiArCWVyciA9
IGJwZl9tYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2gobWFwX2ZkLCBOVUxMLCAmYmF0Y2gsIGtl
eXMsDQo+ICsJCQkJCSAgICAgIHZhbHVlcywgJmNvdW50LCAwLCAwKTsNCj4gKwlDSEVDSyhlcnIs
ICJjb3VudCA9IDAiLCAiZXJyb3I6ICVzXG4iLCBzdHJlcnJvcihlcnJubykpOw0KPiArDQo+ICsJ
LyogdGVzdCAzOiBsb29rdXAvZGVsZXRlIHdpdGggY291bnQgPSBtYXhfZW50cmllcywgc3VjY2Vz
cyAqLw0KPiArCW1lbXNldChrZXlzLCAwLCBtYXhfZW50cmllcyAqIHNpemVvZigqa2V5cykpOw0K
PiArCW1lbXNldCh2YWx1ZXMsIDAsIG1heF9lbnRyaWVzICogdmFsdWVfc2l6ZSk7DQo+ICsJY291
bnQgPSBtYXhfZW50cmllczsNCj4gKwllcnIgPSBicGZfbWFwX2xvb2t1cF9hbmRfZGVsZXRlX2Jh
dGNoKG1hcF9mZCwgTlVMTCwgJmJhdGNoLCBrZXlzLA0KPiArCQkJCQkgICAgICB2YWx1ZXMsICZj
b3VudCwgMCwgMCk7DQo+ICsJQ0hFQ0soKGVyciAmJiBlcnJubyAhPSBFTk9FTlQpLCAiY291bnQg
PSBtYXhfZW50cmllcyIsDQo+ICsJICAgICAgICJlcnJvcjogJXNcbiIsIHN0cmVycm9yKGVycm5v
KSk7DQo+ICsJQ0hFQ0soY291bnQgIT0gbWF4X2VudHJpZXMsICJjb3VudCA9IG1heF9lbnRyaWVz
IiwNCj4gKwkgICAgICAiY291bnQgPSAldSwgbWF4X2VudHJpZXMgPSAldVxuIiwgY291bnQsIG1h
eF9lbnRyaWVzKTsNCj4gKwltYXBfYmF0Y2hfdmVyaWZ5KHZpc2l0ZWQsIG1heF9lbnRyaWVzLCBr
ZXlzLCB2YWx1ZXMsIGlzX3BjcHUpOw0KPiArDQo+ICsJLyogYnBmX21hcF9nZXRfbmV4dF9rZXko
KSBzaG91bGQgcmV0dXJuIC1FTk9FTlQgZm9yIGFuIGVtcHR5IG1hcC4gKi8NCj4gKwllcnIgPSBi
cGZfbWFwX2dldF9uZXh0X2tleShtYXBfZmQsIE5VTEwsICZrZXkpOw0KPiArCUNIRUNLKCFlcnIs
ICJicGZfbWFwX2dldF9uZXh0X2tleSgpIiwgImVycm9yOiAlc1xuIiwgc3RyZXJyb3IoZXJybm8p
KTsNCj4gKw0KWy4uLl0NCg==
