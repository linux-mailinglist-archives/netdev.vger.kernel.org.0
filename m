Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1550148B57
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfFQSID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:08:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725764AbfFQSIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:08:02 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HI76p5008596;
        Mon, 17 Jun 2019 11:07:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VtQzpyV6x+wYllqwvsEnf0Lt0GN4rZ65Cc+SA+a1KA4=;
 b=SZbfb/E5FkMD+ra2qz2tc1S0cySYIWvxWdg6doXtEL3nfMzkRosJsu8CsCAOYb6aC1+c
 Jpcw7S0bKsneQMCHUKkKm2/Uf6EdTtYObg+gXOcWtEuq8DIh0fo56nJsxDOlKzg8Mfek
 xIU10kvxXZfoeHa8W8e5OmsiLS5MpnHczy4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2t6bn010c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 17 Jun 2019 11:07:42 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Jun 2019 11:07:41 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Jun 2019 11:07:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtQzpyV6x+wYllqwvsEnf0Lt0GN4rZ65Cc+SA+a1KA4=;
 b=E5qKyzm0c5uPADgMBpqt8YmpWDQ1MlMRwpYhsmuQEjEc4o1jXdoIHaD9XLwLWdJurmoHM9X+5v/AZaLb5qWUmEkHasfe+I6llf7h1aiEq/9Oy80bMll9NB19JqgiPqoR1U9h5Xa/dnhqJ63HLTTaBdRaFhrzHWpUMMt8C0sKmcM=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1182.namprd15.prod.outlook.com (10.175.3.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 18:07:39 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 18:07:39 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/8] libbpf: extract BTF loading and simplify ELF
 parsing logic
Thread-Topic: [PATCH bpf-next 2/8] libbpf: extract BTF loading and simplify
 ELF parsing logic
Thread-Index: AQHVIBDn0fjzpBv67EKUzcZw1EqvGKadMO4AgALyFwCAAAvwgA==
Date:   Mon, 17 Jun 2019 18:07:39 +0000
Message-ID: <8F07D61C-2751-44A6-9E89-9BE6781FEF81@fb.com>
References: <20190611044747.44839-1-andriin@fb.com>
 <20190611044747.44839-3-andriin@fb.com>
 <CAPhsuW6kAN=gMjtXiAJazDFTszuq4xE-9OQTP_GhDX2cxym0NQ@mail.gmail.com>
 <CAEf4BzY_X9jPvwgcVQozS4RyonXEK9mkd58uvPVrjFi-Gvui3Q@mail.gmail.com>
