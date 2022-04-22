Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A7F50C2C1
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiDVWT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiDVWRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:17:42 -0400
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC225239543
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:09:04 -0700 (PDT)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.120])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2049C1C0085;
        Fri, 22 Apr 2022 21:09:03 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D8938340069;
        Fri, 22 Apr 2022 21:09:02 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 3DD7D13C2B0;
        Fri, 22 Apr 2022 14:09:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 3DD7D13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1650661742;
        bh=Bt9JRgXfJeOH8z8xpXaqE1cUDVlwiEzW8w8IWJXclY8=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=R1XHGqJAhb8eiPppD6o5c5ArVfMDufHCLXO62Z4tlcuuJd2Wx5KgCJofmqY5YPQWc
         oV68VB51LVCoYhgU6h5CfqP8odxkMTK15TDOOhJaOcT+4UjKZS9xU4TSr44IDgNEUl
         xfQj2IdBBHMiAy2PQ/rV/zs0pOC30VM1nZIIlcOI=
Subject: Re: 5.10.4+ hang with 'rmmod nf_conntrack'
From:   Ben Greear <greearb@candelatech.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>
References: <41dbfc93-0d57-6d78-f6fa-529dd5e0685c@candelatech.com>
 <20210108061653.GB19605@breakpoint.cc>
 <0fa45356-7c63-bb01-19c8-9447cf2cad39@candelatech.com>
 <cdddd527-c25d-c581-cea7-d1f13a0d9948@candelatech.com>
Organization: Candela Technologies
Message-ID: <d60c4cf1-8812-01e1-a51d-f1ada3c1b3fa@candelatech.com>
Date:   Fri, 22 Apr 2022 14:09:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cdddd527-c25d-c581-cea7-d1f13a0d9948@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1650661743-2nVWCLAmJbDu
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/22 9:32 AM, Ben Greear wrote:
> On 1/8/21 5:07 AM, Ben Greear wrote:
>> On 1/7/21 10:16 PM, Florian Westphal wrote:
>>> Ben Greear <greearb@candelatech.com> wrote:
>>>> I noticed my system has a hung process trying to 'rmmod nf_conntrack'.
>>>>
>>>> I've generally been doing the script that calls rmmod forever,
>>>> but only extensively tested on 5.4 kernel and earlier.
>>>>
>>>> If anyone has any ideas, please let me know.  This is from 'sysrq t'.  I don't see
>>>> any hung-task splats in dmesg.
>>>
>>> rmmod on conntrack loops forever until the active conntrack object count reaches 0.
>>> (plus a walk of the conntrack table to evict/put all entries).
> 
> Hello Florian,
> 
> I keep hitting this bug in a particular test case in 5.17.4+, so I added some debug to
> try to learn more.
> 
> My debugging patch looks like this:
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 7552e1e9fd62..29724114caef 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -2543,6 +2543,7 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
>   {
>          int busy;
>          struct net *net;
> +       unsigned long loops = 0;
> 
>          /*
>           * This makes sure all current packets have passed through
> @@ -2556,12 +2557,30 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
>                  struct nf_conntrack_net *cnet = nf_ct_pernet(net);
> 
>                  nf_ct_iterate_cleanup(kill_all, net, 0, 0);
> -               if (atomic_read(&cnet->count) != 0)
> +               if (atomic_read(&cnet->count) != 0) {
> +                       if (loops > 50010)
> +                               pr_err("nf-conntrack-cleanup-net-list, loops: %ld  cnet-count: %d, expect-count: %d users4: %d users6: %d  users_bridge: %d\n",
> +                                      loops, atomic_read(&cnet->count), cnet->expect_count,
> +                                      cnet->users4, cnet->users6, cnet->users_bridge);
>                          busy = 1;
> +               }
>          }
>          if (busy) {
> +               loops++;
> +               if (loops > 50000) {
> +                       msleep(500);
> +               }
>                  schedule();
> -               goto i_see_dead_people;
> +               if (loops > 50020) {
> +                       /* This thing is wedged, going to require a reboot to recover, so attempt
> +                        * to just ignore the bad count and see if system works OK.
> +                        */
> +                       WARN_ON_ONCE(1);
> +                       pr_err("ERROR:  nf_conntrack_cleanup_net cannot make progress.  Ignoring stale reference count and will continue.\n");
> +               }
> +               else {
> +                       goto i_see_dead_people;
> +               }
>          }
> 
>          list_for_each_entry(net, net_exit_list, exit_list) {
> 
> 
> Do you (or anyone else), have some ideas for how to debug this further to help find where the reference
> is leaked (or not released)?

I am now quite sure that the problem I was seeing was caused by an skb leak in the mt76 driver
(for which Felix just found a solution).  After that fix, then I no longer see the nf_conntrack
rmmod hangs.  I will keep testing in case I am just geting (un)lucky.

I do plan to keep my hack/patch in my kernel though, I'd rather it continue and leak some more
memory instead of busy hang forever when skb leaks are hit...

Thanks,
Ben

