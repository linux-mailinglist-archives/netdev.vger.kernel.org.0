Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21130512556
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiD0Wj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiD0Wj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:39:28 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660CD6383;
        Wed, 27 Apr 2022 15:36:12 -0700 (PDT)
Date:   Wed, 27 Apr 2022 15:36:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651098970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YptwFdA8KWuDmjvuchBNuhhYcNiTn83Pm656usmn0sI=;
        b=xurUMpP3QLqUoZxw1BdoFkYM+0wVMIHfRfnM/Miz+pyrSnam+pUfOqzeu4w7WEtz+vscdO
        t8sZhvk29FJHTf9oMznLUlDzxrKSBESrMWIxTbOsTmuGq6MX7UWPvgVN2r6Q4pckJigj3y
        prcDwZAQTSSNCJlRUCceBDukatZZNz4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Vasily Averin <vvs@openvz.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks
 allocations
Message-ID: <YmnFUwhmqJwYGQ5j@carbon>
References: <YmdeCqi6wmgiSiWh@carbon>
 <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
 <20220427122232.GA9823@blackbody.suse.cz>
 <CALvZod7v0taU51TNRu=OM5iJ-bnm1ryu9shjs80PuE-SWobqFg@mail.gmail.com>
 <6b18f82d-1950-b38e-f3f5-94f6c23f0edb@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b18f82d-1950-b38e-f3f5-94f6c23f0edb@openvz.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 01:16:53AM +0300, Vasily Averin wrote:
> On 4/27/22 18:06, Shakeel Butt wrote:
> > On Wed, Apr 27, 2022 at 5:22 AM Michal Koutný <mkoutny@suse.com> wrote:
> >>
> >> On Tue, Apr 26, 2022 at 10:23:32PM -0700, Shakeel Butt <shakeelb@google.com> wrote:
> >>> [...]
> >>>>
> >>>> +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
> >>>> +{
> >>>> +       struct mem_cgroup *memcg;
> >>>> +
> >>>
> >>> Do we need memcg_kmem_enabled() check here or maybe
> >>> mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of
> >>> mem_cgroup_disabled() as we can have "cgroup.memory=nokmem" boot
> >>> param.
> 
> Shakeel, unfortunately I'm not ready to answer this question right now.
> I even did not noticed that memcg_kmem_enabled() and mem_cgroup_disabled()
> have a different nature.
> If you have no objections I'm going to keep this place as is and investigate
> this question later. 
> 
> >> I reckon such a guard is on the charge side and readers should treat
> >> NULL and root_mem_group equally. Or is there a case when these two are
> >> different?
> >>
> >> (I can see it's different semantics when stored in current->active_memcg
> >> (and active_memcg() getter) but for such "outer" callers like here it
> >> seems equal.)
> 
> Dear Michal,
> I may have misunderstood your point of view, so let me explain my vision
> in more detail.
> I do not think that NULL and root_mem_cgroup are equal here:
> - we have enabled cgroups and well-defined root_mem_cgroup,
> - this function is called from inside memcg-limited container,
> - we tried to get memcg from net, but without success,
>   and as result got NULL from  mem_cgroup_from_obj()
>   (frankly speaking I do not think this situation is really possible)
> If we keep memcg = NULL, then current's memcg will not be masked and
> net_init's allocations will be accounted to current's memcg. 
> So we need to set active_memcg to root_mem_cgroup, it helps to avoid
> incorrect accounting.

It's way out of scope of this patch, but I think we need to stop
using NULL as root_mem_cgroup/system scope indicator. Remaining use cases
will be like end of cgroup iteration, active memcg not set, parent of the
root memcg, etc.
We can point root_mem_cgroup at a statically allocated structure
on both CONFIG_MEMCG and !CONFIG_MEMCG.
Does it sound reasonable or I'm missing some important points?

Thanks!
