Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DEFDBA61
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 02:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441852AbfJRABJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 20:01:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbfJRABJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 20:01:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EF2F1433FC52;
        Thu, 17 Oct 2019 17:01:08 -0700 (PDT)
Date:   Thu, 17 Oct 2019 17:01:08 -0700 (PDT)
Message-Id: <20191017.170108.328402494902327524.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     walteste@inf.ethz.ch, bcodding@redhat.com, gsierohu@redhat.com,
        nforro@redhat.com, edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] ipv4: Return -ENETUNREACH if we can't create
 route but saddr is valid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <25812471222471a51caf0a749c7bbc321047ae5e.1571251375.git.sbrivio@redhat.com>
References: <25812471222471a51caf0a749c7bbc321047ae5e.1571251375.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 17:01:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Wed, 16 Oct 2019 20:52:09 +0200

> ...instead of -EINVAL. An issue was found with older kernel versions
> while unplugging a NFS client with pending RPCs, and the wrong error
> code here prevented it from recovering once link is back up with a
> configured address.
> 
> Incidentally, this is not an issue anymore since commit 4f8943f80883
> ("SUNRPC: Replace direct task wakeups from softirq context"), included
> in 5.2-rc7, had the effect of decoupling the forwarding of this error
> by using SO_ERROR in xs_wake_error(), as pointed out by Benjamin
> Coddington.
> 
> To the best of my knowledge, this isn't currently causing any further
> issue, but the error code doesn't look appropriate anyway, and we
> might hit this in other paths as well.
> 
> In detail, as analysed by Gonzalo Siero, once the route is deleted
> because the interface is down, and can't be resolved and we return
> -EINVAL here, this ends up, courtesy of inet_sk_rebuild_header(),
> as the socket error seen by tcp_write_err(), called by
> tcp_retransmit_timer().
> 
> In turn, tcp_write_err() indirectly calls xs_error_report(), which
> wakes up the RPC pending tasks with a status of -EINVAL. This is then
> seen by call_status() in the SUN RPC implementation, which aborts the
> RPC call calling rpc_exit(), instead of handling this as a
> potentially temporary condition, i.e. as a timeout.
> 
> Return -EINVAL only if the input parameters passed to
> ip_route_output_key_hash_rcu() are actually invalid (this is the case
> if the specified source address is multicast, limited broadcast or
> all zeroes), but return -ENETUNREACH in all cases where, at the given
> moment, the given source address doesn't allow resolving the route.
> 
> While at it, drop the initialisation of err to -ENETUNREACH, which
> was added to __ip_route_output_key() back then by commit
> 0315e3827048 ("net: Fix behaviour of unreachable, blackhole and
> prohibit routes"), but actually had no effect, as it was, and is,
> overwritten by the fib_lookup() return code assignment, and anyway
> ignored in all other branches, including the if (fl4->saddr) one:
> I find this rather confusing, as it would look like -ENETUNREACH is
> the "default" error, while that statement has no effect.
> 
> Also note that after commit fc75fc8339e7 ("ipv4: dont create routes
> on down devices"), we would get -ENETUNREACH if the device is down,
> but -EINVAL if the source address is specified and we can't resolve
> the route, and this appears to be rather inconsistent.
> 
> Reported-by: Stefan Walter <walteste@inf.ethz.ch>
> Analysed-by: Benjamin Coddington <bcodding@redhat.com>
> Analysed-by: Gonzalo Siero <gsierohu@redhat.com>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Applied and queued up for -stable.
