Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F31C11EA93
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbfLMSnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:43:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53756 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728473AbfLMSnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:43:20 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDIdmU2027933;
        Fri, 13 Dec 2019 10:41:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XOhp5m9nMlio3HXQ/APyC9XL3pUgpzPt3TEEkRndYh4=;
 b=aq6fOJkmVG2g5ECsRom2yBEjneUBEXNX2FtKU8Ev7tYfS48Gs+8f/DflyBkrXriMqyhv
 8zFDF8z5Y+bxgi3yBJd7NUzOH0e0/lXE2jm0I3HP7RD8iekNfW3ab8FTLO8c5eibtdwF
 Z6HlhK33U5PAPUYJ2S4fPPiQpjzNKeu5qv0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wuuxkd2ja-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 10:41:03 -0800
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Dec 2019 10:40:50 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Dec 2019 10:40:49 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 10:40:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmVime1Ky/miPGQiPgQtImYBZe5o9vOaE1I2McEYi3QvN4HFxqxRTr6YwTgkRmdKcsCNMswhpvIwHXp0G5fth8N78qO9JU0GTh2f75hqLZaZ5M4iCzIsqy1Novil5y5N0/5Bn4Y25h0vYadQ1Vi8uGozVfGODZtiglU2rpkwrxJ3CDSPhqfGYKzQaIUedxH4w+zKKvtaodNDSDbe9g9+5PzdDE5Q4+W730NMtLZ9WYP8i8sUofgwzn6myyrKsPJCSdaFHHcFr+Um/Bk2bl1TJseb1QXl3Ot2r8j0V03DeGQ3nDSUQBg39O5vkuZiZn5HZhqtfOt+ouFoiVFe+T9+QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOhp5m9nMlio3HXQ/APyC9XL3pUgpzPt3TEEkRndYh4=;
 b=JNySVexw2Nf3BW1+NXpXIrHDn1GH2A6/O3uX2KutG5zjo5SAnoVE+neRVLPkaAeQCjPj24Vn/jUGxRX+Wxga/YvK7iVMfORhQEfRS/ahVzR8xCYcWxlXRrDo7uYC75IpuFFjEJMmFwNAlQht6yISm/qpW5PO+06tPGL6xmhlt71W/w82MNZJItup5U7DuBBnddteswHz+fQalr6gQZ0Qw0LvVApZNqRqMFYvJzcJdHDsVEjUgT6ns0b/CnrAS4zvOEp7ugKyXwlhGEoDodp+7Lopzp5haEjLEk9sKtcgqowZta8CxSKs1+lqG9DbDgZZ8Gg5hh13fznYYlXIUmof9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOhp5m9nMlio3HXQ/APyC9XL3pUgpzPt3TEEkRndYh4=;
 b=hgPyl3/Dob62MGSxoiPPbXZmzpmMi24TbQT7jX9ya3wWzlq6+GkYA8EX7GLUlMvMPlMKJEgsXDcj5G1py/yQe7n991bOVN7RhlgIAMLqf79sqthVOaK55iuDI+b/5ARMZ48yrda9jiGI6x4oFhl1JxCamjvqamgqHqN1ordA6uo=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1130.namprd15.prod.outlook.com (10.173.208.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Fri, 13 Dec 2019 18:40:48 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 18:40:48 +0000
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
Thread-Index: AQHVsHM7yfbqfNzkC0GsbvFzTjuF76e4aMKA
Date:   Fri, 13 Dec 2019 18:40:48 +0000
Message-ID: <c8944148-1f66-f367-04d8-93d30997d123@fb.com>
References: <20191211223344.165549-1-brianvv@google.com>
 <20191211223344.165549-10-brianvv@google.com>
In-Reply-To: <20191211223344.165549-10-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0014.namprd19.prod.outlook.com
 (2603:10b6:300:d4::24) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e8f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb2b207d-3928-4db7-6103-08d77ffbf8d7
x-ms-traffictypediagnostic: DM5PR15MB1130:
x-microsoft-antispam-prvs: <DM5PR15MB1130C16823940607A9510779D3540@DM5PR15MB1130.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(39860400002)(346002)(376002)(199004)(189003)(54906003)(81166006)(8676002)(5660300002)(110136005)(31686004)(7416002)(36756003)(64756008)(81156014)(8936002)(316002)(66556008)(66446008)(6506007)(53546011)(66476007)(4326008)(66946007)(71200400001)(31696002)(6512007)(2906002)(2616005)(478600001)(52116002)(186003)(86362001)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1130;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4+YgiNm/8+nYzfcmQnW0WlbHI8MLCeH2cS7UdBNQF4y1JaIL+LLf75MUK5ypzihezGpDWBXAitF1OCYc1gJ3Daif2mlzo7zijF4ZJw5H1qtuqkxCvYvBmom1M0JQhEIATqyDjyKwbZV0hTX3FDikehrHbwYscIaG3gKzw//bG3HqbayxY31EpJumV5kzVES2Vka7+jR+sSroOBPEoNnHN+EnfToSY0w9sU1XBDIKDJ8ktWytmAVbPUCdj2TIlZL/JKeWGRMKYAATkrz7de8bjjP+LjYtDN20WK06OpNDokzsMTKzx4aVvqjWpe+o5dNaOC88RYh+JSRIhnkb3Z3m345CUQODfqlbN57pdKylBgIEKNa2WuL5Nl0daZYKJjZgU4ouqrS2NR0Q2EkcU9VsvBDWaM7MrmK8BnGmmflt0lpwYoqOJ0rb7AaB/iDWC6Sh
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <69089D21ACA76B44AA3FB4C2AD5A88B3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2b207d-3928-4db7-6103-08d77ffbf8d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 18:40:48.5637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0F4puXslxsRXO6NtFy/znPbKf2fqvqbHB58OUR/mu6kO/dMlWAlwv281EnYVlhDX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1130
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_05:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130144
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
PiArCXZhbHVlICp2Ow0KDQpXZSBjYW4gaW5pdGlhbGl6ZSB0aGUgYWJvdmUgJ3YnIHRvICd2ID0g
TlVMTCcuDQpTb21lIGNvbXBpbGVyIG1heSBub3QgYmUgc21hcnQgZW5vdWdoIHRvIGZpbmQgb3V0
ICd2JyBpcyBhbHdheXMgaW5pdGlhbGl6ZWQuDQoNCj4gKw0KPiArCWlmIChpc19wY3B1KQ0KPiAr
CQl2ID0gKHZhbHVlICopdmFsdWVzOw0KPiArDQo+ICsJZm9yIChpID0gMDsgaSA8IG1heF9lbnRy
aWVzOyBpKyspIHsNCj4gKwkJa2V5c1tpXSA9IGkgKyAxOw0KPiArCQlpZiAoaXNfcGNwdSkNCj4g
KwkJCWZvciAoaiA9IDA7IGogPCBicGZfbnVtX3Bvc3NpYmxlX2NwdXMoKTsgaisrKQ0KPiArCQkJ
CWJwZl9wZXJjcHUodltpXSwgaikgPSBpICsgMiArIGo7DQo+ICsJCWVsc2UNCj4gKwkJCSgoaW50
ICopdmFsdWVzKVtpXSA9IGkgKyAyOw0KPiArCX0NCj4gKw0KPiArCWVyciA9IGJwZl9tYXBfdXBk
YXRlX2JhdGNoKG1hcF9mZCwga2V5cywgdmFsdWVzLCAmbWF4X2VudHJpZXMsIDAsIDApOw0KPiAr
CUNIRUNLKGVyciwgImJwZl9tYXBfdXBkYXRlX2JhdGNoKCkiLCAiZXJyb3I6JXNcbiIsIHN0cmVy
cm9yKGVycm5vKSk7DQo+ICt9DQo+ICsNClsuLi5dDQo=
