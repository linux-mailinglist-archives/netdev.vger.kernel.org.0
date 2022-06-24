Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89802558D0E
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 03:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiFXB5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 21:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiFXB5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 21:57:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5237260C76;
        Thu, 23 Jun 2022 18:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4FA862023;
        Fri, 24 Jun 2022 01:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B392C3411D;
        Fri, 24 Jun 2022 01:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656035860;
        bh=A5G1y5zfAakBvev3o+XJTirP3qP3skGJx2wBFS2dMIw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NjKjfEStvKxSWdi9XBcvE5z2PoJQ+rRQOSMkMkbJY0GP0VoRTsPwg9uwXpmXN1cvd
         xU6FarBJ5y1fQR2qVqKLuGdOHOdhGQRQuJX9ctEO+u1izzWm6xBvbhiefSVZrCnoPX
         PilF/HnqBRc6tuVGYzt2xvXD2+Lxr6ZtOiEtedEtv9GmJEhWFkaX5rqDDGyxwjV4N8
         wId5i2oWRkpJ5yRyitMGL4QJ6wWk3Am92+3kp8HX+9MjWEFXcvfYQACVljd0P8mwmj
         uwbSRHSLYlTYBy57r5Yaam5U1qLUZvo5XbLYt7E+Q9m2mcLXLDsC4m8Jf5AqATNa1O
         SNi52mAnS305Q==
Date:   Thu, 23 Jun 2022 18:57:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        kernel test robot <oliver.sang@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        network dev <netdev@vger.kernel.org>,
        linux-s390@vger.kernel.org, mptcp@lists.linux.dev,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        lkp@lists.01.org, kbuild test robot <lkp@intel.com>,
        Huang Ying <ying.huang@intel.com>, feng.tang@intel.com,
        zhengjun.xing@linux.intel.com, fengwei.yin@intel.com,
        Ying Xu <yinxu@redhat.com>
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
Message-ID: <20220623185730.25b88096@kernel.org>
In-Reply-To: <CADvbK_eQUmb942vC+bG+NRzM1ki1LiCydEDR1AezZ35Jvsdfnw@mail.gmail.com>
References: <20220619150456.GB34471@xsang-OptiPlex-9020>
        <20220622172857.37db0d29@kernel.org>
        <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
        <CADvbK_eQUmb942vC+bG+NRzM1ki1LiCydEDR1AezZ35Jvsdfnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 18:50:07 -0400 Xin Long wrote:
> From the perf data, we can see __sk_mem_reduce_allocated() is the one
> using CPU the most more than before, and mem_cgroup APIs are also
> called in this function. It means the mem cgroup must be enabled in
> the test env, which may explain why I couldn't reproduce it.
> 
> The Commit 4890b686f4 ("net: keep sk->sk_forward_alloc as small as
> possible") uses sk_mem_reclaim(checking reclaimable >= PAGE_SIZE) to
> reclaim the memory, which is *more frequent* to call
> __sk_mem_reduce_allocated() than before (checking reclaimable >=
> SK_RECLAIM_THRESHOLD). It might be cheap when
> mem_cgroup_sockets_enabled is false, but I'm not sure if it's still
> cheap when mem_cgroup_sockets_enabled is true.
> 
> I think SCTP netperf could trigger this, as the CPU is the bottleneck
> for SCTP netperf testing, which is more sensitive to the extra
> function calls than TCP.
> 
> Can we re-run this testing without mem cgroup enabled?

FWIW I defer to Eric, thanks a lot for double checking the report 
and digging in!
