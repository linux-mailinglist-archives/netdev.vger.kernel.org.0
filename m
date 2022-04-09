Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274D64FAA19
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 20:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiDISMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 14:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242980AbiDISMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 14:12:47 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB66AE4A
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 11:10:36 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bu29so20153502lfb.0
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 11:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=zoPNip8VLikRHe1urojzEFTsB5LgjyaGRKI3ch5gF7o=;
        b=QDPFB+py79p8EG6NCFJUJ36Y42o0PN3kC/RT9Wtd4KQ6ckS3+IbZ57wNMm4PQJfvQZ
         QF/mUuX0LHygBDFGKZJKCF5Q8YNoQ+05MUF+Z6DfiQaBbfkNk9RM8XE2WMk8TyWTQQW5
         oq2v+EJRFv7IVt8/cDBip1kqqzxYVQ1WwW6LQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=zoPNip8VLikRHe1urojzEFTsB5LgjyaGRKI3ch5gF7o=;
        b=WL1879DZlG97rWI8HtZM4j2j9j37MQGnUnlAKe6DS8tkErozO8djzkL5L/1n0aGJ4Z
         gP6Y6qSxRhR3xy8jHnfG8m3JtobzYPpP9ygqyiqCysr8EZsRIIJFe1om1j4Yob2SdKJV
         T6O0XyjfCYJqOL82kb8b7j51pAzuX1UpugrZrxxlbeboOBAarwzkZJvrE6xSzOlXMdLT
         d/RZPChCJF3SrGjEYsR3tNx/AfJcyRP5l4vFoyNnczNBkfWT+0qA5ImxSIfLaALH5Qva
         l/aPPHtfN5RiKp0Gu0PeTZlwLN0I1NG7ytNep6ODRsc4wlriMEniQQNM+AjGxfdMO49W
         /5NQ==
X-Gm-Message-State: AOAM531L3ld5AxHir5Q4fjE4XAePcnz/wMQNZlLHjUV+H0HFx5Sv+fdt
        B4oFyIEkX8wNkcmZS0WdXdTL3A==
X-Google-Smtp-Source: ABdhPJx1QoDFsW1QXOXj1h1+QAAA4L7UzeDxejPq60Y44lFmRRG3L/Nacft8AIckdCniircTb1d8Zw==
X-Received: by 2002:a05:6512:15a5:b0:46b:918a:cdda with SMTP id bp37-20020a05651215a500b0046b918acddamr2720652lfb.216.1649527834686;
        Sat, 09 Apr 2022 11:10:34 -0700 (PDT)
Received: from cloudflare.com ([2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id e11-20020a2e984b000000b00249b8b68f61sm2644717ljj.74.2022.04.09.11.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 11:10:34 -0700 (PDT)
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
Date:   Sat, 09 Apr 2022 19:04:05 +0200
In-reply-to: <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
Message-ID: <87fsmmp1pi.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 03:56 PM -07, Martin KaFai Lau wrote:
> On Thu, Apr 07, 2022 at 03:31:08PM -0700, Stanislav Fomichev wrote:
>> Previous patch adds 1:1 mapping between all 211 LSM hooks
>> and bpf_cgroup program array. Instead of reserving a slot per
>> possible hook, reserve 10 slots per cgroup for lsm programs.
>> Those slots are dynamically allocated on demand and reclaimed.
>> This still adds some bloat to the cgroup and brings us back to
>> roughly pre-cgroup_bpf_attach_type times.
>> 
>> It should be possible to eventually extend this idea to all hooks if
>> the memory consumption is unacceptable and shrink overall effective
>> programs array.
>> 
>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> ---
>>  include/linux/bpf-cgroup-defs.h |  4 +-
>>  include/linux/bpf_lsm.h         |  6 ---
>>  kernel/bpf/bpf_lsm.c            |  9 ++--
>>  kernel/bpf/cgroup.c             | 96 ++++++++++++++++++++++++++++-----
>>  4 files changed, 90 insertions(+), 25 deletions(-)
>> 
>> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
>> index 6c661b4df9fa..d42516e86b3a 100644
>> --- a/include/linux/bpf-cgroup-defs.h
>> +++ b/include/linux/bpf-cgroup-defs.h
>> @@ -10,7 +10,9 @@
>>  
>>  struct bpf_prog_array;
>>  
>> -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
>> +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
>> + */
>> +#define CGROUP_LSM_NUM 10
> hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> a static 211 (and potentially growing in the future) is not good either.
> I currently do not have a better idea also. :/
>
> Have you thought about other dynamic schemes or they would be too slow ?

As long as we're talking ideas - how about a 2-level lookup?

L1: 0..255 -> { 0..31, -1 }, where -1 is inactive cgroup_bp_attach_type
L2: 0..31 -> struct bpf_prog_array * for cgroup->bpf.effective[],
             struct hlist_head [^1]  for cgroup->bpf.progs[],
             u32                     for cgroup->bpf.flags[],

This way we could have 32 distinct _active_ attachment types for each
cgroup instance, to be shared among regular cgroup attach types and BPF
LSM attach types.

It is 9 extra slots in comparison to today, so if anyone has cgroups
that make use of all available attach types at the same time, we don't
break their setup.

The L1 lookup table would still a few slots for new cgroup [^2] or LSM
hooks:

  256 - 23 (cgroup attach types) - 211 (LSM hooks) = 22

Memory bloat:

 +256 B - L1 lookup table
 + 72 B - extra effective[] slots
 + 72 B - extra progs[] slots
 + 36 B - extra flags[] slots
 -184 B - savings from switching to hlist_head
 ------
 +252 B per cgroup instance

Total cgroup_bpf{} size change - 720 B -> 968 B.

WDYT?

[^1] It looks like we can easily switch from cgroup->bpf.progs[] from
     list_head to hlist_head and save some bytes!

     We only access the list tail in __cgroup_bpf_attach(). We can
     either iterate over the list and eat the cost there or push the new
     prog onto the front.

     I think we treat cgroup->bpf.progs[] everywhere like an unordered
     set. Except for __cgroup_bpf_query, where the user might notice the
     order change in the BPF_PROG_QUERY dump.

[^2] Unrelated, but we would like to propose a
     CGROUP_INET[46]_POST_CONNECT hook in the near future to make it
     easier to bind UDP sockets to 4-tuple without creating conflicts:

     https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-connectx/ebpf_connect4
 
[...]
