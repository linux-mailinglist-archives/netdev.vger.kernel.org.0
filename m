Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F006B626EF4
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 11:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbiKMK0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 05:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiKMK0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 05:26:00 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6ED11834;
        Sun, 13 Nov 2022 02:25:58 -0800 (PST)
Message-ID: <b5891f03-7283-8b52-aef6-40773f31ff10@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668335157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Ix5CiIju4tuYtmb+hMgKgKfn6aGjoc/cdFjHgvGIp4=;
        b=kbkrA8sqbm48Wun+YYGfJh4HyZmFW9/V4pmgE4scxjhsWRa7N+WidivUB22QD1hdRnrBMG
        wcF+H/3rPO5JyC1VePsEpjmol6JjZgvPkOuBLMnKQ/E99NIRp2vHt9d+TTQQ/tXKm4KKda
        j/Ue/YUtH5gL9IeWE/G1P48euC0FK44=
Date:   Sun, 13 Nov 2022 18:25:47 +0800
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
From:   Yanjun Zhu <yanjun.zhu@linux.dev>
In-Reply-To: <PH0PR12MB548101B6A19568A3E1FBD50ADC029@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Hi, Parav

Thanks a lot. I will add this example to the cover letter.
And I confirm that rdma device rxe1 is deleted after the command "ip 
netns del net0".

I will delve into the following comments.

Thanks and Regards,
Zhu Yanjun

> 
> 2. Usage of dev_net() in rxe_setup_udp_tunnel() is unsafe.
>     This is because when rxe_setup_udp_tunnel() is executed, net ns of netdev can change.
>     This needs to be synchronized with per net notifier register_pernet_subsys() of exit or exit_batch.
>     This notifiers callback should be added to rxe module.
> 
> 3. You need to set bind_ifindex of udp config to the netdev given in newlink in rxe_setup_udp_tunnel.
>     Should be a separate pre-patch to ensure that close and right relation to udp socket with netdev in a given netns.
> 
> 4. Rearrange series to implement delete link as separate series from net ns securing series.
> They are unrelated. Current delink series may have use after free accesses. Those needs to be guarded in likely larger series.
> 
> 5. udp tunnel must shutdown synchronously when rdma link del is done.
>     This means any new packet arriving after this point, will be dropped.
>     Any existing packet handling present is flushed.
>     From your cover letter description, it appears that sock deletion is refcount based and above semantics is not ensured.
> 
> 6. In patch 5, rxe_get_dev_from_net() can return NULL, hence l_sk6 check can be unsafe. Please add check for rdev null before rdev->l_sk6 check.
> 
> 7. In patch 5, I didn't fully inspect, but seems like call to rxe_find_route4() is not rcu safe.
> Hence, extension of dev_net() in rxe_find_route4() doesn't look secure.
> Accessing sock_net() is more accurate, because at this layer, it is processing packets at socket layer.

