Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2207A48D60C
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 11:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiAMKtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 05:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiAMKtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 05:49:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3668C06173F;
        Thu, 13 Jan 2022 02:49:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5340661C32;
        Thu, 13 Jan 2022 10:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102BBC36AE9;
        Thu, 13 Jan 2022 10:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642070979;
        bh=bq34cJO8tc6pvcztKLeXrSKfQ9lyGLeFK6hHX8V4Mx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LctFIvkMb/rNFsgkcRSPWP7CLNeqnc13VZNL6ps9HHfrRFxbOEG3TU/CEs20A4QHH
         1fzLXqoq5HkvbH//xrDKElXIZBzax4Dd5xBvPoQp/W023We1nZEO5x1hkqmw1q4fQM
         hgQ4YNvUo3nej8PtFJ2fvV8KQ7SuMayS2mP7WVJk=
Date:   Thu, 13 Jan 2022 11:49:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, socketcan@hartkopp.net,
        mkl@pengutronix.de, netdev@vger.kernel.org, stable@vger.kernel.org,
        linux-can@vger.kernel.org, tglx@linutronix.de,
        anna-maria@linutronix.de
Subject: Re: [PATCH net] can: bcm: switch timer to HRTIMER_MODE_SOFT and
 remove hrtimer_tasklet
Message-ID: <YeADwHa4blpQFCII@kroah.com>
References: <20220110132322.1726106-1-william.xuanziyang@huawei.com>
 <YdwxtqexaE75uCZ8@kroah.com>
 <afcc8f0c-1aa7-9f43-bf50-b404c954db8b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afcc8f0c-1aa7-9f43-bf50-b404c954db8b@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 10:02:09AM +0800, Ziyang Xuan (William) wrote:
> > On Mon, Jan 10, 2022 at 09:23:22PM +0800, Ziyang Xuan wrote:
> >> From: Thomas Gleixner <tglx@linutronix.de>
> >>
> >> [ commit bf74aa86e111aa3b2fbb25db37e3a3fab71b5b68 upstream ]
> >>
> >> Stop tx/rx cycle rely on the active state of tasklet and hrtimer
> >> sequentially in bcm_remove_op(), the op object will be freed if they
> >> are all unactive. Assume the hrtimer timeout is short, the hrtimer
> >> cb has been excuted after tasklet conditional judgment which must be
> >> false after last round tasklet_kill() and before condition
> >> hrtimer_active(), it is false when execute to hrtimer_active(). Bug
> >> is triggerd, because the stopping action is end and the op object
> >> will be freed, but the tasklet is scheduled. The resources of the op
> >> object will occur UAF bug.
> > 
> > That is not the changelog text of this commit.  Why modify it?
> 
> Above statement is the reason why I want to backport the patch to
> stable tree. Maybe I could give an extra cover-letter to explain
> the details of the problem, but modify the original changelog. Is it?
> 
> > 
> >>
> >> ----------------------------------------------------------------------
> >>
> >> This patch switches the timer to HRTIMER_MODE_SOFT, which executed the
> >> timer callback in softirq context and removes the hrtimer_tasklet.
> >>
> >> Reported-by: syzbot+652023d5376450cc8516@syzkaller.appspotmail.com
> 
> This is the public problem reporter. Do I need to move it to cover-letter
> but here?
> 
> >> Cc: stable@vger.kernel.org # 4.19
> 
> I want to backport the patch to linux-4.19.y stable tree. How do I need to
> modify?

No need, I can take it like this, thanks.

greg k-h
