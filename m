Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E663926AA
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhE0E7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:59:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234926AbhE0E7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 00:59:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622091455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9TjJw9KGtCuCxj8KF9tuDLAcF4memHbZbcsXiLsQ60Y=;
        b=eCW0dATm8HIUVD/qoWI+qa1FSUI6EyusQhs/Ug5uEYpVLbE3OPOKf/umCHBN2iKSI6XmGi
        YFU0aJqUCu5NLXfnReB/oxDmXIYIWduqHy43jtwNJoD7shn+UKp68pMol/uOf8t8vrmpJg
        byni9peiiy/pHnQYPRsYdTcGDZMrHMs=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-ZJMbc8riMtKpeBlqlp3guA-1; Thu, 27 May 2021 00:57:34 -0400
X-MC-Unique: ZJMbc8riMtKpeBlqlp3guA-1
Received: by mail-pg1-f198.google.com with SMTP id 139-20020a6304910000b029021636f6732aso2215249pge.17
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 21:57:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9TjJw9KGtCuCxj8KF9tuDLAcF4memHbZbcsXiLsQ60Y=;
        b=MuvhpBdDXRvc5p3JBAkS8TLf29ynaL0ajdH5WdRB8XtSIIALq+/mfCH9ggADBcg/cd
         fXwkgBjc2olM3CXTxYJ7puvnHo3+OPkbxHEzVAfBb+nB6Y6tfO21aqpj+RVK0l5FUy4i
         yIQW/g8aBg4YdJvIaIzO+J4I1jMy6jUYEil64m4+vVnu+WF8XnRQYetcQWoAAcecoCa5
         HS3XJtkaLAwti2UawJnX3QEGlHH6hznmxuMqQTCWV7nP5/BXNKFDZ4c7v4cBjC9HmZBW
         mN1f8opBM614OfIOUilT9PRhTZ+Q3r0uB9g4I1UCusrPGImBiVOciMbJshSyhj9fccl2
         ICtA==
X-Gm-Message-State: AOAM533XKzZWBqdvvV7PoCK4q081FZ1ZkVNOsz4r0A4K+HF9NZ2ge8cz
        dnGn4MCd3hUL9SzOIFPnCWPwxvUO2zlX3fgglz91xBjH54tlij+54xqJPQAN3AAn2oebH3cOKOJ
        MRuWmhcWgI4zD76oQ
X-Received: by 2002:a05:6a00:1591:b029:2d9:369a:b846 with SMTP id u17-20020a056a001591b02902d9369ab846mr2011865pfk.40.1622091452646;
        Wed, 26 May 2021 21:57:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZ06zfd32JsDIIzvqDhTQvD40ohKU+eSYyOmUxGbj1h9eqyTFh3zTO8G9qAEfawOTlSc96DQ==
X-Received: by 2002:a05:6a00:1591:b029:2d9:369a:b846 with SMTP id u17-20020a056a001591b02902d9369ab846mr2011842pfk.40.1622091452384;
        Wed, 26 May 2021 21:57:32 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l192sm746205pfd.173.2021.05.26.21.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 21:57:31 -0700 (PDT)
Subject: Re: [PATCH net-next] ptr_ring: make __ptr_ring_empty() checking more
 reliable
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     will@kernel.org, peterz@infradead.org, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mst@redhat.com, brouer@redhat.com
References: <1622032173-11883-1-git-send-email-linyunsheng@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d2287691-1ef9-d2c4-13f6-2baf7b80d905@redhat.com>
Date:   Thu, 27 May 2021 12:57:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1622032173-11883-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/26 ÏÂÎç8:29, Yunsheng Lin Ð´µÀ:
> Currently r->queue[] is cleared after r->consumer_head is moved
> forward, which makes the __ptr_ring_empty() checking called in
> page_pool_refill_alloc_cache() unreliable if the checking is done
> after the r->queue clearing and before the consumer_head moving
> forward.
>
> Move the r->queue[] clearing after consumer_head moving forward
> to make __ptr_ring_empty() checking more reliable.


If I understand this correctly, this can only happens if you run 
__ptr_ring_empty() in parallel with ptr_ring_discard_one().

I think those two needs to be serialized. Or did I miss anything?

Thanks


>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>   include/linux/ptr_ring.h | 26 +++++++++++++++++---------
>   1 file changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> index 808f9d3..f32f052 100644
> --- a/include/linux/ptr_ring.h
> +++ b/include/linux/ptr_ring.h
> @@ -261,8 +261,7 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>   	/* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
>   	 * to work correctly.
>   	 */
> -	int consumer_head = r->consumer_head;
> -	int head = consumer_head++;
> +	int consumer_head = r->consumer_head + 1;
>   
>   	/* Once we have processed enough entries invalidate them in
>   	 * the ring all at once so producer can reuse their space in the ring.
> @@ -271,19 +270,28 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>   	 */
>   	if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
>   		     consumer_head >= r->size)) {
> +		int tail = r->consumer_tail;
> +		int head = consumer_head;
> +
> +		if (unlikely(consumer_head >= r->size)) {
> +			r->consumer_tail = 0;
> +			WRITE_ONCE(r->consumer_head, 0);
> +		} else {
> +			r->consumer_tail = consumer_head;
> +			WRITE_ONCE(r->consumer_head, consumer_head);
> +		}
> +
>   		/* Zero out entries in the reverse order: this way we touch the
>   		 * cache line that producer might currently be reading the last;
>   		 * producer won't make progress and touch other cache lines
>   		 * besides the first one until we write out all entries.
>   		 */
> -		while (likely(head >= r->consumer_tail))
> -			r->queue[head--] = NULL;
> -		r->consumer_tail = consumer_head;
> -	}
> -	if (unlikely(consumer_head >= r->size)) {
> -		consumer_head = 0;
> -		r->consumer_tail = 0;
> +		while (likely(--head >= tail))
> +			r->queue[head] = NULL;
> +
> +		return;
>   	}
> +
>   	/* matching READ_ONCE in __ptr_ring_empty for lockless tests */
>   	WRITE_ONCE(r->consumer_head, consumer_head);
>   }

