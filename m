Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 622074A7CF
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfFRRD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:03:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRRD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:03:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7ACD6150AFBD5;
        Tue, 18 Jun 2019 10:03:57 -0700 (PDT)
Date:   Tue, 18 Jun 2019 10:03:57 -0700 (PDT)
Message-Id: <20190618.100357.465659839647007124.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix issues with early FAILOVER_MSG from peer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617045612.3509-1-tuong.t.lien@dektech.com.au>
References: <20190617045612.3509-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 10:03:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Mon, 17 Jun 2019 11:56:12 +0700

> It appears that a FAILOVER_MSG can come from peer even when the failure
> link is resetting (i.e. just after the 'node_write_unlock()'...). This
> means the failover procedure on the node has not been started yet.
> The situation is as follows:
 ...
> Once this happens, the link failover procedure will be triggered
> wrongly on the receiving node since the node isn't in FAILINGOVER state
> but then another link failover will be carried out.
> The consequences are:
> 
> 1) A peer might get stuck in FAILINGOVER state because the 'sync_point'
> was set, reset and set incorrectly, the criteria to end the failover
> would not be met, it could keep waiting for a message that has already
> received.
> 
> 2) The early FAILOVER_MSG(s) could be queued in the link failover
> deferdq but would be purged or not pulled out because the 'drop_point'
> was not set correctly.
> 
> 3) The early FAILOVER_MSG(s) could be dropped too.
> 
> 4) The dummy FAILOVER_MSG could make the peer leaving FAILINGOVER state
> shortly, but later on it would be restarted.
> 
> The same situation can also happen when the link is in PEER_RESET state
> and a FAILOVER_MSG arrives.
> 
> The commit resolves the issues by forcing the link down immediately, so
> the failover procedure will be started normally (which is the same as
> when receiving a FAILOVER_MSG and the link is in up state).
> 
> Also, the function "tipc_node_link_failover()" is toughen to avoid such
> a situation from happening.
> 
> Acked-by: Jon Maloy <jon.maloy@ericsson.se>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied, thank you.
