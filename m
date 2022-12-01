Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B361763E954
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiLAF0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiLAF0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:26:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D670A1A02;
        Wed, 30 Nov 2022 21:26:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D334D61E6C;
        Thu,  1 Dec 2022 05:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C59AC433C1;
        Thu,  1 Dec 2022 05:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669872407;
        bh=R5GmtDmrK1Mk61T1laNRH+dxK56rGc02m+iTMZhNWT8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CeDxg4gAIM+n/76WUOOtH8vagK3XI5Y6TJx0LIMjdsBEtVehsncsm1BonfbRul8vF
         RwPy11Gi02etxDz2TwkrW6oeHExPGklGaI/hJT9+e0TOspY+asAj2LPcHYiN515K67
         SUy0IX2H4d3uxQiGKhUjICU6aCoC9JgzPR2uw1RiGA3gXcig5wLXAd1Fb2IcbNEads
         tcC4bWUYVzgL6Zi+uQUityKnPI5VyhAvGCyty6MD59Ne364a46u4uGGFZvmGdFgIWk
         j5rdtfeFATw+8ttbWtzzX+n9ZdUKThJcOD4bOR4rSullwo5BUAe0btMJ0kicOAu1Sn
         D1oXYtgQu5d1A==
Date:   Wed, 30 Nov 2022 21:26:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lin Liu <lin.liu@citrix.com>
Cc:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:XEN HYPERVISOR INTERFACE" 
        <xen-devel@lists.xenproject.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/netfront: Fix NULL sring after live
 migration
Message-ID: <20221130212645.06a36158@kernel.org>
In-Reply-To: <20221129061702.60629-1-lin.liu@citrix.com>
References: <20221129061702.60629-1-lin.liu@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Nov 2022 06:17:02 +0000 Lin Liu wrote:
> A NAPI is setup for each network sring to poll data to kernel
> The sring with source host is destroyed before live migration and
> new sring with target host is setup after live migration.
> The NAPI for the old sring is not deleted until setup new sring
> with target host after migration. With busy_poll/busy_read enabled,
> the NAPI can be polled before got deleted when resume VM.
> 
> [50116.602938] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000008
> [50116.603047] IP: xennet_poll+0xae/0xd20
> [50116.603090] PGD 0 P4D 0
> [50116.603118] Oops: 0000 [#1] SMP PTI
> [50116.604624] Call Trace:
> [50116.604674]  ? finish_task_switch+0x71/0x230
> [50116.604745]  ? timerqueue_del+0x1d/0x40
> [50116.604807]  ? hrtimer_try_to_cancel+0xb5/0x110
> [50116.604882]  ? xennet_alloc_rx_buffers+0x2a0/0x2a0
> [50116.604958]  napi_busy_loop+0xdb/0x270
> [50116.605017]  sock_poll+0x87/0x90
> [50116.605066]  do_sys_poll+0x26f/0x580
> [50116.605125]  ? tracing_map_insert+0x1d4/0x2f0
> [50116.605196]  ? event_hist_trigger+0x14a/0x260

You can trim all the ' ? ' entries from the stack trace, 
and the time stamps, FWIW. Makes it easier to read.

> [50116.613598]  ? finish_task_switch+0x71/0x230
> [50116.614131]  ? __schedule+0x256/0x890
> [50116.614640]  ? recalc_sigpending+0x1b/0x50
> [50116.615144]  ? xen_sched_clock+0x15/0x20
> [50116.615643]  ? __rb_reserve_next+0x12d/0x140
> [50116.616138]  ? ring_buffer_lock_reserve+0x123/0x3d0
> [50116.616634]  ? event_triggers_call+0x87/0xb0
> [50116.617138]  ? trace_event_buffer_commit+0x1c4/0x210
> [50116.617625]  ? xen_clocksource_get_cycles+0x15/0x20
> [50116.618112]  ? ktime_get_ts64+0x51/0xf0
> [50116.618578]  SyS_ppoll+0x160/0x1a0
> [50116.619029]  ? SyS_ppoll+0x160/0x1a0
> [50116.619475]  do_syscall_64+0x73/0x130
> [50116.619901]  entry_SYSCALL_64_after_hwframe+0x41/0xa6
> ...
> [50116.806230] RIP: xennet_poll+0xae/0xd20 RSP: ffffb4f041933900
> [50116.806772] CR2: 0000000000000008
> [50116.807337] ---[ end trace f8601785b354351c ]---
> 
> xen frontend should remove the NAPIs for the old srings before live
> migration as the bond srings are destroyed
> 
> There is a tiny window between the srings are set to NULL and
> the NAPIs are disabled, It is safe as the NAPI threads are still
> frozen at that time
> 

Since this is a fix please add a Fixes tag, and add [PATCH net]
to the subject.

> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 9af2b027c19c..dc404e05970c 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -1862,6 +1862,12 @@ static int netfront_resume(struct xenbus_device *dev)
>  	netif_tx_unlock_bh(info->netdev);
>  
>  	xennet_disconnect_backend(info);
> +
> +	rtnl_lock();
> +	if (info->queues)
> +		xennet_destroy_queues(info);
> +	rtnl_unlock();

Now all callers of xennet_disconnect_backend() destroy queues soon
after, can we just move the destroy queues into disconnect ?

>  	return 0;
>  }
>  

