Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF1313792
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 07:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfEDFUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 01:20:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56706 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEDFUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 01:20:15 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5711B14D9FAC7;
        Fri,  3 May 2019 22:20:09 -0700 (PDT)
Date:   Sat, 04 May 2019 01:20:06 -0400 (EDT)
Message-Id: <20190504.012006.508656003426228400.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next] tipc: fix missing Name entries due to half-failover
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502102323.16548-1-tuong.t.lien@dektech.com.au>
References: <20190502102323.16548-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 22:20:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Thu,  2 May 2019 17:23:23 +0700

> TIPC link can temporarily fall into "half-establish" that only one of
> the link endpoints is ESTABLISHED and starts to send traffic, PROTOCOL
> messages, whereas the other link endpoint is not up (e.g. immediately
> when the endpoint receives ACTIVATE_MSG, the network interface goes
> down...).
> 
> This is a normal situation and will be settled because the link
> endpoint will be eventually brought down after the link tolerance time.
> 
> However, the situation will become worse when the second link is
> established before the first link endpoint goes down,
> For example:
> 
>    1. Both links <1A-2A>, <1B-2B> down
>    2. Link endpoint 2A up, but 1A still down (e.g. due to network
>       disturbance, wrong session, etc.)
>    3. Link <1B-2B> up
>    4. Link endpoint 2A down (e.g. due to link tolerance timeout)
>    5. Node B starts failover onto link <1B-2B>
> 
>    ==> Node A does never start link failover.
> 
> When the "half-failover" situation happens, two consequences have been
> observed:
> 
> a) Peer link/node gets stuck in FAILINGOVER state;
> b) Traffic or user messages that peer node is trying to failover onto
> the second link can be partially or completely dropped by this node.
> 
> The consequence a) was actually solved by commit c140eb166d68 ("tipc:
> fix failover problem"), but that commit didn't cover the b). It's due
> to the fact that the tunnel link endpoint has never been prepared for a
> failover, so the 'l->drop_point' (and the other data...) is not set
> correctly. When a TUNNEL_MSG from peer node arrives on the link,
> depending on the inner message's seqno and the current 'l->drop_point'
> value, the message can be dropped (- treated as a duplicate message) or
> processed.
> At this early stage, the traffic messages from peer are likely to be
> NAME_DISTRIBUTORs, this means some name table entries will be missed on
> the node forever!
> 
> The commit resolves the issue by starting the FAILOVER process on this
> node as well. Another benefit from this solution is that we ensure the
> link will not be re-established until the failover ends.
> 
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied, thank you.
