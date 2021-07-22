Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7E33D2D98
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 22:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhGVTnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 15:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhGVTnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 15:43:10 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AADC061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 13:23:45 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j2so1522wrx.9
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 13:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pDRzsfWNbIGxMOyGMfCCilb7XZdT846IuowuCU4dEF0=;
        b=Rcxa01wgsj9B0fVLSqmJnwHEcjScWIW8zXSqF2GzhCDTC3DA0Z1Mxk6bIuYCYeAtAN
         TuTjgAfh4ZYYqU58MmxnfSSEIaJb5mH/O4eP7K8x42MLuowL3VtvczPeY7fxoquSYB+l
         zZzCZh+z3vnCKEZqYwzlztWZ5EhlHj789LIHx/jFJ1VugIxGsuUn27AT/pVuXKwRvqGD
         Xi0AWA6Z63Y9TAUEwpd1GspPL//84FRiOTt9O3gVr11omcvYTVa+2rH7ITPaz4CxWWyU
         7pZmyJ+p9xABJzZ3TCLhWUrCitng9yvr0dWteV61ThfCC6fCyziw2h2Eesj4BGtQ5GRU
         NUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pDRzsfWNbIGxMOyGMfCCilb7XZdT846IuowuCU4dEF0=;
        b=A6dZ+zWFAA0gD8T/fbHSqYa2mndH8Mbd/KNl+h52JvcJEuFiGddcClWo2DHRmItI8a
         3Fb2VQ/QP6Y/304G4/lYwQuHq+t76yoykbMmeHP3WLLtQ8VXOfwVOF2nAn+hdJgT4QKi
         uiEpZ6kGPiggnShullQ6572ojEerVgcGgrhOeKl2zi7/Bt+/koppKc0K5kpT8+ST2o8r
         3goy2+VFJBucy/+GEX/KP33l9BXcI7zLtnGRQqI2kelQmB/7z3Gj8GiaG7n2x34sA1KN
         JXMStnxho2TblfUbuBNU0dtUHLGxhAGjVUDfIiTUtIO9asAV+grbh8MOXrJlyFHmRIq6
         48aw==
X-Gm-Message-State: AOAM531N0YN3IeF5B21UKA/qOg/7Zr6Znu/guchkOxnZGEIVJU4xG73l
        PAf07ZeGg25kgpxJpIBzoCc=
X-Google-Smtp-Source: ABdhPJwhYVXgPJAWS08IIetPM9lId5ud3Uo5DxHgFl0bklH6Kq8Z8fAOUZfg2VpA7YBrnbUmrUZrGg==
X-Received: by 2002:adf:d235:: with SMTP id k21mr1736681wrh.222.1626985423687;
        Thu, 22 Jul 2021 13:23:43 -0700 (PDT)
Received: from [192.168.1.28] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id y3sm31142636wrh.16.2021.07.22.13.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 13:23:43 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 02/36] iov_iter: DDP copy to iter/pages
To:     Christoph Hellwig <hch@infradead.org>,
        Boris Pismenny <borisp@nvidia.com>
Cc:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210722110325.371-1-borisp@nvidia.com>
 <20210722110325.371-3-borisp@nvidia.com> <YPlzHTnoxDinpOsP@infradead.org>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <6f7f96dc-f1e6-99d9-6ab4-920126615302@gmail.com>
Date:   Thu, 22 Jul 2021 23:23:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPlzHTnoxDinpOsP@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/07/2021 16:31, Christoph Hellwig wrote:
>> +#ifdef CONFIG_ULP_DDP
>> +size_t _ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
>> +#endif
>>  size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
>>  bool _copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i);
>>  size_t _copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i);
>> @@ -145,6 +148,16 @@ size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
>>  		return _copy_to_iter(addr, bytes, i);
>>  }
>>  
>> +#ifdef CONFIG_ULP_DDP
>> +static __always_inline __must_check
>> +size_t ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
>> +{
>> +	if (unlikely(!check_copy_size(addr, bytes, true)))
>> +		return 0;
>> +	return _ddp_copy_to_iter(addr, bytes, i);
>> +}
>> +#endif
> 
> There is no need to ifdef out externs with conditional implementations,
> or inlines using them.
> 
>> +#ifdef CONFIG_ULP_DDP
>> +static void ddp_memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
> 
> Overly long line.
> 
>> +	char *to = kmap_atomic(page);
>> +
>> +	if (to + offset != from)
>> +		memcpy(to + offset, from, len);
>> +
>> +	kunmap_atomic(to);
> 
> This looks completely bogus to any casual read, so please document why
> it makes sense.  And no, a magic, unexplained ddp in the name does not
> count as explanation at all.  Please think about a more useful name.

This routine, like other changes in this file, replicates the logic in
memcpy_to_page. The only difference is that "ddp" avoids copies when the
copy source and destinations buffers are one and the same. These are
then used by nvme-tcp (see skb_ddp_copy_datagram_iter in nvme-tcp) which
receives SKBs from the NIC that already placed data in its destination,
and this is the source for the name Direct Data Placement. I'd gladly
take suggestions for better names, but this is the best we came up with
so far.

The reason we are doing it is to avoid modifying memcpy_to_page itself,
but rather allow users (e.g., nvme-tcp) to access this functionality
directly.

> 
> Can this ever write to user page?  If yes it needs a flush_dcache_page.

Yes, will add.

> 
> Last but not least: kmap_atomic is deprecated except for the very
> rate use case where it is actually called from atomic context.  Please
> use kmap_local_page instead.
> 

Will look into it, thanks!

>> +#ifdef CONFIG_CRYPTO_HASH
>> +	struct ahash_request *hash = hashp;
>> +	struct scatterlist sg;
>> +	size_t copied;
>> +
>> +	copied = ddp_copy_to_iter(addr, bytes, i);
>> +	sg_init_one(&sg, addr, copied);
>> +	ahash_request_set_crypt(hash, &sg, NULL, copied);
>> +	crypto_ahash_update(hash);
>> +	return copied;
>> +#else
>> +	return 0;
>> +#endif
> 
> What is the point of this stub?  To me it looks extremely dangerous.
> 

As above, we use the same logic as in hash_and_copy_to_iter. The purpose
is again to eventually avoid the copy in case the source and destination
buffers are one and the same.
