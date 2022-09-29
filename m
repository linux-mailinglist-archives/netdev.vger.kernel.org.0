Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EED5EED9E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 08:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbiI2GKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 02:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbiI2GKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 02:10:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86452419A8;
        Wed, 28 Sep 2022 23:10:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 379DDB8233F;
        Thu, 29 Sep 2022 06:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3AEC43470;
        Thu, 29 Sep 2022 06:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664431807;
        bh=7xmld9n+ZLflyYVZz9glPsXOPPIb/gqWQ8A/fN+pZ54=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DK+7r5ydZMxp87D2zNRYNIdT0cZ5cYfu9nq3mKD9uJW1HIP4axW6y2mtMFDbflQt1
         DsJe/SuoQ7Uug+VddWBQy6CgspEYI1uBsmXG3ZCBUpWAmXjRIFvLn1vMFe8/Us298k
         Rv054bf0QFjnFHQXN4lZhbvQt8MFPhPHAWHsXl/G0Gf4MDNHC86srEMYWWXwWbhFsR
         jlGDP3Kpf5CLP+3SmFjT1ayifVf81Qsf94vp/AHoIqufh06G2N9XSRw4xzBU8AhCHa
         ba/fJQJMYNisrCi5lA2eE9/ToZQ9wUyMBh1exyuP8kGoeWJVf9fYRRyB5X1TYmqz76
         uRcV5Y0lZBkJQ==
Date:   Thu, 29 Sep 2022 09:10:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     asmadeus@codewreck.org
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
Message-ID: <YzU2u+hEmx0kZhb5@unreal>
References: <00000000000015ac7905e97ebaed@google.com>
 <YzQuoqyGsooyDfId@codewreck.org>
 <YzQ12+jtARpwS5bw@unreal>
 <1783490.kFEjeSjHVE@silver>
 <YzTCOGCo5mIxwf9S@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzTCOGCo5mIxwf9S@codewreck.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 06:52:56AM +0900, asmadeus@codewreck.org wrote:

<...>

> > From technical perspective, yes, destruction in reverse order is usually the 
> > better way to go. Whether I would carve that in stone, without any exception, 
> > probably not.
> 
> I think it's a tradeoff really.
> Unrolling in place is great, don't get me wrong, but it's also easy to
> miss things when adding code later on -- we actually just did that and
> got another kasan report which made me factor things in to future-proof
> the code.
> 
> Having a single place of truth that knows how to "untangle" and properly
> free a struct, making sure it is noop for parts of the struct that
> haven't been initialized yet, is less of a burden for me to think about.

It is not bikeshedding or tradeoff, but matter of well-proven coding
patterns, which are very helpful for review and code maintaining.

Thanks
