Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A145B1DA885
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 05:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgETDSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 23:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbgETDSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 23:18:23 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D12EC061A0E;
        Tue, 19 May 2020 20:18:23 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 23so882859pfy.8;
        Tue, 19 May 2020 20:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5WJmSfBCJ9T93UY4usILNY67jnm3iHHEW+ii4uy79rA=;
        b=a2zFSYje3WXYsySWDH3RMzx0U5fYPGVj7Rjb2+WGbvq9lB/IA44wj2HOVze+8NAk3h
         SpAjRZAlMqacFIWLp+DW/APzTrI8A1ULtaTXVZHDpw9gGa92kstm3VcyO8bS14b7j+LU
         +nFXjmLiKaih88zLlkBG/dynHppeDHoC8gvWlKuSZI3o8sqovnTYpAXC7D8TPEElKE+u
         wa8IFA0UqUKMwTWdu1HgUUD6lYRkS1PYwkqtJv8oQ1j1DAjOcRCXeGWqTrp6WTE3cI46
         /IcdnToawUSE/JzvU7KfdbbRd0QNm8QAWXMfHpNXvzSkPCufefKttAWVk0spAUlZcCko
         MIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5WJmSfBCJ9T93UY4usILNY67jnm3iHHEW+ii4uy79rA=;
        b=EKRCpQm5fCjH3ci9R0yA4VgyB1EvmI9dnpbPCSNi7c/ZLk8wf0jlZygN5/yfnKn9lN
         ZRnuYqT00WGB6Uw2eAMrQDNCEQQVdP7OCiyyxtro1CC/vWG6FgiuYvFCLXmwZ0HcaA7S
         Z5u+2Fmr3vwY9GczvY1TM2oJcJ55cmegHTFgNjAgh4cj88g9yC4zQFHUPz2obPYCZwVW
         gS/Yb23tycKSiJjGu6tRKzuLzorCAg6U5+gg2p8NhIWLw18ZwqTFcoQpswvbj4F+8DTO
         3y4BnZDGnjB6IludobiaU9FqmD2qqITcobinB+RUhvLLx5+F9eyOmv8Y1vnM0mEWvxOB
         2UEA==
X-Gm-Message-State: AOAM530tHfamjI552yF4kJpjPa+INQlMpHOjFknHLVanGI51l4UkVm6P
        ljr/0RAjC6wAQKRpv564/oMKJdmr
X-Google-Smtp-Source: ABdhPJwkjDvodLcK7vqo6B6/QVUPQqLUzmdpLFumoYrm8ZpWi1hAKBksPhhb1C5gHePDo5HU2zAmyg==
X-Received: by 2002:a63:c58:: with SMTP id 24mr2226622pgm.246.1589944702433;
        Tue, 19 May 2020 20:18:22 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n205sm733624pfd.50.2020.05.19.20.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 20:18:21 -0700 (PDT)
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of a
 seqcount
To:     David Miller <davem@davemloft.net>, tglx@linutronix.de
Cc:     stephen@networkplumber.org, a.darwish@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        paulmck@kernel.org, bigeasy@linutronix.de, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
References: <87v9kr5zt7.fsf@nanos.tec.linutronix.de>
 <20200519161141.5fbab730@hermes.lan> <87lfln5w61.fsf@nanos.tec.linutronix.de>
 <20200519.195722.1091264300612213554.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <886041df-d889-3d88-59fe-e190d15f9c98@gmail.com>
Date:   Tue, 19 May 2020 20:18:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200519.195722.1091264300612213554.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/20 7:57 PM, David Miller wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 20 May 2020 01:42:30 +0200
> 
>> Stephen Hemminger <stephen@networkplumber.org> writes:
>>> On Wed, 20 May 2020 00:23:48 +0200
>>> Thomas Gleixner <tglx@linutronix.de> wrote:
>>>> No. We did not. -ENOTESTCASE
>>>
>>> Please try, it isn't that hard..
>>>
>>> # time for ((i=0;i<1000;i++)); do ip li add dev dummy$i type dummy; done
>>>
>>> real	0m17.002s
>>> user	0m1.064s
>>> sys	0m0.375s
>>
>> And that solves the incorrectness of the current code in which way?
> 
> You mentioned that there wasn't a test case, he gave you one to try.
> 

I do not think this would ever use device rename, nor netdev_get_name()

None of this stuff is fast path really.

# time for ((i=1;i<1000;i++)); do ip li add dev dummy$i type dummy; done

real	0m1.127s
user	0m0.270s
sys	0m1.039s
