Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4AE5252E5
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356628AbiELQpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345770AbiELQpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:45:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4D4268229;
        Thu, 12 May 2022 09:45:30 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24CEAibn000520;
        Thu, 12 May 2022 09:45:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=Dj8gBZawJ2OR1VDfkspv6tNAJ55cY7Pzz3NiA6b5Tt8=;
 b=O1pjzHn9M5LRCYj0nzZbvphP87LFCsRLArfxrunXb2K/wo8zfwERShBPG9DF7vwnWNtM
 wdFdetIhCykHACIhFOdP7uw2Iv+xEjnsbtPJ7MowfZJYHvWP/vXw7v07LnDZ7z6eReVy
 p64/e4dguSAKkSS0FsA0pGvUFj5d+PQV3QA= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g04ksuyqs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:45:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8fKdbWl9nsvyu4ClabXSRkyJvkabe+KDUft3Fy/8v7nDeC2yjBhLxfGOSOVUwseTFDv1YRQp5qf6h/VJxX8eDsrWoZW9G6p6l5kI+tNINU02NkyR+hV1aT7KEC5ajQIOdGdPFJhvkIPVVgEtDoohxJ1yq0cj5+1usV6XsiPTVF9s2VjgnmxQxnPDqvhW2CdHyKs69+Ci4HMBYtLMB0Xxg2eClq5rn2u4AmXNbhzlhGEijQMBP/mrwzY+fe0FcgXfBisHySoTWO7L9NyZi1h32PZY19ITDPQrK0J6+ssZpaOEoWoWDesrd5WHuik1FMVWUe/yhCeZNrCcwmAWVuKLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dj8gBZawJ2OR1VDfkspv6tNAJ55cY7Pzz3NiA6b5Tt8=;
 b=MDJ4ak89oQR/ndzsNvqqugsAvaOKphfUUKQ2U3+jHZodnElu5vUTSRZWwnHNinnuNbR4d8Ciofn+sa4UEsNXIBUhRsQio9SmR+KZf0whrrgNIh0/MWaTvuvdO8VC1QQYvSDJjH8wu2LSDdPaqkZAZFJ/p9ywY6rh1umyduMCOxgdKou2wcXANTkgpJGP2WsY+AquJWYHq/jqzp5EpBkCpIF09PC90JLwUSTKeSVoJOKiY5BqB6+re93rX2qWduwOjZ5ejR7+rd7HxrYhprdtGFpdrk+mf/d/tdzwaHGkPqijvi5vNckkDKE/Q9ro+gPewqj3bkPn2Ms4ipXqOxlcPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB4091.namprd15.prod.outlook.com (2603:10b6:5:bf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.27; Thu, 12 May
 2022 16:45:24 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 16:45:24 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] bpf: use vmemdup_user instead of kvmalloc and
 copy_from_user
Thread-Topic: [PATCH 3/3] bpf: use vmemdup_user instead of kvmalloc and
 copy_from_user
Thread-Index: AQHYZgsMHuDdmoOKb0i6sfPd8TDQeK0bc0KA
Date:   Thu, 12 May 2022 16:45:24 +0000
Message-ID: <4C02E841-C402-4862-9C54-FBD5686E2FB4@fb.com>
References: <20220512141710.116135-1-wanjiabing@vivo.com>
 <20220512141710.116135-4-wanjiabing@vivo.com>
