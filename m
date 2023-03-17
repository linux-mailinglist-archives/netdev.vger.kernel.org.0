Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857926BDD7E
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjCQAUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCQAU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:20:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC776CA1C2;
        Thu, 16 Mar 2023 17:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78DC4B8213B;
        Fri, 17 Mar 2023 00:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB7CC433D2;
        Fri, 17 Mar 2023 00:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679012422;
        bh=Th0HzCVznMJP+vsrr+8aYTUrND8k6KjTcTg2x8Cwk7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r/T9qYOUnTN4fbu14xtlKee6gFtyVn7cU+upPif26EO90QlFBOL4jnZlaWcWPUuUD
         S2ga/UqKVGUO2x+Km6hmhQZjWWcgzVVAFInFAhAWz5f31taEVE6iMLMlIGjppsfiuM
         +S9TiUQYm3vB/zTEo6qHWrhdo250Q1Tnp7JJSL7msnzZS2ZOffHb0kdoUk8LGRVDOT
         0R671cQJD3jSsq+QxQZJa57ZXoLE8CIDVdC5ywYT5Kb7R2qS2TQ3NcjHBlc4OvIW8v
         YrwxH8BfRtPy03PJCCLun3DPGx0wIIbIdAfM69aL9eGCclDseyQ14fJdytGlkHp/Bb
         SnoI8jsB4S8Hw==
Date:   Thu, 16 Mar 2023 17:20:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help
 us tune rx behavior
Message-ID: <20230316172020.5af40fe8@kernel.org>
In-Reply-To: <20230315092041.35482-3-kerneljasonxing@gmail.com>
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
        <20230315092041.35482-3-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 17:20:41 +0800 Jason Xing wrote:
> In our production environment, there're hundreds of machines hitting the
> old time_squeeze limit often from which we cannot tell what exactly causes
> such issues. Hitting limits aranged from 400 to 2000 times per second,
> Especially, when users are running on the guest OS with veth policy
> configured, it is relatively easier to hit the limit. After several tries
> without this patch, I found it is only real time_squeeze not including
> budget_squeeze that hinders the receive process.

That is the common case, and can be understood from the napi trace
point and probing the kernel with bpftrace. We should only add
uAPI for statistics which must be maintained contiguously. For
investigations tracing will always be orders of magnitude more
powerful :(

On the time squeeze BTW, have you found out what the problem was?
In workloads I've seen the time problems are often because of noise 
in how jiffies are accounted (cgroup code disables interrupts
for long periods of time, for example, making jiffies increment 
by 2, 3 or 4 rather than by 1).

> So when we encounter some related performance issue and then get lost on
> how to tune the budget limit and time limit in net_rx_action() function,
> we can separately counting both of them to avoid the confusion.
