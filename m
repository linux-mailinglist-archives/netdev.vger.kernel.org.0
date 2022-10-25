Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3451260D765
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiJYWxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiJYWxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:53:14 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61056A4841
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 15:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666738391; x=1698274391;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=suNiHrJ2/sBXwz4ycG7EH0K3kVTlC72S4qJ6sfruLSQ=;
  b=XdlP3fz9SHEZ363J/BUPRGI6S3fRfWBpiCbfZvIyKGS1J1AZMDPhpoCF
   Evk8PVMVExyYHzzSGqq31scA/wb6zOjcWWDRe7O4Pfo06EbrbVgZBFVyG
   9+H0zLoc5198UtTQNniO6iv7kJxGbKIN7VIHC7z+7hBScCQjoK7eEfm7y
   9ni1bYof9AwvwWH7SEEH6V1YsX9NuQoNpklF+OdcX4gbIrKwyE8VSpFv3
   w1pr5Iu1k2AcGTt4ey0Kqm5gK+PJ06YWUH30IR717XGAiMpNfn3EF5N6h
   B4hHATQu/rv3G6CiKVyrH4Z1RIieJz8nwwCaqsttF9BG6XVmR62ioJrgo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="308903688"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="308903688"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 15:53:11 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="876978107"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="876978107"
Received: from knnguyen-mobl1.amr.corp.intel.com ([10.209.107.240])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 15:53:10 -0700
Date:   Tue, 25 Oct 2022 15:53:10 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Eric Dumazet <edumazet@google.com>
cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH net-next] mptcp: fix tracking issue in
 mptcp_subflow_create_socket()
In-Reply-To: <20221025180546.652251-1-edumazet@google.com>
Message-ID: <b4e63f00-ab23-9926-b943-531caa1ae9ac@linux.intel.com>
References: <20221025180546.652251-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022, Eric Dumazet wrote:

> My recent patch missed that mptcp_subflow_create_socket()
> was creating a 'kernel' socket, then converted it to 'user' socket.
>
> Fixes: 0cafd77dcd03 ("net: add a refcount tracker for kernel sockets")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---

Hi Eric -

I also missed this quirk in MPTCP subflow handling, thanks for the fix:

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>



> net/mptcp/subflow.c | 2 ++
> 1 file changed, 2 insertions(+)
>
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 07dd23d0fe04ac37f4cc66c0c21d4d41f50fb3f4..120f792fda9764271f020771b36d27c6e44d8618 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -1595,7 +1595,9 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
>
> 	/* kernel sockets do not by default acquire net ref, but TCP timer
> 	 * needs it.
> +	 * Update ns_tracker to current stack trace and refcounted tracker.
> 	 */
> +	__netns_tracker_free(net, &sf->sk->ns_tracker, false);
> 	sf->sk->sk_net_refcnt = 1;
> 	get_net_track(net, &sf->sk->ns_tracker, GFP_KERNEL);
> 	sock_inuse_add(net, 1);
> -- 
> 2.38.0.135.g90850a2211-goog
>
>

--
Mat Martineau
Intel
