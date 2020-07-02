Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383F9212E81
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgGBVIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgGBVIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:08:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF94C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 14:08:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E15B12826FD3;
        Thu,  2 Jul 2020 14:08:43 -0700 (PDT)
Date:   Thu, 02 Jul 2020 14:08:42 -0700 (PDT)
Message-Id: <20200702.140842.462520120826114986.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        mathieu.desnoyers@efficios.com
Subject: Re: [PATCH net] tcp: md5: allow changing MD5 keys in all socket
 states
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702013933.4157053-1-edumazet@google.com>
References: <20200702013933.4157053-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jul 2020 14:08:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  1 Jul 2020 18:39:33 -0700

> This essentially reverts commit 721230326891 ("tcp: md5: reject TCP_MD5SIG
> or TCP_MD5SIG_EXT on established sockets")
> 
> Mathieu reported that many vendors BGP implementations can
> actually switch TCP MD5 on established flows.
> 
> Quoting Mathieu :
>    Here is a list of a few network vendors along with their behavior
>    with respect to TCP MD5:
> 
>    - Cisco: Allows for password to be changed, but within the hold-down
>      timer (~180 seconds).
>    - Juniper: When password is initially set on active connection it will
>      reset, but after that any subsequent password changes no network
>      resets.
>    - Nokia: No notes on if they flap the tcp connection or not.
>    - Ericsson/RedBack: Allows for 2 password (old/new) to co-exist until
>      both sides are ok with new passwords.
>    - Meta-Switch: Expects the password to be set before a connection is
>      attempted, but no further info on whether they reset the TCP
>      connection on a change.
>    - Avaya: Disable the neighbor, then set password, then re-enable.
>    - Zebos: Would normally allow the change when socket connected.
> 
> We can revert my prior change because commit 9424e2e7ad93 ("tcp: md5: fix potential
> overestimation of TCP option space") removed the leak of 4 kernel bytes to
> the wire that was the main reason for my patch.
> 
> While doing my investigations, I found a bug when a MD5 key is changed, leading
> to these commits that stable teams want to consider before backporting this revert :
> 
>  Commit 6a2febec338d ("tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()")
>  Commit e6ced831ef11 ("tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers")
> 
> Fixes: 721230326891 "tcp: md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on established sockets"
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Applied and queued up for -stable with those other two commits.

Thanks!
