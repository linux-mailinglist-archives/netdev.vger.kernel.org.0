Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 999C1117327
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfLIRur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:50:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33502 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLIRur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:50:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB744154370BE;
        Mon,  9 Dec 2019 09:50:46 -0800 (PST)
Date:   Mon, 09 Dec 2019 09:50:46 -0800 (PST)
Message-Id: <20191209.095046.1448956021137333118.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net
Subject: Re: [PATCH net] bonding: fix bond_neigh_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191207221034.31268-1-edumazet@google.com>
References: <20191207221034.31268-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 09:50:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat,  7 Dec 2019 14:10:34 -0800

> 1) syzbot reported an uninit-value in bond_neigh_setup() [1]
> 
>  bond_neigh_setup() uses a temporary on-stack 'struct neigh_parms parms',
>  but only clears parms.neigh_setup field.
> 
>  A stacked bonding device would then enter bond_neigh_setup()
>  and read garbage from parms->dev.
> 
>  If we get really unlucky and garbage is matching @dev, then we
>  could recurse and eventually crash.
> 
>  Let's make sure the whole structure is cleared to avoid surprises.
> 
> 2) bond_neigh_setup() can be called while another cpu manipulates
>  the master device, removing or adding a slave.
>  We need at least rcu protection to prevent use-after-free.
> 
> Note: Prior code does not support a stack of bonding devices,
>       this patch does not attempt to fix this, and leave a comment instead.
 ...
> Fixes: 9918d5bf329d ("bonding: modify only neigh_parms owned by us")
> Fixes: 234bcf8a499e ("net/bonding: correctly proxy slave neigh param setup ndo function")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> ---
> 
> Note: needs to be applied after "neighbour: remove neigh_cleanup() method" patch

Aha, now I see this.

I moved the neigh_cleanup() removal to net and applied this too, all queued
up for -stable too.

Thanks.
