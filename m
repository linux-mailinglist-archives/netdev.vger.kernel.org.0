Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AA82E0D99
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 17:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgLVQ5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 11:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbgLVQ5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 11:57:25 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D872C0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 08:56:45 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id d20so12514173otl.3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 08:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c5lpnq8f4m8C48I2U05aP6/lzHvCNt8Al3Z21qBvhuU=;
        b=BV26B3AEyONshCIUv4By7QMNPivMX6MjL9eyPPv3qSaaI8VtCJAQuTJLEGPGUorh9r
         evbzxTHRw2jf4ol/6Vjq8M5rrT9wJ1bBior/fnN2gCmx8DMVPAOWXR6CXrF3GFpBndUf
         CCsPFSYVVa+GJ4HmtWveE2UzB9H0JlxtTEbLUrHZzT5kraBF4k20sh/qqRAt5vYmKhoE
         whXhU8CaQd0cuS+2YjjD3mChzopOMGMVFuVfHSr9tOsGoEcYzrwsWKILRrbTp7L3uZlB
         8Xv9XVgayMeFPjGtASDYLWQDI4oUJrZIElBMyZKmzJa3L9+R9uNPuvgILoGovYqiF/Bi
         Uqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c5lpnq8f4m8C48I2U05aP6/lzHvCNt8Al3Z21qBvhuU=;
        b=E1PALBpOcZaC7gjmgkhhiWxJv7yxo/N8I1UKFhEu09s2B+JYdRgv+V8xYs61cdgJRY
         +Lg5XxwMiGKhaNwyPwo/Bm2DaMuQs9WrnK2FrnSeDICd152fohhxIKcdD+o5RnHqw75i
         OusnlNEgIZ+lX27UzPz/pVnrnkzWzmxuyoT9IkvYf+fgraWYGlzNkuVuLOHp/MLrVYMK
         a3nY3y9neepFzgxHL1SaEP8FXglJ0NQ5ujzRmfCetVdfTIFxNi7hYLyxndh/e+uiMEVZ
         FJJW94U9C1+Sy1Jbey2MxihDGVyExfD3ZWrzZqLZq980UK6/5fIi7RO5DX4yIxeNoBRH
         pfpg==
X-Gm-Message-State: AOAM5302eH/gpKM18hc4cZDP9En+hJxb1Yvobnmx6/gE9x9ABHbdtlSB
        qphf0HcSHPmso9FFpdtcaR2kLJcp6fA=
X-Google-Smtp-Source: ABdhPJzscRzVww1cvXkz7vHrcLZqQk2qT3EzrMwJ2/tcPRVRtr7sYStLUhjK3RH8/fNNmEI6Nyv9PQ==
X-Received: by 2002:a9d:2248:: with SMTP id o66mr1296396ota.236.1608656204386;
        Tue, 22 Dec 2020 08:56:44 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:84d8:b3da:d879:3ea8])
        by smtp.googlemail.com with ESMTPSA id x20sm4465528oov.33.2020.12.22.08.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 08:56:43 -0800 (PST)
Subject: Re: [PATCH 03/12 v2 RFC] skbuff: simplify sock_zerocopy_put
From:   David Ahern <dsahern@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        edumazet@google.com, willemdebruijn.kernel@gmail.com
Cc:     kernel-team@fb.com
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-4-jonathan.lemon@gmail.com>
 <aefbc3aa-c538-1948-3a3a-a6d4456c829b@gmail.com>
Message-ID: <88a4e130-c726-2782-6d9a-093e326c38b2@gmail.com>
Date:   Tue, 22 Dec 2020 09:56:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <aefbc3aa-c538-1948-3a3a-a6d4456c829b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/22/20 9:52 AM, David Ahern wrote:
> On 12/21/20 5:09 PM, Jonathan Lemon wrote:
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 327ee8938f78..ea32b3414ad6 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -1245,12 +1245,8 @@ EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
>>  
>>  void sock_zerocopy_put(struct ubuf_info *uarg)
>>  {
>> -	if (uarg && refcount_dec_and_test(&uarg->refcnt)) {
>> -		if (uarg->callback)
>> -			uarg->callback(uarg, uarg->zerocopy);
>> -		else
>> -			consume_skb(skb_from_uarg(uarg));
>> -	}
>> +	if (uarg && refcount_dec_and_test(&uarg->refcnt))
>> +		uarg->callback(uarg, uarg->zerocopy);
>>  }
>>  EXPORT_SYMBOL_GPL(sock_zerocopy_put);
>>  
>>
> 
> since it is down to 2 lines, move to skbuff.h as an inline?
> 

nm. that is done in patch 5.
