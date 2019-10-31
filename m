Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1FEEB655
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfJaRrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:47:40 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37591 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfJaRrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:47:40 -0400
Received: by mail-pf1-f196.google.com with SMTP id u9so4860447pfn.4;
        Thu, 31 Oct 2019 10:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D4IpMr9Q2vIVypObg4yLY/Jn9WPLxRmhgpjGt2be+yE=;
        b=EaxrJWLPw0PwefXBdNfCI3NN3ViWbfwS28AnL9dbF+gIpU4/v4BUjM+1mjeTpokV4i
         PLynn1hfwJvZlWx/M+rt9kTiPWXglGVHcvU1R510nIM0RxZoH92YlrO+N6gLDkm0Z467
         gWvEar74I0yVZ5FcvEcG0hrJW4hAGo8sTnE/phIYFo/dWO16qtRwCguFAO80iv/nsE61
         EDkrmQrP+DaFZAwaLwSGC9+YU3YnDlyTpzIRLN18HQClpPxtXohO0tVARbRlgrEppZLm
         waeYTDB+gpHiar/Lrba2wJWbD2xrrQh8dssBd1BrP2elbfrH9uzH2zREokd5SewgB6rv
         Xh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D4IpMr9Q2vIVypObg4yLY/Jn9WPLxRmhgpjGt2be+yE=;
        b=Io+xg99ehailEjrXCmk8ZXheAmLITPf/COgyvY1xb64zOAAMu/MMB2OWNA1A4GQ2ur
         bfr/PpJ0vv/zcrzH/a4NDTqzC3C2vh+VL6sZ3E+1ZOqsWpgKON4wSjYK9NSumRAT1Gr3
         ogd2H244+XJRg4Lg9YBUBSy1kFlxTXYR55bH8PSDLfUbtkkQMxX5SfI7vgcyQVrSywZk
         mpsfv+0Fcv6uglWSPW7n0K3e39YXDbI1i9lhmf5Z4vuuhCOrAhVKt1gGBnRTYSw8CUh/
         BDaM4aeLndfJqdbPz9yZ0feVDltePlJjbUaivOyKvzYl7uAGYo/61HCKisdnzJ+tl8uZ
         10sA==
X-Gm-Message-State: APjAAAXbSG0ByFHxYxW0tVemvliYZBYz8dGiZwFg9CaC+Y0846JHAtug
        jz/OA+CfPCGXcQA+b4dCxh8=
X-Google-Smtp-Source: APXvYqxKYabaLwBCK9EM42f37Bdz1ancD1yj7WBy1GTJ7FA548B9VQCL1PN33zDUvFa1FX50z9ExVg==
X-Received: by 2002:a63:4e13:: with SMTP id c19mr8144284pgb.225.1572544058706;
        Thu, 31 Oct 2019 10:47:38 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i123sm4165002pfe.145.2019.10.31.10.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 10:47:37 -0700 (PDT)
Subject: Re: [PATCH v2] net: fix sk_page_frag() recursion from memory reclaim
To:     Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
 <20191024205027.GF3622521@devbig004.ftw2.facebook.com>
 <CALvZod6=B-gMJJxhMRt6k5eRwB-3zdgJR5419orTq8-+36wbMQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <11f688a6-0288-0ec4-f925-7b8f16ec011b@gmail.com>
