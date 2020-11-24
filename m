Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CAB2C1B62
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 03:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgKXCS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 21:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgKXCS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 21:18:57 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F857C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:18:57 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id s63so6197955pgc.8
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YlrrUTAwUKDHOkEUpWWu/j7q/VQ6CZsrnhGOpp3ktaE=;
        b=lpxRHkpLLRiDeUBDfL+zweoBZjHluAMt6UxVrXaY/ra3jz0X5Xm/GmPh/t8AUPMrsM
         gV9qJqpMf7kcbtGfBzlUxEukHfpQyWyDRqHvjuLCe1mcRQEqtX6QAy2IieMcelvutX+b
         r6rViYRZ3HWw9kUi5PROGq0kDZNs6mJbELumGniNhVYHk82XS9jhfQk5rHAsxv7lUjq6
         d2zUgNZq3TbKsNpOJ3CPkCP4ymU+Nho4J4r6F6Cen+VIjvD9F72R9WREJeSUb1Ywm9ll
         HxqqCFnG2oKEcJN5LoM1PjQumlkBnyCYSODxOAPI/CPtmAIPOezpjIcjx+gDBYqGZltq
         DkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YlrrUTAwUKDHOkEUpWWu/j7q/VQ6CZsrnhGOpp3ktaE=;
        b=IFXzSl5l5ebD5Zlhaxo2NR5vkeHcoMb5xGeD1x9czVR0xNp9xf+Z1v0HVOT3PEiQuV
         YTMDdxSnGVnN6xdAXPi2rjGKcxGKSmCN5OfrY1wTnuBkX8NR6EQpC93DNbkFEKz2cfDy
         pT5xKteZaGZtYROuQ8An0B9x4CnCirbaRGeADG2e1mTUi3NTQHBBFAI+3EJ1PWTR2Bbx
         njq7pUECqXBhP+Ix1eJMXb8PTn1HJzvYrDvutKOirHdUCpeaziYq8xlfE26YT9G26AML
         CkLxThh0y65W2EjNHWuDX8kckVDDmiQ7peU5EAL3HPInHEHVJPXRjDbKBZqbQF62JgyX
         NmQg==
X-Gm-Message-State: AOAM530hGHAr1/eqUWW1zmdfH/CkJdEsGQ4m5ERXZ3liQdrvBldjr+WH
        Zsmv/Ztqi1dEBNzwVAUc4Zg2+jHfDLA=
X-Google-Smtp-Source: ABdhPJxU4zcMo7ueL1CILHdHw8HZGTWSgJI8rM1y37OgF6md2kGA3ihD0s5vD8DgivOo96lmqrhcIQ==
X-Received: by 2002:a17:90a:fd88:: with SMTP id cx8mr2063649pjb.220.1606184337062;
        Mon, 23 Nov 2020 18:18:57 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id y20sm12584456pfr.159.2020.11.23.18.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 18:18:56 -0800 (PST)
Subject: Re: [PATCH] veth: fix memleak in veth_newlink()
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net
References: <20201120093057.1477009-1-yangyingliang@huawei.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <560f4040-e6a4-5745-050b-4628deecb070@gmail.com>
Date:   Tue, 24 Nov 2020 11:18:50 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201120093057.1477009-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/20 18:30, Yang Yingliang wrote:

Hi,

> I got a memleak report when doing fault-inject test:
> 
> unreferenced object 0xffff88810ace9000 (size 1024):
>    comm "ip", pid 4622, jiffies 4295457037 (age 43.378s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<00000000008abe41>] __kmalloc+0x10f/0x210
>      [<000000005d3533a6>] veth_dev_init+0x140/0x310
>      [<0000000088353c64>] register_netdevice+0x496/0x7a0
>      [<000000001324d322>] veth_newlink+0x40b/0x960
>      [<00000000d0799866>] __rtnl_newlink+0xd8c/0x1360
>      [<00000000d616040a>] rtnl_newlink+0x6b/0xa0
>      [<00000000e0a1600d>] rtnetlink_rcv_msg+0x3cc/0x9e0
>      [<000000009eeff98b>] netlink_rcv_skb+0x130/0x3a0
>      [<00000000500f8be1>] netlink_unicast+0x4da/0x700
>      [<00000000666c03b3>] netlink_sendmsg+0x7fe/0xcb0
>      [<0000000073b28103>] sock_sendmsg+0x143/0x180
>      [<00000000ad746a30>] ____sys_sendmsg+0x677/0x810
>      [<0000000087dd98e5>] ___sys_sendmsg+0x105/0x180
>      [<00000000028dd365>] __sys_sendmsg+0xf0/0x1c0
>      [<00000000a6bfbae6>] do_syscall_64+0x33/0x40
>      [<00000000e00521b4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> If call_netdevice_notifiers() failed in register_netdevice(),
> dev->priv_destructor() is not called, it will cause memleak.
> Fix this by assigning ndo_uninit with veth_dev_free(), so
> the memory can be freed in rollback_registered();

We have discussed this before and it seems we should fix
register_netdevice() rather than each driver.

https://patchwork.ozlabs.org/project/netdev/patch/20200830131336.275844-1-rkovhaev@gmail.com/

Toshiaki Makita
