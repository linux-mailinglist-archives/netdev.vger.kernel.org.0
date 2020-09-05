Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A006425E591
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 07:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgIEFOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 01:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgIEFOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 01:14:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94D5208DB;
        Sat,  5 Sep 2020 05:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599282861;
        bh=8yVM5oiCEchg/8Ly4eyCM7pLS76C0Je0cmUGHfx5euA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RabOW790XZgeVcL67W4FZDYkLpsfb+LRuOoSa7m9KDqzL8gpxVOGT8GU8OLRVx8ea
         GVE/O6py0+UTeUHDER5x1Sm3fHctxhz5BIMWdlDMx5QAR7Y5mli3xWIHuWaRwKLt+m
         Ob434w0YuUFfejpYvGE5gWveYxpoXADVNZHEGydA=
Date:   Fri, 4 Sep 2020 22:14:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] act_ife: load meta modules before
 tcf_idr_check_alloc()
Message-ID: <20200904221419.59ba1125@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904021011.27002-1-xiyou.wangcong@gmail.com>
References: <20200904021011.27002-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Sep 2020 19:10:11 -0700 Cong Wang wrote:
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

Vlad, it'd have been nice to see your review tag here.

> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

LGTM, applied and queued for stable, thank you Cong!
