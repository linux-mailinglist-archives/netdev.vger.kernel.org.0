Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B20C538A31
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 05:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243627AbiEaDYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 23:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiEaDYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 23:24:40 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47DC91585
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 20:24:38 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so1172641pju.1
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 20:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=QLemg35dtO0TggrOtHsmX2G8r9FZ0B/KT3RLAejsh4U=;
        b=rC54PeeMuU8j1dq+b34pSGbGrDtfYR37oseYqNxdFvlQSERPokecvYHWf8gIyG/zms
         26C6vVO6Lo8uYlfas7oTx3YECIhiuOI0ycylVWHwCJHJh9YbC7naOatjDp4H2C0dQc6/
         5msyN/q0LSM5BUlAUXdkylWWzWcMySYE5p/KNjDoS/yqYuHBMJ6nJ8D0we5fGlGakM8/
         Pl9ak5WZuD4rcyVmhrQYtWDeWyrMljDocktriE4F8kuu7itM1x9eQ07FYbW+AmU4QC6R
         gzxV5VGFhSA11k3VH9Mq89S/28tZhKbBxXsgtgOptDsHsJnssWeiTGDJTPuyy6xY9235
         AIJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QLemg35dtO0TggrOtHsmX2G8r9FZ0B/KT3RLAejsh4U=;
        b=aLssI2goKrFhMu3tMDJQOClOH/xQmnj5jsY6C/13W4u5XbUFtsv9snnTJIcGv9cKKy
         iqmI81i3gFwPhcLhhkHGfFIWk79k63KTu71CLb2I0qTvMxdLUy3w6bJlS3AvuK82GX4g
         6mKqac1mxahECCx3KXq4YmLqTp/yMXNLhB6azcsUrzGDuPG8txwdUtW+ZBmVOhTrgdNv
         wvl1DdU7k8Qui3uXIAUYq4/JO279FIyK0AuG+NQuYA5Kazbs8IZqRC24IPTpQ5nwZpzt
         9TmZhf/j+oIxk1cO3YOKZNBzJGoggkZiLkVlk0+hi4nHb3cErgkNSqCbCjyxWV1fzY10
         QXUw==
X-Gm-Message-State: AOAM533a5m55p0dbCTxtNRkeZRn5NqwbualwWWABCrLemlBx0LIMiejd
        hhCDaFYU8r5wbri7o+IXHFMzsg==
X-Google-Smtp-Source: ABdhPJyVXeL/+sKZJvszTSuatiJtXzvb33Ze9d4ceYMbJ7rWDV4jLin5P6/QcPPZPdrhwG127DAP0A==
X-Received: by 2002:a17:902:e552:b0:163:6a5e:4e0d with SMTP id n18-20020a170902e55200b001636a5e4e0dmr27124956plf.66.1653967478391;
        Mon, 30 May 2022 20:24:38 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id z3-20020a17090a8b8300b001e2afd35791sm476368pjn.18.2022.05.30.20.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 20:24:38 -0700 (PDT)
Message-ID: <1302ea6d-3b25-bcc9-e988-9f538231e088@bytedance.com>
Date:   Tue, 31 May 2022 11:24:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: Re: [PATCH v3 1/2] bpf: avoid grabbing spin_locks of all cpus
 when no free elems
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com
References: <20220530091340.53443-1-zhoufeng.zf@bytedance.com>
 <20220530091340.53443-2-zhoufeng.zf@bytedance.com>
 <3cd2bc87-d766-0466-7079-eaff14fbe422@iogearbox.net>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <3cd2bc87-d766-0466-7079-eaff14fbe422@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/31 上午5:20, Daniel Borkmann 写道:
