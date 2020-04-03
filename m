Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A34B19CF60
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 06:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgDCEkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 00:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgDCEkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 00:40:09 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22CA22063A;
        Fri,  3 Apr 2020 04:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585888808;
        bh=MA774hbNnMi8WdldEMlM4hLd52sDWJQ+AHnAQqVzUF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cV85XdIZsxoxqQhT8g5rNSJiaN3iNosjbBnL8tjYcp1e3qqEqcQaB+IelmuCuXbfJ
         yNx0GuIsoBsdXsOrvdGKzRco00L2n59FCUpXW9RomtVz8pyNaN+YW+TsKDxhoJ4dab
         JUD1gAqCVAPvfffoZO9/HDxQoBTrwno1nQYzt56U=
Date:   Fri, 3 Apr 2020 07:40:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, arjan@linux.intel.com, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, netdev@vger.kernel.org,
        itayav@mellanox.com
Subject: Re: [PATCH net] net/sched: Don't print dump stack in event of
 transmission timeout
Message-ID: <20200403044005.GD80989@unreal>
References: <20200402152336.538433-1-leon@kernel.org>
 <20200402.180218.940555077368617365.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402.180218.940555077368617365.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 06:02:18PM -0700, David Miller wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Thu,  2 Apr 2020 18:23:36 +0300
>
> > In event of transmission timeout, the drivers are given an opportunity
> > to recover and continue to work after some in-house cleanups.
> >
> > Such event can be caused by HW bugs, wrong congestion configurations
> > and many more other scenarios. In such case, users are interested to
> > get a simple  "NETDEV WATCHDOG ... " print, which points to the relevant
> > netdevice in trouble.
> >
> > The dump stack printed later was added in the commit b4192bbd85d2
> > ("net: Add a WARN_ON_ONCE() to the transmit timeout function") to give
> > extra information, like list of the modules and which driver is involved.
> >
> > While the latter is already printed in "NETDEV WATCHDOG ... ", the list
> > of modules rarely needed and can be collected later.
> >
> > So let's remove the WARN_ONCE() and make dmesg look more user-friendly in
> > large cluster setups.
>
> Software bugs play into these situations and on at least two or three
> occasions I know that the backtrace hinted at the cause of the bug.
>
> I'm not applying this, sorry.

Dave,

In our case, it is HW bug and I'm looking for a way to silence dump
stack. Do I have any way to avoid WARN here?

It will be a little bit overkill to add some special flag to general
netdev structure just to mark that mlx4 doesn't need this trace.

Thanks
