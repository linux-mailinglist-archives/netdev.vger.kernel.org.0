Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C8C6D9DAF
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 18:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239543AbjDFQl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 12:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238668AbjDFQl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 12:41:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C5C7ABC;
        Thu,  6 Apr 2023 09:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B86D1644CC;
        Thu,  6 Apr 2023 16:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D12C433D2;
        Thu,  6 Apr 2023 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680799316;
        bh=ZHCHRKTa8Sub7v0wluuYQVCLFXg+qRwVIK/2Dc97pEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fqoKWFU2jOFx41/oXJiYwLpY9GWNodDW0f4l9y8Le6+VWvGqi7TseasADCnYHxWjs
         pauxxokT5LRv0O79x8xKIG6PJbWOkxJQ0LxHofyqH3E981lkCIdGXklRN+0WgVN5KP
         yb8r5FY+FQ0CO1yfQGq4ZibHCsHQ4PQMWy87jelsOX+jUETuF0HybKpqZvT500KyTT
         FQeFsiYsfzEXZSL+fp0nuqKx/tNhlL3PMrrqBSO2mEWvCBkAT+KnGpHeUzgThHbOEp
         iF9Fq6K2KVJWzVmnHJsT0SS9DfYxnPMVd5oDhQCZy4wmlMJIQcgX6R+CdhvRWSAapv
         8hzFbyG9T40nw==
Date:   Thu, 6 Apr 2023 10:41:52 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Breno Leitao <leitao@debian.org>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        edumazet@google.com, pabeni@redhat.com, davem@davemloft.net,
        dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        willemdebruijn.kernel@gmail.com, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Message-ID: <ZC72UKx/sA4syPfK@kbusch-mbp.dhcp.thefacebook.com>
References: <20230406144330.1932798-1-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406144330.1932798-1-leitao@debian.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 07:43:26AM -0700, Breno Leitao wrote:
> This patchset creates the initial plumbing for a io_uring command for
> sockets.
> 
> For now, create two uring commands for sockets, SOCKET_URING_OP_SIOCOUTQ
> and SOCKET_URING_OP_SIOCINQ. They are similar to ioctl operations
> SIOCOUTQ and SIOCINQ. In fact, the code on the protocol side itself is
> heavily based on the ioctl operations.

Do you have asynchronous operations in mind for a future patch? The io_uring
command infrastructure makes more sense for operations that return EIOCBQUEUED,
otherwise it doesn't have much benefit over ioctl.
 
> In order to test this code, I created a liburing test, which is
> currently located at [1], and I will create a pull request once we are
> good with this patch.
> 
> I've also run test/io_uring_passthrough to make sure the first patch
> didn't regressed the NVME passthrough path.
> 
> This patchset is a RFC for two different reasons:
>   * It changes slighlty on how IO uring command operates. I.e, we are
>     now passing the whole SQE to the io_uring_cmd callback (instead of
>     an opaque buffer). This seems to be more palatable instead of
>     creating some custom structure just to fit small parameters, as in
>     SOCKET_URING_OP_SIOC{IN,OUT}Q. Is this OK?

I think I'm missing something from this series. Where is the io_uring_cmd
change to point to the sqe?
