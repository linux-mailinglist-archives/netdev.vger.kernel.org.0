Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C91860B6FD
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiJXTO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbiJXTOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:14:20 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8828785B3;
        Mon, 24 Oct 2022 10:52:45 -0700 (PDT)
Date:   Mon, 24 Oct 2022 09:02:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666627336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O/N8OMyo9s1B/PNzZrAaI2GwA6VF66/CDcmX3TC5Nt4=;
        b=l4eEMprVk58nUDlv7z8FLEtx1aDuXiDvMj360HMeYTGq6NRIH1TIsuS3fqHASZY9kxebW7
        qvFokj5qToXX63woIoDXoYP8WjTUL76BZfpkZUHbZydTeXRvQyNqJDw5SLNeF1pqSQbwS1
        pqOcY8XcupnBJnfONszHBqJc5ASMClY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     edumazet@google.com, netdev@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, cgroups@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>, weiwan@google.com,
        ncardwell@google.com, ycheng@google.com
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
Message-ID: <Y1a3BHQqllCEymHi@P9FQF9L96D>
References: <20221021160304.1362511-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021160304.1362511-1-kuba@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 09:03:04AM -0700, Jakub Kicinski wrote:
> As Shakeel explains the commit under Fixes had the unintended
> side-effect of no longer pre-loading the cached memory allowance.
> Even tho we previously dropped the first packet received when
> over memory limit - the consecutive ones would get thru by using
> the cache. The charging was happening in batches of 128kB, so
> we'd let in 128kB (truesize) worth of packets per one drop.
> 
> After the change we no longer force charge, there will be no
> cache filling side effects. This causes significant drops and
> connection stalls for workloads which use a lot of page cache,
> since we can't reclaim page cache under GFP_NOWAIT.
> 
> Some of the latency can be recovered by improving SACK reneg
> handling but nowhere near enough to get back to the pre-5.15
> performance (the application I'm experimenting with still
> sees 5-10x worst latency).
> 
> Apply the suggested workaround of using GFP_ATOMIC. We will now
> be more permissive than previously as we'll drop _no_ packets
> in softirq when under pressure. But I can't think of any good
> and simple way to address that within networking.
> 
> Link: https://lore.kernel.org/all/20221012163300.795e7b86@kernel.org/
> Suggested-by: Shakeel Butt <shakeelb@google.com>
> Fixes: 4b1327be9fe5 ("net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
