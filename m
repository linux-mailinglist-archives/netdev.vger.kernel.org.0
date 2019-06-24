Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD0351C81
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731992AbfFXUi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:38:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16678 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726920AbfFXUi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:38:57 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5OKSvQo011518;
        Mon, 24 Jun 2019 13:37:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kVfIyi4joNWTLYL90wmxKsaZeJMMbnk5eBF81Yioads=;
 b=aXrhLfUXMQmy6Et8eA8YKBXVLayyhcK2i2cyt1U1uYsomwSZE2aCu2No3JNpuZQtcpMW
 BtlNDRa4MnorhHrIDXeeTRtg511NlpXTevDCGOEAx1K/xt+JXhDKGew7ckb4VMvA4ahQ
 +54L1T3vlg7kmzJNXOs/1FltxQ2ZAq5kzEQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2tb3gw8jch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 13:37:53 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 24 Jun 2019 13:37:52 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 13:37:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVfIyi4joNWTLYL90wmxKsaZeJMMbnk5eBF81Yioads=;
 b=hhtkxrZwZeWc4FsBGwxFyBzEG+RW2O7xJkmXGKRqIg5ht6BmKw+gbyye2VN7lF0Yt5oOr58nqUxqSZKm8Ptu3TtJALkardD+yY98jhCoR6V2V9XP6xzBBef+cJUa6b0V6OLr7lNGWA7KBCEoT4ehmCIV6iuvlWJKpFMgiNP4gaM=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2248.namprd15.prod.outlook.com (52.135.197.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 20:37:51 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2008.017; Mon, 24 Jun 2019
 20:37:51 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>
CC:     Matt Mullins <mmullins@fb.com>, Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Martin Lau" <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH] bpf: hide do_bpf_send_signal when unused
Thread-Topic: [PATCH] bpf: hide do_bpf_send_signal when unused
Thread-Index: AQHVJQxLPdwx14NZ30+oEngmZgOQRKaf9/mAgACBUQCAAAEKgIAABA2AgAAOVACACsKIgA==
Date:   Mon, 24 Jun 2019 20:37:50 +0000
Message-ID: <07dafa45-4141-2559-43ae-a0c80624426b@fb.com>
References: <20190617125724.1616165-1-arnd@arndb.de>
 <CAADnVQ+LzuNHFyLae0vUAudZpOFQ4cA02OC0zu3ypis+gqnjew@mail.gmail.com>
 <20190617190920.71c21a6c@gandalf.local.home>
 <75e9ff40e1002ad9c82716dfd77966a3721022b6.camel@fb.com>
 <CAADnVQKCeHrq+bf4DceH7+ihpq+q-V+bFOiF-TpYjekH7dPA0w@mail.gmail.com>
 <20190617201850.010a4cf6@gandalf.local.home>
In-Reply-To: <20190617201850.010a4cf6@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:dfbe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d78b8ccd-3bbc-4e41-25e9-08d6f8e3d34a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2248;
x-ms-traffictypediagnostic: BYAPR15MB2248:
x-microsoft-antispam-prvs: <BYAPR15MB22487FF3F0311B7163D28210D3E00@BYAPR15MB2248.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(39860400002)(346002)(376002)(189003)(199004)(52116002)(446003)(110136005)(54906003)(99286004)(81166006)(8936002)(2906002)(6246003)(305945005)(81156014)(31686004)(53936002)(14454004)(7736002)(256004)(229853002)(8676002)(14444005)(6512007)(6486002)(5660300002)(6436002)(71200400001)(71190400001)(36756003)(53546011)(4326008)(316002)(2616005)(66446008)(386003)(76176011)(186003)(86362001)(66946007)(73956011)(6506007)(64756008)(66556008)(476003)(102836004)(68736007)(46003)(25786009)(2501003)(11346002)(66476007)(478600001)(486006)(31696002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2248;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DC4IitThLGIt3rn1x/QJtztNrSOqJOMClLE6PXNdSDga14Q8wKa0O2FxEZ7OQbwIQQV1Mmtb0pp6Fo34WjvcdZ2sxMa5RstlFL+Ex6otlBKAHsrZSkz9owFUG4FGy9aEQCc3XkuXrFrpPjm1HOAjfavdfqDvp5HnNYn1E1ORRi2I76mc0UohLcrqS5JBFydHHGaEEvVQzM2nG6NfYvSWMj6TXUOGKEesEAyo1661YNyEWgL7Apd6GxHiZ3XpnZdLC4frUiehABqyw+toRRigFxc1mZ0u/t88GXpmhec7coRUx7+s3tVNlH2HZz2dh0M4YDhUJGuHdnTmAPOPbG3I78/qQ/JSiM7xFKggKyE02IqZshDDBd+Y/zGaW08WXL8H3gDv6AEJeEX1G+kPix+3QTc24lNcdFozJPyOpZCJ93s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <223AB7B7C03C9540B1EE9EE63A6A05B9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d78b8ccd-3bbc-4e41-25e9-08d6f8e3d34a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 20:37:51.0317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2248
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMTcvMTkgNToxOCBQTSwgU3RldmVuIFJvc3RlZHQgd3JvdGU6DQo+IE9uIE1vbiwg
MTcgSnVuIDIwMTkgMTY6Mjc6MzMgLTA3MDANCj4gQWxleGVpIFN0YXJvdm9pdG92IDxhbGV4ZWku
c3Rhcm92b2l0b3ZAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+PiBPbiBNb24sIEp1biAxNywgMjAx
OSBhdCA0OjEzIFBNIE1hdHQgTXVsbGlucyA8bW11bGxpbnNAZmIuY29tPiB3cm90ZToNCj4+Pj4N
Cj4+Pj4gVGhlIGJ1ZyAocmVhbGx5IGp1c3QgYSB3YXJuaW5nKSByZXBvcnRlZCBpcyBleGFjdGx5
IGhlcmUuDQo+Pj4NCj4+PiBJIGRvbid0IHRoaW5rIGJwZl9zZW5kX3NpZ25hbCBpcyB0aWVkIHRv
IG1vZHVsZXMgYXQgYWxsOw0KPj4+IHNlbmRfc2lnbmFsX2lycV93b3JrX2luaXQgYW5kIHRoZSBj
b3JyZXNwb25kaW5nIGluaXRjYWxsIHNob3VsZCBiZQ0KPj4+IG1vdmVkIG91dHNpZGUgdGhhdCAj
aWZkZWYuDQo+Pg0KPj4gcmlnaHQuIEkgZ3Vlc3Mgc2VuZF9zaWduYWxfaXJxX3dvcmtfaW5pdCB3
YXMgYWNjaWRlbnRhbGx5IHBsYWNlZA0KPj4gYWZ0ZXIgYnBmX2V2ZW50X2luaXQgYW5kIGhhcHBl
bmVkIHRvIGJlIHdpdGhpbiB0aGF0IGlmZGVmLg0KPj4gU2hvdWxkIGRlZmluaXRlbHkgYmUgb3V0
c2lkZS4NCj4gDQo+IFNvIEFybmQgZGlkIGZpbmQgYSBidWcuIEp1c3QgdGhlIHdyb25nIHNvbHV0
aW9uIDstKQ0KPiANCj4gLS0gU3RldmUNCg0KSGksIEFybmQsDQoNClRoZSBmb2xsb3dpbmcgY2hh
bmdlIGNhbiBmaXggdGhlIGlzc3VlLg0KDQpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL2JwZl90
cmFjZS5jIGIva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQppbmRleCBjMTAyYzI0MGJiMGIuLmNh
MTI1NWQxNDU3NiAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS9icGZfdHJhY2UuYw0KKysrIGIv
a2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQpAQCAtMTQzMSw2ICsxNDMxLDIwIEBAIGludCBicGZf
Z2V0X3BlcmZfZXZlbnRfaW5mbyhjb25zdCBzdHJ1Y3QgDQpwZXJmX2V2ZW50ICpldmVudCwgdTMy
ICpwcm9nX2lkLA0KICAgICAgICAgcmV0dXJuIGVycjsNCiAgfQ0KDQorc3RhdGljIGludCBfX2lu
aXQgc2VuZF9zaWduYWxfaXJxX3dvcmtfaW5pdCh2b2lkKQ0KK3sNCisgICAgICAgaW50IGNwdTsN
CisgICAgICAgc3RydWN0IHNlbmRfc2lnbmFsX2lycV93b3JrICp3b3JrOw0KKw0KKyAgICAgICBm
b3JfZWFjaF9wb3NzaWJsZV9jcHUoY3B1KSB7DQorICAgICAgICAgICAgICAgd29yayA9IHBlcl9j
cHVfcHRyKCZzZW5kX3NpZ25hbF93b3JrLCBjcHUpOw0KKyAgICAgICAgICAgICAgIGluaXRfaXJx
X3dvcmsoJndvcmstPmlycV93b3JrLCBkb19icGZfc2VuZF9zaWduYWwpOw0KKyAgICAgICB9DQor
ICAgICAgIHJldHVybiAwOw0KK30NCisNCitzdWJzeXNfaW5pdGNhbGwoc2VuZF9zaWduYWxfaXJx
X3dvcmtfaW5pdCk7DQorDQogICNpZmRlZiBDT05GSUdfTU9EVUxFUw0KICBzdGF0aWMgaW50IGJw
Zl9ldmVudF9ub3RpZnkoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpuYiwgdW5zaWduZWQgbG9uZyBv
cCwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm9pZCAqbW9kdWxlKQ0KQEAgLTE0Nzgs
MTggKzE0OTIsNSBAQCBzdGF0aWMgaW50IF9faW5pdCBicGZfZXZlbnRfaW5pdCh2b2lkKQ0KICAg
ICAgICAgcmV0dXJuIDA7DQogIH0NCg0KLXN0YXRpYyBpbnQgX19pbml0IHNlbmRfc2lnbmFsX2ly
cV93b3JrX2luaXQodm9pZCkNCi17DQotICAgICAgIGludCBjcHU7DQotICAgICAgIHN0cnVjdCBz
ZW5kX3NpZ25hbF9pcnFfd29yayAqd29yazsNCi0NCi0gICAgICAgZm9yX2VhY2hfcG9zc2libGVf
Y3B1KGNwdSkgew0KLSAgICAgICAgICAgICAgIHdvcmsgPSBwZXJfY3B1X3B0cigmc2VuZF9zaWdu
YWxfd29yaywgY3B1KTsNCi0gICAgICAgICAgICAgICBpbml0X2lycV93b3JrKCZ3b3JrLT5pcnFf
d29yaywgZG9fYnBmX3NlbmRfc2lnbmFsKTsNCi0gICAgICAgfQ0KLSAgICAgICByZXR1cm4gMDsN
Ci19DQotDQogIGZzX2luaXRjYWxsKGJwZl9ldmVudF9pbml0KTsNCi1zdWJzeXNfaW5pdGNhbGwo
c2VuZF9zaWduYWxfaXJxX3dvcmtfaW5pdCk7DQogICNlbmRpZiAvKiBDT05GSUdfTU9EVUxFUyAq
Lw0KDQpDb3VsZCB5b3Ugc3VibWl0IGEgbmV3IHJldmlzaW9uPyBUaGFua3MhDQoNCllvbmdob25n
DQo=
