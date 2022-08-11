Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE0358F5F7
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 04:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiHKCt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 22:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiHKCtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 22:49:51 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32EB883C4;
        Wed, 10 Aug 2022 19:49:50 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id q15so17153807vsr.0;
        Wed, 10 Aug 2022 19:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=TfEOTtkcYJaUEG3i8tLJ5y6yonc86NXuPmtehQC+lb0=;
        b=KGbJ7BARMDPZ8ZfDeI/JqSMC9VxHeTvaFJV8O+vqloVR/aSZEmq4pLPF6FVADfTxwJ
         sqhQEHeWpmtzoBtsfSMt4rFSr+V69NOLw8nWf0jAtacDQV2oUaJq/QZwFrZXCadUfQto
         nbyZpuf6T15X8EdWCuuXigx3jVkItY0mrCZgvhqJICvEZuIo8ZJeZk/tAQe5lbWv9Kup
         PSKBk2MyA2W/PtbXz2zEL7mMD4uRKjJ642OuhDJEoT891CLdd+7BbDKNjQ+SziDw0h/c
         iZAhGXV8lvZlr4g3R0au7O04b7Eaba8R0401x6l3S0tTPY+s0Frs2RsVkA9wK0A4yCLr
         jFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=TfEOTtkcYJaUEG3i8tLJ5y6yonc86NXuPmtehQC+lb0=;
        b=Y7Uer3DacCukYle0dFNJF2fmAcYphPkmrbtft/JlIKYhxpUPwfk6welb+kzUFYf3Wk
         AyxlhLEhPVwoVM6e2+X+WnG1mXtDUky1xwoyokJJiDVApjkoyY29xB5yv5hbWCGZjQr+
         PRCU/j4t9vy0bDYJhHHUkDRVTN2CEwHRvCzGtB48BbSAzEG4rNwzq8nyXxY+k8spdIx6
         BuKh5pSZb1C4kVcX3acyTyTE9ji1dIejeo+8X3l0FgMcDgFm3+5pNlzFNd05ZeWEl0Oo
         X2o7OhnphZZUJzswXkaMXxyS0GMtduv8KUU4L6vMR4I6QS0z2l3V5OX4Y8onkN+PlV5T
         j1Vw==
X-Gm-Message-State: ACgBeo2gBNC9F4JJy3dfY9/LCMIchnzKpDUdFNB0buRjOeu4926hT20h
        wkSzHd3NAfNpn2TWvt7oktK47HtnhlqDpFssKRU=
X-Google-Smtp-Source: AA6agR6/0/dr/6H3XAXmzGjLXFciMVLG1Hy9ex5uLgC9traDcSePOKHGIpqAKdOePUtI9IUMfIziA99wd8QWMEQfI+U=
X-Received: by 2002:a67:db14:0:b0:387:fc62:8cd7 with SMTP id
 z20-20020a67db14000000b00387fc628cd7mr12903319vsj.80.1660186190103; Wed, 10
 Aug 2022 19:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220810151840.16394-1-laoar.shao@gmail.com> <20220810151840.16394-6-laoar.shao@gmail.com>
 <20220810170706.ikyrsuzupjwt65h7@google.com>
In-Reply-To: <20220810170706.ikyrsuzupjwt65h7@google.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 11 Aug 2022 10:49:13 +0800
Message-ID: <CALOAHbBk+komswLqs0KBg8FeFAYpC20HjXrUeZA-=7cWf6nRUw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/15] bpf: Fix incorrect mem_cgroup_put
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 1:07 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Wed, Aug 10, 2022 at 03:18:30PM +0000, Yafang Shao wrote:
> > The memcg may be the root_mem_cgroup, in which case we shouldn't put it.
>
> No, it is ok to put root_mem_cgroup. css_put already handles the root
> cgroups.
>

Ah, this commit log doesn't describe the issue clearly. I should improve it.
The issue is that in bpf_map_get_memcg() it doesn't get the objcg if
map->objcg is NULL (that can happen if the map belongs to the root
memcg), so we shouldn't put the objcg if map->objcg is NULL neither in
bpf_map_put_memcg().
Maybe the change below would be more reasonable ?

+static void bpf_map_put_memcg(const struct bpf_map *map, struct
mem_cgroup *memcg)
+{
+       if (map->objcg)
+           mem_cgroup_put(memcg);
+}

-- 
Regards
Yafang
