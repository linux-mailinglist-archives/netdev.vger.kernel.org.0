Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A3977C7E
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 02:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387487AbfG1AYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 20:24:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30664 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725928AbfG1AYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 20:24:54 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6S0NbEp007068;
        Sat, 27 Jul 2019 17:24:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IteGzGrLtsqtDwc96nh2KG9BbdOSrX13UUtphNMa2cE=;
 b=iJxh6e4Xd0FGpcP4bWp+OwDU7fkrogmKOBYhLW0oSNU/G09j+Vc8aEQAkGHbcYexe72V
 3ncR5WQa2cFcKa/vb2q+xqq1Xbea4j9RkesRVenYOclSQ+KHiHdoMRFS9RP4qgXiWaW1
 tBTI0saGxbdOgoPKqhGK4qrMdZhz7vd3OS8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0hwma2j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 27 Jul 2019 17:24:32 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 27 Jul 2019 17:24:31 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 27 Jul 2019 17:24:30 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 27 Jul 2019 17:24:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbLojIhlv2D7/UGAdX3igngFOAvWqA7RELuiCi7lwUjd+urQM96doXCgkKNr6RmKJTXI3RWFmzxm9BHW3H+zaseeL+tc+bsM93orVun51A2vjwedNuo43OCuNk/uU/tjN23rJaR8uhGZ5LoqrwuAhrhYwN8A1TmOxgdTeDBAi8FcGeWxfhzoFta8o9qv0ATzpVaUDYjm6E1PNH9plSzqHbjMlX+YcL1MH9rg7gbp5qHSxPj2UuxCv0ZTwiKNbGE/6i4EYnOVhVtYCxtfaaWDo2aKQRANmG/qDIhI60QEStO2zoPLU6NMhel8k/tQO5qUztQpBqICuLNyL0J7AtOcFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IteGzGrLtsqtDwc96nh2KG9BbdOSrX13UUtphNMa2cE=;
 b=ik4IhtMeAd9adKhnIMl1tfpo+8Y3gqnyh2Q0npDKdNseRF5CPexWkA78glOJ9SvgdQ+YXSzhQmO6V+8grfhP9pkrTs7OguxfJAvCRh0K+5VDWv4fUfM4jyk98ZjJovO6yQvefCz1aKz3QBZj+16JneCj+TZwFf3qZKM2k0iQh08wVujA8F1ab/amybf9TRuJqhWTM6qcbCqfXsGbYxRoj0QA1XfbsaLSMEY+pbNYaZdC0rfKth0bgWU7cYprMM5ho/xGvO9DcUXbG1erewcTPM9XE6QJ0+d8y1Ilqn7y6GB5V3J7qzE4KQzZW+cMEF13P5oELyyS27ePgHyiePFKfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IteGzGrLtsqtDwc96nh2KG9BbdOSrX13UUtphNMa2cE=;
 b=Xf1Q99oxpruni/PcXQ7DcElvegP8oH/rPG9nce3HSTkr0QvG2zrpYJGXlFv2AI25H7mqQLoefKe3TUXVzEr1GzUKEMEkTVBa2RlsG9IEuRmyMuRklWzz3XRrVMQpAQikImZRu9mWn0bQaHTTfwaEulomVx93MOUOHdFJ0luL3To=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1406.namprd15.prod.outlook.com (10.173.234.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Sun, 28 Jul 2019 00:24:28 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Sun, 28 Jul 2019
 00:24:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Topic: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Index: AQHVQlYfQU29UbcfIEO0wFH+SyI9nKbbutUAgAJEsQCAANaMAIAAAs2AgABYFYA=
Date:   Sun, 28 Jul 2019 00:24:28 +0000
Message-ID: <99D7A5F9-48FD-4C64-A5F1-E0CD300F7316@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-3-andriin@fb.com>
 <2D563869-72E5-4623-B239-173EE2313084@fb.com>
 <CAEf4BzZKA29xudKC8WWEXJq+egTCgX4bV9KaE0Y+_u50=D70iQ@mail.gmail.com>
 <9EE75932-5AED-49D3-86BF-D1FC2A139BF8@fb.com>
 <CAEf4BzbwzPsPonkqvGwS-FOWtWYQHQP=PwdVuVEkuEevrUKHWQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbwzPsPonkqvGwS-FOWtWYQHQP=PwdVuVEkuEevrUKHWQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:fb35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c14caf10-daf7-4a11-cc19-08d712f1f3fd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1406;
x-ms-traffictypediagnostic: MWHPR15MB1406:
x-microsoft-antispam-prvs: <MWHPR15MB1406842363C2125B3158A0F8B3C20@MWHPR15MB1406.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01128BA907
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(39860400002)(396003)(376002)(199004)(189003)(54534003)(51914003)(71190400001)(14444005)(256004)(486006)(446003)(11346002)(478600001)(6246003)(476003)(14454004)(2616005)(66476007)(66946007)(316002)(46003)(66556008)(25786009)(54906003)(64756008)(4326008)(76116006)(66446008)(30864003)(5660300002)(71200400001)(229853002)(2906002)(57306001)(6486002)(6512007)(6116002)(6436002)(7736002)(68736007)(36756003)(6916009)(53936002)(86362001)(8676002)(81166006)(50226002)(8936002)(305945005)(81156014)(6506007)(53546011)(102836004)(76176011)(186003)(33656002)(99286004)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1406;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JgE01L4hAv0oiDageevKq2cy4gaHrYtUzBZCQluFEXcxprR8nM9YOos5hsWvPYd/+FcYRDl4/gOfG8jJKFTC5owPZrF35S6PDQDICMj5HdHlSLoLXbh/LZM5zbEGzl29rROHKctfrGRPv45/sfBhZQQf5tCF7/G/pOReF+6jxmNX5PaerdQWA4YlcYj6pZXSqZ9hwbksrfcecIShIPe+fvOoqchLV2gZKcjXUobOf5UeOxT/7R3F3Cvu7vjUvECIN+BELw6dhL7vMBDl62PIpJ6T/S6fqFWVOkSGcge1FQmCwpyjXYuuqP3wlZdVFDYjLwC3cQtGb/e19GaM8wIJlxU1cSdebFEIFKMHa+hY0GJMWPXpvuazNj2NpTPYTE+grV+4XKMnB1uSNNkF7RMEIf9N4wceU5yPaHmZWrlYUXQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C685D8D6FBB5784BBE6491DC986027C9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c14caf10-daf7-4a11-cc19-08d712f1f3fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2019 00:24:28.4017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1406
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_18:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907280001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 27, 2019, at 12:09 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Sat, Jul 27, 2019 at 11:59 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 26, 2019, at 11:11 PM, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
>>>=20
>>> On Thu, Jul 25, 2019 at 12:32 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Jul 24, 2019, at 12:27 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>>>=20
>>>>> This patch implements the core logic for BPF CO-RE offsets relocation=
s.
>>>>> All the details are described in code comments.
>>>>=20
>>>> Some description in the change log is still useful. Please at least
>>>> copy-paste key comments here.
>>>=20
>>> OK, will add some more.
>>>=20
>>>>=20
>>>> And, this is looooong. I think it is totally possible to split it into
>>>> multiple smaller patches.
>>>=20
>>> I don't really know how to split it further without hurting reviewing
>>> by artificially splitting related code into separate patches. Remove
>>> any single function and algorithm will be incomplete.
>>>=20
>>> Let me give you some high-level overview of how pieces are put
>>> together. There are 9 non-trivial functions, let's go over their
>>> purpose in the orderd in which they are defined in file:
>>>=20
>>> 1. bpf_core_spec_parse()
>>>=20
>>> This one take bpf_offset_reloc's type_id and accessor string
>>> ("0:1:2:3") and parses it into more convenient bpf_core_spec
>>> datastructure, which has calculated offset and high-level spec
>>> "steps": either named field or array access.
>>>=20
>>> 2. bpf_core_find_cands()
>>>=20
>>> Given local type name, finds all possible target BTF types with same
>>> name (modulo "flavor" differences, ___flavor suffix is just ignored).
>>>=20
>>> 3. bpf_core_fields_are_compat()
>>>=20
>>> Given local and target field match, checks that their types are
>>> compatible (so that we don't accidentally match, e.g., int against
>>> struct).
>>>=20
>>> 4. bpf_core_match_member()
>>>=20
>>> Given named local field, find corresponding field in target struct. To
>>> understand why it's not trivial, here's an example:
>>>=20
>>> Local type:
>>>=20
>>> struct s___local {
>>> int a;
>>> };
>>>=20
>>> Target type:
>>>=20
>>> struct s___target {
>>> struct {
>>>   union {
>>>     int a;
>>>   };
>>> };
>>> };
>>>=20
>>> For both cases you can access a as s.a, but in local case, field a is
>>> immediately inside s___local, while for s___target, you have to
>>> traverse two levels deeper into anonymous fields to get to an `a`
>>> inside anonymous union.
>>>=20
>>> So this function find that `a` by doing exhaustive search across all
>>> named field and anonymous struct/unions. But otherwise it's pretty
>>> straightforward recursive function.
>>>=20
>>> bpf_core_spec_match()
>>>=20
>>> Just goes over high-level spec steps in local spec and tries to figure
>>> out both high-level and low-level steps for targe type. Consider the
>>> above example. For both structs accessing s.a is one high-level step,
>>> but for s___local it's single low-level step (just another :0 in spec
>>> string), while for s___target it's three low-level steps: ":0:0:0",
>>> one step for each BTF type we need to traverse.
>>>=20
>>> Array access is simpler, it's always one high-level and one low-level s=
tep.
>>>=20
>>> bpf_core_reloc_insn()
>>>=20
>>> Once we match local and target specs and have local and target
>>> offsets, do the relocations - check that instruction has expected
>>> local offset and replace it with target offset.
>>>=20
>>> bpf_core_find_kernel_btf()
>>>=20
>>> This is the only function that can be moved into separate patch, but
>>> it's also very simple. It just iterates over few known possible
>>> locations for vmlinux image and once found, tries to parse .BTF out of
>>> it, to be used as target BTF.
>>>=20
>>> bpf_core_reloc_offset()
>>>=20
>>> It combines all the above functions to perform single relocation.
>>> Parse spec, get candidates, for each candidate try to find matching
>>> target spec. All candidates that matched are cached for given local
>>> root type.
>>=20
>> Thanks for these explanation. They are really helpful.
>>=20
>> I think some example explaining each step of bpf_core_reloc_offset()
>> will be very helpful. Something like:
>>=20
>> Example:
>>=20
>> struct s {
>>        int a;
>>        struct {
>>                int b;
>>                bool c;
>>        };
>> };
>>=20
>> To get offset for c, we do:
>>=20
>> bpf_core_reloc_offset() {
>>=20
>>        /* input data: xxx */
>>=20
>>        /* first step: bpf_core_spec_parse() */
>>=20
>>        /* data after first step */
>>=20
>>        /* second step: bpf_core_find_cands() */
>>=20
>>        /* candidate A and B after second step */
>>=20
>>        ...
>> }
>>=20
>> Well, it requires quite some work to document this way. Please let me
>> know if you feel this is an overkill.
>=20
> Yeah :) And it's not just work, but I think it's bad if comments
> become too specific and document very low-level steps, because code
> might evolve and comments can quickly get out of sync and just add to
> confusion. Which is why I tried to document high-level ideas, leaving
> it up to the source code to be the ultimate reference of minutia
> details.

