Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A21465000
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 03:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfGKBxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 21:53:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34758 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727188AbfGKBxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 21:53:31 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6B1qVr1015850;
        Wed, 10 Jul 2019 18:53:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1reNQlqbWVIyciXJ0XgEGuqh4vr+83chPJ0kC2FEwOo=;
 b=U+Duld5+jDrt9KMrw1hEfn3BLV7WBqaWf7iOa60spuc+otp5pmnPZRCxOGcCJiONKGkQ
 SDzpJkQB3PMnMjhx7myBDaf0eRpVDq468i/MrOJLgik/AVPpsbV2Ez24PiXAIUSFE/oK
 O/qSsnuA0/W3FZ2SiasWGbuXlbtWtGUbPTc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tnhfc30gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Jul 2019 18:53:09 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 10 Jul 2019 18:53:08 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 10 Jul 2019 18:53:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1reNQlqbWVIyciXJ0XgEGuqh4vr+83chPJ0kC2FEwOo=;
 b=HW74b+fLxHeGV1AzYd3k0wJwI7XBdo+MxKOgK2LNvZv6sGQG8RE8d8jCZGQYmu6juDSUevRDWCV6UjiMz+q1Gg2obOce0V6QdoxriN7h+35tMLIdDAGEnEk6hqe6/Yq03YfrF8gNSfCPjm2VDp76LEee2O+56LrE5iWU335aEbk=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2806.namprd15.prod.outlook.com (20.179.158.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 11 Jul 2019 01:53:07 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2073.008; Thu, 11 Jul 2019
 01:53:07 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf] bpf: fix BTF verifier size resolution logic
Thread-Topic: [PATCH bpf] bpf: fix BTF verifier size resolution logic
Thread-Index: AQHVNvb9OTRSXZV6J0yyn1q3qDFOw6bEGJAAgAB44wCAAAH/gIAAEy4AgAACMoA=
Date:   Thu, 11 Jul 2019 01:53:06 +0000
Message-ID: <eebd6ac9-d968-9efb-db07-e5d877f7ae4c@fb.com>
References: <20190710080840.2613160-1-andriin@fb.com>
 <f6bc7a95-e8e1-eec4-9728-3b9e36b434fa@fb.com>
 <CAEf4BzaVouFd=3whC1EjhQ9mit62b-C+NhQuW4RiXW02Rq_1Ug@mail.gmail.com>
 <304d8535-5043-836d-2933-1a5efb7aec72@fb.com>
 <CAEf4Bza6Y87C2_Fobj9CwU-2YRTU32S61f8_8CQdhMPenJiJZQ@mail.gmail.com>
In-Reply-To: <CAEf4Bza6Y87C2_Fobj9CwU-2YRTU32S61f8_8CQdhMPenJiJZQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0013.namprd14.prod.outlook.com
 (2603:10b6:301:4b::23) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:fea5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98a04fa7-453a-4359-a73c-08d705a284cf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2806;
