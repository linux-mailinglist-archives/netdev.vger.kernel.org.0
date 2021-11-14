Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C11144FC7D
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 00:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhKNX5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 18:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhKNX5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 18:57:15 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98476C061746
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 15:54:20 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 200so13033898pga.1
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 15:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1FPcrKXn5v0SnMCEZaBgTW6y30Qu4G6XAqp6/ZFFzM8=;
        b=Rs4UBjXBVi7WnIuUnT9RwPAQyPylhbXY7MuIKb7nmibkLgeDaaZBKtv+GBj1twPvmJ
         rCnnikzl3sGXwuhiF6k+mrZJbxwOSrlNv7evLZzY4/IdclAVtI4n+Xbl7+Et5y/QyUDQ
         ZOjzqHK2523ECPWDGwIbbKCBmwOZ78qPp2AiVT7K1O4ur4VZ+KLMB+fmL2Vm1AUD6bRL
         KaGLXCvx5dwxUt2PKdVHNVkiGj6Mguxzro6t0p27KbdHAsKqmoR4Y610aaQAkBqYuzOQ
         ip1491YcHG/ASMP2m2JgPd6NuyZMUHV0bd03/yWZT04NI/q5mcVWLVt0MobxIgKrsccn
         oggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1FPcrKXn5v0SnMCEZaBgTW6y30Qu4G6XAqp6/ZFFzM8=;
        b=WorL5+T8n1kScf6PddbZlTmQc+KKzGCZoHNOl07sB/pyvF58wPTn2Hc6lXsULcQd3B
         +RCGWQZjTWxGi5mRroJASFs3wz6KaE9Bf/JTDd71qer9MX/nkUTOd04uOLFlLA9/aC04
         VPQgqbxIMNL3bIfpbaJpRI1RQLVWsPaOAfjRia2U1orf+YFzqOw/2n7uMGagh20kbPmB
         6oyM3Nz7JH39CZuUBwrRMDSmAHk9uwVqlhPzImAzC868XU7q/sxvlKW2VJve5/HR3vqo
         fKkfCCWTb0FXTyQyMW3az59a7ScBNakXW30EAj3TwaEEidZJBYo0PiI81QhBTYlD64Zt
         7mYA==
X-Gm-Message-State: AOAM533fciqG6g9FnhV3dmaxVSK6sPsnHRsCdfaMDBozyvaSyun+ijGd
        kzv0QhnYvKX24ZJkgPo81Xye2cH+bjs=
X-Google-Smtp-Source: ABdhPJxQUmY/SUp4VH36Hty60dfP3OQC1HAFy2lasqrhhw1LwSRYEjY1LTUid5dFiYzh7GNNGCKW1g==
X-Received: by 2002:a05:6a00:a14:b0:4a0:945:16fa with SMTP id p20-20020a056a000a1400b004a0094516famr29538690pfh.9.1636934059755;
        Sun, 14 Nov 2021 15:54:19 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p2sm10458320pja.55.2021.11.14.15.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 15:54:19 -0800 (PST)
Subject: Re: [PATCH] sock: fix /proc/net/sockstat underflow in sk_clone_lock()
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
References: <20211114060222.3370-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <ee46d850-7dcb-b9d5-b61c-56638fa2f9ae@gmail.com>
 <51c40730-5b75-fe91-560b-4c4ec4974c83@i-love.sakura.ne.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <17179d2c-8dd2-216f-9c32-0f37ddd78cfa@gmail.com>
Date:   Sun, 14 Nov 2021 15:54:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <51c40730-5b75-fe91-560b-4c4ec4974c83@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/14/21 2:43 PM, Tetsuo Handa wrote:
> On 2021/11/15 5:01, Eric Dumazet wrote:
>> On 11/13/21 10:02 PM, Tetsuo Handa wrote:
>>> sk_clone_lock() needs to call get_net() and sock_inuse_inc() together, or
> 
> s/sock_inuse_inc/sock_inuse_add/
> 
>>> socket_seq_show() will underflow when __sk_free() from sk_free() from
>>> sk_free_unlock_clone() is called.
>>>
>>
>> IMO, a "sock_inuse_get() underflow" is a very different problem,
> 
> Yes, a different problem. I found this problem while trying to examine
> https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed where
> somebody might be failing to call get_net() or we might be failing to
> make sure that all timers are synchronously stopped before put_net().
> 
>> I suspect this should be fixed with the following patch.
> 
> My patch addresses a permanent underflow problem which remains as long as
> that namespace exists. Your patch addresses a temporal underflow problem
> which happens due to calculating the sum without locks. Therefore, we can
> apply both patches if we want.
> 

I think your changelog is a bit confusing.

It would really help if you add the Fixes: tag, because if you do

1) It makes the patch much easier to understand, by reading again the the old patch.

2) We can tell if we can merge both fixes in the same submission (if they share the same bug origin)

Thanks !

