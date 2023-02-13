Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FB0694546
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjBMMJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjBMMJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:09:41 -0500
X-Greylist: delayed 538 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Feb 2023 04:09:22 PST
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E434CA27B
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 04:09:22 -0800 (PST)
Message-ID: <88e9d68c-0f3f-f464-d1d2-12a3a5700dd3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676289620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81Ta6Q6KLL3sqJbTG1h3M/lwig4aKbH+72ZG5Ah46DE=;
        b=DL0eNR49POfcC/MA2Pw7gHJ/8/tappJBlsOD7IzPgJA2tNBDOkgNLFWsEAI5H4t2JRDo95
        9BE+n3kXyndFE+hzKlRTsN15b0ZyROArOlrHer62FA+jDyTtldfjZewvs3DloPFKrXU2QG
        MLYjAYwegiRBBcMi5QTEPS4IKVXKMKQ=
Date:   Mon, 13 Feb 2023 20:00:10 +0800
MIME-Version: 1.0
Subject: Re: RE: [PATCHv2 0/6] Fix the problem that rxe can not work in net
To:     Parav Pandit <parav@nvidia.com>, Yanjun Zhu <yanjun.zhu@linux.dev>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>,
        "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     Zhu Yanjun <yanjun.zhu@intel.com>
References: <20221006085921.1323148-1-yanjun.zhu@linux.dev>
 <204f1ef4-77b1-7d4b-4953-00a99ce83be4@linux.dev>
 <25767d73-c7fc-4831-4a45-337764430fe7@linux.dev>
 <PH0PR12MB54811610FD9F157330606BB7DC009@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ef09ae0a-ad22-8791-a972-ea33e16011ba@linux.dev>
 <PH0PR12MB548101B6A19568A3E1FBD50ADC029@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <PH0PR12MB548101B6A19568A3E1FBD50ADC029@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/11/13 12:58, Parav Pandit 写道:
> Hi Yanjun,
> 
>> From: Yanjun Zhu <yanjun.zhu@linux.dev>
>> Sent: Thursday, November 10, 2022 10:38 PM
>>
>>
>> 在 2022/11/11 11:35, Parav Pandit 写道:
>>>> From: Yanjun Zhu <yanjun.zhu@linux.dev>
>>>> Sent: Thursday, November 10, 2022 9:37 PM
>>>
>>>> Can you help to review these patches?
>>> I will try to review it before 13th.
> 
> I did a brief review of patch set.
> I didn’t go line by line for each patch; hence I give lumped comments here for overall series.
> 
> 1. Add example and test results in below test flow in exclusive mode in cover letter.
>     # ip netns exec net1 rdma link add rxe1 type rxe netdev eno3
>     # ip netns del net0
>     Verify that rdma device rxe1 is deleted.

Sorry. It is late to reply.
Got it. I will add the above example in the cover letter.

> 
> 2. Usage of dev_net() in rxe_setup_udp_tunnel() is unsafe.
>     This is because when rxe_setup_udp_tunnel() is executed, net ns of netdev can change.
>     This needs to be synchronized with per net notifier register_pernet_subsys() of exit or exit_batch.
>     This notifiers callback should be added to rxe module.

No. The netdev device and rxe device are one-to-one correspondence. When 
the netdev device is removed from
the net namespace, the rxe device will be removed. So this will not 
happen that rxe_setup_udp_tunnel is executed
while net namespace of the netdev can change.
In the latest commits, I will add register_pernet_subsys() because the 
init and exit functions can help initialization
and cleanup.

> 
> 3. You need to set bind_ifindex of udp config to the netdev given in newlink in rxe_setup_udp_tunnel.
>     Should be a separate pre-patch to ensure that close and right relation to udp socket with netdev in a given netns.
> 

No. In the rxe, the sock listeing to the udp port 4791 does not bind 
with the netdev device. A sock can listen to the packets from several
netdev devices. That is, this port 4791 sock is shared by many rxe rdma 
links.

> 4. Rearrange series to implement delete link as separate series from net ns securing series.
> They are unrelated. Current delink series may have use after free accesses. Those needs to be guarded in likely larger series.
> 

Got it. I found the use-after-free problem with the sock. And now it is 
fixed in the latest commits.
I will send it out very soon.

> 5. udp tunnel must shutdown synchronously when rdma link del is done.
>     This means any new packet arriving after this point, will be dropped.
>     Any existing packet handling present is flushed.
>     From your cover letter description, it appears that sock deletion is refcount based and above semantics is not ensured.
> 

The port 4791 udp tunnel is shared by many rxe rdma links. If one rdma 
link exists in net namespace, this udp tunnel should not be
shutdown. Only if no rxe rdma link exist, this udp tunnel will be destroyed.

> 6. In patch 5, rxe_get_dev_from_net() can return NULL, hence l_sk6 check can be unsafe. Please add check for rdev null before rdev->l_sk6 check.
> 

Got it. the l_sk6 is replaced with the sk6 in net namespace notifier.

> 7. In patch 5, I didn't fully inspect, but seems like call to rxe_find_route4() is not rcu safe.
> Hence, extension of dev_net() in rxe_find_route4() doesn't look secure.
> Accessing sock_net() is more accurate, because at this layer, it is processing packets at socket layer.

No. As I mentioned in the above, because the netdev device and rxe 
device are one-to-one correspondence, if one net device is moved out of 
the net namespace,
the related rxe device is also removed. So dev_net seems safe.

I will send out the latest commits very soon.

Zhu Yanjun

