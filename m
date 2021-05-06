Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307AA3753CD
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 14:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhEFM13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 08:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhEFM12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 08:27:28 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7EAC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 05:26:29 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id h20so3313267plr.4
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 05:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UOr8NafAmOg+SDhHKkNq3pgrPvJaefwJSt/lBDY5Kcc=;
        b=Kst5LGHC9QaQzubCQ3p8U1KOPnZxnmazcaRL3RtTZ4XKjG1EO9L8bPDE8ON/nD0ALt
         rrFfgCVtqkpmxfKvbskzZej+DVkprwD+0JfKJPaupLy2Yosrx3FL3xaxYa2VD1fPwTjM
         LcZ0GDoynN4DDw9rCzPrceIc0spobhD09rnpofIqPh5H0rBRIXjjS8BuC9pqoGSowemx
         5zN/smMvFVLMPSq0jreaaheIN5buB7P05cwM/3xwPZsFfkXyWHgFCPUsvMnBO8PIMeTT
         1iDfIknXdiTIDP+rWApdXStPRZrYhXkHHOe0fHQVfRGRRqEavo6se0fGj7oeDAk7Ei0D
         SHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UOr8NafAmOg+SDhHKkNq3pgrPvJaefwJSt/lBDY5Kcc=;
        b=fWFmEbsD+PRWPYdP/WxS5rmK6qczSyZV4pYcuEd6ATcEPqDVu+tQq9VL1zH0cdO+zN
         u51SUFNihfoWGNueMV7LqRF4aLTF7A4Y7cR9av+AOIyS8hnLn9PBzN7swQgjL/palOJz
         5uk0WqZkLK3+INII2KyWt6IATgJzRLtN+DvNPYLZpJ1952pSBzt0YFU3wHsVpnqUdHbS
         z8Irss65IaMosMydvf8/QFcuwB9TOVKxi5SVVI8h+LrX1CDva41QxZ5w9VdYsObH/Cjm
         s5gbDyHGSFVfHmdkrun+xDk3m5X4M8CvB04mR03Akh/47cU4g1Fg7ifF3Ul8jNi2s3ap
         B8iQ==
X-Gm-Message-State: AOAM533hRlw/4EjWfxGtfGb8Aa2v9PJVpGExpmN36sD7gsk9Yp5NxKRu
        OhVSPnoepn4vBBB/LWltwhk=
X-Google-Smtp-Source: ABdhPJwdhUO8WjXsVzZrqRHm3vkZp5OAAMjl+6bPAlm167Ux5dvbuzaAbADP8CSJONqZ+WVXYMCspA==
X-Received: by 2002:a17:902:7c85:b029:ed:893d:ec7c with SMTP id y5-20020a1709027c85b02900ed893dec7cmr3996469pll.82.1620303989423;
        Thu, 06 May 2021 05:26:29 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id j79sm78937pfd.184.2021.05.06.05.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 05:26:28 -0700 (PDT)
Subject: Re: [Patch net] rtnetlink: use rwsem to protect rtnl_af_ops list
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com
References: <20210505233642.13661-1-xiyou.wangcong@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <d7581cb6-a795-42a3-346a-07ccfa8fc8ce@gmail.com>
Date:   Thu, 6 May 2021 21:26:26 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210505233642.13661-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/21 8:36 AM, Cong Wang wrote:
 > From: Cong Wang <cong.wang@bytedance.com>
 >

Hi Cong,
Thank you so much for fixing it!

 > We use RTNL lock and RCU read lock to protect the global
 > list rtnl_af_ops, however, this forces the af_ops readers
 > being in atomic context while iterating this list,
 > particularly af_ops->set_link_af(). This was not a problem
 > until we begin to take mutex lock down the path in
 > __ipv6_dev_mc_dec().
 >
 > Convert RTNL+RCU to rwsemaphore, so that we can block on
 > the reader side while still allowing parallel readers.
 >
 > Reported-and-tested-by: 
syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com
 > Fixes: 63ed8de4be81 ("mld: add mc_lock for protecting per-interface 
mld data")
 > Cc: Taehee Yoo <ap420073@gmail.com>
 > Signed-off-by: Cong Wang <cong.wang@bytedance.com>

I have been testing this patch and I found a warning
[ 8410.605309] BUG: sleeping function called from invalid context at 
kernel/locking/rwsem.c:1352
[ 8410.607508] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 
6626, name: ip
[ 8410.609507] INFO: lockdep is turned off.
[ 8410.610644] CPU: 5 PID: 6626 Comm: ip Tainted: G        W 
5.12.0+ #881
[ 8410.614943] Call Trace:
[ 8410.615714]  dump_stack+0xa4/0xe5
[ 8410.616692]  ___might_sleep.cold.126+0x140/0x16e
[ 8410.617958]  down_read+0x7b/0x710
[ 8410.618914]  ? lock_release+0x519/0xc30
[ 8410.620005]  ? down_write_killable+0x3b0/0x3b0
[ 8410.621231]  ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
[ 8410.622647]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 8410.624055]  if_nlmsg_size+0x2b2/0x870
[ 8410.625101]  rtnl_calcit.isra.34+0x1db/0x370
[ 8410.626317]  ? if_nlmsg_size+0x870/0x870
[ 8410.627412]  ? lock_release+0x519/0xc30
[ 8410.628497]  ? rtnl_fill_ifinfo+0x3990/0x3990
[ 8410.629716]  rtnetlink_rcv_msg+0x7cf/0x920
[ 8410.630905]  ? rtnetlink_put_metrics+0x450/0x450
[ 8410.632174]  ? lock_release+0x519/0xc30
[ 8410.633271]  ? lock_acquire+0x2a5/0x720
[ 8410.634371]  netlink_rcv_skb+0x121/0x350
[ 8410.635485]  ? rtnetlink_put_metrics+0x450/0x450
[ 8410.636729]  ? slab_post_alloc_hook+0x43/0x430
[ 8410.637993]  ? netlink_ack+0x9d0/0x9d0
[ 8410.639073]  ? _copy_from_iter_full+0x258/0xeb0
[ 8410.640338]  netlink_unicast+0x41c/0x610
[ 8410.641477]  ? netlink_attachskb+0x710/0x710
[ 8410.642624]  ? try_charge+0x2d1/0xfd0
[ 8410.643684]  ? trace_hardirqs_on+0x41/0x120
[ 8410.644859]  netlink_sendmsg+0x6b9/0xb70
[ 8410.645983]  ? netlink_unicast+0x610/0x610
[ 8410.647136]  ? sockfd_lookup_light+0x1c/0x150
[ 8410.648350]  __sys_sendto+0x30b/0x350

