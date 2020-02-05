Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A10F1531DF
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 14:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgBENbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 08:31:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47020 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgBENbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 08:31:01 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE427158E6343;
        Wed,  5 Feb 2020 05:30:59 -0800 (PST)
Date:   Wed, 05 Feb 2020 14:30:58 +0100 (CET)
Message-Id: <20200205.143058.1599098684086589259.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net
Subject: Re: [PATCH net] bonding/alb: properly access headers in
 bond_alb_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200205032605.242866-1-edumazet@google.com>
References: <20200205032605.242866-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 05:31:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  4 Feb 2020 19:26:05 -0800

> syzbot managed to send an IPX packet through bond_alb_xmit()
> and af_packet and triggered a use-after-free.
> 
> First, bond_alb_xmit() was using ipx_hdr() helper to reach
> the IPX header, but ipx_hdr() was using the transport offset
> instead of the network offset. In the particular syzbot
> report transport offset was 0xFFFF
> 
> This patch removes ipx_hdr() since it was only (mis)used from bonding.
> 
> Then we need to make sure IPv4/IPv6/IPX headers are pulled
> in skb->head before dereferencing anything.
> 
> BUG: KASAN: use-after-free in bond_alb_xmit+0x153a/0x1590 drivers/net/bonding/bond_alb.c:1452
> Read of size 2 at addr ffff8801ce56dfff by task syz-executor.2/18108
>  (if (ipx_hdr(skb)->ipx_checksum != IPX_NO_CHECKSUM) ...)
 ...
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

I had to read this one over a few times, but looks good.

Applied and queued up for -stable, thanks.
