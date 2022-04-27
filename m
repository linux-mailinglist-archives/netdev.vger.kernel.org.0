Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF18512107
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiD0PJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239345AbiD0PJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:09:34 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C451D506E8
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:06:22 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id j8so1770093pll.11
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XS75V+e2Ct78C2HTr9fzu0rvESRlSHMev5cWIVD79uw=;
        b=r/YR+XZjsNKfW6ntLhVS2qvC7q4aKCieabb65nb4ICf0i6WPU76Rc+tkeTTxtOSp4r
         Cp4ikH5UOnW0RwHI0VWzuKZyB2yx+/3AEW56212jW8nk916NwlrBUrYbb5yh6HFUn/3g
         7C24RG1alHoU/CY45Nv2Q+KqmGQGYipv6EK7gRTDqW9eWMqt2je5/dYX0pSpvobCGJ2U
         T++YUMItnBRWW3mLRtwxTf5lcgwHzksUW2ykha3mFO2hChZdUZ9YL6VgaQRSBgXZJ1CA
         KE42kd5aMrtcbglmkWfum3XmBqsylzcpg0FRfxBDKbVvhz6YeFwQIJ/RD9fCyF/VAJ6e
         4lcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XS75V+e2Ct78C2HTr9fzu0rvESRlSHMev5cWIVD79uw=;
        b=k+IseGvwcmftg4M1l0gClNhAiJ2LByrlmCBySuNVPJfgs2tlxT0Y/sk0afvmLYjAqI
         XUelE9zDaIZiP7sJQNsUCLsxRrxZsJHVwL7kdDRkOE0cEvEB/2JfSuwWXQVP0qcc63So
         xOeiWPZFneXIMrAS7MBBgcfHxLNtzyQ93InxY4yPDW1ue8BdVvOgVm1rQQ0Gr5I+s8rM
         d/tflKDObiyphjQW1AcQZDQaY+8xgdujX8Af/+zz3+rriMKS6aYrlWrcaHx42Z1OsPrx
         Bn+wN1Em0J9snw3RIgKae+GXtzwlPKrp/dQGDSStpqfU2AMbPiM2LWIBhtibcpqPqbVw
         zXkQ==
X-Gm-Message-State: AOAM533UXzRwQRrYif7xxm9Se9hu3VyGpI03ywlWcpAxmGiKmJRwWOrl
        UdIV73mh+9nUw52fUrWoidcDpLDJNmS3FYVUN+qi3w==
X-Google-Smtp-Source: ABdhPJyhFsA6EuYCCsjkboZqyERAvCzNstvehUDrJwgfZmF4YkAReKOkOhEXO+4ruAdhtV07MECBNmLql1kgnul+17A=
X-Received: by 2002:a17:903:2285:b0:15b:cd9e:f018 with SMTP id
 b5-20020a170903228500b0015bcd9ef018mr27793510plh.106.1651071981975; Wed, 27
 Apr 2022 08:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <YmdeCqi6wmgiSiWh@carbon> <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com> <20220427122232.GA9823@blackbody.suse.cz>
In-Reply-To: <20220427122232.GA9823@blackbody.suse.cz>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 27 Apr 2022 08:06:10 -0700
Message-ID: <CALvZod7v0taU51TNRu=OM5iJ-bnm1ryu9shjs80PuE-SWobqFg@mail.gmail.com>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks allocations
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     Vasily Averin <vvs@openvz.org>, Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 5:22 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> On Tue, Apr 26, 2022 at 10:23:32PM -0700, Shakeel Butt <shakeelb@google.c=
om> wrote:
> > [...]
> > >
> > > +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
> > > +{
> > > +       struct mem_cgroup *memcg;
> > > +
> >
> > Do we need memcg_kmem_enabled() check here or maybe
> > mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of
> > mem_cgroup_disabled() as we can have "cgroup.memory=3Dnokmem" boot
> > param.
>
> I reckon such a guard is on the charge side and readers should treat
> NULL and root_mem_group equally. Or is there a case when these two are
> different?
>
> (I can see it's different semantics when stored in current->active_memcg
> (and active_memcg() getter) but for such "outer" callers like here it
> seems equal.)

I was more thinking about possible shortcut optimization and unrelated
to this patch.

Vasily, can you please add documentation for get_mem_cgroup_from_obj()
similar to get_mem_cgroup_from_mm()? Also for mem_cgroup_or_root().
Please note that root_mem_cgroup can be NULL during early boot.
