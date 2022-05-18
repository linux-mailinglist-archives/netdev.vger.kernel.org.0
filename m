Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DE752B268
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiERGdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiERGc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:32:59 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6B3DE335;
        Tue, 17 May 2022 23:32:47 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id n10so851259qvi.5;
        Tue, 17 May 2022 23:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iNLG0SMc9nRqW0DoCoki52GgrxJLjTRCAhq9TQJlP3I=;
        b=J57mevt0lm333o3WqDhpUZ6lu35lzwxo4U0axQIyYIu8/Ub51orLPP+oVWcZ+7yuRO
         7TgzHWGchDJ2BfOfg2xsmx/0ebQ1NGbkQe8FjGp/g/MKi+IFcu3yF/KRfPVty1Ry2Xos
         Azoqc/NogRtoS6SJQsW8j0ixrA+Ttqw/Bv6pfmQ+CLAa4d/ycHb3YVx/lOOvCkvz4PLU
         /TWjhO3bn5hnPHQI95OdjDJHdxtkOrg+cg9VX7tWBXPGRqRTvbcmMOE92d+8NSfhSh4z
         Ji7EiBr4ktQIMgbpiWksFR2fN0eGkUW5r+1n2obxF3oJYxUwOQD2huxNxwLehof3hyfF
         dyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iNLG0SMc9nRqW0DoCoki52GgrxJLjTRCAhq9TQJlP3I=;
        b=jl3nv35/vg3g7hXWPGwiffAYumLcaRnvXtixY/ooZsumB4X9O07AOP3uoA/JQjabSz
         gKz92LTCgfhAdV5+Z0mgt1XhJmG4PXEi8aPXHpxU29Cq+Ift2dYQNTD3EzUtkldF9u77
         VxGGMqtSRQ9+PIklcETjJYGlNbDXFm9BIr0RNO+M4ZLloKfqQ7ewLRqhXIVKCR0R/SnE
         EH0zWIkzglPhN1QrrBmHdxqQzi+wHwj3gBzMRxZX5+TlWPFED6VQbgoAiLE41C8cs2ZP
         FxbsYGNzngaClPee6CIalnVYrETkXLXyNOrGgu2uYHg1Fyo5QGczVy0rCjxKsg2wd5xq
         LmBg==
X-Gm-Message-State: AOAM531kWdSzohGGZKI/pN6Yn+q4RJ6+lwKPyq3FINWUD9+QyEtQnBMu
        JuHUey7gQtBnYEVomV7Q+l9WcONmX7f5ap4N5+E=
X-Google-Smtp-Source: ABdhPJxbXZu2paoKEwxHX2Ersl25ZBBKIYIkmfDysk93JrGCsEzCBur7wOwPucdBX+7P9RLfRUAPFLmShF08g1cRR4k=
X-Received: by 2002:ad4:5c6e:0:b0:45a:aefd:f551 with SMTP id
 i14-20020ad45c6e000000b0045aaefdf551mr23591604qvh.95.1652855566388; Tue, 17
 May 2022 23:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220518062715.27809-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220518062715.27809-1-zhoufeng.zf@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 May 2022 23:32:35 -0700
Message-ID: <CAADnVQ+x-A87Z9_c+3vuRJOYm=gCOBXmyCJQ64CiCNukHS6FpA@mail.gmail.com>
Subject: Re: [PATCH] bpf: avoid grabbing spin_locks of all cpus when no free elems
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
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

On Tue, May 17, 2022 at 11:27 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> We encountered bad case on big system with 96 CPUs that
> alloc_htab_elem() would last for 1ms. The reason is that after the
> prealloc hashtab has no free elems, when trying to update, it will still
> grab spin_locks of all cpus. If there are multiple update users, the
> competition is very serious.
>
> So this patch add is_empty in pcpu_freelist_head to check freelist
> having free or not. If having, grab spin_lock, or check next cpu's
> freelist.
>
> Before patch: hash_map performance
> ./map_perf_test 1
> 0:hash_map_perf pre-alloc 975345 events per sec
> 4:hash_map_perf pre-alloc 855367 events per sec
> 12:hash_map_perf pre-alloc 860862 events per sec
> 8:hash_map_perf pre-alloc 849561 events per sec
> 3:hash_map_perf pre-alloc 849074 events per sec
> 6:hash_map_perf pre-alloc 847120 events per sec
> 10:hash_map_perf pre-alloc 845047 events per sec
> 5:hash_map_perf pre-alloc 841266 events per sec
> 14:hash_map_perf pre-alloc 849740 events per sec
> 2:hash_map_perf pre-alloc 839598 events per sec
> 9:hash_map_perf pre-alloc 838695 events per sec
> 11:hash_map_perf pre-alloc 845390 events per sec
> 7:hash_map_perf pre-alloc 834865 events per sec
> 13:hash_map_perf pre-alloc 842619 events per sec
> 1:hash_map_perf pre-alloc 804231 events per sec
> 15:hash_map_perf pre-alloc 795314 events per sec
>
> hash_map the worst: no free
> ./map_perf_test 2048
> 6:worse hash_map_perf pre-alloc 28628 events per sec
> 5:worse hash_map_perf pre-alloc 28553 events per sec
> 11:worse hash_map_perf pre-alloc 28543 events per sec
> 3:worse hash_map_perf pre-alloc 28444 events per sec
> 1:worse hash_map_perf pre-alloc 28418 events per sec
> 7:worse hash_map_perf pre-alloc 28427 events per sec
> 13:worse hash_map_perf pre-alloc 28330 events per sec
> 14:worse hash_map_perf pre-alloc 28263 events per sec
> 9:worse hash_map_perf pre-alloc 28211 events per sec
> 15:worse hash_map_perf pre-alloc 28193 events per sec
> 12:worse hash_map_perf pre-alloc 28190 events per sec
> 10:worse hash_map_perf pre-alloc 28129 events per sec
> 8:worse hash_map_perf pre-alloc 28116 events per sec
> 4:worse hash_map_perf pre-alloc 27906 events per sec
> 2:worse hash_map_perf pre-alloc 27801 events per sec
> 0:worse hash_map_perf pre-alloc 27416 events per sec
> 3:worse hash_map_perf pre-alloc 28188 events per sec
>
> ftrace trace
>
> 0)               |  htab_map_update_elem() {
> 0)   0.198 us    |    migrate_disable();
> 0)               |    _raw_spin_lock_irqsave() {
> 0)   0.157 us    |      preempt_count_add();
> 0)   0.538 us    |    }
> 0)   0.260 us    |    lookup_elem_raw();
> 0)               |    alloc_htab_elem() {
> 0)               |      __pcpu_freelist_pop() {
> 0)               |        _raw_spin_lock() {
> 0)   0.152 us    |          preempt_count_add();
> 0)   0.352 us    |          native_queued_spin_lock_slowpath();
> 0)   1.065 us    |        }
>                  |        ...
> 0)               |        _raw_spin_unlock() {
> 0)   0.254 us    |          preempt_count_sub();
> 0)   0.555 us    |        }
> 0) + 25.188 us   |      }
> 0) + 25.486 us   |    }
> 0)               |    _raw_spin_unlock_irqrestore() {
> 0)   0.155 us    |      preempt_count_sub();
> 0)   0.454 us    |    }
> 0)   0.148 us    |    migrate_enable();
> 0) + 28.439 us   |  }
>
> The test machine is 16C, trying to get spin_lock 17 times, in addition
> to 16c, there is an extralist.

Is this with small max_entries and a large number of cpus?

If so, probably better to fix would be to artificially
bump max_entries to be 4x of num_cpus.
Racy is_empty check still wastes the loop.