> On 5/30/22 11:13 AM, Feng zhou wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> This patch add is_empty in pcpu_freelist_head to check freelist
>> having free or not. If having, grab spin_lock, or check next cpu's
>> freelist.
>>
>> Before patch: hash_map performance
>> ./map_perf_test 1
>> 0:hash_map_perf pre-alloc 975345 events per sec
>> 4:hash_map_perf pre-alloc 855367 events per sec
>> 12:hash_map_perf pre-alloc 860862 events per sec
>> 8:hash_map_perf pre-alloc 849561 events per sec
>> 3:hash_map_perf pre-alloc 849074 events per sec
>> 6:hash_map_perf pre-alloc 847120 events per sec
>> 10:hash_map_perf pre-alloc 845047 events per sec
>> 5:hash_map_perf pre-alloc 841266 events per sec
>> 14:hash_map_perf pre-alloc 849740 events per sec
>> 2:hash_map_perf pre-alloc 839598 events per sec
>> 9:hash_map_perf pre-alloc 838695 events per sec
>> 11:hash_map_perf pre-alloc 845390 events per sec
>> 7:hash_map_perf pre-alloc 834865 events per sec
>> 13:hash_map_perf pre-alloc 842619 events per sec
>> 1:hash_map_perf pre-alloc 804231 events per sec
>> 15:hash_map_perf pre-alloc 795314 events per sec
>>
>> hash_map the worst: no free
>> ./map_perf_test 2048
>> 6:worse hash_map_perf pre-alloc 28628 events per sec
>> 5:worse hash_map_perf pre-alloc 28553 events per sec
>> 11:worse hash_map_perf pre-alloc 28543 events per sec
>> 3:worse hash_map_perf pre-alloc 28444 events per sec
>> 1:worse hash_map_perf pre-alloc 28418 events per sec
>> 7:worse hash_map_perf pre-alloc 28427 events per sec
>> 13:worse hash_map_perf pre-alloc 28330 events per sec
>> 14:worse hash_map_perf pre-alloc 28263 events per sec
>> 9:worse hash_map_perf pre-alloc 28211 events per sec
>> 15:worse hash_map_perf pre-alloc 28193 events per sec
>> 12:worse hash_map_perf pre-alloc 28190 events per sec
>> 10:worse hash_map_perf pre-alloc 28129 events per sec
>> 8:worse hash_map_perf pre-alloc 28116 events per sec
>> 4:worse hash_map_perf pre-alloc 27906 events per sec
>> 2:worse hash_map_perf pre-alloc 27801 events per sec
>> 0:worse hash_map_perf pre-alloc 27416 events per sec
>> 3:worse hash_map_perf pre-alloc 28188 events per sec
>>
>> ftrace trace
>>
>> 0)               |  htab_map_update_elem() {
>> 0)   0.198 us    |    migrate_disable();
>> 0)               |    _raw_spin_lock_irqsave() {
>> 0)   0.157 us    |      preempt_count_add();
>> 0)   0.538 us    |    }
>> 0)   0.260 us    |    lookup_elem_raw();
>> 0)               |    alloc_htab_elem() {
>> 0)               |      __pcpu_freelist_pop() {
>> 0)               |        _raw_spin_lock() {
>> 0)   0.152 us    |          preempt_count_add();
>> 0)   0.352 us    |          native_queued_spin_lock_slowpath();
>> 0)   1.065 us    |        }
>>          |      ...
>> 0)               |        _raw_spin_unlock() {
>> 0)   0.254 us    |          preempt_count_sub();
>> 0)   0.555 us    |        }
>> 0) + 25.188 us   |      }
>> 0) + 25.486 us   |    }
>> 0)               |    _raw_spin_unlock_irqrestore() {
>> 0)   0.155 us    |      preempt_count_sub();
>> 0)   0.454 us    |    }
>> 0)   0.148 us    |    migrate_enable();
>> 0) + 28.439 us   |  }
>>
>> The test machine is 16C, trying to get spin_lock 17 times, in addition
>> to 16c, there is an extralist.
>>
>> after patch: hash_map performance
>> ./map_perf_test 1
>> 0:hash_map_perf pre-alloc 969348 events per sec
>> 10:hash_map_perf pre-alloc 906526 events per sec
>> 11:hash_map_perf pre-alloc 904557 events per sec
>> 9:hash_map_perf pre-alloc 902384 events per sec
>> 15:hash_map_perf pre-alloc 912287 events per sec
>> 14:hash_map_perf pre-alloc 905689 events per sec
>> 12:hash_map_perf pre-alloc 903680 events per sec
>> 13:hash_map_perf pre-alloc 902631 events per sec
>> 8:hash_map_perf pre-alloc 875369 events per sec
>> 4:hash_map_perf pre-alloc 862808 events per sec
>> 1:hash_map_perf pre-alloc 857218 events per sec
>> 2:hash_map_perf pre-alloc 852875 events per sec
>> 5:hash_map_perf pre-alloc 846497 events per sec
>> 6:hash_map_perf pre-alloc 828467 events per sec
>> 3:hash_map_perf pre-alloc 812542 events per sec
>> 7:hash_map_perf pre-alloc 805336 events per sec
>>
>> hash_map worst: no free
>> ./map_perf_test 2048
>> 7:worse hash_map_perf pre-alloc 391104 events per sec
>> 4:worse hash_map_perf pre-alloc 388073 events per sec
>> 5:worse hash_map_perf pre-alloc 387038 events per sec
>> 1:worse hash_map_perf pre-alloc 386546 events per sec
>> 0:worse hash_map_perf pre-alloc 384590 events per sec
>> 11:worse hash_map_perf pre-alloc 379378 events per sec
>> 10:worse hash_map_perf pre-alloc 375480 events per sec
>> 12:worse hash_map_perf pre-alloc 372394 events per sec
>> 6:worse hash_map_perf pre-alloc 367692 events per sec
>> 3:worse hash_map_perf pre-alloc 363970 events per sec
>> 9:worse hash_map_perf pre-alloc 364008 events per sec
>> 8:worse hash_map_perf pre-alloc 363759 events per sec
>> 2:worse hash_map_perf pre-alloc 360743 events per sec
>> 14:worse hash_map_perf pre-alloc 361195 events per sec
>> 13:worse hash_map_perf pre-alloc 360276 events per sec
>> 15:worse hash_map_perf pre-alloc 360057 events per sec
>> 0:worse hash_map_perf pre-alloc 378177 events per sec
>>
>> ftrace trace
>> 0)               |  htab_map_update_elem() {
>> 0)   0.317 us    |    migrate_disable();
>> 0)               |    _raw_spin_lock_irqsave() {
>> 0)   0.260 us    |      preempt_count_add();
>> 0)   1.803 us    |    }
>> 0)   0.276 us    |    lookup_elem_raw();
>> 0)               |    alloc_htab_elem() {
>> 0)   0.586 us    |      __pcpu_freelist_pop();
>> 0)   0.945 us    |    }
>> 0)               |    _raw_spin_unlock_irqrestore() {
>> 0)   0.160 us    |      preempt_count_sub();
>> 0)   0.972 us    |    }
>> 0)   0.657 us    |    migrate_enable();
>> 0)   8.669 us    |  }
>>
>> It can be seen that after adding this patch, the map performance is
>> almost not degraded, and when free=0, first check is_empty instead of
>> directly acquiring spin_lock.
>>
>> As for why to add is_empty instead of directly judging head->first, my
>> understanding is this, head->first is frequently modified during 
>> updating
>> map, which will lead to invalid other cpus's cache, and is_empty is 
>> after
>> freelist having no free elems will be changed, the performance will 
>> be better.
>>
>> Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>> ---
>>   kernel/bpf/percpu_freelist.c | 28 +++++++++++++++++++++++++---
>>   kernel/bpf/percpu_freelist.h |  1 +
>>   2 files changed, 26 insertions(+), 3 deletions(-)
> [...]
>>       /* per cpu lists are all empty, try extralist */
>> +    if (s->extralist.is_empty)
>> +        return NULL;
>>       raw_spin_lock(&s->extralist.lock);
>>       node = s->extralist.first;
>> -    if (node)
>> +    if (node) {
>>           s->extralist.first = node->next;
>> +        if (!s->extralist.first)
>> +            s->extralist.is_empty = true;
>> +    }
>>       raw_spin_unlock(&s->extralist.lock);
>>       return node;
>>   }
>> @@ -164,15 +178,20 @@ ___pcpu_freelist_pop_nmi(struct pcpu_freelist *s)
>>       orig_cpu = cpu = raw_smp_processor_id();
>>       while (1) {
>>           head = per_cpu_ptr(s->freelist, cpu);
>> +        if (head->is_empty)
>
> This should use READ_ONCE/WRITE_ONCE pair for head->is_empty.

Yes, will do. Thanks.

>
>> +            goto next_cpu;
>>           if (raw_spin_trylock(&head->lock)) {
>>               node = head->first;
>>               if (node) {
>>                   head->first = node->next;
>> +                if (!head->first)
>> +                    head->is_empty = true;
>>                   raw_spin_unlock(&head->lock);
>>                   return node;
>>               }
>>               raw_spin_unlock(&head->lock);
>>           }
>> +next_cpu:
>>           cpu = cpumask_next(cpu, cpu_possible_mask);
>>           if (cpu >= nr_cpu_ids)
>>               cpu = 0;


