Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CDF55F478
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiF2Dvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiF2Dva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:51:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C8F21250
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 20:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C50461DE9
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 03:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA45C34114;
        Wed, 29 Jun 2022 03:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656474687;
        bh=wzvIhAbGKcMmn5soNNOdPkV0ZLlt8CF7a1OX+dbQ3c4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aT1IFeWgtqHWobaNAL1nIiTT44CBEwNlJpVtMRgLPqTg9ED7yi0N4FFWdXt0ogpLe
         VWelW9nBkSLsESeWaxOTloXovEIVSqfUgSfIMlF+GFyAvMYwtU/ZXDb2eE3rMYYP5B
         MZkecT/vjxg0+kjAgv1rjQ5kozdEhHcw5WBU8M7+oURo0gRnA4kAt2LUygfIJDEv2i
         94mPxUsJhj4CsjbnbgBjYBpL7ItjFYhMEpR8LaLNj3ZPwjrfniTYMy/rLc7b7UkjHK
         Pj5ngRBZDcbTy/nC0o7G7QFNBGtT4hUPYfq73TOgMnA86BEb6iWqBH+HZ2GKXKzMbK
         hS7sgcrzyf+vQ==
Date:   Tue, 28 Jun 2022 20:51:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net] af_unix: Do not call kmemdup() for init_net's
 sysctl table.
Message-ID: <20220628205125.2b443819@kernel.org>
In-Reply-To: <20220627233627.51646-1-kuniyu@amazon.com>
References: <20220627233627.51646-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jun 2022 16:36:27 -0700 Kuniyuki Iwashima wrote:
> While setting up init_net's sysctl table, we need not duplicate the
> global table and can use it directly as ipv4_sysctl_init_net() does.
> 
> Unlike IPv4, AF_UNIX does not have a huge sysctl table for now, so it
> cannot be a problem, but this patch makes code consistent.

Thanks for the extra info. It sounds like an optimization, tho.
We save one table's worth of memory. Any objections to applying
this to net-next?

> Fixes: 1597fbc0faf8 ("[UNIX]: Make the unix sysctl tables per-namespace")
> Acked-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
