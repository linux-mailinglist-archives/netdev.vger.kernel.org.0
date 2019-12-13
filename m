Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B007511E95F
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbfLMRmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:42:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58282 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728413AbfLMRmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:42:02 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDHdaVl028814;
        Fri, 13 Dec 2019 09:39:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UBlwsEaVvq/o2MKNB3F/EvwG2nPvlMPfn334KZU0Kd0=;
 b=n7i5lplie0N0YPsQ5r9LDk8+W55R8cjGIU5q5CYLz/cJNv064hCumInpkfEB89srh42n
 stBY0EGFhB5NZPGUgNDrbao4qMC4bsM6JZtEfum6+AfERLNdeiOmR7f9QNIZ2ybkL8l5
 jQwnx1kpJFcvhlALHpBcubbMhijX0lmWmXc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wuskg5p0g-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Dec 2019 09:39:45 -0800
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 09:39:43 -0800
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 09:39:43 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 09:39:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrcrWkG6GIggKVEgUIQksRg1/KJW4teMWLOI+RAPKPiM8VsowVpK3Bb+Zu5JVwMeBbULZa1IjGRBNaMnXOl1SO9lwEYEUe0jahmRoHhrBCEtXb7xTL8B1zDQERK8JvamqWFGP+KgyXVrt3XtYpCCD2sn36vvLyE808h5+nYs9mqgpDpIQNKKI8G+YQZAFT438MEdOglaATMZurrq7IrKcxJttQMpQdDr5hScBGIdMu/rH5WtAPWmovkKRAD4nQMtktZKxSz9K7NHwfu/Fud5J+FNZUVhfPu/mrHhUKmwvN1FwPovB+vcqdSMin7fAQgubpNoDMT933p7xtfXSGB1yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBlwsEaVvq/o2MKNB3F/EvwG2nPvlMPfn334KZU0Kd0=;
 b=VLbzOrdl13OyAo68eiHFe18vYuycdq2OzoN1o0CkFXTM7+3C6/eTkb/K7TgF+ihYNgnQU3zYgiSgsYtWkfZqE/a5rC8no9+9a+gDrxe+nLFWoZEWqdyNKcOtsV8FOD6WqRXsR4JlJQz+2bxhRQ/V7PgFPCZGVwZeMHktU28gT+YbvuLLKfs6milwJ+NQzaJV3Mch5zB6DGBBvWk8aC2zL+2B20ixMc5VUupGpCa821x5lo9xQmHKQp/oY3RszDxYzj1uNamIdRF7PSoGyJUhFMuiPcySZBVUfviRPtvfEYys3QUyB7X35XUIWcq7yyXqHKVpoXHOT2zEjmSEaImH9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBlwsEaVvq/o2MKNB3F/EvwG2nPvlMPfn334KZU0Kd0=;
 b=gqSAz0y6h2kBqS9fgMfVowd3t5gxgS+JGo54yCgUPHf5pLVxxh4jXDxmhTWDIelUHv3PgI5bqgTuZBk/KQ0/J5wOLW8t9IapBNZ7mqP2hFiq8lermYZm5kSybJ1DMiRlMS/w4vT8QKzWhlKpDrl/Q3sjjw7p024liR/WYI37wsU=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1420.namprd15.prod.outlook.com (10.173.223.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Fri, 13 Dec 2019 17:39:41 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 17:39:41 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 04/11] bpf: add lookup and updated batch ops
 to arraymap
Thread-Topic: [PATCH v3 bpf-next 04/11] bpf: add lookup and updated batch ops
 to arraymap
Thread-Index: AQHVsHMsJhp01G9JEkiwq0k+wK0tCae4V64A
Date:   Fri, 13 Dec 2019 17:39:41 +0000
Message-ID: <877c575c-c929-1a84-f9c6-bb4b519b2229@fb.com>
References: <20191211223344.165549-1-brianvv@google.com>
 <20191211223344.165549-5-brianvv@google.com>
In-Reply-To: <20191211223344.165549-5-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:300:4b::26) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e8f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 363486db-c8c5-4e74-0e77-08d77ff36eef
x-ms-traffictypediagnostic: DM5PR15MB1420:
x-microsoft-antispam-prvs: <DM5PR15MB14202ABE355512291EBEB7D7D3540@DM5PR15MB1420.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(346002)(136003)(376002)(199004)(189003)(54906003)(52116002)(6506007)(2616005)(53546011)(66946007)(66556008)(66446008)(66476007)(64756008)(4326008)(6486002)(316002)(110136005)(81156014)(31686004)(6512007)(7416002)(81166006)(5660300002)(8676002)(31696002)(2906002)(86362001)(71200400001)(186003)(558084003)(478600001)(36756003)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1420;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PNXJZgwz9C3kaNiaeWEe9JZEvceq/FhlTSuLeUAEAYxdFkdjjA/LpC2CChsXt/j3T2qkTztCHcbj7Zqh7oCon6r7XVO3m34uEyLHbhTEeuaRzaq3f5TYIP5M9VOrgqki6UM8SttmlutdD9Risda8NQ/itfUqDvY21JVGpha6NAHhEG9gD+9LCgjy4rRwRK47ZsMpf3yzmNuKBUzdfB7WOMtllYGBKd3TVVVS6xPmzqu1TaEYBpcxWX2NPN67Ltuw9silTKN1RKTf0w2m0m2OVzBT1uAV17HP97XMD1TSxjRnmmK6Uh03hL2DajOujNZ284r+pLKNfKr3mNyVrjaiFnAKiyPOaU+weQ09Ns9VHmUQu0YMlWbhrkX/6mtlRG1fKBgE9rRi8chzGjSfFlVyPP3j0IgbwROp/WZDaqsRBc0J17PnPxyAc6o6kgE+gGb2
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8636CDF65CE2AF4EB5238571813DF5CA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 363486db-c8c5-4e74-0e77-08d77ff36eef
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 17:39:41.2654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D7Gvvbpim7WeUVMVlApDlegsPNqcZcOIeAVvZyV2GzoXNTBujWyrF5Vk1X3yjpF/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1420
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_05:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=732
 suspectscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912130140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzExLzE5IDI6MzMgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IFRoaXMgYWRk
cyB0aGUgZ2VuZXJpYyBiYXRjaCBvcHMgZnVuY3Rpb25hbGl0eSB0byBicGYgYXJyYXltYXAsIG5v
dGUgdGhhdA0KPiBzaW5jZSBkZWxldGlvbiBpcyBub3QgYSB2YWxpZCBvcGVyYXRpb24gZm9yIGFy
cmF5bWFwLCBvbmx5IGJhdGNoIGFuZA0KPiBsb29rdXAgYXJlIGFkZGVkLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogQnJpYW4gVmF6cXVleiA8YnJpYW52dkBnb29nbGUuY29tPg0KDQpBY2tlZC1ieTog
WW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg==
