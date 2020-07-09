Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B57921A8AC
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgGIUIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgGIUIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:08:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88398C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 13:08:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 33FE5120F19DD;
        Thu,  9 Jul 2020 13:08:39 -0700 (PDT)
Date:   Thu, 09 Jul 2020 13:08:38 -0700 (PDT)
Message-Id: <20200709.130838.1280141169142103459.davem@davemloft.net>
To:     cpaasch@apple.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, weiwan@google.com,
        edumazet@google.com
Subject: Re: [PATCH v2 net] tcp: make sure listeners don't initialize
 congestion-control state
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708231834.55194-1-cpaasch@apple.com>
References: <20200708231834.55194-1-cpaasch@apple.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 13:08:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Paasch <cpaasch@apple.com>
Date: Wed, 08 Jul 2020 16:18:34 -0700

> syzkaller found its way into setsockopt with TCP_CONGESTION "cdg".
> tcp_cdg_init() does a kcalloc to store the gradients. As sk_clone_lock
> just copies all the memory, the allocated pointer will be copied as
> well, if the app called setsockopt(..., TCP_CONGESTION) on the listener.
> If now the socket will be destroyed before the congestion-control
> has properly been initialized (through a call to tcp_init_transfer), we
> will end up freeing memory that does not belong to that particular
> socket, opening the door to a double-free:
...
> Wei Wang fixed a part of these CDG-malloc issues with commit c12014440750
> ("tcp: memset ca_priv data to 0 properly").
> 
> This patch here fixes the listener-scenario: We make sure that listeners
> setting the congestion-control through setsockopt won't initialize it
> (thus CDG never allocates on listeners). For those who use AF_UNSPEC to
> reuse a socket, tcp_disconnect() is changed to cleanup afterwards.
> 
> (The issue can be reproduced at least down to v4.4.x.)
> 
> Cc: Wei Wang <weiwan@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Fixes: 2b0a8c9eee81 ("tcp: add CDG congestion control")
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>

Applied and queued up for -stable, thanks.
