Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DA0661A0D
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 22:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbjAHVeL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Jan 2023 16:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbjAHVeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 16:34:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E55A2652;
        Sun,  8 Jan 2023 13:34:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A027B80B97;
        Sun,  8 Jan 2023 21:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71FBC433EF;
        Sun,  8 Jan 2023 21:34:04 +0000 (UTC)
Date:   Sun, 8 Jan 2023 16:34:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yunhui Cui <cuiyunhui@bytedance.com>
Cc:     mhiramat@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        xiyou.wangcong@gmail.com, duanxiongchun@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] sock: add tracepoint for send recv length
Message-ID: <20230108163403.37e3f25d@rorschach.local.home>
In-Reply-To: <20230107035923.363-1-cuiyunhui@bytedance.com>
References: <20230107035923.363-1-cuiyunhui@bytedance.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Jan 2023 11:59:23 +0800
Yunhui Cui <cuiyunhui@bytedance.com> wrote:

> Add 2 tracepoints to monitor the tcp/udp traffic
> of per process and per cgroup.
> 
> Regarding monitoring the tcp/udp traffic of each process, there are two
> existing solutions, the first one is https://www.atoptool.nl/netatop.php.
> The second is via kprobe/kretprobe.
> 
> Netatop solution is implemented by registering the hook function at the
> hook point provided by the netfilter framework.
> 
> These hook functions may be in the soft interrupt context and cannot
> directly obtain the pid. Some data structures are added to bind packets
> and processes. For example, struct taskinfobucket, struct taskinfo ...
> 
> Every time the process sends and receives packets it needs multiple
> hashmaps,resulting in low performance and it has the problem fo inaccurate
> tcp/udp traffic statistics(for example: multiple threads share sockets).
> 
> We can obtain the information with kretprobe, but as we know, kprobe gets
> the result by trappig in an exception, which loses performance compared
> to tracepoint.
> 
> We compared the performance of tracepoints with the above two methods, and
> the results are as follows:
> 
> ab -n 1000000 -c 1000 -r http://127.0.0.1/index.html
> without trace:
> Time per request: 39.660 [ms] (mean)
> Time per request: 0.040 [ms] (mean, across all concurrent requests)
> 
> netatop:
> Time per request: 50.717 [ms] (mean)
> Time per request: 0.051 [ms] (mean, across all concurrent requests)
> 
> kr:
> Time per request: 43.168 [ms] (mean)
> Time per request: 0.043 [ms] (mean, across all concurrent requests)
> 
> tracepoint:
> Time per request: 41.004 [ms] (mean)
> Time per request: 0.041 [ms] (mean, across all concurrent requests
> 
> It can be seen that tracepoint has better performance.
> 
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> Signed-off-by: Xiongchun Duan <duanxiongchun@bytedance.com>
> ---


From a tracing POV:

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
