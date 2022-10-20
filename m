Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57019605DB4
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiJTKk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiJTKku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:40:50 -0400
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D113511540E
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:40:43 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 29077 invoked from network); 20 Oct 2022 12:40:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1666262440; bh=YiUYx4m1KM/++4m8L0pp6WOehdY09Qob4zZNKzryBSc=;
          h=From:To:Cc:Subject;
          b=SECSFuLFtgLY+UIoEigmDcOl4MC6ss6ytWo9jjV0fEzw7xVgLsYqSwC/86Dpqwxa1
           6Pavi4Mwde2eBYetegBlN3B9j0o95A1Tpy0wCCRmO8G9CH6KKxRE1k95Mp1dcb3d4M
           ihbMWosePD4EeMjVu6w+qtwEcafWE1MJVp0IckmY=
Received: from 89-64-7-202.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.7.202])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <andriy.shevchenko@linux.intel.com>; 20 Oct 2022 12:40:40 +0200
Date:   Thu, 20 Oct 2022 12:40:40 +0200
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
Message-ID: <20221020104040.GB95289@wp.pl>
References: <202210190108.ESC3pc3D-lkp@intel.com>
 <20221018202734.140489-1-Jason@zx2c4.com>
 <20221019085219.GA81503@wp.pl>
 <Y0/Z2aHKYVPsiWa5@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0/Z2aHKYVPsiWa5@smile.fi.intel.com>
X-WP-MailID: 09a596413a20ffdf6a3f0dbf20015b16
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [AWP0]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 02:04:57PM +0300, Andy Shevchenko wrote:
> On Wed, Oct 19, 2022 at 10:52:19AM +0200, Stanislaw Gruszka wrote:
> > On Tue, Oct 18, 2022 at 02:27:34PM -0600, Jason A. Donenfeld wrote:
> > > On some platforms, `char` is unsigned, which makes casting -7 to char
> > > overflow, which in turn makes the clamping operation bogus. Instead,
> > > deal with an explicit `s8` type, so that the comparison is always
> > > signed, and return an s8 result from the function as well. Note that
> > > this function's result is assigned to a `short`, which is always signed.
> > > 
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> > > Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> > > Cc: Kalle Valo <kvalo@kernel.org>
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > 
> > I prefer s8 just because is shorter name than short :-)
> 
> Shouldn't the corresponding data structure type be fixed accordingly?

We can change types of channel_info default_power* fields in rt2x00.h,
but I'm a bit reluctant to do so, as I'm afraid this could change
actual power values sent to the hardware and will require careful
verification.

Regards
Stanislaw
