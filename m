Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E738C522
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 02:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfHNAdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 20:33:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27130 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfHNAdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 20:33:12 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7E0OQcq013687;
        Tue, 13 Aug 2019 17:32:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SCA0lDxrZou3Nhxn+fHxRRQtvs2EvPrVxXg4FYd8fCg=;
 b=ZvnWUCsALDJjr3t7mAP1mXgiXh5wFRrnwFQCJDJ+d88HWgjVXo6JByGmJmbl1MX4h3g+
 /39i+wgpK6366D8jARM3kIvhbLPSHfVP7gTwIz2zM8YE308jSnFgcTSxnZ6KW57lPZxy
 GHbbqbc/aXpcc7cqA9YWFXCLbE0+SS+LP8o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uc4uhgqkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 13 Aug 2019 17:32:44 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 13 Aug 2019 17:32:43 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 13 Aug 2019 17:32:43 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 13 Aug 2019 17:32:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9bMCEIy77inKSWF5IHAqfPFjGHYfa+5sQLGbunDmqX1j/HV6yGtvVXohfITFrJhdbKBa+g90EdPENizktXgZThE+uvUoQfex/a4Wzu4FnvodoS9i1bI28fkObgMBc0YoYUn2Qn1hTNRjl4886Auw6Q/IXuqN1H61r1h//NMCbh74fJk0fzKFsAnrnAtbGXEhVnUtZeHGje5WTlQ6SNhmEpFTL1QXsU9NrNGLfYdJ2vMwbemQ2IuCywGU/JYJnKuwBnwoOgfASetvq2Twf/mq+BuG7u/vECcspsdi7xkmcB18T36Zese0Cgc37Pj9GrZSIkZEz+h8JictmLenQNwmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCA0lDxrZou3Nhxn+fHxRRQtvs2EvPrVxXg4FYd8fCg=;
 b=WNUnh4x+G+wF4yu2vuJbUVRVevGFbwECVOyx5SP9+uyhV1dc2LYcwzbv2amESSjytfc8tyvH549Znz3kZA9YxYstoW9wAaVHIqlgTmVPwU50lRExwmgSGQyfcIj4vSaa7zf6Iy/Um4iP9UXX0/RDNvpoK/oPQJSs59+NM4bSx/Z+ohdUdC3ImLTCXCuDeNSfNZ6k2xmd9/j1Ia6dmzjcxQbX6FO4RmCKsHrGF19X8hwEpjSVCsrNfJO7JE0J4Hjo/rZ5RuL/5QsZJjozH80V+cOdmyXYafhkF7HijLstvfqf4uCBJ9aCtElkBTsCcOcqCfZoi/zALsozIm5QF6bX3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCA0lDxrZou3Nhxn+fHxRRQtvs2EvPrVxXg4FYd8fCg=;
 b=HnzjABKDu0JYCQawZVt1pxSY6B3qrg7y4ukYJr6sUomp97SSRXZFsbMcK/UUXM9szJOszW3s+dntYYRtRvOAe6LE8oFLuFJLo9BgeN/XNLdDVRw5MejVOjakXwHqzz38rJ3rcZVs8rx1S7X4uGRio/OUPlK52Zz0S3CL9D7JJxI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3093.namprd15.prod.outlook.com (20.178.239.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Wed, 14 Aug 2019 00:32:42 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2157.020; Wed, 14 Aug 2019
 00:32:42 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Thread-Topic: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Thread-Index: AQHVUjfGKyrT2yAIekOTwiyoLftnBA==
Date:   Wed, 14 Aug 2019 00:32:41 +0000
Message-ID: <05e5d15b-5ef9-b4dc-a76c-0d423fb2f15d@fb.com>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:104:1::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:f941]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9820697-bd67-4a58-c4b3-08d7204eeae6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3093;
x-ms-traffictypediagnostic: BYAPR15MB3093:
x-microsoft-antispam-prvs: <BYAPR15MB309302F82675425A344404A9D3AD0@BYAPR15MB3093.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:158;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(366004)(346002)(396003)(189003)(199004)(8676002)(99286004)(7736002)(66476007)(64756008)(66446008)(81166006)(8936002)(256004)(66556008)(81156014)(25786009)(478600001)(4744005)(71200400001)(66946007)(71190400001)(52116002)(305945005)(316002)(110136005)(54906003)(2501003)(31686004)(486006)(5660300002)(229853002)(2906002)(6512007)(36756003)(31696002)(186003)(46003)(11346002)(476003)(2616005)(86362001)(446003)(76176011)(102836004)(6116002)(7416002)(6506007)(2201001)(386003)(53546011)(6246003)(6436002)(6486002)(4326008)(14454004)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3093;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: m614WIyVs4uvdyyxeu/xVoqOEFkbbYB3jqQvu5Us/L7nfrWKCmTLaBSCRBJSpSil9Me+6bvIpRYEMdpZvJkPQVjrK1tfI2ql9bjx7iSyea+vcQaj88c0UbCUDZYrcl+k+Yo9dqwJnBOAjlhv6coSJb77+w/t0bBosY7buajemEZAQeIn/fCxmLZ8l4gjjzSN0eRjN3EVxkbf85ACbh2WpC+xh+9O8jkzF5XsPr+ziemYjyzYSAMrhXnflGZQnmMbtcRxP1g+6/4PYbauFSMla7sRIli4QgNFUW4KqMYURn5tsH7cREbQqu+T8XxuT+l7FvC+fq1wkTrprylmbipbYQMO16cVUwkjNMV+xOd0aYS+yLP5FrSCZUcyg8b8UlYrCcz+Ir0Sol33D5VmqpQk3PiL4Orz1LY628owLwUU6K0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACBDF9403A26CA43B901796247CE5ED1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a9820697-bd67-4a58-c4b3-08d7204eeae6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 00:32:41.9443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Co7Un36MbXwc2bO2iU7TsoexBaWD0CC/a5L6fB+itbzrpC1QE1QFxjqVWrIGM5Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3093
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTMvMTkgMzoyMyBBTSwgSXZhbiBLaG9yb256aHVrIHdyb3RlOg0KPiBUaGF0J3Mg
bmVlZGVkIHRvIGdldCBfX05SX21tYXAyIHdoZW4gbW1hcDIgc3lzY2FsbCBpcyB1c2VkLg0KDQpJ
dCBzZWVtcyBJIGRpZCBub3QgaGF2ZSB0aGlzIGlzc3VlIG9uIHg2NCBtYWNoaW5lIGUuZy4sIEZl
ZG9yYSAyOS4NCk15IGdsaWJjIHZlcnNpb24gaXMgMi4yOC4gZ2NjIDguMi4xLg0KDQpXaGF0IGlz
IHlvdXIgcGFydGljdWxhciBzeXN0ZW0gZ2xpYmMgdmVyc2lvbj8NClNvIG5lZWRpbmcga2VybmVs
IGFzbS91bmlzdGQuaCBpcyBiZWNhdXNlIG9mIG9sZGVyIGdsaWJjIG9uIHlvdXINCnN5c3RlbSwg
b3Igc29tZXRoaW5nIGVsc2U/IENvdWxkIHlvdSBjbGFyaWZ5Pw0KDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBJdmFuIEtob3JvbnpodWsgPGl2YW4ua2hvcm9uemh1a0BsaW5hcm8ub3JnPg0KPiAtLS0N
Cj4gICB0b29scy9saWIvYnBmL3hzay5jIHwgMSArDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi94c2suYyBiL3Rvb2xz
L2xpYi9icGYveHNrLmMNCj4gaW5kZXggNTAwN2I1ZDRmZDJjLi5mMmZjNDBmOTgwNGMgMTAwNjQ0
DQo+IC0tLSBhL3Rvb2xzL2xpYi9icGYveHNrLmMNCj4gKysrIGIvdG9vbHMvbGliL2JwZi94c2su
Yw0KPiBAQCAtMTIsNiArMTIsNyBAQA0KPiAgICNpbmNsdWRlIDxzdGRsaWIuaD4NCj4gICAjaW5j
bHVkZSA8c3RyaW5nLmg+DQo+ICAgI2luY2x1ZGUgPHVuaXN0ZC5oPg0KPiArI2luY2x1ZGUgPGFz
bS91bmlzdGQuaD4NCj4gICAjaW5jbHVkZSA8YXJwYS9pbmV0Lmg+DQo+ICAgI2luY2x1ZGUgPGFz
bS9iYXJyaWVyLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L2NvbXBpbGVyLmg+DQo+IA0K
