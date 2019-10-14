Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DE2D6A9C
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 22:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbfJNUNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 16:13:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59954 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729864AbfJNUNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 16:13:52 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9EKDVv3021040;
        Mon, 14 Oct 2019 13:13:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hZdq5eXuDhJgtf/T42jGdzL3qpr6IJg6qMUrkQyFckE=;
 b=eIkhtqDoY27wveVSXaJnuDkRZG7hoZ2GU+REEOZyLDvQRIDOefL8ewyz6JOcNjoc4Owu
 RnCx4ZuAMJer4el+L/24bjpIeaJnQ1jjE6BcRzpn48XZL7txyJ8OfMYh5KkZMKKNC5YJ
 RPGFZRV2duunAuQhd5RCEPnY6OUqETw68FE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vky52e6ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Oct 2019 13:13:32 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Oct 2019 13:13:00 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Oct 2019 13:13:00 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 14 Oct 2019 13:13:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Das7vj7goEseKEI9HW9F3Ip4V8iHgXrMS6pMHr5ZGYaOznHmgi4BPbkb7TURe3ujpgqROuzLD9uArkeWCPD5+pWeoAZzs4LVFj3G9F19VDD3hQtadRPgSlYb9y/lNOALg/6l1KxLsLX3z29YmdnHvdLLRJ/SrSS19VkdxcBgtk7RYM27HHJOuqH6KjLKvCW5bIF5KXX7tm1N5SPLrq5EDnX1xrs89xzwRa3aEqWf7HZ0niUlhFQqdLEYcatbHv1HVTHj/kvOY8zPr7C4ckzORvqIdAwf8565kMsw+f+R6cesIbGhHA5fJs62QIAOvIv7ouTXUhtIhnRk5uqJWEQfxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZdq5eXuDhJgtf/T42jGdzL3qpr6IJg6qMUrkQyFckE=;
 b=bId9zDYibXOUhui4lgODtFRphFPjWA9rnlEmbkl+rwUcjGNEND3zL8BMJZRr7Of7P94Jwk5aIindgd4ROpRNkW6BWrx8GKB2bP+hEGi5EtLAdZl3oF3aRIo0zHZVz9UtJB3Ml4uXf1jJKdxFxOaXqDLZ3sA54Bcbwba1ewv0UsPVcn/HryNgMrYOtRFbu04M6Z+rsZKzhnQAhT3AFUXobB5SBy0mgv9mzfJWvXq69ZhXHzatlA9xCuJc/svwVPQP2qkTiNhwgKxgJe9Rr/bxVNxW70fGL1/o5DxpzqcYgMPxGomLOGa1hCo601uoybqZaVXMjv9/kXD8EZoq8W8F4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZdq5eXuDhJgtf/T42jGdzL3qpr6IJg6qMUrkQyFckE=;
 b=IZkwDcK6xU9MhFINO2NImA2A44ZzH7yTEGAdEf9A4PUVLaaHQhYy7fvx2unfbfOnjxDIKl2u6K24IVzQgTAAgN4YLN73nqFnh3fBXUDIFgGMDSBhvhgFZ4pgewnCUCtfqdeL7OvrjYT4Ampy8xTLQx2OLFBj9t+qblIP4GzuWcU=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1182.namprd15.prod.outlook.com (10.175.3.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Mon, 14 Oct 2019 20:12:59 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2347.023; Mon, 14 Oct 2019
 20:12:59 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] bpf/stackmap: fix A-A deadlock in
 bpf_get_stack()
Thread-Topic: [PATCH bpf-next 2/2] bpf/stackmap: fix A-A deadlock in
 bpf_get_stack()
Thread-Index: AQHVfzKraNK9YMcIS0WwHSwrlFbkdqdTfF0AgACi24CAAAefAIAABZIAgAWzPYCAALmAgA==
Date:   Mon, 14 Oct 2019 20:12:59 +0000
Message-ID: <048ED376-246D-4895-B5DA-FB3158C99122@fb.com>
References: <20191010061916.198761-1-songliubraving@fb.com>
 <20191010061916.198761-3-songliubraving@fb.com>
 <20191010073608.GO2311@hirez.programming.kicks-ass.net>
 <a1d30b11-2759-0293-5612-48150db92775@fb.com>
 <20191010174618.GT2328@hirez.programming.kicks-ass.net>
 <4865df4d-7d13-0655-f3b4-5d025aaa1edb@fb.com>
 <20191014090903.GA2328@hirez.programming.kicks-ass.net>
