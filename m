Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B9623C8F9
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 11:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgHEJQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 05:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbgHEJO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 05:14:29 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3BBC0617A2
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 02:14:28 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id df16so15626664edb.9
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 02:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XlU4kIXTL0y90kRWkeZfjXyK6xzPMe7WZqwaZ+XBuOk=;
        b=x6ShoXul3eWI8uNid2pE/cCPE7yTG95rNJqg4NxfktmQCjQgvWd0OEckhRq0xHvyO+
         5xH9SVddkOJEDZVp/5dTTi6IjhU5tgx/lLvnC/jitTgj4fzCyXAnerymRudykzw05bHR
         GOxeE/OOsDY5FASvdxTx6LtcRKnys+BYuHuvzPNuj/fJM79dHOq2UkMsTXc0D9xK6Usl
         93SEkB67MocG48yt0G435nMdRHc2nFxQf/XNGhTAY6fI8gsVpHLbDkuYWMwYGJarO4T3
         l1W6pLT6QE7xO3GimIWhHj3gtLv5jLjabnO363ekw12uCZrDa2NexBxexLz0YsaMOCKg
         21Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XlU4kIXTL0y90kRWkeZfjXyK6xzPMe7WZqwaZ+XBuOk=;
        b=djSV5SalRY6f2i8xIlKQfVrX7xg4WbFl8MtsEvrBPwkhBclfFU1LwhRxmx0sq+y31A
         /UWyo2pj0MGu01Rsf+kfYWkP3cjSNeOHZlCY5hMFDoFHj61x6PpQ8vAS4SpTTqax1Ro7
         8JXLpe+pW1JKmON/748pcCH4llL8lVBqj3dULgN+s11ptub5pyYpLognZJDivWXOVy53
         GDVExYXmtosah4/aqZ6DYoPw0ZCmGRwZ4vVG3vgW9mCxZ4vNHiZ+lGBMBqGQNcV/frfU
         gad3zGEz0xXgkvpDxZ7LpnBshZfcaywobi86rhvS8D7hvdIQiEKLtEQaDfDUdaO4kRn7
         SeQA==
X-Gm-Message-State: AOAM530bQX6X9fDXY41F5eY0cl2hQ5ZW6PI/KbkcEUQYLxLMKN7TvmNw
        By7CqCd0GHzcfd+S4JJ49rzb7A==
X-Google-Smtp-Source: ABdhPJyPaQ6e31rbWiMs4n8yhdWhPNZ7zNJ34Hw1xkamRHVn2hkNeEzyhCJpQyKCBh6wFAOD75yuuQ==
X-Received: by 2002:aa7:d1c6:: with SMTP id g6mr1950024edp.232.1596618867522;
        Wed, 05 Aug 2020 02:14:27 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id rs5sm1117832ejb.44.2020.08.05.02.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 02:14:26 -0700 (PDT)
Subject: Re: [PATCH net] mptcp: be careful on subflow creation
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>
References: <61e82de664dffde9ff445ed6f776d6809b198693.1596558566.git.pabeni@redhat.com>
 <4f2a74b9-d728-fa76-7b0f-f70c256077ee@tessares.net>
 <e197f22c62d4f1b78cee4f8a2a9b55a6bc807ede.camel@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <6fa22193-b14d-e006-9128-aa2c77ca6147@tessares.net>
Date:   Wed, 5 Aug 2020 11:14:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e197f22c62d4f1b78cee4f8a2a9b55a6bc807ede.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 05/08/2020 11:10, Paolo Abeni wrote:
> On Tue, 2020-08-04 at 21:25 +0200, Matthieu Baerts wrote:
>> Hi Paolo,
>>
>> On 04/08/2020 18:31, Paolo Abeni wrote:
>>> Nicolas reported the following oops:
>>
>> (...)
>>
>>> on some unconventional configuration.
>>>
>>> The MPTCP protocol is trying to create a subflow for an
>>> unaccepted server socket. That is allowed by the RFC, even
>>> if subflow creation will likely fail.
>>> Unaccepted sockets have still a NULL sk_socket field,
>>> avoid the issue by failing earlier.
>>>
>>> Reported-and-tested-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
>>> Fixes: 7d14b0d2b9b3 ("mptcp: set correct vfs info for subflows")
>>
>> Thank you for the patch, the addition in the code looks very good to me!
>>
>> But are you sure the commit you mention introduces the issue you fix here?
> 
> AFAICS, the oops can be observed only with the mentioned commit - which
> unconditioanlly de-reference a NULL sk->sk_socket. [try to] create a
> subflow on server unaccepted socket is not a bug per-se, so I would not
> send the fix to older trees.

Sorry, my bad, I didn't see that in the mentioned commit, we were using 
sk->sk_socket without checking if it was not NULL...
Thank you for pointing that to me!

Bad idea to review patches on the evening :)

The patch is then good to go to me!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
