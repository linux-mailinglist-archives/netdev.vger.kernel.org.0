Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDEA6AA75B
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 02:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCDBj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 20:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDBjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 20:39:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1386922DFC;
        Fri,  3 Mar 2023 17:39:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1BFFB818AB;
        Sat,  4 Mar 2023 01:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9D6C433D2;
        Sat,  4 Mar 2023 01:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677893962;
        bh=mEKoMzqdlRLtkZYk1sy2rZAGbDfV0c8nyMlcP49YaHw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qRL3X4so7Vo70vv56AaExkg7vuz9vM5VK+7M8Yx/PbGHFXpGtG/+k7Q9lqgyMmmOO
         liCAuayw5efpePoh+va6N1DFY5tbsLvJeFKfi8XWcy+k3BlVoXKNBAxd9yEv8crVH+
         K9k3WenPj8VWMa487uaC/H1rZE/yDurtMx64F/I+B4npiKmgNibgUfGi4uvxoAE0du
         T4QQlWu4K0xzbObVWQB2xWdU+KZNBlpD+pNq1JLTfpJTBilWoOsC0u8lnkn2WOSq7h
         Y3LhBcZ8eX0sApcIqXDVsG1BRiuvtEC0Oj60oUNLMoHpvtlBoI8g/rbhRriAYSSqOJ
         4PC0xb5B3Uk8Q==
Date:   Fri, 3 Mar 2023 17:39:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to
 need_resched()
Message-ID: <20230303173921.29d9faef@kernel.org>
In-Reply-To: <20230304012535.GF1301832@paulmck-ThinkPad-P17-Gen-1>
References: <20221222221244.1290833-1-kuba@kernel.org>
        <20221222221244.1290833-3-kuba@kernel.org>
        <87r0u6j721.ffs@tglx>
        <20230303133143.7b35433f@kernel.org>
        <20230303223739.GC1301832@paulmck-ThinkPad-P17-Gen-1>
        <20230303233627.GA2136520@paulmck-ThinkPad-P17-Gen-1>
        <20230303154413.1d846ac3@kernel.org>
        <20230304012535.GF1301832@paulmck-ThinkPad-P17-Gen-1>
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

On Fri, 3 Mar 2023 17:25:35 -0800 Paul E. McKenney wrote:
> > Just to be sure - have you seen Peter's patches?
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core/softirq
> > 
> > I think it feeds the time limit to the callback from softirq,
> > so the local 3ms is no more?  
> 
> I might or might not have back in September of 2020.  ;-)
> 
> But either way, the question remains:  Should RCU_SOFTIRQ do time checking
> in ksoftirqd context?  Seems like the answer should be "yes", independently
> of Peter's patches.

:-o  I didn't notice, I thought that's from Dec 22, LWN was writing
about Peter's rework at that point. I'm not sure what the story is :(
And when / if any of these changes are coming downstream.
