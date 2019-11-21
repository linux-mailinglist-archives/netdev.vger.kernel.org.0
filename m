Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0289E1048D8
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 04:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfKUDM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 22:12:27 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45034 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKUDM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 22:12:27 -0500
Received: by mail-pg1-f193.google.com with SMTP id e6so813383pgi.11
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 19:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JZi4IaZO+YxD33BP/6pj/4Z8CMim+aUeaQ/P3ef6vOg=;
        b=ImHwd4gT4wYdLSlNNxFLQ0j3Hx6z8sfLV2HdypJCUAlf4jTRtMHdze1XsIM4tQPub/
         NdAQ81Jlz0SRJsM5nEDA8sep6bp5GY/ZGHJXSOXxB/lZmg42MJ0/xM7PXnoz6SF3WUt4
         SpE43xD6+cAPfXK1VAjGZG8RrD5u9OFT0LqJl20e9bMdXoRS06cF7kaBZK/cSRJidY5Z
         6YKarAZgCsKKr08vMgNu7bD3VwOG/kr7e0rdbTNqi18nEZSoj4EZ2xA0Hooi3xqWRaoF
         Ry0r/924tFYtPt+XzgqRu0ygigUyK+VSSRBWswB3YqmrBjeQsA4ZG2mhSfeUheQ9PEu+
         CeqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JZi4IaZO+YxD33BP/6pj/4Z8CMim+aUeaQ/P3ef6vOg=;
        b=olzNfPpHAPdyKvtDxHxrU+zP0S4RZoxDyiV9DxlkJqqNY8/oKZww2uUA2jmEmKysnk
         hmUWPadvgbVRT0sfmsn1OqwdrZJ+ft0ekGdv2wwjwWO6oQEsCNiO6p1LakBY4EmuoWXf
         O1j331z70hmV5PuMRIbmCSSp169oLHarxqyEljYjmWD77kg+MhjCJNH/sx2x+Ov/X/MV
         OVnNsHNxci49UslkHgKhNjOBjdPdyHuRWRv3RsMwZjyisi6xffz29YCD71C2NmnfsELV
         Ocqy5odr1O8zxxFw0Eie5OGFu1CpCvITmxJUUWRf0pEHOANLSlSbkaTZ6Q9LKbMAC7PZ
         4iKw==
X-Gm-Message-State: APjAAAVTIs+cNW15unx41QUkp9xh6lbWOU3QKj3fi7VKeqAyMQv92cnj
        Lj7sZOs6QCtkoicgkQuNGhI=
X-Google-Smtp-Source: APXvYqywVqPIGxNo6fuFu6FvIxk9iYalvMysWFx2mZXKg+zy0gCRsYckEAy+/R//J6SQj4kTA5jDFw==
X-Received: by 2002:a63:77c4:: with SMTP id s187mr6883692pgc.304.1574305946640;
        Wed, 20 Nov 2019 19:12:26 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 13sm637176pgu.53.2019.11.20.19.12.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 19:12:25 -0800 (PST)
Subject: Re: [PATCH] net-sysfs: Fix reference count leak in
 rx|netdev_queue_add_kobject
To:     David Miller <davem@davemloft.net>, jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, lukas.bulwahn@gmail.com
References: <20191120070816.12893-1-jouni.hogander@unikie.com>
 <20191120.121013.1898975725512803153.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ff662def-67dc-8e54-80eb-cfe7a98767ae@gmail.com>
Date:   Wed, 20 Nov 2019 19:12:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120.121013.1898975725512803153.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/19 12:10 PM, David Miller wrote:
> From: jouni.hogander@unikie.com
> Date: Wed, 20 Nov 2019 09:08:16 +0200
> 
>> From: Jouni Hogander <jouni.hogander@unikie.com>
>>
>> kobject_init_and_add takes reference even when it fails. This has
>> to be given up by the caller in error handling. Otherwise memory
>> allocated by kobject_init_and_add is never freed. Originally found
>> by Syzkaller:
>>
>> BUG: memory leak
>  ...
>> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Applied, thank you.
> 

I am late to the party, sorry.

But I do not see a Fixes: tag, and the patch seems buggy.

I question how it was really tested ? Please Jouni share your drugs :)

I would rather see this stuff for net-next, because whatever memory leak
we had for years has not raised serious concerns.

I will submit this fix, I guess...

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4f404bf33e44c977c1a8ba00706817b76215b75c..ae3bcb1540ec57df311dac6847323a23a74ec960 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1474,6 +1474,7 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 #endif
 
        kobject_uevent(kobj, KOBJ_ADD);
+       return 0;
 
 err:
        kobject_put(kobj);

	 
