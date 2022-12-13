Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F0064BC92
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 20:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbiLMTAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 14:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236674AbiLMTAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 14:00:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FBC22B12;
        Tue, 13 Dec 2022 11:00:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE526614D7;
        Tue, 13 Dec 2022 19:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ECDC433D2;
        Tue, 13 Dec 2022 19:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670958001;
        bh=j8OrJ7rVD9mtqUyvbM9k9Q1oCGT9CJ/+cHVnUfcCUBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oYoKi5gdCoC0JlKsBw1OSFHfY7b+pOaEBWOATMlBtoqPa2kAkUg7JBfALF+GxsSaO
         E5kEQVWS0IS8oxfjAlhnlLQXVDyTKCL+fZPUdFxmqR3gi20+7P7tqEhih6JYaOKp2k
         EoNz/Qfg/n9FPfBX3jsBxyLhd20D4cPMFACezq/93pPmQmXyXWzn4QBogM5o0iCQgk
         zRlTuvKIvtzWw2WsKkfSMh7HQL6Ba6RIibZVyD3dFA0ejoSswdG1G27yCRdCgPFYBO
         AoPocIN/ArLrHZN2b+BB/6IuovG7oQErRNw7FRSqkMZJyRL2PL8EXXkHNYjR5I6zCV
         5GgYFYxxZ/A4Q==
Date:   Tue, 13 Dec 2022 10:59:59 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>, netdev@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v3] epoll: use refcount to reduce ep_mutex contention
Message-ID: <Y5jLr0/hikL9X6Fz@sol.localdomain>
References: <1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni@redhat.com>
 <Y5gVJz+qDfw0tEP1@sol.localdomain>
 <229be448e2979258a7c2c84d808360618f5095a9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <229be448e2979258a7c2c84d808360618f5095a9.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 07:21:14PM +0100, Paolo Abeni wrote:
> Hi,
> 
> On Mon, 2022-12-12 at 22:01 -0800, Eric Biggers wrote:
> > I am trying to understand whether this patch is correct.
> > 
> > One thing that would help would be to use more standard naming:
> > 
> > 	ep_put => ep_refcount_dec_and_test (or ep_put_and_test)
> > 	ep_dispose => ep_free
> > 	ep_free => ep_clear_and_put
> 
> Thank you for the feedback. 
> 
> I must admit I'm not good at all at selecting good names, so I
> definitelly will apply the above. I additionally still have to cover
> the feedback from Jacob - switching the reference count to a kref - as
> I've been diverted to other tasks.
> 
> I hope to be able to share a new revision of this patch next week.

Using 'refcount_t' directly is another option.

I think a plain 'unsigned int' would be fine here, if all reads and writes of
the refcount really happen under a mutex.  Using refcount_t (or kref) would add
some extra sanity checks, though.

- Eric