In-Reply-To: <20191014090903.GA2328@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3594.4.19)
x-originating-ip: [2620:10d:c090:200::2:249a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4624f09-0376-481e-58a8-08d750e2e8d9
x-ms-traffictypediagnostic: MWHPR15MB1182:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB118262A24774DEB3F147D62EB3900@MWHPR15MB1182.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 01901B3451
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(376002)(396003)(39860400002)(199004)(189003)(52314003)(6436002)(50226002)(8936002)(36756003)(6486002)(4326008)(46003)(6116002)(2906002)(33656002)(11346002)(446003)(86362001)(14444005)(7736002)(229853002)(256004)(305945005)(71190400001)(71200400001)(66446008)(6512007)(102836004)(6506007)(66476007)(53546011)(66556008)(186003)(478600001)(6916009)(2616005)(316002)(5660300002)(476003)(81166006)(81156014)(8676002)(99286004)(66946007)(6246003)(486006)(76116006)(54906003)(25786009)(14454004)(76176011)(64756008)(98474003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1182;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qQUJ7c5bG3SqcTPQTqS1jJ4ZezvGHUapx9WsL8Rasv1GK0EvlGnAR2sIr8j97M0Tj5LSmAGWMjl3fNdNv/peHjO1EpEw3Y/q29Co+WrrFjgsOSFyg/eRbMNMa4g4DhJwg5KJZ8lvMEaV53+xif5Qf7/DYHqaj8IWOqA8ZBTx4T266mz+Ja1QYGted/Sz4yK+b25HIFQMMtkteKvQiE3rgGewN84Oc6xqVP/MaX/+Afu2sZD4TRh117jf16oy6vnikZwWHu9SZbcp2Ge6rTIBmnq1IZhE339wNN2E4kpWnUE/HboQPgRb8SrhexWtbMfPl6nO4O0mmZOjewhooFl7Iklw5brYzCYHXSa6Xq9V24jaHGw3UxxOpDx3GF7DAG0ykKaGJeg0+973bHlNAAqsfY7oX1i+pgoqC5zxx8iXah8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E1B63940F9EEE443B9F123C048498F46@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b4624f09-0376-481e-58a8-08d750e2e8d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2019 20:12:59.4064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 02p02APrS160hJ9JCgo3Z/m4bBwxRYZrA8ZtXuRuUnqHN1B43OqzexHNzDWPeWrAGJ3w5Iw6bB2B8zDdPm6Geg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1182
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-14_10:2019-10-11,2019-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910140168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Peter!

> On Oct 14, 2019, at 2:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Thu, Oct 10, 2019 at 06:06:14PM +0000, Alexei Starovoitov wrote:
>> On 10/10/19 10:46 AM, Peter Zijlstra wrote:
>=20
>>> All of stack_map_get_build_id_offset() is just disguisting games; I did
>>> tell you guys how to do lockless vma lookups a few years ago -- and yes=
,
>>> that is invasive core mm surgery. But this is just disguisting hacks fo=
r
>>> not wanting to do it right.
>>=20
>> you mean speculative page fault stuff?
>> That was my hope as well and I offered Laurent all the help to land it.
>> Yet after a year since we've talked the patches are not any closer
>> to landing.
>> Any other 'invasive mm surgery' you have in mind?
>=20
> Indeed that series. It had RCU managed VMAs and lockless VMA lookups,
> which is exactly what you need here.

Lockless VMA lookups will be really useful. It would resolve all the=20
pains we are having here.=20

I remember Google folks also mentioned in LPC that they would like=20
better mechanism to confirm build-id in perf.=20

>=20
>>> Basically the only semi-sane thing to do with that trainwreck is
>>> s/in_nmi()/true/ and pray.
>>>=20
>>> On top of that I just hate buildids in general.
>>=20
>> Emotions aside... build_id is useful and used in production.
>> It's used widely because it solves real problems.
>=20
> AFAIU it solves the problem of you not knowing what version of the
> binary runs where; which I was hoping your cloud infrastructure thing
> would actually know already.
>=20
> Anyway, I know what it does, I just don't nessecarily agree it is the
> right way around that particular problem (also, the way I'm personally
> affected is that perf-record is dead slow by default due to built-id
> post processing).
>=20
> And it obviously leads to horrible hacks like the code currently under
> discussion :/
>=20
>> This dead lock is from real servers and not from some sanitizer wannabe.
>=20
> If you enable CFS bandwidth control and run this function on the
> trace_hrtimer_start() tracepoint, you should be able to trigger a real
> AB-BA lockup.
>=20
>> Hence we need to fix it as cleanly as possible and quickly.
>> s/in_nmi/true/ is certainly an option.
>=20
> That is the best option; because tracepoints / perf-overflow handlers
> really should not be taking any locks.
>=20
>> I'm worried about overhead of doing irq_work_queue() all the time.
>> But I'm not familiar with mechanism enough to justify the concerns.
>> Would it make sense to do s/in_nmi/irgs_disabled/ instead?
>=20
> irqs_disabled() should work in this particular case because rq->lock
> (and therefore all it's nested locks) are IRQ-safe.

We worry about the overhead of irq_work for every single stackmap=20
lookup. So we would like to go with the irqs_disabled() check. I just=20
sent v2 of the patch.=20

Thanks again,
Song

