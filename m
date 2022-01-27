Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C15A49E517
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbiA0Ota (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242673AbiA0OtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:49:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3A0C06173B;
        Thu, 27 Jan 2022 06:49:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C15B6B821EE;
        Thu, 27 Jan 2022 14:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0155EC340E4;
        Thu, 27 Jan 2022 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643294962;
        bh=7GUpIIjT3Y6Ka+9rlNQeh5Ll/mUbH+UHkWafLK84ylY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fqWaM6v6BABqrDPDtsu+lltqDV7JSlhx2rU5pFaEifYFVODfWgYimo6/zcHO222vX
         kNR0ydUBY2DStqVQGhXFTKrdDO4e561hbTIHOuuUKTmSeCtQHwLTJSDYWoZ+g8uWm2
         DgR+O8A5+WlUkT/slecOK3qxuYvfvaEffB9x66Is=
Date:   Thu, 27 Jan 2022 15:49:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>, mkl@pengutronix.de,
        davem@davemloft.net, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH 4.14] can: bcm: fix UAF of bcm op
Message-ID: <YfKw7+TVJDJGHpoP@kroah.com>
References: <20220122102506.2898032-1-william.xuanziyang@huawei.com>
 <Yevc134xM9BDEyNd@kroah.com>
 <f1e819b6-d37b-286f-85d5-9893a6fdb83e@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1e819b6-d37b-286f-85d5-9893a6fdb83e@hartkopp.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 03:10:01PM +0100, Oliver Hartkopp wrote:
> 
> 
> On 22.01.22 11:30, Greg KH wrote:
> > On Sat, Jan 22, 2022 at 06:25:06PM +0800, Ziyang Xuan wrote:
> > > Stopping tasklet and hrtimer rely on the active state of tasklet and
> > > hrtimer sequentially in bcm_remove_op(), the op object will be freed
> > > if they are all unactive. Assume the hrtimer timeout is short, the
> > > hrtimer cb has been excuted after tasklet conditional judgment which
> > > must be false after last round tasklet_kill() and before condition
> > > hrtimer_active(), it is false when execute to hrtimer_active(). Bug
> > > is triggerd, because the stopping action is end and the op object
> > > will be freed, but the tasklet is scheduled. The resources of the op
> > > object will occur UAF bug.
> > > 
> > > Move hrtimer_cancel() behind tasklet_kill() and switch 'while () {...}'
> > > to 'do {...} while ()' to fix the op UAF problem.
> > > 
> > > Fixes: a06393ed0316 ("can: bcm: fix hrtimer/tasklet termination in bcm op removal")
> > > Reported-by: syzbot+5ca851459ed04c778d1d@syzkaller.appspotmail.com
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> > > ---
> > >   net/can/bcm.c | 20 ++++++++++----------
> > >   1 file changed, 10 insertions(+), 10 deletions(-)
> > 
> > What is the git commit id of this change in Linus's tree?
> 
> Linus' tree has been fixed by removing the tasklet implementation and
> replacing it with a HRTIMER_MODE_SOFT approach here:
> 
> commit bf74aa86e111a ("can: bcm: switch timer to HRTIMER_MODE_SOFT and
> remove hrtimer_tasklet")
> 
> This patch from Ziyang Xuan fixes the 'old' tasklet implementation for 'old'
> stable kernels that lack the HRTIMER_MODE_SOFT infrastructure.
> 
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks, I'll queue this up for 4.14.

Ziyang, can I get a version for 4.19.y as well?

thanks,

greg k-h
