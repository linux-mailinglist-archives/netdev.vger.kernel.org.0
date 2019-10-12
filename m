Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2620CD4B72
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 02:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfJLAkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 20:40:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28058 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbfJLAkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 20:40:33 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9C0Srmi015548;
        Fri, 11 Oct 2019 17:40:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mxu85jSsVmqlh3Knzrpr2cZ0Oni0TKqf3ITbkJyl3U0=;
 b=LhqNYDSvOWF9Uqynr3KmvHYlsAkN5E84/qbHg8J4DEYFfItnm0vDJytGeZcyzcPVguFO
 XTHuBNL+m5Rg1OunvwVicLIcS+HrGzwSlvynK7ZtjFqCsRi7X6FxkBqyNIbzrDPWhisv
 AK7Ztv6xOGZYRKC3z4h3nDk8RrRL+MhEhHg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vjwwg9t38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 17:40:16 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 17:40:15 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 17:40:15 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 17:40:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwh2TsGz30gdzwYyj+w4ldCOjyo1g9uIN9fhGZCl/0EF3A1/zprToCuDQUl8U84G7GCRLy/pwEuip7lpdxpJJr3tXLA0Lz+5Si3JIzhuwlZb7MzNM4UJ05pgAZMYYO4C2mYJ380XoMAEHKe8MalIHEo45rebq4meBsz0BdNk53u8UBl8v0g1JxRFhZMA35wbhajdIBgyrmsIcZKNQIhyQBF0JcjtQsXQm45joJ7vnjnHC6HSN1FUaZ7B2FGVhymzp0INcR9S9vN9it2Y+BTRZVTuCLgqfQA9g3wIvjCYna13MsOGeEqOZx5KDwR4v39Bgt3vqT/noFdq48SI091XSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxu85jSsVmqlh3Knzrpr2cZ0Oni0TKqf3ITbkJyl3U0=;
 b=IRnOAnw54x5jma7XuWpWiz+OSv2J2vTkg6iyBf3h0Ay003k6IyqOOTXOD7fUg9m82tHHFQxicEHJUfAjSTEVCsjuPEZlvl4HjjdL1k0ZSkecYy8OumLUWkaBlvzh5eOxMtNeqkdp8YGLQOVTD6kOXBmdjyxlZJve3K9fm8YvWnBuAMuxoRAqMjneXj0gld/tzj9M5Ch/uYF6LFjZopzIbDOlZ3mfVsZluJSvMDpq/lVVypdbzV9d4VakY9za21XhhwfB+aui+3uo0S9Q8IuAhXQld3flSdQNY0Jj+eaAqbBkKcAxOhyPzilbIfkxGOWj7HTm2U6yaAMEfj5AsfmfyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxu85jSsVmqlh3Knzrpr2cZ0Oni0TKqf3ITbkJyl3U0=;
 b=dDzzfkvNFj96SaNEz3DwlEzvvgAJIgAntS7sHHnlxm9v+Hz0INamFkywXT2qGxrWG9cOHxYqeORmNsDIv0B/kzSEgVwg8iqxuaDyo90ZSqByXPuVc1yh2YdcZZWAqrKYfwlC/23kn0AQIIY90+comPMIxVms9JmZntIiXc4az9M=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3301.namprd15.prod.outlook.com (20.178.207.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Sat, 12 Oct 2019 00:40:14 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.021; Sat, 12 Oct 2019
 00:40:13 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of
 raw_tracepoint
Thread-Topic: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of
 raw_tracepoint
Thread-Index: AQHVfyFTTiLEwIVqQE6co+EkPTXoLKdVvxuAgABt1AA=
Date:   Sat, 12 Oct 2019 00:40:13 +0000
Message-ID: <0dbf83e8-10ec-cc17-c575-949639a7f018@fb.com>
References: <20191010041503.2526303-1-ast@kernel.org>
 <20191010041503.2526303-6-ast@kernel.org>
 <CAEf4BzZxQDUzYYjF091135d+O_fwZVdK9Dqw5H4_z=5QBqueYg@mail.gmail.com>
In-Reply-To: <CAEf4BzZxQDUzYYjF091135d+O_fwZVdK9Dqw5H4_z=5QBqueYg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0006.namprd22.prod.outlook.com
 (2603:10b6:301:28::19) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::3d03]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14e9b14e-9180-4eb8-1f0b-08d74eacbe8b
