Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F20B05CA
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 00:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfIKWyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 18:54:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49938 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfIKWyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 18:54:19 -0400
Received: from localhost (unknown [88.214.186.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9CD7F154FCED5;
        Wed, 11 Sep 2019 15:54:18 -0700 (PDT)
Date:   Thu, 12 Sep 2019 00:54:17 +0200 (CEST)
Message-Id: <20190912.005417.251757766535771790.davem@davemloft.net>
To:     ncardwell@google.com
Cc:     netdev@vger.kernel.org, ycheng@google.com, soheil@google.com,
        edumazet@google.com
Subject: Re: [PATCH net] tcp: fix tcp_ecn_withdraw_cwr() to clear
 TCP_ECN_QUEUE_CWR
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190909205602.248472-1-ncardwell@google.com>
References: <20190909205602.248472-1-ncardwell@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 15:54:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>
Date: Mon,  9 Sep 2019 16:56:02 -0400

> Fix tcp_ecn_withdraw_cwr() to clear the correct bit:
> TCP_ECN_QUEUE_CWR.
> 
> Rationale: basically, TCP_ECN_DEMAND_CWR is a bit that is purely about
> the behavior of data receivers, and deciding whether to reflect
> incoming IP ECN CE marks as outgoing TCP th->ece marks. The
> TCP_ECN_QUEUE_CWR bit is purely about the behavior of data senders,
> and deciding whether to send CWR. The tcp_ecn_withdraw_cwr() function
> is only called from tcp_undo_cwnd_reduction() by data senders during
> an undo, so it should zero the sender-side state,
> TCP_ECN_QUEUE_CWR. It does not make sense to stop the reflection of
> incoming CE bits on incoming data packets just because outgoing
> packets were spuriously retransmitted.
> 
> The bug has been reproduced with packetdrill to manifest in a scenario
> with RFC3168 ECN, with an incoming data packet with CE bit set and
> carrying a TCP timestamp value that causes cwnd undo. Before this fix,
> the IP CE bit was ignored and not reflected in the TCP ECE header bit,
> and sender sent a TCP CWR ('W') bit on the next outgoing data packet,
> even though the cwnd reduction had been undone.  After this fix, the
> sender properly reflects the CE bit and does not set the W bit.
> 
> Note: the bug actually predates 2005 git history; this Fixes footer is
> chosen to be the oldest SHA1 I have tested (from Sep 2007) for which
> the patch applies cleanly (since before this commit the code was in a
> .h file).
> 
> Fixes: bdf1ee5d3bd3 ("[TCP]: Move code from tcp_ecn.h to tcp*.c and tcp.h & remove it")
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks Neal.
