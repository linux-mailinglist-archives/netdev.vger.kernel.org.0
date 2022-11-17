Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C1B62E175
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240396AbiKQQUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240382AbiKQQUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:20:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2F878D7F;
        Thu, 17 Nov 2022 08:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B58EEB820F9;
        Thu, 17 Nov 2022 16:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59CEC433B5;
        Thu, 17 Nov 2022 16:20:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ShJChEFk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1668702005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yXReeGYWAkNsw4+UICMYAUFCUliJi8syMU+jrBjtN+I=;
        b=ShJChEFkS/WoLTYTfqnIoulaJEVDjPgHlBF73vJKzecwUuNaBWaxad+1izxyXu6Exw/TaA
        5irR4sihjVzoDK1KiXvBd2OBPvvMwotSdLzvfkIJeE7XNMY72JeeG28zUlT5pyaHmBsZk0
        JQ9ybm2sWtI6GOjvOwFIenKMBQ/9L7c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d3e36533 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 17 Nov 2022 16:20:04 +0000 (UTC)
Date:   Thu, 17 Nov 2022 17:19:52 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Kees Cook <kees@kernel.org>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christoph =?utf-8?Q?B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
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
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org,
        ydroneaud@opteya.com
Subject: Re: [PATCH v2 3/3] treewide: use get_random_u32_between() when
 possible
Message-ID: <Y3ZfKHTHWUkdZIMt@zx2c4.com>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
 <20221114164558.1180362-4-Jason@zx2c4.com>
 <202211161436.A45AD719A@keescook>
 <Y3V4g8eorwiU++Y3@zx2c4.com>
 <Y3V6QtYMayODVDOk@zx2c4.com>
 <202211161628.164F47F@keescook>
 <Y3WDyl8ArQgeEoUU@zx2c4.com>
 <0EE39896-C7B6-4CB6-87D5-22AA787740A9@kernel.org>
 <Y3ZWbcoGOdFjlPhS@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3ZWbcoGOdFjlPhS@mit.edu>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 10:42:37AM -0500, Theodore Ts'o wrote:
> On Wed, Nov 16, 2022 at 04:47:27PM -0800, Kees Cook wrote:
> > >> > - between
> > >> > - ranged
> > >> > - spanning
> > >> > 
> > >> > https://www.thefreedictionary.com/List-of-prepositions.htm
> > >> > - amid
> > >> > 
> > >> > Sigh, names.
> > >> 
> > >> I think "inclusive" is best.
> > >
> > >I find it not very descriptive of what the function does. Is there one
> > >you like second best? Or are you convinced they're all much much much
> > >worse than "inclusive" that they shouldn't be considered?
> > 
> > Right, I don't think any are sufficiently descriptive. "Incluisve"
> > with two arguments seems unambiguous and complete to me. :)
> 
> The problem with "between", "ranged", "spanning" is that they don't
> tell the reader whether we're dealing with an "open interval" or a
> "closed interval".  They are just different ways of saying that it's a
> range between, say, 0 and 20.  But it doesn't tell you whether it
> includes 0 or 20 or not.
> 
> The only way I can see for making it ambiguous is either to use the
> terminology "closed interval" or "inclusive".  And "open" and "closed"
> can have other meanings, so get_random_u32_inclusive() is going to be
> less confusing than get_random_u32_closed().

Alright, that about settles it then. I'll re-roll.

Jason
