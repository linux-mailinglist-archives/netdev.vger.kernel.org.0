Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06C7F3EAF
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 05:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbfKHEGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 23:06:24 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbfKHEGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 23:06:24 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA843E4m005768;
        Thu, 7 Nov 2019 20:06:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pkTgJun/71Sspw0MhvsXi8WVlOBulf9sW9UCrR/RbJM=;
 b=M5viVnTBJ9f6WPBT5Cqve3dqi/7iQLTrfLEepkzKPAlJhfLgIuJIrMNMCs9/mP2rrhRK
 zqrvbUIXif7KyDTWNuLa2kCqfF8iwUrRE6hViypZFJCWwPbhkPa5oqvEp+2OyKb81vtV
 dZgWIr4jmlK+EWe6acO45Rgf2uWpgVk5yzo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vy1c10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 20:06:08 -0800
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 20:06:07 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 20:06:06 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 20:06:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAHV0tTjlU94mPiNIHjwdyZKCnUXOkHX3uJ1Qm2RvuKrV4qKCrlNOpJ2hJ41rjoM3lQfe9QZ7HuEo/jbVDQhGsD9vf+0rlXLym47FLaUpV+oxsK+VyOfyU27mSDeV1twDHoO19p9LyQnM8ToAUpYxui0u08T8cJZA7fhlCG+mMLh++S9PsIZeeT4IjQUnNM/9sRJriWj0yfUXVT+b55W04ho9kxHPDk00APviZf+oaQEC9EV8HXljueiklm3F6jeL/kA9kqnDj4yw8gEoF9e87Wpk3PSWIIMsZfQ8IJOd7+5MIrzEOuXNEVJ49DhUaVFLWo/ZQ6OOiSicfmE2jnXyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkTgJun/71Sspw0MhvsXi8WVlOBulf9sW9UCrR/RbJM=;
 b=huhRAOCvsfYZzlUnMnp/SYRB4YiNFAzdTOn9XRkBT8OKAkCLOxDMe5M9mWZDOi0ZJ83oS08FldV5qNqqyqEfc6fZVhRxp6J7EsoG5j1BoGAKBOclcHJaT/GOfCSBP5enFhT9RsquMK7y3fKHVAdfqrKqx3gQdqAGbVUuU4JhXtDndCXfPzi6iEoJTGcG3pv7WcrsJzqe6iCYmK0guWGcWSjTZFd4OCVvxRoEZx3nk6WjCqd2jxLRmTOLZonUUi7Kby0lvBgOJPBJYT2Kh7CjV7KqYKDqgej5GifNCE3WfiMQ+tpsYhEH9gV+d8LlA1+8RTg9Qz/EmpHplcmpDIOyVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkTgJun/71Sspw0MhvsXi8WVlOBulf9sW9UCrR/RbJM=;
 b=aumerAL4hZGyeDPaAS2/RmSQpU8RiWs0twa/VaSoIuY7ju3cKtrHocUmt9YmjOKEpki1Aj5NOQKi5Yk09Ke8L4NMoOPfm/tu28x7Gu/trwG/A8KdW48HabEKN/en9v8NTAFpIADCDfBZtKdXsyxMyz+1dD61bpX79kmA0Lt/mE8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1837.namprd15.prod.outlook.com (10.174.255.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 04:06:06 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 04:06:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Song Liu <liu.song.a23@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
Thread-Topic: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
Thread-Index: AQHVlS7H2riFVn1w60W5YsSPSMrqRaeATXQAgAAFMwCAAAMxAIAAAJQAgAAB8ACAAA7qgIAAEO4AgAAh1QCAAA9IgA==
Date:   Fri, 8 Nov 2019 04:06:05 +0000
Message-ID: <3000B3E1-25DE-4653-B11C-AAF61492B0FF@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-4-ast@kernel.org>
 <5967F93A-235B-447E-9B70-E7768998B718@fb.com>
 <20191107225553.vnnos6nblxlwx24a@ast-mbp.dhcp.thefacebook.com>
 <FABEB3EB-2AC4-43F8-984B-EFD1DA621A3E@fb.com>
 <20191107230923.knpejhp6fbyzioxi@ast-mbp.dhcp.thefacebook.com>
 <22015BB9-7A84-4F5E-A8A5-D10CB9DA3AEE@fb.com>
 <20191108000941.r4umt2624o3j45p7@ast-mbp.dhcp.thefacebook.com>
 <CAPhsuW4gYU=HJTe2ueDXhiyY__V1ZBF1ZEhCasHb5m8XgkTtww@mail.gmail.com>
 <CAADnVQJFNo3wcyMKkOhX-LVYpgg302-K-As9ZKkPUXxRdGN0nw@mail.gmail.com>
In-Reply-To: <CAADnVQJFNo3wcyMKkOhX-LVYpgg302-K-As9ZKkPUXxRdGN0nw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::f533]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1e18afa-fec1-46e6-6f38-08d76400fa62
x-ms-traffictypediagnostic: MWHPR15MB1837:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB183728C5AC9A5CCFC6AAD256B37B0@MWHPR15MB1837.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(376002)(346002)(396003)(199004)(189003)(5024004)(256004)(14444005)(305945005)(186003)(6512007)(66556008)(66476007)(66946007)(8676002)(6506007)(6246003)(81156014)(76176011)(81166006)(33656002)(53546011)(102836004)(76116006)(5660300002)(99286004)(6916009)(229853002)(36756003)(11346002)(8936002)(476003)(2616005)(446003)(46003)(86362001)(486006)(6436002)(14454004)(66446008)(64756008)(316002)(71200400001)(2906002)(6486002)(54906003)(71190400001)(25786009)(6116002)(478600001)(4326008)(7736002)(50226002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1837;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f5Zk+wpAEs5VXFWDsRKedcFbAFEsa+i9qGf7hQHWs72huqcWYq7Z+bGf/frUmKC585iZAGZJv8g4iz3WkaLs/cJWGdzwhgQO4MYgjLExn5pJi+Mwam38fPpCoBidNnicAs1v4oQmifB2yhi1KQ+tGaVJG3Zr8qMPT9qGG8zHMx9IBItMKzjCV0GXURNguO5jCzvSOytEVtZ3wRduDCZcQfGzf3KD5d00/T8Gzt5FSlAQP4ONVoUIuriUxlpIohA8q4ehOw+XLWg7tb/1vlI2n45arj8zRb6ShmtnZOsX4RHOfL+Iq44AlZN4OsPiYJJu6dXiGlzEO5qh2kvss8CB04yfgfTrjLogiepgs72Xg9GBqETPA9Y8n+WbsFYewmWVy4lNHR8xeFkoohiDVRdtLNn9m7U6o03IwJ9r3Vt6dw0PO1G1v1nTUDIL95vCo5v/
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9C08F0BA9C8A16469AD98D84FD254CC9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e18afa-fec1-46e6-6f38-08d76400fa62
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 04:06:05.6788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +KADAGJNWMNyktDM7VySxyMzFqUCAXg4UimN1QFN3C2xJrVZan6qM1B21N0VIYla+kuqYbZlJ4PbPOV8tJRO9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1837
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=955
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080038
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 7:11 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Thu, Nov 7, 2019 at 5:10 PM Song Liu <liu.song.a23@gmail.com> wrote:
>>>>>>>>> +               goto out;
>>>>>>>>> +       tr->selector++;
>>>>>>>>=20
>>>>>>>> Shall we do selector-- for unlink?
>>>>>>>=20
>>>>>>> It's a bit flip. I think it would be more confusing with --
>>>>>>=20
>>>>>> Right.. Maybe should use int instead of u64 for selector?
>>>>>=20
>>>>> No, since int can overflow.
>>>>=20
>>>> I guess it is OK to overflow, no?
>>>=20
>>> overflow is not ok, since transition 0->1 should use nop->call patching
>>> whereas 1->2, 2->3 should use call->call.
>>>=20
>>> In my initial implementation (one I didn't share with anyone) I had
>>> trampoline_mutex taken inside bpf_trampoline_update(). And multiple lin=
k()
>>> operation were allowed. The idea was to attach multiple progs and updat=
e
>>> trampoline once. But then I realized that I cannot do that since 'unlin=
k +
>>> update' where only 'update' is taking lock will not guarantee success. =
Since
>>> other 'link' operations can race and 'update' can potentially fail in
>>> arch_prepare_bpf_trampoline() due to new things that 'link' brought in.=
 In that
>>> version (since there several fentry/fexit progs can come in at once) I =
used
>>> separate 'selector' ticker to pick the side of the page. Once I realize=
d the
>>> issue (to guarantee that unlink+update =3D=3D always success) I moved m=
utex all the
>>> way to unlink and link and left 'selector' as-is. Just now I realized t=
hat
>>> 'selector' can be removed.  fentry_cnt + fexit_cnt can be used instead.=
 This
>>> sum of counters will change 1 bit at a time. Am I right?
>>=20
>> Yeah, I think fentry_cnt + fexit_cnt is cleaner.
>=20
> ... and that didn't work.
> It's transition that matters. Either need to remember previous sum value
> or have separate selector. imo selector is cleaner, so I'm back to that.

Hmm.. is this because of the error handling path?

+	tr->progs_cnt[kind]++;
+	err =3D bpf_trampoline_update(prog);
+	if (err) {
+		hlist_del(&prog->aux->tramp_hlist);
+		tr->progs_cnt[kind]--;
+	}

Thanks,
Song=
