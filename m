Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE03C594A3
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfF1HON convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 03:14:13 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44692 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfF1HOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:14:12 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so9617571edr.11
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 00:14:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=NmaOpiJ9l1jI4HCBQvUD1z7O3VBPPhuaqBjfvioNh5g=;
        b=NeQw+vW91/FQhzqc/85XVDb6zY3BsoFZdaTnwEntpyU8G354f3wwW5OJdoXEIziATc
         1Yp+B11swKJ4iQ9af+orqnEHaK781PCYsenMxpDRfZaBtv37l067I2Buf3IJ213RFyw+
         m2uPLdDX7GHqlgOgU5XCpQ/atFFtpLvLEpqE/qS770tuzoACmDCGTAuKQrlZTCvukI0h
         jdhSO6E7dMviRX6O8yybz/xVTmvZ7p98HTEie/oBwomiC6GiztcAwt1/vLOyfiU4WaxX
         3Luyv1mzYf0yeXa3tShEOuVpEaO5ce7zqOJ4xZvwDJ06bpem/McW9tQQ9Q9Ev8/TAljk
         pdRA==
X-Gm-Message-State: APjAAAXgqw08uWeg7CDfOa1UPWhZunD3dBdrGB3b7uHND98wiUoyMsDw
        hUmpA0XM3+1UyMep3uz5tE2hVA==
X-Google-Smtp-Source: APXvYqy3jHp+s5Bz80KoxN5m1RFTeXtyIAX9MQpcV6lhBkHlV9W2m6m9AkJgxZ58aHFrVMYusFAtgQ==
X-Received: by 2002:a17:906:398:: with SMTP id b24mr7236064eja.78.1561706051056;
        Fri, 28 Jun 2019 00:14:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id n5sm283302ejc.62.2019.06.28.00.14.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 00:14:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5896B181CA7; Fri, 28 Jun 2019 09:14:09 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] devmap/cpumap: Use flush list instead of bitmap
In-Reply-To: <ff82dde7-8f31-1ab5-65b8-5e2d5ca5f680@iogearbox.net>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1> <156125626115.5209.3880071777007082264.stgit@alrua-x1> <ff82dde7-8f31-1ab5-65b8-5e2d5ca5f680@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Jun 2019 09:14:09 +0200
Message-ID: <877e969o72.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 06/23/2019 04:17 AM, Toke Høiland-Jørgensen wrote:
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> 
>> The socket map uses a linked list instead of a bitmap to keep track of
>> which entries to flush. Do the same for devmap and cpumap, as this means we
>> don't have to care about the map index when enqueueing things into the
>> map (and so we can cache the map lookup).
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> [...]
>> +static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx)
>>  {
>> +	struct bpf_cpu_map_entry *rcpu = bq->obj;
>>  	unsigned int processed = 0, drops = 0;
>>  	const int to_cpu = rcpu->cpu;
>>  	struct ptr_ring *q;
>> @@ -621,6 +630,9 @@ static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
>>  	bq->count = 0;
>>  	spin_unlock(&q->producer_lock);
>>  
>> +	__list_del(bq->flush_node.prev, bq->flush_node.next);
>> +	bq->flush_node.prev = NULL;
>
> Given this and below is a bit non-standard way of using list API, maybe add
> these as inline helpers to include/linux/list.h to make sure anyone changing
> list API semantics doesn't overlook these in future?

Sure, can do.

-Toke
