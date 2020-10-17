Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77288290FAC
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436699AbgJQFyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411824AbgJQFym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 01:54:42 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC27FC05BD21
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 21:37:40 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w17so4958230ilg.8
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 21:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iiGwrV0NKK1gY2dyfZjkPU9prcwn/lHJEnsM17MGAy0=;
        b=Qz53maOYpBBHWC/D2yPufBKX2d0XNPtUz7tXjDDyGbvr9i11nPR55My0VB4/9yRWOC
         adcnrm9PQfww+7npFVCIJNG+vTfsIWT5c5exiHH1EYJrNC9wIFmu6AmC3C09ZO9qUyIF
         f5823WFgbbqcxnpyaN6N7MPnknkLunP/UwzW918KvDEAQ8s2CaxomFIGmoGjTOF0rEQ/
         VrZi8xCeZW261iB0ZlSth+EIcXuVeMC+TabfN8FOYGi56eHBI1bJlrEvZH71SPVSO+Ai
         RUgpNvNQ9t5+gupR7FKCyu3IutW5euMEIBTVVN5zE2WYsUGwFtliHnbnwjl5wggg2vu5
         pZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iiGwrV0NKK1gY2dyfZjkPU9prcwn/lHJEnsM17MGAy0=;
        b=ppoxz76DImVXYDJ2i0QI92EnRiivCFa5zdo6+igEgAUZ7ymPz8oZCs6L+ss0JoD41y
         OUSLwkog+3qhsayKQbxzopJJ7lZGkMVd7KGBnsswZHjeNCoAJ5AYmXp+TLWiidXniGaI
         BfwRyknBHybMIHwG9xy0/cA/jKGMxYhsuG4uG9X7QXCxUvm0aORT7flwa6IUwy+Ap2xX
         HztMoNx1mBt5CRj9ilwbs0iEHVTrogFGaA3XXsa2D2bqs1AtQJ5MxalJcCrSqEmJWMrw
         RWpwI3Xz9ETWs5MMOd+TVNx6M+WUGzu7gl1G03AlJp3xPgKhqDtM0qwJP4kkoRbptyO1
         4LaQ==
X-Gm-Message-State: AOAM532PSjuj2Erdk2EJMK77k1ZqRUMRh9s38vHUHGHjpAGhOFpwfu0B
        j9LshfA+naCEE7kXjdjuvtJMHnZ3bIw=
X-Google-Smtp-Source: ABdhPJzHvKd1Z61v12kZVQ2mwiAJMuIbqTBOze8k9RAEZugO53FTmmiIVEwq+Kg+gkRuDU3CpcEygg==
X-Received: by 2002:a92:8742:: with SMTP id d2mr4945055ilm.153.1602909460270;
        Fri, 16 Oct 2020 21:37:40 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:c015:614b:5c97:a602])
        by smtp.googlemail.com with ESMTPSA id y75sm4274473iof.36.2020.10.16.21.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 21:37:39 -0700 (PDT)
Subject: Re: [PATCH net] nexthop: Fix performance regression in nexthop
 deletion
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20201016172914.643282-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f0cf2c4d-3432-e904-1d27-1de5c88e5b34@gmail.com>
Date:   Fri, 16 Oct 2020 22:37:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201016172914.643282-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/20 11:29 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> While insertion of 16k nexthops all using the same netdev ('dummy10')
> takes less than a second, deletion takes about 130 seconds:
> 
> # time -p ip -b nexthop.batch
> real 0.29
> user 0.01
> sys 0.15
> 
> # time -p ip link set dev dummy10 down
> real 131.03
> user 0.06
> sys 0.52
> 
> This is because of repeated calls to synchronize_rcu() whenever a
> nexthop is removed from a nexthop group:
> 
> # /usr/share/bcc/tools/offcputime -p `pgrep -nx ip` -K
> ...
>     b'finish_task_switch'
>     b'schedule'
>     b'schedule_timeout'
>     b'wait_for_completion'
>     b'__wait_rcu_gp'
>     b'synchronize_rcu.part.0'
>     b'synchronize_rcu'
>     b'__remove_nexthop'
>     b'remove_nexthop'
>     b'nexthop_flush_dev'
>     b'nh_netdev_event'
>     b'raw_notifier_call_chain'
>     b'call_netdevice_notifiers_info'
>     b'__dev_notify_flags'
>     b'dev_change_flags'
>     b'do_setlink'
>     b'__rtnl_newlink'
>     b'rtnl_newlink'
>     b'rtnetlink_rcv_msg'
>     b'netlink_rcv_skb'
>     b'rtnetlink_rcv'
>     b'netlink_unicast'
>     b'netlink_sendmsg'
>     b'____sys_sendmsg'
>     b'___sys_sendmsg'
>     b'__sys_sendmsg'
>     b'__x64_sys_sendmsg'
>     b'do_syscall_64'
>     b'entry_SYSCALL_64_after_hwframe'
>     -                ip (277)
>         126554955
> 
> Since nexthops are always deleted under RTNL, synchronize_net() can be
> used instead. It will call synchronize_rcu_expedited() which only blocks
> for several microseconds as opposed to multiple milliseconds like
> synchronize_rcu().
> 
> With this patch deletion of 16k nexthops takes less than a second:
> 
> # time -p ip link set dev dummy10 down
> real 0.12
> user 0.00
> sys 0.04
> 
> Tested with fib_nexthops.sh which includes torture tests that prompted
> the initial change:
> 
> # ./fib_nexthops.sh
> ...
> Tests passed: 134
> Tests failed:   0
> 
> Fixes: 90f33bffa382 ("nexthops: don't modify published nexthop groups")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks for finding this, Ido.

Reviewed-by: David Ahern <dsahern@gmail.com>


