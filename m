Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD38514DAB
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377697AbiD2Oms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377723AbiD2Olc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:41:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C0D366B9;
        Fri, 29 Apr 2022 07:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE571615B1;
        Fri, 29 Apr 2022 14:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82EDC385A7;
        Fri, 29 Apr 2022 14:37:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nmURRhmF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651243042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n4+Hrsa3/2uZn2FjMlvF3cp+u5Zrs5QPWYxXzJ56pZo=;
        b=nmURRhmF7lDoOMEuvqYf5EPmb7EXSskhUre4xdQLNsIN+4cuYCHOmHNQhBaPDYGm/gbqHu
        FIEb7BcrkFVYDN+GU04ur3OVWSYQ0HDv5fi/JxtwxcTtuIky5uSNDSjqPkBZFToy7rwhd2
        xqjE2Xs3Jg20BItfi3t2/9BNQJa0aew=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9798adb4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 29 Apr 2022 14:37:21 +0000 (UTC)
Date:   Fri, 29 Apr 2022 16:37:12 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Willy Tarreau <w@1wt.eu>, edumazet@google.com
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 3/7] tcp: resalt the secret every 10 seconds
Message-ID: <Ymv4GAezJlA1+Vfs@zx2c4.com>
References: <20220428124001.7428-1-w@1wt.eu>
 <20220428124001.7428-4-w@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220428124001.7428-4-w@1wt.eu>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Thu, Apr 28, 2022 at 02:39:57PM +0200, Willy Tarreau wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> In order to limit the ability for an observer to recognize the source
> ports sequence used to contact a set of destinations, we should
> periodically shuffle the secret. 10 seconds looks effective enough
Nit: "periodically re-salt the input".
> without causing particular issues.

Just FYI, moving from siphash_3u32 to siphash_4u32 is not free, as it
bumps us up from siphash_3u32 to siphash_2u64, which does two more
siphash rounds. Maybe this doesn't matter much, but just FYI.

I wonder, though, about your "10 seconds looks effective enough without
causing particular issues." I surmise from that sentence that a lower
value might cause particular issues, but that you found 10 seconds to be
okay in practice. Fine. But what happens if one caller hits this at
second 9 and the next caller hits it at second 0? In that case, the
interval might have been 1 second, not 10. In other words, if you need
a certain minimum quantization for this to not cause "particular
issues", it might not work the way you wanted it to.

Additionally, that problem aside, if you round EPHEMERAL_PORT_SHUFFLE_PERIOD
to the nearest power of two, you can turn the expensive division into a
bit shift right.

Regards,
Jason
