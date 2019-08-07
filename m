Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E458385648
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 01:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388133AbfHGXEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 19:04:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52238 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729624AbfHGXEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 19:04:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x77MxUpi007838;
        Wed, 7 Aug 2019 16:04:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dxpnxn8we0tO3lD2KVxw0YyMV2oGAXpddRWMNhUy25o=;
 b=Uo1iUPmgfK4GRHZavbvTxXWkByZn839WsU73FYKevqMKNxMIgn1/bmVY+QGAWtjowbZw
 gVw3rUj2h1NOh1VkC/G9KhrkP+JJd4u/YInFLQ2n0zQ51q4xX9auxtSxUk7SP+s6eqXQ
 uOEEll2H7ysNInd+8yAv/L2ELpd1Vtf3FpQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u87uf00ys-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 07 Aug 2019 16:04:15 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 7 Aug 2019 16:04:04 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 7 Aug 2019 16:04:04 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Aug 2019 16:04:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5RpUDHSGpD2Z5KyXw9q0ty8C/czEX8UPFRWcxPDO4Pr6cFYN8tRgUQHHXuS6zdmcgDr/HpkUr3HsqbZ4vEnVLuy6PNTYzpxWkEuWaVlJIR/Qm6RkPEHVbcy1Zclb/VndRYCAV5BY+PZBJVRbsHA19ZgrYPCDurxANz5/R+0oKqkPnkgarD1CyQmUxpG1YjUuCyg8hP9OyHe9nMcUznmAcjDJmoYK8MjA1JdTAqAim+NXgjnfvNu7QUFHTI8puwQQtgEZbYpKZ322MYj0gkFTTtP8tZ3j0SR1oa7e/QS4FAfLbRKw+DJvOaxHaCeJh5NBjggXXtOf77u7OzAUspGqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxpnxn8we0tO3lD2KVxw0YyMV2oGAXpddRWMNhUy25o=;
 b=XtwHbbCj0Upb+HpW9F+kCqcXJfxxeqmcFDPU7QFiszC7ujvIlP0TGRKSjOfjuGsAe4vG8LSTa/6H1eYti3X1vJ3KS/qX0kWiHjdGtDiLrQA2qhRuPHHHLTi4wWqj9ktn52qSGw5Bl/wbmj69JGgxwIhVAv1DIAgH+jLijNmYYh0ZwB7PFG5GLkcAiCqyIiezOZjPfTH5BDs2nCQe5vy3empK5QzsBCZ0LuIEPFzwLnw3wfzb8gpZesL5Ojx388AGqePJkmmAaja46BxIw0JOw90Rkjji/BPybjVZUZw6RlA8pZuJZZKZpyTeUA5zj5BKWZUvQlpTfw6HweG6xYSvdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxpnxn8we0tO3lD2KVxw0YyMV2oGAXpddRWMNhUy25o=;
 b=N5Dqf+oJ9MQM7WLrT0umGcqrhPLKiFIhVtjOUZTSzJGSCzbFM4OKTMHptHJszlogjT+jN2Nv7O/yLXIB8v9SETqjnH7d5qNIjVABdjGsBrtdgOjeDHlM+eZIUEabhZuaSyn02Fsbhv6tbznRyH69cRnhN3AHaQj6EQmZkg9bbLY=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2694.namprd15.prod.outlook.com (20.179.156.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 7 Aug 2019 23:04:02 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 23:04:02 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: sync bpf.h to tools/
Thread-Topic: [PATCH bpf-next 2/3] bpf: sync bpf.h to tools/
Thread-Index: AQHVTTd0hAOS9SaX/EaumVlEfV2IPKbwTl0A
Date:   Wed, 7 Aug 2019 23:04:02 +0000
Message-ID: <372653d3-4d54-f242-8a33-265b8fa95807@fb.com>
References: <20190807154720.260577-1-sdf@google.com>
 <20190807154720.260577-3-sdf@google.com>
In-Reply-To: <20190807154720.260577-3-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR06CA0054.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::31) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:f6d1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40d1b5b1-90d9-43be-faa2-08d71b8b89f3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2694;
x-ms-traffictypediagnostic: BYAPR15MB2694:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB269427CB96D9581A000A39C2D3D40@BYAPR15MB2694.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(39860400002)(366004)(396003)(199004)(189003)(86362001)(2501003)(478600001)(5660300002)(316002)(31696002)(2201001)(7736002)(54906003)(4744005)(305945005)(6512007)(66446008)(14454004)(11346002)(81166006)(81156014)(8936002)(446003)(8676002)(6116002)(110136005)(53936002)(66946007)(66476007)(64756008)(4326008)(52116002)(102836004)(76176011)(99286004)(476003)(386003)(31686004)(53546011)(14444005)(256004)(6506007)(2616005)(229853002)(25786009)(486006)(71200400001)(71190400001)(6246003)(46003)(186003)(6436002)(6486002)(36756003)(66556008)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2694;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gs6zoQyt1ytB/+/57YMOlI3KuS6OF7rTJnlIUpj5es9rorllUcgyngMDi1Y8K7Sqh7U5eKAvlxUIpDPEu9t671ko5/Ios3ZOgKSrmHmNVTUfw70+puk+Mk7GWlhFV4ywSNZOQbRypquk7INEPPed/3/HWyHYNtyY2O4JK8HC+sjkVIIM36t3la3l2yYqav46NMYvAHofIGPEtCuD6joCDQHx46aOGUoaPit6O1CVHge4+jiicyplHI0DNHn4bnjHpMMudtZ3VoVM7iggaPvI1zWpp3r8+SrKGx8C8S3N27RuLA4zuGMNkp4yTmmQczzIQiBORbC4EdfoNYvI3SWMxkP8WqDxw1dcaVFd91faAzl/tkJejYBHOqdKWLBV1gYYAtS2UeSHDlNa3SChzE3rTMwhV/Q/HC0mHeaJnJYWCkY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22DF12EC9812EB42B116413BF4711032@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d1b5b1-90d9-43be-faa2-08d71b8b89f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 23:04:02.7035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2694
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=746 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvNy8xOSA4OjQ3IEFNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IFN5bmMg
bmV3IHNrIHN0b3JhZ2UgY2xvbmUgZmxhZy4NCj4gDQo+IENjOiBNYXJ0aW4gS2FGYWkgTGF1IDxr
YWZhaUBmYi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFN0YW5pc2xhdiBGb21pY2hldiA8c2RmQGdv
b2dsZS5jb20+DQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KDQo+IC0t
LQ0KPiAgIHRvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaCB8IDEgKw0KPiAgIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2luY2x1ZGUv
dWFwaS9saW51eC9icGYuaCBiL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPiBpbmRl
eCA0MzkzYmQ0YjI0MTkuLjAwNDU5Y2E0YzhjZiAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvaW5jbHVk
ZS91YXBpL2xpbnV4L2JwZi5oDQo+ICsrKyBiL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYu
aA0KPiBAQCAtMjkzMSw2ICsyOTMxLDcgQEAgZW51bSBicGZfZnVuY19pZCB7DQo+ICAgDQo+ICAg
LyogQlBGX0ZVTkNfc2tfc3RvcmFnZV9nZXQgZmxhZ3MgKi8NCj4gICAjZGVmaW5lIEJQRl9TS19T
VE9SQUdFX0dFVF9GX0NSRUFURQkoMVVMTCA8PCAwKQ0KPiArI2RlZmluZSBCUEZfU0tfU1RPUkFH
RV9HRVRfRl9DTE9ORQkoMVVMTCA8PCAxKQ0KPiAgIA0KPiAgIC8qIE1vZGUgZm9yIEJQRl9GVU5D
X3NrYl9hZGp1c3Rfcm9vbSBoZWxwZXIuICovDQo+ICAgZW51bSBicGZfYWRqX3Jvb21fbW9kZSB7
DQo+IA0K
