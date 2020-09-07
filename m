Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7652126037C
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbgIGRuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729267AbgIGMNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 08:13:41 -0400
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04A2C061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 05:13:22 -0700 (PDT)
Received: from vlad-x1g6 (u5543.alfa-inet.net [62.205.135.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id CB73E202B0;
        Mon,  7 Sep 2020 15:13:19 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1599480800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5jQ/aX4Qeixmadl4lw1KDXugs5vnxp2fcwugoOy9FzE=;
        b=ubn4dNS4aYONFSSLAM4vtKb6YtTDuf2N7kN45rLaY3/H2E3RNeBUWT9rWVRt/juoASad2b
        sHhV+08opzIf72umZh/gBxoyWFFe/pSjTJ3q/UjMILmigOvkQvUqaFGwUYW0dSXOYz7sJB
        WPHlSFdpqsExe/KX0CcHxEPtCICB3BPow+T+W4MXW48/K3EfwOvVyKyH+1wjuBvWSTMcHL
        7ZA1Gz/Kr3lLLmvWAWAB1//Tl5DSzU/DFZVjWY+U3pXjLJCJzxhFdstOvrECJ4P1oIE0+v
        jINQlkfdQFBAjDysLqhmioLEiKRvu1jsxdzyIynglnjKMDwcyVgnhb6K+lqvlQ==
References: <20200904021011.27002-1-xiyou.wangcong@gmail.com> <20200904221419.59ba1125@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] act_ife: load meta modules before tcf_idr_check_alloc()
In-reply-to: <20200904221419.59ba1125@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 07 Sep 2020 15:13:19 +0300
Message-ID: <877dt5bx9c.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 05 Sep 2020 at 08:14, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu,  3 Sep 2020 19:10:11 -0700 Cong Wang wrote:
>> The following deadlock scenario is triggered by syzbot:
>> 
>> Thread A:				Thread B:
>> tcf_idr_check_alloc()
>> ...
>> populate_metalist()
>>   rtnl_unlock()
>> 					rtnl_lock()
>> 					...
>>   request_module()			tcf_idr_check_alloc()
>>   rtnl_lock()
>> 
>> At this point, thread A is waiting for thread B to release RTNL
>> lock, while thread B is waiting for thread A to commit the IDR
>> change with tcf_idr_insert() later.
>> 
>> Break this deadlock situation by preloading ife modules earlier,
>> before tcf_idr_check_alloc(), this is fine because we only need
>> to load modules we need potentially.
>> 
>> Reported-and-tested-by: syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com
>> Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
>> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
>> Cc: Vlad Buslov <vladbu@mellanox.com>
>
> Vlad, it'd have been nice to see your review tag here.

Reviewed. Sorry for the delay.

>
>> Cc: Jiri Pirko <jiri@resnulli.us>
>> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>
> LGTM, applied and queued for stable, thank you Cong!