In-Reply-To: <20220512141710.116135-4-wanjiabing@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e045f05-797d-4435-c300-08da3436cfa7
x-ms-traffictypediagnostic: DM6PR15MB4091:EE_
x-microsoft-antispam-prvs: <DM6PR15MB40918E244E495A0C0757E866B3CB9@DM6PR15MB4091.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yjBqk/rWY140R0/hD67lMndsolSxOvvrgDVl8pGPSKtHy30Xzc2McmJPhJavY5aVCK/baXeAwOM8hX4KR+9MiBTshMroRTvpvUnRUc3w9rRUpx0NQ/FdWBMxbghbyDXd5cXCTmZFeJ5sQMkl3a322XfgPNBVudF+NdcLZjob3/uXiRDHdVttai+rsp4DJ+hfKyKiTJcmVVJym/J3K/zoSTPsZXAHTcAdH7fvvX+DIcfGO9u9bEQw44kJsYXHPvyg19UtCzPe0o5PdkI5uvAefdZiZ0g0hlH6gauZ8Tg6KFKkxqLlz7mOkl4TBfyFG1CXR3yfQGUlAF6lCYa9zjPxq6oEk3HM8aHid+TjP+m/ytSasfBeUrtZS0pn8XxmdkSagjJlN09dJYoUs9cku7bHMJOqx4MCMlkLeIzSuPH7Jl3fNky9rQKQBTjqGt8/HNInz/l7SojxmRD5FPG7t3bncPdzAsm+s4puPiD5eAaBIkqpH2inAZm8AvOCWsNRwheRYrFBWHTpDPajiobp0Rj2FRA+/VJk900t1h5FwDUKlyo6SJo++QzyBcK8NrDGPQMeqWoQXW7lmMPSoyVZ+nkNDedAkA5sUaB39N8dr1ywig6GyxNrFg7Uqscd6jrTuS3YJ6Tu3EuorNwOdLvwXHcywq9v6jyfWeei9o3RAUP0mj8ji90eeGYAqhigHx0Ve8KyfZmJvApGpZB1BN2aGS5ZO/6kgjvNRpeXIQPxKw4+Qz3T+kbLdff6OsvQFq8AobjL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(122000001)(86362001)(38100700002)(38070700005)(316002)(6916009)(508600001)(66476007)(66446008)(6486002)(6506007)(76116006)(91956017)(66556008)(66946007)(53546011)(54906003)(186003)(2616005)(71200400001)(2906002)(8936002)(64756008)(8676002)(4326008)(5660300002)(83380400001)(33656002)(7416002)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l3SnWezd8OFgsI0p0cT878I73MjGUPO14ulm7alx0QXY3GSVvPRb8eO30uOe?=
 =?us-ascii?Q?PJJ8cnJ+30/YMc4SGWE6JmANTWza0W/qjL4MCyXa5XZw/dAnXaa/Bz7olpT9?=
 =?us-ascii?Q?lB+esEi3F/Z0a3lRHEbo4Qy7H51suPECDZjIzVX44nxxI6YXz6ERbTD9ujWH?=
 =?us-ascii?Q?9fxceQZhZKqz8F4vuk5BmIKTCeUM8usqdMbs/KnTFoGmtirwAJ//aE4qhLHa?=
 =?us-ascii?Q?z25FA4JFiYFjqLwtlosAVC9rW1uyLLPQLoY17tXtwrRgbrwqcE/5YPpTZBST?=
 =?us-ascii?Q?/iC9AmhsdV/mR/3RESoq/wJ91u9Bjh5+hMSOd3f4lVjc/yL7mMg8qLh02XFh?=
 =?us-ascii?Q?fM99ZcIBn8FVLANivwX7PcY019Gvn5t6JE3OVjpQEkbcP8oDRW+xzFrzJ+AV?=
 =?us-ascii?Q?wOdYv+j0DDqdR6SDYlwWy4bpEtbtaIBSvQcx6JF6gkXiED2wF2NzAyJX4o4y?=
 =?us-ascii?Q?tzYXUuggfChHW4+H1RucsmfVD8vNRO+EGW0XEWX0W9dVF74kSlnODpA11UZ5?=
 =?us-ascii?Q?FnBaZXW9sxxtBrr8ItTCiJiEVOCxfbIzPTuSgCyz/2XKjEtbhXD2+O3o0Qxx?=
 =?us-ascii?Q?0RTFCcEQY4S424YsRXNUEYXb5dm8ZWRn7MBQR6a5pqf6o2dVXT+yJ6EI/9Z3?=
 =?us-ascii?Q?gobOErO7Rex5YqJHZZLf9mAg4/8wKQvqYNSDw/Y9eDCBbnvgn1HpXioSGCxb?=
 =?us-ascii?Q?3KaliPWb2QnPQAQ+joaoGjpMdsKoOeRtZ7LjHanF0tSQ+6C9sIFPgJNgh11M?=
 =?us-ascii?Q?tlh+VGC/EwaSMp46WheEJA6i4Om2Arep/CtoBuNC1CnirHKuRDluv7gQvykF?=
 =?us-ascii?Q?QAXAUBpaFFVXGIZAtZZZiRbQ/pxQPXUEAS9eFKqYfLd2t63qEp2ScLjLCMw/?=
 =?us-ascii?Q?1PxJNNd+bOVVPXxIZZPxoC+nXzMvpziopyOuWxjvAl+7QyPh9T+bQMdRz2pT?=
 =?us-ascii?Q?VnoMH6rDiOMvJYsKNfFGYzp8h15phvPWVtoQc9WARxub0xwYc0WcMT1CLINh?=
 =?us-ascii?Q?xp/I3vnwdKl/xeocqHaWpNsa7HJM3ag5c5JWSxC56cA03eWvTLW3YYAbUwqo?=
 =?us-ascii?Q?O9N/POuzDlGdvpN9dW6LOt8yZu9rkuhIRFWeMwAqm8IRnx3frZf5ijk52EEE?=
 =?us-ascii?Q?kJU0j/9fgXDn2Mn6aujxYnTtaRZ3ajJQoaTjo0jGZRBjOzsJUfC4zgniYMjz?=
 =?us-ascii?Q?uuEc/+QAL1Zi8tKPAcfBTHdy96I9CfuOp9tNoUCBZ65iuK00levXTUtptfmc?=
 =?us-ascii?Q?gp/ObwaPnJ2aAUow8jBSiym6Rp3KEPvtZDZm/V1BUixuElxxOEOmFhVHc6YK?=
 =?us-ascii?Q?rGRErQecmUZ3O55grVyZRTzYhE+QXE/Uh8A5tml6T8DTncy+4PhYs8fZ69JS?=
 =?us-ascii?Q?e2T6mJuwSNHFjXuMnVTYHOogyo0GYt0ZX/irng+7guMaUwt4p+y5Y3Rv6Xtu?=
 =?us-ascii?Q?3OxFLgiSJaJD6mPt6CielTlEWWerfKKuDjoyzIMWwA/1rPgDr/1hzIwPtuEH?=
 =?us-ascii?Q?RdQgcuwJk9zo/0vn0iQIAaAuWkX/rmsEiwNJGSyvr03Loa5qElpfLlGPg9+T?=
 =?us-ascii?Q?KEHoTVqag1P2iQNnPsLc58DHXDRxVW9R1XFKsYfTn/GyJCqu4zdPmhN1Em6C?=
 =?us-ascii?Q?poWwGxcncqRBTPiiIcxEJviR0U4GABai/AWfnDYVqM5aFiKsqc8ERYXbIW7U?=
 =?us-ascii?Q?1cfvGz2giq1bghUAMnjdPeOB5/zONhiwP66603Wj8de9M2HOfal7ZMNg2fJM?=
 =?us-ascii?Q?vwx7xyqTdEonVEc8AgNNfnzF41O3sUXXXoxhlcJ8cXC/bAtH5UE9?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A15D40C47A32B945A6A29E77D81ECE7E@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e045f05-797d-4435-c300-08da3436cfa7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 16:45:24.2634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SgJzfpgMAd9F60pbEFJpXzUC2ZbQqhisQTCAP0NlCDcyek++fk5od5bLWjj6iRmGCkC9VOpEgSkFayHLu2j4qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4091
