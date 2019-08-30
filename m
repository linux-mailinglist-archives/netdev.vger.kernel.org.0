Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E84FA3F5C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbfH3VEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:04:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43220 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbfH3VEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:04:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4FA30602B8; Fri, 30 Aug 2019 21:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567199040;
        bh=Is5eZc7DVdkuU1nKvQ5hshmoFJxfPJ/Boisu5FEI0bI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C2sssOwX5p+lGXtEN2o+zm06nWym3rdFf9jMvUpHn2RZFZqENPxnQ+XIZhlTFaDYQ
         4s7Gs+0C2KjEQu43DIAVfXO6mOu7DR0bw6NnEp3ViUbraaGVKOFYSBMcoMSWyeGFFK
         pnl/iGyKFBNIYmS19vfhpWyxm0R/9FmAU/SgPFK4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id EEF38602A9;
        Fri, 30 Aug 2019 21:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567199037;
        bh=Is5eZc7DVdkuU1nKvQ5hshmoFJxfPJ/Boisu5FEI0bI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GJGsj0efElh6bWPAZcR70M/oq6zhvKq2GEJnabtK7biigNKQ7Ll/xZIWwByT9a32Z
         2M+S+k3nBluyIZd7N9B0t5JcWAhpFNWqMo0TqqbV9sKtCyqTJBBjxz+JDU7sQOlNBJ
         JL48AyhnkBFPxRH6RZYwHPMoHJkahVW6W+LU+fCY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 30 Aug 2019 15:03:56 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: [PATCH net] dev: Delay the free of the percpu refcount
In-Reply-To: <959f4b3e-387d-a148-3281-aed26a6a7aa5@gmail.com>
References: <1567142596-25923-1-git-send-email-subashab@codeaurora.org>
 <959f4b3e-387d-a148-3281-aed26a6a7aa5@gmail.com>
Message-ID: <adbe6efaabd34538fa424e028bdc6699@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This looks bogus.
> 
> Whatever layer tries to access dev refcnt after free_netdev() has been
> called is buggy.
> 
> I would rather trap early and fix the root cause.
> 
> Untested patch :
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index b5d28dadf964..8080f1305417 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3723,6 +3723,7 @@ void netdev_run_todo(void);
>   */
>  static inline void dev_put(struct net_device *dev)
>  {
> +       BUG_ON(!dev->pcpu_refcnt);
>         this_cpu_dec(*dev->pcpu_refcnt);
>  }
> 
> @@ -3734,6 +3735,7 @@ static inline void dev_put(struct net_device 
> *dev)
>   */
>  static inline void dev_hold(struct net_device *dev)
>  {
> +       BUG_ON(!dev->pcpu_refcnt);
>         this_cpu_inc(*dev->pcpu_refcnt);
>  }

Hello Eric

I am seeing a similar crash with your patch as well.
The NULL dev->pcpu_refcnt was caught by the BUG you added.

    786.510217:   <6> kernel BUG at include/linux/netdevice.h:3633!
    786.510263:   <2> pc : in_dev_finish_destroy+0xcc/0xd0
    786.510267:   <2> lr : in_dev_finish_destroy+0x2c/0xd0
    786.511220:   <2> Call trace:
    786.511225:   <2>  in_dev_finish_destroy+0xcc/0xd0
    786.511230:   <2>  in_dev_rcu_put+0x24/0x30
    786.511237:   <2>  rcu_nocb_kthread+0x43c/0x468
    786.511243:   <2>  kthread+0x118/0x128
    786.511249:   <2>  ret_from_fork+0x10/0x1c

This seems to be happening when there is an allocation failure
in the IPv6 notifier callback only.

I had added some additional debug to narrow down the refcount
validity along the callers of the dev_put/dev_hold.
refcnt valid below shows that the pointer dev->pcpu_refcnt is valid
while refcnt null shows the case where dev->pcpu_refcnt is NULL.
The last dev_put happens after free_netdev leading to the
dev->pcpu_refcnt to be accessed when NULL.

