Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207AE2E401
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfE2SCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:02:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45984 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727381AbfE2SCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 14:02:21 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4THxWGN020264;
        Wed, 29 May 2019 11:02:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=uZtKwRRwP37PTjxCXjiS0dgDZhSthSqgQLWVUGSTTLw=;
 b=A92s+h7HOB3DykmjJLH3gq2Y80ndP03QW/mRHPslQ3pclGvpln5LN7wzh1jF/is9kEJ8
 Hb2cPfabPPOriRNaAqBEAb5KXAEDoXR/XkC8AWToj/XE2RF3GYxkbqYLc15eRnfVI7FB
 vc4oMX5N1wkBtO14Wh3/DioZtcv4P3azyxo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ssv0errj7-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 May 2019 11:02:00 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 29 May 2019 11:01:57 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 29 May 2019 11:01:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZtKwRRwP37PTjxCXjiS0dgDZhSthSqgQLWVUGSTTLw=;
 b=c+UZpd14QtoyHn0tgUuUWeqHE+8swfhT2F+Wd/UM/qojnnQ8syIxMONGScXxfINOy7GhUWwglA+DZKJlOFtH9AjRgPw4cL7673hiXTl3VBGtW3P5yBqNzdjuSBNYt8GXDdR6Af1A7naNlugPcJn7j2P1QYxyT7FLchADkJoiBEQ=
Received: from BN6PR15MB1154.namprd15.prod.outlook.com (10.172.208.137) by
 BN6PR15MB1617.namprd15.prod.outlook.com (10.175.129.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Wed, 29 May 2019 18:01:55 +0000
Received: from BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::adc0:9bbf:9292:27bd]) by BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::adc0:9bbf:9292:27bd%2]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 18:01:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/9] libbpf: fix detection of corrupted BPF
 instructions section
Thread-Topic: [PATCH v2 bpf-next 1/9] libbpf: fix detection of corrupted BPF
 instructions section
Thread-Index: AQHVFkU4QWKZcRhogUKP54f2SWIibKaCZKcA
Date:   Wed, 29 May 2019 18:01:55 +0000
Message-ID: <050E74F9-AF14-4815-A97A-6A77766D7767@fb.com>
References: <20190529173611.4012579-1-andriin@fb.com>
 <20190529173611.4012579-2-andriin@fb.com>
In-Reply-To: <20190529173611.4012579-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:e408]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21663e47-ed05-4bf0-adf9-08d6e45fbcbf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR15MB1617;
x-ms-traffictypediagnostic: BN6PR15MB1617:
x-microsoft-antispam-prvs: <BN6PR15MB161768B4AC6D593512BC199BB31F0@BN6PR15MB1617.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:51;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39860400002)(366004)(376002)(136003)(199004)(189003)(68736007)(2616005)(476003)(6512007)(11346002)(446003)(486006)(14454004)(305945005)(2906002)(54906003)(57306001)(186003)(6636002)(76176011)(53546011)(6506007)(99286004)(33656002)(6116002)(66556008)(66476007)(7736002)(25786009)(36756003)(478600001)(46003)(82746002)(81166006)(8936002)(6862004)(64756008)(4326008)(8676002)(229853002)(81156014)(6436002)(6486002)(66946007)(73956011)(91956017)(76116006)(37006003)(256004)(83716004)(14444005)(71200400001)(71190400001)(86362001)(5660300002)(102836004)(50226002)(316002)(6246003)(53936002)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR15MB1617;H:BN6PR15MB1154.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: h5ZGooUZ8ZEEdZhTKxQRHBSED/59UGe6w+wILgMNnLJvj66Nn404HC5nXkKCRyCTMiJ8m5COBPOx/cVbUvQmxbUWs+8NYnnY1BOrY1hgcKcA7EUI3vP7D25OPemQVnmQLH4BywJTY+X1zNlpZtx0hW9LrnIDkstS7z45TnDIK/RcSzUAKXkewePIUAdGOdPwafvUiWpYmTMYuwS06FBXT6CimmDqS/mbydGMnJBrI/Ttm0q9So+YAsxV34ju1pPnf/PFwsBKv6bbsO4lubzgZ4muLcKwLlC9Eqwv5LGgrwyfYbtBEuYnBoQzK3phq33ZJ+B0MeBG/rH2dXb2rdm99D9MCPa6w7mIdHcZu5Ik5yQxXklYLzbAZmSbfLeobwxSkgGKMp9tKU7MjSq23PCCW3mMVXIi59yx1dlKaSQ25U8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DDB9D5E7F3A3264C89F0BB7754862205@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 21663e47-ed05-4bf0-adf9-08d6e45fbcbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 18:01:55.7827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1617
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290117
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 29, 2019, at 10:36 AM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Ensure that size of a section w/ BPF instruction is exactly a multiple
> of BPF instruction size.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/lib/bpf/libbpf.c | 12 +++++++-----
> 1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ca4432f5b067..c6c9d632624a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -349,8 +349,11 @@ static int
> bpf_program__init(void *data, size_t size, char *section_name, int idx,
> 		  struct bpf_program *prog)
> {
> -	if (size < sizeof(struct bpf_insn)) {
> -		pr_warning("corrupted section '%s'\n", section_name);
> +	const size_t bpf_insn_sz =3D sizeof(struct bpf_insn);
> +
> +	if (size =3D=3D 0 || size % bpf_insn_sz) {
> +		pr_warning("corrupted section '%s', size: %zu\n",
> +			   section_name, size);
> 		return -EINVAL;
> 	}
>=20
> @@ -376,9 +379,8 @@ bpf_program__init(void *data, size_t size, char *sect=
ion_name, int idx,
> 			   section_name);
> 		goto errout;
> 	}
> -	prog->insns_cnt =3D size / sizeof(struct bpf_insn);
> -	memcpy(prog->insns, data,
> -	       prog->insns_cnt * sizeof(struct bpf_insn));
> +	prog->insns_cnt =3D size / bpf_insn_sz;
> +	memcpy(prog->insns, data, size);
> 	prog->idx =3D idx;
> 	prog->instances.fds =3D NULL;
> 	prog->instances.nr =3D -1;
> --=20
> 2.17.1
>=20

