Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C6CCA15B
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfJCPuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:50:18 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46297 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfJCPuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:50:18 -0400
Received: by mail-pg1-f195.google.com with SMTP id a3so1991575pgm.13
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 08:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=46b+iIgwwlx3THIAGpZkHGpAt6JbX+mXIn7LIcKAMTU=;
        b=JLNUFvx9hZZS5DECXn/Prg7pfpj147xAsb964z/uot5s7d/Q11QYbTx+Bth6sgUf+y
         VB+O9nLU97lEV7X/yi9WYUKU/1BWVS74Y9SJNE5vEM7nmOYoLUOB9SPozM2aZikv8pem
         p7H/r7UE7gIhnzKe11ScbWnYaKVCpv7me6nf+lQFJ5FQUSrkZbDulk8Cq3RvWEtXgq1/
         dDOk8Ba1ZFVWZvFaD74lABbVmCOz4/OlOs5Xy3aOqKg2ZAiboSYWktyDmBSmXSWRWEVH
         NTdFgTgo4S5eT5qBE+6U7ui3ABSWFdThc79wqXGpvVrivmuMsEYbWzedQu+tx68/weOB
         3/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=46b+iIgwwlx3THIAGpZkHGpAt6JbX+mXIn7LIcKAMTU=;
        b=VzrJOOB/EFHux2Tp+XmLwjckZRpRRFA2/tDIZcHP0UC0wZFrCLy7/+gOXW9EZ6ChFV
         4ulgy/PZKzvljTOurfViMNNB0zz9jtgb9zQYcECHWpgPtZkFiNnLVY1t+Iz30pAPwC0u
         kN3PF1PK1AUg+BEgxX3mJ+6TaP9oP11KbUB+dMKDhX6Vb05B8nJqHCC1eKVv9G4S1v/H
         Xlx/Ue57jFrSr1BPQksZC1uOaMqhqLPiAzQUIqLUOup2BYhFIFHMpIgIkOPgZiP0v9J5
         bCbIx5q3OL0kTvntAOpc/ViFLcPeOZN+AJRpfhHDh2SUuIyRsFBaEan/qLbG/OI66XUx
         HG1A==
X-Gm-Message-State: APjAAAUNft4s9F+RlxaeH+KWH8PY7pmbj4VTU7q4AevoLY0LYpd+ON3w
        zbwSrRqm7o5MtcfqWX7LLWk=
X-Google-Smtp-Source: APXvYqzEyOXrLR8WDHwGO9brcNUJntCsealKdZZQQbX9iS7ZPXdYj3rNxTWHlQfG2AqmL1CZiGe/fg==
X-Received: by 2002:aa7:8d8a:: with SMTP id i10mr11646766pfr.45.1570117817508;
        Thu, 03 Oct 2019 08:50:17 -0700 (PDT)
Received: from [172.27.227.195] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id a11sm4817003pfg.94.2019.10.03.08.50.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 08:50:16 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4c896029-882f-1a4f-c0cc-4553a9429da3@gmail.com>
Date:   Thu, 3 Oct 2019 09:50:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 3:23 PM, Eric Dumazet wrote:
> 
> 
> On 10/2/19 2:08 PM, Eric Dumazet wrote:
>>
>>
>> On 10/1/19 11:18 AM, Eric Dumazet wrote:
>>>
>>>
>>> On 9/30/19 8:28 PM, David Ahern wrote:
>>>> From: David Ahern <dsahern@gmail.com>
>>>>
>>>> Rajendra reported a kernel panic when a link was taken down:
>>>>
>>>> [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
>>>> [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290
>>>>
>>>> <snip>
>>>>
>>>
>>> Reviewed-by: Eric Dumazet <edumazet@google.com>
>>>
>>> Thanks !
>>>
>>
>> Apparently this patch causes problems. I yet have to make an analysis.
>>
> 
> It seems we need to allow the code to do some changes if IF_READY is not set.
> 

That statement was correct. Prior to the patch in question ifp->state is
bumped to INET6_IFADDR_STATE_DAD in addrconf_dad_work. When
NETDEV_CHANGE event happens, addrconf_notify calls addrconf_dad_run
which calls addrconf_dad_kick to restart dad after the dad process
(applies even if nodad is set -- yes, odd).

With the patch, IF_READY is not set when the bond device is created and
dad_work skips bumping the state. When the CHANGE event comes through
the state is not INET6_IFADDR_STATE_DAD (and the restart argument is not
set), so addrconf_dad_run does not call addrconf_dad_kick.

Bottom line, regardless of IF_READY we need the state change to happen
in dad_work, we just need to skip the call to addconf_dad_begin.

Can you test the change below on your boxes? It applies on current net.

Rajendra: can you test as well and make sure your problem is still
resolved?

Thanks,

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index dd3be06d5a06..fce0d0dca7bb 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4032,12 +4032,6 @@ static void addrconf_dad_work(struct work_struct *w)

        rtnl_lock();

-       /* check if device was taken down before this delayed work
-        * function could be canceled
-        */
-       if (idev->dead || !(idev->if_flags & IF_READY))
-               goto out;
-
        spin_lock_bh(&ifp->lock);
        if (ifp->state == INET6_IFADDR_STATE_PREDAD) {
                action = DAD_BEGIN;
@@ -4068,6 +4062,12 @@ static void addrconf_dad_work(struct work_struct *w)
        }
        spin_unlock_bh(&ifp->lock);

+       /* check if device was taken down before this delayed work
+        * function could be canceled
+        */
+       if (idev->dead || !(idev->if_flags & IF_READY))
+               goto out;
+
        if (action == DAD_BEGIN) {
                addrconf_dad_begin(ifp);
                goto out;

