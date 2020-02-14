Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B50E15F9C7
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 23:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgBNWah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 17:30:37 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46944 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgBNWag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 17:30:36 -0500
Received: by mail-pf1-f193.google.com with SMTP id k29so5520751pfp.13
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 14:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yCl8JYqCQ0ZRdvZ9qSFM44dK9YmNfursd24TTY4kjAM=;
        b=AEgAfA1RzkVRS5tWEo0GR3u3zzW8Yl1qH4FzVXjRD2NzPLE86ymZxL8/zUPwcK/hr/
         3ltWjdYuZP2vXA3S6rOTETvlPuXS+Pn9XjSZBGCco1wzjaPuuSO+TXShchKx6M197ODE
         IJOqcpUeeNL8CXqyPRIZLjjVL+T0KdWZHvwZIdqTrZ2QZ+eGDbfxLVIn34XCCQBJrnms
         lGUQ2mocbZ6ZpnhMb0OSRm5HoWhjQLHxHc3gXXUiPtN9m7axgaMSEMxZfJNQ/bmVZzIz
         wxxv5pcP2vPlxqEeesFHvaYKEm9LWEQ5wuAsPS3+3lek9Ofo+RFsaLdsrnJ5xu3mXyou
         P+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yCl8JYqCQ0ZRdvZ9qSFM44dK9YmNfursd24TTY4kjAM=;
        b=H+UWHSFo9GXjbXPsH88+Ub61GG5kp7AkaXTXMMS2VT10LLgskL1P2iUNhRG0hctZrs
         HRtGhJFSa4Woj2WHH9YM3jApD4dU5WT3uQ8bg1rhF0cH479mwYH0a84SqiYdQRwnlQuC
         8P0NJbCtV+BfJ2r744Ooajkdq8SsSlp989RwYUjpQx3GMydTA2VEcv2AMKusNIIHz5PB
         7g3j8Mc3HsJJFIJQOcanrlrK0lVUejGrExGfuDaJ+GQl+WIyBnZyMll+CcdLa5+cS7/N
         GlAMHPx52e6DdcZIFdWYaooQo+fPUCwbYfUfMZLw7g59kGXDZJ3lOOo9RP8sbzlwFRF6
         VRiA==
X-Gm-Message-State: APjAAAVK4UYxUa4iz6Tj6lXS+01JvZE6lAYPMyj2le6jqhoIx59s+nX1
        Hbkz/k+wzTgINEIe9djilGoJRzmY
X-Google-Smtp-Source: APXvYqyJmVlIqTUNZLdLCd8VdnVPiMCGLHigNw5a/mACvNNPqviVEvs8m2dLp7wfNlDEe7uK5+AIzA==
X-Received: by 2002:a63:3308:: with SMTP id z8mr5645636pgz.230.1581719435752;
        Fri, 14 Feb 2020 14:30:35 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id b3sm8001784pft.73.2020.02.14.14.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 14:30:34 -0800 (PST)
Subject: Re: [PATCH v2 net 3/3] wireguard: send: account for mtu=0 devices
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
References: <20200214173407.52521-1-Jason@zx2c4.com>
 <20200214173407.52521-4-Jason@zx2c4.com>
 <135ffa7a-f06a-80e3-4412-17457b202c77@gmail.com>
 <CAHmME9pjLfscZ-b0YFsOoKMcENRh4Ld1rfiTTzzHmt+OxOzdjA@mail.gmail.com>
 <e20d0c52-cb83-224d-7507-b53c5c4a5b69@gmail.com>
 <CAHmME9oXfDCGmsCJJEuaPmgj7_U4yfrBoqi0wRZrOD9SdWny_w@mail.gmail.com>
 <ec52e8cb-5649-9167-bb14-7e9775c6a8be@gmail.com>
 <CAHmME9r6gTCV8cpPgyjOVMWCbRJtswzqXMYBqTQmo001AZz05Q@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1b132351-d4a7-851c-ac98-0a48c8d90797@gmail.com>
Date:   Fri, 14 Feb 2020 14:30:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAHmME9r6gTCV8cpPgyjOVMWCbRJtswzqXMYBqTQmo001AZz05Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/20 1:57 PM, Jason A. Donenfeld wrote:

> 
> Thanks, I appreciate your scrutiny here. Right again, you are. It
> looks like that was added in 2017 after observing the pattern in other
> drivers and seeing the documentation comment, "Wait for packets
> currently being received to be done." That sounds like an important
> thing to do before tearing down a socket. But here it makes no sense
> at all, since synchronize_net() is just a wrapper around
> synchronize_rcu() (and sometimes _expedited). And here, the
> synchronize_rcu() usage makes sense to have, since this is as boring
> of an rcu pattern as can be:
> 
> mutex_lock()
> old = rcu_dereference_protected(x->y)
> rcu_assign(x->y, new)
> mutex_unlock()
> synchronize_rcu()
> free_it(old)
> 
> Straight out of the documentation. Having the extra synchronize_net()
> in there adds nothing at all. I'll send a v3 of this 5.6-rc2 cleanup
> series containing that removal.
> 

Also note that UDP sockets have SOCK_RCU_FREE flag set, so core
networking also respect one RCU grace period before freeing them.

It is possible that no extra synchronize_{net|rcu}() call is needed,
but this is left as an exercise for future kernels :)

