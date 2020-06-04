Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CAB1EEE14
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 01:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgFDXAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 19:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgFDXAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 19:00:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BB5C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 16:00:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E88C211F5F8D1;
        Thu,  4 Jun 2020 16:00:32 -0700 (PDT)
Date:   Thu, 04 Jun 2020 16:00:32 -0700 (PDT)
Message-Id: <20200604.160032.1940917295284318635.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        kuba@kernel.org, mptcp@lists.01.org, edumazet@google.com,
        cpaasch@apple.com
Subject: Re: [PATCH net] inet_connection_sock: clear inet_num out of
 destroy helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cc2adbd7dcc17c44e2858e550302906760b38a0b.1591289527.git.pabeni@redhat.com>
References: <cc2adbd7dcc17c44e2858e550302906760b38a0b.1591289527.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 16:00:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu,  4 Jun 2020 18:55:45 +0200

> Clearing the 'inet_num' field is necessary and safe if and
> only if the socket is not bound. The MPTCP protocol calls
> the destroy helper on bound sockets, as tcp_v{4,6}_syn_recv_sock
> completed successfully.
> 
> Move the clearing of such field out of the common code, otherwise
> the MPTCP MP_JOIN error path will find the wrong 'inet_num' value
> on socket disposal, __inet_put_port() will acquire the wrong lock
> and bind_node removal could race with other modifiers possibly
> corrupting the bind hash table.
> 
> Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
> Fixes: 729cd6436f35 ("mptcp: cope better with MP_JOIN failure")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks Paolo.
