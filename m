Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 210ADF4080
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfKHGkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 01:40:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2920 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbfKHGkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 01:40:09 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA86XcME023920;
        Thu, 7 Nov 2019 22:39:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IBDC/DfzvVR7b0XB+JzW7mCmWYSVNhUX1yhdnX1pRk4=;
 b=Agx8tPxXYCJvVyF7Qee82/AWsBGYyAP9j987Y7OJbtTcPVLw9F05lN2P5DJicRhXwkYg
 XiRd9gDQS5s38yXtY1APU7c01uO3df26IhwBx33iv//skDoqqz3tcnzB/trT0e8QT8xN
 8lKO+u373wtA8AbOfCtoqpfMrpqVoP3pr4g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vy1vx4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 22:39:46 -0800
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 22:39:46 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 22:39:45 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 22:39:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WehA6l5PXTvHLW1+g8HyBY5DKrRZxZnJC5Y7q11qc9XyGphwwbRxzZALY8TWXqjKIGIprGK6UsHUvl8S0dGfXubP5xxbePUPxBIvgFwt9YQbKiXq9H6Nzm0y61IZmHmWzOhNnijlLZTT6+vH9IMiSBhu2/SjS+v63C4uVMrZH6Mh2TdaXwmfjU7BrLcmYV7SVY84+mJUy9KOI/px0KM9FcRkbSXIEpTwAHooaAjBWTgxyRcj3/lF/xY5PHBu32tvAGd/xsSFy384ZOR5/VL54d4Rhu9zRE8m+iwKnIuuCUV8mbnm8/WUDY8y4l+IgMf7FaMGmEqpzVPYuFoH7nWSng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBDC/DfzvVR7b0XB+JzW7mCmWYSVNhUX1yhdnX1pRk4=;
 b=Ai3ZQXmjrZ/poqkLDogye1t3E6icmRqXRZTT7wQYk08zgJn4R6OFfX1T0Vz+d7n+Gbvp35mGbVcOFcKUypBaB0XMH9Hs3i8e+RtvhvSavMZsQHGZYrAEjRN5WqxAcr22Q/c/0GP5u6u+ETXXvpyqI/oaBys2BlVwHxh0dd/7eHEE/+zRzNZbU1FVnnn4NKndZL488atSJIfsehhmWHt4oBSFN2TBuG6nCwknRvkSTUqvZuznN5GfDcHfevx5iRuoev7LzYDx/qNyANbDKWSOxBvtKVh+NYUWU7OjB23jqH1h5IG5PNnsDl8m8rsv/YGYF1BMud7B+to+9XNzCx+clQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBDC/DfzvVR7b0XB+JzW7mCmWYSVNhUX1yhdnX1pRk4=;
 b=CVrQ7YOd6+DCgPNRJ6x+D37k6lQD+lP1ahfJ05v4ggdi8bjcECIWMLlmalieXwwQd+u8BtIUbzCSZs3iu92Vs2GdxAXo2E+m9vtuCSrJE/LhEyOQi88xW2i3qh4jXcrItDK+2snERHSvFT88w1a33tlY9ymzILZvbpu06jnWOVw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1950.namprd15.prod.outlook.com (10.175.2.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Fri, 8 Nov 2019 06:39:44 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 06:39:44 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next 1/3] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Topic: [PATCH bpf-next 1/3] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Index: AQHVlevuobT30QigFUGH2JlZwZjdj6eA0sOA
Date:   Fri, 8 Nov 2019 06:39:44 +0000
Message-ID: <94BD3FAC-CA98-4448-B467-3FC7307174F9@fb.com>
References: <20191108042041.1549144-1-andriin@fb.com>
 <20191108042041.1549144-2-andriin@fb.com>
