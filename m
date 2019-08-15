Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 555328F61A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 23:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbfHOVAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 17:00:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50234 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfHOVAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 17:00:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 067591000B022;
        Thu, 15 Aug 2019 14:00:35 -0700 (PDT)
Date:   Thu, 15 Aug 2019 14:00:35 -0700 (PDT)
Message-Id: <20190815.140035.145028724115387751.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net/packet: fix race in tpacket_snd()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814091157.215108-1-edumazet@google.com>
References: <20190814091157.215108-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 14:00:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 14 Aug 2019 02:11:57 -0700

> packet_sendmsg() checks tx_ring.pg_vec to decide
> if it must call tpacket_snd().
> 
> Problem is that the check is lockless, meaning another thread
> can issue a concurrent setsockopt(PACKET_TX_RING ) to flip
> tx_ring.pg_vec back to NULL.
> 
> Given that tpacket_snd() grabs pg_vec_lock mutex, we can
> perform the check again to solve the race.
> 
> syzbot reported :
 ...
> Fixes: 69e3c75f4d54 ("net: TX_RING and packet mmap")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
