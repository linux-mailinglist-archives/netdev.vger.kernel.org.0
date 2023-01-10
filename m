Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0CC663901
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjAJGDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbjAJGDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:03:05 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2712DC26;
        Mon,  9 Jan 2023 22:02:50 -0800 (PST)
Message-ID: <276971e8-7eac-6b0c-06a7-30d415fb86c0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673330567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KrPYN+LFQ7vZhHhi6lQN6JTbpeL3pectrwA8T2cqrOU=;
        b=SHuiBTv4PG2ZF0jINppB/8edMzc0cNokbDuu6N5sUrAhkO3zFmlxegIYt53soDShoIc4Jv
        fr0Rj9I3tgruXFyLBsejRzW6R4iXkzfuIZR/oOabjRbz+T8joeMBx4zhzMvnsuh1tgzb67
        V4qMBvRKdDIElEfn8SQJqLMLZQawzRM=
Date:   Tue, 10 Jan 2023 14:02:34 +0800
MIME-Version: 1.0
Subject: Re: RE: Network do not works with linux >= 6.1.2. Issue bisected to
 "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the correct
 link speed)
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Wesierski, DawidX" <dawidx.wesierski@intel.com>
Cc:     "kamalheib1@gmail.com" <kamalheib1@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Raits <igor.raits@gooddata.com>
References: <CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com>
 <Y7hJJ5hIxDolYIAV@ziepe.ca>
 <MWHPR11MB00299035ECB2E34F60BC2C74E9FE9@MWHPR11MB0029.namprd11.prod.outlook.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <MWHPR11MB00299035ECB2E34F60BC2C74E9FE9@MWHPR11MB0029.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2023/1/10 3:36, Saleem, Shiraz 写道:
>> Subject: Re: Network do not works with linux >= 6.1.2. Issue bisected to
>> "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the
>> correct link speed)
>>
>> On Fri, Jan 06, 2023 at 08:55:29AM +0100, Jaroslav Pulchart wrote:
>>> [  257.967099] task:NetworkManager  state:D stack:0     pid:3387
>>> ppid:1      flags:0x00004002
>>> [  257.975446] Call Trace:
>>> [  257.977901]  <TASK>
>>> [  257.980004]  __schedule+0x1eb/0x630 [  257.983498]
>>> schedule+0x5a/0xd0 [  257.986641]  schedule_timeout+0x11d/0x160 [
>>> 257.990654]  __wait_for_common+0x90/0x1e0 [  257.994666]  ?
>>> usleep_range_state+0x90/0x90 [  257.998854]
>>> __flush_workqueue+0x13a/0x3f0 [  258.002955]  ?
>>> __kernfs_remove.part.0+0x11e/0x1e0
>>> [  258.007661]  ib_cache_cleanup_one+0x1c/0xe0 [ib_core] [
>>> 258.012721]  __ib_unregister_device+0x62/0xa0 [ib_core] [  258.017959]
>>> ib_unregister_device+0x22/0x30 [ib_core] [  258.023024]
>>> irdma_remove+0x1a/0x60 [irdma] [  258.027223]
>>> auxiliary_bus_remove+0x18/0x30 [  258.031414]
>>> device_release_driver_internal+0x1aa/0x230
>>> [  258.036643]  bus_remove_device+0xd8/0x150 [  258.040654]
>>> device_del+0x18b/0x3f0 [  258.044149]  ice_unplug_aux_dev+0x42/0x60
>>> [ice]
>>
>> We talked about this already - wasn't it on this series?
> 
> This is yet another path (when ice ports are added to a bond) I believe where the RDMA aux device
> is removed holding the RTNL lock. It's being exposed now with this recent irdma patch - 425c9bd06b7a,
> causing a deadlock.
> 
> ice_lag_event_handler [rtnl_lock]
>   ->ice_lag_changeupper_event
>       ->ice_unplug_aux_dev
>          ->irdma_remove
>              ->ib_unregister_device
>                 ->ib_cache_cleanup_one
>                    ->flush_workqueue(ib)
>                       ->irdma_query_port
>                           -> ib_get_eth_speed [rtnl_lock]

Agree with the above analysis.
Maybe a quick and direct fix is like this.

@@ -74,6 +74,7 @@ static int irdma_query_port(struct ib_device *ibdev, 
u32 port,
  {
         struct irdma_device *iwdev = to_iwdev(ibdev);
         struct net_device *netdev = iwdev->netdev;
+       bool unlock_rtnl = false;

         /* no need to zero out pros here. done by caller */

@@ -91,9 +92,16 @@ static int irdma_query_port(struct ib_device *ibdev, 
u32 port,
                 props->phys_state = IB_PORT_PHYS_STATE_DISABLED;
         }

+       if (rtnl_is_locked()) {
+               rtnl_unlock();
+               unlock_rtnl = true;
+       }
         ib_get_eth_speed(ibdev, port, &props->active_speed,
                          &props->active_width);

+       if (unlock_rtnl) {
+               rtnl_lock();
+       }
         if (rdma_protocol_roce(ibdev, 1)) {
                 props->gid_tbl_len = 32;
                 props->ip_gids = true;

Zhu Yanjun

> 
> Previous discussion was on ethtool channel config change, https://lore.kernel.org/linux-rdma/Y5ES3kmYSINlAQhz@x130/,
> which David E. is taking care of.
> 
> We are working on a patch for this issue.
> 
>>
>> Don't hold locks when removing aux devices.
>>
>>> [  258.048707]  ice_lag_changeupper_event+0x287/0x2a0 [ice] [
>>> 258.054038]  ice_lag_event_handler+0x51/0x130 [ice] [  258.058930]
>>> raw_notifier_call_chain+0x41/0x60 [  258.063381]
>>> __netdev_upper_dev_link+0x1a0/0x370
>>> [  258.068008]  netdev_master_upper_dev_link+0x3d/0x60
>>> [  258.072886]  bond_enslave+0xd16/0x16f0 [bonding] [  258.077517]  ?
>>> nla_put+0x28/0x40 [  258.080756]  do_setlink+0x26c/0xc10 [
>>> 258.084249]  ? avc_alloc_node+0x27/0x180 [  258.088173]  ?
>>> __nla_validate_parse+0x141/0x190 [  258.092708]
>>> __rtnl_newlink+0x53a/0x620 [  258.096549]  rtnl_newlink+0x44/0x70
>>
>> Especially not the rtnl.
>>
>> Jason