In-Reply-To: <20191108042041.1549144-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e36b6d6-12df-4fb1-8438-08d7641670ea
x-ms-traffictypediagnostic: MWHPR15MB1950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB19504529709654E8A03222F8B37B0@MWHPR15MB1950.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(39860400002)(396003)(346002)(189003)(199004)(229853002)(37006003)(54906003)(6436002)(6486002)(86362001)(2616005)(64756008)(66446008)(66476007)(476003)(486006)(6246003)(66946007)(66556008)(446003)(6862004)(46003)(11346002)(4326008)(5660300002)(76116006)(186003)(305945005)(256004)(7736002)(14444005)(6636002)(478600001)(102836004)(6506007)(53546011)(71200400001)(71190400001)(76176011)(14454004)(2906002)(99286004)(316002)(50226002)(8676002)(33656002)(81156014)(8936002)(81166006)(36756003)(6116002)(6512007)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1950;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZcmGtKXqP52Tt7UJIRWKtwFtnga0mveNGmoWOfrxWU8d9tDL0xrle+uXixsY8fUJZ8mrolElkGsJ0y5LzIcsExUzZNxsddANApISqA4jwmkLFEDF0Y1v7qkggigZ4J6BsF0tyWnsDi3x3WPPkVLwKg09F6xWiaoeX9SfEd+20SLd2yOb1W7FLGnt8FMPUrerVoemUZfsKTtN52IJ1Qi4iaUCrXC+7AXY7D87+PnYH0kOGAtX8MjAgBEdBw/1Z6teZfqSMIKUuNe0yez9zc69coB3fZF1SwX+laZV4YVPonPbgk0hd+8ylD9N4rWSB5FKqpAz1JpkfJ0XI5cUuFH/n0UhjlV1PZdht/iQAYwjVvEnsG8W39CAQgieg8ksycjSJt9jbNdOH1fHoRIiTxPmMYAPfr8Ds1rd12kaJoLQ8exfrhiwJ3u8zri0n1wxIh7w
Content-Type: text/plain; charset="us-ascii"
Content-ID: <315663F0F9B1B74796DD7C74E49CFAEE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e36b6d6-12df-4fb1-8438-08d7641670ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 06:39:44.1150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SmZON9wcauonpYT9ROq5ZX6r8UB1P6E91U0VJUVYb3zfO+rdV0GN8OPIpMSUPl04Q4T4zewyLNM4Pw0Rfimo6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1950
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=862
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 8:20 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add ability to memory-map contents of BPF array map. This is extremely us=
eful
> for working with BPF global data from userspace programs. It allows to av=
oid
> typical bpf_map_{lookup,update}_elem operations, improving both performan=
ce
> and usability.
>=20
> There had to be special considerations for map freezing, to avoid having
> writable memory view into a frozen map. To solve this issue, map freezing=
 and
> mmap-ing is happening under mutex now:
>  - if map is already frozen, no writable mapping is allowed;
>  - if map has writable memory mappings active (accounted in map->writecnt=
),
>    map freezing will keep failing with -EBUSY;
>  - once number of writable memory mappings drops to zero, map freezing ca=
n be
>    performed again.
>=20
> Only non-per-CPU arrays are supported right now. Maps with spinlocks can'=
t be
> memory mapped either.
>=20
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

With one nit below.=20


[...]

> -	if (percpu)
> +	data_size =3D 0;
> +	if (percpu) {
> 		array_size +=3D (u64) max_entries * sizeof(void *);
> -	else
> -		array_size +=3D (u64) max_entries * elem_size;

> +	} else {
> +		if (attr->map_flags & BPF_F_MMAPABLE) {
> +			data_size =3D (u64) max_entries * elem_size;
> +			data_size =3D round_up(data_size, PAGE_SIZE);
> +		} else {
> +			array_size +=3D (u64) max_entries * elem_size;
> +		}
> +	}
>=20
> 	/* make sure there is no u32 overflow later in round_up() */
> -	cost =3D array_size;
> +	cost =3D array_size + data_size;



This is a little confusing. Maybe we can do=20

	data_size =3D (u64) max_entries * (per_cpu ? sizeof(void *) : elem_size;
	if (attr->map_flags & BPF_F_MMAPABLE)
		data_size =3D round_up(data_size, PAGE_SIZE);
=09
	cost =3D array_size + data_size;

So we use data_size in all cases.=20

Maybe also rename array_size.


> 	if (percpu)
> 		cost +=3D (u64)attr->max_entries * elem_size * num_possible_cpus();

And maybe we can also include this in data_size.=20

[...]

