Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1868DEA3ED
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfJ3TQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:16:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44700 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfJ3TQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 15:16:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00E3514B4DFD2;
        Wed, 30 Oct 2019 12:16:57 -0700 (PDT)
Date:   Wed, 30 Oct 2019 12:16:57 -0700 (PDT)
Message-Id: <20191030.121657.2103053708806525889.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, tung.q.nguyen@dektech.com.au,
        hoang.h.le@dektech.com.au, lxin@redhat.com, shuali@redhat.com,
        ying.xue@windriver.com, edumazet@google.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 1/1] tipc: add smart nagle feature
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572440441-474-1-git-send-email-jon.maloy@ericsson.com>
References: <1572440441-474-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 12:16:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Wed, 30 Oct 2019 14:00:41 +0100

> We introduce a feature that works like a combination of TCP_NAGLE and
> TCP_CORK, but without some of the weaknesses of those. In particular,
> we will not observe long delivery delays because of delayed acks, since
> the algorithm itself decides if and when acks are to be sent from the
> receiving peer.
> 
> - The nagle property as such is determined by manipulating a new
>   'maxnagle' field in struct tipc_sock. If certain conditions are met,
>   'maxnagle' will define max size of the messages which can be bundled.
>   If it is set to zero no messages are ever bundled, implying that the
>   nagle property is disabled.
> - A socket with the nagle property enabled enters nagle mode when more
>   than 4 messages have been sent out without receiving any data message
>   from the peer.
> - A socket leaves nagle mode whenever it receives a data message from
>   the peer.
> 
> In nagle mode, messages smaller than 'maxnagle' are accumulated in the
> socket write queue. The last buffer in the queue is marked with a new
> 'ack_required' bit, which forces the receiving peer to send a CONN_ACK
> message back to the sender upon reception.
> 
> The accumulated contents of the write queue is transmitted when one of
> the following events or conditions occur.
> 
> - A CONN_ACK message is received from the peer.
> - A data message is received from the peer.
> - A SOCK_WAKEUP pseudo message is received from the link level.
> - The write queue contains more than 64 1k blocks of data.
> - The connection is being shut down.
> - There is no CONN_ACK message to expect. I.e., there is currently
>   no outstanding message where the 'ack_required' bit was set. As a
>   consequence, the first message added after we enter nagle mode
>   is always sent directly with this bit set.
> 
> This new feature gives a 50-100% improvement of throughput for small
> (i.e., less than MTU size) messages, while it might add up to one RTT
> to latency time when the socket is in nagle mode.
> 
> Acked-by: Ying Xue <ying.xue@windreiver.com>
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Applied, thanks Jon.
