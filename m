Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687065374B9
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiE3FhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 01:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiE3FhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 01:37:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762C34EA2D;
        Sun, 29 May 2022 22:37:10 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24TNriPL003045;
        Sun, 29 May 2022 22:37:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=8Td+Hjhz9e9EMoaM+PTPaq7AdSZddms2zT6z2mG6rlM=;
 b=YCbTXs6wsxCYcUDOS+NV46sSmgSYnZwBQPFD8r0Iqzb2Mbh4V1bDuA6nTiNv78h2I+Lw
 157dMiGuyxOEy0DWh8XHCFqYwmNMVWiXGUq/A16zchIKoAU4fR/6JRn+McCNCE2o8Tmu
 LnRnrY2VG2+i6WjPg6C6AaUOY3dGin5sepA= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gbk22p9b3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 May 2022 22:37:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHhpTL+Q+JHcIY1pShoZh6sBBL5yL1r2ZffJ3gw+Sf9WDFQEPO/HeM2U5Xjule/Eoeuoud89LkJDi+ijPo9zDuYS0nqu1Wz98usEMTpOF0hMDKoIaTrpYOYsNPIN6h8wZPtnRzcoU0OLHjcXf098XoP7gU2W7nofTEtG990U8uv7dQ6YeXNOu5vlX+Rt9i3lBlnvR7Z/XwN16T1a3vTTAyFP5u3YZld2UH4tRpUCHVdJaX0ANXEHbp89qhnsVflqdKTlylBfPTHvsCwqahVsJxbdGw1X/nPj6wXFWq7IC6aBn2kpnVztOVvFCZPYyFUX31mMCYB9BR3qZy/48A7P5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Td+Hjhz9e9EMoaM+PTPaq7AdSZddms2zT6z2mG6rlM=;
 b=Kt7+X/xgLD4QhH++VqzQJKi50e51o+0SimKrij3m4iutjqNEODAP4b2WZYw8hoYLrlk7l9RcXLH3iPzteFmNsXBSyxj+Yt2sDOQX9Eybnqv5OuMeC40VEcgaFHR0h1Ngp71XW3T3daKCpeJTmFHcKBI7V8s+sLc32nEjOMFX74dnu0qbqSVWX/Gb2GEGFp3fNQ6GlYs9tjvxuJA0hbGxUvY0GahxGwxzfXDjJP+WXIDbItpBZroIE5OMyUScdfr9DVU+l/HrMSb0ZZiQMCiMmRRhkLq7NUuG0gHX9RSk1jIga+9zkPyv1D9fU0p5cYTgSUCmxTrrTsePp8c2LWRJjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA0PR15MB3838.namprd15.prod.outlook.com (2603:10b6:806:88::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Mon, 30 May
 2022 05:37:08 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%5]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 05:37:08 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: Shuffle cookies symbols in
 kprobe multi test
Thread-Topic: [PATCH bpf-next 1/3] selftests/bpf: Shuffle cookies symbols in
 kprobe multi test
Thread-Index: AQHYcgxB6hxZ3XL2jk61vWi7LB2HS6026oGA
Date:   Mon, 30 May 2022 05:37:08 +0000
Message-ID: <F27191C0-A530-4D18-9FA1-8D47DD1ACF8A@fb.com>
References: <20220527205611.655282-1-jolsa@kernel.org>
 <20220527205611.655282-2-jolsa@kernel.org>
