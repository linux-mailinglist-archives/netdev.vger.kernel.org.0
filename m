Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE7B611E22
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 01:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJ1X2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 19:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJ1X2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 19:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA914249D06
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 16:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86CCB62AF4
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 23:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBD8C433D6;
        Fri, 28 Oct 2022 23:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666999677;
        bh=vvh83tMNRom59HAWomp0u0n0mKzcJCERwZ/87wYWEgQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sQMqCy0dEVq6LXFelrYMQVFcb1uP/s0+vlOu/fDsX0PoNtQtcuAYc06RDyuB7q1vD
         wfg1s37gxfJAaARXhwdVdAEvcfAnNREaKgm7rtXh+b8+Njm94BdqV4IpyjsnBsygiH
         Du+LjAWfOc0MQ/qNq4aBgql5jldw8BTAr3F2bOg4rg8D7EpiFnsApBjyzyJx/Pezx2
         FwIAq23owiOgRHgqqtwXFQ2EslsntSaNRX4sSbmAaC+nwgFmSkW9OddO4jnc/6ke5c
         KLH74Fp/eueMBuLYLW/xmpX8dS2ivCyx2gZSo1nzCyuyu+PnZvaYMr+Alhux9ljhLK
         +8r7LR7aNKWhw==
Date:   Fri, 28 Oct 2022 16:27:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net] kcm: fix a race condition in kcm_recvmsg()
Message-ID: <20221028162756.6c1f64f0@kernel.org>
In-Reply-To: <Y1wrp4pL4BmUL0LE@pop-os.localdomain>
References: <20221023023044.149357-1-xiyou.wangcong@gmail.com>
        <20221025160222.5902e899@kernel.org>
        <Y1wrp4pL4BmUL0LE@pop-os.localdomain>
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

On Fri, 28 Oct 2022 12:21:11 -0700 Cong Wang wrote:
> On Tue, Oct 25, 2022 at 04:02:22PM -0700, Jakub Kicinski wrote:
> > On Sat, 22 Oct 2022 19:30:44 -0700 Cong Wang wrote:  
> > > +			spin_lock_bh(&mux->rx_lock);
> > >  			KCM_STATS_INCR(kcm->stats.rx_msgs);
> > >  			skb_unlink(skb, &sk->sk_receive_queue);
> > > +			spin_unlock_bh(&mux->rx_lock);  
> > 
> > Why not switch to __skb_unlink() at the same time?
> > Abundance of caution?  
> 
> What gain do we have? Since we have rx_lock, skb queue lock should never
> be contended?

I was thinking mostly about readability, the performance is secondary.
Other parts of the code use unlocked skb queue helpers so it may be
confusing to a reader why this on isn't, and therefore what lock
protects the queue. But no strong feelings.
