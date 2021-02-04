Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40FD30F49B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 15:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhBDOHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 09:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236596AbhBDOGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 09:06:01 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87EEC06178C
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 06:04:53 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l7fFa-0005wj-O9; Thu, 04 Feb 2021 15:04:50 +0100
Date:   Thu, 4 Feb 2021 15:04:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [iproute PATCH] tc: u32: Fix key folding in sample option
Message-ID: <20210204140450.GS3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210202183051.21022-1-phil@nwl.cc>
 <6948a2a9-1ed2-ce8d-daeb-601c425e1258@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6948a2a9-1ed2-ce8d-daeb-601c425e1258@mojatatu.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal,

On Thu, Feb 04, 2021 at 08:19:55AM -0500, Jamal Hadi Salim wrote:
> I couldnt tell by inspection if what used to work before continues to.
> In particular the kernel version does consider the divisor when folding.

That's correct. And so does tc. What's the matter?

> Two examples that currently work, if you can try them:

Both lack information about the used hashkey and divisor.

> Most used scheme:
> ---
> tc filter add dev $DEV parent 999:0  protocol ip prio 10 u32 \
> ht 2:: \
> sample ip protocol 1 0xff match ip src 1.2.3.4/32 flowid 1:10 \
> action ok
> ----

htid before: 0x201000
htid after: 0x201000

> 
> and this i also found in one of my scripts:
> ----
> tc filter add dev $DEV parent 999:0  protocol ip prio 10 u32 \
> ht 2:: \
> sample u32 0x00000806 0x0000ffff at 12 \
> match u32 0x00000800 0x0000ff00 at 12 flowid 1:10 \
> action ok
> ----

htid before: 0x20e000 (0x8 ^ 0x6 = 0xe)
htid after: 0x206000

Are you sure this still works with current kernel and iproute2
(excluding my patch)? What divisor and hashkey is used?

> Probably a simple meaning of "working" is:
> the values before and after (your changes) are consistent.
> 
> If also you will do us a kindness and add maybe a testcase in tdc?
> This way next person wanting to fix it can run the tests first before
> posting a patch.

What is "tdc"?

Cheers, Phil
