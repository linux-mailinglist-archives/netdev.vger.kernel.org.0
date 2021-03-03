Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E5232B3DD
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840238AbhCCEHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhCCATe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 19:19:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFDB64E58;
        Wed,  3 Mar 2021 00:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614730708;
        bh=xH7SlLzQFALuFyk9S6UXanSxxZdD1tWHJq2H84sW7+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oi7COk6/ycIXSZ6Kq/Qzb3GU4faxQDBEIgBswMbaP0huzRBm2RMcmv8tGYeAgZJ2C
         KfXAJsoCS3G311wJGDX69K7mNDV8u81+HzAPXerUCcyBMb1atxFG4mwZD3tjnQD5zt
         3FWxqQQisxQDJO9o+A3Ue3LaytQKJaHz3rNonAF9Y96hXoHaSF8caA9Sud/64nN4Ih
         McOfwkupFO7NBOTkhNhAh+wEEGPoqkb0/3cpWYHy/qSg3ubnUtPGofzObgTyHvit9G
         CRO5a4ul20EzJVoaB2GqdS/V7soi/59qvB08i1RBpGvlspFN5g/OnLik8fZbxrfkit
         1HuDR4unI0c1A==
Date:   Tue, 2 Mar 2021 16:18:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH net v3] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210302161827.476f2a5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210302012113.1432412-1-weiwan@google.com>
References: <20210302012113.1432412-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Mar 2021 17:21:13 -0800 Wei Wang wrote:
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

Thanks!
