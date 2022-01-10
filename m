Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373D04899AE
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiAJNQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:16:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35598 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiAJNQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:16:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37D516118E;
        Mon, 10 Jan 2022 13:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A2BC36AE5;
        Mon, 10 Jan 2022 13:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641820601;
        bh=y6qHHVX40j4JNzuG880v2MSwzAY82M/t0XIpMUjE6o4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oWXqVBbQLSKbj+4VoM737udYizS/E/gawe9L/MhHDBJbE/KnzRzInaD++oOdL87p7
         93/2dUrpkPWSRzyOFAxeuuhGWd/jOLWST+K+9MXAH2/l1aw2ZmQk8pSYASCJtLmQ1+
         7UMOGgSCJxxuq9VOmy4v7FEEeZhXi14m6FMYm34E=
Date:   Mon, 10 Jan 2022 14:16:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, socketcan@hartkopp.net,
        mkl@pengutronix.de, netdev@vger.kernel.org, stable@vger.kernel.org,
        linux-can@vger.kernel.org, tglx@linutronix.de,
        anna-maria@linutronix.de
Subject: Re: [PATCH net] can: bcm: switch timer to HRTIMER_MODE_SOFT and
 remove hrtimer_tasklet
Message-ID: <YdwxtqexaE75uCZ8@kroah.com>
References: <20220110132322.1726106-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110132322.1726106-1-william.xuanziyang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 09:23:22PM +0800, Ziyang Xuan wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> [ commit bf74aa86e111aa3b2fbb25db37e3a3fab71b5b68 upstream ]
> 
> Stop tx/rx cycle rely on the active state of tasklet and hrtimer
> sequentially in bcm_remove_op(), the op object will be freed if they
> are all unactive. Assume the hrtimer timeout is short, the hrtimer
> cb has been excuted after tasklet conditional judgment which must be
> false after last round tasklet_kill() and before condition
> hrtimer_active(), it is false when execute to hrtimer_active(). Bug
> is triggerd, because the stopping action is end and the op object
> will be freed, but the tasklet is scheduled. The resources of the op
> object will occur UAF bug.

That is not the changelog text of this commit.  Why modify it?

> 
> ----------------------------------------------------------------------
> 
> This patch switches the timer to HRTIMER_MODE_SOFT, which executed the
> timer callback in softirq context and removes the hrtimer_tasklet.
> 
> Reported-by: syzbot+652023d5376450cc8516@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org # 4.19
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/can/bcm.c | 156 +++++++++++++++++---------------------------------
>  1 file changed, 52 insertions(+), 104 deletions(-)

What stable kernel tree(s) are you wanting this backported to?

thanks,

greg k-h
