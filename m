Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9066CF9D9
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 05:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjC3D5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 23:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjC3D5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 23:57:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FD14C35
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:57:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA735B82100
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF9AC433D2;
        Thu, 30 Mar 2023 03:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680148668;
        bh=GM+1nF7UmArM3iyAFikUsyHP5u/M46DmQIVOKVbFl8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rb4+A+gFdu2X8/y7ae7I7koECc2JBUHW4DKbBSQ5uzLgBrgL5bd02F1odVAS98iCO
         JXkjuAEz6EIgLUsrbI6aQoXKOn5J/QG4LZH7RA60IqIWfYopXRD9G16daHEwW4hiH7
         eHgYjTQfbwC/9E2ILGP4V0Pbj26T5qLYV/TkN7epM66q9oZ1ECZ/ZPp3QGydXMeHR3
         n0RZqxrSgn2kJNgdyQCfenBC0yUkaO77lokyFRq/pqvySwSwFN9k4lBaajJpqSn9TQ
         pXTZ0dCA5zc6YbTG/naQ9UxOggSRKK/Y3D+1MJwCdI7g0gD69cEciIgawE9XnEuCfR
         OJS5U7IgWkjHA==
Date:   Wed, 29 Mar 2023 20:57:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
Message-ID: <20230329205747.3ed24339@kernel.org>
In-Reply-To: <CANn89iKxuKs8muPAe+6jCjYdvoYa=39uXVKoCpKpOVRUFtqt7w@mail.gmail.com>
References: <20230328235021.1048163-1-edumazet@google.com>
        <20230329200403.095be0f7@kernel.org>
        <CANn89iKtD8xiedfvDEWOPQAPeqwDM0HxWqMYgk7C9Ar_gTcGOA@mail.gmail.com>
        <CANn89iKxuKs8muPAe+6jCjYdvoYa=39uXVKoCpKpOVRUFtqt7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 05:39:35 +0200 Eric Dumazet wrote:
> > This was from "grep NET_RX /proc/softirqs" (more exactly a tool
> > parsing /proc/softirqs)
> >
> > So it should match the number of calls to net_rx_action(), but I can
> > double check if you want.
> >
> > (I had a simple hack to enable/disable the optimizations with a hijacked sysctl)  
> 
> Trace of real debug session, because numbers ;)
> Old platform with two Intel(R) Xeon(R) Gold 6268L CPU @ 2.80GHz  (96
> threads total)
> 
> 600 tcp_rr flows
> 
> iroa23:/home/edumazet# cat /proc/sys/net/core/netdev_max_backlog
> 1000
> iroa23:/home/edumazet# ./interrupts
> hrtimer:99518 cal:2421783 timer:1034 sched:80505 rcu:7661 rps:2390765
> net_tx:43 net_rx:3344637 eth1-rx:295134 eth1-tx:558933 eth1:854074
> ^C
> iroa23:/home/edumazet# echo 1001 >/proc/sys/net/core/netdev_max_backlog
> iroa23:/home/edumazet# ./interrupts
> hrtimer:99545 cal:2358993 timer:1086 sched:77806 rcu:10928 rps:2419052
> net_tx:21 net_rx:3016301 eth1-rx:294612 eth1-tx:560331 eth1:855083
> ^C
> 
> echo "(3344637 - 3016301)/3344637" | bc -ql
> .09816790282473105452

Very nice, thanks! (I didn't know about /proc/softirqs !)
