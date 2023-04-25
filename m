Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AC16EE4CF
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbjDYPeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbjDYPeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:34:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C806A5F5;
        Tue, 25 Apr 2023 08:34:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07C7B62EB3;
        Tue, 25 Apr 2023 15:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA429C433EF;
        Tue, 25 Apr 2023 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682436840;
        bh=OARleUAyajgwQosFGKsXcoGf5T0vXiZRIsLkdB7bnYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dJnw5W5IQCT/YQeMxKHb+5Rvzd919/iRVjelMnbeE/qG0QY/xds0rMbpW1YRyVzSM
         dZYw2mbT1FPz3GuXwPw1U/KBn+nm5DNKAJutlanzC+Y0dUVi/6ImLguEIzhVC/A8RL
         /8TCaSynE8HzSp/E1LBAEoNGpu2nkmw166V4xCMZ27CEkzp4zNIQOgpS+QnscjiAUQ
         1BEi5Du+AFr5sYV1Kj7xJjoPkvzauBK06g9GLgg5vk/rhYqQJWWRjTF8zvPdQBFNmD
         AOpxPGuH4Jdp1DkIe4y3dbulsrc9PCQRgyTka+FUFZRtTQ9On0CRP0ecPKRZCNNiBM
         xO10sUm1RwnEA==
Date:   Tue, 25 Apr 2023 18:33:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: Re: [PATCH v3 1/1] wifi: mac80211: fortify the spinlock against
 deadlock by interrupt
Message-ID: <20230425153353.GB27649@unreal>
References: <20230425093547.1131-1-mirsad.todorovac@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425093547.1131-1-mirsad.todorovac@alu.unizg.hr>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:35:48AM +0200, Mirsad Goran Todorovac wrote:
> In the function ieee80211_tx_dequeue() there is a particular locking
> sequence:
> 
> begin:
> 	spin_lock(&local->queue_stop_reason_lock);
> 	q_stopped = local->queue_stop_reasons[q];
> 	spin_unlock(&local->queue_stop_reason_lock);
> 
> However small the chance (increased by ftracetest), an asynchronous
> interrupt can occur in between of spin_lock() and spin_unlock(),
> and the interrupt routine will attempt to lock the same
> &local->queue_stop_reason_lock again.
> 
> This will cause a costly reset of the CPU and the wifi device or an
> altogether hang in the single CPU and single core scenario.
> 
> This is the probable trace of the deadlock:
> 
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  Possible unsafe locking scenario:
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        CPU0
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        ----
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   lock(&local->queue_stop_reason_lock);
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   <Interrupt>
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:     lock(&local->queue_stop_reason_lock);
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:
>                                                  *** DEADLOCK ***

Can you please add to the commit message whole lockdep trace?

And please trim "Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel: " line prefix,
it doesn't add any value.

Thanks
