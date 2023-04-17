Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAF26E5016
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjDQSXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDQSXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:23:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573523C1F;
        Mon, 17 Apr 2023 11:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCC86628C9;
        Mon, 17 Apr 2023 18:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D59C433D2;
        Mon, 17 Apr 2023 18:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681755828;
        bh=1lrwAwTZh6fAL5iIhPDThSaH0guw7VxGpJd4kSL5gCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IpVEfswLasLR4afDYgcySKN8UeEaUVZNJ3wnrvv8RR98CgYG7L8Fp5J5V4efGlp69
         U6V1Mjy+2enegM9Tgt/14kWVFjqZoY7TKav15Tom2V/4CMUWDrmeA35pSdPdNFW4Ih
         xH9wIK5/vqOURi6d6Mj6x1VT0fuWW/KITuakuOIPyRe6BLBxRGcVsCPwPHV5F+XrBP
         ckQFk9hpBjgEzSx6rKOvmmH5kY2Sh17XCHoyAUpdrMxAQfYHNPIatrsKtWYwssr42I
         TDIdYpGP632b6ZVSBqi3VoSBjWEFp11aoHu7X1akzZJBenNMgABoylj3MsUvnaBnaS
         uwEb9XUI/fszA==
Date:   Mon, 17 Apr 2023 11:23:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
Subject: Re: issue with inflight pages from page_pool
Message-ID: <20230417112346.546dbe57@kernel.org>
In-Reply-To: <ZD2NSSYFzNeN68NO@lore-desk>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
        <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
        <ZD2NSSYFzNeN68NO@lore-desk>
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

On Mon, 17 Apr 2023 20:17:45 +0200 Lorenzo Bianconi wrote:
> > I do not see why this would be different than having buffers sitting
> > in some tcp receive
> > (or out or order) queues for a few minutes ?  
> 
> The main issue in my tests (and even in mt76 I think) is the pages are not returned
> to the pool for a very long time (even hours) and doing so the pool is like in a
> 'limbo' state where it is not actually deallocated and page_pool_release_retry
> continues complaining about it. I think this is because we do not have more tcp
> traffic to deallocate them, but I am not so familiar with tcp codebase :)

I've seen the page leaks too in my recent testing but I just assumed 
I fumbled the quick bnxt conversion to page pool. Could it be something
with page frags? It happened a lot if I used page frags, IIRC mt76 is
using page frags, too.

Is drgn available for your target? You could try to scan the pages on
the system and see if you can find what's still pointing to the page
pool (assuming they are indeed leaked and not returned to the page
allocator without releasing :()