x-ms-traffictypediagnostic: BYAPR15MB3301:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3301B51ED2A4C705BF64730BD7960@BYAPR15MB3301.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0188D66E61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(376002)(396003)(366004)(199004)(189003)(6116002)(11346002)(14454004)(71190400001)(71200400001)(6512007)(305945005)(4326008)(7736002)(478600001)(8676002)(256004)(5024004)(8936002)(54906003)(2906002)(316002)(81156014)(110136005)(14444005)(81166006)(53546011)(76176011)(386003)(186003)(102836004)(46003)(446003)(6486002)(99286004)(476003)(6506007)(2616005)(25786009)(31686004)(6436002)(66946007)(66476007)(66556008)(64756008)(66446008)(229853002)(52116002)(5660300002)(31696002)(6246003)(36756003)(486006)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3301;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YLnQ/5iRJvf+mfmCUcSlxddr4uBjlZXRZCWd7VDrmYhgR65yFYGmT0KCgmv51hkpRuxqm0soTryvWX1DszN6L/o8FWxaoT+i5gYYq+xB/0mTXL377cxlAEhtxfRUvgKOixkavfb0cuODf2hYs3RpijUVvca7E2flcW4fAvYyLIYmcrIzyH5h1zc/Mkh4BY417WijQpF4DrdIxnradb9FBAJAYlIw/lLqP/9lxrTj2R/pd7yVMh7i2kw3B4n8NPJ0jP0ygR3W+L4c29au/liZwie6fZbwxX6gtx6+lYjL8ZJPJsAMHd8H0g2zvWNtmcS3l+28ERk7oIVNukLVSMxl0Y/cAMjiC/7nWf0d72BrJ0IFKm2xg3+r91KOKhAhJHXsxUJN1baTSvjVfaDqJnb96diPFum4Zwj8rUrnqla8hpY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E7C5E8C6EF5BE46875045229F0BFFAA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e9b14e-9180-4eb8-1f0b-08d74eacbe8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2019 00:40:13.6783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZTQo89GxsdPfNNewersop7auofHhWyrw58SvYhZvViJrFum0VUzmzPpGguQ5sICE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3301
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_12:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910120001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTEvMTkgMTE6MDcgQU0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gT24gV2VkLCBP
Y3QgOSwgMjAxOSBhdCA5OjE3IFBNIEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+
IHdyb3RlOg0KPj4NCj4+IEZvciByYXcgdHJhY2Vwb2ludCBwcm9ncmFtIHR5cGVzIGxpYmJwZiB3
aWxsIHRyeSB0byBmaW5kDQo+PiBidGZfaWQgb2YgcmF3IHRyYWNlcG9pbnQgaW4gdm1saW51eCdz
IEJURi4NCj4+IEl0J3MgYSByZXNwb25zaWJsaXR5IG9mIGJwZiBwcm9ncmFtIGF1dGhvciB0byBh
bm5vdGF0ZSB0aGUgcHJvZ3JhbQ0KPj4gd2l0aCBTRUMoInJhd190cmFjZXBvaW50L25hbWUiKSB3
aGVyZSAibmFtZSIgaXMgYSB2YWxpZCByYXcgdHJhY2Vwb2ludC4NCj4+IElmICJuYW1lIiBpcyBp
bmRlZWQgYSB2YWxpZCByYXcgdHJhY2Vwb2ludCB0aGVuIGluLWtlcm5lbCBCVEYNCj4+IHdpbGwg
aGF2ZSAiYnRmX3RyYWNlXyMjbmFtZSIgdHlwZWRlZiB0aGF0IHBvaW50cyB0byBmdW5jdGlvbg0K
Pj4gcHJvdG90eXBlIG9mIHRoYXQgcmF3IHRyYWNlcG9pbnQuIEJURiBkZXNjcmlwdGlvbiBjYXB0
dXJlcw0KPj4gZXhhY3QgYXJndW1lbnQgdGhlIGtlcm5lbCBDIGNvZGUgaXMgcGFzc2luZyBpbnRv
IHJhdyB0cmFjZXBvaW50Lg0KPj4gVGhlIGtlcm5lbCB2ZXJpZmllciB3aWxsIGNoZWNrIHRoZSB0
eXBlcyB3aGlsZSBsb2FkaW5nIGJwZiBwcm9ncmFtLg0KPj4NCj4+IGxpYmJwZiBrZWVwcyBCVEYg
dHlwZSBpZCBpbiBleHBlY3RlZF9hdHRhY2hfdHlwZSwgYnV0IHNpbmNlDQo+PiBrZXJuZWwgaWdu
b3JlcyB0aGlzIGF0dHJpYnV0ZSBmb3IgdHJhY2luZyBwcm9ncmFtcyBjb3B5IGl0DQo+PiBpbnRv
IGF0dGFjaF9idGZfaWQgYXR0cmlidXRlIGJlZm9yZSBsb2FkaW5nLg0KPj4NCj4+IFNpZ25lZC1v
ZmYtYnk6IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+DQo+PiAtLS0NCj4+ICAg
dG9vbHMvbGliL2JwZi9icGYuYyAgICB8ICAzICsrKw0KPj4gICB0b29scy9saWIvYnBmL2xpYmJw
Zi5jIHwgMTcgKysrKysrKysrKysrKysrKysNCj4+ICAgMiBmaWxlcyBjaGFuZ2VkLCAyMCBpbnNl
cnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvYnBmLmMgYi90b29s
cy9saWIvYnBmL2JwZi5jDQo+PiBpbmRleCBjYmI5MzM1MzI5ODEuLjc5MDQ2MDY3NzIwZiAxMDA2
NDQNCj4+IC0tLSBhL3Rvb2xzL2xpYi9icGYvYnBmLmMNCj4+ICsrKyBiL3Rvb2xzL2xpYi9icGYv
YnBmLmMNCj4+IEBAIC0yMjgsNiArMjI4LDkgQEAgaW50IGJwZl9sb2FkX3Byb2dyYW1feGF0dHIo
Y29uc3Qgc3RydWN0IGJwZl9sb2FkX3Byb2dyYW1fYXR0ciAqbG9hZF9hdHRyLA0KPj4gICAgICAg
ICAgbWVtc2V0KCZhdHRyLCAwLCBzaXplb2YoYXR0cikpOw0KPj4gICAgICAgICAgYXR0ci5wcm9n
X3R5cGUgPSBsb2FkX2F0dHItPnByb2dfdHlwZTsNCj4+ICAgICAgICAgIGF0dHIuZXhwZWN0ZWRf
YXR0YWNoX3R5cGUgPSBsb2FkX2F0dHItPmV4cGVjdGVkX2F0dGFjaF90eXBlOw0KPj4gKyAgICAg
ICBpZiAoYXR0ci5wcm9nX3R5cGUgPT0gQlBGX1BST0dfVFlQRV9SQVdfVFJBQ0VQT0lOVCkNCj4+
ICsgICAgICAgICAgICAgICAvKiBleHBlY3RlZF9hdHRhY2hfdHlwZSBpcyBpZ25vcmVkIGZvciB0
cmFjaW5nIHByb2dzICovDQo+PiArICAgICAgICAgICAgICAgYXR0ci5hdHRhY2hfYnRmX2lkID0g
YXR0ci5leHBlY3RlZF9hdHRhY2hfdHlwZTsNCj4+ICAgICAgICAgIGF0dHIuaW5zbl9jbnQgPSAo
X191MzIpbG9hZF9hdHRyLT5pbnNuc19jbnQ7DQo+PiAgICAgICAgICBhdHRyLmluc25zID0gcHRy
X3RvX3U2NChsb2FkX2F0dHItPmluc25zKTsNCj4+ICAgICAgICAgIGF0dHIubGljZW5zZSA9IHB0
cl90b191NjQobG9hZF9hdHRyLT5saWNlbnNlKTsNCj4+IGRpZmYgLS1naXQgYS90b29scy9saWIv
YnBmL2xpYmJwZi5jIGIvdG9vbHMvbGliL2JwZi9saWJicGYuYw0KPj4gaW5kZXggYTAyY2RlZGM0
ZTNmLi44YmYzMGE2NzQyOGMgMTAwNjQ0DQo+PiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZi5j
DQo+PiArKysgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+PiBAQCAtNDU4Niw2ICs0NTg2LDIz
IEBAIGludCBsaWJicGZfcHJvZ190eXBlX2J5X25hbWUoY29uc3QgY2hhciAqbmFtZSwgZW51bSBi
cGZfcHJvZ190eXBlICpwcm9nX3R5cGUsDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgY29u
dGludWU7DQo+PiAgICAgICAgICAgICAgICAgICpwcm9nX3R5cGUgPSBzZWN0aW9uX25hbWVzW2ld
LnByb2dfdHlwZTsNCj4+ICAgICAgICAgICAgICAgICAgKmV4cGVjdGVkX2F0dGFjaF90eXBlID0g
c2VjdGlvbl9uYW1lc1tpXS5leHBlY3RlZF9hdHRhY2hfdHlwZTsNCj4+ICsgICAgICAgICAgICAg
ICBpZiAoKnByb2dfdHlwZSA9PSBCUEZfUFJPR19UWVBFX1JBV19UUkFDRVBPSU5UKSB7DQo+PiAr
ICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgYnRmICpidGYgPSBicGZfY29yZV9maW5kX2tl
cm5lbF9idGYoKTsNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIGNoYXIgcmF3X3RwX2J0Zl9u
YW1lWzEyOF0gPSAiYnRmX3RyYWNlXyI7DQo+PiArICAgICAgICAgICAgICAgICAgICAgICBjaGFy
ICpkc3QgPSByYXdfdHBfYnRmX25hbWUgKyBzaXplb2YoImJ0Zl90cmFjZV8iKSAtIDE7DQo+PiAr
ICAgICAgICAgICAgICAgICAgICAgICBpbnQgcmV0Ow0KPj4gKw0KPj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgaWYgKElTX0VSUihidGYpKQ0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAvKiBsYWNrIG9mIGtlcm5lbCBCVEYgaXMgbm90IGEgZmFpbHVyZSAqLw0KPj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgIC8qIHByZXBlbmQgImJ0Zl90cmFjZV8iIHByZWZpeCBwZXIga2VybmVsIGNvbnZlbnRp
b24gKi8NCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHN0cm5jYXQoZHN0LCBuYW1lICsgc2Vj
dGlvbl9uYW1lc1tpXS5sZW4sDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNp
emVvZihyYXdfdHBfYnRmX25hbWUpIC0gKGRzdCAtIHJhd190cF9idGZfbmFtZSkpOw0KPj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgcmV0ID0gYnRmX19maW5kX2J5X25hbWUoYnRmLCByYXdfdHBf
YnRmX25hbWUpOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKHJldCA+IDApDQo+PiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICpleHBlY3RlZF9hdHRhY2hfdHlwZSA9IHJl
dDsNCj4gDQo+IFdlbGwsIGFjdHVhbGx5LCBJIHJlYWxpemVkIGFmdGVyIEkgZ2F2ZSBBY2tlZC1i
eSwgc28gbm90IHlldCA6KQ0KPiANCj4gVGhpcyBuZWVkcyBrZXJuZWwgZmVhdHVyZSBwcm9iZSBv
ZiB3aGV0aGVyIGtlcm5lbCBzdXBwb3J0cyBzcGVjaWZ5aW5nDQo+IGF0dGFjaF9idGZfaWQsIG90
aGVyd2lzZSBvbiBvbGRlciBrZXJuZWxzIHdlJ2xsIHN0b3Agc3VjY2Vzc2Z1bGx5DQo+IGxvYWRp
bmcgdmFsaWQgcHJvZ3JhbS4NCg0KVGhlIGNvZGUgYWJvdmUgd29uJ3QgZmluZCBhbnl0aGluZyBv
biBvbGRlciBrZXJuZWxzLg0KVGhlIHBhdGNoIDEgb2YgdGhlIHNlcmllcyBoYXMgdG8gYmUgdGhl
cmUgZm9yIHByb3BlciBidGYgdG8gYmUNCmdlbmVyYXRlZCBieSBwYWhvbGUuDQpCZWZvcmUgdGhh
dCBoYXBwZW5zIGV4cGVjdGVkX2F0dGFjaF90eXBlIHdpbGwgc3RheSB6ZXJvDQphbmQgY29ycmVz
cG9uZGluZyBjb3B5IGluIGF0dGFjaF9idGZfaWQgd2lsbCBiZSB6ZXJvIGFzIHdlbGwuDQpJIHNl
ZSBubyBpc3N1ZXMgYmVpbmcgY29tcGF0aWJsZSB3aXRoIG9sZGVyIGtlcm5lbHMuDQoNCj4gQnV0
IGV2ZW4gaWYga2VybmVsIHN1cHBvcnRzIGF0dGFjaF9idGZfaWQsIEkgdGhpbmsgdXNlcnMgc3Rp
bGwgbmVlZCB0bw0KPiBvcHQgaW4gaW50byBzcGVjaWZ5aW5nIGF0dGFjaF9idGZfaWQgYnkgbGli
YnBmLiBUaGluayBhYm91dCBleGlzdGluZw0KPiByYXdfdHAgcHJvZ3JhbXMgdGhhdCBhcmUgdXNp
bmcgYnBmX3Byb2JlX3JlYWQoKSBiZWNhdXNlIHRoZXkgd2VyZSBub3QNCj4gY3JlYXRlZCB3aXRo
IHRoaXMga2VybmVsIGZlYXR1cmUgaW4gbWluZC4gVGhleSB3aWxsIHN1ZGRlbmx5IHN0b3ANCj4g
d29ya2luZyB3aXRob3V0IGFueSBvZiB1c2VyJ3MgZmF1bHQuDQoNClRoaXMgb25lIGlzIGV4Y2Vs
bGVudCBjYXRjaC4NCmxvb3AxLmMgc2hvdWxkIGhhdmUgY2F1Z2h0IGl0LCBzaW5jZSBpdCBoYXMN
ClNFQygicmF3X3RyYWNlcG9pbnQva2ZyZWVfc2tiIikNCnsNCiAgIGludCBuZXN0ZWRfbG9vcHMo
dm9sYXRpbGUgc3RydWN0IHB0X3JlZ3MqIGN0eCkNCiAgICAuLiA9IFBUX1JFR1NfUkMoY3R4KTsN
Cg0KYW5kIHZlcmlmaWVyIHdvdWxkIGhhdmUgcmVqZWN0ZWQgaXQuDQpCdXQgdGhlIHdheSB0aGUg
dGVzdCBpcyB3cml0dGVuIGl0J3Mgbm90IHVzaW5nIGxpYmJwZidzIGF1dG9kZXRlY3QNCm9mIHBy
b2dyYW0gdHlwZSwgc28gZXZlcnl0aGluZyBpcyBwYXNzaW5nLg0K
