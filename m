Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBFD169BBE
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 02:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBXBZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 20:25:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58282 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgBXBZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 20:25:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BA381340EBEE;
        Sun, 23 Feb 2020 17:25:29 -0800 (PST)
Date:   Sun, 23 Feb 2020 17:25:28 -0800 (PST)
Message-Id: <20200223.172528.2144668063707204291.davem@davemloft.net>
To:     ncardwell@google.com
Cc:     netdev@vger.kernel.org, ycheng@google.com, edumazet@google.com
Subject: Re: [PATCH net] tcp: fix TFO SYNACK undo to avoid
 double-timestamp-undo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200222162116.148681-1-ncardwell@google.com>
References: <20200222162116.148681-1-ncardwell@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 17:25:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>
Date: Sat, 22 Feb 2020 11:21:15 -0500

> In a rare corner case the new logic for undo of SYNACK RTO could
> result in triggering the warning in tcp_fastretrans_alert() that says:
>         WARN_ON(tp->retrans_out != 0);
> 
> The warning looked like:
> 
> WARNING: CPU: 1 PID: 1 at net/ipv4/tcp_input.c:2818 tcp_ack+0x13e0/0x3270
> 
> The sequence that tickles this bug is:
>  - Fast Open server receives TFO SYN with data, sends SYNACK
>  - (client receives SYNACK and sends ACK, but ACK is lost)
>  - server app sends some data packets
>  - (N of the first data packets are lost)
>  - server receives client ACK that has a TS ECR matching first SYNACK,
>    and also SACKs suggesting the first N data packets were lost
>     - server performs TS undo of SYNACK RTO, then immediately
>       enters recovery
>     - buggy behavior then performed a *second* undo that caused
>       the connection to be in CA_Open with retrans_out != 0
> 
> Basically, the incoming ACK packet with SACK blocks causes us to first
> undo the cwnd reduction from the SYNACK RTO, but then immediately
> enters fast recovery, which then makes us eligible for undo again. And
> then tcp_rcv_synrecv_state_fastopen() accidentally performs an undo
> using a "mash-up" of state from two different loss recovery phases: it
> uses the timestamp info from the ACK of the original SYNACK, and the
> undo_marker from the fast recovery.
> 
> This fix refines the logic to only invoke the tcp_try_undo_loss()
> inside tcp_rcv_synrecv_state_fastopen() if the connection is still in
> CA_Loss.  If peer SACKs triggered fast recovery, then
> tcp_rcv_synrecv_state_fastopen() can't safely undo.
> 
> Fixes: 794200d66273 ("tcp: undo cwnd on Fast Open spurious SYNACK retransmit")
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable.
