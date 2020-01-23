Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA11465EF
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgAWKoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:44:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56302 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgAWKoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:44:34 -0500
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C8BF153DE704;
        Thu, 23 Jan 2020 02:44:30 -0800 (PST)
Date:   Thu, 23 Jan 2020 11:44:21 +0100 (CET)
Message-Id: <20200123.114421.1414769180741959285.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, ppenkov@google.com, willemb@google.com
Subject: Re: [PATCH net] tun: add mutex_unlock() call and napi.skb clearing
 in tun_get_user()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122170735.4126-1-edumazet@google.com>
References: <20200122170735.4126-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 02:44:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 22 Jan 2020 09:07:35 -0800

> If both IFF_NAPI_FRAGS mode and XDP are enabled, and the XDP program
> consumes the skb, we need to clear the napi.skb (or risk
> a use-after-free) and release the mutex (or risk a deadlock)
> 
> WARNING: lock held when returning to user space!
> 5.5.0-rc6-syzkaller #0 Not tainted
> ------------------------------------------------
> syz-executor.0/455 is leaving the kernel with locks still held!
> 1 lock held by syz-executor.0/455:
>  #0: ffff888098f6e748 (&tfile->napi_mutex){+.+.}, at: tun_get_user+0x1604/0x3fc0 drivers/net/tun.c:1835
> 
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
