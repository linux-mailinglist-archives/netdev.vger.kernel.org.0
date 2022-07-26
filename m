Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F59581856
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiGZR07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 13:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiGZR06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 13:26:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 333A21AC
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658856416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gR/8mr5O8RiY7MMLT2YIwLim43XBEVBrVoLE8NdjlQw=;
        b=UAVTou3V9FoCashTc/NblH8skZvvgPWqmtYAhOYc53fIZaNGm3C9zWgXchhDzSL9LC5fny
        sinGo83k9NCELE4c5/9H7vRfiadQxQ04WrU2ZUDfoJ7Iiq2v/o28qgXV77J4WfBTkiHYvS
        Hprit1mJMqJ9QIt3DQpvwCODY6ZoVwY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-P7S_w-OHM5-up-PK-80Rzw-1; Tue, 26 Jul 2022 13:26:55 -0400
X-MC-Unique: P7S_w-OHM5-up-PK-80Rzw-1
Received: by mail-wm1-f72.google.com with SMTP id c62-20020a1c3541000000b003a30d86cb2dso10510989wma.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:26:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gR/8mr5O8RiY7MMLT2YIwLim43XBEVBrVoLE8NdjlQw=;
        b=skG4smgEI4m9m8vnxH+Rj9h2eIWqCxsUhLkSr1Ce2b+49HhSY08PSC3sd5ejAfa4Sg
         fsFC9FdVJY1URxwykeWfGU6/cVaGMMPUTt6yxgwZkv2ifuWORi8e4KOCro9bO2W178xq
         UGRp6L8MEEh7lnZGKxLwaZwLhM+XkcHiWWYUj5sMnqXKx8Awgg5b7Hzf40XwX2NqArns
         IVRkYAiYPzNd+1/z2mPI+6b62VI9f7HDSVlfqdfaJKQJucdugffg1J9wVCzfzFGiwkCU
         4dWfSXmSF+2jnoJxowzOLBClt5RDz5V+1HMdQsV5LkiqTMH2iQUji94A7FmGnfGuESvB
         bsdQ==
X-Gm-Message-State: AJIora+Qek6W6q3Khl3NFkjUPd1b/SnhkzCN5NPN6irfnjG3t2+jEsbj
        XZDrLmgGrDqXLsSzxKO/0YSjM4gX9n6PYyeGjK4cSNCk3MX0Ovwi/xdJ5vIZKJx2Udx3tHBsWJd
        weVTmBqyGIfzojOyw
X-Received: by 2002:a5d:5503:0:b0:21e:6e2a:2a0a with SMTP id b3-20020a5d5503000000b0021e6e2a2a0amr11362432wrv.695.1658856413811;
        Tue, 26 Jul 2022 10:26:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1saUk1xwedO5kXcQSU+AsojgM6BUSEYWQcYIfStwe4duyJz95b/02/1AnLz3fzWAcTMo3pb+Q==
X-Received: by 2002:a5d:5503:0:b0:21e:6e2a:2a0a with SMTP id b3-20020a5d5503000000b0021e6e2a2a0amr11362416wrv.695.1658856413402;
        Tue, 26 Jul 2022 10:26:53 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id a21-20020a05600c349500b003a317ee3036sm19281374wmq.2.2022.07.26.10.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 10:26:52 -0700 (PDT)
Message-ID: <1317ab48c253a040dc15b9c458ce640ac2257b9b.camel@redhat.com>
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru
Date:   Tue, 26 Jul 2022 19:26:51 +0200
In-Reply-To: <20220726100112.6c82fdb5@kernel.org>
References: <20220722235033.2594446-1-kuba@kernel.org>
         <20220722235033.2594446-8-kuba@kernel.org>
         <506b4478378d5bdcdf4a43bd6e2b48dd0dcd6b5d.camel@redhat.com>
         <20220726100112.6c82fdb5@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-26 at 10:01 -0700, Jakub Kicinski wrote:
