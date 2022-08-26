Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635EB5A2D03
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 19:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344476AbiHZRBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 13:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245334AbiHZRA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 13:00:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD274C22B1;
        Fri, 26 Aug 2022 10:00:56 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27QG79v7012752;
        Fri, 26 Aug 2022 10:00:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=r/GTamki9cXlimfL/v32dFmKRWhzyXeEjMbiNDop/R0=;
 b=oqUaWv0upTcQ2qpGh/bxqC4++aJtk1fBFm4eVK1VlUcqwBJw0JaNYX9EVh2iUa3jk6/X
 lTNsa3raTgLAwca9oH32Z0/5g3HGC5V7RO0SdQioZRWehPCEY/EOjMGl62KqomghiD0M
 YZfnT3wozyOqaF2KnLruqhjSpVWIOOyF9dY= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by m0001303.ppops.net (PPS) with ESMTPS id 3j71dhgcw0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 10:00:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZ6piL4lEsQ+/CdL7HVTk83fgS4qBE4tBCg3P9eIehwDxGgG+1a/qv0KyEMqMnKIYqMi/PI8HVrCM89jFHOIvjk4Q5k/ZnuFCKiB6AHdVa9ukVZeXjw8eZaWExNGR8591IAaSvEoN7kiD9arBUH+2StTxgtX41EKZZI1wdwXXQFTvQyYLwMbCnkWw1HoLfd9+6sQ480JOmXH9zH+w+qG+UkxxA4taEqNVZh+xqtAnAIbZV/kkYQLT91aiOsa2vcrT9hPGgKFez3P60fBBhEnUzg15eGqqmw/ltN7J0IId/ZmoEe9bLzh9uk98ElSVTP7+0eHVc2k3EGyPhumNVQD3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/GTamki9cXlimfL/v32dFmKRWhzyXeEjMbiNDop/R0=;
 b=AF6jVjHKm69clwGf+GY9HdTQRDHvO/9TZIpb21rqNrAzz5wo1hWqVPcgBJ5pQ6hGo5TRC5olyARbt/0l9MxADbGuT08WcUVEIdVyLc0FfsQamPNpqjAiHFiuryAGc6Xzme9DGDHhcggx37r95X5yeFrYyVYnPWodbL8JS0SvLsIkZuFlugF7VdnheT5ufVfDMGWdhbO3KLzaa4aQfJLD/wlLAiVIKYNmBiVk2qw7MX3tr5aaz1K7tJ7wDBzz+s0LEC61GC2glq2AHF/hXrSScH/FIo3bnua+9LKik20uWS+uVNrpaS7HulRgaSqQMTU3vuMkLUXmdR9V9flpsR6PVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BYAPR15MB3366.namprd15.prod.outlook.com (2603:10b6:a03:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 17:00:51 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da%9]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 17:00:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Serge E. Hallyn" <serge@hallyn.com>
CC:     Paul Moore <paul@paul-moore.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>,
        KP Singh <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>,
        "jackmanb@chromium.org" <jackmanb@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "stephen.smalley.work@gmail.com" <stephen.smalley.work@gmail.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        Shuah Khan <shuah@kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        bpf <bpf@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        "cgzones@googlemail.com" <cgzones@googlemail.com>,
        "karl@bigbadwolfsecurity.com" <karl@bigbadwolfsecurity.com>,
        "tixxdz@gmail.com" <tixxdz@gmail.com>
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
Thread-Topic: [PATCH v5 0/4] Introduce security_create_user_ns()
Thread-Index: AQHYsML1s5QOEDIN+UabdnIDmWJJf62yExMAgAEh2FOAAA7TgIAAQiRwgAAERYCAAAwHXoAAA3iAgAAEXA2AAReTgIAAEl8AgAGLNoCAAGuIgIAJPUDAgAARoYCAACyYgIABJECAgAAa2YA=
Date:   Fri, 26 Aug 2022 17:00:51 +0000
Message-ID: <25C89E75-A900-42C7-A8E4-2800AA2E3387@fb.com>
References: <8735du7fnp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
 <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
 <20220819144537.GA16552@mail.hallyn.com>
 <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
 <875yigp4tp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
 <0D14C118-E644-4D7B-84C0-CA7752DC0605@fb.com>
 <20220826152445.GB12466@mail.hallyn.com>
