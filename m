Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA28489D8E
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 17:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237474AbiAJQ3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 11:29:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50358 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237471AbiAJQ3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 11:29:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6930B8165F;
        Mon, 10 Jan 2022 16:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D1FC36AE3;
        Mon, 10 Jan 2022 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641832190;
        bh=fQExllmMl+dj2jTx2YMZ1O6mpZuoE8POpJVdkmjVsxg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ilYOMpIgLD+9OxTa8dbe43JdsXgf+Dbdn5x4LowsmAyEse7F2sH9hhuYESf2pcRVA
         LeMbupc1+563Tej1CHOi9Z8e50PhY4k/642DEm8E7b9sbsiPSZlJgL+q8cioKBQ1P2
         XRvloaF69nxoF9vfheyz3WJXaKxBBfXJk83rGykNY9DUJRZ6esExe8WUMdCP/f6HBs
         cxwrd7J4nP8zvLpJgwHfX9y3GMxAiDHVU0Jykzin+kGLtt22Xat69FViPX/gP02ACL
         od7dSmcaKf+YCPrAy6iYN0s5TgDQqiNNSAJFlV1hUfxHmhKAaTKffvhur+plBDTRHU
         jioOaRkvvLNew==
Date:   Mon, 10 Jan 2022 08:29:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Rao Shoaib <rao.shoaib@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
        regressions@lists.linux.dev
Subject: Re: Observation of a memory leak with commit 314001f0bf92
 ("af_unix: Add OOB support")
Message-ID: <20220110082949.3a14a738@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAKXUXMygcVJ2v5enu-KY9_2reC6+aAk8F9q5RiwwNp4wO-prug@mail.gmail.com>
References: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
        <20220109132038.38f8ae4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <a754b7d0-8a20-9730-c439-1660994005d0@leemhuis.info>
        <CAKXUXMygcVJ2v5enu-KY9_2reC6+aAk8F9q5RiwwNp4wO-prug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 17:19:56 +0100 Lukas Bulwahn wrote:
> It's a regression if some application or practical use case running fine on one
> Linux kernel works worse or not at all with a newer version compiled using a
> similar configuration.
> 
> The af_unix functionality without oob support works before
> 314001f0bf92 ("af_unix: Add OOB support").
> The af_unix functionality without oob support works after 314001f0bf92
> ("af_unix: Add OOB support").
> The af_unix with oob support after the new feature with 314001f0bf92
> ("af_unix: Add OOB support") makes a memory leak visible; we do not
> know if this feature even triggers it or just makes it visible.
> 
> Now, if we disable oob support we get a kernel without an observable
> memory leak. However, oob support is added by default, and this makes
> this memory leak visible. So, if oob support is turned into a
> non-default option or nobody ever made use of the oob support before,
> it really does not count as regression at all. The oob support did not
> work before and now it works but just leaks a bit of memory---it is
> potentially a bug, but not a regression. Of course, maybe oob support
> is also just intended to make this memory leak observable, who knows?
> Then, it is not even a bug, but a feature.

I see, thanks for the explanation. It wasn't clear from the "does not
repro on 5.15, does repro on net-next" type of wording that the repro
actually uses the new functionality.

> Thorsten's database is still quite empty, so let us keep tracking the
> progress with regzbot. I guess we cannot mark "issues" in regzbot as a
> true regression or as a bug (an issue that appears with a new
> feature).
> 
> Also, this reproducer is automatically generated, so it barely
> qualifies as "some application or practical use case", but at best as
> some derived "stress test program" or "micro benchmark".
> 
> The syzbot CI and kernel CI database are also planning to track such
> things (once all databases and all the interfaces all work smoothly),
> so in the long term, such issues as this one would not qualify for
> regzbot. For now, many things in these pipelines are still manual and
> hence, triggering and investigation is manual effort, as well as
> manually informing the involved developers, which also means that
> tracking remains manual effort, for which regzbot is probably the
> right new tool for now.

Right, that was my thinking.

> We will learn what should go into regzbot's tracker and what should
> not---as we move on in the community: various information from other
> systems (syzbot, kernel CI, kernel test robot etc.) and their reports
> are also still difficult to add, find, track, bisect etc.
