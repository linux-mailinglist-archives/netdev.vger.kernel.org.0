Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9AC51B198
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 00:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346050AbiEDWJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 18:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379043AbiEDWJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 18:09:26 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D22219F
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651701949; x=1683237949;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Wjl5CUBGON7BL43KS5pqq+KeTvR1Ilqkh6+3zbaW7OM=;
  b=Dtlk5Q6gEs7h8AjPHx9Uj96vQoFLxSbiVby1vOfFVjLWkPz394FakCvY
   b5AuuJk1A/yogc+zCqn/8ISPTWpPjzOz9k2lF8Cgm2TlZ0YRUzhg+bfB/
   9/sELCSw7/FPFxVdwc/gmI2d50rOCUNYTBRhy0ft8dKdCKdrr8b6q6MCF
   DBj3p5bA7t/AirNkrrsSODtvQdzn9vt7J8K1w77z5BFzc+SZzZ6WS8a6q
   C0RvqU41jUZmd57j35Rr9RBBbaDS36uGtg0bQyiFvy3JHFsgIEJFsa7m1
   vDrLzEDvV3cly1BVWXVtrcVyxTT0XMFMzfv+tJn5qljTVSTNROBHEwkJZ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="328451557"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="328451557"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:05:48 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="621005205"
Received: from jsbradle-mobl1.amr.corp.intel.com ([10.212.185.245])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:05:47 -0700
Date:   Wed, 4 May 2022 15:05:45 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 0/5] mptcp: Improve MPTCP-level window
 tracking
In-Reply-To: <20220504215408.349318-1-mathew.j.martineau@linux.intel.com>
Message-ID: <73fb3f63-c10-2c9c-91a0-3567a838512@linux.intel.com>
References: <20220504215408.349318-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 4 May 2022, Mat Martineau wrote:

> This series improves MPTCP receive window compliance with RFC 8684 and
> helps increase throughput on high-speed links. Note that patch 3 makes a
> change in tcp_output.c
>
> For the details, Paolo says:
>
> I've been chasing bad/unstable performance with multiple subflows
> on very high speed links.
>
> It looks like the root cause is due to the current mptcp-level
> congestion window handling. There are apparently a few different
> sub-issues:
>
> - the rcv_wnd is not effectively shared on the tx side, as each
>  subflow takes in account only the value received by the underlaying
>  TCP connection. This is addressed in patch 1/4

I missed a couple of small edits - this should be "patch 1/5"...

>
> - The mptcp-level offered wnd right edge is currently allowed to shrink.
>  Reading section 3.3.4.:
>
> """
>   The receive window is relative to the DATA_ACK.  As in TCP, a
>   receiver MUST NOT shrink the right edge of the receive window (i.e.,
>   DATA_ACK + receive window).  The receiver will use the data sequence
>   number to tell if a packet should be accepted at the connection
>   level.
> """
>
> I read the above as we need to reflect window right-edge tracking
> on the wire, see patch 4/5.
>
> - The offered window right edge tracking can happen concurrently on
>  multiple subflows, but there is no mutex protection. We need an
>  additional atomic operation - still patch 3/4

...and this "patch 4/5".

- Mat

>
> This series additionally bumps a few new MIBs to track all the above
> (ensure/observe that the suspected races actually take place).
>
> I could not access again the host where the issue was so
> noticeable, still in the current setup the tput changes from
> [6-18] Gbps to 19Gbps very stable.
>
>
> Paolo Abeni (5):
>  mptcp: really share subflow snd_wnd
>  mptcp: add mib for xmit window sharing
>  tcp: allow MPTCP to update the announced window
>  mptcp: never shrink offered window
>  mptcp: add more offered MIBs counter
>
> include/net/mptcp.h   |  2 +-
> net/ipv4/tcp_output.c | 14 ++++++-----
> net/mptcp/mib.c       |  4 +++
> net/mptcp/mib.h       |  6 +++++
> net/mptcp/options.c   | 58 +++++++++++++++++++++++++++++++++++++------
> net/mptcp/protocol.c  | 32 +++++++++++++++---------
> net/mptcp/protocol.h  |  2 +-
> 7 files changed, 90 insertions(+), 28 deletions(-)
>
>
> base-commit: a37f37a2e7f5ea3ae2a1278f552aa21a8e32c221
> -- 
> 2.36.0
>
>

--
Mat Martineau
Intel
