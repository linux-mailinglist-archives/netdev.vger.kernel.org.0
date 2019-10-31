Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE00EB7F3
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbfJaT2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:28:07 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42876 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729347AbfJaT2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:28:07 -0400
Received: by mail-lj1-f194.google.com with SMTP id a21so7842343ljh.9
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 12:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TnCbq2000sgK9KKfW0a0I1LlWJLVNeCp1tHN1Di2rZ0=;
        b=K4WeBKfV4LVJUx9dWAsJXRPNV5GU2cS/3jB7ikEIQNTer3zdMFt55qG5Dv3SG0otQ2
         XgYvoxht5SxklhFM/+jjbxfv/50HS2Oa/WQ2lBh/qeNEIvyWWQnT3obeCZUsEaSTCLwp
         8BvACCPR4tHb1dtnWdgF7RweVv2ZNg7HD4Jl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TnCbq2000sgK9KKfW0a0I1LlWJLVNeCp1tHN1Di2rZ0=;
        b=m/9ynt6a3TAxhLu9Na7Vs8rc/PJIqOj0R6JL84Stp5T1fVukl5N6LpNiLUUtrhXMX0
         MgfJqm7sLX+RIUDKCljyg6Iksod/oxNKyDzTPyf66a7HlmnWZFidtSIiScblm0EVWSD1
         Sv+QwBMfySsxbzj9xQ4lsYsV/JqX4Pt0jXV2l5Sx0iJGVxiOdwnwXe04OoiiFNA97uju
         BJsA84+Apkg4UkMKJO4vX2cGU1qPjSJrhk0m9Hw+H39wOPiaZ68YXB91yUXAQIe5ylqE
         809j3bXsZUur6788gUDv4Ej6VOPx56NWPw5KIehtEDBa6aF2dpvqCNrhJoZcZ/SI8osO
         TdSQ==
X-Gm-Message-State: APjAAAXGEQ/tkZA8TXvufzh0mM6WdFkvQyTy8lnB1qDJHTPqqJQPlcYz
        5aOom0sI0CxzGyHqeJHPSBoo+g==
X-Google-Smtp-Source: APXvYqyUQ5kzEbBRvsqE0Zym867THLLJuL57Z2vzRG+u5rwex/Ypu4aDDFy0rYIsQ+5wxV2eJatiFw==
X-Received: by 2002:a2e:b5a2:: with SMTP id f2mr5300902ljn.108.1572550083554;
        Thu, 31 Oct 2019 12:28:03 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d27sm2432810lfb.3.2019.10.31.12.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 12:28:02 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] net: bridge: convert fdbs to use bitops
To:     Joe Perches <joe@perches.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
References: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
 <8e21b79c1adf5c3c4fb94c11fbe30371c4e96943.camel@perches.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <14ab24ad-e730-989a-db61-9cd377104a7a@cumulusnetworks.com>
Date:   Thu, 31 Oct 2019 21:28:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8e21b79c1adf5c3c4fb94c11fbe30371c4e96943.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/10/2019 20:37, Joe Perches wrote:
> On Tue, 2019-10-29 at 13:45 +0200, Nikolay Aleksandrov wrote:
>> Hi,
>> We'd like to have a well-defined behaviour when changing fdb flags. The
>> problem is that we've added new fields which are changed from all
>> contexts without any locking. We are aware of the bit test/change races
>> and these are fine (we can remove them later), but it is considered
>> undefined behaviour to change bitfields from multiple threads and also
>> on some architectures that can result in unexpected results,
>> specifically when all fields between the changed ones are also
>> bitfields. The conversion to bitops shows the intent clearly and
>> makes them use functions with well-defined behaviour in such cases.
>> There is no overhead for the fast-path, the bit changing functions are
>> used only in special cases when learning and in the slow path.
>> In addition this conversion allows us to simplify fdb flag handling and
>> avoid bugs for future bits (e.g. a forgetting to clear the new bit when
>> allocating a new fdb). All bridge selftests passed, also tried all of the
>> converted bits manually in a VM.
>>
>> Thanks,
>>  Nik
>>
>> Nikolay Aleksandrov (7):
>>   net: bridge: fdb: convert is_local to bitops
>>   net: bridge: fdb: convert is_static to bitops
>>   net: bridge: fdb: convert is_sticky to bitops
>>   net: bridge: fdb: convert added_by_user to bitops
>>   net: bridge: fdb: convert added_by_external_learn to use bitops
>>   net: bridge: fdb: convert offloaded to use bitops
>>   net: bridge: fdb: set flags directly in fdb_create
> 
> Wouldn't it be simpler to change all these bitfields to bool?
> 
> The next member is ____cachline_aligned_in_smp so it's not
> like the struct size matters or likely even changes.
> 

I guess it's just preference now, I'd prefer having 1 field which is well
packed and can contain more bits (and more are to come) instead of bunch
of bool or u8 fields which is a waste of space. We can set them together, it's more
compact and also the atomic bitops make it clear that these can change
without any locking. We're about to add new bits to these and it's nice
to have a clear understanding and well-defined API for them. Specifically
the test_and_set/clear_bit() can simplify code considerably.

> ---
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index ce2ab1..46d2f10 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -183,12 +183,12 @@ struct net_bridge_fdb_entry {
>  
>  	struct net_bridge_fdb_key	key;
>  	struct hlist_node		fdb_node;
> -	unsigned char			is_local:1,
> -					is_static:1,
> -					is_sticky:1,
> -					added_by_user:1,
> -					added_by_external_learn:1,
> -					offloaded:1;
> +	bool				is_local;
> +	bool				is_static;
> +	bool				is_sticky;
> +	bool				added_by_user;
> +	bool				added_by_external_learn;
> +	bool				offloaded;
>  
>  	/* write-heavy members should not affect lookups */
>  	unsigned long			updated ____cacheline_aligned_in_smp;
> 
> 

