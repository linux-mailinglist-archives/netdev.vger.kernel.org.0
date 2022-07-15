Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E35576813
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 22:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiGOUV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 16:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiGOUV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 16:21:56 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCA33C151;
        Fri, 15 Jul 2022 13:21:55 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FKCk0W029859;
        Fri, 15 Jul 2022 13:21:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=uNCHDFj0TotbBy6xBe/FUfjcHo450aWCwPcb3jd5y8w=;
 b=dtzcpi2f4xyUt1tSNKCt72HIaEfTYjIC2eAaGSzrR5GMu0BQop9Wu8jsPTKxEQYWLe6L
 Jd7nLZ7R93q6V8BUNKlPe/z8Pb8j/lfDED8QkLBP9zA//VucaCBcQSzaMefeBqO3C44B
 5Rp6qfGn+3lF85JBTMENuk1PB00UURH5qhA= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3haxdg5ecp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 13:21:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5p42Ngtrm7rYNbqd/O/UUhiBAuqhjtVbRbbfKDbccFXfAjy4eJFgMHc+A1A8aUPlkLD55RKq5XDZ8lewwb+y9+70nmXQU8/8deXBn8fcLBATKf8RCpQ/jRux2DmCRY76V3q9qOO1yRav/TIHBozv6a2soovisyIv4UDtUYQ5HV7XoG7kWCv58UtpymjXCvc0ejYdAN1WVqFjt3uG1sGVnuOwlFst9sFkdUGLub86fX5zrODPZB3qHsy7QhNARZGiDwXswgADKgs1wpW0YjBZ7lSWgJLK2xPN7ptrmGcU8KuSxmpvSdo04ugLJyBJyFIpzQJ6OWHCVI04e9frJBHAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNCHDFj0TotbBy6xBe/FUfjcHo450aWCwPcb3jd5y8w=;
 b=Q7/69EjbxhHSMZ/y1U4wmpt0gNWzKuEjXj+SM8l/d+3LFCQXfFE/i87ayM8LIfJG/VojT0jRze0g+Oku9FVZPFxI4Rywlw6Qbml/d0XpWZWpRJQTOT31i2H+BFX3MicY0xJx+R8pQwRd9PEf2BnZDuTpuINj7ItiilBh/k6eVrmzD4tUwvAIftkG50FA+bjJhv4MnkoP6VYlp6rH0+R61o6Qm8Weyl/jw1fBn+gaSoRIvmtRCxafOAQ/83BgIv7qXnxKd6napn+6Lj695QcTmx2PuJBK0/Vt8JFYaeBNDl5qwIH6CuI/WD/BNifdYLf9XdGX6iRDMPYG2G6pwuu0yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MN2PR15MB3070.namprd15.prod.outlook.com (2603:10b6:208:f8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 20:21:50 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 20:21:50 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrjyXTiiEgEgK0K1BTZfHuJgSq19RUuAgAGMyICAAAmfgIAAFU+AgAALzACAAADvgIAA+XEAgAAY+YCAAApDAIAAAwqAgAAGIYA=
Date:   Fri, 15 Jul 2022 20:21:49 +0000
Message-ID: <6271DEDF-F585-4A3B-90BF-BA2EB76DDC01@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-4-song@kernel.org>
 <20220713203343.4997eb71@rorschach.local.home>
 <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
 <20220714204817.2889e280@rorschach.local.home>
 <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
 <20220714224646.62d49e36@rorschach.local.home>
 <170BE89A-101C-4B25-A664-5E47A902DB83@fb.com>
 <0CE9BF90-B8CE-40F6-A431-459936157B78@fb.com>
 <20220715151217.141dc98f@gandalf.local.home>
 <0EB34157-8BCA-47FC-B78F-AA8FE45A1707@fb.com>
 <20220715155953.4fb692e2@gandalf.local.home>
In-Reply-To: <20220715155953.4fb692e2@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d59fabec-65e1-4b13-dbc7-08da669fa62d
x-ms-traffictypediagnostic: MN2PR15MB3070:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lgPVS5z0jJCgEz06tyZm41l33f0x8eGF+Sp6dP4ODEahOoYCcowHdND4KvGJaawfqQ/maGPjVZ+gDv4pq3wXI1o7JXiCoEIZfOPNOlQtbhnH1qS9cceMMwNcLyLLzaeGXC/4CqZ+4gOjLJ5QBrH3vHmku+6ozW/utATv4weM3O1sFDyDXP58Ac21ismUFMt56XrQIdpr2VGuUEjGzl9XOBQOi9CIBD5Uk3YFMxRmg76u1YBVT4brrqO5wrdcBywazqoK3zVz3yXVEtA+sU+aNqAvm3lwArO3+zBSXDIGBhTvEZZXSumbZtxo1GHsoyAvfermo8Zl0A2di3hRG5HqAtrO3I5ZSF6Bexavf5UuLX7vxtzZiaHEiWeCw8ZX0Wt+iP6G/h/BG4tbpdtU5uF7U8P8ylD+5an4nq9dISc2R15qf46f5zoYwq0cePR1LMaOjlRg9qvkSj8insBi6TpH9owY8nPmvE1qT6abAOD/UykPxltgKdOjIPW9ohjoO/Xk1ISsriiHF1H5NH9n3Hjkhi++lQuLmxSg9B2vYB+YOcB482bMJwRVD2TztiFoBS2rBJ/rJxfW7PJ9blgJbj3+pjnSDhEvopzmdrnWXCa1kWDPiJTfz+GU8hMkc5LxmMIuJXiKj95OJT4jhchS9/CKL+DWmx4/Dg09z74jh2zw40hXhIb83WgpdG+Q7fJPDl4GS8EUDLMm8zGvhhc8riUVCJvXwPfkTmMiWL256nktajBJJRvyNEucV61bz5wzR/7V5np3fm5VA/emZEU/8godRUgeOVooqgz6Ap6nu7ZTQR8hjnszy2bEITGL3YgSEiX/UzQOaN6w1DwtOv7pXki7bHOJzFXhGhw6v+VidY6DbBs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(2906002)(38100700002)(6512007)(316002)(54906003)(6916009)(478600001)(8936002)(7416002)(5660300002)(33656002)(41300700001)(6486002)(6506007)(36756003)(2616005)(186003)(53546011)(83380400001)(71200400001)(38070700005)(122000001)(8676002)(91956017)(4326008)(76116006)(66446008)(64756008)(66946007)(66556008)(66476007)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6HMidZLsFSIdQ4oPY2Q0h6rJnAwpDFJ6hRfY4Ye4ym4d+vief8UUm/tKdjfr?=
 =?us-ascii?Q?E6u4W7dOK6lHI3el39Ahx/uvpTQZYPDUHJ6Qnk5xcuEfvI0OdSb0C2Y/j/Fx?=
 =?us-ascii?Q?ZTUGul9gwGx8YJQT0Dn046kC7pzJvhkBe69u7jJenJrlmGiSJc4evex74RVl?=
 =?us-ascii?Q?g3PwCRm1emKeqkaMpcxC1TjclpBb/8G+0FA2Erxj5BHrhEmB+R9ItaAIOMcv?=
 =?us-ascii?Q?FlF+uOzxrZIHIxr/xmgcve+qHmK2kElb5DUL7eFN8xITXR5Z7jtKHBD2uosE?=
 =?us-ascii?Q?V+CD4qRZxqQY83NQr/jUW1mcRJ45xXfbJFl9OrAIGHrPUiLR0mIQvoC+iKh1?=
 =?us-ascii?Q?M7Fq6uwRnqiDRSmDwxioatDQxiuhV2GpgWHKgGW1/U3EKrOmaYnoqAhrJZWP?=
 =?us-ascii?Q?oZtz+EIDcaiIRqTwOYeXrVyGawBfcc/3VY190ahS0W3SSXrFAN4KuhBfVsOd?=
 =?us-ascii?Q?v0tGT/RBn1+Ugo8TmuWHFLFTTFi3uhIW1lIIS0YGRZzcyWJ5YwOXlKPM7AUr?=
 =?us-ascii?Q?LKFFd4Kvp7WyTCgkteXH4bCWZqqPR8TEJxz8lLg/ErS7wIV9ymKspLAFwnYj?=
 =?us-ascii?Q?lYALov301lxokX5MzN/TyekOttoC5IM2LV4IlVAa8J+/uqztLfyBI0nZWDqT?=
 =?us-ascii?Q?a4STyLxymCb3oj2wJJwAGHMIZ3fgYro9/Zmj2QlirNyq9XgBi5vxF88uN7KP?=
 =?us-ascii?Q?dIQ8ioXXH8R6FX/QFWaBtsmDHYN4YA6PxIrKHc9Ve315DZwYq9OmahJYFXls?=
 =?us-ascii?Q?mps3R2+ktx/s5cZA1LSssNf83Sg1sT0jW8JvPIVVjnGjENHRuhOHesoUOzgU?=
 =?us-ascii?Q?qqihSrMBSPVVYgGN9TJgf+3uj0ArzGvHOBFvrzpWinmRwpJDyfX0uVR5hth9?=
 =?us-ascii?Q?oYIjfpJeiI+B+KFt4eJza7TFBwG8NZlPTIPMxBggDN7WSfr9yXGw8kLMCUl5?=
 =?us-ascii?Q?s9C3fHffdq4OM0x0OZq5jnuC0cXmTYz0tEo2o3vBYPBwwESJcKJVFcYqcnO8?=
 =?us-ascii?Q?zH9xn4B3U14myZGE/at0tAWucXKVOOcwdhQtHjqQhDyi8MnrUFOSEcbOOqmj?=
 =?us-ascii?Q?8Xjg8Q5Rf8GszVFlhmwUuCKH7mx1abt03pEXPfqvcWjG0WzcJouaUZaMTS6h?=
 =?us-ascii?Q?VNcBmhQft5C945GJN3zOCJskeo+RokvXoRC/GfwphioCLTcqgEiPixDWhwaE?=
 =?us-ascii?Q?2BMh3ly1nYYiV90Digw83090aWVWkyuhdtHozUSydjHdtNUtnNgZtZLplOsJ?=
 =?us-ascii?Q?jzrr+6t82e4Z5JRjAO1ZP8gN2v50XY8I1ELhtTQY68ueuF3fckc5c4gl+fPD?=
 =?us-ascii?Q?PfKGX05tvZRo91eD4b9HqKGzh/tec+DT+1It7VSToXG1zuXFjAh26CTJjkRd?=
 =?us-ascii?Q?iNZD0S6Ga9vpbQAohJu9pCyxIozcaMqtvxi5wUt6nxv5rZcGwo0OG5beifJc?=
 =?us-ascii?Q?jBvRZFRVT3VKPcXAd8hVuTx6ytwCV4eM+02Zl/fIAueGBVQsdccwYv1yEITj?=
 =?us-ascii?Q?5xZ2sR8DKNw0lWqOxQPyNtkgoRyFcYbnRA3wyY0lzoeXGKQ6Mgr6iZ0RdcJR?=
 =?us-ascii?Q?/tasJl+9INZKMnqgeMiCMfx0vmbXpoQX/F4WjnlIF4C7Ts8c5FEZffg489Xn?=
 =?us-ascii?Q?Vreiv88lvPi6QChnEa2X4WE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E09626EB48D08140ACA9E7ED9D971B6B@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59fabec-65e1-4b13-dbc7-08da669fa62d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 20:21:49.9890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T40kpuKq1kxJVmxhum6XssBLPK46cgEKiORgCMfCXl1BsNt7dtYNTe5GRDLtZDFOnYUm+fBD1fsQNXcBwEaVEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3070
X-Proofpoint-GUID: eOzdkrKNpJqdd5LHrezcf1I6A3qxicqx
X-Proofpoint-ORIG-GUID: eOzdkrKNpJqdd5LHrezcf1I6A3qxicqx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_13,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 15, 2022, at 12:59 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Fri, 15 Jul 2022 19:49:00 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>>> 
>>> What about if we release the lock when doing the callback?  
>> 
>> We can probably unlock ftrace_lock here. But we may break locking order 
>> with direct mutex (see below).
> 
> You're talking about the multi registering case, right?

We are using the *_ftrace_direct_multi() API here, to be able to specify
ops_func. The direct single API just uses the shared direct_ops. 

> 
>> 
>>> 
>>> Then we just need to make sure things are the same after reacquiring the
>>> lock, and if they are different, we release the lock again and do the
>>> callback with the new update. Wash, rinse, repeat, until the state is the
>>> same before and after the callback with locks acquired?  
>> 
>> Personally, I would like to avoid wash-rinse-repeat here.
> 
> But it's common to do. Keeps your hair cleaner that way ;-)
> 
>> 
>>> 
>>> This is a common way to handle callbacks that need to do something that
>>> takes the lock held before doing a callback.
>>> 
>>> The reason I say this, is because the more we can keep the accounting
>>> inside of ftrace the better.
>>> 
>>> Wouldn't this need to be done anyway if BPF was first and live kernel
>>> patching needed the update? An -EAGAIN would not suffice.  
>> 
>> prepare_direct_functions_for_ipmodify handles BPF-first-livepatch-later
>> case. The benefit of prepare_direct_functions_for_ipmodify() is that it 
>> holds direct_mutex before ftrace_lock, and keeps holding it if necessary. 
>> This is enough to make sure we don't need the wash-rinse-repeat. 
>> 
>> OTOH, if we wait until __ftrace_hash_update_ipmodify(), we already hold
>> ftrace_lock, but not direct_mutex. To make changes to bpf trampoline, we
>> have to unlock ftrace_lock and lock direct_mutex to avoid deadlock. 
>> However, this means we will need the wash-rinse-repeat. 

What do you think about the prepare_direct_functions_for_ipmodify() 
approach? If this is not ideal, maybe we can simplify it so that it only
holds direct_mutex (when necessary). The benefit is that we are sure
direct_mutex is already held in __ftrace_hash_update_ipmodify(). However, 
I think it is not safe to unlock ftrace_lock in __ftrace_hash_update_ipmodify(). 
We can get parallel do_for_each_ftrace_rec(), which is dangerous, no? 

>> 
>> 
>> For livepatch-first-BPF-later case, we can probably handle this in 
>> __ftrace_hash_update_ipmodify(), since we hold both direct_mutex and 
>> ftrace_lock. We can unlock ftrace_lock and update the BPF trampoline. 
>> It is safe against changes to direct ops, because we are still holding 
>> direct_mutex. But, is this safe against another IPMODIFY ops? I am not 
>> sure yet... Also, this is pretty weird because, we are updating a 
>> direct trampoline before we finish registering it for the first time. 
>> IOW, we are calling modify_ftrace_direct_multi_nolock for the same 
>> trampoline before register_ftrace_direct_multi() returns.
>> 
>> The approach in v2 propagates the -EAGAIN to BPF side, so these are two
>> independent calls of register_ftrace_direct_multi(). This does require
>> some protocol between ftrace core and its user, but I still think this 
>> is a cleaner approach. 
> 
> The issue I have with this approach is it couples BPF and ftrace a bit too
> much.
> 
> But there is a way with my approach you can still do your approach. That
> is, have ops_func() return zero if everything is fine, and otherwise returns
> a negative value. Then have the register function fail and return whatever
> value that gets returned by the ops_func()
> 
> Then have the bpf ops_func() check (does this direct caller handle
> IPMODIFY? if yes, return 0, else return -EAGAIN). Then the registering of
> ftrace fails with your -EAGAIN, and then you can change the direct
> trampoline to handle IPMODIFY and try again. This time when ops_func() is
> called, it sees that the direct trampoline can handle the IPMODIFY and
> returns 0.
> 
> Basically, it's a way to still implement my suggestion, but let BPF decide
> to use -EAGAIN to try again. And then BPF and ftrace don't need to have
> these special flags to change the behavior of each other.

I like this one. So there is no protocol about the return value here. 

Thanks,
Song