X-Proofpoint-ORIG-GUID: MP2qQOgDS9bZA6SO1g6FKxo9Lx_JrfLk
X-Proofpoint-GUID: MP2qQOgDS9bZA6SO1g6FKxo9Lx_JrfLk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_14,2022-05-12_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 12, 2022, at 7:17 AM, Wan Jiabing <wanjiabing@vivo.com> wrote:
> 
> Fix following coccicheck warning:
> ./kernel/trace/bpf_trace.c:2488:12-20: WARNING opportunity for vmemdup_user
> 
> Use vmemdup_user instead of kvmalloc and copy_from_user.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
> kernel/trace/bpf_trace.c | 10 +++-------
> 1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 1b0db8f78dc8..48fc97a6db50 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2483,15 +2483,11 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> 
> 	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
> 	if (ucookies) {
> -		cookies = kvmalloc(size, GFP_KERNEL);
> -		if (!cookies) {
> -			err = -ENOMEM;
> +		cookies = vmemdup_user(ucookies, size);

vmemdup_user() uses GFP_USER, so this is a behavior change. 

Song

> +		if (IS_ERR(cookies)) {
> +			err = PTR_ERR(cookies);
> 			goto error_addrs;
> 		}
> -		if (copy_from_user(cookies, ucookies, size)) {
> -			err = -EFAULT;
> -			goto error_cookies;
> -		}
> 	}
> 
> 	link = kzalloc(sizeof(*link), GFP_KERNEL);
> -- 
> 2.35.1
> 

