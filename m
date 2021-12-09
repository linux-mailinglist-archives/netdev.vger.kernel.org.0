Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6485246EC76
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240722AbhLIQFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:05:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240565AbhLIQFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:05:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639065729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1HkMwGUSLzSpEkF6yTy3MllG932xksHPg1EKQ//z4ek=;
        b=Yt74PB8jL170Yam+OG5DFQng755YHSFzBRn6/05rpi9phpQcCF403JxHZZgTISW6kWOH/k
        1Jk+wxLQUTaO1Y02KWAVxpv7JES6CNZBHpib0+Suuel6iitdfPkPI072NZrnw7O7umZO21
        GvL5PjeEtWtky5cB64Nig4Q5DEDNWdk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-5MAKZ0cDNd2G0IycDg-_4w-1; Thu, 09 Dec 2021 11:02:08 -0500
X-MC-Unique: 5MAKZ0cDNd2G0IycDg-_4w-1
Received: by mail-ed1-f71.google.com with SMTP id v22-20020a50a456000000b003e7cbfe3dfeso5658976edb.11
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 08:02:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1HkMwGUSLzSpEkF6yTy3MllG932xksHPg1EKQ//z4ek=;
        b=ggIvH6cMW/KZnTM/YGOTJLClvGh01pHIxxO3g2s7f8Oco9O5aZEhg+PqFa5cEm9s2S
         kkRizMIx7vZ11fqyJickAPciEg7AaZvdKbMUB/yFxAhMLfcQ6yq/bsyyKkP1nxZbgoVu
         FREp6FwD3ngToGbYt42C+lGacd1FC1FPp7vhKzwgwFRAoQ3oc1G9JkhrPjsPI2cWWh1D
         zHbjTSmoLcQgxok1rgKqXBFPdlhkKEWrYnJk6XYp4YoFNcAaT8SV5RPXvji5ZADwygpJ
         FP7Jh8U9R3D7PgMFx7HtrXv80lBcSKbxGqF9hVW1bh+ip3a3M/txkfpDOIHtv7iB7TKS
         3HbA==
X-Gm-Message-State: AOAM5304xc0C7ODka7samP0KhKODBilUSbA3S1bT+le7Q6dBH0d4jVfA
        qDMt78uUAWVRw0/R4ScmFk/jvaA+E9tMWNUWq+zQ3iyupADGzztpnj8JI3oOBWU9UtnUor9W92Q
        sqFgPWH7J9mGPs3te
X-Received: by 2002:a05:6402:1292:: with SMTP id w18mr29991083edv.46.1639065720969;
        Thu, 09 Dec 2021 08:02:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwe+6roGeOOO9pQCDglWWGKyk6lJOhnyfnE3Kissr7dFE7pyUHoYF7URLruw9+/XBdDKKT4A==
X-Received: by 2002:a05:6402:1292:: with SMTP id w18mr29991046edv.46.1639065720672;
        Thu, 09 Dec 2021 08:02:00 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g15sm148774ejt.10.2021.12.09.08.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 08:02:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7077F180471; Thu,  9 Dec 2021 17:01:59 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: RE: [PATCH bpf-next 1/8] page_pool: Add callback to init pages when
 they are allocated
In-Reply-To: <61b131f0a4c18_97957208ad@john.notmuch>
References: <20211202000232.380824-1-toke@redhat.com>
 <20211202000232.380824-2-toke@redhat.com>
 <61b131f0a4c18_97957208ad@john.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 09 Dec 2021 17:01:59 +0100
Message-ID: <87zgp9wyvc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Add a new callback function to page_pool that, if set, will be called ev=
ery
>> time a new page is allocated. This will be used from bpf_test_run() to
>> initialise the page data with the data provided by userspace when running
>> XDP programs with redirect turned on.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> LGTM.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
>
>>  include/net/page_pool.h | 2 ++
>>  net/core/page_pool.c    | 2 ++
>>  2 files changed, 4 insertions(+)
>>=20
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index 3855f069627f..a71201854c41 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -80,6 +80,8 @@ struct page_pool_params {
>>  	enum dma_data_direction dma_dir; /* DMA mapping direction */
>>  	unsigned int	max_len; /* max DMA sync memory size */
>>  	unsigned int	offset;  /* DMA addr offset */
>> +	void (*init_callback)(struct page *page, void *arg);
>> +	void *init_arg;
>>  };
>>=20=20
>>  struct page_pool {
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 9b60e4301a44..fb5a90b9d574 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -219,6 +219,8 @@ static void page_pool_set_pp_info(struct page_pool *=
pool,
>>  {
>>  	page->pp =3D pool;
>>  	page->pp_magic |=3D PP_SIGNATURE;
>> +	if (unlikely(pool->p.init_callback))
>> +		pool->p.init_callback(page, pool->p.init_arg);
>
> already in slow path right? So unlikely in a slow path should not
> have any impact on performance is my reading.

Yeah, fair point, may have gone a little overboard on the "minimise
impact to existing code" here - will drop.

-Toke

