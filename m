Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9B2590B88
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 07:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbiHLFey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 01:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiHLFex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 01:34:53 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E643FA287A;
        Thu, 11 Aug 2022 22:34:51 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660282490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eT9oB/Jxs0HX/eo2S3EGE6XjZBx5ygu2ZiQitesEUO4=;
        b=w2pIQGWCS1/EKSQZpsMmnNHdguMKuLCCLx81UoSZ1cJIns5aJlRW/klnxQxiXEXBqXDzj1
        /I1800EVWMbwRGR+k99rKu6F5nZla3D0AmNRp7u7RrQnx4XQIv2OWT8dzbMuEXRDZOd6di
        B6IqiwAAkFlhCc3zqmARwFxJq42GCM0=
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 05/15] bpf: Fix incorrect mem_cgroup_put
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CALOAHbCXfRKDEt7jsUBsf-pQ-A7TpXPxGKYxu_GZN-8BUe2auw@mail.gmail.com>
Date:   Fri, 12 Aug 2022 13:33:54 +0800
Cc:     Shakeel Butt <shakeelb@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <870C70CA-C760-40A5-8A04-F0962EFDF507@linux.dev>
References: <20220810151840.16394-1-laoar.shao@gmail.com>
 <20220810151840.16394-6-laoar.shao@gmail.com>
 <20220810170706.ikyrsuzupjwt65h7@google.com>
 <CALOAHbBk+komswLqs0KBg8FeFAYpC20HjXrUeZA-=7cWf6nRUw@mail.gmail.com>
 <20220811154731.3smhom6v4qy2u6rd@google.com>
 <CALOAHbCXfRKDEt7jsUBsf-pQ-A7TpXPxGKYxu_GZN-8BUe2auw@mail.gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 12, 2022, at 08:27, Yafang Shao <laoar.shao@gmail.com> wrote:
>=20
> On Thu, Aug 11, 2022 at 11:47 PM Shakeel Butt <shakeelb@google.com> =
wrote:
>>=20
>> On Thu, Aug 11, 2022 at 10:49:13AM +0800, Yafang Shao wrote:
>>> On Thu, Aug 11, 2022 at 1:07 AM Shakeel Butt <shakeelb@google.com> =
wrote:
>>>>=20
>>>> On Wed, Aug 10, 2022 at 03:18:30PM +0000, Yafang Shao wrote:
>>>>> The memcg may be the root_mem_cgroup, in which case we shouldn't =
put it.
>>>>=20
>>>> No, it is ok to put root_mem_cgroup. css_put already handles the =
root
>>>> cgroups.
>>>>=20
>>>=20
>>> Ah, this commit log doesn't describe the issue clearly. I should =
improve it.
>>> The issue is that in bpf_map_get_memcg() it doesn't get the objcg if
>>> map->objcg is NULL (that can happen if the map belongs to the root
>>> memcg), so we shouldn't put the objcg if map->objcg is NULL neither =
in
>>> bpf_map_put_memcg().
>>=20
>> Sorry I am still not understanding. We are not 'getting' objcg in
>> bpf_map_get_memcg(). We are 'getting' memcg from map->objcg and if =
that
>> is NULL the function is returning root memcg and putting root memcg =
is
>> totally fine.
>=20
> When the map belongs to root_mem_cgroup, the map->objcg is NULL, right =
?
> See also bpf_map_save_memcg() and it describes clearly in the comment =
-
>=20
> static void bpf_map_save_memcg(struct bpf_map *map)
> {
>        /* Currently if a map is created by a process belonging to the =
root
>         * memory cgroup, get_obj_cgroup_from_current() will return =
NULL.
>         * So we have to check map->objcg for being NULL each time it's
>         * being used.
>         */
>        map->objcg =3D get_obj_cgroup_from_current();
> }
>=20
> So for the root_mem_cgroup case, bpf_map_get_memcg() will return
> root_mem_cgroup directly without getting its css, right ? See below,
>=20
> static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
> {
>=20
>        if (map->objcg)
>                return get_mem_cgroup_from_objcg(map->objcg);
>=20
>        return root_mem_cgroup;   // without css_get(&memcg->css);
> }
>=20
> But it will put the css unconditionally.  See below,
>=20
> memcg =3D bpf_map_get_memcg(map);
> ...
> mem_cgroup_put(memcg);
>=20
> So we should put it *conditionally* as well.

Hi,

No. We could put root_mem_cgroup unconditionally since the root css
is treated as no reference css. See css_put().

static inline void css_put(struct cgroup_subsys_state *css)
{
	// The root memcg=E2=80=99s css has been set with CSS_NO_REF.
        if (!(css->flags & CSS_NO_REF))
                percpu_ref_put(&css->refcnt);
}

Muchun,
Thanks.

>=20
>  memcg =3D bpf_map_get_memcg(map);
>   ...
> + if (map->objcg)
>       mem_cgroup_put(memcg);
>=20
> Is it clear to you ?
>=20
>> Or are you saying that root_mem_cgroup is NULL?
>>=20
>=20
> No
>=20
> --=20
> Regards
> Yafang

