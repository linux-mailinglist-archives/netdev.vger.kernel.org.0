Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FEA6E12B4
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjDMQsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDMQsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:48:19 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DA7AD11;
        Thu, 13 Apr 2023 09:48:01 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id j16so1544226wms.0;
        Thu, 13 Apr 2023 09:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681404480; x=1683996480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCpgFka1BgdgEY+0DayOyo6Vcm/YOc5P4OYz7TLB5yc=;
        b=arlLyv3XTe3oSRhCJKt0ZnifAS4z+zzt4UuIGKvzC8sRytt3szwTNFpgF1xSzlHGa8
         Y4ctEdpQzjXZv6Dl7fc/v4fZFHr1MLEt4Y9HmjG+QFkoEtdmZ+4VLJ3NngP+9Z/6FlYB
         fapvOTOj6WrNphsZGIwKZZpOHT+kPquv5BGdqoU5SLAdYe/2Yv4xMviq7r/HytrCP0o1
         KwUI40/nwW13/mytNfxXx+3RETHnjbOnorTIqSa/Oe9CyY2Wy44qa/xwV8meBPEj/zpO
         ahiBh2jDc3QJUmi33sbvStZHQsCyZ1CQJ7VDydDx/a9uJSmXfYLQjDV3xlEwDSumOT89
         tcgQ==
X-Gm-Message-State: AAQBX9eEsxoqJkyDC7Xl/+a13e033s0k5YLdFyaaUZOYcrK8LtJsekEV
        76JK5QBs/+7jJP8zBNY0+D9atbOGz6V+Vw==
X-Google-Smtp-Source: AKy350ZdQPQ3cXX00NpaTx1MkBt3f8xuBSIA/dEDB7p2hTM+xW52IAI5JJyva9D/4uoTyXif85pzPA==
X-Received: by 2002:a05:600c:2144:b0:3f0:a098:f4ff with SMTP id v4-20020a05600c214400b003f0a098f4ffmr2398926wml.35.1681404479703;
        Thu, 13 Apr 2023 09:47:59 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-116.fbsv.net. [2a03:2880:31ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id k6-20020a05600c1c8600b003f034c76e85sm6002542wms.38.2023.04.13.09.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 09:47:58 -0700 (PDT)
Date:   Thu, 13 Apr 2023 09:47:56 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, davem@davemloft.net,
        dccp@vger.kernel.org, dsahern@kernel.org, edumazet@google.com,
        io-uring@vger.kernel.org, kuba@kernel.org, leit@fb.com,
        linux-kernel@vger.kernel.org, marcelo.leitner@gmail.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        netdev@vger.kernel.org, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH RFC] io_uring: Pass whole sqe to commands
Message-ID: <ZDgyPL6UrX/MaBR4@gmail.com>
References: <20230406144330.1932798-1-leitao@debian.org>
 <20230406165705.3161734-1-leitao@debian.org>
 <ZDdvcSKLa6ZEAhRW@ovpn-8-18.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDdvcSKLa6ZEAhRW@ovpn-8-18.pek2.redhat.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ming,

On Thu, Apr 13, 2023 at 10:56:49AM +0800, Ming Lei wrote:
> On Thu, Apr 06, 2023 at 09:57:05AM -0700, Breno Leitao wrote:
> > Currently uring CMD operation relies on having large SQEs, but future
> > operations might want to use normal SQE.
> > 
> > The io_uring_cmd currently only saves the payload (cmd) part of the SQE,
> > but, for commands that use normal SQE size, it might be necessary to
> > access the initial SQE fields outside of the payload/cmd block.  So,
> > saves the whole SQE other than just the pdu.
> > 
> > This changes slighlty how the io_uring_cmd works, since the cmd
> > structures and callbacks are not opaque to io_uring anymore. I.e, the
> > callbacks can look at the SQE entries, not only, in the cmd structure.
> > 
> > The main advantage is that we don't need to create custom structures for
> > simple commands.
> > 
> > Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> 
> ...
> 
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 2e4c483075d3..9648134ccae1 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -63,14 +63,15 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_done);
> >  int io_uring_cmd_prep_async(struct io_kiocb *req)
> >  {
> >  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> > -	size_t cmd_size;
> > +	size_t size = sizeof(struct io_uring_sqe);
> >  
> >  	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
> >  	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
> >  
> > -	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
> > +	if (req->ctx->flags & IORING_SETUP_SQE128)
> > +		size <<= 1;
> >  
> > -	memcpy(req->async_data, ioucmd->cmd, cmd_size);
> > +	memcpy(req->async_data, ioucmd->sqe, size);
> 
> The copy will make some fields of sqe become READ TWICE, and driver may see
> different sqe field value compared with the one observed in io_init_req().

This copy only happens if the operation goes to the async path
(calling io_uring_cmd_prep_async()).  This only happens if
f_op->uring_cmd() returns -EAGAIN.

          ret = file->f_op->uring_cmd(ioucmd, issue_flags);
          if (ret == -EAGAIN) {
                  if (!req_has_async_data(req)) {
                          if (io_alloc_async_data(req))
                                  return -ENOMEM;
                          io_uring_cmd_prep_async(req);
                  }
                  return -EAGAIN;
          }

Are you saying that after this copy, the operation is still reading from
sqe instead of req->async_data?

If you have an example of the two copes flow, that would be great.

Thanks for the review,
Breno
