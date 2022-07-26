Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0288F581807
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 19:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiGZRBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 13:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGZRBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 13:01:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D1825C78
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:01:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35BEEB81889
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 17:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC94C433C1;
        Tue, 26 Jul 2022 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658854874;
        bh=PM71S3n0l1uRIfQ3vm7mLaKOWXfWGbDuYoaKUP25lpo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BpJiMl56JOT8h55kk2hBKin2DVyQzyrLUgPI4t/szfekjY8icpfK3wk9o+kSW7+9Q
         KCdyg95UvJ/KXq0nAdQ4fcnthKB5ti/6yhXoVaj5XXMJCcWkWa26FKWO97i4uemnNr
         khaJZk79IDwr4BMa0nDMH0W2gSQl2MAp/4ZKl8uvLILdoPoP5kTt/W41PM2jszHJ+5
         hUkqPeTdsRg4iyd43/nPNplS7kgAbb/0NsIZAGvt4dncUPBNj/9zUmf9y+x4JMD747
         c4GITDqRps471J5kxpeIXjIWJpX39VXbU/pNJr2jnuPocjt8ZlkNXz1pYryPM9X6po
         zJQaJsVLrFzsg==
Date:   Tue, 26 Jul 2022 10:01:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Message-ID: <20220726100112.6c82fdb5@kernel.org>
In-Reply-To: <506b4478378d5bdcdf4a43bd6e2b48dd0dcd6b5d.camel@redhat.com>
References: <20220722235033.2594446-1-kuba@kernel.org>
        <20220722235033.2594446-8-kuba@kernel.org>
        <506b4478378d5bdcdf4a43bd6e2b48dd0dcd6b5d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 11:27:36 +0200 Paolo Abeni wrote:
> On Fri, 2022-07-22 at 16:50 -0700, Jakub Kicinski wrote:
> > diff --git a/net/tls/tls.h b/net/tls/tls.h
> > index 154a3773e785..0e840a0c3437 100644
> > --- a/net/tls/tls.h
> > +++ b/net/tls/tls.h
> > @@ -1,4 +1,5 @@
> >  /*
> > + * Copyright (c) 2016 Tom Herbert <tom@herbertland.com>  
> 
> It's a little strange to me the above line ??! digging this file
> history, you created it out of include/net/tls.h and the latter was
> originally authored by Dave Watson (modulo ENOCOFFEE here...)
> 
> > +++ b/net/tls/tls_strp.c
> > @@ -1,37 +1,493 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (c) 2016 Tom Herbert <tom@herbertland.com> */  
> 
> Same here ...

I tried to add the Copyrights as I copied some code around, since I'm
lazy around legal stuff. I think I copied parts of the strparser
at some point and the structure definition (workqueue handling?). 
I'd rather keep too many copyrights than too few, tho. 
The semi-custom license is more annoying :(

> > +static int tls_strp_copyin(read_descriptor_t *desc, struct sk_buff *in_skb,
> > +			   unsigned int offset, size_t in_len)
> > +{
> > +	struct tls_strparser *strp = (struct tls_strparser *)desc->arg.data;
> > +	size_t sz, len, chunk;
> > +	struct sk_buff *skb;
> > +	skb_frag_t *frag;
> > +
> > +	if (strp->msg_ready)
> > +		return 0;
> > +
> > +	skb = strp->anchor;
> > +	frag = &skb_shinfo(skb)->frags[skb->len / PAGE_SIZE];  
> 
> I'm wondering if TSOv2 GRO packets can reach here? Even without TSO v2,
> I *think* the TCP stack is allowed to grow queued skbs above 64K via
> tcp_queue_rcv()/tcp_try_coalesce().

I don't think the TSO skbs can get here, the @skb is completely
constructed by me and the length is bounded by max TLS record size
(16k + overheads). We should be safe to use 4k pages, I think.

> > +static int tls_strp_read_copyin(struct tls_strparser *strp)
> > +{
> > +	struct socket *sock = strp->sk->sk_socket;
> > +	read_descriptor_t desc;
> > +
> > +	desc.arg.data = strp;
> > +	desc.error = 0;
> > +	desc.count = 1; /* give more than one skb per call */
> > +
> > +	/* sk should be locked here, so okay to do read_sock */
> > +	sock->ops->read_sock(strp->sk, &desc, tls_strp_copyin);  
> 
> If you are concerned by indirect calls/retpoline, you can use directly
> tcp_read_sock here, as read_sock is always tcp_read_sock since commit
> 965b57b469a589d64d81b1688b38dcb537011bb0. Or you can use
> indirect_call_wrapper.h

This is a slowpath which only gets triggered if we are so rbuf
constrained that TCP will not be able to buffer a full record.
Otherwise we try to avoid doing any copying/read_sock at all.

> > -int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
> > -		      struct sk_buff_head *dst)
> > +/* strp must already be stopped so that tls_strp_recv will no longer be called.
> > + * Note that tls_strp_done is not called with the lower socket held.
> > + */
> > +void tls_strp_done(struct tls_strparser *strp)
> >  {
> > -	struct sk_buff *clone;
> > +	WARN_ON(!strp->stopped);
> >  
> > -	clone = skb_clone(skb, sk->sk_allocation);
> > -	if (!clone)
> > +	cancel_work_sync(&strp->work);
> > +	tls_strp_anchor_free(strp);
> > +}
> > +
> > +int __init tls_strp_dev_init(void)
> > +{
> > +	tls_strp_wq = create_singlethread_workqueue("kstrp");  
> 
> I guess it's better to change the name to avoid confusing with plain
> strparser ?!?
> 
> Out of sheer ignorance and not related to this patch: If I read
> correctly, the above means that multiple tls flows on top of different
> TCP sockets will use a single CPU, isn't that a relevant bottle-neck?
> isn't enough to rely on queue_work() to submit the work on the same CPU
> that just did the TCP stack processing? 

Oh yeah, this is a slow/rare path too but you're right. I copied this
code from strparser without thinking, not sure what the motivation was
there.
