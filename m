Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C64931A61E1
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 06:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgDMEFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 00:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgDMEFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 00:05:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5E5C0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 21:05:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E552127AF28B;
        Sun, 12 Apr 2020 21:05:09 -0700 (PDT)
Date:   Sun, 12 Apr 2020 21:05:08 -0700 (PDT)
Message-Id: <20200412.210508.28307843911867097.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        mptcp@lists.01.org,
        syzbot+e56606435b7bfeea8cf5@syzkaller.appspotmail.com
Subject: Re: [PATCH net] mptcp: fix double-unlock in mptcp_poll
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200411190501.13249-1-fw@strlen.de>
References: <000000000000758fcf05a306a8bf@google.com>
        <20200411190501.13249-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Apr 2020 21:05:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Sat, 11 Apr 2020 21:05:01 +0200

> mptcp_connect/28740 is trying to release lock (sk_lock-AF_INET) at:
> [<ffffffff82c15869>] mptcp_poll+0xb9/0x550
> but there are no more locks to release!
> Call Trace:
>  lock_release+0x50f/0x750
>  release_sock+0x171/0x1b0
>  mptcp_poll+0xb9/0x550
>  sock_poll+0x157/0x470
>  ? get_net_ns+0xb0/0xb0
>  do_sys_poll+0x63c/0xdd0
> 
> Problem is that __mptcp_tcp_fallback() releases the mptcp socket lock,
> but after recent change it doesn't do this in all of its return paths.
> 
> To fix this, remove the unlock from __mptcp_tcp_fallback() and
> always do the unlock in the caller.
> 
> Also add a small comment as to why we have this
> __mptcp_needs_tcp_fallback().
> 
> Fixes: 0b4f33def7bbde ("mptcp: fix tcp fallback crash")
> Reported-by: syzbot+e56606435b7bfeea8cf5@syzkaller.appspotmail.com
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  NB: Reproducer did not trigger for me, so i can't be 100% sure,
>  but looking at the 'Fixes' commit the change to
>  __mptcp_needs_tcp_fallback was broken.

Applied, thanks Florian.
