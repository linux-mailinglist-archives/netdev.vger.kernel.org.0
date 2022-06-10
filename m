Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD67546C33
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241445AbiFJSQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346557AbiFJSQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 14:16:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A4E1B7814
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 11:16:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BE08621D7
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 18:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B083AC34114;
        Fri, 10 Jun 2022 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654884969;
        bh=mrJ2s15cRuyuggCeUhE/koIAgXwRvFou4HV7jYKWTIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ip4wz+s5HuAKDxvOfallKI2l9YpXlYYrQMkIir7ZqHay6JgAyKgSwnRs+Z6ZRmPqs
         3FG/6GHRibTP/TLaJSNYV4sawD9vnND/2+WXIWcgjlnqBd5evq4mTmiNFiPqGfLbvJ
         Z3Z6AvoGaKVo5agY9Zkha2x0Bu5OL/FS6AK0FtnyVCffNO/XncNPNz71GeilkhwHoh
         4isBxWUmPU/jKQkSbM6TGsCACZoU0dHnUe6tOZElOsny/kdOy1DaLjxPNHhZQ5QVmX
         ppHVbmAGDn1aFCuGigDSx+EN9JOG31gbtiSYN5doTAHG4Gk4d0bHI1bhBybpNJGjjT
         6Nuh7t30XFvAw==
Date:   Fri, 10 Jun 2022 11:16:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Ossama Othman <ossama.othman@intel.com>,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 1/2] mptcp: fix conflict with <netinet/in.h>
Message-ID: <20220610111607.38b003e1@kernel.org>
In-Reply-To: <d4c74484-da9-8af3-e25b-93de29443840@linux.intel.com>
References: <20220608191919.327705-1-mathew.j.martineau@linux.intel.com>
        <20220608191919.327705-2-mathew.j.martineau@linux.intel.com>
        <20220609225936.4cba4860@kernel.org>
        <d4c74484-da9-8af3-e25b-93de29443840@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022 11:00:28 -0700 (PDT) Mat Martineau wrote:
> This is a minor "fix" to be sure, which I thought did not meet the bar for 
> net and therefore submitted for net-next. It's not prep for another 
> change, it's something Ossama and I noticed when doing code review for a 
> userspace program that included the header. There's no problem with kernel 
> compilation, and there's also no issue if the userspace program happens to 
> include netinet/in.h before linux/mptcp.h
> 
> 
> If my threshold for the net branch is too high, I have no objection to 
> having this patch applied there and will recalibrate :)
> 
> Do you prefer to have no Fixes: tags in net-next, or did that just seem 
> ambiguous in this case?

The important point is that the middle ground of marking things as fixes
and at the same time putting them in -next, to still get them
backported but with an extended settling time -- that middle ground
does not exist.

If we look at the patch from the "do we want it backported or not"
perspective I think the answer is yes, hence I'd lean towards net.
If you think it doesn't matter enough for backport - we can drop the
fixes tag and go with net-next. Unfortunately I don't have enough
direct experience to tell how annoying this will be to the user space.
netinet/in.h vs linux/in.h is a mess :(
