Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4D634748B
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 10:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhCXJ0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 05:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234735AbhCXJ0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 05:26:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEF6061A02;
        Wed, 24 Mar 2021 09:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616577977;
        bh=6wiIThzSkVnF7qtv1l/O8z77Ue/yw9XMyIc65XSUbi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hFWkBGMgO6ReKOD1zxIBOsFedXhuo0yRN9qBEyxCDO7/tyEGiy7V7xAgP5W9pSLm8
         McTPFwuBA7DK9NrpuGDd43ZKOC1kjJmvFSS3uE9eihNwLJ3aKiUyod9maCk+0QkNgj
         dYfB1EKitdWzQT93Rqv9qWNXBJU/KtNg2uhveNbs=
Date:   Wed, 24 Mar 2021 10:26:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.10 104/157] mptcp: put subflow sock on connect error
Message-ID: <YFsFt1+5do3d0iTH@kroah.com>
References: <20210322121933.746237845@linuxfoundation.org>
 <20210322121937.071435221@linuxfoundation.org>
 <CA+G9fYvRM+9DmGuKM0ErDnrYBOmZ6zzmMkrWevMJqOzhejWwZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvRM+9DmGuKM0ErDnrYBOmZ6zzmMkrWevMJqOzhejWwZg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 02:02:06PM +0530, Naresh Kamboju wrote:
> On Mon, 22 Mar 2021 at 18:15, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Florian Westphal <fw@strlen.de>
> >
> > [ Upstream commit f07157792c633b528de5fc1dbe2e4ea54f8e09d4 ]
> >
> > mptcp_add_pending_subflow() performs a sock_hold() on the subflow,
> > then adds the subflow to the join list.
> >
> > Without a sock_put the subflow sk won't be freed in case connect() fails.
> >
> > unreferenced object 0xffff88810c03b100 (size 3000):
> > [..]
> >     sk_prot_alloc.isra.0+0x2f/0x110
> >     sk_alloc+0x5d/0xc20
> >     inet6_create+0x2b7/0xd30
> >     __sock_create+0x17f/0x410
> >     mptcp_subflow_create_socket+0xff/0x9c0
> >     __mptcp_subflow_connect+0x1da/0xaf0
> >     mptcp_pm_nl_work+0x6e0/0x1120
> >     mptcp_worker+0x508/0x9a0
> >
> > Fixes: 5b950ff4331ddda ("mptcp: link MPC subflow into msk only after accept")
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I have reported the following warnings and kernel crash on 5.10.26-rc2 [1]
> The bisect reported that issue pointing out to this commit.
> 
> commit 460916534896e6d4f80a37152e0948db33376873
> mptcp: put subflow sock on connect error
> 
> This problem is specific to 5.10.26-rc2.

Thank you for tracking this down!
