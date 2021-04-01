Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A987E35200A
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhDATk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:40:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:57496 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhDATkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 15:40:25 -0400
IronPort-SDR: 3jQmY/vznNcVF7wOR/qWRaOfSAzKwdFOkxmWAuAW8SZGxtmBfV8hExL+PImPb3qgDldXGTBkkI
 oHRex6KHYYdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="212589478"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="212589478"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 12:40:26 -0700
IronPort-SDR: BbUk/UUk2FFtIP8KlQygtPDobPNQPfoJNvKmaXy+KXux+aTaJ+Ajz5YlI8Ld6o1CaHs8HW7Z/x
 iCzuPMDwvGNg==
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="419337883"
Received: from jmurunue-mobl2.amr.corp.intel.com ([10.251.11.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 12:40:25 -0700
Date:   Thu, 1 Apr 2021 12:40:25 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 1/2] mptcp: forbit mcast-related sockopt on MPTCP
 sockets
In-Reply-To: <b7d0edf1f94da07d39e9319cdd78a7863473eacf.1617295578.git.pabeni@redhat.com>
Message-ID: <19889968-a3cb-61eb-1915-12c15133bf32@linux.intel.com>
References: <cover.1617295578.git.pabeni@redhat.com> <b7d0edf1f94da07d39e9319cdd78a7863473eacf.1617295578.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Apr 2021, Paolo Abeni wrote:

> Unrolling mcast state at msk dismantel time is bug prone, as
> syzkaller reported:
>
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.11.0-syzkaller #0 Not tainted
> ------------------------------------------------------
> syz-executor905/8822 is trying to acquire lock:
> ffffffff8d678fe8 (rtnl_mutex){+.+.}-{3:3}, at: ipv6_sock_mc_close+0xd7/0x110 net/ipv6/mcast.c:323
>
> but task is already holding lock:
> ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1600 [inline]
> ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp6_release+0x57/0x130 net/mptcp/protocol.c:3507
>
> which lock already depends on the new lock.
>
> Instead we can simply forbit any mcast-related setsockopt
>
> Fixes: 717e79c867ca5 ("mptcp: Add setsockopt()/getsockopt() socket operations")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 45 ++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 45 insertions(+)
>

Thanks Paolo.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
