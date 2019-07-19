Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5B96E8A6
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbfGSQVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:21:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23826 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728051AbfGSQVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 12:21:36 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6JGINdV024857;
        Fri, 19 Jul 2019 09:21:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1+3hbKjGfYgN3/4Z+axz9ZUE2Wiy0PGTF/X9jCscLTU=;
 b=ClOcBnrw1FgWDITrg60AUbijgmWqUg0FUMK05gsI6xfMB7EpuUmobFmSjpGRrdiGENkV
 u9b78ZAQiiz3gQrelLirOSMJh7XNRhl+L8+AFulxuvufet17S7XRq7eXcG0LtI8cqI2I
 9B8qHehyiPKFl6uX4OnKUQYGODiyVzC90w4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tubxdh5wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 19 Jul 2019 09:21:34 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 19 Jul 2019 09:21:33 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 19 Jul 2019 09:21:32 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 19 Jul 2019 09:21:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jS36d+UySDBbO7RYPFDkcDwMyzwdDKjgCZ3XyWYzx9scQKPxuKAuVRZh6468g+V69nbTKu/tU22+u+i/ZUeDNJpVe/JwP2UH1qPmjfKN1UP4nnbtPsKaExHTatL/zUitbacpNZi+fi/j4FxjyjrTtbhn0rxemNqfhXiuy5ezQY8lOKYk5iQSOb1wvzuifJi/SyvYt2QYlLFT9kGdKeWrMJHsXF4ORSVdU3E473A0t/ijnBczorurBjql5bkVOf7b+L/YvXEbUFaymUHxSrHh/Yi7CRK+vVy0j0gVCYvJXAohrsNJSthq1vaJDK4T8Wtj9P2OX/KXS4jWlvMJnnqf+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+3hbKjGfYgN3/4Z+axz9ZUE2Wiy0PGTF/X9jCscLTU=;
 b=SHWmcxSxaJUeaj6onIzu5/AOtVwkVKFsZXuQYUBoZPQChSUfTbMK1jNqQF71JNf7FkLAP8evKXgUIOK1lBtjPlu+zcIYXSwLC6W2MyenznBQJYRypHV/nKwmSa+KVGF3/BIAvuT51umwfXPTknCr/BvGTIxmIizUW5k8ZFY7lrVembsyQYMHxpVHEtEXyE7SyoRFINoah4wt/YQkK8VXJyB9KBviFRU4VBmofSDKULlMmah7IQ72uG06DYBzIyPZPTlLWA5tiGGeAwFWcIkpmdHYajPW6MYQXsYu+dPdHTfbjd7jY9tJEbZHEgEZzpG4meZENZ69EoR3AYNAt9Tw8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+3hbKjGfYgN3/4Z+axz9ZUE2Wiy0PGTF/X9jCscLTU=;
 b=dPlJoTyHRWRmmyi/sah/K6+w5twirWHHUDXTYI66Gw6KvV6qIVNmtY5Voq9upcjrnv8QGLhQVZeW/NfrHL5yyTKj0rvyDmQ0Ikc+pdspqgKokIoic5l/qRvGniCZC9Gp1VcMcpawVuXKkSBHUCyO2r1BGiryWjd/gv/IhqoDSAs=
Received: from CY4PR15MB1366.namprd15.prod.outlook.com (10.172.157.148) by
 CY4PR15MB1559.namprd15.prod.outlook.com (10.172.161.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 16:21:31 +0000
Received: from CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::84cf:a2a8:4070:2ce8]) by CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::84cf:a2a8:4070:2ce8%12]) with mapi id 15.20.2073.012; Fri, 19 Jul
 2019 16:21:31 +0000
