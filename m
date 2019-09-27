Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113C7C0B71
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfI0Sm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:42:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35416 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfI0Sm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:42:59 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86199153F26C2;
        Fri, 27 Sep 2019 11:42:57 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:42:55 +0200 (CEST)
Message-Id: <20190927.204255.1089012302502570397.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, ycheng@google.com,
        marek@cloudflare.com, jmaxwell37@gmail.com
Subject: Re: [PATCH net] tcp: better handle TCP_USER_TIMEOUT in SYN_SENT
 state
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190926224251.249797-1-edumazet@google.com>
References: <20190926224251.249797-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:42:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 26 Sep 2019 15:42:51 -0700

> Yuchung Cheng and Marek Majkowski independently reported a weird
> behavior of TCP_USER_TIMEOUT option when used at connect() time.
> 
> When the TCP_USER_TIMEOUT is reached, tcp_write_timeout()
> believes the flow should live, and the following condition
> in tcp_clamp_rto_to_user_timeout() programs one jiffie timers :
> 
>     remaining = icsk->icsk_user_timeout - elapsed;
>     if (remaining <= 0)
>         return 1; /* user timeout has passed; fire ASAP */
> 
> This silly situation ends when the max syn rtx count is reached.
> 
> This patch makes sure we honor both TCP_SYNCNT and TCP_USER_TIMEOUT,
> avoiding these spurious SYN packets.
> 
> Fixes: b701a99e431d ("tcp: Add tcp_clamp_rto_to_user_timeout() helper to improve accuracy")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Yuchung Cheng <ycheng@google.com>
> Reported-by: Marek Majkowski <marek@cloudflare.com>
> Cc: Jon Maxwell <jmaxwell37@gmail.com>
> Link: https://marc.info/?l=linux-netdev&m=156940118307949&w=2

Applied and queued up for -stable.