In-Reply-To: <20220826152445.GB12466@mail.hallyn.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0411fc31-e9cf-408e-7e19-08da87848829
x-ms-traffictypediagnostic: BYAPR15MB3366:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z54URYuxmyfIex6anw/bnnM4YKdq3tcxALjZAz+SVlKqO0ExdKgHR0WifchtUA3gqXaMQA/RNVntkNOoJVTZxzFyuKunI5e3Alt5oGq8qRK1JojYhFheDLTh+SdlO/NHD1W8NYM1xW7uSBGh13Zp3z6Vl483cCp/oBzs8/BG1T2mBMQzYsBkAdqR9qITc4qvWgkbIydmpCkmhRL12gPHlq2aePnRkoda38IxFfmwXbyEGv4FlwXjzHR+eNbc6raH4E3qGqVw19oQGe0sSUUG2O3QlQHNlR4dPqxrEKZY1rENqQ6AG2w7p3JtEJ+hPUCMf18OL1EJfMb9TwF+6vEYzr+ar9PYkUBeEYBExT3SLazt45d5J1fDW1h50ZE50fPcs2bcSD3qCRo7BzRHGZzID4Aw43fB7EQxYp4XHgKsjOnxSDk6vgwGvQWeHKxPtpq9TYxumRb0x3NeQJgofDxR6FwT5R8dxypH+7Hhq6dyoS99FaaUP64cMgemdb1Kokt/ciMl72yi0YwV6b/vPffB7SPdhzL2dlYTKowT+UT1RoEGbS3FILO1u5hhjZACJx6sv+GwGL60oobZKts9DkoyJr102qo+zRRtwJG7I/yd7dB9c5bu47E+IeYqzwSLf4JgDzCA8Ggn1WJAgBmpAhf1Gm2LhlEyXN3gzEiU5X1v2z+UIsxnrTZQTBds1N5ZoCgTzW0FX7EFjPbulmGtgm2Tp+nTH+5FUE4i9CNjhVAHUnlFxAMNj9aQKxzj8N/9fF+IMtUuIgbB2t5I0jcPl50m+WAgiFvy/rr4ob+QotsEvRJuldD0ukyf5vm4eNcutqar5tpVVyPpLHhv4C1fiOeVlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(8936002)(5660300002)(64756008)(66476007)(66556008)(4326008)(66946007)(6916009)(15650500001)(91956017)(76116006)(38100700002)(316002)(122000001)(36756003)(7416002)(54906003)(66446008)(6512007)(186003)(6506007)(86362001)(2616005)(8676002)(2906002)(33656002)(71200400001)(6486002)(966005)(38070700005)(41300700001)(53546011)(83380400001)(478600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qP7m+we4sPFInkoiUd6Fvhq5VOv4JyBk9SfgUniehMZgOTpHioiZlw/5XDFY?=
 =?us-ascii?Q?C4TZV70Ch9TIC5JaWS/2o0ub+f72GVN/s8AdZb3ZNAmH+FqOgt98BW2yq/0r?=
 =?us-ascii?Q?e0xw7vzJYFZkPQUiC76T2cjuSlmu1HQWt8DDksCz02zW63KTnk8cLKBg6Oaz?=
 =?us-ascii?Q?y8xNy1lotGeXnCzHnDv/QFPAT33Aj/Cg98DsUytl4HM56WAi4tJP/qG+4Wuf?=
 =?us-ascii?Q?V4jw1VurJZzehup3DjwE8iLyVT7u8wWB6MxDthb/0tP0zu5dGOTMTQRCkKA1?=
 =?us-ascii?Q?Tjg2NppIAWRx+j4BmincNa9MPxJoMZxbFSq7VeTQ86V0jpnad38YkqfQ018m?=
 =?us-ascii?Q?CcYJRTGKrO7NVzDDoDLtZNHwYVAAzC8Gye26wEy1Gi08gfWIwGpNRmkhU+7D?=
 =?us-ascii?Q?4IWDDNLF6mDBb9cgSVKVNocg7kyeDwTCwsNMV5CEPb6HINMR109DS0vSCPJs?=
 =?us-ascii?Q?7BOAPgkrvx/NgxqECmF3LSqkrtj9NX6kgBM8uIxvmwt5XZoGYzb4kPArIfQC?=
 =?us-ascii?Q?/OwXONidCvKoGa/CasZhqP/7h1j2yRqDaIOxDNAGtoFH3tB8PZbkMEFFPcdU?=
 =?us-ascii?Q?T2VB1+igpcCx+uSKMYVKdePQV54Ee6gsx+5t7BCnmBzTRXMcqljQW/RUJNW/?=
 =?us-ascii?Q?xnLB657iozuOabk0TL0EtkwGeSi9AWBoS1lESr5aBP4EB9nJPJaHUyobHyuL?=
 =?us-ascii?Q?7EAfxiBfenrVDTMwjiA7h/sGX5bMxTV2y/4Hb7DGXnvVhgw80DU4pMNkABBy?=
 =?us-ascii?Q?6ZoUcgUcQb7ttnsp/iXwK/0E3ixjmfVh0E4Hlb9WAtwnHzwbKaFQ8tSh4sBm?=
 =?us-ascii?Q?rIIOxjI1SrIxj+L0hbkGL5pPC3ejV8XObw0B7H+e14ACcZkWtFZWLLmupVW0?=
 =?us-ascii?Q?7+XUx9q/z8QI3atIYOUuy8j8hhihGP4MRrd+6+HbSasZ/lOe4Fd2Z1Xm61gs?=
 =?us-ascii?Q?xw41RPE/o53dCa7SGuPiuZjQPlKGBKZx/Digu2ypsjlolzSzwdm0/V7fVy1t?=
 =?us-ascii?Q?Unoey8AlArmOndc+gmRXPJRW2lODGGpUymjUsOTzDsGwj7ZHJvOL76/3rUeL?=
 =?us-ascii?Q?G2xVCgt/xYk4c0ZEwP+d4mXESAGWZYj61RUjWOuGlHkqvpW+A33hJhdq03YH?=
 =?us-ascii?Q?qyc1I4G8nM9zcihaK+T70llXZG3Or8VVw0mI8FTdS6mHyNHv52L7tSxhawXt?=
 =?us-ascii?Q?9bNPJU7ujNAPmz+7Sc2uaDT3pDMT/csmdj9AkqL1sFhdRP/QFqXqTa7jVeLe?=
 =?us-ascii?Q?D5XGIzx0T5YaAafkSj+g4QjLmVpMRtV6kPHSO3WoWQo2GXF4V/+biQEwXzpd?=
 =?us-ascii?Q?fcEjCKS67sP+lZ/X2XSWTCMdOEnZ1XzfP/ikWYJ53ChAfQkeIbGqE4MOGVbf?=
 =?us-ascii?Q?5LiEirq3rLGqPw9oUdwu+4KS9In+Q7jK11A3ZKQjgo9456+RsHklnnEri7+0?=
 =?us-ascii?Q?9pq5kqvr7Zb1N5pwBgQij/HnKkiIAgXBX2n5f8dylai8Bqc6A4Qj9Re+BIVz?=
 =?us-ascii?Q?6aDoqb7uqBW3BnqQpHuGXcN9iW+H3aYOokp6WC93kEFdHAofNchUXgw5PciZ?=
 =?us-ascii?Q?5oMh18+jVD8du8JqGTdZlDAObisORELcp4T7QROHwqDZHmEJep4MVENwuDfS?=
 =?us-ascii?Q?CIQd/SuiJZn+9KWODXsTOFY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B9B4117421A38A4BA1781E10A1B2512E@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0411fc31-e9cf-408e-7e19-08da87848829
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 17:00:51.5887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +G5C54ayu1LgVJVGK3+T/P0h8XjmF6uLlObeKRAaA5vvEWnSvGsHe29/x+FpCmXJC4JqCy7yWxngXwKVVZ32VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3366
X-Proofpoint-ORIG-GUID: r5CYj8q7_3oDYBFZI0U-uO46OoBTML8f
X-Proofpoint-GUID: r5CYj8q7_3oDYBFZI0U-uO46OoBTML8f
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_08,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 26, 2022, at 8:24 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> 
> On Thu, Aug 25, 2022 at 09:58:46PM +0000, Song Liu wrote:
>> 
>> 
>>> On Aug 25, 2022, at 12:19 PM, Paul Moore <paul@paul-moore.com> wrote:
>>> 
>>> On Thu, Aug 25, 2022 at 2:15 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>> Paul Moore <paul@paul-moore.com> writes:
>>>>> On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
>>>>>> I am hoping we can come up with
>>>>>> "something better" to address people's needs, make everyone happy, and
>>>>>> bring forth world peace.  Which would stack just fine with what's here
>>>>>> for defense in depth.
>>>>>> 
>>>>>> You may well not be interested in further work, and that's fine.  I need
>>>>>> to set aside a few days to think on this.
>>>>> 
>>>>> I'm happy to continue the discussion as long as it's constructive; I
>>>>> think we all are.  My gut feeling is that Frederick's approach falls
>>>>> closest to the sweet spot of "workable without being overly offensive"
>>>>> (*cough*), but if you've got an additional approach in mind, or an
>>>>> alternative approach that solves the same use case problems, I think
>>>>> we'd all love to hear about it.
>>>> 
>>>> I would love to actually hear the problems people are trying to solve so
>>>> that we can have a sensible conversation about the trade offs.
>>> 
>>> Here are several taken from the previous threads, it's surely not a
>>> complete list, but it should give you a good idea:
>>> 
>>> https://lore.kernel.org/linux-security-module/CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com/
>>> 
>>>> As best I can tell without more information people want to use
>>>> the creation of a user namespace as a signal that the code is
>>>> attempting an exploit.
>>> 
>>> Some use cases are like that, there are several other use cases that
>>> go beyond this; see all of our previous discussions on this
>>> topic/patchset.  As has been mentioned before, there are use cases
>>> that require improved observability, access control, or both.
>>> 
>>>> As such let me propose instead of returning an error code which will let
>>>> the exploit continue, have the security hook return a bool.  With true
>>>> meaning the code can continue and on false it will trigger using SIGSYS
>>>> to terminate the program like seccomp does.
>>> 
>>> Having the kernel forcibly exit the process isn't something that most
>>> LSMs would likely want.  I suppose we could modify the hook/caller so
>>> that *if* an LSM wanted to return SIGSYS the system would kill the
>>> process, but I would want that to be something in addition to
>>> returning an error code like LSMs normally do (e.g. EACCES).
>> 
>> I am new to user_namespace and security work, so please pardon me if
>> anything below is very wrong. 
>> 
>> IIUC, user_namespace is a tool that enables trusted userspace code to 
>> control the behavior of untrusted (or less trusted) userspace code. 
> 
> No.  user namespaces are not a way for more trusted code to control the
> behavior of less trusted code.

Hmm.. In this case, I think I really need to learn more. 

Thanks for pointing out my misunderstanding.

Song

> 
>> Failing create_user_ns() doesn't make the system more reliable. 
>> Specifically, we call create_user_ns() via two paths: fork/clone and 
>> unshare. For both paths, we need the userspace to use user_namespace, 
>> and to honor failed create_user_ns(). 
>> 
>> On the other hand, I would echo that killing the process is not 
>> practical in some use cases. Specifically, allowing the application to 
>> run in a less secure environment for a short period of time might be 
>> much better than killing it and taking down the whole service. Of 
>> course, there are other cases that security is more important, and 
>> taking down the whole service is the better choice. 
>> 
>> I guess the ultimate solution is a way to enforce using user_namespace
>> in the kernel (if it ever makes sense...). But I don't know how that
>> gonna work. Before we have such solution, maybe we only need an 
>> void hook for observability (or just a tracepoint, coming from BPF
>> background). 
>> 
>> Thanks,
>> Song

