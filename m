Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915DC6B9DD0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjCNSEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCNSEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:04:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC66A0F16;
        Tue, 14 Mar 2023 11:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 055FB6187A;
        Tue, 14 Mar 2023 18:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E3FC433D2;
        Tue, 14 Mar 2023 18:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678817075;
        bh=wu6X3gPI/hIU0QOGg6AY3AuhGQQOgWXBa5uRUVDWnnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sr0CSaRyqsbLYuxEs73gvW0v9Bv+eX56sZNzyAp5yiOHoOFZ/6wiKH09+sSM83VYt
         ouomMg+sw6PeEskYx2DJ5Ib4aRRwdJLBxZiseKWxZNtDZepQ0LwMVeGCEYEUXRjwPB
         9SRBEHzJ3JES3myjQI/EsOBgavNQb5KcGVJ5bIkOcjGdiMz1Cw4Hx+1q8260ePFp6a
         rCjEfhI5QEYZ8ca05nQJpi3PEUA4+2nx0OowQtBdxnqnNCkz3F/AwDCUVmHOUcKBiY
         7wDMFeRQH5wfKhe5jOmgfWJd33SnzXGqd3xM8RgswSMlRh1etiLVy2ej+ds9Mq+6h7
         kTSYsKv67J5Fw==
Date:   Tue, 14 Mar 2023 18:04:30 +0000
From:   Lee Jones <lee@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Tung Nguyen <tung.q.nguyen@dektech.com.au>, stable@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [STABLE REQUEST] tipc: improve function tipc_wait_for_cond()
Message-ID: <20230314180430.GY9667@google.com>
References: <20190219042048.23243-1-tung.q.nguyen@dektech.com.au>
 <20190219042048.23243-2-tung.q.nguyen@dektech.com.au>
 <20230314174537.GA1642994@google.com>
 <ZBC1opyrsZkYb3Gb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBC1opyrsZkYb3Gb@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023, Greg KH wrote:

> On Tue, Mar 14, 2023 at 05:45:37PM +0000, Lee Jones wrote:
> > Dear Stable,
> >
> > > Commit 844cf763fba6 ("tipc: make macro tipc_wait_for_cond() smp safe")
> > > replaced finish_wait() with remove_wait_queue() but still used
> > > prepare_to_wait(). This causes unnecessary conditional
> > > checking  before adding to wait queue in prepare_to_wait().
> > >
> > > This commit replaces prepare_to_wait() with add_wait_queue()
> > > as the pair function with remove_wait_queue().
> > >
> > > Acked-by: Ying Xue <ying.xue@windriver.com>
> > > Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> > > Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
> > > ---
> > >  net/tipc/socket.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> > > index 1217c90a363b..81b87916a0eb 100644
> > > --- a/net/tipc/socket.c
> > > +++ b/net/tipc/socket.c
> > > @@ -388,7 +388,7 @@ static int tipc_sk_sock_err(struct socket *sock, long *timeout)
> > >  		rc_ = tipc_sk_sock_err((sock_), timeo_);		       \
> > >  		if (rc_)						       \
> > >  			break;						       \
> > > -		prepare_to_wait(sk_sleep(sk_), &wait_, TASK_INTERRUPTIBLE);    \
> > > +		add_wait_queue(sk_sleep(sk_), &wait_);                         \
> > >  		release_sock(sk_);					       \
> > >  		*(timeo_) = wait_woken(&wait_, TASK_INTERRUPTIBLE, *(timeo_)); \
> > >  		sched_annotate_sleep();				               \
> >
> > Could we have this ol' classic backported to v4.19 and v4.14 please?
>
> What is the git commit id?

Sorry, it's 223b7329ec6a0.

--
Lee Jones [李琼斯]
