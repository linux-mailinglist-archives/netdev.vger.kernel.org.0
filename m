Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B44B57120
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfFZS6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:58:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30964 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfFZS6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:58:13 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QItQR7018876;
        Wed, 26 Jun 2019 11:57:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vqbZ6HuwBTXTRJtqv4b+9il/FV7h6hXeK2PtPOF6u0A=;
 b=Jhge7YFKvkzWFQEPyFW55z5zMKIhSnWocRPMyu9Q/lHOGTyfEdPW6og/5jIxuIrTGx7z
 qq1NOYaV2ZUrS7HKFeSUHdSP8DH+DvpOqa7eBCZvcj2T0MnMpnlmJjstWvm5kyPyzrB6
 E0u5/LZJpm0RCd3WTvwo31J8ft6uno5oZ0o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tcctkge32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Jun 2019 11:57:52 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 26 Jun 2019 11:57:49 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Jun 2019 11:57:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vqbZ6HuwBTXTRJtqv4b+9il/FV7h6hXeK2PtPOF6u0A=;
 b=FWRwtsR6ncYAqf4LZciC/DKaYHIYtj8WDQ+4rUSik3za3xnNoxsPgNg0037zrDlC6G/lkack8B101+q2MFIWogyu1WqsX3Jab8JapfwaHF7QwgVBLww0ZIkSnabbof4o8vFzudxi7c2yzRgAHNQVH2X2sqnO0ClPl4iwatF3WHU=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1760.namprd15.prod.outlook.com (10.174.97.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Wed, 26 Jun 2019 18:57:49 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 18:57:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: auto-set PERF_EVENT_ARRAY size to
 number of CPUs
Thread-Topic: [PATCH v2 bpf-next 2/3] libbpf: auto-set PERF_EVENT_ARRAY size
 to number of CPUs
Thread-Index: AQHVK+Ywm19X09A+CUGz9GX/LXhW3qauSksA
Date:   Wed, 26 Jun 2019 18:57:49 +0000
Message-ID: <3E535E64-3FD8-4B3D-BBBB-033057084319@fb.com>
References: <20190626061235.602633-1-andriin@fb.com>
 <20190626061235.602633-3-andriin@fb.com>
In-Reply-To: <20190626061235.602633-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6898]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1103c2c-1428-4d00-5c81-08d6fa682f37
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1760;
x-ms-traffictypediagnostic: MWHPR15MB1760:
x-microsoft-antispam-prvs: <MWHPR15MB1760C0CCA8C2E8926F8F13FBB3E20@MWHPR15MB1760.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(136003)(376002)(366004)(199004)(189003)(6246003)(50226002)(8936002)(186003)(14454004)(46003)(33656002)(81166006)(305945005)(71190400001)(8676002)(71200400001)(37006003)(36756003)(2906002)(7736002)(81156014)(6116002)(99286004)(54906003)(229853002)(66946007)(73956011)(5660300002)(76116006)(6862004)(53546011)(53936002)(86362001)(4326008)(25786009)(76176011)(316002)(6512007)(66556008)(64756008)(478600001)(11346002)(446003)(486006)(476003)(102836004)(66476007)(256004)(57306001)(6486002)(6436002)(68736007)(2616005)(14444005)(6636002)(66446008)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1760;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6l3IQ0SxKCIhDHa87q7mGq4hyE4KhjGcZ8yFV2+RP+n3sswZlP5JcuhBwXIKQ/wnz1yQ/ZZNRaFwcqZgxBuorxktgFMJ11t40rEgJEnnLOzQQaQuDsS/m+4CjywuGV4hJDqwNsWQXdGt/kfSG2stG8RpUNVG050v5ZEASKojKcWIySHEREekbXUCsu6Sl00SHWOiXVCzYdA4JnQfV+qt8n8udAHoBfJz1Fw1QJiYJjn9JqphjTCeopUBFwv0ShR8YdUa+2VOXoNmJA9U3C3OqSGO8eNw1G/uNsZZnCXqUEzkyihsE7k80Hq8XNIBYewceso0m8DqhFFUjJRlpmmiId5KgBSrt2YCs25bCo0DV7YyT7MD9HnRqVCocfoQdcO/MzsZU3xxlS3vIOLnstwc/p7dZ7cZ52VIucu2h8DmenA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0F479F8EE39C0A4BB087829B83FAA847@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f1103c2c-1428-4d00-5c81-08d6fa682f37
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 18:57:49.3152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1760
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260219
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 25, 2019, at 11:12 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> For BPF_MAP_TYPE_PERF_EVENT_ARRAY typically correct size is number of
> possible CPUs. This is impossible to specify at compilation time. This
> change adds automatic setting of PERF_EVENT_ARRAY size to number of
> system CPUs, unless non-zero size is specified explicitly. This allows
> to adjust size for advanced specific cases, while providing convenient
> and logical defaults.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/lib/bpf/libbpf.c | 17 ++++++++++++++++-
> 1 file changed, 16 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index c74cc535902a..8f2b8a081ba7 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2114,6 +2114,7 @@ static int
> bpf_object__create_maps(struct bpf_object *obj)
> {
> 	struct bpf_create_map_attr create_attr =3D {};
> +	int nr_cpus =3D 0;
> 	unsigned int i;
> 	int err;
>=20
> @@ -2136,7 +2137,21 @@ bpf_object__create_maps(struct bpf_object *obj)
> 		create_attr.map_flags =3D def->map_flags;
> 		create_attr.key_size =3D def->key_size;
> 		create_attr.value_size =3D def->value_size;
> -		create_attr.max_entries =3D def->max_entries;
> +		if (def->type =3D=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY &&
> +		    !def->max_entries) {
> +			if (!nr_cpus)
> +				nr_cpus =3D libbpf_num_possible_cpus();
> +			if (nr_cpus < 0) {
> +				pr_warning("failed to determine number of system CPUs: %d\n",
> +					   nr_cpus);
> +				return nr_cpus;

I think we need to goto err_out here.=20

Thanks,
Song

