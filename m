Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2961546FC7
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 01:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244144AbiFJXAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 19:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbiFJXAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 19:00:54 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CB3197619
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 16:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654902053; x=1686438053;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=4tO281xJnv2Vf7p7ZqScbVkcoxNTdyTMoY8bCK9tDuU=;
  b=GbHPYa4U9Xlr3z86IKpIj/+wLbIahs3d6OVBpPiL6kmSja+MnvWtfxLV
   +L9w2PC8dCQU+zHZX4jm02tDFsBXynGozGF1QNuDmPp6pt8C7pEUnQ4cd
   e233nCNTJKh81cmM6BYiFpLCk9ppGrPeMeaplt7s+QIJRXypzG2YH4drn
   0XDYUfpsJr3fAAOxqSjcex3EAqmxS1YcEKOuFM67+e+55muEMnHVnc1qa
   iV8wLfn/L6B6QxsxjqYtaavIzZki2QIOMgEeCmVHRSlo6n5cHbb/4iuvy
   RutAN9EHb38M3+Hd/R5/QuSd8qNFmB+gNwtjXSn4dndYzoi2/W/9y8PpF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="277809453"
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="277809453"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 16:00:52 -0700
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="581291576"
Received: from efbarbud-mobl1.amr.corp.intel.com (HELO csouzax-mobl2.amr.corp.intel.com) ([10.212.104.59])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 16:00:52 -0700
Date:   Fri, 10 Jun 2022 16:00:51 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 6/7] net: keep sk->sk_forward_alloc as small as
 possible
In-Reply-To: <20220609063412.2205738-7-eric.dumazet@gmail.com>
Message-ID: <3029e92-4720-eb49-77e1-ca6fc0a855f3@linux.intel.com>
References: <20220609063412.2205738-1-eric.dumazet@gmail.com> <20220609063412.2205738-7-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jun 2022, Eric Dumazet wrote:

> From: Eric Dumazet <edumazet@google.com>
>
> Currently, tcp_memory_allocated can hit tcp_mem[] limits quite fast.
>
> Each TCP socket can forward allocate up to 2 MB of memory, even after
> flow became less active.
>
> 10,000 sockets can have reserved 20 GB of memory,
> and we have no shrinker in place to reclaim that.
>
> Instead of trying to reclaim the extra allocations in some places,
> just keep sk->sk_forward_alloc values as small as possible.
>
> This should not impact performance too much now we have per-cpu
> reserves: Changes to tcp_memory_allocated should not be too frequent.
>
> For sockets not using SO_RESERVE_MEM:
> - idle sockets (no packets in tx/rx queues) have zero forward alloc.
> - non idle sockets have a forward alloc smaller than one page.
>
> Note:
>
> - Removal of SK_RECLAIM_CHUNK and SK_RECLAIM_THRESHOLD
>   is left to MPTCP maintainers as a follow up.

Yes, noted. Will be sure to clean this up.

Thanks Eric.


>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
> include/net/sock.h           | 29 ++---------------------------
> net/core/datagram.c          |  3 ---
> net/ipv4/tcp.c               |  7 -------
> net/ipv4/tcp_input.c         |  4 ----
> net/ipv4/tcp_timer.c         | 19 ++++---------------
> net/iucv/af_iucv.c           |  2 --
> net/mptcp/protocol.c         |  2 +-
> net/sctp/sm_statefuns.c      |  2 --
> net/sctp/socket.c            |  5 -----
> net/sctp/stream_interleave.c |  2 --
> net/sctp/ulpqueue.c          |  4 ----
> 11 files changed, 7 insertions(+), 72 deletions(-)
>

--
Mat Martineau
Intel
