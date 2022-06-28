Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE6E55EABF
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiF1RPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiF1RPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:15:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC742CE22;
        Tue, 28 Jun 2022 10:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 962B861937;
        Tue, 28 Jun 2022 17:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B72FC3411D;
        Tue, 28 Jun 2022 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656436534;
        bh=UBVsW+yzxyFb/s3b5sRvKn2VSjVfkBM2AyEJPMVc8lo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jtn6qXrzGfs6D+k2i4yl2UP7DzBvENpEo9EjvzK+oRPwSzmDr0+t2nd5udz2o3BvX
         TGsN68oe9rG7XqUXpemiQKvPcflszZit6/04QYDvyPhA69X45MSFrMsJUccxh3mXiX
         uFTFQTrgi8rRmPAf2Fs5J0LNiut+VYhc37dqeo1hkldj25rbmgvWwIWu+VM/rdg1uw
         VzvcLeKj+4Vrd/e2HnSmMz1g59J6MYQPgXQkyHRGw8XDl3IpVRaxrZaQ6I9Ax7iGa+
         5yYLu6ZG5mRitcZ/FmnnO+eSvvxEZVzuKs098M4xaAp6kV8P13z35Ll/LBe0qmS8rJ
         7BCDunm4kr1fA==
Date:   Tue, 28 Jun 2022 10:15:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Albert Huang <huangjie.albert@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <atenart@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net : rps : supoort a single flow to use rps
Message-ID: <20220628101532.1be4a9df@kernel.org>
In-Reply-To: <CANn89iKfW8_OLN3veCaMDDLLPU1EP_eAcf03PJZJnLD+6Pv3vw@mail.gmail.com>
References: <20220628140044.65068-1-huangjie.albert@bytedance.com>
        <CANn89iKfW8_OLN3veCaMDDLLPU1EP_eAcf03PJZJnLD+6Pv3vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 17:31:12 +0200 Eric Dumazet wrote:
> > how to use:
> > echo xxx > /sys/class/net/xxx/queues/rx-x/rps_cpus
> > echo 1 > /sys/class/net/xxx/queues/rx-x/rps_single_flow
> > and create a flow node with the function:
> > rps_flow_node_create  
> 
> Which part calls rps_flow_node_create() exactly ?
> 
> This seems to be very specialized to IPSEC.
> 
> Can IPSEC  use multiple threads for decryption ?

+1 Doesn't wireguard do something to spread the load across CPUs?
Maybe it can be generalized? I don't think a solution to "spray 
crypto around" belongs as part of RPS.
