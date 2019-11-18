Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A214CFFD4D
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 04:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKRDWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 22:22:50 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33595 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfKRDWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 22:22:50 -0500
Received: by mail-pg1-f193.google.com with SMTP id h27so8937364pgn.0;
        Sun, 17 Nov 2019 19:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=leAkEv51t4eJyYoGlCrW4N4M5OthipZ9Iq1DcQhvnMw=;
        b=uBIfyzTaFkGmG4mIRWMg2aZwioi7reUgRiN5jVjUcRQFtcJ5wX3K9HaVtV+IeEEp5U
         tzQ8i7gIxVhEHfEpkHgObDBbiwnbyI7cqstrJm0aL0VskoUAbm9i4+j/Bt0mcDR4Q4cv
         dku1ctA0GB7TZbUCp+38p/icpr4okGjqaT2iXtpQyT4RbEH56draUYgQS3UNXbBOvwgI
         kSEjC3Y2omRP3e+htBNy+2/hoTi1qtp8CvQL0B3aEgSHjoJEQBS8+owiG4UiAPWFt8TA
         MWpvSpyif4mEA+2wpxX0jMDpwAm7JNgYXmkyXp91Ml45nZwFU1D2KP8eUz5hUUGSjPrc
         +pvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=leAkEv51t4eJyYoGlCrW4N4M5OthipZ9Iq1DcQhvnMw=;
        b=i9MOolqg8XO7LGvHTrk1syB/9DFU66MmebqXqVs4kK6+uMfYhqLtcVCq4YKDkPwIgI
         KE6G2hBfcrIEelRYqvCgLHhcLSWiuXF7t2qkMk+RAy3Yoll04n4Z98kfrhilb/MugCI2
         jcUqhkAwp+cMkXKqiNi/Hof8tL/1Hcm2aMnts0SKSyZFs6acehRJewshRJFOc0zKclO/
         kGL6K/q5WE2jd+7EYAkQRmqAkoTaXoY6+ijY1xVkVSI8C6YG40IFG8oaAXbr5Myx2I0F
         6iG35E7jTSyo8gsi073MYDWDUyshWZFo9wcSAzfjNLF0Oblec78gSu9fm7jvnyTajrSi
         E7Jw==
X-Gm-Message-State: APjAAAXTXd8W1EPxmh0BzFy20YtxPckKL4Sbyjm/9oYLfRyGpPFaN/td
        Iocz0nqFpUVEQRzP2cvzs9A=
X-Google-Smtp-Source: APXvYqzl3S+PYebJzZmwvmcdv3/1hICFN6KZRUbNJ2CdmhG8qiXc6TFrsLSo9nYv8Trr2KMSZ1fzCA==
X-Received: by 2002:a62:31c1:: with SMTP id x184mr31929066pfx.255.1574047369805;
        Sun, 17 Nov 2019 19:22:49 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:bd88:fb6d:6b19:f7d1])
        by smtp.googlemail.com with ESMTPSA id w4sm9830pjt.21.2019.11.17.19.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Nov 2019 19:22:49 -0800 (PST)
Subject: Re: [PATCH] vrf: Fix possible NULL pointer oops when delete nic
To:     "wangxiaogang (F)" <wangxiaogang3@huawei.com>, dsahern@kernel.org,
        shrijeet@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hujunwei4@huawei.com, xuhanbing@huawei.com,
        Taehee Yoo <ap420073@gmail.com>
References: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
 <fde95f03-72ee-b4e9-7f14-b98e3227f0f4@gmail.com>
 <517baa2a-2c42-7790-e225-02d22c5ed90b@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e908c58d-4bab-4b96-be3f-7e5d589b2050@gmail.com>
Date:   Sun, 17 Nov 2019 20:22:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <517baa2a-2c42-7790-e225-02d22c5ed90b@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/19 8:15 PM, wangxiaogang (F) wrote:
> 
> 
> On 2019/11/15 21:14, David Ahern wrote:
>> On 11/14/19 11:22 PM, wangxiaogang (F) wrote:
>>> From: XiaoGang Wang <wangxiaogang3@huawei.com>
>>>
>>> Recently we get a crash when access illegal address (0xc0),
>>> which will occasionally appear when deleting a physical NIC with vrf.
>>>
>>
>> How long have you been running this test?
>>
>> I am wondering if this is fallout from the recent adjacency changes in
>> commits 5343da4c1742 through f3b0a18bb6cb.
>>
>>
>>
>>
>>
> Thank you so much for the reply, our kernel version is linux 4.19.
> this problem happened once in our production environment.
> 

ok, so the recent adjacency changes would not be at fault here.
