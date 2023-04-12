Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE5C6DF7C0
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjDLNyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjDLNyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:54:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9325E173A
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C4E36354A
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 13:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18513C433EF;
        Wed, 12 Apr 2023 13:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681307649;
        bh=YrCxrrj3G0PAJOX+6zWZRmM5HqwWlgsB7fkdn30miBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R8cA9IEtfEf5wvqrm5iKMRi73noRqMZeC/Ypf0ENWq485bBh+Yiha6L5FfUa+PJs1
         Rz+/8CzwzNmQyD03t/7PZ8Q4hofAdMZpELLlWBnOY0CZ7swwCqIc5Oa23mHoZD2bwj
         GkCakbairP6hqjO0ClWkK+bisZ1BjiURe19nvDRTkXNQbOAcm+y7CEGDLFOSE4Fc1u
         XSEQl3iCmjBJPUA7wmIsDVEpRkk3o+prkS0lK2Aocz2WHIYgPuntL+l8RN8C2UDmen
         Su7Ig4q1wDuOChy8LpVQpOvzWbsBeRAHLy2OnBJj22Wqk4lC9j/p+Lz0LXu1QGLt0D
         hmBPsJC0grw+g==
Date:   Wed, 12 Apr 2023 06:54:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, alexander.duyck@gmail.com, hkallweit1@gmail.com,
        andrew@lunn.ch, willemb@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v3 7/7] net: piggy back on the memory barrier
 in bql when waking queues
Message-ID: <20230412065408.59e02bb7@kernel.org>
In-Reply-To: <ZDZKaoPaiy6Itj7P@gondor.apana.org.au>
References: <20230405223134.94665-1-kuba@kernel.org>
        <20230405223134.94665-8-kuba@kernel.org>
        <ZC52VRfUOOObx2fw@gondor.apana.org.au>
        <20230406174140.36930b15@kernel.org>
        <ZDZKaoPaiy6Itj7P@gondor.apana.org.au>
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

On Wed, 12 Apr 2023 14:06:34 +0800 Herbert Xu wrote:
> On Thu, Apr 06, 2023 at 05:41:40PM -0700, Jakub Kicinski wrote:
> > I wanted to keep the same semantics as netdev_tx_completed_queue()
> > which only barriers if (bytes). Not in the least to make it obvious
> > to someone looking at the code of netdev_txq_completed_mb() (and not
> > the comment above it) that it doesn't _always_ put a barrier in.  
> 
> OK, but I think we should instead change netdev_tx_compelted_queue
> to do the smp_mb unconditionally.  We should never optimise for the
> unlikely case, and it is extremely unlikely for a TX cleanup routine
> to wind up with nothing to do.

I don't understand what you're trying to argue. The whole point of 
the patch is to use the BQL barrier and BQL returns early, before 
the barrier.

I don't think many people actually build kernels with BQL=n so the other
branch is more *documentation* than it is relevant, executed code.
