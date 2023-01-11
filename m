Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BF366505E
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 01:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbjAKAbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 19:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235617AbjAKAa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 19:30:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587175371B;
        Tue, 10 Jan 2023 16:30:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E82836192A;
        Wed, 11 Jan 2023 00:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003ABC433EF;
        Wed, 11 Jan 2023 00:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673397044;
        bh=rro122zyyIk0msdDvW9hB2HQ5TMSZChh4RsFZRPUYII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BHTs1FGPDZls/lttea9ggYa+d4sliQTJu+VUPo1ComZqiVDRvC8GLLTuljo0mNNcc
         9zPg9gBSUArZiDSNz7AWagIckfcHfvEhoGxCJbJaW6RAxtwGpMXCyoPJBS6JqeofDX
         36+LDybgBu7kq9svtAqM1tFQUcksGaJwYL2286QyGFoI88goNHkCtSiNR9ZacLCpAe
         +a+038y+R/rAOabIxzVCyRs16tQe4vMZ83RrhxQDSX6mf+8s64a1odVQlTuVLcYC7G
         l6SCukFShYiA/MHLWpnm8TPk7JfJIgT+/vQ8WYuimbjbc9EcptfCKciDdoEB4Z1i98
         LTVk9YdU/2qnQ==
Date:   Tue, 10 Jan 2023 16:30:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     =?UTF-8?B?5p2O5ZOy?= <sensor1010@163.com>,
        Wei Wang <weiwan@google.com>, davem@davemloft.net,
        pabeni@redhat.com, bigeasy@linutronix.de, imagedong@tencent.com,
        kuniyu@amazon.com, petrm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net/dev.c : Remove redundant state settings after
 waking up
Message-ID: <20230110163043.069c9aa4@kernel.org>
In-Reply-To: <CANn89iL0EYuGASWaXPwKN+E6mZvFicbDKOoZVA8N+BXFQV7e2A@mail.gmail.com>
References: <20230110091409.2962-1-sensor1010@163.com>
        <CANn89iL0EYuGASWaXPwKN+E6mZvFicbDKOoZVA8N+BXFQV7e2A@mail.gmail.com>
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

On Tue, 10 Jan 2023 10:29:20 +0100 Eric Dumazet wrote:
> > the task status has been set to TASK_RUNNING in shcedule(),
> > no need to set again here  
> 
> Changelog is rather confusing, this does not match the patch, which
> removes one set_current_state(TASK_INTERRUPTIBLE);
> 
> TASK_INTERRUPTIBLE != TASK_RUNNING
> 
> Patch itself looks okay (but has nothing to do with thread state after
> schedule()),
> you should have CC Wei Wang because she
> authored commit cb038357937e net: fix race between napi kthread mode
> and busy poll

AFAIU this is the semi-idiomatic way of handling wait loops.
It's not schedule() that may set the task state to TASK_RUNNING,
it's whoever wakes the process and makes the "wait condition" true.
In this case - test_bit(NAPI_STATE_SCHED, &napi->state)

I vote to not futz with this logic.