Date:   Thu, 31 Oct 2019 10:47:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CALvZod6=B-gMJJxhMRt6k5eRwB-3zdgJR5419orTq8-+36wbMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/31/19 10:35 AM, Shakeel Butt wrote:
> +Michal Hocko
> 
> On Thu, Oct 24, 2019 at 1:50 PM Tejun Heo <tj@kernel.org> wrote:
>>
>> sk_page_frag() optimizes skb_frag allocations by using per-task
>> skb_frag cache when it knows it's the only user.  The condition is
>> determined by seeing whether the socket allocation mask allows
>> blocking - if the allocation may block, it obviously owns the task's
>> context and ergo exclusively owns current->task_frag.
>>
>> Unfortunately, this misses recursion through memory reclaim path.
>> Please take a look at the following backtrace.
>>
>>  [2] RIP: 0010:tcp_sendmsg_locked+0xccf/0xe10
>>      ...
>>      tcp_sendmsg+0x27/0x40
>>      sock_sendmsg+0x30/0x40
>>      sock_xmit.isra.24+0xa1/0x170 [nbd]
>>      nbd_send_cmd+0x1d2/0x690 [nbd]
>>      nbd_queue_rq+0x1b5/0x3b0 [nbd]
>>      __blk_mq_try_issue_directly+0x108/0x1b0
>>      blk_mq_request_issue_directly+0xbd/0xe0
>>      blk_mq_try_issue_list_directly+0x41/0xb0
>>      blk_mq_sched_insert_requests+0xa2/0xe0
>>      blk_mq_flush_plug_list+0x205/0x2a0
>>      blk_flush_plug_list+0xc3/0xf0
>>  [1] blk_finish_plug+0x21/0x2e
>>      _xfs_buf_ioapply+0x313/0x460
>>      __xfs_buf_submit+0x67/0x220
>>      xfs_buf_read_map+0x113/0x1a0
>>      xfs_trans_read_buf_map+0xbf/0x330
>>      xfs_btree_read_buf_block.constprop.42+0x95/0xd0
>>      xfs_btree_lookup_get_block+0x95/0x170
>>      xfs_btree_lookup+0xcc/0x470
>>      xfs_bmap_del_extent_real+0x254/0x9a0
>>      __xfs_bunmapi+0x45c/0xab0
>>      xfs_bunmapi+0x15/0x30
>>      xfs_itruncate_extents_flags+0xca/0x250
>>      xfs_free_eofblocks+0x181/0x1e0
>>      xfs_fs_destroy_inode+0xa8/0x1b0
>>      destroy_inode+0x38/0x70
>>      dispose_list+0x35/0x50
>>      prune_icache_sb+0x52/0x70
>>      super_cache_scan+0x120/0x1a0
>>      do_shrink_slab+0x120/0x290
>>      shrink_slab+0x216/0x2b0
>>      shrink_node+0x1b6/0x4a0
>>      do_try_to_free_pages+0xc6/0x370
>>      try_to_free_mem_cgroup_pages+0xe3/0x1e0
>>      try_charge+0x29e/0x790
>>      mem_cgroup_charge_skmem+0x6a/0x100
>>      __sk_mem_raise_allocated+0x18e/0x390
>>      __sk_mem_schedule+0x2a/0x40
>>  [0] tcp_sendmsg_locked+0x8eb/0xe10
>>      tcp_sendmsg+0x27/0x40
>>      sock_sendmsg+0x30/0x40
>>      ___sys_sendmsg+0x26d/0x2b0
>>      __sys_sendmsg+0x57/0xa0
>>      do_syscall_64+0x42/0x100
>>      entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> In [0], tcp_send_msg_locked() was using current->page_frag when it
>> called sk_wmem_schedule().  It already calculated how many bytes can
>> be fit into current->page_frag.  Due to memory pressure,
>> sk_wmem_schedule() called into memory reclaim path which called into
>> xfs and then IO issue path.  Because the filesystem in question is
>> backed by nbd, the control goes back into the tcp layer - back into
>> tcp_sendmsg_locked().
>>
>> nbd sets sk_allocation to (GFP_NOIO | __GFP_MEMALLOC) which makes
>> sense - it's in the process of freeing memory and wants to be able to,
>> e.g., drop clean pages to make forward progress.  However, this
>> confused sk_page_frag() called from [2].  Because it only tests
>> whether the allocation allows blocking which it does, it now thinks
>> current->page_frag can be used again although it already was being
>> used in [0].
>>
>> After [2] used current->page_frag, the offset would be increased by
>> the used amount.  When the control returns to [0],
>> current->page_frag's offset is increased and the previously calculated
>> number of bytes now may overrun the end of allocated memory leading to
>> silent memory corruptions.
>>
>> Fix it by adding gfpflags_normal_context() which tests sleepable &&
>> !reclaim and use it to determine whether to use current->task_frag.
>>
>> v2: Eric didn't like gfp flags being tested twice.  Introduce a new
>>     helper gfpflags_normal_context() and combine the two tests.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Josef Bacik <josef@toxicpanda.com>
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
>> Cc: stable@vger.kernel.org
>> ---
>>  include/linux/gfp.h |   23 +++++++++++++++++++++++
>>  include/net/sock.h  |   11 ++++++++---
>>  2 files changed, 31 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index fb07b503dc45..61f2f6ff9467 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -325,6 +325,29 @@ static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
>>         return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
>>  }
>>
>> +/**
>> + * gfpflags_normal_context - is gfp_flags a normal sleepable context?
>> + * @gfp_flags: gfp_flags to test
>> + *
>> + * Test whether @gfp_flags indicates that the allocation is from the
>> + * %current context and allowed to sleep.
>> + *
>> + * An allocation being allowed to block doesn't mean it owns the %current
>> + * context.  When direct reclaim path tries to allocate memory, the
>> + * allocation context is nested inside whatever %current was doing at the
>> + * time of the original allocation.  The nested allocation may be allowed
>> + * to block but modifying anything %current owns can corrupt the outer
>> + * context's expectations.
>> + *
>> + * %true result from this function indicates that the allocation context
>> + * can sleep and use anything that's associated with %current.
>> + */
>> +static inline bool gfpflags_normal_context(const gfp_t gfp_flags)
>> +{
>> +       return (gfp_flags & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC)) ==
>> +               __GFP_DIRECT_RECLAIM;
> 
> I think we should be checking PF_MEMALLOC here instead. Something like:
> 
> return gfpflags_allow_blocking(gfp_flags) && !(current->flags & PF_MEMALLOC);
> 
> In my limited understanding, __GFP_MEMALLOC gives access to reserve
> but we have overloaded PF_MEMALLOC to also define the reclaim context.
> There are PF_MEMALLOC users which does not use __GFP_MEMALLOC like
> iscsi_sw_tcp_pdu_xmit() which can call sock_sendmsg().

Why would this layer not set sk->sk_allocation to GFP_ATOMIC ?

And it also might call sk_set_memalloc() too.

Please double check scsi layer, I am pretty sure it did well at some point.

