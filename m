Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD597465B9
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfFNR1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:27:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60480 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbfFNR1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:27:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5EHQBJY019084;
        Fri, 14 Jun 2019 10:26:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0cc6wWQwlvd6tkN9NfV38HY1WbuwTbJvSBpiIOo3oFA=;
 b=Dya0YY4ZtCye+kd+UWR/QThc+DFq1Ikc7W5MqvDRmT/sLIxxXuu3ymyRgpgZoP+0dMs3
 x7+Usdb085WiyudGyHGxLk+EC7g5dXWg6JSBiTzd73yYwpOfwjmFTacO2geLmT1WN8kp
 Y1Be20KZ7kbegW8TQgKQso0ltgMpaeeUJrY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t43tpt8hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 Jun 2019 10:26:11 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 14 Jun 2019 10:25:40 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 14 Jun 2019 10:25:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cc6wWQwlvd6tkN9NfV38HY1WbuwTbJvSBpiIOo3oFA=;
 b=jscWoQX5T9Y00wRGOmqVSl6OSnFA3Wo+Da2hg1jgB0uzr1DO3cOPpdBJggnol0H9i+y5fjcCP+2fmn1xl9YvtPEQjTScml6eKivZwKaQVJyc2BpyD9V4C9rxnx+gJhWFzaEDshuPAqvnVlLK0SBMdi8k5aUObLz77v5KjnMEOjA=
Received: from MWHPR15MB1262.namprd15.prod.outlook.com (10.175.3.141) by
 MWHPR15MB1935.namprd15.prod.outlook.com (10.174.96.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Fri, 14 Jun 2019 17:25:39 +0000
Received: from MWHPR15MB1262.namprd15.prod.outlook.com
 ([fe80::80df:7291:9855:e8bc]) by MWHPR15MB1262.namprd15.prod.outlook.com
 ([fe80::80df:7291:9855:e8bc%8]) with mapi id 15.20.1987.013; Fri, 14 Jun 2019
 17:25:39 +0000
From:   Matt Mullins <mmullins@fb.com>
To:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
CC:     Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "ast@kernel.org" <ast@kernel.org>, Andrew Hall <hall@fb.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf v2] bpf: fix nested bpf tracepoints with per-cpu data
Thread-Topic: [PATCH bpf v2] bpf: fix nested bpf tracepoints with per-cpu data
Thread-Index: AQHVIKAbh1qBtP69rE6qUMBEymUwlKaXdkuAgAK8dwCAACKQgIAA6pQAgAArNoA=
Date:   Fri, 14 Jun 2019 17:25:39 +0000
Message-ID: <82327aade6a42e838bfb0c2399a63eb9baed57b7.camel@fb.com>
References: <20190611215304.28831-1-mmullins@fb.com>
         <CAEf4BzZ_Gypm32mSnrpGWw_U9q8LfTn7hag-p-LvYKVNkFdZGw@mail.gmail.com>
         <4aa26670-75b8-118d-68ca-56719af44204@iogearbox.net>
         <9c77657414993332987ca79d4081c4d71cc48d66.camel@fb.com>
         <e9665520-0523-def3-ddbb-59137694b029@iogearbox.net>
