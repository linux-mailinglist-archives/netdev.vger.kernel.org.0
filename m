Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1C58F133
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbiHJRHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiHJRHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:07:12 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E4C6DF88
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 10:07:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3283109eae2so130863537b3.15
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 10:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=NDKj9WvDVcpp72e/Jq/GTiPcROFKNcyaGjJEdm/L+Ts=;
        b=X9e/GgluQJANDKFV0jFwlXW00XKEjHhjfO/brvre3Gw5uNpgSHsWoIi8QDqA4wt8zk
         CexRXMYl9XeZtcQ1hg2op+YKm38bo0z4cWq8rCwG5+wrjzrUOJSInGLpcRNPTKVPxD8J
         TQJ02+pc3eBFY+XQ/1/w34xfwA9dtKzVGX0nmZGQMjB+MdAlDz3bkz8mMF91BWMCEFEt
         j+/QOmPEv9/ryDVEy/xsPy0lJGhPCSW59i60SFbFZp6JphxcmA71yWhTiw3oKJzNgwnu
         XoWreqyMPwsntxrmAakC9gUG0oYWZ4lVDH7xx1MiVudxtJgaYpbfsUUkgBjahjMLoLq3
         i1YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=NDKj9WvDVcpp72e/Jq/GTiPcROFKNcyaGjJEdm/L+Ts=;
        b=0HLurJLHjmlH6t/+0LAqlDcwCC/mC2wavU+fswDmcDvM45acIvs2lNdlPuWMNy3lWZ
         H2c/Zk5D24e1n7yCUthsJ3t4myzTQwPtckyKe8iY1v0HRBGw8POPIcSePc2wSZmxErvt
         EYzSG6tQCKgwhmVS7mW88/5Odn85FkBp9RqwTJ8/mh0o22r0E9hUy1JDLT4lgxNcJkcz
         89XZhgauu3Q6ZW1SPwm8oKasosGEjFLkivh5+yzQclSxuNlhmmPwyuShnCZ9gN/dbzHd
         lsa6xylq6S/LJT8LdUUp02vJYbwzzA+THWYyvBS7+YXft3htx/V28umXVsrG111pGKtX
         5Vew==
X-Gm-Message-State: ACgBeo1UCZw51GFCIejA5B5ujXVyPG6MrxaVfqdQBny4sw459SQzi7mX
        28n1GTdQjxvxZkdh2uXR46//CcQ7D9FP2g==
X-Google-Smtp-Source: AA6agR40+GyN7iMi/+y8+SEnXgz5d1sWTF6KBR9mZOrYJz5MsqI+gArikvEGD0ucx6p3tDpnZos8Ahi8w8vEZQ==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:28b])
 (user=shakeelb job=sendgmr) by 2002:a25:cb4f:0:b0:677:5f49:99e6 with SMTP id
 b76-20020a25cb4f000000b006775f4999e6mr25934323ybg.338.1660151229736; Wed, 10
 Aug 2022 10:07:09 -0700 (PDT)
Date:   Wed, 10 Aug 2022 17:07:06 +0000
In-Reply-To: <20220810151840.16394-6-laoar.shao@gmail.com>
Message-Id: <20220810170706.ikyrsuzupjwt65h7@google.com>
Mime-Version: 1.0
References: <20220810151840.16394-1-laoar.shao@gmail.com> <20220810151840.16394-6-laoar.shao@gmail.com>
Subject: Re: [PATCH bpf-next 05/15] bpf: Fix incorrect mem_cgroup_put
From:   Shakeel Butt <shakeelb@google.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 03:18:30PM +0000, Yafang Shao wrote:
> The memcg may be the root_mem_cgroup, in which case we shouldn't put it.

No, it is ok to put root_mem_cgroup. css_put already handles the root
cgroups.

