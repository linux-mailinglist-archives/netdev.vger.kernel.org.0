Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7088B1541D1
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 11:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgBFKZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 05:25:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57786 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgBFKZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 05:25:32 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6FE191489E4D0;
        Thu,  6 Feb 2020 02:25:29 -0800 (PST)
Date:   Thu, 06 Feb 2020 11:25:25 +0100 (CET)
Message-Id: <20200206.112525.456289672678472327.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, cpaasch@apple.com
Subject: Re: [PATCH net] mptcp: fix use-after-free for ipv6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200205233937.30596-1-fw@strlen.de>
References: <20200205233937.30596-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 02:25:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu,  6 Feb 2020 00:39:37 +0100

> Turns out that when we accept a new subflow, the newly created
> inet_sk(tcp_sk)->pinet6 points at the ipv6_pinfo structure of the
> listener socket.
> 
> This wasn't caught by the selftest because it closes the accepted fd
> before the listening one.
> 
> adding a close(listenfd) after accept returns is enough:
>  BUG: KASAN: use-after-free in inet6_getname+0x6ba/0x790
>  Read of size 1 at addr ffff88810e310866 by task mptcp_connect/2518
>  Call Trace:
>   inet6_getname+0x6ba/0x790
>   __sys_getpeername+0x10b/0x250
>   __x64_sys_getpeername+0x6f/0xb0
> 
> also alter test program to exercise this.
> 
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian.
