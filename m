Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48460D79F
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 01:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiJYXC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 19:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiJYXCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 19:02:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD77FA039
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 16:02:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C945A61BF0
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 23:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5630C433C1;
        Tue, 25 Oct 2022 23:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666738944;
        bh=33Cbf6OZU2rRRnwLLnMglmb4dSRWwmktk2tIfwhwFRs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fD8qZ8ptVY2xFkslb4SoGOAQhWKVOorxEMxX9efkHhnBMvNM7mq2ArVHf39mppcsm
         Zxb9FfI0e/Fjyt1QGgdf0BHh+ozJOa79mY8n3uA7vjE8Iz2EIwOxqH/NfClFJ8KASO
         4ftNJrwXi3Z2ffeTanjQ7gRmiG388HHiOzwRT/bfWaAIEMmHZywGdY6M52C2pDNLR0
         iLsjzYHoGdAJl1hUK9sPvWSrjG+7hYnAX65j7DcJ6FpZkmabu5zssezx9gzaB5EYam
         PN7c+R5cJXPIbdQBUwEeTHMXQqhuBY9wuNIxLbOKpGLGUaPZkHj0n6ELqTjR9foFNQ
         5pSfmmsWuaOlQ==
Date:   Tue, 25 Oct 2022 16:02:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net] kcm: fix a race condition in kcm_recvmsg()
Message-ID: <20221025160222.5902e899@kernel.org>
In-Reply-To: <20221023023044.149357-1-xiyou.wangcong@gmail.com>
References: <20221023023044.149357-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Oct 2022 19:30:44 -0700 Cong Wang wrote:
> +			spin_lock_bh(&mux->rx_lock);
>  			KCM_STATS_INCR(kcm->stats.rx_msgs);
>  			skb_unlink(skb, &sk->sk_receive_queue);
> +			spin_unlock_bh(&mux->rx_lock);

Why not switch to __skb_unlink() at the same time?
Abundance of caution?

Adding Eric who was fixing KCM bugs recently.
