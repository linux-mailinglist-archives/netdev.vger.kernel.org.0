Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02E46E553A
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 01:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjDQXcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 19:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDQXcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 19:32:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C06DA4;
        Mon, 17 Apr 2023 16:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0DAC6209F;
        Mon, 17 Apr 2023 23:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1C3C433EF;
        Mon, 17 Apr 2023 23:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681774332;
        bh=4qE9NfxkI33Wn/KoQ5gjCEF1BUWC+qJgfq+1TZFENLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fOllUS+95UEUj5CZHPpOd1q3B93WfaKg0gVmcQOhheJbUs+m6eEEeSAdqzrQHx/bq
         +6K6/29JBAj9tt7xHn6h6biZduvYHcHP6fXVX6DdfnCFYP7VzDogfMnNcpldhCA88b
         LrYSMgmpMQgsYzwqZ4mX74CviW/bF6amyePG/QmzsnJJmkniWYuUw0ynhR/7o6A9X8
         Ca7rgyniHFSW9NSNGUPzO0KnoF42jOgTn7Sa+x2o/K3LuNj4qTWsbokO6y+1BsOqMx
         biVXdQwRSGvNjjTJhbU+ydKW0ZZS6KxviK47t3vHUH+zHfvytClP2h89cW35BD9KZx
         uHCNXQY21Qqqw==
Date:   Mon, 17 Apr 2023 16:32:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
Subject: Re: issue with inflight pages from page_pool
Message-ID: <20230417163210.2433ae40@kernel.org>
In-Reply-To: <ZD26lb2qdsdX16qa@lore-desk>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
        <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
        <ZD2NSSYFzNeN68NO@lore-desk>
        <20230417112346.546dbe57@kernel.org>
        <ZD2TH4PsmSNayhfs@lore-desk>
        <20230417120837.6f1e0ef6@kernel.org>
        <ZD26lb2qdsdX16qa@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 23:31:01 +0200 Lorenzo Bianconi wrote:
> > If it's that then I'm with Eric. There are many ways to keep the pages
> > in use, no point working around one of them and not the rest :(  
> 
> I was not clear here, my fault. What I mean is I can see the returned
> pages counter increasing from time to time, but during most of tests,
> even after 2h the tcp traffic has stopped, page_pool_release_retry()
> still complains not all the pages are returned to the pool and so the
> pool has not been deallocated yet.
> The chunk of code in my first email is just to demonstrate the issue
> and I am completely fine to get a better solution :) 

Your problem is perhaps made worse by threaded NAPI, you have
defer-free skbs sprayed across all cores and no NAPI there to 
flush them :(

> I guess we just need a way to free the pool in a reasonable amount 
> of time. Agree?

Whether we need to guarantee the release is the real question.
Maybe it's more of a false-positive warning.

Flushing the defer list is probably fine as a hack, but it's not
a full fix as Eric explained. False positive can still happen.

I'm ambivalent. My only real request wold be to make the flushing 
a helper in net/core/dev.c rather than open coded in page_pool.c.

Somewhat related - Eric, do we need to handle defer_list in dev_cpu_dead()?
