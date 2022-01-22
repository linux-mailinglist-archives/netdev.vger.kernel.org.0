Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF41496BAD
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 11:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiAVKay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 05:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiAVKax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 05:30:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA2DC06173B;
        Sat, 22 Jan 2022 02:30:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81A5EB81B8D;
        Sat, 22 Jan 2022 10:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCF9C004E1;
        Sat, 22 Jan 2022 10:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642847450;
        bh=gUZn2Gk16JowLLdk/g3spcvb8uldFBnKHG6Enfkbk7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kHyXILn2km7d7Ozr48FjUxsiPKUJOq7s+8xrvXSlittqqNcpulQw9gF0h1yoiwZ7O
         c7lb3lnU0bE2vOvrGatBrpXJRe6XXILbCfg8p1eLc9vgzOLnmQXOMd9sUFYs8NSz/Q
         OwvD2GhS35ngzecbe+mfjxsslqoXakhe6nWiHD6k=
Date:   Sat, 22 Jan 2022 11:30:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH 4.14] can: bcm: fix UAF of bcm op
Message-ID: <Yevc134xM9BDEyNd@kroah.com>
References: <20220122102506.2898032-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122102506.2898032-1-william.xuanziyang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 22, 2022 at 06:25:06PM +0800, Ziyang Xuan wrote:
> Stopping tasklet and hrtimer rely on the active state of tasklet and
> hrtimer sequentially in bcm_remove_op(), the op object will be freed
> if they are all unactive. Assume the hrtimer timeout is short, the
> hrtimer cb has been excuted after tasklet conditional judgment which
> must be false after last round tasklet_kill() and before condition
> hrtimer_active(), it is false when execute to hrtimer_active(). Bug
> is triggerd, because the stopping action is end and the op object
> will be freed, but the tasklet is scheduled. The resources of the op
> object will occur UAF bug.
> 
> Move hrtimer_cancel() behind tasklet_kill() and switch 'while () {...}'
> to 'do {...} while ()' to fix the op UAF problem.
> 
> Fixes: a06393ed0316 ("can: bcm: fix hrtimer/tasklet termination in bcm op removal")
> Reported-by: syzbot+5ca851459ed04c778d1d@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/can/bcm.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

What is the git commit id of this change in Linus's tree?

thanks,

greg k-h