In-Reply-To: <CAEf4BzY_X9jPvwgcVQozS4RyonXEK9mkd58uvPVrjFi-Gvui3Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:da81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcaeff1c-89cb-479c-a619-08d6f34eaf42
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1182;
x-ms-traffictypediagnostic: MWHPR15MB1182:
x-microsoft-antispam-prvs: <MWHPR15MB1182A53882117EFAC8072D3DB3EB0@MWHPR15MB1182.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:117;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(366004)(346002)(396003)(199004)(189003)(99286004)(53936002)(14444005)(66446008)(64756008)(66476007)(66946007)(73956011)(76116006)(54906003)(486006)(102836004)(76176011)(53546011)(6506007)(46003)(316002)(6916009)(256004)(478600001)(50226002)(57306001)(68736007)(446003)(11346002)(6246003)(4326008)(66556008)(476003)(25786009)(86362001)(2616005)(186003)(6116002)(8936002)(2906002)(5660300002)(71190400001)(36756003)(6486002)(305945005)(81166006)(81156014)(7736002)(33656002)(229853002)(8676002)(6512007)(14454004)(6436002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1182;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bNPgHD+APyUPSjxEV9i+CNdOds5hWRYMWDB2cuX6H4nsFFOX5wd6QvqXYomJbq4Jiy9YKy6Rm01LqXgzNhYrGnxnE3tGK98uhods2xsqOaNlPdmHRUKmH/N334tDIrgTTAgA+axjSfyds0PRMoc9h4hier5Y9JU+6YrbVX52IzhbmCBeuAKtLgRdyqURIXZXgSmbe7tX1djpaMUBKb4e+uVJYWJlvt2Xq6rXm187exwv2lie/1Bvwr9eTUNLSsNsxA8yMmAkOGZblaQGe1hDvBsvWpvW0Rmrrl3NE/wzqgYXlElnhzB1TQpLCYtNAvuxzvWLR+hHQMwdKTSw5pkWDas4QEqrLwfBy3TVOUGOQPfRc9NzN/OQRyWl/SWz/5b1jf5eXPZxn3vjAD1RqnukMFbV1IcjvGPu1IOjvxCdl2Y=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FD4E5595C91F774295462A525AD57AB4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fcaeff1c-89cb-479c-a619-08d6f34eaf42
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 18:07:39.1712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1182
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 17, 2019, at 10:24 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Sat, Jun 15, 2019 at 1:26 PM Song Liu <liu.song.a23@gmail.com> wrote:
>>=20
>> On Mon, Jun 10, 2019 at 9:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> As a preparation for adding BTF-based BPF map loading, extract .BTF and
>>> .BTF.ext loading logic. Also simplify error handling in
>>> bpf_object__elf_collect() by returning early, as there is no common
>>> clean up to be done.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>> tools/lib/bpf/libbpf.c | 137 ++++++++++++++++++++++-------------------
>>> 1 file changed, 75 insertions(+), 62 deletions(-)
>>>=20
>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>> index ba89d9727137..9e39a0a33aeb 100644
>>> --- a/tools/lib/bpf/libbpf.c
>>> +++ b/tools/lib/bpf/libbpf.c
>>> @@ -1078,6 +1078,58 @@ static void bpf_object__sanitize_btf_ext(struct =
bpf_object *obj)
>>>        }
>>> }
>>>=20
>>> +static int bpf_object__load_btf(struct bpf_object *obj,
>>> +                               Elf_Data *btf_data,
>>> +                               Elf_Data *btf_ext_data)
>>> +{
>>> +       int err =3D 0;
>>> +
>>> +       if (btf_data) {
>>> +               obj->btf =3D btf__new(btf_data->d_buf, btf_data->d_size=
);
>>> +               if (IS_ERR(obj->btf)) {
>>> +                       pr_warning("Error loading ELF section %s: %d.\n=
",
>>> +                                  BTF_ELF_SEC, err);
>>> +                       goto out;
>>=20
>> If we goto out here, we will return 0.
>=20
>=20
> Yes, it's intentional. BTF is treated as optional, so if we fail to
> load it, libbpf will emit warning, but will proceed as nothing
> happened and no BTF was supposed to be loaded.
>=20
>>=20
>>> +               }
>>> +               err =3D btf__finalize_data(obj, obj->btf);
>>> +               if (err) {
>>> +                       pr_warning("Error finalizing %s: %d.\n",
>>> +                                  BTF_ELF_SEC, err);
>>> +                       goto out;
>>> +               }
>>> +               bpf_object__sanitize_btf(obj);
>>> +               err =3D btf__load(obj->btf);
>>> +               if (err) {
>>> +                       pr_warning("Error loading %s into kernel: %d.\n=
",
>>> +                                  BTF_ELF_SEC, err);
>>> +                       goto out;
>>> +               }
>>> +       }
>>> +       if (btf_ext_data) {
>>> +               if (!obj->btf) {
>>> +                       pr_debug("Ignore ELF section %s because its dep=
ending ELF section %s is not found.\n",
>>> +                                BTF_EXT_ELF_SEC, BTF_ELF_SEC);
>>> +                       goto out;
>>=20
>> We will also return 0 when goto out here.
>=20
>=20
> See above, it's original behavior of libbpf.
>=20
>>=20
>>> +               }
>>> +               obj->btf_ext =3D btf_ext__new(btf_ext_data->d_buf,
>>> +                                           btf_ext_data->d_size);
>>> +               if (IS_ERR(obj->btf_ext)) {
>>> +                       pr_warning("Error loading ELF section %s: %ld. =
Ignored and continue.\n",
>>> +                                  BTF_EXT_ELF_SEC, PTR_ERR(obj->btf_ex=
t));
>>> +                       obj->btf_ext =3D NULL;
>>> +                       goto out;
>> And, here. And we will not free obj->btf.
>=20
> This is situation in which we successfully loaded .BTF, but failed to
> load .BTF.ext. In that case we'll warn about .BTF.ext, but will drop
> it and continue with .BTF only.
>=20

Yeah, that makes sense.=20

Shall we let bpf_object__load_btf() return void? Since it always=20
returns 0?

Thanks,
Song

<snip>

