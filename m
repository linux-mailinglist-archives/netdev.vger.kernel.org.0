Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325FD44D4AE
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 11:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhKKKI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 05:08:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232699AbhKKKI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 05:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636625169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jl6i9Vg5MH/D47qfgpp1++mvVXS5mXYZyKefeF00ENM=;
        b=LQ8JCNJ/CZqx0sebwqzD2aufSpRh06bracHLkCbf6AAb7xldb1TlZr90AG1406ZP+fon99
        zBl2njf/yswV8czAA3ZJbD9y6pPIcH1OL8lI9pAQ+1ddGO+dSICH8UFHUY5g5fZTozRNSp
        BDpYpz7Rw+NiPr2UOIqvkXApTEq14f4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-TPVDj1ZtME24f5p01_kTyw-1; Thu, 11 Nov 2021 05:06:07 -0500
X-MC-Unique: TPVDj1ZtME24f5p01_kTyw-1
Received: by mail-wm1-f72.google.com with SMTP id o22-20020a1c7516000000b0030d6f9c7f5fso2479830wmc.1
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 02:06:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=jl6i9Vg5MH/D47qfgpp1++mvVXS5mXYZyKefeF00ENM=;
        b=MCDJ/TG4CmbOeUQluShEMvd0PWiYJqm2ygVeb8raap8s3Anv8U5acIL3WA24Pk99sp
         7M5V5arhx2osUB3pQKS2+VzbRbpsFqv7ouaYnga6lv5gD0JSjiCOESbMPV5onA6tkjrb
         O74d4aLcZtvoRMWXALPVkrZU2xqh3GucBwaILAE+1U/BnnAV6h2gh3+aDFES0+WrgnI3
         7cpt3JAZmD+WrSyYUS24nQRM/I033sE+lFGCxYkZF3jui17s8Kd1YauJSF82+LKhFxYB
         N22HPJmfRAAInJwd1d8ULtcfk7Nju1w8Us35jPB0G2WTgK9w5xUqa62KiNAn0GKwTAFg
         8pVA==
X-Gm-Message-State: AOAM531oUIGGs1Et4ftESCF/C5EsvVYPb8bcOe7M/wPHts+mu+jeeOhc
        G+QnSZkcsk2MMKKB8kdSKDs2vR8PH3NzZtsSg+hiCbD2g+IGAwk9RnU6CfgX+d6tOrOCijReGHQ
        T2d9/HvfuP1HHhe3G
X-Received: by 2002:adf:ef52:: with SMTP id c18mr7576522wrp.162.1636625166581;
        Thu, 11 Nov 2021 02:06:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsepfx71+Xyqb2g2FyILt7HhfvGVM2Y27qZ2ME6eL9iigsTPlV6uU5mw6Ulj3j6sBKopzmZQ==
X-Received: by 2002:adf:ef52:: with SMTP id c18mr7576497wrp.162.1636625166404;
        Thu, 11 Nov 2021 02:06:06 -0800 (PST)
Received: from [192.168.3.132] (p4ff23ee8.dip0.t-ipconnect.de. [79.242.62.232])
        by smtp.gmail.com with ESMTPSA id l15sm2324926wme.47.2021.11.11.02.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 02:06:05 -0800 (PST)
Message-ID: <b495d38d-5cdd-8a33-b9d3-de721095ccab@redhat.com>
Date:   Thu, 11 Nov 2021 11:06:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/7] fs/binfmt_elf: use get_task_comm instead of
 open-coded string copy
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
 <20211108083840.4627-5-laoar.shao@gmail.com>
 <a13c0541-59a3-6561-6d42-b51fef9f7c8b@redhat.com>
Organization: Red Hat
In-Reply-To: <a13c0541-59a3-6561-6d42-b51fef9f7c8b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.11.21 11:03, David Hildenbrand wrote:
> On 08.11.21 09:38, Yafang Shao wrote:
>> It is better to use get_task_comm() instead of the open coded string
>> copy as we do in other places.
>>
>> struct elf_prpsinfo is used to dump the task information in userspace
>> coredump or kernel vmcore. Below is the verfication of vmcore,
>>
>> crash> ps
>>    PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
>>       0      0   0  ffffffff9d21a940  RU   0.0       0      0  [swapper/0]
>>>     0      0   1  ffffa09e40f85e80  RU   0.0       0      0  [swapper/1]
>>>     0      0   2  ffffa09e40f81f80  RU   0.0       0      0  [swapper/2]
>>>     0      0   3  ffffa09e40f83f00  RU   0.0       0      0  [swapper/3]
>>>     0      0   4  ffffa09e40f80000  RU   0.0       0      0  [swapper/4]
>>>     0      0   5  ffffa09e40f89f80  RU   0.0       0      0  [swapper/5]
>>       0      0   6  ffffa09e40f8bf00  RU   0.0       0      0  [swapper/6]
>>>     0      0   7  ffffa09e40f88000  RU   0.0       0      0  [swapper/7]
>>>     0      0   8  ffffa09e40f8de80  RU   0.0       0      0  [swapper/8]
>>>     0      0   9  ffffa09e40f95e80  RU   0.0       0      0  [swapper/9]
>>>     0      0  10  ffffa09e40f91f80  RU   0.0       0      0  [swapper/10]
>>>     0      0  11  ffffa09e40f93f00  RU   0.0       0      0  [swapper/11]
>>>     0      0  12  ffffa09e40f90000  RU   0.0       0      0  [swapper/12]
>>>     0      0  13  ffffa09e40f9bf00  RU   0.0       0      0  [swapper/13]
>>>     0      0  14  ffffa09e40f98000  RU   0.0       0      0  [swapper/14]
>>>     0      0  15  ffffa09e40f9de80  RU   0.0       0      0  [swapper/15]
>>
>> It works well as expected.
>>
>> Suggested-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
>> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Petr Mladek <pmladek@suse.com>
>> ---
>>  fs/binfmt_elf.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>> index a813b70f594e..138956fd4a88 100644
>> --- a/fs/binfmt_elf.c
>> +++ b/fs/binfmt_elf.c
>> @@ -1572,7 +1572,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
>>  	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
>>  	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
>>  	rcu_read_unlock();
>> -	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
>> +	get_task_comm(psinfo->pr_fname, p);
>>  
>>  	return 0;
>>  }
>>
> 
> We have a hard-coded "pr_fname[16]" as well, not sure if we want to
> adjust that to use TASK_COMM_LEN?

But if the intention is to chance TASK_COMM_LEN later, we might want to
keep that unchanged.

(replacing the 16 by a define might still be a good idea, similar to how
it's done for ELF_PRARGSZ, but just a thought)


-- 
Thanks,

David / dhildenb

