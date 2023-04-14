Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107AA6E2504
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjDNOBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjDNOBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:01:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA64BBA4
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681480818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=27YyBi9hssfCHBO7/PKix6vU7A+oXZmvyq6RpUloX40=;
        b=EANDVzVfuH1gRpSaxucrtwYcw+DtA0P9n+mwjRkQOUqBVuoBW1jvbKykCIXt5Q0VqE4UbY
        mpaaAQU/sePC/UkBaxkuKraHVBWgnqXlJxtWDqUQgVzdluDCsQDEBh+WaSauDxGfn803gY
        um/GHUDbc1efnbAjMi/GQ3i1Czr3aL8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-BcRvrHRHMtmqZL31AExtOw-1; Fri, 14 Apr 2023 10:00:14 -0400
X-MC-Unique: BcRvrHRHMtmqZL31AExtOw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F8F41C0691B;
        Fri, 14 Apr 2023 14:00:13 +0000 (UTC)
Received: from ovpn-8-21.pek2.redhat.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A3E6404DC40;
        Fri, 14 Apr 2023 14:00:02 +0000 (UTC)
Date:   Fri, 14 Apr 2023 21:59:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Breno Leitao <leitao@debian.org>, axboe@kernel.dk,
        davem@davemloft.net, dccp@vger.kernel.org, dsahern@kernel.org,
        edumazet@google.com, io-uring@vger.kernel.org, kuba@kernel.org,
        leit@fb.com, linux-kernel@vger.kernel.org,
        marcelo.leitner@gmail.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com, ming.lei@redhat.com
Subject: Re: [PATCH RFC] io_uring: Pass whole sqe to commands
Message-ID: <ZDlcXd4K+a2iGbnv@ovpn-8-21.pek2.redhat.com>
References: <20230406144330.1932798-1-leitao@debian.org>
 <20230406165705.3161734-1-leitao@debian.org>
 <ZDdvcSKLa6ZEAhRW@ovpn-8-18.pek2.redhat.com>
 <ZDgyPL6UrX/MaBR4@gmail.com>
 <ZDi2pP4jgHwCvJRm@ovpn-8-21.pek2.redhat.com>
 <44420e92-f629-f56e-f930-475be6f6a83a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44420e92-f629-f56e-f930-475be6f6a83a@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 02:12:10PM +0100, Pavel Begunkov wrote:
> On 4/14/23 03:12, Ming Lei wrote:
> > On Thu, Apr 13, 2023 at 09:47:56AM -0700, Breno Leitao wrote:
> > > Hello Ming,
> > > 
> > > On Thu, Apr 13, 2023 at 10:56:49AM +0800, Ming Lei wrote:
> > > > On Thu, Apr 06, 2023 at 09:57:05AM -0700, Breno Leitao wrote:
> > > > > Currently uring CMD operation relies on having large SQEs, but future
> > > > > operations might want to use normal SQE.
> > > > > 
> > > > > The io_uring_cmd currently only saves the payload (cmd) part of the SQE,
> > > > > but, for commands that use normal SQE size, it might be necessary to
> > > > > access the initial SQE fields outside of the payload/cmd block.  So,
> > > > > saves the whole SQE other than just the pdu.
> > > > > 
> > > > > This changes slighlty how the io_uring_cmd works, since the cmd
> > > > > structures and callbacks are not opaque to io_uring anymore. I.e, the
> > > > > callbacks can look at the SQE entries, not only, in the cmd structure.
> > > > > 
> > > > > The main advantage is that we don't need to create custom structures for
> > > > > simple commands.
> > > > > 
> > > > > Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> > > > > Signed-off-by: Breno Leitao <leitao@debian.org>
> > > > > ---
> > > > 
> > > > ...
> > > > 
> > > > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > > > index 2e4c483075d3..9648134ccae1 100644
> > > > > --- a/io_uring/uring_cmd.c
> > > > > +++ b/io_uring/uring_cmd.c
> > > > > @@ -63,14 +63,15 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_done);
> > > > >   int io_uring_cmd_prep_async(struct io_kiocb *req)
> > > > >   {
> > > > >   	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> > > > > -	size_t cmd_size;
> > > > > +	size_t size = sizeof(struct io_uring_sqe);
> > > > >   	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
> > > > >   	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
> > > > > -	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
> > > > > +	if (req->ctx->flags & IORING_SETUP_SQE128)
> > > > > +		size <<= 1;
> > > > > -	memcpy(req->async_data, ioucmd->cmd, cmd_size);
> > > > > +	memcpy(req->async_data, ioucmd->sqe, size);
> > > > 
> > > > The copy will make some fields of sqe become READ TWICE, and driver may see
> > > > different sqe field value compared with the one observed in io_init_req().
> > > 
> > > This copy only happens if the operation goes to the async path
> > > (calling io_uring_cmd_prep_async()).  This only happens if
> > > f_op->uring_cmd() returns -EAGAIN.
> > > 
> > >            ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> > >            if (ret == -EAGAIN) {
> > >                    if (!req_has_async_data(req)) {
> > >                            if (io_alloc_async_data(req))
> > >                                    return -ENOMEM;
> > >                            io_uring_cmd_prep_async(req);
> > >                    }
> > >                    return -EAGAIN;
> > >            }
> > > 
> > > Are you saying that after this copy, the operation is still reading from
> > > sqe instead of req->async_data?
> > 
> > I meant that the 2nd read is on the sqe copy(req->aync_data), but same
> > fields can become different between the two READs(first is done on original
> > SQE during io_init_req(), and second is done on sqe copy in driver).
> > 
> > Will this kind of inconsistency cause trouble for driver? Cause READ
> > TWICE becomes possible with this patch.
> 
> Right it might happen, and I was keeping that in mind, but it's not
> specific to this patch. It won't reload core io_uring bits, and all

It depends if driver reloads core bits or not, anyway the patch exports
all fields and opens the window.

> fields cmds use already have this problem.

driver is supposed to load cmds field just once too, right?

> 
> Unless there is a better option, the direction we'll be moving in is
> adding a preparation step that should read and stash parts of SQE
> it cares about, which should also make full SQE copy not
> needed / optional.

Sounds good.


Thanks,
Ming

