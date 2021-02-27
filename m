Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A536326AD0
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhB0Asq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:48:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhB0Asp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 19:48:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B775364EDB;
        Sat, 27 Feb 2021 00:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614386885;
        bh=6EdsVAtTLQgeWe8LLHSnInFY5ZbXW3fkD5/Sjr2O+2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=incWVsYUUT4pIHf1Ny21tL1tZ2iCKp6QBPFRWl+IArePk0wPb4Ostk+cQeO0fKjuh
         ewiNwSmGn0agDthZNdoAYsDXhiPCtuvo0Nw4tgQ62msEnSOHjhTqc6p5ajapsinNjT
         g0LyG5UBnlKeNdYnAyO1yA4MoO2pGLol9O6xiGz0Vx/3+O7/j26YUnLd8zV7zhpRaP
         cFR1O8f2Kfrb1ZKRwKNS9gkrmb8CU+0nuE+4WdYW0w/8OOLUNHkmoAGNGGge9vSFWF
         EytncAfCyuugDZLhe2aIXjWdEyEqp7mkCt+36+pTDkwo9t0blsirYw3vl/DNJb+AE3
         Xj++UDNutNGKQ==
Date:   Fri, 26 Feb 2021 16:48:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH net v2] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210226164803.4413571f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210227003047.1051347-1-weiwan@google.com>
References: <20210227003047.1051347-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 16:30:47 -0800 Wei Wang wrote:
>  		thread = READ_ONCE(napi->thread);
>  		if (thread) {
> +			set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
>  			wake_up_process(thread);

What about the version which checks RUNNING? As long as
wake_up_process() implies a barrier I _think_ it should 
work as well. Am I missing some case, or did you decide
to go with the simpler/safer approach?
