Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0050560345A
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 22:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiJRUww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 16:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJRUwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 16:52:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7988275A;
        Tue, 18 Oct 2022 13:52:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B343CB8210F;
        Tue, 18 Oct 2022 20:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7904DC433D6;
        Tue, 18 Oct 2022 20:52:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="CJR6Zcc+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666126366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q2De+L2mj6ggKfV7A724gHHI+sEE+lO5v6yhYvbl6Qk=;
        b=CJR6Zcc+einEF1tRKP8x+5xs1x8uCZkRdfQwqz9MP10kn5Ad97goZ5uf/TyWgw+N3/rd7o
        EOMhd+Lp2gK1sFTXexDzbM/4At2XND7eARz2Po4Ngh7eafhCCjJcPybt9Xh85y684gXfBU
        TlhQh8zd+xILLVAj10h2JDdyTpAvw0U=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b088152b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 18 Oct 2022 20:52:45 +0000 (UTC)
Date:   Tue, 18 Oct 2022 14:52:43 -0600
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
Message-ID: <Y08SGz/xGSN87ynk@zx2c4.com>
References: <202210190108.ESC3pc3D-lkp@intel.com>
 <20221018202734.140489-1-Jason@zx2c4.com>
 <Y08PVnsTw75sHfbg@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y08PVnsTw75sHfbg@smile.fi.intel.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 11:40:54PM +0300, Andy Shevchenko wrote:
> On Tue, Oct 18, 2022 at 02:27:34PM -0600, Jason A. Donenfeld wrote:
> > On some platforms, `char` is unsigned, which makes casting -7 to char
> > overflow, which in turn makes the clamping operation bogus. Instead,
> > deal with an explicit `s8` type, so that the comparison is always
> > signed, and return an s8 result from the function as well. Note that
> > this function's result is assigned to a `short`, which is always signed.
> 
> Why not to use short? See my patch I just sent.

Trying to have the most minimal change here that doesn't rock the boat.
I'm not out to rewrite the driver. I don't know the original author's
rationales. This patch here is correct and will generate the same code
as before on architectures where it wasn't broken.

However, if you want your "change the codegen" patch to be taken
seriously, you should probably send it to the wireless maintainers like
this one, and they can decide. Personally, I don't really care either
way.

Jason
