Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1B7663077
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbjAITec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237679AbjAITeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:34:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06ECA48CC8
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:34:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F79D61354
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 19:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3D7C433EF;
        Mon,  9 Jan 2023 19:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673292850;
        bh=HN9aM3NaQJD9jjs3/fTNlOvH8YfDyi/3pMgZBBdN+sg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bTM3fSXwrYJ6BBHShT3dsk/SkIAnaEWWyzZWgD7PVHNFzilQ7HhjqgvBORD16iFiz
         C7BYpQqhCxnCt/l6oCR5kxacyOGyWjtr44uGTx3vrSfseNlMtvGqbRBAdbghXbB6z8
         1G9m8ObK+BygR1rz/QEDKp8fqJ/vd7yy1pbcs3ZuqAyYj8pZFPwFNFbmlC5V7DvuLJ
         VMCmsjhmwiKZqRbHbAOvkzLslMipzz5fzLYhpU48QXeZrlzlz0azkHDAEAFq+Oy2ju
         YisshSZgvMbRo3KAzWu8S9uzV5v5xBhMX0SSitREhoq6hZMRzlv7C3ell1ksj79t8H
         PqSF5Xb0sMPpQ==
Date:   Mon, 9 Jan 2023 11:34:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 2/2] net: kfree_skb_list use
 kmem_cache_free_bulk
Message-ID: <20230109113409.2d5fab44@kernel.org>
In-Reply-To: <fa1c57de-52f6-719f-7298-c606c119d1ab@redhat.com>
References: <167293333469.249536.14941306539034136264.stgit@firesoul>
        <167293336786.249536.14237439594457105125.stgit@firesoul>
        <20230106143310.699197bd@kernel.org>
        <fa1c57de-52f6-719f-7298-c606c119d1ab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Jan 2023 13:24:54 +0100 Jesper Dangaard Brouer wrote:
> > Also the lack of perf numbers is a bit of a red flag.
> >  
> 
> I have run performance tests, but as I tried to explain in the
> cover letter, for the qdisc use-case this code path is only activated
> when we have overflow at enqueue.  Thus, this doesn't translate directly
> into a performance numbers, as TX-qdisc is 100% full caused by hardware
> device being backed up, and this patch makes us use less time on freeing
> memory.

I guess it's quite subjective, so it'd be good to get a third opinion.
To me that reads like a premature optimization. Saeed asked for perf
numbers, too.

Does anyone on the list want to cast the tie-break vote?

> I have been using pktgen script ./pktgen_bench_xmit_mode_queue_xmit.sh
> which can inject packets at the qdisc layer (invoking __dev_queue_xmit).
> And then used perf-record to see overhead of SLUB (__slab_free is top#4)
> is reduced.

Right, pktgen wasting time while still delivering line rate is not of
practical importance.

> > kfree_skb_list_bulk() ?  
> 
> Hmm, IMHO not really worth changing the function name.  The
> kfree_skb_list() is called in more places, (than qdisc enqueue-overflow
> case), which automatically benefits if we keep the function name
> kfree_skb_list().

To be clear - I was suggesting a simple
  s/kfree_skb_defer_local/kfree_skb_list_bulk/
on the patch, just renaming the static helper.

IMO now that we have multiple freeing optimizations using "defer" for
the TCP scheme and "bulk" for your prior slab bulk optimizations would
improve clarity.
