Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D117F3AD68
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 05:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbfFJDEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 23:04:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49062 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFJDEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 23:04:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6580614EAF650;
        Sun,  9 Jun 2019 20:04:33 -0700 (PDT)
Date:   Sun, 09 Jun 2019 20:04:32 -0700 (PDT)
Message-Id: <20190609.200432.128713001997279882.davem@davemloft.net>
To:     ycheng@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, edumazet@google.com
Subject: Re: [PATCH net] tcp: fix undo spurious SYNACK in passive Fast Open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190608012633.107118-1-ycheng@google.com>
References: <20190608012633.107118-1-ycheng@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 20:04:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>
Date: Fri,  7 Jun 2019 18:26:33 -0700

> Commit 794200d66273 ("tcp: undo cwnd on Fast Open spurious SYNACK
> retransmit") may cause tcp_fastretrans_alert() to warn about pending
> retransmission in Open state. This is triggered when the Fast Open
> server both sends data and has spurious SYNACK retransmission during
> the handshake, and the data packets were lost or reordered.
> 
> The root cause is a bit complicated:
> 
> (1) Upon receiving SYN-data: a full socket is created with
>     snd_una = ISN + 1 by tcp_create_openreq_child()
> 
> (2) On SYNACK timeout the server/sender enters CA_Loss state.
> 
> (3) Upon receiving the final ACK to complete the handshake, sender
>     does not mark FLAG_SND_UNA_ADVANCED since (1)
> 
>     Sender then calls tcp_process_loss since state is CA_loss by (2)
> 
> (4) tcp_process_loss() does not invoke undo operations but instead
>     mark REXMIT_LOST to force retransmission
> 
> (5) tcp_rcv_synrecv_state_fastopen() calls tcp_try_undo_loss(). It
>     changes state to CA_Open but has positive tp->retrans_out
> 
> (6) Next ACK triggers the WARN_ON in tcp_fastretrans_alert()
> 
> The step that goes wrong is (4) where the undo operation should
> have been invoked because the ACK successfully acknowledged the
> SYN sequence. This fixes that by specifically checking undo
> when the SYN-ACK sequence is acknowledged. Then after
> tcp_process_loss() the state would be further adjusted based
> in tcp_fastretrans_alert() to avoid triggering the warning in (6).
> 
> Fixes: 794200d66273 ("tcp: undo cwnd on Fast Open spurious SYNACK retransmit")
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>

Applied, thank you.
