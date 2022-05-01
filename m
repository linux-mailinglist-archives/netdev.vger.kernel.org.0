Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F8A5167FB
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 23:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355009AbiEAVN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 17:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354953AbiEAVN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 17:13:26 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D30FD34;
        Sun,  1 May 2022 14:09:59 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651439396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKDIQf5YU17uxh4rrGWr9X3eU/7EjCb3dKHQ+RI13NM=;
        b=ErAYkoy8SGeqig6yJdiYyw7Ot9Lryj1rEO8aAlGEhY/qHTXfpBSqY8LsRp7fqFiv6FkmER
        wff03KP5AxxltMOkRtZmEz9t9u7gmdBgFvOhjJ0ubJH80rA3q3H6f6bAfURXExHlsRS3vz
        CEA3rbbu0cJncAwfrI4SHmiUjFU5DQ0=
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks allocations
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <78b556f9-e57b-325d-89ce-7a482ef4ea21@openvz.org>
Date:   Sun, 1 May 2022 14:09:49 -0700
Cc:     Shakeel Butt <shakeelb@google.com>,
        =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Message-Id: <092476D2-C2C4-496C-A92C-EC0B331990ED@linux.dev>
References: <78b556f9-e57b-325d-89ce-7a482ef4ea21@openvz.org>
To:     Vasily Averin <vvs@openvz.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On May 1, 2022, at 6:44 AM, Vasily Averin <vvs@openvz.org> wrote:
>=20
> =EF=BB=BFOn 4/28/22 01:47, Shakeel Butt wrote:
>>> On Wed, Apr 27, 2022 at 3:43 PM Vasily Averin <vvs@openvz.org> wrote:
>>>=20
>>> On 4/27/22 18:06, Shakeel Butt wrote:
>>>> On Wed, Apr 27, 2022 at 5:22 AM Michal Koutn=C3=BD <mkoutny@suse.com> w=
rote:
>>>>>=20
>>>>> On Tue, Apr 26, 2022 at 10:23:32PM -0700, Shakeel Butt <shakeelb@googl=
e.com> wrote:
>>>>>> [...]
>>>>>>>=20
>>>>>>> +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
>>>>>>> +{
>>>>>>> +       struct mem_cgroup *memcg;
>>>>>>> +
>>>>>>=20
>>>>>> Do we need memcg_kmem_enabled() check here or maybe
>>>>>> mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of=

>>>>>> mem_cgroup_disabled() as we can have "cgroup.memory=3Dnokmem" boot
>>>>>> param.
>>>=20
>>> Shakeel, unfortunately I'm not ready to answer this question right now.
>>> I even did not noticed that memcg_kmem_enabled() and mem_cgroup_disabled=
()
>>> have a different nature.
>>> If you have no objections I'm going to keep this place as is and investi=
gate
>>> this question later.
>>>=20
>>=20
>> Patch is good as is. Just add the documentation to the functions in
>> the next version and you can keep the ACKs.
>=20
> I noticed that the kernel already has a function get_mem_cgroup_from_objcg=
(),
> the name of which is very similar to my new function get_mem_cgroup_from_o=
bj().
> Maybe it's better to rename my function to get_mem_cgroup_from_ptr()?

I don=E2=80=99t think it=E2=80=99s a problem: objcg is a widely used abbrevi=
ation and in my opinion is different enough from obj. I=E2=80=99d keep it fo=
r the consistency with the mem_cgroup_from_obj().

Thanks!=
