Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74936278D2E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgIYPvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgIYPvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:51:18 -0400
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70441C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 08:51:18 -0700 (PDT)
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id B9DE01F99E;
        Fri, 25 Sep 2020 18:51:15 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1601049076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xh+91DUBFHEqAG36hmtZtaljP6GXNa+l5Ayve7N7IPg=;
        b=UqANSCXG6VPfIeOCqi9xS/1U7a3s0eVEyl5BRRl4IptH8Mve7EUgmxUlsE3MtntuCsCvT2
        qXC2g2KoWtk36/UljhOJBRrMeUOtLx0prrS9CnSRpFdDHrcG3dGPCSU5H9aoLKXOxWv8Ve
        AAdv1Hr3Y1/jgtvTA98yFjl0wt+HD7gcE4ANg8hvVBYUj51IazEclZiQQUY67FCHPpbnIJ
        m3l8potXJF+LR3VbKGHXLR0q16s6I+4MXjRHZ5RKxEGEvyTeNcLSscQzwAVLYGHb9dWwlo
        aFCrwnwj3engMEjVif7AhUKFKKQ0ui1NZ1no4QO66zkMOKZQ+NiGzT7Hn3kE8g==
References: <20200923035624.7307-1-xiyou.wangcong@gmail.com> <20200923035624.7307-3-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+2287853d392e4b42374a@syzkaller.appspotmail.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net 2/2] net_sched: commit action insertions together
In-reply-to: <20200923035624.7307-3-xiyou.wangcong@gmail.com>
Date:   Fri, 25 Sep 2020 18:51:15 +0300
Message-ID: <874knl97nw.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 23 Sep 2020 at 06:56, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> syzbot is able to trigger a failure case inside the loop in
> tcf_action_init(), and when this happens we clean up with
> tcf_action_destroy(). But, as these actions are already inserted
> into the global IDR, other parallel process could free them
> before tcf_action_destroy(), then we will trigger a use-after-free.
>
> Fix this by deferring the insertions even later, after the loop,
> and committing all the insertions in a separate loop, so we will
> never fail in the middle of the insertions any more.
>
> One side effect is that the window between alloction and final
> insertion becomes larger, now it is more likely that the loop in
> tcf_del_walker() sees the placeholder -EBUSY pointer. So we have
> to check for error pointer in tcf_del_walker().
>
> Reported-and-tested-by: syzbot+2287853d392e4b42374a@syzkaller.appspotmail.com
> Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
> Cc: Vlad Buslov <vladbu@mellanox.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---

Reviewed-by: Vlad Buslov <vlad@buslov.dev>