In-Reply-To: <e9665520-0523-def3-ddbb-59137694b029@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-originating-ip: [2620:10d:c090:200::2:9cf8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f879ff49-6f97-45a4-6034-08d6f0ed5225
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1935;
x-ms-traffictypediagnostic: MWHPR15MB1935:
x-microsoft-antispam-prvs: <MWHPR15MB1935A85EB1750C6ACBCF4042B0EE0@MWHPR15MB1935.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(366004)(346002)(396003)(136003)(189003)(199004)(8936002)(14444005)(229853002)(81166006)(81156014)(186003)(76176011)(2616005)(446003)(6506007)(50226002)(11346002)(53936002)(68736007)(4326008)(66556008)(476003)(256004)(64756008)(110136005)(316002)(2906002)(66946007)(486006)(54906003)(14454004)(66446008)(66476007)(2501003)(102836004)(6436002)(46003)(25786009)(99286004)(8676002)(6486002)(6512007)(5660300002)(6116002)(36756003)(7736002)(71200400001)(53546011)(6246003)(71190400001)(305945005)(76116006)(118296001)(478600001)(86362001)(73956011)(99106002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1935;H:MWHPR15MB1262.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mGH4CxtIMiIWSQWBT/cuCue8OGMEKyixtK3P3Fi4sZmB1WLEaGHe11Est9oNxh/pJ539qNGcrgXVSg1cvJqbOeN01sSlJU/h99ULZFq5UvrjSixizpt1H3kp+XufTMGsp6MG4JX5tFxgjt2P/+/oyz+GdzL/aTsoMnPTF6hEMTNc1ohTWJccUbCMRb/Kn3IiRTowdqm8FWhvds9ahOH2jINTMc1VrLjaQyeIeCxdPDcJ5UYWqFKP+RJWOIs++EkX0nBPMuwvd2uZybabDMxJ8EoBvrfgmUghxgOSwK2UWceHsR8e19nLLFPAY0fhea1n0lmswRPB/NUF7QpeQ3JwsTSQbGnhV7ft8LE2X9bdM8vnLWGWOLXvaKTiBIUSdmqezFMhir8MmDAlbXA2owzLL557vHDjUwMJVzAYGlMUWT8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05E1351BFB526B46859AA0F4AD1F7DAF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f879ff49-6f97-45a4-6034-08d6f0ed5225
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 17:25:39.3428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmullins@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1935
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA2LTE0IGF0IDE2OjUwICswMjAwLCBEYW5pZWwgQm9ya21hbm4gd3JvdGU6
DQo+IE9uIDA2LzE0LzIwMTkgMDI6NTEgQU0sIE1hdHQgTXVsbGlucyB3cm90ZToNCj4gPiBPbiBG
cmksIDIwMTktMDYtMTQgYXQgMDA6NDcgKzAyMDAsIERhbmllbCBCb3JrbWFubiB3cm90ZToNCj4g
PiA+IE9uIDA2LzEyLzIwMTkgMDc6MDAgQU0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gPiA+
ID4gT24gVHVlLCBKdW4gMTEsIDIwMTkgYXQgODo0OCBQTSBNYXR0IE11bGxpbnMgPG1tdWxsaW5z
QGZiLmNvbT4gd3JvdGU6DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gQlBGX1BST0dfVFlQRV9SQVdf
VFJBQ0VQT0lOVHMgY2FuIGJlIGV4ZWN1dGVkIG5lc3RlZCBvbiB0aGUgc2FtZSBDUFUsIGFzDQo+
ID4gPiA+ID4gdGhleSBkbyBub3QgaW5jcmVtZW50IGJwZl9wcm9nX2FjdGl2ZSB3aGlsZSBleGVj
dXRpbmcuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gVGhpcyBlbmFibGVzIHRocmVlIGxldmVscyBv
ZiBuZXN0aW5nLCB0byBzdXBwb3J0DQo+ID4gPiA+ID4gICAtIGEga3Byb2JlIG9yIHJhdyB0cCBv
ciBwZXJmIGV2ZW50LA0KPiA+ID4gPiA+ICAgLSBhbm90aGVyIG9uZSBvZiB0aGUgYWJvdmUgdGhh
dCBpcnEgY29udGV4dCBoYXBwZW5zIHRvIGNhbGwsIGFuZA0KPiA+ID4gPiA+ICAgLSBhbm90aGVy
IG9uZSBpbiBubWkgY29udGV4dA0KPiA+ID4gPiA+IChhdCBtb3N0IG9uZSBvZiB3aGljaCBtYXkg
YmUgYSBrcHJvYmUgb3IgcGVyZiBldmVudCkuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gRml4ZXM6
IDIwYjlkN2FjNDg1MiAoImJwZjogYXZvaWQgZXhjZXNzaXZlIHN0YWNrIHVzYWdlIGZvciBwZXJm
X3NhbXBsZV9kYXRhIikNCj4gPiA+IA0KPiA+ID4gR2VuZXJhbGx5LCBsb29rcyBnb29kIHRvIG1l
LiBUd28gdGhpbmdzIGJlbG93Og0KPiA+ID4gDQo+ID4gPiBOaXQsIGZvciBzdGFibGUsIHNob3Vs
ZG4ndCBmaXhlcyB0YWcgYmUgYzRmNjY5OWRmY2I4ICgiYnBmOiBpbnRyb2R1Y2UgQlBGX1JBV19U
UkFDRVBPSU5UIikNCj4gPiA+IGluc3RlYWQgb2YgdGhlIG9uZSB5b3UgY3VycmVudGx5IGhhdmU/
DQo+ID4gDQo+ID4gQWgsIHllYWgsIHRoYXQncyBwcm9iYWJseSBtb3JlIHJlYXNvbmFibGU7IEkg
aGF2ZW4ndCBtYW5hZ2VkIHRvIGNvbWUgdXANCj4gPiB3aXRoIGEgc2NlbmFyaW8gd2hlcmUgb25l
IGNvdWxkIGhpdCB0aGlzIHdpdGhvdXQgcmF3IHRyYWNlcG9pbnRzLiAgSSdsbA0KPiA+IGZpeCB1
cCB0aGUgbml0cyB0aGF0J3ZlIGFjY3VtdWxhdGVkIHNpbmNlIHYyLg0KPiA+IA0KPiA+ID4gT25l
IG1vcmUgcXVlc3Rpb24gLyBjbGFyaWZpY2F0aW9uOiB3ZSBoYXZlIF9fYnBmX3RyYWNlX3J1bigp
IHZzIHRyYWNlX2NhbGxfYnBmKCkuDQo+ID4gPiANCj4gPiA+IE9ubHkgcmF3IHRyYWNlcG9pbnRz
IGNhbiBiZSBuZXN0ZWQgc2luY2UgdGhlIHJlc3QgaGFzIHRoZSBicGZfcHJvZ19hY3RpdmUgcGVy
LUNQVQ0KPiA+ID4gY291bnRlciB2aWEgdHJhY2VfY2FsbF9icGYoKSBhbmQgd291bGQgYmFpbCBv
dXQgb3RoZXJ3aXNlLCBpaXVjLiBBbmQgcmF3IG9uZXMgdXNlDQo+ID4gPiB0aGUgX19icGZfdHJh
Y2VfcnVuKCkgYWRkZWQgaW4gYzRmNjY5OWRmY2I4ICgiYnBmOiBpbnRyb2R1Y2UgQlBGX1JBV19U
UkFDRVBPSU5UIikuDQo+ID4gPiANCj4gPiA+IDEpIEkgdHJpZWQgdG8gcmVjYWxsIGFuZCBmaW5k
IGEgcmF0aW9uYWxlIGZvciBtZW50aW9uZWQgdHJhY2VfY2FsbF9icGYoKSBzcGxpdCBpbg0KPiA+
ID4gdGhlIGM0ZjY2OTlkZmNiOCBsb2csIGJ1dCBjb3VsZG4ndCBmaW5kIGFueS4gSXMgdGhlIHJh
aXNvbiBkJ8OqdHJlIHB1cmVseSBiZWNhdXNlIG9mDQo+ID4gPiBwZXJmb3JtYW5jZSBvdmVyaGVh
ZCAoYW5kIGRlc2lyZSB0byBub3QgbWlzcyBldmVudHMgYXMgYSByZXN1bHQgb2YgbmVzdGluZyk/
IChUaGlzDQo+ID4gPiBhbHNvIG1lYW5zIHdlJ3JlIG5vdCBwcm90ZWN0ZWQgYnkgYnBmX3Byb2df
YWN0aXZlIGluIGFsbCB0aGUgbWFwIG9wcywgb2YgY291cnNlLikNCj4gPiA+IDIpIFdvdWxkbid0
IHRoaXMgYWxzbyBtZWFuIHRoYXQgd2Ugb25seSBuZWVkIHRvIGZpeCB0aGUgcmF3IHRwIHByb2dy
YW1zIHZpYQ0KPiA+ID4gZ2V0X2JwZl9yYXdfdHBfcmVncygpIC8gcHV0X2JwZl9yYXdfdHBfcmVn
cygpIGFuZCB3b24ndCBuZWVkIHRoaXMgZHVwbGljYXRpb24gZm9yDQo+ID4gPiB0aGUgcmVzdCB3
aGljaCByZWxpZXMgdXBvbiB0cmFjZV9jYWxsX2JwZigpPyBJJ20gcHJvYmFibHkgbWlzc2luZyBz
b21ldGhpbmcsIGJ1dA0KPiA+ID4gZ2l2ZW4gdGhleSBoYXZlIHNlcGFyYXRlIHB0X3JlZ3MgdGhl
cmUsIGhvdyBjb3VsZCB0aGV5IGJlIGFmZmVjdGVkIHRoZW4/DQo+ID4gDQo+ID4gRm9yIHRoZSBw
dF9yZWdzLCB5b3UncmUgY29ycmVjdDogSSBvbmx5IHVzZWQgZ2V0L3B1dF9yYXdfdHBfcmVncyBm
b3INCj4gPiB0aGUgX3Jhd190cCB2YXJpYW50cy4gIEhvd2V2ZXIsIGNvbnNpZGVyIHRoZSBmb2xs
b3dpbmcgbmVzdGluZzoNCj4gPiANCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB0cmFjZV9uZXN0X2xldmVsIHJhd190cF9uZXN0X2xldmVsDQo+ID4gICAoa3Byb2JlKSBi
cGZfcGVyZl9ldmVudF9vdXRwdXQgICAgICAgICAgICAxICAgICAgICAgICAgICAgMA0KPiA+ICAg
KHJhd190cCkgYnBmX3BlcmZfZXZlbnRfb3V0cHV0X3Jhd190cCAgICAgMiAgICAgICAgICAgICAg
IDENCj4gPiAgIChyYXdfdHApIGJwZl9nZXRfc3RhY2tpZF9yYXdfdHAgICAgICAgICAgIDIgICAg
ICAgICAgICAgICAyDQo+ID4gDQo+ID4gSSBuZWVkIHRvIGluY3JlbWVudCBhIG5lc3QgbGV2ZWwg
KGFuZCBpZGVhbGx5IGluY3JlbWVudCBpdCBvbmx5IG9uY2UpDQo+ID4gYmV0d2VlbiB0aGUga3By
b2JlIGFuZCB0aGUgZmlyc3QgcmF3X3RwLCBiZWNhdXNlIHRoZXkgd291bGQgb3RoZXJ3aXNlDQo+
ID4gc2hhcmUgdGhlIHN0cnVjdCBwZXJmX3NhbXBsZV9kYXRhLiAgQnV0IEkgYWxzbyBuZWVkIHRv
IGluY3JlbWVudCBhIG5lc3QNCj4gDQo+IEknbSBub3Qgc3VyZSBJIGZvbGxvdyBvbiB0aGlzIG9u
ZTogdGhlIGZvcm1lciB3b3VsZCBzdGlsbCBrZWVwIHVzaW5nIHRoZQ0KPiBicGZfdHJhY2Vfc2Qg
YXMtaXMgdG9kYXkgc2luY2Ugb25seSBldmVyIC9vbmUvIGNhbiBiZSBhY3RpdmUgb24gYSBnaXZl
biBDUFUNCj4gYXMgd2Ugb3RoZXJ3aXNlIGJhaWwgb3V0IGluIHRyYWNlX2NhbGxfYnBmKCkgZHVl
IHRvIGJwZl9wcm9nX2FjdGl2ZSBjb3VudGVyLg0KPiBHaXZlbiB0aGVzZSB0d28gYXJlIC9ub3Qv
IHNoYXJlZCwgeW91IG9ubHkgbmVlZCB0aGUgY29kZSB5b3UgaGF2ZSBiZWxvdyBmb3INCj4gbmVz
dGluZyB0byBkZWFsIHdpdGggdGhlIHJhd190cHMgdmlhIGdldF9icGZfcmF3X3RwX3JlZ3MoKSAv
IHB1dF9icGZfcmF3X3RwX3JlZ3MoKQ0KPiB3aGljaCBzaG91bGQgYWxzbyBzaW1wbGlmeSB0aGUg
Y29kZSBxdWl0ZSBhIGJpdC4NCg0KYnBmX3BlcmZfZXZlbnRfb3V0cHV0X3Jhd190cCBjYWxscyBf
X19fYnBmX3BlcmZfZXZlbnRfb3V0cHV0LCBzbyBpdA0KY3VycmVudGx5IHNoYXJlcyBicGZfdHJh
Y2Vfc2Qgd2l0aCBrcHJvYmVzIC0tIGl0IF9jYW5fIGJlIG5lc3RlZC4NCg0KPiANCj4gPiBsZXZl
bCBiZXR3ZWVuIHRoZSB0d28gcmF3X3Rwcywgc2luY2UgdGhleSBzaGFyZSB0aGUgcHRfcmVncyAt
LSBJIGNhbid0DQo+ID4gdXNlIHRyYWNlX25lc3RfbGV2ZWwgZm9yIGV2ZXJ5dGhpbmcgYmVjYXVz
ZSBpdCdzIG5vdCB1c2VkIGJ5DQo+ID4gZ2V0X3N0YWNraWQsIGFuZCBJIGNhbid0IHVzZSByYXdf
dHBfbmVzdF9sZXZlbCBmb3IgZXZlcnl0aGluZyBiZWNhdXNlDQo+ID4gaXQncyBub3QgaW5jcmVt
ZW50ZWQgYnkga3Byb2Jlcy4NCj4gDQo+IChTZWUgYWJvdmUgd3J0IGtwcm9iZXMuKQ0KPiANCj4g
PiBJZiByYXcgdHJhY2Vwb2ludHMgd2VyZSB0byBidW1wIGJwZl9wcm9nX2FjdGl2ZSwgdGhlbiBJ
IGNvdWxkIGdldCBhd2F5DQo+ID4gd2l0aCBqdXN0IHVzaW5nIHRoYXQgY291bnQgaW4gdGhlc2Ug
Y2FsbHNpdGVzIC0tIEknbSByZWx1Y3RhbnQgdG8gZG8NCj4gPiB0aGF0LCB0aG91Z2gsIHNpbmNl
IGl0IHdvdWxkIHByZXZlbnQga3Byb2JlcyBmcm9tIGV2ZXIgcnVubmluZyBpbnNpZGUgYQ0KPiA+
IHJhd190cC4gIEknZCBsaWtlIHRvIHJldGFpbiB0aGUgYWJpbGl0eSB0byAoZS5nLikNCj4gPiAg
IHRyYWNlLnB5IC1LIGh0YWJfbWFwX3VwZGF0ZV9lbGVtDQo+ID4gYW5kIGdldCBzb21lIHN0YWNr
IHRyYWNlcyBmcm9tIGF0IGxlYXN0IHdpdGhpbiByYXcgdHJhY2Vwb2ludHMuDQo+ID4gDQo+ID4g
VGhhdCBzYWlkLCBhcyBJIHdyb3RlIHVwIHRoaXMgZXhhbXBsZSwgYnBmX3RyYWNlX25lc3RfbGV2
ZWwgc2VlbXMgdG8gYmUNCj4gPiB3aWxkbHkgbWlzbmFtZWQ7IEkgc2hvdWxkIG5hbWUgdGhvc2Ug
YWZ0ZXIgdGhlIHN0cnVjdHVyZSB0aGV5J3JlDQo+ID4gcHJvdGVjdGluZy4uLg0K
