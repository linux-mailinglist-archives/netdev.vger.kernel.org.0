Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940FB2A6C8
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 21:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfEYTe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 15:34:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40046 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbfEYTe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 15:34:29 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4PJXeTo013917;
        Sat, 25 May 2019 12:34:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kjFwkEK44ugJ5yrTvFwAGEcNwMbh3zs6bQNy3KjB/7Y=;
 b=IDBl5WkrhCDeyn+7Y73lGNFOU34QIo/cYGrVm4rDFQ47kE5V7PgyaF/j4ltbcXxq4UCb
 he1kCcYSCsaPnylc3Y6cUcjFFlSodBAobZ1ivNJE05OkMDgDglonvpr4v63RIlsaN8V8
 ktOPgZT53sgPJW7SrFy+M1mOI3uozK4znjQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sq2t89210-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 25 May 2019 12:34:03 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 25 May 2019 12:34:02 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 25 May 2019 12:34:02 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 25 May 2019 12:34:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjFwkEK44ugJ5yrTvFwAGEcNwMbh3zs6bQNy3KjB/7Y=;
 b=PdcLVF6uKdL1HnTa96JjeyGVfKqnHnc38oL+oiipbpHwOPofmwvYk+XnO9sHP/r+8t6PpeA1aPrLSTSyEjSkWf56CmH+mUhOWtSYF8kSrLbGzDsKzaefjHhP70eNv6LGvghsRwZjUmAlsMSz98u/alR/rFxFxQvm6bsK8GW9jNI=
Received: from BN8PR15MB3380.namprd15.prod.outlook.com (20.179.75.139) by
 BN8PR15MB2753.namprd15.prod.outlook.com (20.179.139.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.22; Sat, 25 May 2019 19:33:45 +0000
Received: from BN8PR15MB3380.namprd15.prod.outlook.com
 ([fe80::9059:5076:c91d:672a]) by BN8PR15MB3380.namprd15.prod.outlook.com
 ([fe80::9059:5076:c91d:672a%7]) with mapi id 15.20.1922.021; Sat, 25 May 2019
 19:33:45 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>
Subject: Re: [PATCH] libbpf: fix warning PTR_ERR_OR_ZERO can be used
Thread-Topic: [PATCH] libbpf: fix warning PTR_ERR_OR_ZERO can be used
Thread-Index: AQHVEtivAG5/EXh3z0e90A/GY8EZ6aZ8O8cA
Date:   Sat, 25 May 2019 19:33:44 +0000
Message-ID: <2d147a2f-ac12-4e97-d281-c0d3463a5405@fb.com>
References: <20190525090257.GA12104@hari-Inspiron-1545>
In-Reply-To: <20190525090257.GA12104@hari-Inspiron-1545>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0017.namprd14.prod.outlook.com
 (2603:10b6:301:4b::27) To BN8PR15MB3380.namprd15.prod.outlook.com
 (2603:10b6:408:a6::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d262]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74e2ec2c-d58c-4e2a-019f-08d6e147e67b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR15MB2753;
x-ms-traffictypediagnostic: BN8PR15MB2753:
x-microsoft-antispam-prvs: <BN8PR15MB27536AE41B6439059972B685D3030@BN8PR15MB2753.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:213;
x-forefront-prvs: 0048BCF4DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(39860400002)(376002)(346002)(189003)(199004)(11346002)(446003)(476003)(2616005)(46003)(486006)(2906002)(25786009)(53936002)(14454004)(6246003)(5660300002)(478600001)(66556008)(66476007)(66946007)(73956011)(4744005)(66446008)(64756008)(99286004)(8936002)(81156014)(8676002)(81166006)(110136005)(2501003)(7736002)(305945005)(2201001)(86362001)(14444005)(256004)(7416002)(386003)(6506007)(53546011)(71200400001)(71190400001)(31696002)(76176011)(102836004)(52116002)(229853002)(6486002)(36756003)(6116002)(186003)(6436002)(6512007)(316002)(68736007)(31686004)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2753;H:BN8PR15MB3380.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iqZc0n/XW03W9ThAXTuyoeZFwGp11nEhgq3JT9/TRv7iLzwIG+YHKlPAMcab9hg0Dc2uO+h7aTbm/Mt9tN+6MWMgXGsp9o+qTn84ByzEH1NCZjM3IvZBMWDrDc3cIlE1RX/dTwzIDi//YGGrewvmIhjIYDirfQMbbarMid/zfAumlP5lsAidFhiEcm1OZVUyBOC2/0DN+aUZ9FtldJpRLhpSd/A2MSY1UxTaHcbXSM70GlilRsO9yOeKyfVnzUEnUNBiZdkCHnrJTShiIwTarF54VRcxZPQpoqLJ7X/9j4sYfqq9tJmv3u53UrbXyoTcaKjKAiczIPdxbWwgJGxGTxR/8ej79QHssXginLiJhDdrTaNgoY7o4VXVhvHDHVJT7hEsRSKM34tEsR1TytVOIOpaKP0VXXXb62BGJrL912s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39D77CFF63DBDE42824E52F6659BE541@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 74e2ec2c-d58c-4e2a-019f-08d6e147e67b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2019 19:33:44.9619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2753
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-25_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905250138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjUvMTkgMjowMiBBTSwgSGFyaXByYXNhZCBLZWxhbSB3cm90ZToNCj4gZml4IGJl
bG93IHdhcm5pbmcgcmVwb3J0ZWQgYnkgY29jY2ljaGVjaw0KPiANCj4gL3Rvb2xzL2xpYi9icGYv
bGliYnBmLmM6MzQ2MToxLTM6IFdBUk5JTkc6IFBUUl9FUlJfT1JfWkVSTyBjYW4gYmUgdXNlZA0K
PiANCj4gU2lnbmVkLW9mZi1ieTogSGFyaXByYXNhZCBLZWxhbSA8aGFyaXByYXNhZC5rZWxhbUBn
bWFpbC5jb20+DQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg0KPiAtLS0N
Cj4gICB0b29scy9saWIvYnBmL2xpYmJwZi5jIHwgNCArLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xz
L2xpYi9icGYvbGliYnBmLmMgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+IGluZGV4IDE5N2I1
NzQuLjMzYzI1YjYgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4gKysr
IGIvdG9vbHMvbGliL2JwZi9saWJicGYuYw0KPiBAQCAtMzQ1OCw5ICszNDU4LDcgQEAgYnBmX29i
amVjdF9fZmluZF9tYXBfYnlfb2Zmc2V0KHN0cnVjdCBicGZfb2JqZWN0ICpvYmosIHNpemVfdCBv
ZmZzZXQpDQo+ICAgDQo+ICAgbG9uZyBsaWJicGZfZ2V0X2Vycm9yKGNvbnN0IHZvaWQgKnB0cikN
Cj4gICB7DQo+IC0JaWYgKElTX0VSUihwdHIpKQ0KPiAtCQlyZXR1cm4gUFRSX0VSUihwdHIpOw0K
PiAtCXJldHVybiAwOw0KPiArCXJldHVybiBQVFJfRVJSX09SX1pFUk8ocHRyKTsNCj4gICB9DQo+
ICAgDQo+ICAgaW50IGJwZl9wcm9nX2xvYWQoY29uc3QgY2hhciAqZmlsZSwgZW51bSBicGZfcHJv
Z190eXBlIHR5cGUsDQo+IA0K
