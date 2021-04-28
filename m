Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B067C36D96A
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhD1OTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhD1OTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 10:19:19 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950B8C061573;
        Wed, 28 Apr 2021 07:18:33 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n127so22108544wmb.5;
        Wed, 28 Apr 2021 07:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sA44iSBVTRPE1/+y8eq3P54Y7wYSKijWIbljnB3TKwo=;
        b=WJ1sA+C+IeMDOgw3O7uaHmSvOd/BNDKf7ULbdIZ+JyfxDdJvzDuN4Ulpo3WKHUGYsD
         mLLePGcuFSLRm0HoScTdwxL0iRkSGr47TjzwojSmUzUm+9WT9er9KATD9UF01VRSTzHn
         a91kqkWAu0ulcYjUj2h19HIuxrE5u/3fDApdepMmScAGia+OsgwhuraIyS5qo5LbAqU/
         DfGSvMnBhI0KYLQZwb6qXFWIhxblKGlu3yJALsXvkQ2oRA3zacEa9Y9VCERzwQd049rB
         HP+h5S6U/T+FhLRZqkzTb0/ZsBoOVX1WKT87AVMmZKK5BMSeKe3QWENknEmzDhmOpXvQ
         e2cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sA44iSBVTRPE1/+y8eq3P54Y7wYSKijWIbljnB3TKwo=;
        b=YfJ2TOhWvbHgo1SGtQS7EvP+OiyrjjKb0giMUIL+cMVfqav0bcSX5uSM7wt39Kb5ve
         juQ8MUcaUL22//IiijStk0a9oqUlt2m7SZD1iqxosbILM6hCXSI8++Wmc6ZJ11Shculp
         4k0t5ygHtTb3teqEP9OX7WcyP7g1coEdtOWPGVl4knRRZJVu49nr7WH/pgm7o6ibtIAb
         uuT4L8gWWb3g4d29ilMx9CFbKaYGgr1a/NbWAQ3Q1zRKSnn8pAmKSyzhJtPDhJz1iey6
         VYzQXsQzSuJVv/XKBL59hbf415iWKSOyjuMS6pnoymmtPRnDA9bENowosOLEqcLabMvU
         XqpQ==
X-Gm-Message-State: AOAM5327dSr5OW0cV36U2du3Br0ZvxCuQsRZVXo6KcwXejqw3PLcKZjZ
        mhs+kYHiQJhaoON5wo9DzmWVD5QSJxM=
X-Google-Smtp-Source: ABdhPJyGVF4Ulrt4rBUjS5QW2tkc8y29t9BdZsE78bdd56ms63rAN06zlX9oGR97cNsFGxaEvUpJew==
X-Received: by 2002:a05:600c:4fd4:: with SMTP id o20mr4951276wmq.166.1619619512068;
        Wed, 28 Apr 2021 07:18:32 -0700 (PDT)
Received: from [192.168.1.102] ([37.168.62.78])
        by smtp.gmail.com with ESMTPSA id p10sm93896wre.84.2021.04.28.07.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:18:31 -0700 (PDT)
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Martin KaFai Lau <kafai@fb.com>, Jason Baron <jbaron@akamai.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210427034623.46528-1-kuniyu@amazon.co.jp>
 <a10fdca5-7772-6edb-cbe6-c3fe66f57391@akamai.com>
 <20210428012734.cbzie3ihf6fbx5kp@kafai-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2f4b2039-1144-f26f-4ee7-2fbec7eb415b@gmail.com>
Date:   Wed, 28 Apr 2021 16:18:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210428012734.cbzie3ihf6fbx5kp@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/21 3:27 AM, Martin KaFai Lau wrote:
> On Tue, Apr 27, 2021 at 12:38:58PM -0400, Jason Baron wrote:
>>
>>
>> On 4/26/21 11:46 PM, Kuniyuki Iwashima wrote:
>>> The SO_REUSEPORT option allows sockets to listen on the same port and to
>>> accept connections evenly. However, there is a defect in the current
>>> implementation [1]. When a SYN packet is received, the connection is tied
>>> to a listening socket. Accordingly, when the listener is closed, in-flight
>>> requests during the three-way handshake and child sockets in the accept
>>> queue are dropped even if other listeners on the same port could accept
>>> such connections.
>>>
>>> This situation can happen when various server management tools restart
>>> server (such as nginx) processes. For instance, when we change nginx
>>> configurations and restart it, it spins up new workers that respect the new
>>> configuration and closes all listeners on the old workers, resulting in the
>>> in-flight ACK of 3WHS is responded by RST.
>>
>> Hi Kuniyuki,
>>
>> I had implemented a different approach to this that I wanted to get your
>> thoughts about. The idea is to use unix sockets and SCM_RIGHTS to pass the
>> listen fd (or any other fd) around. Currently, if you have an 'old' webserver
>> that you want to replace with a 'new' webserver, you would need a separate
>> process to receive the listen fd and then have that process send the fd to
>> the new webserver, if they are not running con-currently. So instead what
>> I'm proposing is a 'delayed close' for a unix socket. That is, one could do:
>>
>> 1) bind unix socket with path '/sockets'
>> 2) sendmsg() the listen fd via the unix socket
>> 2) setsockopt() some 'timeout' on the unix socket (maybe 10 seconds or so)
>> 3) exit/close the old webserver and the listen socket
>> 4) start the new webserver
>> 5) create new unix socket and bind to '/sockets' (if has MAY_WRITE file permissions)
>> 6) recvmsg() the listen fd
>>
>> So the idea is that we set a timeout on the unix socket. If the new process
>> does not start and bind to the unix socket, it simply closes, thus releasing
>> the listen socket. However, if it does bind it can now call recvmsg() and
>> use the listen fd as normal. It can then simply continue to use the old listen
>> fds and/or create new ones and drain the old ones.
>>
>> Thus, the old and new webservers do not have to run concurrently. This doesn't
>> involve any changes to the tcp layer and can be used to pass any type of fd.
>> not sure if it's actually useful for anything else though.
> We also used to do tcp-listen(/udp) fd transfer because the new process can not
> bind to the same IP:PORT in the old kernel without SO_REUSEPORT.  Some of the
> services listen to many different IP:PORT(s).  Transferring all of them
> was ok-ish but the old and new process do not necessary listen to the same set
> of IP:PORT(s) (e.g. the config may have changed during restart) and it further
> complicates the fd transfer logic in the userspace.
> 
> It was then moved to SO_REUSEPORT.  The new process can create its listen fds
> without depending on the old process.  It pretty much starts as if there is
> no old process.  There is no need to transfer the fds, simplified the userspace
> logic.  The old and new process can work independently.  The old and new process
> still run concurrently for a brief time period to avoid service disruption.
> 


Note that another technique is to force syncookies during the switch of old/new servers.

echo 2 >/proc/sys/net/ipv4/tcp_syncookies

If there is interest, we could add a socket option to override the sysctl on a per-socket basis.

