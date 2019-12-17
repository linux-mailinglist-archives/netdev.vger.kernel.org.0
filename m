Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A78912328B
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfLQQcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:32:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23772 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728368AbfLQQcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 11:32:43 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHGMEb3029471;
        Tue, 17 Dec 2019 08:32:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qAeqN+CyyzXoUS0+HXx5WKDkSdwjbwncvQ0tElXpKrY=;
 b=QqRekEgXjAbVey0aXfumGbjCm4oKZ7Lh3TUNlOfQP153ZFG8BnngJURymDICU+DaI0rj
 hQnPGwJ7xr3LILvpb2delWr2pDCh0GWonLcnCa4tpps2omnK0/j0ceWfu2OUwpUDSWud
 CZcYksTpf9sgYRlJH4ewSd0bJ3/Lzq7rG9I= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wy1qrg9gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 08:32:26 -0800
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 08:32:26 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 08:32:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 08:32:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYDPUm1C0arR7y3fyeUKfOOLRwTYfdQXBBgpX8DBfnsFQ7n2qmew0QLPKxBVl8zazrgS9iBSext39wL66nYbWwb/WhboJJU0QL4L8M3pdmtdZZI0BqNH7v5Wz1ABgNkyN07NPOxFfO+/DX1bRyS97/uEba/8XrJAq0rm3KJkWvCz+cuvdlEvf/VVLFRf+CXZp7Lg+WU+X/29yuvdIQw8Y2c4hJtEeDqe/2bjkBpny3ivGxLrp5xWisLGCyI+ela3UCvqBXrbkRaOjHuCpJh4iNpcFIgRfD5W9UHQIwGibAB5vlf7nHdMUbkmBJPvQmgTIoii0WLcucKbFs3MQVmsTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAeqN+CyyzXoUS0+HXx5WKDkSdwjbwncvQ0tElXpKrY=;
 b=XfABqr/H2H6AkM5Xmi9G6Q+Zx+DHiRTJGDX2fwzB4bjasRh6vK3JZOniOijXaVU7GKSUJVnSFpGDOhAVzp3VRsZ7CAQL3oqKf8sJQ4ZYeIEsm6mLyyyXu7EU5jQd3R9TJpkFWBKcoM+kQi+vf9DWwCzpu0J4r1HsN/M/VlNw8fX4CCWOIlZs7JpEH9gJIkybLZBpxnZZms98NssXa+ECrYD+2tbFFe0HyJqQehmNBYhUXs9JtzS7sRYLYIchQjhcZAy7EiDol0cjEc8fatu5btPEGDQPywekScQwm6ugbgM0a+l6ALMfBKCQfnU+TUcJTjJlHzg+rZloRHTlUuqeTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAeqN+CyyzXoUS0+HXx5WKDkSdwjbwncvQ0tElXpKrY=;
 b=d8eQJjjda+MPMZBfEiKz0vEMsjK/4sMdu/nDG0THQvNtOlnYZlLxZ4eJFxYcyzhj87yewy7/iNUC2DX8ZAvumF1egwJ7fK2lZbUiNWgmFs24SLaNTwLUxrYnU68xjReAEnAUBFMs0J2eIxubDdoOfwBPSdCYWWheHQZy3T9P0jk=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1868.namprd15.prod.outlook.com (10.174.247.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Tue, 17 Dec 2019 16:32:24 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:32:24 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Wenbo Zhang <ethercflow@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bgregg@netflix.com" <bgregg@netflix.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v13 2/2] selftests/bpf: test for
 bpf_get_fd_path() from tracepoint
Thread-Topic: [PATCH bpf-next v13 2/2] selftests/bpf: test for
 bpf_get_fd_path() from tracepoint
Thread-Index: AQHVtL8D6uRFXy8CYEi4ZKSUfUmCc6e+hZMA
Date:   Tue, 17 Dec 2019 16:32:24 +0000
Message-ID: <3ca73db9-3ed4-c655-7540-852dfa624bd1@fb.com>
References: <cover.1576575253.git.ethercflow@gmail.com>
 <56f0db8d7556bf84ccb3705b58d4e88ead04c894.1576575253.git.ethercflow@gmail.com>
In-Reply-To: <56f0db8d7556bf84ccb3705b58d4e88ead04c894.1576575253.git.ethercflow@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0084.namprd05.prod.outlook.com
 (2603:10b6:102:2::52) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:c02c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbe31b61-5eb4-4601-9ef0-08d7830eb244
x-ms-traffictypediagnostic: DM5PR15MB1868:
x-microsoft-antispam-prvs: <DM5PR15MB1868FDC7FAA423BE7F98F6E2D3500@DM5PR15MB1868.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(396003)(136003)(366004)(189003)(199004)(36756003)(66946007)(31686004)(31696002)(5660300002)(66476007)(478600001)(66446008)(64756008)(66556008)(316002)(6506007)(53546011)(2616005)(2906002)(86362001)(186003)(8936002)(71200400001)(54906003)(52116002)(4326008)(8676002)(81166006)(81156014)(6512007)(6486002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1868;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R0la/P7RFUrch7yk6MChMVs9CBtxy0lGvOubnalrDPJ55udByIr90omrjCbW3ui9L1x3AcwiqhPQAkJmIncPw+lmGq6QaknJ/eRb4FmgkI6wrmRGG5RsXCtj9a1gaQMJKYFTdOT6/cYtLpJd1vIWgkQdJxlFBadb2CGQyEcbWs7ztOTfOcZ4+E9C6vTzP9Wmj4ehevISKzqEMXCUVo+rZCyXhY2C0nJYLEJT46oQ5ORTgK+OjhVUZTslkJAJ+ZGzIaarVopvr1JWYuU8m2YVb7jOmMQiNHDN0f48CMA13Jerb6geL8aoyv08N7PG0ajRTR3/kwpwmaY4TPCTpS49oxUNxoaaCvHSasFc0o317LRdCtcdCPH58vzjlaHnIMh5JA1nRz+jMBjoZdhoKK3s/QnBeL/RC7lYgM7chZp/hEd6CxhdQ47Q4pcA9NEpIKuR
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D16A39522948AF4FB840BDD1775F9CA6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe31b61-5eb4-4601-9ef0-08d7830eb244
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:32:24.1476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gjtISIQCa4j5Pef8s7QM8BRC9l59Fv2h1KHG5Qlx3ceF60K2yQmYIcRFpPFqFrDt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1868
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_02:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912170133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE3LzE5IDE6NDcgQU0sIFdlbmJvIFpoYW5nIHdyb3RlOg0KPiB0cmFjZSBmc3Rh
dCBldmVudHMgYnkgdHJhY2Vwb2ludCBzeXNjYWxscy9zeXNfZW50ZXJfbmV3ZnN0YXQsIGFuZCBo
YW5kbGUNCj4gZXZlbnRzIG9ubHkgcHJvZHVjZWQgYnkgdGVzdF9maWxlX2ZkX3BhdGgsIHdoaWNo
IGNhbGwgZnN0YXQgb24gc2V2ZXJhbA0KPiBkaWZmZXJlbnQgdHlwZXMgb2YgZmlsZXMgdG8gdGVz
dCBicGZfZmRfZmlsZV9wYXRoJ3MgZmVhdHVyZS4NCj4gDQo+IHY1LT52NjogYWRkcmVzc2VkIEdy
ZWdnIGFuZCBZb25naG9uZydzIGZlZWRiYWNrDQo+IC0gcmVuYW1lIHRvIGdldF9mZF9wYXRoDQo+
IC0gY2hhbmdlIHN5c19lbnRlcl9uZXdmc3RhdF9hcmdzJ3MgZmQgdHlwZSB0byBsb25nIHRvIGZp
eCBpc3N1ZSBvbg0KPiBiaWctZW5kaWFuIG1hY2hpbmVzDQo+IA0KPiB2NC0+djU6IGFkZHJlc3Nl
ZCBBbmRyaWkncyBmZWVkYmFjaw0KPiAtIHBhc3MgTlVMTCBmb3Igb3B0cyBhcyBicGZfb2JqZWN0
X19vcGVuX2ZpbGUncyBQQVJBTTIsIGFzIG5vdCByZWFsbHkNCj4gdXNpbmcgYW55DQo+IC0gbW9k
aWZ5IHBhdGNoIHN1YmplY3QgdG8ga2VlcCB1cCB3aXRoIHRlc3QgY29kZQ0KPiAtIGFzIHRoaXMg
dGVzdCBpcyBzaW5nbGUtdGhyZWFkZWQsIHNvIHVzZSBnZXRwaWQgaW5zdGVhZCBvZiBTWVNfZ2V0
dGlkDQo+IC0gcmVtb3ZlIHVubmVjZXNzYXJ5IHBhcmVucyBhcm91bmQgY2hlY2sgd2hpY2ggYWZ0
ZXIgaWYgKGkgPCAzKQ0KPiAtIGluIGtlcm4gdXNlIGJwZl9nZXRfY3VycmVudF9waWRfdGdpZCgp
ID4+IDMyIHRvIGZpdCBnZXRwaWQoKSBpbg0KPiB1c2Vyc3BhY2UgcGFydA0KPiAtIHdpdGggdGhl
IHBhdGNoIGFkZGluZyBoZWxwZXIgYXMgb25lIHBhdGNoIHNlcmllcw0KPiANCj4gdjMtPnY0OiBh
ZGRyZXNzZWQgQW5kcmlpJ3MgZmVlZGJhY2sNCj4gLSB1c2UgYSBzZXQgb2YgZmQgaW5zdGVhZCBv
ZiBmZHMgYXJyYXkNCj4gLSB1c2UgZ2xvYmFsIHZhcmlhYmxlcyBpbnN0ZWFkIG9mIG1hcHMgKGlu
IHYzLCBJIG1pc3Rha2VubHkgdGhvdWdodCB0aGF0DQo+IHRoZSBicGYgbWFwcyBhcmUgZ2xvYmFs
IHZhcmlhYmxlcy4pDQo+IC0gcmVtb3ZlIHVuY2Vzc2FyeSBnbG9iYWwgdmFyaWFibGUgcGF0aF9p
bmZvX2luZGV4DQo+IC0gcmVtb3ZlIGZkIGNvbXBhcmUgYXMgdGhlIGZzdGF0J3Mgb3JkZXIgaXMg
Zml4ZWQNCj4gDQo+IHYyLT52MzogYWRkcmVzc2VkIEFuZHJpaSdzIGZlZWRiYWNrDQo+IC0gdXNl
IGdsb2JhbCBkYXRhIGluc3RlYWQgb2YgcGVyZl9idWZmZXIgdG8gc2ltcGxpZmllZCBjb2RlDQo+
IA0KPiB2MS0+djI6IGFkZHJlc3NlZCBEYW5pZWwncyBmZWVkYmFjaw0KPiAtIHJlbmFtZSBicGZf
ZmQycGF0aCB0byBicGZfZ2V0X2ZpbGVfcGF0aCB0byBiZSBjb25zaXN0ZW50IHdpdGggb3RoZXIN
Cj4gaGVscGVyJ3MgbmFtZXMNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFdlbmJvIFpoYW5nIDxldGhl
cmNmbG93QGdtYWlsLmNvbT4NCg0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+
DQo=
