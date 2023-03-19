Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01B56C047F
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjCSTnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCSTnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:43:06 -0400
Received: from mx03lb.world4you.com (mx03lb.world4you.com [81.19.149.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72D3126C6;
        Sun, 19 Mar 2023 12:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2S3XcKrxpllatvyZR/d1hy91S8a1rPUKUx3briQkCzM=; b=QTYBQeRcCtySaMdhNnGFvZ/tdU
        0vYVaGzFWwDuHGbpq3qJ1o/QvZOeKWzYbQvd8QPV4lYLzngwS+Ji175NuKslzeQBQ0C1y0c5oGWfI
        twBmIa60QIyEKjxzfI0Wpk4CMVxgKqv2rRq65I6a42aC1FGZxPCDYTfJKXInaQMPieHM=;
Received: from [88.117.56.218] (helo=[10.0.0.160])
        by mx03lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pdyvj-00044b-Fy; Sun, 19 Mar 2023 20:42:59 +0100
Message-ID: <867eb8dc-0c4c-4d12-7c71-5fbd44fc348d@engleder-embedded.com>
Date:   Sun, 19 Mar 2023 20:42:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH net] bpf: Fix unregister memory model in BPF_PROG_RUN
 in test runner
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, hawk@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, toke@redhat.com, song@kernel.org
References: <20230311213709.42625-1-gerhard@engleder-embedded.com>
Content-Language: en-US
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230311213709.42625-1-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.03.23 22:37, Gerhard Engleder wrote:
> After executing xdp-trafficgen the following kernel output appeared:
> [  214.564375] page_pool_release_retry() stalled pool shutdown 64 inflight 60 sec
> 
> xdp_test_run_batch() in combination with xdp-trafficgen uses a batch
> size of 64. So it seems that a single batch does find its way back to
> the page pool. I checked my tsnep driver, but the page pool entries were
> not lost in the driver according to my analysis.
> 
> Executing xdp-trafficgen with n=1000 resulted in this output:
> [  251.652376] page_pool_release_retry() stalled pool shutdown 40 inflight 60 sec
> 
> Executing xdp-trafficgen with n=10000 resulted in this output:
> [  267.332374] page_pool_release_retry() stalled pool shutdown 16 inflight 60 sec
> 
> So interestingly in both cases the last batch with a size lower than 64
> does not find its way back to the page pool. So what's the problem with
> the last batch?
> 
> After xdp_test_run_batch() clean up is done in xdp_test_run_teardown()
> no matter if page pool entries are still in flight. No problem for
> page_pool_destroy() as the page pool is released later when no entries
> are in flight.
> 
> With commit 425d239379db0 unregistering memory model has been added to
> xdp_test_run_teardown(). Otherwise the page pool would not be released.
> But xdp_unreg_mem_model() resets the memory model type immediately to 0
> (which is actually MEM_TYPE_PAGE_SHARED). So the memory model type
> MEM_TYPE_PAGE_POOL is lost and any inflight page pool entries have no
> chance to find its way back to the page pool. I assume that's the reason
> why the last batch does not find its way back to the page pool.
> 
> A simple sleep before xdp_unreg_mem_model() solved this problem, but
> this is no valid fix of course. It needs to be ensured that the memory
> model is not in use anymore. This is the case when the page pool has no
> entries in flight.
> 
> How could it be ensured that a call to xdp_unreg_mem_model() is safe?
> In my opinion drivers suffer the same problem. Is there a pattern how
> this can be solved? Or did I misinterprete something?
> 
> Fixes: 425d239379db0 ("bpf: Fix release of page_pool in BPF_PROG_RUN in test runner")
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>   net/bpf/test_run.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index b766a84c8536..eaccfdab0be3 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -202,6 +202,8 @@ static int xdp_test_run_setup(struct xdp_test_data *xdp, struct xdp_buff *orig_c
>   
>   static void xdp_test_run_teardown(struct xdp_test_data *xdp)
>   {
> +	usleep_range(10000, 11000);
> +
>   	xdp_unreg_mem_model(&xdp->mem);
>   	page_pool_destroy(xdp->pp);
>   	kfree(xdp->frames);

I did not get any reply. Did I post it the wrong the way?

I did post it as RFC as I have no clear idea how to fix that. But maybe
I'm wrong and there is no problem. Would be great to hear your opinion 
about this issue.

Gerhard
