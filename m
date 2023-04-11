Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA016DDAAE
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjDKMW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKMWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:22:55 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4291717;
        Tue, 11 Apr 2023 05:22:54 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id o18so7362008wro.12;
        Tue, 11 Apr 2023 05:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681215773; x=1683807773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iv40Wkjx2Hf7U9sldsgemiXt0WJwZLPB7N5j/0A4xtA=;
        b=yv4FJ7t6tme8poClQGeqViG0BYanEaNJrCPxFd4FDeaaoxmXm/xOYMJ5BxgzUzeQbN
         9WxiTJMtsTeKAkQCSbJbO3ovTRyjKM2fx5csKwnggmr89SOKSqnjysbkG6IQAK1M5R/b
         Des5g8hwGnWo1/d0dK7Ga5egdQBqUQIJTAFbi8JDyaISSxu3rDKuelKYThLn5QbsOaox
         c4S9Qs3Idm1/sWqtqJczM+390EWLqDdbtUsGjgXA4ovxYxzSvQuqnm4ZYSI8kolDBTOe
         WGidI36hhHpsFNoi0s7m4JfLanDQ9Z/cfHj5Vl2ggj+234P+vxp9EOKwCoYaTU/6UIhE
         u1Vw==
X-Gm-Message-State: AAQBX9fZBbec4jy4wzuXaOolPtwcKsOc/XaGC95kFGzJ/x5fRUl6OfGU
        dojTg9rS0M0neuwov4aorJc=
X-Google-Smtp-Source: AKy350bjxpbuRhCW8HYnxa/zj45MxirttrrnxnBmDV4LJDlUcpX+aQ5g1qb+RhpZpAg7lgYuObJ+xQ==
X-Received: by 2002:a5d:4f83:0:b0:2e4:6197:21b3 with SMTP id d3-20020a5d4f83000000b002e4619721b3mr7751336wru.55.1681215772861;
        Tue, 11 Apr 2023 05:22:52 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-015.fbsv.net. [2a03:2880:31ff:f::face:b00c])
        by smtp.gmail.com with ESMTPSA id a5-20020a5d4d45000000b002c3f81c51b6sm14480806wru.90.2023.04.11.05.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 05:22:52 -0700 (PDT)
Date:   Tue, 11 Apr 2023 05:22:50 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Keith Busch <kbusch@kernel.org>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, davem@davemloft.net,
        dccp@vger.kernel.org, dsahern@kernel.org, edumazet@google.com,
        io-uring@vger.kernel.org, kuba@kernel.org, leit@fb.com,
        linux-kernel@vger.kernel.org, marcelo.leitner@gmail.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        netdev@vger.kernel.org, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH RFC] io_uring: Pass whole sqe to commands
Message-ID: <ZDVRGoDZo1tTbmZu@gmail.com>
References: <20230406144330.1932798-1-leitao@debian.org>
 <20230406165705.3161734-1-leitao@debian.org>
 <ZDBmQOhbyU0iLhMw@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDBmQOhbyU0iLhMw@kbusch-mbp.dhcp.thefacebook.com>
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 12:51:44PM -0600, Keith Busch wrote:
> > @@ -63,14 +63,15 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_done);
> >  int io_uring_cmd_prep_async(struct io_kiocb *req)
> >  {
> >  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> > -	size_t cmd_size;
> > +	size_t size = sizeof(struct io_uring_sqe);
> >  
> >  	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
> >  	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
> 
> One minor suggestion. The above is the only user of uring_cmd_pdu_size() now,
> which is kind of a convoluted way to enfoce the offset of the 'cmd' field. It
> may be more clear to replace these with:

I agree with you here. Basically it is a bug if the payload (pdu) size is
is different than 16 for single SQE or != 80 for extended SQE.

So, basically it is checking for two things:
   * the cmd offset is 48
   * the io_uring_sqe struct is 64

Since this is a uapi, I am not confidence that they will change at all.
I can replace the code with your suggestion.

> 	BUILD_BUG_ON(offsetof(struct io_uring_sqe, cmd) == 48);

It should be "offset(struct io_uring_sqe, cmd) != 48)", right?

Thanks for the review!
