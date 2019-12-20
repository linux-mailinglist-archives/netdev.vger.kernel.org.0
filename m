Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD8E127C08
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 14:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLTNyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 08:54:13 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:41351 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbfLTNyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 08:54:12 -0500
Received: by mail-io1-f67.google.com with SMTP id c16so5875899ioo.8
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 05:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cgytD78FRHMpVR07lVHdXHDp7d3fIsIaVIOtC1GfChA=;
        b=srLBMCUG5LrZHAQ6N8QKzaPKbo6tAQbhGsmRFigsMnpPpAHy5s/foc2/URZxQVZdqK
         t9OQkIZ4/4Vb49ha+6K1qDfK422fIYTbR9PZVE0zjceG3FAqQnPUAqIceqmBzI90xQAx
         gzMkn1ay/UjGV376KT0nHUR3/dT3sc62xwsWldApjYhpaBxs8M31l2AL6XOoGFyKDI0v
         8uLXW/0wcFKwb6Nuwn3xhQtSgx0icIM7784QaqRLIl3uhlkPLeLBmF1wWQ+YlnggcpNV
         GEyr08GSdjriDqQgyWf4Pw4yVqpZ0uyapMExGkRFL2Q2PsQkcm98P+SRWSrMZ20pKCAW
         4Vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cgytD78FRHMpVR07lVHdXHDp7d3fIsIaVIOtC1GfChA=;
        b=ev0V6HxSyGnPIQgrrk/eOqJMH3PJEdUgMxiloc62J65oU1NwF/i/m+9xrZrvbxq4/2
         3nU8yZLZqkBaLvqJzM9W2rIV6zNnLXZjaI6LzFZhp+70DuoLAXifJ05z44WzGg9XWXIp
         B71Vg63tnHBhldmn+7j2HkQ3UXVgIXNx3jK5jYhSUBG7TAmV3vacdO0LVSEwsibehtx8
         BhBz/ZmVKzk6Qvz+L1pjM6VwsSNambDkCAry5wffxH99p/IGAeUE8xevGbOrj/wzARJl
         SI3OqmsvEjgKITY5vJuqdU1y7JyzxGiQyva8BlghKhU504FvMdLfk8H+ei1kdLlNb+J/
         Qz5Q==
X-Gm-Message-State: APjAAAUf9k1zFvgA+OR5Pttw1lFuCs7MgQA4uU8TZtZiI3KUGU/fnIgV
        okVgElxPc0T6MQFYAs0iZyuOsQ==
X-Google-Smtp-Source: APXvYqzpa93wbr1qHXEjhaYJ188wjPx5K7DK7CRdw8UTP3GU/qH9L4ETT99JfT3FJ0al0ANHzTphSg==
X-Received: by 2002:a02:3090:: with SMTP id q138mr12272515jaq.23.1576850051454;
        Fri, 20 Dec 2019 05:54:11 -0800 (PST)
Received: from [192.168.0.125] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id x25sm1012318iol.6.2019.12.20.05.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 05:54:10 -0800 (PST)
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
To:     Davide Caratti <dcaratti@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Roman Mashak <mrv@mojatatu.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
 <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
 <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
 <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
 <vbfr2102swb.fsf@mellanox.com>
 <63fe479d-51cd-eff4-eb13-f0211f694366@mojatatu.com>
 <vbfpngk2r9a.fsf@mellanox.com> <vbfo8w42qt2.fsf@mellanox.com>
 <3bbe208c56d4b6cf3526f4957b19f87d695d5d0a.camel@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <424b6532-377c-1fcf-f0a8-e9efdbae8740@mojatatu.com>
Date:   Fri, 20 Dec 2019 08:54:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3bbe208c56d4b6cf3526f4957b19f87d695d5d0a.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-20 8:21 a.m., Davide Caratti wrote:
> hi Jamal and Vlad,
> 
> thanks a lot for sharing your thoughts.
> 
> On Thu, 2019-12-19 at 17:01 +0000, Vlad Buslov wrote:
>>>> IMO that would be a cleaner fix give walk() is used for other
>>>> operations and this is a core cls issue.

> I tried forcing an error in matchall, and didn't observe this problem:
> 
> [root@f31 ~]# perf record -e probe:mall_change__return -agR -- tc filter add dev dam0 parent root matchall skip_sw action drop
> RTNETLINK answers: Operation not supported
> We have an error talking to the kernel
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 1.225 MB perf.data (1 samples) ]
> [root@f31 ~]# perf script
> tc 115241 [002] 19665.372130: probe:mall_change__return: (ffffffffc115f930 <- ffffffffb98a7266) ret=0xffffffa1
>          ffffffffb9066790 kretprobe_trampoline+0x0 (vmlinux)
>              7fa64c16cb77 __libc_sendmsg+0x17 (/usr/lib64/libc-2.30.so)
> 
> [root@f31 ~]# tc filter show dev dam0
> [root@f31 ~]#
> 
> and similar test can be also carried for the other classifiers
> (on unpatched kernel), so it should be easy to understand if there are
> other filter that show the same problem.
> 

I think this one works because of the simpler walk().
In the corner cases you caught u32 is more complex. It would create
multiple tp and so the list would not appear empty.

>> BTW another approach would be to extend ops with new callback
>> delete_empty(), require unlocked implementation to define it and move
>> functionality of tcf_proto_check_delete() there. Such approach would
>> remove the need for (ab)using ops->walk() for this since internally
>> in classifier implementation there is always a way to correctly verify
>> that classifier instance is empty. Don't know which approach is better
>> in this case.
> 
> I like the idea of using walk() only when filters are dumped, and handling
> the check for empty filters on deletion with a separate callback. That
> would allow de-refcounting the filter in the error path unconditionally
> for   all classifiers, like old kernel was doing, unless the classifier
> implements its own "check empty" function.
> 
> how does it sound?

Agreed.
Note: my comment on other email was also to consider using
TCF_PROTO_OPS_DOIT_UNLOCKED for obvious cases.

cheers,
jamal