x-ms-traffictypediagnostic: BYAPR15MB2806:
x-microsoft-antispam-prvs: <BYAPR15MB28069322FEFCF01FB1362349D3F30@BYAPR15MB2806.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(396003)(346002)(376002)(199004)(189003)(51444003)(86362001)(256004)(14444005)(31696002)(54906003)(316002)(99286004)(66476007)(66556008)(76176011)(6506007)(64756008)(66446008)(66946007)(53936002)(386003)(6246003)(53546011)(6916009)(102836004)(52116002)(71200400001)(6512007)(478600001)(71190400001)(7736002)(2616005)(81156014)(81166006)(8676002)(4326008)(25786009)(186003)(5660300002)(36756003)(11346002)(446003)(305945005)(31686004)(6436002)(46003)(486006)(476003)(14454004)(6486002)(6116002)(68736007)(2906002)(229853002)(8936002)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2806;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 21uyIwD4v+cFkbt+kDkuLFviEs2nIazV1zisvg9hwfSfY9eeyDVuC4qP3dN2m8Rk0gMh7fx6VZd/wtgPXrxZ9dAp7TFp1bTY/ueb1wYxwEsKeSpVBXaDMhEAsGXgPyRqVfbr9GUG9TmROSMoL7AyeQcZazU8U6V+hEhmDIHhlBbl8zEaV4WIRDtVcgzTaUpFQS5W2VzPn9f9hnvx8wifr1agJLqVRKX0oBRz+63C7g4KSLkFBGUFaPLptlWMgzzJV+Zg+9gD0T4S/By9cZ/sWXKb0Jh2EnloC1fonjT/KpCxgSQyPfFNsWUFwfCxAcy4zgswy6N+/WuWWnSzi5BnjaLfxZFsEVbsphbT29MOuHuTYZAeDgNJgqjE3GNe4yN7GSB0QpKu0UilxS2x0k0GW2GGZHT4txlowere0CcY5Ts=
Content-Type: text/plain; charset="utf-8"
Content-ID: <672816790DE20443B63203A16D7CFF7A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a04fa7-453a-4359-a73c-08d705a284cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 01:53:06.9285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2806
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110022
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTAvMTkgNjo0NSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBXZWQs
IEp1bCAxMCwgMjAxOSBhdCA1OjM2IFBNIFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+IHdyb3Rl
Og0KPj4NCj4+DQo+Pg0KPj4gT24gNy8xMC8xOSA1OjI5IFBNLCBBbmRyaWkgTmFrcnlpa28gd3Jv
dGU6DQo+Pj4gT24gV2VkLCBKdWwgMTAsIDIwMTkgYXQgNToxNiBQTSBZb25naG9uZyBTb25nIDx5
aHNAZmIuY29tPiB3cm90ZToNCj4+Pj4NCj4+Pj4NCj4+Pj4NCj4+Pj4gT24gNy8xMC8xOSAxOjA4
IEFNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+Pj4+PiBCVEYgdmVyaWZpZXIgaGFzIERpZmZl
cmVudCBsb2dpYyBkZXBlbmRpbmcgb24gd2hldGhlciB3ZSBhcmUgZm9sbG93aW5nDQo+Pj4+PiBh
IFBUUiBvciBTVFJVQ1QvQVJSQVkgKG9yIHNvbWV0aGluZyBlbHNlKS4gVGhpcyBpcyBhbiBvcHRp
bWl6YXRpb24gdG8NCj4+Pj4+IHN0b3AgZWFybHkgaW4gREZTIHRyYXZlcnNhbCB3aGlsZSByZXNv
bHZpbmcgQlRGIHR5cGVzLiBCdXQgaXQgYWxzbw0KPj4+Pj4gcmVzdWx0cyBpbiBhIHNpemUgcmVz
b2x1dGlvbiBidWcsIHdoZW4gdGhlcmUgaXMgYSBjaGFpbiwgZS5nLiwgb2YgUFRSIC0+DQo+Pj4+
PiBUWVBFREVGIC0+IEFSUkFZLCBpbiB3aGljaCBjYXNlIGR1ZSB0byBiZWluZyBpbiBwb2ludGVy
IGNvbnRleHQgQVJSQVkNCj4+Pj4+IHNpemUgd29uJ3QgYmUgcmVzb2x2ZWQsIGFzIGl0IGlzIGNv
bnNpZGVyZWQgdG8gYmUgYSBzaW5rIGZvciBwb2ludGVyLA0KPj4+Pj4gbGVhZGluZyB0byBUWVBF
REVGIGJlaW5nIGluIFJFU09MVkVEIHN0YXRlIHdpdGggemVybyBzaXplLCB3aGljaCBpcw0KPj4+
Pj4gY29tcGxldGVseSB3cm9uZy4NCj4+Pj4+DQo+Pj4+PiBPcHRpbWl6YXRpb24gaXMgZG91YnRm
dWwsIHRob3VnaCwgYXMgYnRmX2NoZWNrX2FsbF90eXBlcygpIHdpbGwgaXRlcmF0ZQ0KPj4+Pj4g
b3ZlciBhbGwgQlRGIHR5cGVzIGFueXdheXMsIHNvIHRoZSBvbmx5IHNhdmluZyBpcyBhIHBvdGVu
dGlhbGx5IHNsaWdodGx5DQo+Pj4+PiBzaG9ydGVyIHN0YWNrLiBCdXQgY29ycmVjdG5lc3MgaXMg
bW9yZSBpbXBvcnRhbnQgdGhhdCB0aW55IHNhdmluZ3MuDQo+Pj4+Pg0KPj4+Pj4gVGhpcyBidWcg
bWFuaWZlc3RzIGl0c2VsZiBpbiByZWplY3RpbmcgQlRGLWRlZmluZWQgbWFwcyB0aGF0IHVzZSBh
cnJheQ0KPj4+Pj4gdHlwZWRlZiBhcyBhIHZhbHVlIHR5cGU6DQo+Pj4+Pg0KPj4+Pj4gdHlwZWRl
ZiBpbnQgYXJyYXlfdFsxNl07DQo+Pj4+Pg0KPj4+Pj4gc3RydWN0IHsNCj4+Pj4+ICAgICAgICAg
X191aW50KHR5cGUsIEJQRl9NQVBfVFlQRV9BUlJBWSk7DQo+Pj4+PiAgICAgICAgIF9fdHlwZSh2
YWx1ZSwgYXJyYXlfdCk7IC8qIGkuZS4sIGFycmF5X3QgKnZhbHVlOyAqLw0KPj4+Pj4gfSB0ZXN0
X21hcCBTRUMoIi5tYXBzIik7DQo+Pj4+Pg0KPj4+Pj4gRml4ZXM6IGViM2Y1OTVkYWI0MCAoImJw
ZjogYnRmOiBWYWxpZGF0ZSB0eXBlIHJlZmVyZW5jZSIpDQo+Pj4+PiBDYzogTWFydGluIEthRmFp
IExhdSA8a2FmYWlAZmIuY29tPg0KPj4+Pj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtv
IDxhbmRyaWluQGZiLmNvbT4NCj4+Pj4NCj4+Pj4gVGhlIGNoYW5nZSBzZWVtcyBva2F5IHRvIG1l
LiBDdXJyZW50bHksIGxvb2tzIGxpa2UgaW50ZXJtZWRpYXRlDQo+Pj4+IG1vZGlmaWVyIHR5cGUg
d2lsbCBjYXJyeSBzaXplID0gMCAoaW4gdGhlIGludGVybmFsIGRhdGEgc3RydWN0dXJlKS4NCj4+
Pg0KPj4+IFllcywgd2hpY2ggaXMgdG90YWxseSB3cm9uZywgZXNwZWNpYWxseSB0aGF0IHdlIHVz
ZSB0aGF0IHNpemUgaW4gc29tZQ0KPj4+IGNhc2VzIHRvIHJlamVjdCBtYXAgd2l0aCBzcGVjaWZp
ZWQgQlRGLg0KPj4+DQo+Pj4+DQo+Pj4+IElmIHdlIHJlbW92ZSBSRVNPTFZFIGxvZ2ljLCB3ZSBw
cm9iYWJseSB3YW50IHRvIGRvdWJsZSBjaGVjaw0KPj4+PiB3aGV0aGVyIHdlIGhhbmRsZSBjaXJj
dWxhciB0eXBlcyBjb3JyZWN0bHkgb3Igbm90LiBNYXliZSB3ZSB3aWxsDQo+Pj4+IGJlIG9rYXkg
aWYgYWxsIHNlbGYgdGVzdHMgcGFzcy4NCj4+Pg0KPj4+IEkgY2hlY2tlZCwgaXQgZG9lcy4gV2Un
bGwgYXR0ZW1wdCB0byBhZGQgcmVmZXJlbmNlZCB0eXBlIHVubGVzcyBpdCdzIGENCj4+PiAicmVz
b2x2ZSBzaW5rIiAod2hlcmUgc2l6ZSBpcyBpbW1lZGlhdGVseSBrbm93bikgb3IgaXMgYWxyZWFk
eQ0KPj4+IHJlc29sdmVkIChpdCdzIHN0YXRlIGlzIFJFU09MVkVEKS4gSW4gb3RoZXIgY2FzZXMs
IHdlJ2xsIGF0dGVtcHQgdG8NCj4+PiBlbnZfc3RhY2tfcHVzaCgpLCB3aGljaCBjaGVjayB0aGF0
IHRoZSBzdGF0ZSBvZiB0aGF0IHR5cGUgaXMNCj4+PiBOT1RfVklTSVRFRC4gSWYgaXQncyBSRVNP
TFZFRCBvciBWSVNJVEVELCBpdCByZXR1cm5zIC1FRVhJU1RTLiBXaGVuDQo+Pj4gdHlwZSBpcyBh
ZGRlZCBpbnRvIHRoZSBzdGFjaywgaXQncyByZXNvbHZlIHN0YXRlIGdvZXMgZnJvbSBOT1RfVklT
SVRFRA0KPj4+IHRvIFZJU0lURUQuDQo+Pj4NCj4+PiBTbywgaWYgdGhlcmUgaXMgYSBsb29wLCB0
aGVuIHdlJ2xsIGRldGVjdCBpdCBhcyBzb29uIGFzIHdlJ2xsIGF0dGVtcHQNCj4+PiB0byBhZGQg
dGhlIHNhbWUgdHlwZSBvbnRvIHRoZSBzdGFjayBzZWNvbmQgdGltZS4NCj4+Pg0KPj4+Pg0KPj4+
PiBJIG1heSBzdGlsbCBiZSB3b3J0aHdoaWxlIHRvIHF1YWxpZnkgdGhlIFJFU09MVkUgb3B0aW1p
emF0aW9uIGJlbmVmaXQNCj4+Pj4gYmVmb3JlIHJlbW92aW5nIGl0Lg0KPj4+DQo+Pj4gSSBkb24n
dCB0aGluayB0aGVyZSBpcyBhbnksIGJlY2F1c2UgZXZlcnkgdHlwZSB3aWxsIGJlIHZpc2l0ZWQg
ZXhhY3RseQ0KPj4+IG9uY2UsIGR1ZSB0byBERlMgbmF0dXJlIG9mIGFsZ29yaXRobS4gVGhlIG9u
bHkgZGlmZmVyZW5jZSBpcyB0aGF0IGlmDQo+Pj4gd2UgaGF2ZSBhIGxvbmcgY2hhaW4gb2YgbW9k
aWZpZXJzLCB3ZSBjYW4gdGVjaG5pY2FsbHkgcmVhY2ggdGhlIG1heA0KPj4+IGxpbWl0IGFuZCBm
YWlsLiBCdXQgYXQgMzIgSSB0aGluayBpdCdzIHByZXR0eSB1bnJlYWxpc3RpYyB0byBoYXZlIHN1
Y2gNCj4+PiBhIGxvbmcgY2hhaW4gb2YgUFRSL1RZUEVERUYvQ09OU1QvVk9MQVRJTEUvUkVTVFJJ
Q1RzIDopDQo+Pj4NCj4+Pj4NCj4+Pj4gQW5vdGhlciBwb3NzaWJsZSBjaGFuZ2UgaXMsIGZvciBl
eHRlcm5hbCB1c2FnZSwgcmVtb3ZpbmcNCj4+Pj4gbW9kaWZpZXJzLCBiZWZvcmUgY2hlY2tpbmcg
dGhlIHNpemUsIHNvbWV0aGluZyBsaWtlIGJlbG93Lg0KPj4+PiBOb3RlIHRoYXQgSSBhbSBub3Qg
c3Ryb25nbHkgYWR2b2NhdGluZyBteSBiZWxvdyBwYXRjaCBhcw0KPj4+PiBpdCBoYXMgdGhlIHNh
bWUgc2hvcnRjb21pbmcgdGhhdCBtYWludGFpbmVkIG1vZGlmaWVyIHR5cGUNCj4+Pj4gc2l6ZSBt
YXkgbm90IGJlIGNvcnJlY3QuDQo+Pj4NCj4+PiBJIGRvbid0IHRoaW5rIHlvdXIgcGF0Y2ggaGVs
cHMsIGl0IGNhbiBhY3R1YWxseSBjb25mdXNlIHRoaW5ncyBldmVuDQo+Pj4gbW9yZS4gSXQgc2tp
cHMgbW9kaWZpZXJzIHVudGlsIHVuZGVybHlpbmcgdHlwZSBpcyBmb3VuZCwgYnV0IHlvdSBzdGls
bA0KPj4+IGRvbid0IGd1YXJhbnRlZSB0aGF0IGF0IHRoYXQgdGltZSB0aGF0IHVuZGVybHlpbmcg
dHlwZSB3aWxsIGhhdmUgaXRzDQo+Pj4gc2l6ZSByZXNvbHZlZC4NCj4+DQo+PiBJdCBhY3R1YWxs
eSBkb2VzIGhlbHAuIEl0IGRvZXMgbm90IGNoYW5nZSB0aGUgaW50ZXJuYWwgYnRmIHR5cGUNCj4+
IHRyYXZlcnNhbCBhbGdvcml0aG1zLiBJdCBvbmx5IGNoYW5nZSB0aGUgaW1wbGVtZW50YXRpb24g
b2YNCj4+IGFuIGV4dGVybmFsIEFQSSBidGZfdHlwZV9pZF9zaXplKCkuIFByZXZpb3VzbHksIHRo
aXMgZnVuY3Rpb24NCj4+IGlzIHVzZWQgYnkgZXh0ZXJuYWxzIGFuZCBpbnRlcm5hbCBidGYuYy4g
SSBicm9rZSBpdCBpbnRvIHR3bywNCj4+IG9uZSBpbnRlcm5hbCBfX2J0Zl90eXBlX2lkX3NpemUo
KSwgYW5kIGFub3RoZXIgZXh0ZXJuYWwNCj4+IGJ0Zl90eXBlX2lkX3NpemUoKS4gVGhlIGV4dGVy
bmFsIG9uZSByZW1vdmVzIG1vZGlmaWVyIGJlZm9yZQ0KPj4gZmluZGluZyB0eXBlIHNpemUuIFRo
ZSBleHRlcm5hbCBvbmUgaXMgdHlwaWNhbGx5IHVzZWQgb25seQ0KPj4gYWZ0ZXIgYnRmIGlzIHZh
bGlkYXRlZC4NCj4gDQo+IFN1cmUsIGZvciBleHRlcm5hbCBjYWxsZXJzIHllcywgaXQgc29sdmVz
IHRoZSBwcm9ibGVtLiBCdXQgdGhlcmUgaXMNCj4gZGVlcGVyIHByb2JsZW06IHdlIG1hcmsgbW9k
aWZpZXIgdHlwZXMgUkVTT0xWRUQgYmVmb3JlIHR5cGVzIHRoZXkNCj4gdWx0aW1hdGVseSBwb2lu
dCB0byBhcmUgcmVzb2x2ZWQuIFRoZW4gaW4gYWxsIHRob3NlIGJ0Zl94eHhfcmVzb2x2ZSgpDQo+
IGZ1bmN0aW9ucyB3ZSBoYXZlIGNoZWNrOg0KPiANCj4gaWYgKCFlbnZfdHlwZV9pc19yZXNvbHZl
X3NpbmsgJiYgIWVudl90eXBlX2lzX3Jlc29sdmVkKQ0KPiAgICByZXR1cm4gZW52X3N0YWNrX3B1
c2goKTsNCj4gZWxzZSB7DQo+IA0KPiAgICAvKiBoZXJlIHdlIGFzc3VtZSB0aGF0IHdlIGNhbiBj
YWxjdWxhdGUgc2l6ZSBvZiB0aGUgdHlwZSAqLw0KPiAgICAvKiBzbyBldmVuIGlmIHdlIHRyYXZl
cnNlIHRocm91Z2ggYWxsIHRoZSBtb2RpZmllcnMgYW5kIGZpbmQNCj4gdW5kZXJseWluZyB0eXBl
ICovDQo+ICAgIC8qIHRoYXQgdHlwZSB3aWxsIGhhdmUgcmVzb2x2ZWRfc2l6ZSA9IDAsIGJlY2F1
c2Ugd2UgaGF2ZW4ndA0KPiBwcm9jZXNzZWQgaXQgeWV0ICovDQo+ICAgIC8qIGJ1dCB3ZSB3aWxs
IGp1c3QgaW5jb3JyZWN0bHkgYXNzdW1lIHRoYXQgemVybyBpcyAqZmluYWwqIHNpemUgKi8NCj4g
fQ0KPiANCj4gU28gSSB0aGluayB0aGF0IHlvdXIgcGF0Y2ggaXMgc3RpbGwganVzdCBoaWRpbmcg
dGhlIHByb2JsZW0sIG5vdCBzb2x2aW5nIGl0Lg0KDQpUaGF0IGlzIHdoeSBJIGFtIG5vdCBhZHZv
Y2F0aW5nIGl0Lg0KDQpUaGUgcmVhbGx5IGxvbmcgbW9kaWZpZXIgY2hhaW4gKGNvbnN0IHZvbGF0
aWxlIHJlc3RyaWN0IC4uLikgaXMgcmFyZS4NClNvIEkgYWdyZWUgcmVtb3ZpbmcgdGhpcyBSRVNP
TFZFIGxvZ2ljIGlzIG9rYXkuDQoNCj4gDQo+IEJUVywgSSd2ZSBhbHNvIGlkZW50aWZpZWQgcGFy
dCBvZiBidGZfcHRyX3Jlc29sdmUoKSBsb2dpYyB0aGF0IGNhbiBiZQ0KPiBub3cgc2FmZWx5IHJl
bW92ZWQgKGl0J3MgYSBzcGVjaWFsIGNhc2UgdGhhdCAicmVzdGFydHMiIERGUyB0cmF2ZXJzYWwN
Cj4gZm9yIG1vZGlmaWVycywgYmVjYXVzZSB0aGV5IGNvdWxkIGhhdmUgYmVlbiBwcmVtYXR1cmVs
eSBtYXJrZWQNCj4gcmVzb2x2ZWQpLiBUaGlzIGlzIGFub3RoZXIgc2lnbiB0aGF0IHRoZXJlIGlz
IHNvbWV0aGluZyB3cm9uZyBpbiBhbg0KPiBhbGdvcml0aG0uDQo+IA0KPiBJJ2QgcmF0aGVyIHJl
bW92ZSB1bm5lY2Vzc2FyeSBjb21wbGV4aXR5IGFuZCBmaXggdW5kZXJseWluZyBwcm9ibGVtLA0K
PiBlc3BlY2lhbGx5IGdpdmVuIHRoYXQgdGhlcmUgaXMgbm8gcGVyZm9ybWFuY2Ugb3IgY29ycmVj
dG5lc3MgcGVuYWx0eS4NCj4gDQo+IEknbGwgcG9zdCB2MiBzb29uLg0KDQpTb3VuZHMgZ29vZC4N
Cg0KPiANCj4+DQo+PiBXaWxsIGdvIHRocm91Z2ggeW91ciBvdGhlciBjb21tZW50cyBsYXRlci4N
Cj4+DQo+Pj4NCj4+Pj4NCj4+Pj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvYnRmLmMgYi9rZXJu
ZWwvYnBmL2J0Zi5jDQo+Pj4+IGluZGV4IDU0NmViZWUzOWUyYS4uNmY5MjdjM2UwYTg5IDEwMDY0
NA0KPj4+PiAtLS0gYS9rZXJuZWwvYnBmL2J0Zi5jDQo+Pj4+ICsrKyBiL2tlcm5lbC9icGYvYnRm
LmMNCj4+Pj4gQEAgLTYyMCw2ICs2MjAsNTQgQEAgc3RhdGljIGJvb2wgYnRmX3R5cGVfaW50X2lz
X3JlZ3VsYXIoY29uc3Qgc3RydWN0DQo+Pj4+IGJ0Zl90eXBlICp0KQ0KPj4+PiAgICAgICAgICAg
IHJldHVybiB0cnVlOw0KPj4+PiAgICAgfQ0KPj4+Pg0KPj4+PiArc3RhdGljIGNvbnN0IHN0cnVj
dCBidGZfdHlwZSAqX19idGZfdHlwZV9pZF9zaXplKGNvbnN0IHN0cnVjdCBidGYgKmJ0ZiwNCj4+
Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHUzMiAq
dHlwZV9pZCwgdTMyDQo+Pj4+ICpyZXRfc2l6ZSwNCj4+Pj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJvb2wgc2tpcF9tb2RpZmllcikNCj4+Pj4gK3sN
Cj4+Pj4gKyAgICAgICBjb25zdCBzdHJ1Y3QgYnRmX3R5cGUgKnNpemVfdHlwZTsNCj4+Pj4gKyAg
ICAgICB1MzIgc2l6ZV90eXBlX2lkID0gKnR5cGVfaWQ7DQo+Pj4+ICsgICAgICAgdTMyIHNpemUg
PSAwOw0KPj4+PiArDQo+Pj4+ICsgICAgICAgc2l6ZV90eXBlID0gYnRmX3R5cGVfYnlfaWQoYnRm
LCBzaXplX3R5cGVfaWQpOw0KPj4+PiArICAgICAgIGlmIChzaXplX3R5cGUgJiYgc2tpcF9tb2Rp
Zmllcikgew0KPj4+PiArICAgICAgICAgICAgICAgd2hpbGUgKGJ0Zl90eXBlX2lzX21vZGlmaWVy
KHNpemVfdHlwZSkpDQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHNpemVfdHlwZSA9IGJ0
Zl90eXBlX2J5X2lkKGJ0Ziwgc2l6ZV90eXBlLT50eXBlKTsNCj4+Pj4gKyAgICAgICB9DQo+Pj4+
ICsNCj4+Pj4gKyAgICAgICBpZiAoYnRmX3R5cGVfbm9zaXplX29yX251bGwoc2l6ZV90eXBlKSkN
Cj4+Pj4gKyAgICAgICAgICAgICAgIHJldHVybiBOVUxMOw0KPj4+PiArDQo+Pj4+ICsgICAgICAg
aWYgKGJ0Zl90eXBlX2hhc19zaXplKHNpemVfdHlwZSkpIHsNCj4+Pj4gKyAgICAgICAgICAgICAg
IHNpemUgPSBzaXplX3R5cGUtPnNpemU7DQo+Pj4+ICsgICAgICAgfSBlbHNlIGlmIChidGZfdHlw
ZV9pc19hcnJheShzaXplX3R5cGUpKSB7DQo+Pj4+ICsgICAgICAgICAgICAgICBzaXplID0gYnRm
LT5yZXNvbHZlZF9zaXplc1tzaXplX3R5cGVfaWRdOw0KPj4+PiArICAgICAgIH0gZWxzZSBpZiAo
YnRmX3R5cGVfaXNfcHRyKHNpemVfdHlwZSkpIHsNCj4+Pj4gKyAgICAgICAgICAgICAgIHNpemUg
PSBzaXplb2Yodm9pZCAqKTsNCj4+Pj4gKyAgICAgICB9IGVsc2Ugew0KPj4+PiArICAgICAgICAg
ICAgICAgaWYgKFdBUk5fT05fT05DRSghYnRmX3R5cGVfaXNfbW9kaWZpZXIoc2l6ZV90eXBlKSAm
Jg0KPj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAhYnRmX3R5cGVfaXNfdmFy
KHNpemVfdHlwZSkpKQ0KPj4+PiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsN
Cj4+Pj4gKw0KPj4+PiArICAgICAgICAgICAgICAgc2l6ZSA9IGJ0Zi0+cmVzb2x2ZWRfc2l6ZXNb
c2l6ZV90eXBlX2lkXTsNCj4+Pj4gKyAgICAgICAgICAgICAgIHNpemVfdHlwZV9pZCA9IGJ0Zi0+
cmVzb2x2ZWRfaWRzW3NpemVfdHlwZV9pZF07DQo+Pj4+ICsgICAgICAgICAgICAgICBzaXplX3R5
cGUgPSBidGZfdHlwZV9ieV9pZChidGYsIHNpemVfdHlwZV9pZCk7DQo+Pj4+ICsgICAgICAgICAg
ICAgICBpZiAoYnRmX3R5cGVfbm9zaXplX29yX251bGwoc2l6ZV90eXBlKSkNCj4+Pj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+Pj4+ICsgICAgICAgfQ0KPj4+PiArDQo+
Pj4+ICsgICAgICAgKnR5cGVfaWQgPSBzaXplX3R5cGVfaWQ7DQo+Pj4+ICsgICAgICAgaWYgKHJl
dF9zaXplKQ0KPj4+PiArICAgICAgICAgICAgICAgKnJldF9zaXplID0gc2l6ZTsNCj4+Pj4gKw0K
Pj4+PiArICAgICAgIHJldHVybiBzaXplX3R5cGU7DQo+Pj4+ICt9DQo+Pj4+ICsNCj4+IFsuLi5d
DQo=
