Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29345F3BC4
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfKGWv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:51:59 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44736 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfKGWv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:51:59 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7Moaj2031291;
        Thu, 7 Nov 2019 14:51:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=AFpddRMRxBvOo3GVG9feQc/9oEjctkNTgFXNcFcaL4U=;
 b=FdwX6jfLV9w4lmezNHgee3uke+14gKbxQ/AsxQH4kj3IyZc+pjrrJ685HHSW9soEbRC+
 MLr2FT0KfXDokuV7gv6Z70beMhLhKRq3S2uJqkICeYHwVJ5JFIHUNoxItUg5rnoQNt9Y
 /ox63pVW6XJ6Y0bWmQqxkWIASXraQG9FU8M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41ue7xjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 14:51:44 -0800
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 14:51:43 -0800
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 14:51:42 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 14:51:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHaxlf+SQKfEFyAvsMYajB1Rv6FH3okIPVs5dq3zvTRG6t3Yhu0sKTY1pvhO/8JLd8qV6Y2rkFB65hKpxRPR/3qOSuvGr/de8gdK816qg5UykaMe1ynYbFCxd/eLPMkl6oSomze+tU/SOzYrYrlI5UUS3Td/sf2yUfW1iL/qel9i96B+ucmYxSnvGG/Vlh3xhQJm7Bl3kmyKB5a79h1gkQbxQN95dr/sKfst2ndubZH9CDDrndLENAE8iaJ4OoVV9Z3WiQ1eKHjZMschJRhQ6A/Jk9NY2fv5TZa4NDvda9kTJ3Ia8V1euOIbzmPaskTS8FDQDhGxVZuo5tYOqjpP1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFpddRMRxBvOo3GVG9feQc/9oEjctkNTgFXNcFcaL4U=;
 b=bTjf3Pt2alg0Kw984MxwLuPWafKXm6sTQUcJeQ3Po9GzcWMcBzracw4GjUHIw9Bp3fL0coGA5FxgMot/M94fh8D+o82n57EKxT33188MoBzKzRv/JlIMDFM4S+8Z8TJefxRHqiOHdvTQOuwDp6xmrTsb7Ojq05XA5jdD0lpd6Fn2oudVWRWBqPNGtXXFcDRFXfJd0dkjV9lEoBg6XS36IQpr2gbIBaIEAcyXcSykLUujr+mL2Hnkn+t19gRtbvDU6lx6b9ZtWH6gkVZNNULevDHwAkol9TEiKSoGZW3Ar0Jkw8+zPpeNKsek1LjtuqX7GQqfKukDwau3SZmu/0r2bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFpddRMRxBvOo3GVG9feQc/9oEjctkNTgFXNcFcaL4U=;
 b=BxBCM5asMLBJhF9HddzQDGSdEfXIDs/5/Hvg5X9O6hG6L9UXGMdJjbt68cebVqLm6JKPuZDLcs9hXXnVTH6J7LTo2cH0+eW/ImWOXp/kR4IPY/tBKgzjpc4HeyvkULTUmUhQl0wFZsCY4t6VHGOYJ/YJ6YK9+YMXdlxVFGVmS5M=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1485.namprd15.prod.outlook.com (10.173.234.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Thu, 7 Nov 2019 22:51:41 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:51:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 04/17] libbpf: Add support to attach to
 fentry/fexit tracing progs
Thread-Topic: [PATCH v2 bpf-next 04/17] libbpf: Add support to attach to
 fentry/fexit tracing progs
Thread-Index: AQHVlS7jYVIzh19QiEmCQVoPVUOiDaeAUXgA
Date:   Thu, 7 Nov 2019 22:51:41 +0000
Message-ID: <693CECA2-5588-43AD-9AC9-CF5AF30C4589@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-5-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-5-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::1:11cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0404093-58c3-4e42-acb2-08d763d50e1f
x-ms-traffictypediagnostic: MWHPR15MB1485:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB14858F584249596B15EB9266B3780@MWHPR15MB1485.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(136003)(39860400002)(366004)(199004)(189003)(33656002)(229853002)(305945005)(86362001)(36756003)(8936002)(4744005)(4326008)(5660300002)(71200400001)(8676002)(76116006)(54906003)(6116002)(14454004)(66946007)(71190400001)(66556008)(66476007)(316002)(64756008)(66446008)(50226002)(81156014)(46003)(5024004)(6486002)(186003)(446003)(256004)(6436002)(99286004)(6916009)(486006)(81166006)(25786009)(6246003)(11346002)(2616005)(476003)(2906002)(6506007)(53546011)(7736002)(102836004)(6512007)(478600001)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1485;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cjwO0taubwlh6AWwegoJLUAHa+IQzoempPrOc/PFF6dS7PtdWJWvhWPshd+pIpaGh6ozYMBO4zTbLaZFwmkCr2s6Q1hRdCIee/yHf1RjAANN/qY5TrSxYvsf1bu9r/pnPRB+C5cT3oDe8q3b6GW84i9sYNLlKCbOXhDhaO2o6l9/tPeS+YzGzktaYqsnwHU6Lkx42yGxpmC91o5GibIdaAWOg3L+ckHwQBMhHYFWc5STp4s47kGLg1wufV4P8czbJR7Gsky/gXXjwcVHF2zUgd1h+o9/8mkvN80QBRwNdJopnFVxCF2I39GlLnJt3rEz9ziMdTqwU9B9b9cy5WQN7R0o4jnWWArrVaUYP8tRvVZ0Oz92Vh289tl5dT30JqQsy8fwRuDbNs2mhGwMJLxcYG5Xl7yMk8FqpBmMmlgrracTR2GxE9FVI1w7AeUE20R2
Content-Type: text/plain; charset="us-ascii"
Content-ID: <828F2382CCC2FB459CD720F15E6BAC72@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e0404093-58c3-4e42-acb2-08d763d50e1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:51:41.0745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fc6/uby6mE0rVLQNBEXihpJ97VDLzlqdYgLzIjOSjdj9n5bV1Xb1kE4jUHkVeUSxaEgKERZ/TVY1afv205amqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1485
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=908 suspectscore=0 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070209
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Teach libbpf to recognize tracing programs types and attach them to
> fentry/fexit.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

With nit below:

> ---
> tools/include/uapi/linux/bpf.h |  2 ++
> tools/lib/bpf/libbpf.c         | 61 +++++++++++++++++++++++++++++-----
> tools/lib/bpf/libbpf.h         |  5 +++
> tools/lib/bpf/libbpf.map       |  2 ++
> 4 files changed, 61 insertions(+), 9 deletions(-)
>=20

[...]

>=20
> /* Accessors of bpf_program */
> struct bpf_program;
> @@ -248,6 +251,8 @@ LIBBPF_API struct bpf_link *
> bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
> 				   const char *tp_name);
>=20
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_trace(struct bpf_program *prog);
> struct bpf_insn;

attach_trace is not very clear. I guess we cannot call it=20
attach_ftrace? Maybe we call it attach_fentry and attach_fexit
(two names pointing to same function)?=20
