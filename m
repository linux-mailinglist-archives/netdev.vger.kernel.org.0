Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C87396797
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 19:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbfHTRaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 13:30:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21096 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728344AbfHTR37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 13:29:59 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KHRpHC023245;
        Tue, 20 Aug 2019 10:29:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OLbPRXTI4r9B6Hy/IQsVMXalG+WFRGvAWttcapTghgc=;
 b=YG2CLu32a9BBnNuSNPg+b/UGzfXQw3JU+gJxre4QXUqDc76Ty5RxuXSGhs/H2aaU/mh2
 Qdi+oeHe69yPUvbbbdUULCd8f7F8GJdrGTbxEuIh8hkb8cuiWboFD9NMmiUvSD/phg/g
 aWd5uBSsFYYVumtcmzfioQ/ekvJTJTVinz0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ugjymrsu3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Aug 2019 10:29:56 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 10:29:55 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 10:29:55 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 10:29:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwCb9l07UsOmns7My2ey8G6w9TQt82DfThE4vL5PFw4A124ela6Qc+BP9fe+O/xqysP4NmnAvJUAgGG9+uR6MblgfkPU+IzHvMokiSKn7kQ9SRUwbj/JqgcB3tFRvsGSmdpVO8kBrJyeZscIZ/NiSH7i7k8BcTHiCPwlg3tzpS1p31ptez61h34EOwxcAR9rOIXdUom9lUW22edxbAougUPXA9zgKhzsZl3RXMxDytsD+kEYBTs0f3tw9PLMGewWG6aFus8doDMhoEHlXhAANMTqoxmvlNdpNlZ1d9RZTDU5QsGZLbUiH5Gl9dbPyxz32u4mcuNbquDymQwaW/sutA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLbPRXTI4r9B6Hy/IQsVMXalG+WFRGvAWttcapTghgc=;
 b=SAV1ryvYJ6Mr7iB3LiRdaFCUktDdG/4AwXbz+VSpiFrf+cnISzV/aSPuHVsNe9qcf3g+ih+d7B6LyZc08GhQJZVCNOYRQxMYMndHsANfd0+qQgdnKJiZ8gm+lXJCsS/06bItZN5I+GLGZKAjhJnrM1CY301yFg7dwkYzf1mDlVzcEkAWczzkxiHhNnzEa98wS/tR6Zrr1o8uJNYNN51gV24iY9QqzqnmdoIWxKqW6nSq+CBlLgzrUp8fdcQxWEmzY3FtHnGo923r55CGY5h3PjJ596zZsBQUFS2r2jWo9KCnGVc6MvaeyFr2Z+ddbFkdDkII6E0BNQFYZQaQb19tww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLbPRXTI4r9B6Hy/IQsVMXalG+WFRGvAWttcapTghgc=;
 b=i9Jk+2A+GqobvCQAgEMGlj98rBlyNhNJBa/hTX71MG6r4RHsHB5TEV4XejcJIgVkeQEA9NYTqeEGMbLHBnDsXkJY0atZzdIqSGO3Iqe65tvN+K8FCpjn8jFDShmR4OmD6bu6yR1+FyeH97s1UHFVYU58Ig3nHOUfcpcuGp7V/KY=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2872.namprd15.prod.outlook.com (20.178.206.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 17:29:54 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 17:29:54 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Thread-Topic: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Thread-Index: AQHVUgen0TRJjFwMbUCsjzJfHVP59ab5NXYAgAr5WACAACbhgA==
Date:   Tue, 20 Aug 2019 17:29:54 +0000
Message-ID: <e1265647-f934-1cb5-a31d-73608b7adad5@fb.com>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
 <20190813184747.12225-2-cneirabustos@gmail.com>
 <445a4535-b8cc-b6bc-717b-a5736030533a@fb.com>
 <20190820151040.GA53610@localhost>
In-Reply-To: <20190820151040.GA53610@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:301:3a::38) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:b743]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 965f5366-c050-4eff-8668-08d7259403a2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2872;
x-ms-traffictypediagnostic: BYAPR15MB2872:
x-microsoft-antispam-prvs: <BYAPR15MB28728F042F66146C16C684DED3AB0@BYAPR15MB2872.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(346002)(366004)(396003)(189003)(199004)(66446008)(52116002)(446003)(66556008)(2616005)(476003)(54906003)(36756003)(66946007)(99286004)(11346002)(86362001)(486006)(6916009)(53936002)(186003)(7736002)(71190400001)(31696002)(6246003)(46003)(305945005)(53546011)(256004)(478600001)(14444005)(71200400001)(6506007)(102836004)(64756008)(6116002)(76176011)(5660300002)(2906002)(14454004)(386003)(66476007)(1411001)(4326008)(6436002)(81156014)(316002)(6512007)(81166006)(8936002)(229853002)(6486002)(25786009)(31686004)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2872;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Z9wAJz4D1zJmcGe+VPsCUzTYWj2c95iVXdC5yx3U0GiQgZxPW9QMmfbhVaPY6AarHJaXU71JllGOYgqm3/chiRPUIdtDV7CsBOOoyx7G4Pg0kXrAMUgNWivslNq3BZgCeW/ahd7bUZ8PkW48wflTkfAJPse3NJpYOQ83VsXo2q14etL4aIYXnfeKlA/DsU3lFLpZ+qhmo2J5qSgafwnN7jnlK0Jx4CqvA/r6YKD4IYOJ1S09ZG5NcTY5LcKyYSiLY16wXEq0pCJGlsMNaWPhafB/g1kEXdqQRpfnY396xkpoIddcZCHPRbh5/X9MsrNewfF06fjubP/892fn1L8wzZTLpgEPZO8tznN8DlJjdEVE5pl5+p8Uyy2MCixqN9EQnqZWnc5weFkdThq0O+qLoq8ZCJXB2seczHF4kZuyiBE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E8396C2A20A7148AEC70E780E4E0656@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 965f5366-c050-4eff-8668-08d7259403a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 17:29:54.5123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9jxL+5DrIT2MYjIr8J4tv5gf+9CvvjDoMqcggdSEOh9PsquzdZ0QnR6/qKeeDurQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2872
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMjAvMTkgODoxMCBBTSwgQ2FybG9zIEFudG9uaW8gTmVpcmEgQnVzdG9zIHdyb3Rl
Og0KPiBIaSBZb25naG9uZywNCj4gDQo+IFRoYW5rcyBmb3IgdGFraW5nIHRoZSB0aW1lIHRvIHJl
dmlldyB0aGlzLg0KPiANCj4gDQo+Pj4gKyAqDQo+Pj4gKyAqCQkqKi1FSU5WQUwqKiBpZiAqc2l6
ZV9vZl9waWRucyogaXMgbm90IHZhbGlkIG9yIHVuYWJsZSB0byBnZXQgbnMsIHBpZA0KPj4+ICsg
KgkJb3IgdGdpZCBvZiB0aGUgY3VycmVudCB0YXNrLg0KPj4+ICsgKg0KPj4+ICsgKgkJKiotRUNI
SUxEKiogaWYgL3Byb2Mvc2VsZi9ucy9waWQgZG9lcyBub3QgZXhpc3RzLg0KPj4+ICsgKg0KPj4+
ICsgKgkJKiotRU5PVERJUioqIGlmIC9wcm9jL3NlbGYvbnMgZG9lcyBub3QgZXhpc3RzLg0KPj4N
Cj4+IExldCB1cyByZW1vdmUgRUNISUxEIGFuZCBFTk9URElSIGFuZCByZXBsYWNlIGl0IHdpdGgg
RU5PRU5UIGFzIEkNCj4+IGRlc2NyaWJlZCBiZWxvdy4NCj4+DQo+PiBQbGVhc2UgKmRvIHZlcmlm
eSogd2hhdCBoYXBwZW5zIHdoZW4gbmFtZXNwYWNlcyBvciBwaWRfbnMgYXJlIG5vdA0KPj4gY29u
ZmlndXJlZC4NCj4+DQo+IA0KPiANCj4gSSBoYXZlIHRlc3RlZCBrZXJuZWwgY29uZmlndXJhdGlv
bnMgd2l0aG91dCBuYW1lc3BhY2Ugc3VwcG9ydCBhbmQgd2l0aA0KPiBuYW1lc3BhY2Ugc3VwcG9y
dCBidXQgd2l0aG91dCBwaWQgbmFtZXNwYWNlcywgdGhlIGhlbHBlciByZXR1cm5zIC1FSU5WQUwN
Cj4gb24gYm90aCBjYXNlcywgbm93IGl0IHNob3VsZCByZXR1cm4gLUVOT0VOVC4NCg0KSW5kZWVk
LiAtRU5PRU5UIGlzIGJldHRlci4NCg0KPiANCj4gDQo+Pj4gK3N0cnVjdCBicGZfcGlkbnNfaW5m
byB7DQo+Pj4gKwlfX3UzMiBkZXY7DQo+Pg0KPj4gUGxlYXNlIGFkZCBhIGNvbW1lbnQgZm9yIGRl
diBmb3IgaG93IGRldmljZSBtYWpvciBhbmQgbWlub3IgbnVtYmVyIGFyZQ0KPj4gZGVyaXZlZC4g
VXNlciBzcGFjZSBnZXRzIGRldmljZSBtYWpvciBhbmQgbWlub3IgbnVtYmVyLCB0aGV5IG5lZWQg
dG8NCj4+IGNvbXBhcmUgdG8gdGhlIGNvcnJlc3BvbmRpbmcgbWFqb3IvbWlub3IgbnVtYmVycyBy
ZXR1cm5lZCBieSB0aGlzIGhlbHBlci4NCj4+DQo+Pj4gKwlfX3UzMiBuc2lkOw0KPj4+ICsJX191
MzIgdGdpZDsNCj4+PiArCV9fdTMyIHBpZDsNCj4+PiArfTsNCj4+DQo+IA0KPiBXaGF0IGRvIHlv
dSB0aGluayBvZiB0aGlzIGNvbW1lbnQgPw0KPiANCj4gc3RydWN0IGJwZl9waWRuc19pbmZvIHsN
Cj4gCV9fdTMyIGRldjsJLyogbWFqb3IvbWlub3IgbnVtYmVycyBmcm9tIC9wcm9jL3NlbGYvbnMv
cGlkLg0KPiAJCQkgKiBVc2VyIHNwYWNlIGdldHMgZGV2aWNlIG1ham9yIGFuZCBtaW5vciBudW1i
ZXJzIGZyb20NCj4gCQkJICogdGhlIHNhbWUgZGV2aWNlIHRoYXQgbmVlZCB0byBiZSBjb21wYXJl
ZCBhZ2FpbnN0IHRoZQ0KPiAJCQkgKiBtYWpvci9taW5vciBudW1iZXJzIHJldHVybmVkIGJ5IHRo
aXMgaGVscGVyLg0KPiAJCQkgKi8NCj4gCV9fdTMyIG5zaWQ7DQo+IAlfX3UzMiB0Z2lkOw0KPiAJ
X191MzIgcGlkOw0KPiB9Ow0KPiANCg0KVG8gYmUgbW9yZSBzcGVjaWZpYywgSSBsaWtlIGEgY29t
bWVudCBzaW1pbGFyIHRvIGJlbG93IGluIHVhcGkgYnBmLmgNCg0Kc3RydWN0IGJwZl9jZ3JvdXBf
ZGV2X2N0eCB7DQogICAgICAgICAvKiBhY2Nlc3NfdHlwZSBlbmNvZGVkIGFzIChCUEZfREVWQ0df
QUNDXyogPDwgMTYpIHwgDQpCUEZfREVWQ0dfREVWXyogKi8NCiAgICAgICAgIF9fdTMyIGFjY2Vz
c190eXBlOw0KICAgICAgICAgX191MzIgbWFqb3I7DQogICAgICAgICBfX3UzMiBtaW5vcjsNCn07
DQoNClNvbWUgbGlrZToNCgkvKiBkZXYgZW5jb2RlZCBhcyAobWFqb3IgPDwgOCB8IChtaW5vciAm
IDB4ZmYpKSAqLw0KDQo+Pg0KPj4gUGxlYXNlIHB1dCBhbiBlbXB0eSBsaW5lLiBBcyBhIGdlbmVy
YWwgcnVsZSBmb3IgcmVhZGFiaWxpdHksDQo+PiBwdXQgYW4gZW1wdHkgbGluZSBpZiBjb250cm9s
IGZsb3cgaXMgaW50ZXJydXB0ZWQsIGUuZy4sIGJ5DQo+PiAicmV0dXJuIiwgImJyZWFrIiBvciAi
Y29udGludWUiLiBBdCBsZWFzdCB0aGlzIGlzIHdoYXQNCj4+IEkgc2F3IG1vc3QgaW4gYnBmIG1h
aWxpbmcgbGlzdC4NCj4+DQo+IEknbGwgZml4IGl0IGluIHZlcnNpb24gMTAuDQo+IA0KPj4+ICsJ
bGVuID0gc3RybGVuKHBpZG5zX3BhdGgpICsgMTsNCj4+PiArCW1lbWNweSgoY2hhciAqKXRtcC0+
bmFtZSwgcGlkbnNfcGF0aCwgbGVuKTsNCj4+PiArCXRtcC0+dXB0ciA9IE5VTEw7DQo+Pj4gKwl0
bXAtPmFuYW1lID0gTlVMTDsNCj4+PiArCXRtcC0+cmVmY250ID0gMTsNCj4+PiArCXJldCA9IGZp
bGVuYW1lX2xvb2t1cChBVF9GRENXRCwgdG1wLCAwLCAma3AsIE5VTEwpOw0KPj4gQWRkaW5nIGJl
bG93IHRvIGZyZWUga21lbSBjYWNoZSBtZW1vcnkNCj4+IAlrbWVtX2NhY2hlX2ZyZWUobmFtZXNf
Y2FjaGVwLCBmbmFtZSk7DQo+Pg0KPiANCj4gSSB0aGluayB3ZSBkb24ndCBuZWVkIHRvIGNhbGwg
a21lbV9jYWNoZV9mcmVlIGFzIGZpbGVuYW1lX2xvb2t1cA0KPiBjYWxscyBwdXRuYW1lIHRoYXQg
Y2FsbHMga21lbV9jYWNoZV9mcmVlLg0KDQpPaCwgcmlnaHQuIFRoYW5rcyBmb3IgY2hlY2tpbmcg
dGhpcy4NCg0KPiANCj4gDQo+IFRoYW5rcyBhIGxvdCBmb3IgeW91ciBoZWxwLg0KPiANCj4gQmVz
dHMNCj4gDQo+PiBJbiB0aGUgYWJvdmUsIHdlIGNoZWNrZWQgdGFza19hY3RpdmVfcGlkX25zKCku
DQo+PiBJZiBub3QgcmV0dXJuaW5nIE5VTEwsIHdlIGhhdmUgYSB2YWxpZCBwaWQgbnMuIFNvIHRo
ZSBhYm92ZQ0KPj4gZmlsZW5hbWVfbG9va3VwIHNob3VsZCBub3QgZ28gd3JvbmcuIFdlIGNhbiBz
dGlsbCBrZWVwDQo+PiB0aGUgZXJyb3IgY2hlY2tpbmcgdGhvdWdoLg0KPj4NCj4+PiArCWlmIChy
ZXQpIHsNCj4+PiArCQltZW1zZXQoKHZvaWQgKilwaWRuc19pbmZvLCAwLCAoc2l6ZV90KSBzaXpl
KTsNCj4+PiArCQlyZXR1cm4gcmV0Ow0KPj4NCj4+DQo+IA0KPiBJIHRoaW5rIHdlIGNvdWxkIGdl
dCByaWQgb2YgdGhpcy4NCj4gDQo+IA0K
