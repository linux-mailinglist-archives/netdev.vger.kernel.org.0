Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A9344FC4D
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 23:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbhKNWq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 17:46:56 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62698 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbhKNWqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 17:46:46 -0500
Received: from fsav111.sakura.ne.jp (fsav111.sakura.ne.jp [27.133.134.238])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 1AEMhkGq071280;
        Mon, 15 Nov 2021 07:43:46 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav111.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp);
 Mon, 15 Nov 2021 07:43:46 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 1AEMhk16071277
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 15 Nov 2021 07:43:46 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Message-ID: <51c40730-5b75-fe91-560b-4c4ec4974c83@i-love.sakura.ne.jp>
Date:   Mon, 15 Nov 2021 07:43:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] sock: fix /proc/net/sockstat underflow in sk_clone_lock()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
References: <20211114060222.3370-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <ee46d850-7dcb-b9d5-b61c-56638fa2f9ae@gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
In-Reply-To: <ee46d850-7dcb-b9d5-b61c-56638fa2f9ae@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/11/15 5:01, Eric Dumazet wrote:
> On 11/13/21 10:02 PM, Tetsuo Handa wrote:
>> sk_clone_lock() needs to call get_net() and sock_inuse_inc() together, or

s/sock_inuse_inc/sock_inuse_add/

>> socket_seq_show() will underflow when __sk_free() from sk_free() from
>> sk_free_unlock_clone() is called.
>>
> 
> IMO, a "sock_inuse_get() underflow" is a very different problem,

Yes, a different problem. I found this problem while trying to examine
https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed where
somebody might be failing to call get_net() or we might be failing to
make sure that all timers are synchronously stopped before put_net().

> I suspect this should be fixed with the following patch.

My patch addresses a permanent underflow problem which remains as long as
that namespace exists. Your patch addresses a temporal underflow problem
which happens due to calculating the sum without locks. Therefore, we can
apply both patches if we want.

> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index c57d9883f62c75f522b7f6bc68451aaf8429dc83..bac8e2b62521301ce897728fff9622c4c05419a3 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3573,7 +3573,7 @@ int sock_inuse_get(struct net *net)
>         for_each_possible_cpu(cpu)
>                 res += *per_cpu_ptr(net->core.sock_inuse, cpu);
>  
> -       return res;
> +       return max(res, 0);
>  }
>  
>  EXPORT_SYMBOL_GPL(sock_inuse_get);
> 
> 
> Bug added in commit 648845ab7e200993dccd3948c719c858368c91e7
> Author: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Date:   Thu Dec 14 05:51:58 2017 -0800
> 
>     sock: Move the socket inuse to namespace.
> 
> 

