Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8001D6C66
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgEQTgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQTgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:36:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F30C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:36:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1AA70128A2D84;
        Sun, 17 May 2020 12:36:42 -0700 (PDT)
Date:   Sun, 17 May 2020 12:36:41 -0700 (PDT)
Message-Id: <20200517.123641.663719377645438432.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, pabeni@redhat.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net
Subject: Re: [PATCH net-next 0/7] mptcp: do not block on subflow socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200516084623.28453-1-fw@strlen.de>
References: <20200516084623.28453-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 May 2020 12:36:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Sat, 16 May 2020 10:46:16 +0200

> This series reworks mptcp_sendmsg logic to avoid blocking on the subflow
> socket.
> 
> It does so by removing the wait loop from mptcp_sendmsg_frag helper.
> 
> In order to do that, it moves prerequisites that are currently
> handled in mptcp_sendmsg_frag (and cause it to wait until they are
> met, e.g. frag cache refill) into the callers.
> 
> The worker can just reschedule in case no subflow socket is ready,
> since it can't wait -- doing so would block other work items and
> doesn't make sense anyway because we should not (re)send data
> in case resources are already low.
> 
> The sendmsg path can use the existing wait logic until memory
> becomes available.
> 
> Because large send requests can result in multiple mptcp_sendmsg_frag
> calls from mptcp_sendmsg, we may need to restart the socket lookup in
> case subflow can't accept more data or memory is low.
> 
> Doing so blocks on the mptcp socket, and existing wait handling
> releases the msk lock while blocking.
> 
> Lastly, no need to use GFP_ATOMIC for extension allocation:
> extend __skb_ext_alloc with gfp_t arg instead of hard-coded ATOMIC and
> then relax the allocation constraints for mptcp case: those requests
> occur in process context.

Series applied, thanks Florian.
