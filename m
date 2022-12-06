Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C30643B85
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiLFCs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbiLFCsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:48:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D147222530;
        Mon,  5 Dec 2022 18:47:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F10DDB81609;
        Tue,  6 Dec 2022 02:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09152C433D6;
        Tue,  6 Dec 2022 02:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670294863;
        bh=U3jMWo8UOIlXRtrpHAUyzh+FgiPs3PjKBCtkUu1R5B4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lmEyK/yLEa/mUttm4uKQUHisF8in+OHCKto8WjfW1KDBAoIoYNPiNhrfE1Eqrnqe2
         2DZGKjbGK5UFrBU418bqlW9dtM8lDwHmgYFYI+E/KMW9iq7FyHIIRWEOPuCZxMjO3N
         /Jq24dMTln+BwtgJ/LTramROt0i/64lAJRNlwL+tEPPVSFB76ZtdvDF18/zXnJJXlA
         hHksAcNqQqM9O3nlGMy6loO7nrVxzSY2gl3iE9R6NuiJqbg70H4u/lP7Wt1UoJZ2vF
         RSDwgq001wApQlG7QVQZ5Y809YzDFk5fi5fat79lfVx87yuOJTPmRI6Pf0g4V5lPng
         fzJoGfxyp8laQ==
Date:   Mon, 5 Dec 2022 18:47:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tedheadster@gmail.com>
Subject: Re: [PATCH linux-next] net: record times of netdev_budget exhausted
Message-ID: <20221205184742.0952fc75@kernel.org>
In-Reply-To: <202212061035074041030@zte.com.cn>
References: <20221205175314.0487527a@kernel.org>
        <202212061035074041030@zte.com.cn>
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

On Tue, 6 Dec 2022 10:35:07 +0800 (CST) yang.yang29@zte.com.cn wrote:
> The author of "Replace 2 jiffies with sysctl netdev_budget_usecs
> to enable softirq tuning" is Matthew Whitehead, he said this in
> git log: Constants used for tuning are generally a bad idea, especially
> as hardware changes over time...For example, a very fast machine
> might tune this to 1000 microseconds, while my regression testing
> 486DX-25 needs it to be 4000 microseconds on a nearly idle network
> to prevent time_squeeze from being incremented.

Let's just ignore that on the basis that it mentions prehistoric HW ;)

> And on my systems there are huge packets on the intranet, and we
> came accross with lots of time_squeeze. The idea is that, netdev_budget*
> are selections between throughput and real-time. If we care throughput
> and not care real-time so much, we may want bigger netdev_budget*.

But are you seeing actual performance wins in terms of throughput 
or latency? 

As I said time_squeeze is very noisy. In my experience it's very
sensitive to issues with jiffies, like someone masking interrupts on
the timekeeper CPU for a long time (which if you use cgroups happens
_a lot_ :/).

Have you tried threaded NAPI? (find files called 'threaded' in sysfs)
It will let you do any such tuning much more flexibly.

> In this scenario, we want to tune netdev_budget* and see their effect
> separately.
>
> By the way, if netdev_budget* are useless, should they be deleted?

Well, we can't be sure if there's really nobody that uses them :(
It's very risky to remove stuff that's exposed to user space.