309.908501:   <6> dev_hold() ffffffe13c9df000 ip6_vti0 refcnt valid 
setup_net+0xa0/0x210 -> ops_init+0x88/0x110
309.908674:   <6> dev_hold() ffffffe13c9df000 ip6_vti0 refcnt valid 
register_netdevice+0x29c/0x5b0 -> netdev_register_kobject+0xd8/0x150
309.908696:   <6> dev_hold() ffffffe13c9df000 ip6_vti0 refcnt valid 
register_netdevice+0x29c/0x5b0 -> netdev_register_kobject+0x100/0x150
309.908717:   <6> dev_hold() ffffffe13c9df000 ip6_vti0 refcnt valid 
vti6_init_net+0x188/0x1c0 -> register_netdev+0x28/0x40
309.908763:   <6> neighbour: dev_hold() ffffffe13c9df000 ip6_vti0 refcnt 
valid inetdev_event+0x43c/0x528 -> inetdev_init+0x80/0x1e0
309.908835:   <6> dev_hold() ffffffe13c9df000 ip6_vti0 refcnt valid 
raw_notifier_call_chain+0x3c/0x68 -> inetdev_event+0x43c/0x528
309.908882:   <6> neighbour: dev_hold() ffffffe13c9df000 ip6_vti0 refcnt 
valid addrconf_notify+0x42c/0xe58 -> ipv6_add_dev+0xe4/0x588
309.908890:   <6> IPv6: dev_hold() ffffffe13c9df000 ip6_vti0 refcnt 
valid raw_notifier_call_chain+0x3c/0x68 -> addrconf_notify+0x42c/0xe58
309.908906:   <6> stress-ng-clone: page allocation failure: order:0, 
mode:0x6040c0(GFP_KERNEL|__GFP_COMP), nodemask=(null)
309.908910:   <6> stress-ng-clone cpuset=foreground mems_allowed=0
309.908925:   <2> Call trace:
309.908931:   <2>  dump_backtrace+0x0/0x158
309.908934:   <2>  show_stack+0x14/0x20
309.908939:   <2>  dump_stack+0xc4/0xfc
309.908944:   <2>  warn_alloc+0xf8/0x168
309.908947:   <2>  __alloc_pages_nodemask+0xff4/0x1018
309.908955:   <2>  new_slab+0x128/0x5b8
309.908958:   <2>  ___slab_alloc+0x4cc/0x5f8
309.908960:   <2>  kmem_cache_alloc_trace+0x2a4/0x2c0
309.908963:   <2>  ipv6_add_dev+0x220/0x588
309.908966:   <2>  addrconf_notify+0x42c/0xe58
309.908969:   <2>  raw_notifier_call_chain+0x3c/0x68
309.908972:   <2>  register_netdevice+0x3c4/0x5b0
309.908974:   <2>  register_netdev+0x28/0x40
309.908978:   <2>  vti6_init_net+0x188/0x1c0
309.908981:   <2>  ops_init+0x88/0x110
309.908983:   <2>  setup_net+0xa0/0x210
309.908986:   <2>  copy_net_ns+0xa8/0x130
309.908990:   <2>  create_new_namespaces+0x138/0x170
309.908993:   <2>  unshare_nsproxy_namespaces+0x68/0x90
309.908999:   <2>  ksys_unshare+0x17c/0x248
309.909001:   <2>  __arm64_sys_unshare+0x10/0x20
309.909004:   <2>  el0_svc_common+0xa0/0x158
309.909007:   <2>  el0_svc_handler+0x6c/0x88
309.909010:   <2>  el0_svc+0x8/0xc
309.909021:   <6> neighbour: dev_put() ffffffe13c9df000 ip6_vti0 refcnt 
valid addrconf_notify+0x42c/0xe58 -> ipv6_add_dev+0x400/0x588
309.909030:   <6> IPv6: dev_put() ffffffe13c9df000 ip6_vti0 refcnt valid 
raw_notifier_call_chain+0x3c/0x68 -> addrconf_notify+0x42c/0xe58
309.918097:   <6> neighbour: dev_put() ffffffe13c9df000 ip6_vti0 refcnt 
valid raw_notifier_call_chain+0x3c/0x68 -> inetdev_event+0x290/0x528
309.918249:   <6> dev_put() ffffffe13c9df000 ip6_vti0 refcnt valid 
register_netdevice+0x3f8/0x5b0 -> rollback_registered_many+0x488/0x658
309.918318:   <6> dev_put() ffffffe13c9df000 ip6_vti0 refcnt valid 
net_rx_queue_update_kobjects+0x1ec/0x238 -> kobject_put+0x7c/0xc0
309.918405:   <6> dev_put() ffffffe13c9df000 ip6_vti0 refcnt valid 
netdev_queue_update_kobjects+0x1dc/0x228 -> kobject_put+0x7c/0xc0
309.918759:   <6> dev_put() ffffffe13c9df000 ip6_vti0 refcnt valid 
register_netdev+0x28/0x40 -> register_netdevice+0x3f8/0x5b0
309.918778:   <6> free_netdev() ffffffe13c9df000 ip6_vti0 refcnt valid 
ops_init+0x88/0x110 -> vti6_init_net+0x1ac/0x1c0
309.980671:   <6> dev_put() ffffffe13c9df000 ip6_vti0 refcnt null 
rcu_nocb_kthread+0x43c/0x468 -> in_dev_rcu_put+0x24/0x30
309.980838:   <6> kernel BUG at include/linux/netdevice.h:3636!

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
