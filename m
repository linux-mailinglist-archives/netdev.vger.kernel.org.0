Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D72E6A21D7
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBXSzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBXSzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:55:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50106193F3;
        Fri, 24 Feb 2023 10:55:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E81D76193E;
        Fri, 24 Feb 2023 18:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F85C433EF;
        Fri, 24 Feb 2023 18:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677264910;
        bh=c5QLDq5WRfpxIp3gOZoLLdhen/tLPzbkWhB+2lf8V2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fGPMJvFmhQ5A7Ao3TGKepF+U2540r8ducfS1GiL/kUb7R8bmfRUhR08QCL0Yl+NvG
         Arpw/OOp/YM043p0MfqLE82dYaAWQonGyZSGnLyKgWhwnR1NLLYBZeCepryPzIupgk
         ipsh9odzcjZudNA3peF6YUMvnaom0qRurJPHRQR28ba4JqDOxzKRGcEXN0/OUxcrFZ
         oPSADhRzdJ7hIeBbRlhUTdFsnqKKL8W1LkvsrNEnWPoAmF2XdX29+DWFxfAZQyH1NJ
         CeRWqiQTkayfM+IHXnf+G+xJnymq3xmYZrFV2pz3bKgSZreFWWVuLiIjRp2OLJlylu
         OhL+sPWPWezDA==
Date:   Fri, 24 Feb 2023 10:55:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, borisp@nvidia.com,
        john.fastabend@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, davejwatson@fb.com, aviadye@mellanox.com,
        ilyal@mellanox.com, sd@queasysnail.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Message-ID: <20230224105508.4892901f@kernel.org>
In-Reply-To: <20230224120606.GI26596@breakpoint.cc>
References: <20230224105811.27467-1-hbh25y@gmail.com>
        <20230224120606.GI26596@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 13:06:06 +0100 Florian Westphal wrote:
> Hangyu Hua <hbh25y@gmail.com> wrote:
> > ctx->crypto_send.info is not protected by lock_sock in
> > do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
> > and do_tls_setsockopt_conf() can cause a NULL point dereference or
> > use-after-free read when memcpy.  
> 
> Its good practice to quote the relevant parts of the splat here.

Right, the bug and the fix seem completely bogus.
Please make sure the bugs are real and the fixes you sent actually 
fix them.
