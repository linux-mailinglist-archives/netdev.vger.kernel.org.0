Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C5833F896
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhCQS7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232388AbhCQS6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 14:58:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3B9864DDF;
        Wed, 17 Mar 2021 18:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616007531;
        bh=2X7hZf7Mbj3I22kgp5FFUCDj9EdssAgFUaQuqjj5aaU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WoegWE2R/sejIAtKJvR1N7u7JJcx26LLNGMidIEUO6KfXl2luhCihSJLIGSC4dlME
         iXcfYsOsjoEY312/mG1zIpu9QXbe7qmAw/K18rxxzTqE7eIRNRy3vpDzlQlun6fHyW
         gMGMtd6Akq6rLlZT72OunzQscGXpSshgi/werx3kxlDD7yW4eJDaIztYDSvy4Gvwlg
         aav1BixfDRg8YCNeN+WVPhGm6XSPsA+3TXWlezJd0jTyeQUhStrBmr6XOnBkMR1PZe
         z9fnC5MFXDoRwW/ynTJKoDB412t2ni3JQ04lfY+Bnq+A3lYRhiUNpEv7jHuYO8o3YX
         U+TpTmxS9PdkA==
Date:   Wed, 17 Mar 2021 11:58:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH net v4] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210317115849.36d915ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316223647.4080796-1-weiwan@google.com>
References: <20210316223647.4080796-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 15:36:47 -0700 Wei Wang wrote:
> Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> determine if the kthread owns this napi and could call napi->poll() on
> it. However, if socket busy poll is enabled, it is possible that the
> busy poll thread grabs this SCHED bit (after the previous napi->poll()
> invokes napi_complete_done() and clears SCHED bit) and tries to poll
> on the same napi. napi_disable() could grab the SCHED bit as well.
> This patch tries to fix this race by adding a new bit
> NAPI_STATE_SCHED_THREADED in napi->state. This bit gets set in
> ____napi_schedule() if the threaded mode is enabled, and gets cleared
> in napi_complete_done(), and we only poll the napi in kthread if this
> bit is set. This helps distinguish the ownership of the napi between
> kthread and other scenarios and fixes the race issue.
> 
> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> Reported-by: Martin Zaharinov <micron10@gmail.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Cc: Alexander Duyck <alexanderduyck@fb.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
