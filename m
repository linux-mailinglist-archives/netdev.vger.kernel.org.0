Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034055A0869
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 07:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiHYFVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 01:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiHYFVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 01:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A99D9DB79;
        Wed, 24 Aug 2022 22:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6AAB616F1;
        Thu, 25 Aug 2022 05:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F9BC433D6;
        Thu, 25 Aug 2022 05:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661404912;
        bh=AnKrb1Ct86zWoZc2cR8mHfo305wchMKv2BEvmUehEfA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QundzHzoSD285RvlDevYssYd0+eBJWvLpiws5T0NJRxeZcpTf/6HAWQ6nRYpD05/L
         Jo7K04tJKiBzbEwarfN/+9T/St1bo6xkgoING+DmJ1b6qFnnXmAS6URsD+huaj8WI/
         pC9DzwN3tmyooTXX3GJR8yBcpQ0GBO+NebpLXbTY=
Date:   Wed, 24 Aug 2022 22:21:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>, lkp@lists.01.org,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] mm: page_counter: rearrange struct page_counter
 fields
Message-Id: <20220824222150.61c516a83bfe0ecb6c9b5348@linux-foundation.org>
In-Reply-To: <CALvZod6+Y1yvp8evMLTeEwKnQyoXJmzjO7xLN9w=EPcOUH6BHQ@mail.gmail.com>
References: <20220825000506.239406-1-shakeelb@google.com>
        <20220825000506.239406-3-shakeelb@google.com>
        <20220824173330.2a15bcda24d2c3c248bc43c7@linux-foundation.org>
        <CALvZod6+Y1yvp8evMLTeEwKnQyoXJmzjO7xLN9w=EPcOUH6BHQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 21:41:42 -0700 Shakeel Butt <shakeelb@google.com> wrote:

> > Did you evaluate the effects of using a per-cpu counter of some form?
> 
> Do you mean per-cpu counter for usage or something else?

percpu_counter, perhaps.  Or some hand-rolled thing if that's more suitable.

> The usage
> needs to be compared against the limits and accumulating per-cpu is
> costly particularly on larger machines,

Well, there are tricks one can play.  For example, only run
__percpu_counter_sum() when `usage' is close to its limit.  

I'd suggest flinging together a prototype which simply uses
percpu_counter_read() all the time.  If the performance testing results
are sufficiently promising, then look into the accuracy issues.

