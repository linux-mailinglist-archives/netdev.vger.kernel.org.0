Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4F94A2E51
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 12:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbiA2Ll5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 06:41:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36758 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbiA2Ll4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 06:41:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90F27B827AB;
        Sat, 29 Jan 2022 11:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B411AC340E5;
        Sat, 29 Jan 2022 11:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643456514;
        bh=++Zd6EN2TNR4Zau6rFyThIqLoRILUgq3HW8r82o/PGE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NhohHItrsU/lkDPvetPAUhNMgILa9xFy4XlXV60T0KSo8bbxVUhCQNFyVtV9khNOT
         prvPsA6zTyOckgG5ZiP7JLv1kjwjLmt9p9Xm/wiTk0ez2hn2aE1FWhxgG25DiGgYX6
         7ZRZwWQHQwfPaVrzDf44CANsMOeeOk1Crr1Jd2q4=
Date:   Sat, 29 Jan 2022 12:41:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH 4.9] can: bcm: fix UAF of bcm op
Message-ID: <YfUn/++keVx5/ez/@kroah.com>
References: <20220128064054.2434068-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128064054.2434068-1-william.xuanziyang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 02:40:54PM +0800, Ziyang Xuan wrote:
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

Both now queued up, thanks.

greg k-h