Fair enough.=20

>=20
>>=20
>>>=20
>>> bpf_core_reloc_offsets()
>>>=20
>>> High-level coordination. Iterate over all per-program .BTF.ext offset
>>> reloc sections, each relocation within them. Find corresponding
>>> program and try to apply relocations one by one.
>>>=20
>>>=20
>>> I think the only non-obvious part here is to understand that
>>> relocation records local raw spec with every single anonymous type
>>> traversal, which is not that useful when we try to match it against
>>> target type, which can have very different composition, but still the
>>> same field access pattern, from C language standpoint (which hides all
>>> those anonymous type traversals from programmer).
>>>=20
>>> But it should be pretty clear now, plus also check tests, they have
>>> lots of cases showing what's compatible and what's not.
>>=20
>> I see. I will review the tests.
>>=20
>>>>>=20
>>>>> static const struct btf_type *skip_mods_and_typedefs(const struct btf=
 *btf,
>>>>> -                                                  __u32 id)
>>>>> +                                                  __u32 id,
>>>>> +                                                  __u32 *res_id)
>>>>> {
>>>>>     const struct btf_type *t =3D btf__type_by_id(btf, id);
>>>>=20
>>>> Maybe have a local "__u32 rid;"
>>>>=20
>>>>>=20
>>>>> +     if (res_id)
>>>>> +             *res_id =3D id;
>>>>> +
>>>>=20
>>>> and do "rid =3D id;" here
>>>>=20
>>>>>     while (true) {
>>>>>             switch (BTF_INFO_KIND(t->info)) {
>>>>>             case BTF_KIND_VOLATILE:
>>>>>             case BTF_KIND_CONST:
>>>>>             case BTF_KIND_RESTRICT:
>>>>>             case BTF_KIND_TYPEDEF:
>>>>> +                     if (res_id)
>>>>> +                             *res_id =3D t->type;
>>>> and here
>>>>=20
>>>>>                     t =3D btf__type_by_id(btf, t->type);
>>>>>                     break;
>>>>>             default:
>>>> and "*res_id =3D rid;" right before return?
>>>=20
>>> Sure, but why?
>>=20
>> I think it is cleaner that way. But feel free to ignore if you
>> think otherwise.
>>=20
>>>=20
>>>>=20
>>>>> @@ -1041,7 +1049,7 @@ static const struct btf_type *skip_mods_and_typ=
edefs(const struct btf *btf,
>>>>> static bool get_map_field_int(const char *map_name, const struct btf =
*btf,
>>>>>                           const struct btf_type *def,
>>>>>                           const struct btf_member *m, __u32 *res) {
>>>=20
>>> [...]
>>>=20
>>>>> +struct bpf_core_spec {
>>>>> +     const struct btf *btf;
>>>>> +     /* high-level spec: named fields and array indicies only */
>>>>=20
>>>> typo: indices
>>>=20
>>> thanks!
>>>=20
>>>>=20
>>>>> +     struct bpf_core_accessor spec[BPF_CORE_SPEC_MAX_LEN];
>>>>> +     /* high-level spec length */
>>>>> +     int len;
>>>>> +     /* raw, low-level spec: 1-to-1 with accessor spec string */
>>>>> +     int raw_spec[BPF_CORE_SPEC_MAX_LEN];
>>>>> +     /* raw spec length */
>>>>> +     int raw_len;
>>>>> +     /* field byte offset represented by spec */
>>>>> +     __u32 offset;
>>>>> +};
>>>=20
>>> [...]
>>>=20
>>>>> + *
>>>>> + *   int x =3D &s->a[3]; // access string =3D '0:1:2:3'
>>>>> + *
>>>>> + * Low-level spec has 1:1 mapping with each element of access string=
 (it's
>>>>> + * just a parsed access string representation): [0, 1, 2, 3].
>>>>> + *
>>>>> + * High-level spec will capture only 3 points:
>>>>> + *   - intial zero-index access by pointer (&s->... is the same as &=
s[0]...);
>>>>> + *   - field 'a' access (corresponds to '2' in low-level spec);
>>>>> + *   - array element #3 access (corresponds to '3' in low-level spec=
).
>>>>> + *
>>>>> + */
>>>>=20
>>>> IIUC, high-level points are subset of low-level points. How about we i=
ntroduce
>>>> "anonymous" high-level points, so that high-level points and low-level=
 points
>>>> are 1:1 mapping?
>>>=20
>>> No, that will just hurt and complicate things. See above explanation
>>> about why we need high-level points (it's what you as C programmer try
>>> to achieve vs low-level spec is what C-language does in reality, with
>>> all the anonymous struct/union traversal).
>>>=20
>>> What's wrong with this separation? Think about it as recording
>>> "intent" (high-level spec) vs "mechanics" (low-level spec, how exactly
>>> to achieve that intent, in excruciating details).
>>=20
>> There is nothing wrong with separation. I just personally think it is
>> cleaner the other way. That's why I raised the question.
>>=20
>> I will go with your assessment, as you looked into this much more than
>> I did. :-)
>=20
> For me it's a machine view of the problem (raw spec) vs human view of
> the problem (high-level spec, which resembles how you think about this
> in C code). I'll keep it separate unless it proves to be problematic
> going forward.

[...]

>>>=20
>>> No. spec->offset is carefully maintained across multiple low-level
>>> steps, as we traverse down embedded structs/unions.
>>>=20
>>> Think about, e.g.:
>>>=20
>>> struct s {
>>>   int a;
>>>   struct {
>>>       int b;
>>>   };
>>> };
>>>=20
>>> Imagine you are trying to match s.b access. With what you propose
>>> you'll end up with offset 0, but it should be 4.
>>=20
>> Hmm... this is just for i =3D=3D 0, right? Which line updated spec->offs=
et
>> after "memset(spec, 0, sizeof(*spec));"?
>=20
> Ah, I missed that you are referring to the special i =3D=3D 0 case. I can
> do assignment, yes, you are right. I'll probably also extract it out
> of the loop to make it less confusing.

Yes, please.=20

>=20
>>>>> +                     continue;
>>>>> +             }
>>>>=20
>>>> Maybe pull i =3D=3D 0 case out of the for loop?

As I mentioned earlier. ;-)

>>>>=20
>>>>> +
>>>>> +             if (btf_is_composite(t)) {
>>>=20
>>> [...]
>>>=20
>>>>> +
>>>>> +     if (spec->len =3D=3D 0)
>>>>> +             return -EINVAL;
>>>>=20
>>>> Can this ever happen?
>>>=20
>>> Not really, because I already check raw_len =3D=3D 0 and exit with erro=
r.
>>> I'll remove.
>>>=20
>>>>=20
>>>>> +
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>=20

[...]

