Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C09380FD
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfFFWkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:40:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726352AbfFFWkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:40:07 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56MYMNr023667;
        Thu, 6 Jun 2019 15:39:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NG7v0SaDv/pxnLUdpQTc4vMtNg4tltirnqVPcfN4QAE=;
 b=ekbRS0e0XNQaWZvxDEzV3Bbx+h+zTqia1wVZz/9ENb3nnAZmK8ntW9UOOfm5wAqqiF02
 sCuD98fkulPnmLWtNK/niChw0LWmuQr7OSATMqeevqBXM02b0BXlvGC1L94d4/riaYvu
 YqQPxxLLYI7IAxX367O4NVkrakszeNX4XHg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy072trf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 15:39:06 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 15:39:05 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 15:39:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG7v0SaDv/pxnLUdpQTc4vMtNg4tltirnqVPcfN4QAE=;
 b=KmT7OIyJfIBEV6DaF7qFK5CXlqQODpgyfBQpqWEktNGUmKihhDyXUbb7BlI0g5Qywm7ah2ZK6vm+omYLRYqLTH7dXkwP85M1aF9HvZN2xQVpzcbFt0O2l92jTi4QoXhL67BTbLj8CS7drashxSpI+DLv710TZ4k8gEUqfZ3/1L4=
Received: from CY4PR15MB1254.namprd15.prod.outlook.com (10.172.180.136) by
 CY4PR15MB1206.namprd15.prod.outlook.com (10.172.182.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 6 Jun 2019 22:39:03 +0000
Received: from CY4PR15MB1254.namprd15.prod.outlook.com
 ([fe80::5913:4af7:f57c:1d22]) by CY4PR15MB1254.namprd15.prod.outlook.com
 ([fe80::5913:4af7:f57c:1d22%7]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 22:39:03 +0000
From:   Matt Mullins <mmullins@fb.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "ast@kernel.org" <ast@kernel.org>, Andrew Hall <hall@fb.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf] bpf: fix nested bpf tracepoints with per-cpu data
Thread-Topic: [PATCH bpf] bpf: fix nested bpf tracepoints with per-cpu data
Thread-Index: AQHVHJldLlMzOQXFxkujs8FjBsQ6GqaPMQUAgAAHDwA=
Date:   Thu, 6 Jun 2019 22:39:03 +0000
Message-ID: <90ffbb8e2251b1afc95d813b6fcc325e67f31118.camel@fb.com>
References: <a6a31da39debb8bde6ca5085b0f4e43a96a88ea5.camel@fb.com>
         <20190606185427.7558-1-mmullins@fb.com>
         <20190606151346.6a9ed27e@cakuba.netronome.com>
In-Reply-To: <20190606151346.6a9ed27e@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-originating-ip: [2620:10d:c090:200::306b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94f92e55-18f5-4215-b2a0-08d6eacfc6f2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1206;
x-ms-traffictypediagnostic: CY4PR15MB1206:
x-microsoft-antispam-prvs: <CY4PR15MB12067497A30874083DFC0ECBB0170@CY4PR15MB1206.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(136003)(366004)(189003)(199004)(11346002)(6246003)(446003)(81166006)(2616005)(476003)(76116006)(81156014)(2351001)(6486002)(6512007)(5640700003)(71200400001)(486006)(71190400001)(6436002)(118296001)(229853002)(91956017)(73956011)(66476007)(66946007)(7736002)(68736007)(66446008)(305945005)(66556008)(64756008)(53936002)(36756003)(2501003)(8676002)(54906003)(76176011)(50226002)(6506007)(14454004)(4326008)(6916009)(2906002)(5660300002)(316002)(25786009)(99286004)(186003)(6116002)(46003)(8936002)(256004)(86362001)(478600001)(102836004)(99106002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1206;H:CY4PR15MB1254.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4h7vyei5fVIaKVjP3NqjGCb6qDsvdNsEZHbitnDUs7ryUEy4j/NyX2iN/pEmeBlRxW7n5luy8HhAMQcKMjWNhlrzPNjgv5l9mIU7zkzuaHX1EMvKvgmb0jzTG/6h00pDD+QbZACYnHqORad5tT6S0l5tjJTeO8hhTTLHWodaQYnF5czbEXdFzaILc43ouiCWaOQMkM0wPBrQyUdVbYPmz9yVEez/kCLLI2NICekCw2rmkWNtukw3HpgotQfB8e8TIGwkfK2mpEh52+rIG0KojcG5P25x6d/V+UUdVLlCFk6puZ8B7kOtyqCUrjDlC8on7E1AoaCAMZ1U05pzQsyfO4WFfGyy5z+fA9r5qdGtCHvNsijAuwnNo0aGbf7XVowMVfpYmiwpg35ilTspu4o+RIq3gnuUE+TekaOr9XbWsac=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09AD664F88A07441B6ACE1BE5D290FAE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f92e55-18f5-4215-b2a0-08d6eacfc6f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 22:39:03.4096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmullins@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1206
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA2LTA2IGF0IDE1OjEzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA2IEp1biAyMDE5IDExOjU0OjI3IC0wNzAwLCBNYXR0IE11bGxpbnMgd3JvdGU6
DQo+ID4gQlBGX1BST0dfVFlQRV9SQVdfVFJBQ0VQT0lOVHMgY2FuIGJlIGV4ZWN1dGVkIG5lc3Rl
ZCBvbiB0aGUgc2FtZSBDUFUsIGFzDQo+ID4gdGhleSBkbyBub3QgaW5jcmVtZW50IGJwZl9wcm9n
X2FjdGl2ZSB3aGlsZSBleGVjdXRpbmcuDQo+ID4gDQo+ID4gVGhpcyBlbmFibGVzIHRocmVlIGxl
dmVscyBvZiBuZXN0aW5nLCB0byBzdXBwb3J0DQo+ID4gICAtIGEga3Byb2JlIG9yIHJhdyB0cCBv
ciBwZXJmIGV2ZW50LA0KPiA+ICAgLSBhbm90aGVyIG9uZSBvZiB0aGUgYWJvdmUgdGhhdCBpcnEg
Y29udGV4dCBoYXBwZW5zIHRvIGNhbGwsIGFuZA0KPiA+ICAgLSBhbm90aGVyIG9uZSBpbiBubWkg
Y29udGV4dA0KPiA+IChhdCBtb3N0IG9uZSBvZiB3aGljaCBtYXkgYmUgYSBrcHJvYmUgb3IgcGVy
ZiBldmVudCkuDQo+ID4gDQo+ID4gRml4ZXM6IDIwYjlkN2FjNDg1MiAoImJwZjogYXZvaWQgZXhj
ZXNzaXZlIHN0YWNrIHVzYWdlIGZvciBwZXJmX3NhbXBsZV9kYXRhIikNCj4gDQo+IE5vIGNvbW1l
bnQgb24gdGhlIGNvZGUsIGJ1dCB5b3UncmUgZGVmaW5pdGVseSBtaXNzaW5nIGEgc2lnbi1vZmYu
DQoNCk9vcHMsIEkgdG90YWxseSBhbS4gIEknbGwgZ2l2ZSBpdCBzb21lIG1vcmUgdGltZSBmb3Ig
b3BpbmlvbnMgdG8gcm9sbA0KaW4sIGFuZCBJJ2xsIGZpeCB0aGF0IGJlZm9yZSBJIHJlc3VibWl0
IDopDQoNCj4gDQo+ID4gLS0tDQo+ID4gVGhpcyBpcyBtb3JlIGxpbmVzIG9mIGNvZGUsIGJ1dCBw
b3NzaWJseSBsZXNzIGludHJ1c2l2ZSB0aGFuIHRoZQ0KPiA+IHBlci1hcnJheS1lbGVtZW50IGFw
cHJvYWNoLg0KPiA+IA0KPiA+IEkgZG9uJ3QgbmVjZXNzYXJpbHkgbGlrZSB0aGF0IEkgZHVwbGlj
YXRlZCB0aGUgbmVzdF9sZXZlbCBsb2dpYyBpbiB0d28NCj4gPiBwbGFjZXMsIGJ1dCBJIGRvbid0
IHNlZSBhIHdheSB0byB1bmlmeSB0aGVtOg0KPiA+ICAgLSBrcHJvYmVzJyBicGZfcGVyZl9ldmVu
dF9vdXRwdXQgZG9lc24ndCB1c2UgYnBmX3Jhd190cF9yZWdzLCBhbmQgZG9lcw0KPiA+ICAgICB1
c2UgdGhlIHBlcmZfc2FtcGxlX2RhdGEsDQo+ID4gICAtIHJhdyB0cmFjZXBvaW50cycgYnBmX2dl
dF9zdGFja2lkIHVzZXMgYnBmX3Jhd190cF9yZWdzLCBidXQgbm90DQo+ID4gICAgIHRoZSBwZXJm
X3NhbXBsZV9kYXRhLCBhbmQNCj4gPiAgIC0gcmF3IHRyYWNlcG9pbnRzJyBicGZfcGVyZl9ldmVu
dF9vdXRwdXQgdXNlcyBib3RoLi4uDQo+IA0KPiANCg==
