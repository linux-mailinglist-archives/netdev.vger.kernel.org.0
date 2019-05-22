Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEE525C9C
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 06:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbfEVET2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 00:19:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40986 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbfEVET2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 00:19:28 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4M4HGcG008469;
        Tue, 21 May 2019 21:19:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zk92Z2OrWX/h/bRTcg7vwnPL1gGfd+sDYlkxUSWtdOo=;
 b=XY2ocQJsLrVCqHTwAJSBOpBL0jGJ6lUat+g3xemCBnXzH8J61dR6zwFTPrzUlW5Z/2ku
 1J/5AMKrrUJe9Q0nzkdVqESmeQac0fzRdJvARUSXDDwXhHPx3BE7aZbqYLEcr7Fo1Rwy
 Ywp8ysZmhiAJ8dyBB+mR2Z1ulMRJSIM9S7M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2smcnpupfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 May 2019 21:19:05 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 May 2019 21:19:04 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 21 May 2019 21:19:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zk92Z2OrWX/h/bRTcg7vwnPL1gGfd+sDYlkxUSWtdOo=;
 b=F91c4EHMeb0W3LXSCJDmXKVExA8m95vHrTckJxvc+Pyble96HXbUtfINRHPQern0/jDc0mbjVn7IsDQE5TakRpnkS0AGRZ4ggrP+4xzNJzvj+6542/wOX23Oj6EZX8+uQ9wY0njiZ89HNCImG+2McWe+idFVl8WlTaRQW5pKtW0=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3271.namprd15.prod.outlook.com (20.179.57.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Wed, 22 May 2019 04:18:49 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::140e:9c62:f2d3:7f27]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::140e:9c62:f2d3:7f27%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 04:18:48 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] bpf: convert explored_states to hash table
Thread-Topic: [PATCH bpf-next 3/3] bpf: convert explored_states to hash table
Thread-Index: AQHVECoSwzM5ZnUzl0WUmqsBU0nlOqZ2UakAgAAXJICAAB8NgIAAAraA
Date:   Wed, 22 May 2019 04:18:48 +0000
Message-ID: <569b0549-a32e-d7f4-a6f3-0d0d80879472@fb.com>
References: <20190521230635.2142522-1-ast@kernel.org>
 <20190521230635.2142522-4-ast@kernel.org>
 <CAEf4BzZkWWCqEJ8mKJjqkF1FpvP+urJ5dcdhneCoPd4wtViOww@mail.gmail.com>
 <20190522021753.2sm2ixz644r4cnnu@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYKrKniMmS8mTfcFS8aD1ybTY2RRFq+yXKXoXUpkQeeJA@mail.gmail.com>
In-Reply-To: <CAEf4BzYKrKniMmS8mTfcFS8aD1ybTY2RRFq+yXKXoXUpkQeeJA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0040.namprd02.prod.outlook.com
 (2603:10b6:301:73::17) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d0e7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30e0487c-337e-4329-585c-08d6de6c9683
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3271;
x-ms-traffictypediagnostic: BYAPR15MB3271:
x-microsoft-antispam-prvs: <BYAPR15MB3271571C618179112A79DCB9D7000@BYAPR15MB3271.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(396003)(39860400002)(366004)(54094003)(199004)(189003)(25786009)(229853002)(110136005)(6486002)(6512007)(5660300002)(102836004)(478600001)(446003)(6436002)(8936002)(31696002)(11346002)(2616005)(476003)(86362001)(7736002)(186003)(486006)(46003)(81156014)(305945005)(316002)(54906003)(8676002)(81166006)(68736007)(36756003)(53936002)(66446008)(14454004)(4326008)(52116002)(99286004)(66946007)(66556008)(66476007)(73956011)(71190400001)(71200400001)(64756008)(6506007)(6116002)(386003)(76176011)(256004)(31686004)(6246003)(4744005)(2906002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3271;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JOK+0G2ShdAD3EUeXNVQt/0K35bpRI21WaWaMdLUC0dziiaxfOSekyZWaIdz2ccXhFs0yrgDQns3GX6aA4O3dVTS/NfDGUqfRLHJsam7LkboZupvsSAAXUH6wt2etitTQN+4+ScCkhqN3qltiWZ4lxU5fsfMpeVb1yAif+86pnZtu+SUEScJpFxV0EnTUgMR4XpWlt+cgquNwdLY8w/RE7t1Dj3as31JQtG6FEyHfMd5BXFZvjjZvqEHniVawN2aGfMb+tQ+eBHQfCUgVtyNutd5MLFe5iKP5xgQAIvLq2R3xCVVh0F52neMR7D80mpTgH+nP8liMgpuvbp4/xCG8F+Yd3Phy2lWCemKWKcVt6M6few7hjtOir3/lT6/3Wfym1qHE2xs07RKK4O0OVFUhUDm4LDM2PGxSO5xkWonMMw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A42E78E781B4974FB5BD9046D1F43B75@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e0487c-337e-4329-585c-08d6de6c9683
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 04:18:48.6046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3271
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=948 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS8yMS8xOSA5OjA5IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IA0KPj4gICBIaXQv
bWlzcyBoZXVyaXN0aWMgaXMgbm90IGNvdW50aW5nIGluZGV4IG1pc2NvbXBhcmUgYXMgYSBtaXNz
Lg0KPj4gICBPdGhlcndpc2UgdmVyaWZpZXIgc3RhdHMgYmVjb21lIHVuc3RhYmxlIHdoZW4gZXhw
ZXJpbWVudGluZw0KPj4gICB3aXRoIGRpZmZlcmVudCBoYXNoIGZ1bmN0aW9ucy4NCj4+DQo+PiBJ
ZiBpbnNuIGNvbXBhcmlzb24gaXMgZG9uZSBpbnNpZGUgc3RhdGVzX2VxdWFsKCkgdGhlbg0KPj4g
bWlzcyA+IGhpdCAqIDMgKyAzIGhldXJpc3RpYyBhZmZlY3RzICdjb2xsaXNpb25zJy4NCj4+IFRo
ZSBjYXNlcyB3aGVyZSBkaWZmZXJlbnQgaW5kaWNlcyBmYWxsIGludG8gdGhlIHNhbWUgYnVja2V0
Lg0KPj4gQW5kIHZlcmlmaWVyIHN0YXRzIGZsdWN0dWF0ZSB3aGVuIGhhc2ggZnVuY3Rpb24gb3Ig
c2l6ZSBjaGFuZ2VzLg0KPj4NCj4gDQo+IFllYWgsIHRoYXQgbWFrZSBzZW5zZS4gSSB3b25kZXIg
aWYgY3VyZnJhbWUgY29tcGFyaXNvbiBoYXMgc2ltaWxhcg0KPiBlZmZlY3QsIHN0YXRlcyBmcm9t
IGRpZmZlcmVudCBmcmFtZXMgc2VlbSBzaW1pbGFyIHRvIGhhc2ggY29sbGlzaW9ucw0KPiBiZXR3
ZWVuIGRpZmZlcmVudCBpbnN0cnVjdGlvbiBzdGF0ZXMgaW4gdGhhdCByZWdhcmQuIE9yIHRoZXkg
YXJlIG5vdD8NCg0KU2luY2UgY3VyZnJhbWUgaXMgbm90IHBhcnQgb2YgdGhlIGhhc2ggaXQgZG9l
c24ndCBoYXZlIHN1Y2ggcHJvcGVydHkuDQo=