From:   Andrey Ignatov <rdna@fb.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix sendmsg6_prog on s390
Thread-Topic: [PATCH bpf] selftests/bpf: fix sendmsg6_prog on s390
Thread-Index: AQHVPhFWgrU01ARfIEagaLKVJzFWY6bSH+YA
Date:   Fri, 19 Jul 2019 16:21:30 +0000
Message-ID: <20190719162128.GA36225@rdna-mbp.dhcp.thefacebook.com>
References: <20190719090611.91743-1-iii@linux.ibm.com>
In-Reply-To: <20190719090611.91743-1-iii@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR06CA0056.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::33) To CY4PR15MB1366.namprd15.prod.outlook.com
 (2603:10b6:903:f7::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:cf0e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e466891-5f5c-4348-363c-08d70c652843
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1559;
x-ms-traffictypediagnostic: CY4PR15MB1559:
x-microsoft-antispam-prvs: <CY4PR15MB1559D65E6F0A293C4F0D4F30A8CB0@CY4PR15MB1559.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(396003)(366004)(51914003)(189003)(199004)(316002)(76176011)(186003)(25786009)(53936002)(6506007)(102836004)(46003)(6246003)(8676002)(66476007)(8936002)(305945005)(33656002)(81156014)(6916009)(52116002)(7736002)(6116002)(386003)(229853002)(81166006)(6486002)(2906002)(476003)(11346002)(6436002)(486006)(9686003)(256004)(1076003)(446003)(6512007)(478600001)(99286004)(68736007)(5660300002)(64756008)(66446008)(66946007)(86362001)(71190400001)(4326008)(14454004)(54906003)(71200400001)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1559;H:CY4PR15MB1366.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UVx83vc3pdvtMrZdppKgfN7J3gjI7hNOLKxjiXFtLgyzA3giWLvTs2bmcjsVAgTb5h+h4XEEojPpqMfiEpBRjD3dc/91GMrMawp7CCAl4NU4BgH0KaOzht3kxMFz3AMMaYBeoldXT/iidvfvYkaP6F3jNrP3oeOiexKils6NC41luuF5icxGZRBsqJ7QJq9u92Z/dlx8pi/MGhQSX92SHxSMGMhtiAtJzaUsxLEaOrDM7ZblLgREfiVAecgqCLF+HzqRJnFK2H2cT4sRTcpON4Qw3e3/Q4fUCI8LaFIr9J8BTnENwrO/NTtk00GB6qzkTdtmqVC9wqOHT5F1DMTmWvl0AmO3UrPY1Pub/yd0XBLRYHMOVuObzPSnclaQ+le/eq17WYuB0st26p4RPc2rd6dbrP2xOyD60N4DWzpy8Fg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <498AF0DEF71F0549A23FC69747C081EA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e466891-5f5c-4348-363c-08d70c652843
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 16:21:31.0474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdna@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1559
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SWx5YSBMZW9zaGtldmljaCA8aWlpQGxpbnV4LmlibS5jb20+IFtGcmksIDIwMTktMDctMTkgMDI6
MDcgLTA3MDBdOg0KPiAic2VuZG1zZzY6IHJld3JpdGUgSVAgJiBwb3J0IChDKSIgZmFpbHMgb24g
czM5MCwgYmVjYXVzZSB0aGUgY29kZSBpbg0KPiBzZW5kbXNnX3Y2X3Byb2coKSBhc3N1bWVzIHRo
YXQgKGN0eC0+dXNlcl9pcDZbMF0gJiAweEZGRkYpIHJlZmVycyB0bw0KPiBsZWFkaW5nIElQdjYg
YWRkcmVzcyBkaWdpdHMsIHdoaWNoIGlzIG5vdCB0aGUgY2FzZSBvbiBiaWctZW5kaWFuDQo+IG1h
Y2hpbmVzLg0KPiANCj4gU2luY2UgY2hlY2tpbmcgYml0d2lzZSBvcGVyYXRpb25zIGRvZXNuJ3Qg
c2VlbSB0byBiZSB0aGUgcG9pbnQgb2YgdGhlDQo+IHRlc3QsIHJlcGxhY2UgdHdvIHNob3J0IGNv
bXBhcmlzb25zIHdpdGggYSBzaW5nbGUgaW50IGNvbXBhcmlzb24uDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBJbHlhIExlb3Noa2V2aWNoIDxpaWlAbGludXguaWJtLmNvbT4NCg0KQWNrZWQtYnk6IEFu
ZHJleSBJZ25hdG92IDxyZG5hQGZiLmNvbT4NCg0KSUlSQyBJIGRpZCBpdCB0aGlzIHdheSB0byB0
ZXN0IDE2Yml0IGxvYWRzIGZyb20gQyBwcm9ncmFtLCBidXQgc3VjaA0KbG9hZHMgYXJlIGFscmVh
ZHkgdGVzdGVkIGJ5IGFzbSBwcm9nIGluIHRlc3Rfc29ja19hZGRyLmMuDQoNClRoYW5rcyBmb3Ig
dGhlIGZpeCENCg0KPiAtLS0NCj4gIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9z
ZW5kbXNnNl9wcm9nLmMgfCAzICstLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2JwZi9wcm9ncy9zZW5kbXNnNl9wcm9nLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9i
cGYvcHJvZ3Mvc2VuZG1zZzZfcHJvZy5jDQo+IGluZGV4IDVhZWFhMjg0ZmM0Ny4uYTY4MDYyODIw
NDEwIDEwMDY0NA0KPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3Mvc2Vu
ZG1zZzZfcHJvZy5jDQo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9z
ZW5kbXNnNl9wcm9nLmMNCj4gQEAgLTQxLDggKzQxLDcgQEAgaW50IHNlbmRtc2dfdjZfcHJvZyhz
dHJ1Y3QgYnBmX3NvY2tfYWRkciAqY3R4KQ0KPiAgCX0NCj4gIA0KPiAgCS8qIFJld3JpdGUgZGVz
dGluYXRpb24uICovDQo+IC0JaWYgKChjdHgtPnVzZXJfaXA2WzBdICYgMHhGRkZGKSA9PSBicGZf
aHRvbnMoMHhGQUNFKSAmJg0KPiAtCSAgICAgY3R4LT51c2VyX2lwNlswXSA+PiAxNiA9PSBicGZf
aHRvbnMoMHhCMDBDKSkgew0KPiArCWlmIChjdHgtPnVzZXJfaXA2WzBdID09IGJwZl9odG9ubCgw
eEZBQ0VCMDBDKSkgew0KPiAgCQljdHgtPnVzZXJfaXA2WzBdID0gYnBmX2h0b25sKERTVF9SRVdS
SVRFX0lQNl8wKTsNCj4gIAkJY3R4LT51c2VyX2lwNlsxXSA9IGJwZl9odG9ubChEU1RfUkVXUklU
RV9JUDZfMSk7DQo+ICAJCWN0eC0+dXNlcl9pcDZbMl0gPSBicGZfaHRvbmwoRFNUX1JFV1JJVEVf
SVA2XzIpOw0KPiAtLSANCj4gMi4yMS4wDQo+IA0KDQotLSANCkFuZHJleSBJZ25hdG92DQo=
