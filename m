Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30630115E4E
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 20:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfLGTzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 14:55:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42786 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfLGTzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 14:55:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0B4E15421AD8;
        Sat,  7 Dec 2019 11:55:43 -0800 (PST)
Date:   Sat, 07 Dec 2019 11:55:43 -0800 (PST)
Message-Id: <20191207.115543.1000946398725521110.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] inet: protect against too small mtu values.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206044346.155271-1-edumazet@google.com>
References: <20191206044346.155271-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 11:55:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  5 Dec 2019 20:43:46 -0800

> syzbot was once again able to crash a host by setting a very small mtu
> on loopback device.
> 
> Let's make inetdev_valid_mtu() available in include/net/ip.h,
> and use it in ip_setup_cork(), so that we protect both ip_append_page()
> and __ip_append_data()
> 
> Also add a READ_ONCE() when the device mtu is read.
> 
> Pairs this lockless read with one WRITE_ONCE() in __dev_set_mtu(),
> even if other code paths might write over this field.
> 
> Add a big comment in include/linux/netdevice.h about dev->mtu
> needing READ_ONCE()/WRITE_ONCE() annotations.
> 
> Hopefully we will add the missing ones in followup patches.
 ...
> Fixes: 1470ddf7f8ce ("inet: Remove explicit write references to sk/inet in ip_append_data")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks.
