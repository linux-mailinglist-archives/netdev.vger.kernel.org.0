Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC2E313DE58
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 16:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgAPPMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 10:12:54 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33878 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgAPPMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 10:12:53 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so10042365pgf.1;
        Thu, 16 Jan 2020 07:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=umv9beinPPdR7oTlGs1whE/3lML77Q/Kt2Jyq+HV7DA=;
        b=vH/LJb7AaPc4aD9UJCeA9LweH3nTuF3/zy3RA+L9mrSPaoTIz/VhQUtwSP2bwID4Y/
         ugqKwW040tGzfzrb2CqQcQ7heJJinJCffZDEYYQT8Pq7Tp+ohanFDD7P7GRGLyRveQGR
         1ctsNoEUmmCwdkxIIRhXovErGw5Ob1hsWAlzGAQ2yZGE60WFChRx2jP1hJecw0sSi7HO
         SYXCJAGtDDRqUb6adoF1PNTgMZyCjjKA4cvZZNOJ2j1iTx1UK2TDGIyXBbOSir97xe3o
         g5xqW/kBTsXfvz8dpjI5Yv+Dhf2A6WgfQ73SNemNma+Aq0PMLe65SOekSQrg3u3pLbYa
         1S3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=umv9beinPPdR7oTlGs1whE/3lML77Q/Kt2Jyq+HV7DA=;
        b=f8gY+yZnp0QbK2b9juwRVMD2n/Rzd9eluXQX+RC8y7FeWV81B4BMizqcq6Zs6crqEN
         yHwa1aeJzQcYN6HC20uBxzUV/s8tpZZagS8nkUtIY4Y1f0Oi1f3awdvvRfrw/m2cWasY
         duLTPCL/OoL5fICLWDN/DTdgpc66RtYHz5xbi8caDTbz4xBmvz5wjkN4Xaa6tYfShme7
         8LUAWeh5Wc3mxW/v9XZW3C8Z1UsMPWl5MZg+dkZyOS7Wq/KkZ0HHewKqMapIegfH4KzK
         zxnMm1LatOm0vmtlC7xJnXQipsL89sMHKwZrY8ikCkS1BPEVd/3KGkAjNm3YLmuxKwWl
         ZOAQ==
X-Gm-Message-State: APjAAAXqnarVWqruSG72ca4DvoAf5monxxvc3c3/Q+ETT6CuZGqr61NC
        Iq2OKrUOHujB/dlOeEtHwF4=
X-Google-Smtp-Source: APXvYqwcEz2L4zCJ8EqgoxMNOwCPhZpJp3E5cqx5s7SNcavaIu+fjzuZroiokKwJxCC4lc1VE3MRvA==
X-Received: by 2002:a62:296:: with SMTP id 144mr38163784pfc.120.1579187573172;
        Thu, 16 Jan 2020 07:12:53 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p28sm25157336pgb.93.2020.01.16.07.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 07:12:52 -0800 (PST)
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
To:     David Miller <davem@davemloft.net>, zhangshaokun@hisilicon.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jinyuqi@huawei.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        edumazet@google.com, guoyang2@huawei.com
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
Date:   Thu, 16 Jan 2020 07:12:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200116.042722.153124126288244814.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/16/20 4:27 AM, David Miller wrote:
> From: Shaokun Zhang <zhangshaokun@hisilicon.com>
> Date: Wed, 15 Jan 2020 11:23:40 +0800
> 
>> From: Yuqi Jin <jinyuqi@huawei.com>
>>
>> atomic_try_cmpxchg is called instead of atomic_cmpxchg that can reduce
>> the access number of the global variable @p_id in the loop. Let's
>> optimize it for performance.
>>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Yang Guo <guoyang2@huawei.com>
>> Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> 
> I doubt this makes any measurable improvement in performance.
> 
> If you can document a specific measurable improvement under
> a useful set of circumstances for real usage, then put those
> details into the commit message and resubmit.
> 
> Otherwise, I'm not applying this, sorry.
> 


Real difference that could be made here is to 
only use this cmpxchg() dance for CONFIG_UBSAN

When CONFIG_UBSAN is not set, atomic_add_return() is just fine.

(Supposedly UBSAN should not warn about that either, but this depends on compiler version)

 
