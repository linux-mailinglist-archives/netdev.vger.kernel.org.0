Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7552147930
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 09:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgAXIK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 03:10:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37968 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAXIK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 03:10:26 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 954361584078A;
        Fri, 24 Jan 2020 00:10:24 -0800 (PST)
Date:   Fri, 24 Jan 2020 09:10:19 +0100 (CET)
Message-Id: <20200124.091019.1591871888872198996.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        cambda@linux.alibaba.com, ycheng@google.com, ncardwell@google.com
Subject: Re: [PATCH net] tcp: do not leave dangling pointers in
 tp->highest_sack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200123050300.29767-1-edumazet@google.com>
References: <20200123050300.29767-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jan 2020 00:10:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 22 Jan 2020 21:03:00 -0800

> Latest commit 853697504de0 ("tcp: Fix highest_sack and highest_sack_seq")
> apparently allowed syzbot to trigger various crashes in TCP stack [1]
> 
> I believe this commit only made things easier for syzbot to find
> its way into triggering use-after-frees. But really the bugs
> could lead to bad TCP behavior or even plain crashes even for
> non malicious peers.
> 
> I have audited all calls to tcp_rtx_queue_unlink() and
> tcp_rtx_queue_unlink_and_free() and made sure tp->highest_sack would be updated
> if we are removing from rtx queue the skb that tp->highest_sack points to.
> 
> These updates were missing in three locations :
> 
> 1) tcp_clean_rtx_queue() [This one seems quite serious,
>                           I have no idea why this was not caught earlier]
> 
> 2) tcp_rtx_queue_purge() [Probably not a big deal for normal operations]
> 
> 3) tcp_send_synack()     [Probably not a big deal for normal operations]
> 
> [1]
 ...
> Fixes: 853697504de0 ("tcp: Fix highest_sack and highest_sack_seq")
> Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
> Fixes: 737ff314563c ("tcp: use sequence distance to detect reordering")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks.
