Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AAC608C3A
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 13:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiJVLEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 07:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiJVLDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 07:03:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A6C140A6;
        Sat, 22 Oct 2022 03:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE36760BBF;
        Sat, 22 Oct 2022 10:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97FEC433D6;
        Sat, 22 Oct 2022 10:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666434090;
        bh=4VayhwOVTKVAjPqqz97sF96LRLG+KRcajksLHZHtUxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wOx3mp5ksWJtvhNhAOmZUG8X3+HuRkTdY9Nc7h6cWFEIxsW4svt4t9REDVX0plI4T
         0jvG2TdFgRx98jdox1K2bPVjxSRKOYymF+6X8vmbsIcB0hIMeoD9P7/9qN6LIAT+Ko
         fQekZTeUTocY/mdL9wRqCZaeHaw+pLcmNqIWDT+k=
Date:   Sat, 22 Oct 2022 12:21:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Darrick J . Wong" <djwong@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH v1 0/5] convert tree to
 get_random_u32_{below,above,between}()
Message-ID: <Y1PEJxnlY7dh4yK8@kroah.com>
References: <20221022014403.3881893-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221022014403.3881893-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 09:43:58PM -0400, Jason A. Donenfeld wrote:
> Hey everyone,
> 
> Here's the second and final tranche of tree-wide conversions to get
> random integer handling a bit tamer. It's predominantly another
> Coccinelle-based patchset.
> 
> First we s/prandom_u32_max/get_random_u32_below/, since the former is
> just a deprecated alias for the latter. Then in the next commit we can
> remove prandom_u32_max all together. I'm quite happy about finally being
> able to do that. It means that prandom.h is now only for deterministic and 
> repeatable randomness, not non-deterministic/cryptographic randomness.
> That line is no longer blurred.
> 
> Then, in order to clean up a bunch of inefficient patterns, we introduce
> two trivial static inline helper functions built on top of
> get_random_u32_below: get_random_u32_above and get_random_u32_between.
> These are pretty straight forward to use and understand. Then the final
> two patches convert some gnarly open-coded number juggling to use these
> helpers.
> 
> I've used Coccinelle for all the treewide patches, so hopefully review
> is rather uneventful. I didn't accept all of the changes that Coccinelle
> proposed, though, as these tend to be somewhat context-specific. I erred
> on the side of just going with the most obvious cases, at least this
> time through. And then we can address more complicated cases through
> actual maintainer trees.
> 
> Since get_random_u32_below() sits in my random.git tree, these patches
> too will flow through that same tree.
> 
> Regards,
> Jason


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
