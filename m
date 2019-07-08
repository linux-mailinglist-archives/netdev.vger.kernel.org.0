Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E119621CE
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733242AbfGHPT3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jul 2019 11:19:29 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37137 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733214AbfGHPT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:19:27 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so14922275eds.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 08:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=YH2YgQGgRu8ORoAWuJ0OHSKOvcsTEoBnLl5Pmi6dTOg=;
        b=iKf48pH7zcuQAkD1LkGwYAOFpvG5LbjycrTVxCQAFvDtlGMXn8zuHoG3dXHf7+uLlS
         64gvCTNY5fz6IGx+EH/VQiJu3jLsqTpPHg4sw1gjsAfwVXmMjHBqbKT+aVvI5VHau4GV
         v1utiTM1M3HwTMSNVblXl9IsLpElwUkJ87q8Wm5JkdfGfCoFBCiZZD8bmQx8ss3bhYeb
         d6SUNhHLI6iVs6XjVkv2X5ayZnY6cKxkGZjq/BjAaiA4qMhpfZL3zWpk5MFnbhrAiDnA
         PYMpLJvF0g0mY5sxkP3KvXPvWHkfwaIBnu7nXqDXXcjtxAvT21XlhnIch+qfcTinKP64
         Pizw==
X-Gm-Message-State: APjAAAWYHX8T2yS/IVhoRz092RuWgoRZg0+zNwNzlVYMjiD1tQVZm6Op
        HEmNfl9IwOpH/FdebVZ/8d9XsA==
X-Google-Smtp-Source: APXvYqwmOI9gYG+tjkxAHIY10UIEZxmmcGhEdzs18AVPrgGMaKQvwJafmCKn2hYnjLW2KO2zItdUHg==
X-Received: by 2002:a17:906:d052:: with SMTP id bo18mr16562174ejb.311.1562599164941;
        Mon, 08 Jul 2019 08:19:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id y3sm5419806edr.27.2019.07.08.08.19.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 08:19:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B71B0181CE7; Mon,  8 Jul 2019 17:19:23 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jonathan Lemon <jlemon@flugsvamp.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next 2/3] xdp: Refactor devmap allocation code for reuse
In-Reply-To: <A2ABED10-8475-4878-93DF-F16D106FC33D@flugsvamp.com>
References: <156234940798.2378.9008707939063611210.stgit@alrua-x1> <156234940841.2378.6629890565300526702.stgit@alrua-x1> <A2ABED10-8475-4878-93DF-F16D106FC33D@flugsvamp.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 08 Jul 2019 17:19:23 +0200
Message-ID: <87ef30zh8k.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jonathan Lemon" <jlemon@flugsvamp.com> writes:

> On 5 Jul 2019, at 10:56, Toke Høiland-Jørgensen wrote:
>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> The subsequent patch to add a new devmap sub-type can re-use much of 
>> the
>> initialisation and allocation code, so refactor it into separate 
>> functions.
>>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>  kernel/bpf/devmap.c |  137 
>> +++++++++++++++++++++++++++++++--------------------
>>  1 file changed, 84 insertions(+), 53 deletions(-)
>>
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index d83cf8ccc872..a2fe16362129 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -60,7 +60,7 @@ struct xdp_bulk_queue {
>>  struct bpf_dtab_netdev {
>>  	struct net_device *dev; /* must be first member, due to tracepoint 
>> */
>>  	struct bpf_dtab *dtab;
>> -	unsigned int bit;
>> +	unsigned int idx; /* keep track of map index for tracepoint */
>>  	struct xdp_bulk_queue __percpu *bulkq;
>>  	struct rcu_head rcu;
>>  };
>> @@ -75,28 +75,22 @@ struct bpf_dtab {
>>  static DEFINE_SPINLOCK(dev_map_lock);
>>  static LIST_HEAD(dev_map_list);
>>
>> -static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
>> +static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr 
>> *attr,
>> +			    bool check_memlock)
>
> This check_memlock parameter appears to be unused.

Ah yes, good catch! That was left over from when the patch set also
contained the "default map" stuff. Will fix.

-Toke
