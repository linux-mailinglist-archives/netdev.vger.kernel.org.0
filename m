Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A536BA8F7
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCOHYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCOHYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:24:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B0F5AB41;
        Wed, 15 Mar 2023 00:24:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B194B81CA2;
        Wed, 15 Mar 2023 07:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD6AC433EF;
        Wed, 15 Mar 2023 07:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678865049;
        bh=3AwyPjsVUvckYCPwQdIh5LbzPKofHco7e2uYe5oPfVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w0AaVRTzGDc1ny20wFXdVxIC92pnn7ThNjd54flnMKxPZ4rW8uoz/zifdDRN5AWch
         SXZt35kK8cQNO+qc7aL+Ul1y7KjSs8fTeV4/TNlGQlkmhry08rIemhg+QbvJYWtufb
         pp8eX1nG8POU6QingmpA5GYj+jn76acc6FmzTJYM=
Date:   Wed, 15 Mar 2023 08:24:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee@kernel.org>
Cc:     Tung Nguyen <tung.q.nguyen@dektech.com.au>, stable@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [STABLE REQUEST] tipc: improve function tipc_wait_for_cond()
Message-ID: <ZBFylYeCT9NjtNDK@kroah.com>
References: <20190219042048.23243-1-tung.q.nguyen@dektech.com.au>
 <20190219042048.23243-2-tung.q.nguyen@dektech.com.au>
 <20230314174537.GA1642994@google.com>
 <ZBC1opyrsZkYb3Gb@kroah.com>
 <20230314180430.GY9667@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314180430.GY9667@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 06:04:30PM +0000, Lee Jones wrote:
> On Tue, 14 Mar 2023, Greg KH wrote:
> 
> > On Tue, Mar 14, 2023 at 05:45:37PM +0000, Lee Jones wrote:
> > > Dear Stable,
> > >
> > > > Commit 844cf763fba6 ("tipc: make macro tipc_wait_for_cond() smp safe")
> > > > replaced finish_wait() with remove_wait_queue() but still used
> > > > prepare_to_wait(). This causes unnecessary conditional
> > > > checking  before adding to wait queue in prepare_to_wait().
> > > >
> > > > This commit replaces prepare_to_wait() with add_wait_queue()
> > > > as the pair function with remove_wait_queue().
> > > >
> > > > Acked-by: Ying Xue <ying.xue@windriver.com>
> > > > Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> > > > Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
> > > > ---
> > > >  net/tipc/socket.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> > > > index 1217c90a363b..81b87916a0eb 100644
> > > > --- a/net/tipc/socket.c
> > > > +++ b/net/tipc/socket.c
> > > > @@ -388,7 +388,7 @@ static int tipc_sk_sock_err(struct socket *sock, long *timeout)
> > > >  		rc_ = tipc_sk_sock_err((sock_), timeo_);		       \
> > > >  		if (rc_)						       \
> > > >  			break;						       \
> > > > -		prepare_to_wait(sk_sleep(sk_), &wait_, TASK_INTERRUPTIBLE);    \
> > > > +		add_wait_queue(sk_sleep(sk_), &wait_);                         \
> > > >  		release_sock(sk_);					       \
> > > >  		*(timeo_) = wait_woken(&wait_, TASK_INTERRUPTIBLE, *(timeo_)); \
> > > >  		sched_annotate_sleep();				               \
> > >
> > > Could we have this ol' classic backported to v4.19 and v4.14 please?
> >
> > What is the git commit id?
> 
> Sorry, it's 223b7329ec6a0.

Now queued up, thanks.

greg k-h
