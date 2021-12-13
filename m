Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDEB473165
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240591AbhLMQQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:16:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58228 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238112AbhLMQQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:16:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A255B81170
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 16:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75B0C34602;
        Mon, 13 Dec 2021 16:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639412158;
        bh=f7afz/4Uy57OvBierwdcWgG76PzVbZlIaTgdiRwTrFY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jLd6Xt2LA7Qw+gWCa7f+8dpq78e6cpWNxI6sSuMVYZQN7O0JmkmbftrNgaiCiQa4Z
         PxO+5YvQJtykuKUAJKEndcQ4oGNtUG436SYljVDRNwYxVHq1HaZzB+K6wH6wNeFS2J
         aKCbCb/mdAfP9Il4MoxgBURGetjrLveUp+CF6U/OO7fy02r7qOucuYcggpb7RpitiV
         zAKX1zohVduVxsHHBTDuNJSy50qx3uxVyaTeQL8jvX2iczUVi7lUXEzlLH3I0iEQf1
         u/GQHyH5zRnnsvGVuZt4b1/ibBkQmT0xXdnTEl9EAiWARvf7qVpKyeMYCF2K9X94ID
         rPA22hl6wpntg==
Date:   Mon, 13 Dec 2021 08:15:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock
 in __dev_xmit_skb() on PREEMPT_RT.
Message-ID: <20211213081556.1a575a28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YbckZ8VxICTThXOn@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
        <20211210203256.09eec931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YbckZ8VxICTThXOn@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Dec 2021 11:45:59 +0100 Sebastian Andrzej Siewior wrote:
> On 2021-12-10 20:32:56 [-0800], Jakub Kicinski wrote:
> > On Fri, 10 Dec 2021 16:41:44 +0100 Sebastian Andrzej Siewior wrote:  
> > > -	contended = qdisc_is_running(q);
> > > +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> > > +		contended = qdisc_is_running(q);
> > > +	else
> > > +		contended = true;  
> > 
> > Why not:
> > 
> > 	contended = qdisc_is_running(q) || IS_ENABLED(CONFIG_PREEMPT_RT);  
> 
> I could do that. But I would swap the two arguments so that the
> IS_ENABLED macro comes first and if true qdisc_is_running() is optimized
> away.

FWIW I disagree. My version was more readable. The sprinkling of the
PREEMPT_RT tosh is getting a little annoying. Trying to regress the 
clarity of the code should be top of mind here.