In-Reply-To: <20220527205611.655282-2-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54ede1b3-8308-40a1-dcd1-08da41fe6fdb
x-ms-traffictypediagnostic: SA0PR15MB3838:EE_
x-microsoft-antispam-prvs: <SA0PR15MB3838CFD28057E41673371B5EB3DD9@SA0PR15MB3838.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p6aIsBsEE0lv9ST/BoPyQKNGuIX4WN/VYu1U5elrd4grbfvi65rQ7Sdn4QCexL7X+nlVKLYKPSXaHMNjYe8LMG6iPTBdEEssPmhPNEOTiNYTr1IBgFrVnKO8mSgXj2r27JmCedBlIY9PhntDKQiGcY3Eh82/iwRhyYubCdnZwnHPHT1IcWif8FXAALNCNVedYYhPuvqEU+7y7Hr10I030DlXIlaQDEpQxwSRMsyv89h0fNsDHP7udzFOrNGeiSsVqxCkDi27rYPXYTbgtYKUH6/Loz5nAKTIPWPjJk/D4GwtFShzQAXN3JasGh8uRK+UtN+sWhcWqKvuY0OOqgI1WpRttXoyUx7PF5aZTHDqJNpusPqTfYZr5j5q+7wyFyTpSc6iN7AbRIBhacm9KFc3TkneqlrOcjfopOMk42/7zVG2px9Wqf+uWZzznotBLXU58243GMh/lnlDBRWgb7GyoIeZ+3jwyTvSSXc3T407XTzZEfj6jwpKkIKY8UU7Wxn8w0k3sCFNKoBIEk5XbUFrP0SMVeFeWg02mCjlOTIBpnRQADkjEPVK7TyFnTj3EQPw85Hn4PUdqQPYK7agl8ft0wDoucN7skGE7TsPG/0b2wahjRsoWz+OdbVHmUNoLCFvg86T+OR/XNUdlhsfJnOeEL0eMes+/Cx1q5ENfFi1F+fkLiFImDi4yBEe74Io8+rFyBWUjRrtTrZc8B2HeHXu++m3vwZha7hsJdHigaCTWAsy+QuTivjaToIfhfm0SeTE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(4744005)(6916009)(53546011)(38070700005)(5660300002)(7416002)(33656002)(54906003)(38100700002)(316002)(122000001)(6486002)(76116006)(4326008)(66476007)(66946007)(91956017)(66556008)(64756008)(66446008)(2906002)(6512007)(2616005)(8936002)(86362001)(36756003)(8676002)(508600001)(6506007)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cLFSejizIXwPFnzygL6HAhfkdErIwvGDydIAyQQslbhUhJeRoG9/NzIvMTMr?=
 =?us-ascii?Q?1K8OlbvmAI++FM445IsZLhA3ZGRaVIX96Sd/54pc0N/YP7bDSuxkZMlMaSrS?=
 =?us-ascii?Q?eBA2vRdDNeLpBRSsq/UtNLvuoeyyw/U7zUOnessHHPTHh5Sokpj33F96+PK2?=
 =?us-ascii?Q?hz674OfOcaYAo4yhxCdy704AFd0ouEdjkrIwqlJPsFUVZPD8dW8WypTCcY1m?=
 =?us-ascii?Q?aNDHv5Mj9ZijGhI0Wx+viGGOgqbRYlqO7vI6m+RQNMnljpSOSjUvVV+RkjKO?=
 =?us-ascii?Q?50U7TSG1PpzUe/nv0Hb8+T6eV7BxU8RgTnKR8KfQ9eKimX2sjOK6JzLIaHjj?=
 =?us-ascii?Q?5SM2dR2WH3dIycZ9wGw8k7hVP3SSfgTjn+BfE6Wpp1RQJHMECMsxHzqdfWts?=
 =?us-ascii?Q?81PtezBqoA8GJTKr6lipIep6dXfhnDVfYM5k/qS6Nnw1DgOg28UOYT0A4Rn0?=
 =?us-ascii?Q?Kb8r60nZE8oiPVCCwXd/o7DQJ1BFixeKzHPA94GmRZgKIEEYeVfuTejAm21n?=
 =?us-ascii?Q?SwR2KLD0pOnbTsScRD5ugFDVE7+wuNShZmnLp2ocIiEgQ2o6XPN1N8JgolX3?=
 =?us-ascii?Q?Jw7rd1srbcFXJ5CoJwELg5n3Beh2SRxxZ/HaHSPEIjGBl2lhFCVwOqdbSfCu?=
 =?us-ascii?Q?Xw18vdmYJVDpNNpvfvnq2f/T/HF+5Zi3MUNM6Kfm2ffuMHCOreNJltx87F/U?=
 =?us-ascii?Q?xxM/cThIRacviZiLq9M3y1Vhb/+BuYZcW6WNXBdgJTwMXX3zMjhpGC7VQFpX?=
 =?us-ascii?Q?esQULZOXeRz175/V+a47/mf4pPFPzPwlNuzq446lSSKxGPAyvF9zHoBx+79v?=
 =?us-ascii?Q?BqHcd4lheBFc4x1IJmW6VyAbQEjeV5RE8t4JDAmAAdCLbrktUV1XGL6fahAS?=
 =?us-ascii?Q?L3tCgvnTBnGzsIj48NCZuZM/rR32U8RVCW1q5sxR+K9jxAt80qC43igpug+L?=
 =?us-ascii?Q?9qOS9uuIXIolpuMsrZPx7KKWIKqa9i4WQCQUw6sYfyUbowPxkJn1LfKHN6kL?=
 =?us-ascii?Q?W7y961jQs+eRrd/2Ir+URt2k5Xou9fV7WsxM9oEdLFg8cQuJKzfno1kDzZPv?=
 =?us-ascii?Q?hqlD8+LfWs/Jrht+qEZCA2pvEgiMqzmZiraH5+/7FC4YpmZXbcN8zrOQ/2xO?=
 =?us-ascii?Q?7MVeh9QjdXcS6WM0z27GB1ea6SMw5c78uzERNpLvhgh5+IR0W/WxhRUbp9F8?=
 =?us-ascii?Q?dSDZTVNuDfX0u7O+3DfTaLf6hnhIQUTbDtbnt/n1B0DGdopKUo26MQyi+tnu?=
 =?us-ascii?Q?m8Wwk3dbFHehOrMqf0RKFlmBIsv1Rmy/bBOkTDLv5Vuyrq5zvBaWGFcS3Cwh?=
 =?us-ascii?Q?wjKQ2sLiaBb9dtUMzxzYq5WDxo4TTxXqIhcCzm421VarVx1Kj9LRYygCk1xA?=
 =?us-ascii?Q?wWfnsbyN/3EB3k6wLh9u8pfdfHxNpvS+lA5rWLUHs1hsyUJju7w2iZXfICA9?=
 =?us-ascii?Q?b/yDqcotixhKB/xxE+ZtAkqR/mtNOwffdRnVwEx3ZgD54vTl0xAijIh7R8nA?=
 =?us-ascii?Q?gLGoRlZp2iBBLR4yNxlGWpQxGn6xKLbITNkBJLxYqBl1JcSpvQXD58y72UyY?=
 =?us-ascii?Q?YMP22Hx/rO9fYSGBeEr7RBMMG4bX5TJcdAJNMfLWy5qwybN652zBj/Kdssss?=
 =?us-ascii?Q?lEmhmTrX4sx1Xs77LOKJcY4lqSl+FBvgDQm7Uq8xvjKgSiDHu3IVOmmIWNn+?=
 =?us-ascii?Q?ltdex9y04x6x/KBCzVPPVuGPE2DeXz+bHwchl41vz8gOVPs4pLnox8o4uDGw?=
 =?us-ascii?Q?9Lb+BBbBMxKx3y9GVDRZD+TTg6oqmIJ7j2E5PuNNlm2aBWhkBjkM?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <97AE24256101744B81957562F008CF85@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ede1b3-8308-40a1-dcd1-08da41fe6fdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2022 05:37:08.0212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /bmS33lc+0+bR9zjDod071qNwKafQJG/WoH30bfwJi1yNnXAxmVP+Yj308//1t3VyVI2cWXTJZCx8dLugZ7JtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3838
X-Proofpoint-GUID: tHhZJuKcjhtCnL0tvwqHrAQLF9P7tEcb
X-Proofpoint-ORIG-GUID: tHhZJuKcjhtCnL0tvwqHrAQLF9P7tEcb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_01,2022-05-27_01,2022-02-23_01
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 27, 2022, at 1:56 PM, Jiri Olsa <jolsa@kernel.org> wrote:
> 
> There's a kernel bug that causes cookies to be misplaced and
> the reason we did not catch this with this test is that we
> provide bpf_fentry_test* functions already sorted by name.
> 
> Shuffling function bpf_fentry_test2 deeper in the list and
> keeping the current cookie values as before will trigger
> the bug.
> 
> The kernel fix is coming in following changes.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>


