Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABE125FA42
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 14:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgIGMO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 08:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729255AbgIGMMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 08:12:44 -0400
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719E5C061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 05:12:43 -0700 (PDT)
Received: from vlad-x1g6 (u5543.alfa-inet.net [62.205.135.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id A3ED8202B0;
        Mon,  7 Sep 2020 15:12:34 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1599480754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cfw1hsZQ2GoLLkPQ7588pgIpqmJQq5HRampRNds2KTw=;
        b=lWhQu+P4xrkbQXOmhYCryLBh5p9FQLIXgru7sWhLHTO/6CUfWNvqOSH/tL8azZ4JDkN/dc
        1GsgIGULaO2MekArm7XFPRG5neOkWPO6kNYJ0GsfjE0hXfjdPaxij+baRAz56RinzhlwOB
        dpXZI2GGiZy8Vu6tBlxi+8bgCzit+qnnLviWEeai3hA8b85mEP4L47k0jNU54naZ2t/+Yi
        ODaeUGYX1vjXoyAwAXT7fUMm4VIiX6CuyDlU5JP3bvBC77pDI77j6BoH6lNNaSxpqe7Wqd
        lvyTKsuMzdTChYYTQI+HSTkLQneZ6HAriF/N0ZNfnGLjvWXSPiysCrAjhnXO5g==
References: <20200904021011.27002-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] act_ife: load meta modules before tcf_idr_check_alloc()
In-reply-to: <20200904021011.27002-1-xiyou.wangcong@gmail.com>
Date:   Mon, 07 Sep 2020 15:12:34 +0300
Message-ID: <87a6y1bxal.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 04 Sep 2020 at 05:10, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> The following deadlock scenario is triggered by syzbot:
>
> Thread A:				Thread B:
> tcf_idr_check_alloc()
> ...
> populate_metalist()
>   rtnl_unlock()
> 					rtnl_lock()
> 					...
>   request_module()			tcf_idr_check_alloc()
>   rtnl_lock()
>
> At this point, thread A is waiting for thread B to release RTNL
> lock, while thread B is waiting for thread A to commit the IDR
> change with tcf_idr_insert() later.
>
> Break this deadlock situation by preloading ife modules earlier,
> before tcf_idr_check_alloc(), this is fine because we only need
> to load modules we need potentially.
>
> Reported-and-tested-by: syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com
> Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Vlad Buslov <vladbu@mellanox.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---

Thanks for fixing this, Cong! I've verified that all tdc ife tests pass
with this patch.

Reviewed-by: Vlad Buslov <vlad@buslov.dev>
Tested-by: Vlad Buslov <vlad@buslov.dev>
