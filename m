Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C94FE8B5
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfKOXhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:37:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33874 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727056AbfKOXhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:37:34 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFNZh79021423;
        Fri, 15 Nov 2019 15:37:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=npMVu5pHO7NJJVedbXjWKy30JgkzS/1F+/JDDZru1u4=;
 b=AyuOuwCu5GTmy5mVQv9xjC1ZsE+dGT+TwR66plNk/IiEdz4yQpzLPT93H4TjQX32Pd29
 hfoYGLCOLOFGFyUKqckX3Kn4+n0/Q1nBIeDl1tB/5OMe8Sxj6BAm139u9ejKuHAw5iUk
 nRDlROmSY+M+W0/ozAtvjq7V+xS+1qX2lk0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w9umgghdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Nov 2019 15:37:16 -0800
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 15 Nov 2019 15:37:15 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 15 Nov 2019 15:37:15 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 15 Nov 2019 15:37:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6Zc7xV+0H5plSQKU2YjiS96VE447+XJZFBjsyXi3FDIhJRDuZirDTZivQUe66mZ6nx/fHrYUgf8AiGl4Y2FVUH3ynrwMY31xAZZKbiL1OX91s/6ZKigwLvdSGi4NvQpInMMuCTyiCfo2iTaoovTfyRPqbVi2H3eQeAawAsRFsw6YUbj+y4FyB7AchBQpO9992G0/qwj19Dz92MK7qWKxdtQsKRT+cO2kbb2MqrISqVp1C+GHowrAPHpEYRZEHZPM9Ib/LMoUwEAX20DwNk8Kk9WiRGhadyIrh93MsaMro5373q4dFKPnWQvEUmXMp7olCWWUPIfUiTcKBuQj2eFEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npMVu5pHO7NJJVedbXjWKy30JgkzS/1F+/JDDZru1u4=;
 b=glVrLTuQvZU8p2Vy+tRd0A7Df7ZS9DobdQNLOfNIXR2dT0Y9jQ7ClCjERz7xGX37jNhiySzLIzzJj2Mls+y36yvJOUb0lEdvCZiqCLRMb+Ts7CBC3JI0xgswJCGbyUKplaKL671tK7DGqUkvO/ekpr10Dx5ZOOng/Q7ERtAHIgwjsKUTNJdShEq9H7PoQV8EQiT0TD8zKhbz0dVphLiOPCZh8cYfeoRI8CWhnilC3yob6ezo0qiwVisaw4xxL5Lb5Xu4e8fIoq06v+YynQxzqe9goLGskMoNDjCHDc+AkTY50Yam4dKlElK60wGPBtdSdikOwBIJqz5ubplkBAbjPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npMVu5pHO7NJJVedbXjWKy30JgkzS/1F+/JDDZru1u4=;
 b=Oxz+k4T3ioQ6iIP8N1b3okMpeEdpft88dNYaTJVIRf9yaThguzFcaAtOE5nO5G3s0vOaUqAKlB+bq2Q02FRiChxmfEby7xJ6C1SsxgIajucFBnclQJQOYbUR7TDRxcLPqUKszsTd3rjevYjJzJi/PuL1rv1wezey9JLOXjiNoBs=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2261.namprd15.prod.outlook.com (52.135.199.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Fri, 15 Nov 2019 23:37:13 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2451.027; Fri, 15 Nov 2019
 23:37:13 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Topic: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Index: AQHVm2mT23Qa9zxaoUGXDmZOssK4HKeM4soAgAABlIA=
Date:   Fri, 15 Nov 2019 23:37:13 +0000
Message-ID: <293bb2fe-7599-3825-1bfe-d52224e5c357@fb.com>
References: <20191115040225.2147245-1-andriin@fb.com>
 <20191115040225.2147245-3-andriin@fb.com>
 <888858f7-97fb-4434-4440-a5c0ec5cbac8@iogearbox.net>
In-Reply-To: <888858f7-97fb-4434-4440-a5c0ec5cbac8@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0148.namprd04.prod.outlook.com (2603:10b6:104::26)
 To BYAPR15MB2501.namprd15.prod.outlook.com (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::8ac1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa4c1dfb-ff22-4316-a116-08d76a24bdc6
x-ms-traffictypediagnostic: BYAPR15MB2261:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2261B744356CAF68AABFB803D7700@BYAPR15MB2261.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(396003)(136003)(376002)(346002)(199004)(189003)(2201001)(14444005)(256004)(14454004)(76176011)(99286004)(6116002)(7736002)(53546011)(6506007)(305945005)(478600001)(2906002)(186003)(102836004)(66556008)(66476007)(64756008)(66446008)(25786009)(316002)(86362001)(71190400001)(71200400001)(2616005)(36756003)(31686004)(2501003)(4326008)(6246003)(5660300002)(6436002)(6486002)(46003)(52116002)(386003)(31696002)(8676002)(54906003)(6512007)(8936002)(66946007)(81156014)(81166006)(446003)(486006)(476003)(11346002)(229853002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2261;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JNYVGYYGm5lAHGAx4Zy8BJJyyxTJBoorT9YBhbvuozGpVKWf9LnfcBYNP6R/Z5TMsLIzU0S/G+qRJ26CiQHz9kaiUn0w8e22Z45ZJE6+Y9CoYlUC/4JRiF8F+A9mXhJeocTl6lSIAsLGbZqnUvIVcx8+G4PyBp4i/IV9vaoUU6kGlqqXb58sjBMEvsP5+Dii9ibdOUmwuwND82lVoxzIF0mf2YceHTg7rrvCJBXEOu9HtsCQTGjZrv9qFKlxHjDkdDu29fHSkL+RlcnevHizhmtLdpeynXaYnInQgg9aGsb5vKefUUVrqVyAOPiM0Ag7T2MUJsb6INBYGY5r800LLNK1VCnrL9zFRM8mdmJ8QvJpOPL6BEXaNZXn01uoKGoc8IKG0p+F1VwW9/N/8UKLKbmb15UkIyEy26BkULgP4eLgFRAhWwAHVOOF2YUh00pe
Content-Type: text/plain; charset="utf-8"
Content-ID: <53CAAEBB3B10494FA4A08D1A5B49C969@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4c1dfb-ff22-4316-a116-08d76a24bdc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 23:37:13.4370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GtxDDmz41f5uYuSeDzcSzc2XZSe+U7XsieaSIKJMcyGiWx4HeWBSGLkTOx3vwNKm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2261
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_07:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911150205
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMTUvMTkgMzozMSBQTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPiBPbiAxMS8xNS8x
OSA1OjAyIEFNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+PiBBZGQgYWJpbGl0eSB0byBtZW1v
cnktbWFwIGNvbnRlbnRzIG9mIEJQRiBhcnJheSBtYXAuIFRoaXMgaXMgZXh0cmVtZWx5IA0KPj4g
dXNlZnVsDQo+PiBmb3Igd29ya2luZyB3aXRoIEJQRiBnbG9iYWwgZGF0YSBmcm9tIHVzZXJzcGFj
ZSBwcm9ncmFtcy4gSXQgYWxsb3dzIHRvIA0KPj4gYXZvaWQNCj4+IHR5cGljYWwgYnBmX21hcF97
bG9va3VwLHVwZGF0ZX1fZWxlbSBvcGVyYXRpb25zLCBpbXByb3ZpbmcgYm90aCANCj4+IHBlcmZv
cm1hbmNlDQo+PiBhbmQgdXNhYmlsaXR5Lg0KPj4NCj4+IFRoZXJlIGhhZCB0byBiZSBzcGVjaWFs
IGNvbnNpZGVyYXRpb25zIGZvciBtYXAgZnJlZXppbmcsIHRvIGF2b2lkIGhhdmluZw0KPj4gd3Jp
dGFibGUgbWVtb3J5IHZpZXcgaW50byBhIGZyb3plbiBtYXAuIFRvIHNvbHZlIHRoaXMgaXNzdWUs
IG1hcCANCj4+IGZyZWV6aW5nIGFuZA0KPj4gbW1hcC1pbmcgaXMgaGFwcGVuaW5nIHVuZGVyIG11
dGV4IG5vdzoNCj4+IMKgwqAgLSBpZiBtYXAgaXMgYWxyZWFkeSBmcm96ZW4sIG5vIHdyaXRhYmxl
IG1hcHBpbmcgaXMgYWxsb3dlZDsNCj4+IMKgwqAgLSBpZiBtYXAgaGFzIHdyaXRhYmxlIG1lbW9y
eSBtYXBwaW5ncyBhY3RpdmUgKGFjY291bnRlZCBpbiANCj4+IG1hcC0+d3JpdGVjbnQpLA0KPj4g
wqDCoMKgwqAgbWFwIGZyZWV6aW5nIHdpbGwga2VlcCBmYWlsaW5nIHdpdGggLUVCVVNZOw0KPj4g
wqDCoCAtIG9uY2UgbnVtYmVyIG9mIHdyaXRhYmxlIG1lbW9yeSBtYXBwaW5ncyBkcm9wcyB0byB6
ZXJvLCBtYXAgDQo+PiBmcmVlemluZyBjYW4gYmUNCj4+IMKgwqDCoMKgIHBlcmZvcm1lZCBhZ2Fp
bi4NCj4+DQo+PiBPbmx5IG5vbi1wZXItQ1BVIHBsYWluIGFycmF5cyBhcmUgc3VwcG9ydGVkIHJp
Z2h0IG5vdy4gTWFwcyB3aXRoIA0KPj4gc3BpbmxvY2tzDQo+PiBjYW4ndCBiZSBtZW1vcnkgbWFw
cGVkIGVpdGhlci4NCj4+DQo+PiBGb3IgQlBGX0ZfTU1BUEFCTEUgYXJyYXksIG1lbW9yeSBhbGxv
Y2F0aW9uIGhhcyB0byBiZSBkb25lIHRocm91Z2ggDQo+PiB2bWFsbG9jKCkNCj4+IHRvIGJlIG1t
YXAoKSdhYmxlLiBXZSBhbHNvIG5lZWQgdG8gbWFrZSBzdXJlIHRoYXQgYXJyYXkgZGF0YSBtZW1v
cnkgaXMNCj4+IHBhZ2Utc2l6ZWQgYW5kIHBhZ2UtYWxpZ25lZCwgc28gd2Ugb3Zlci1hbGxvY2F0
ZSBtZW1vcnkgaW4gc3VjaCBhIHdheSANCj4+IHRoYXQNCj4+IHN0cnVjdCBicGZfYXJyYXkgaXMg
YXQgdGhlIGVuZCBvZiBhIHNpbmdsZSBwYWdlIG9mIG1lbW9yeSB3aXRoIA0KPj4gYXJyYXktPnZh
bHVlDQo+PiBiZWluZyBhbGlnbmVkIHdpdGggdGhlIHN0YXJ0IG9mIHRoZSBzZWNvbmQgcGFnZS4g
T24gZGVhbGxvY2F0aW9uIHdlIA0KPj4gbmVlZCB0bw0KPj4gYWNjb21vZGF0ZSB0aGlzIG1lbW9y
eSBhcnJhbmdlbWVudCB0byBmcmVlIHZtYWxsb2MoKSdlZCBtZW1vcnkgY29ycmVjdGx5Lg0KPj4N
Cj4+IE9uZSBpbXBvcnRhbnQgY29uc2lkZXJhdGlvbiByZWdhcmRpbmcgaG93IG1lbW9yeS1tYXBw
aW5nIHN1YnN5c3RlbSANCj4+IGZ1bmN0aW9ucy4NCj4+IE1lbW9yeS1tYXBwaW5nIHN1YnN5c3Rl
bSBwcm92aWRlcyBmZXcgb3B0aW9uYWwgY2FsbGJhY2tzLCBhbW9uZyB0aGVtIA0KPj4gb3Blbigp
DQo+PiBhbmQgY2xvc2UoKS7CoCBjbG9zZSgpIGlzIGNhbGxlZCBmb3IgZWFjaCBtZW1vcnkgcmVn
aW9uIHRoYXQgaXMgDQo+PiB1bm1hcHBlZCwgc28NCj4+IHRoYXQgdXNlcnMgY2FuIGRlY3JlYXNl
IHRoZWlyIHJlZmVyZW5jZSBjb3VudGVycyBhbmQgZnJlZSB1cCANCj4+IHJlc291cmNlcywgaWYN
Cj4+IG5lY2Vzc2FyeS4gb3BlbigpIGlzICphbG1vc3QqIHN5bW1ldHJpY2FsOiBpdCdzIGNhbGxl
ZCBmb3IgZWFjaCBtZW1vcnkgDQo+PiByZWdpb24NCj4+IHRoYXQgaXMgYmVpbmcgbWFwcGVkLCAq
KmV4Y2VwdCoqIHRoZSB2ZXJ5IGZpcnN0IG9uZS4gU28gYnBmX21hcF9tbWFwIGRvZXMNCj4+IGlu
aXRpYWwgcmVmY250IGJ1bXAsIHdoaWxlIG9wZW4oKSB3aWxsIGRvIGFueSBleHRyYSBvbmVzIGFm
dGVyIHRoYXQuIFRodXMNCj4+IG51bWJlciBvZiBjbG9zZSgpIGNhbGxzIGlzIGVxdWFsIHRvIG51
bWJlciBvZiBvcGVuKCkgY2FsbHMgcGx1cyBvbmUgbW9yZS4NCj4+DQo+PiBDYzogSm9oYW5uZXMg
V2VpbmVyIDxoYW5uZXNAY21weGNoZy5vcmc+DQo+PiBDYzogUmlrIHZhbiBSaWVsIDxyaWVsQHN1
cnJpZWwuY29tPg0KPj4gQWNrZWQtYnk6IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+
DQo+PiBBY2tlZC1ieTogSm9obiBGYXN0YWJlbmQgPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbT4N
Cj4+IFNpZ25lZC1vZmYtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+IA0K
PiBbLi4uXQ0KPj4gKy8qIGNhbGxlZCBmb3IgYW55IGV4dHJhIG1lbW9yeS1tYXBwZWQgcmVnaW9u
cyAoZXhjZXB0IGluaXRpYWwpICovDQo+PiArc3RhdGljIHZvaWQgYnBmX21hcF9tbWFwX29wZW4o
c3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpDQo+PiArew0KPj4gK8KgwqDCoCBzdHJ1Y3QgYnBm
X21hcCAqbWFwID0gdm1hLT52bV9maWxlLT5wcml2YXRlX2RhdGE7DQo+PiArDQo+PiArwqDCoMKg
IGJwZl9tYXBfaW5jKG1hcCk7DQo+IA0KPiBUaGlzIHdvdWxkIGFsc28gbmVlZCB0byBpbmMgdXJl
ZiBjb3VudGVyIHNpbmNlIGl0J3MgdGVjaG5pY2FsbHkgYSByZWZlcmVuY2UNCj4gb2YgdGhpcyBt
YXAgaW50byB1c2VyIHNwYWNlIGFzIG90aGVyd2lzZSBpZiBtYXAtPm9wcy0+bWFwX3JlbGVhc2Vf
dXJlZiANCj4gd291bGQNCj4gYmUgdXNlZCBmb3IgbWFwcyBzdXBwb3J0aW5nIG1tYXAsIHRoZW4g
dGhlIGNhbGxiYWNrIHdvdWxkIHRyaWdnZXIgZXZlbiANCj4gaWYgdXNlcg0KPiBzcGFjZSBzdGls
bCBoYXMgYSByZWZlcmVuY2UgdG8gaXQuDQoNCkkgdGhvdWdodCB3ZSB1c2UgdXJlZiBvbmx5IGZv
ciBhcnJheSB0aGF0IGNhbiBob2xkIEZEcyA/DQpUaGF0J3Mgd2h5IEkgc3VnZ2VzdGVkIEFuZHJp
aSBlYXJsaWVyIHRvIGRyb3AgdXJlZisrLg0K
