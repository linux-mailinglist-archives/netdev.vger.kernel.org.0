Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC9C6231C1
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 18:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiKIRqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 12:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiKIRqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 12:46:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B17264F9
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 09:46:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 159C7B80AE1
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 17:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38585C433D6;
        Wed,  9 Nov 2022 17:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668015998;
        bh=AEV2on7v3Wqf+NZxt1Tb77L50IvgWqqp5YrPSSQaOuc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=txU4AWDhH1jna551XfHzi2ODumMz3fOJKz1H+MYW0bXGiBaxbB+tPB/bL6tOG/A2N
         3mRL+yhMADwWRtddCByHbMbTyaJje4kAe+79Ln+6Z+kI0TiVt/xIrgnBT6r/abBqTG
         YPafOkEOuwkLefgfL7i3zEx9GE1dABFUBt/75PttXUlLuW/XU3GCq0JaqGtOHMt5EB
         4R78AohLxhIFUlXo/GR4GiUDW7vQsnASRNgCg4CadCO7S0iBOGVNSLHApwE+SeSfv5
         eQjkEe4XefwbrFegnjDwP0wjONFx0D7a/gp0UGyUzLeXnyQweqqYeRvx6XTHnr6nl9
         1PMjKXkzOinrg==
Date:   Wed, 9 Nov 2022 19:46:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jonathan Lemon <bsd@meta.com>,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] genetlink: fix policy dump for dumps
Message-ID: <Y2vnesR4cNMVF4Jn@unreal>
References: <20221108204041.330172-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108204041.330172-1-kuba@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 12:40:41PM -0800, Jakub Kicinski wrote:
> Jonathan reports crashes when running net-next in Meta's fleet.

I experience these crashes too.

> Stats collection uses ethtool -I which does a per-op policy dump
> to check if stats are supported. We don't initialize the dumpit
> information if doit succeeds due to evaluation short-circuiting.
> 
> The crash may look like this:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000cc0
>    RIP: 0010:netlink_policy_dump_add_policy+0x174/0x2a0
>      ctrl_dumppolicy_start+0x19f/0x2f0
>      genl_start+0xe7/0x140
> 
> Or we may trigger a warning:
> 
>    WARNING: CPU: 1 PID: 785 at net/netlink/policy.c:87 netlink_policy_dump_get_policy_idx+0x79/0x80
>    RIP: 0010:netlink_policy_dump_get_policy_idx+0x79/0x80
>      ctrl_dumppolicy_put_op+0x214/0x360
> 
> depending on what garbage we pick up from the stack.
> 
> Reported-by: Jonathan Lemon <bsd@meta.com>
> Fixes: 26588edbef60 ("genetlink: support split policies in ctrl_dumppolicy_put_op()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jacob.e.keller@intel.com
> ---
>  net/netlink/genetlink.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

I added your updated patch to my CI run. Unfortunately, the regression
system is overloaded due to nightly regression so won't be able to get
results in sensible time frame.

Thanks