> On Tue, 26 Jul 2022 11:27:36 +0200 Paolo Abeni wrote:
> > On Fri, 2022-07-22 at 16:50 -0700, Jakub Kicinski wrote:
> > > diff --git a/net/tls/tls.h b/net/tls/tls.h
> > > index 154a3773e785..0e840a0c3437 100644
> > > --- a/net/tls/tls.h
> > > +++ b/net/tls/tls.h
> > > @@ -1,4 +1,5 @@
> > >  /*
> > > + * Copyright (c) 2016 Tom Herbert <tom@herbertland.com>  
> > 
> > It's a little strange to me the above line ??! digging this file
> > history, you created it out of include/net/tls.h and the latter was
> > originally authored by Dave Watson (modulo ENOCOFFEE here...)
> > 
> > > +++ b/net/tls/tls_strp.c
> > > @@ -1,37 +1,493 @@
> > >  // SPDX-License-Identifier: GPL-2.0-only
> > > +/* Copyright (c) 2016 Tom Herbert <tom@herbertland.com> */  
> > 
> > Same here ...
> 
> I tried to add the Copyrights as I copied some code around, since I'm
> lazy around legal stuff. I think I copied parts of the strparser
> at some point and the structure definition (workqueue handling?). 
> I'd rather keep too many copyrights than too few, tho. 
> The semi-custom license is more annoying :(
> 
> > > +static int tls_strp_copyin(read_descriptor_t *desc, struct sk_buff *in_skb,
> > > +			   unsigned int offset, size_t in_len)
> > > +{
> > > +	struct tls_strparser *strp = (struct tls_strparser *)desc->arg.data;
> > > +	size_t sz, len, chunk;
> > > +	struct sk_buff *skb;
> > > +	skb_frag_t *frag;
> > > +
> > > +	if (strp->msg_ready)
> > > +		return 0;
> > > +
> > > +	skb = strp->anchor;
> > > +	frag = &skb_shinfo(skb)->frags[skb->len / PAGE_SIZE];  
> > 
> > I'm wondering if TSOv2 GRO packets can reach here? Even without TSO v2,
> > I *think* the TCP stack is allowed to grow queued skbs above 64K via
> > tcp_queue_rcv()/tcp_try_coalesce().
> 
> I don't think the TSO skbs can get here, the @skb is completely
> constructed by me and the length is bounded by max TLS record size
> (16k + overheads). We should be safe to use 4k pages, I think.
> 
> > > +static int tls_strp_read_copyin(struct tls_strparser *strp)
> > > +{
> > > +	struct socket *sock = strp->sk->sk_socket;
> > > +	read_descriptor_t desc;
> > > +
> > > +	desc.arg.data = strp;
> > > +	desc.error = 0;
> > > +	desc.count = 1; /* give more than one skb per call */
> > > +
> > > +	/* sk should be locked here, so okay to do read_sock */
> > > +	sock->ops->read_sock(strp->sk, &desc, tls_strp_copyin);  
> > 
> > If you are concerned by indirect calls/retpoline, you can use directly
> > tcp_read_sock here, as read_sock is always tcp_read_sock since commit
> > 965b57b469a589d64d81b1688b38dcb537011bb0. Or you can use
> > indirect_call_wrapper.h
> 
> This is a slowpath which only gets triggered if we are so rbuf
> constrained that TCP will not be able to buffer a full record.
> Otherwise we try to avoid doing any copying/read_sock at all.
> 
> > > -int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
> > > -		      struct sk_buff_head *dst)
> > > +/* strp must already be stopped so that tls_strp_recv will no longer be called.
> > > + * Note that tls_strp_done is not called with the lower socket held.
> > > + */
> > > +void tls_strp_done(struct tls_strparser *strp)
> > >  {
> > > -	struct sk_buff *clone;
> > > +	WARN_ON(!strp->stopped);
> > >  
> > > -	clone = skb_clone(skb, sk->sk_allocation);
> > > -	if (!clone)
> > > +	cancel_work_sync(&strp->work);
> > > +	tls_strp_anchor_free(strp);
> > > +}
> > > +
> > > +int __init tls_strp_dev_init(void)
> > > +{
> > > +	tls_strp_wq = create_singlethread_workqueue("kstrp");  
> > 
> > I guess it's better to change the name to avoid confusing with plain
> > strparser ?!?
> > 
> > Out of sheer ignorance and not related to this patch: If I read
> > correctly, the above means that multiple tls flows on top of different
> > TCP sockets will use a single CPU, isn't that a relevant bottle-neck?
> > isn't enough to rely on queue_work() to submit the work on the same CPU
> > that just did the TCP stack processing? 
> 
> Oh yeah, this is a slow/rare path too but you're right. I copied this
> code from strparser without thinking, not sure what the motivation was
> there.

I'm fine with your replies here. I'm ok with the code as-is. I think
this last bits could be updated with a later patch, if needed.

Acked-by: Paolo Abeni <pabeni@redhat.com>

