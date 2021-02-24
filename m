Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA71A3244C2
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 20:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhBXTth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 14:49:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232276AbhBXTtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 14:49:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5F9464E6C;
        Wed, 24 Feb 2021 19:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614196135;
        bh=+rxsna9mjC2rFWG3uNT1RSmlO2bBP7P0Dc6I90o9+ao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hUJ6C7fWuJWKrZg1loz1mplz8kRKSO1RVHUwEP8gkNGwkmtrkjUPex3NlLRjlWMSl
         z/QeuKEJkfH3DliazQPWVktW4/DAQ6injHmOkQIQTimfah09EahJFaZ6CLb10hj6/Z
         ePeZf+XZtXM5YCm21rh7+P9cEAjKgp6U88GckvAEhsbewkaLdXacpO0mr6Di2Kzs7I
         oA4pp7ytujNCMZrecAy+pi3ajXVJEyMuSZc37tnFbKc7FjEdsfyaA+KIxW7eFTh7mw
         ww77wqts3XtAbkNvIoGiN4XXiEyzCQHdbaGj/w9dqtqRowTT5Z7FnZyJ6Zd/q/mYPO
         vIPMv5T6bBahw==
Date:   Wed, 24 Feb 2021 11:48:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223234130.437831-1-weiwan@google.com>
References: <20210223234130.437831-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 15:41:30 -0800 Wei Wang wrote:
> Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> determine if the kthread owns this napi and could call napi->poll() on
> it. However, if socket busy poll is enabled, it is possible that the
> busy poll thread grabs this SCHED bit (after the previous napi->poll()
> invokes napi_complete_done() and clears SCHED bit) and tries to poll
> on the same napi.
> This patch tries to fix this race by adding a new bit
> NAPI_STATE_SCHED_BUSY_POLL in napi->state. This bit gets set in
> napi_busy_loop() togther with NAPI_STATE_SCHED, and gets cleared in
> napi_complete_done() together with NAPI_STATE_SCHED. This helps
> distinguish the ownership of the napi between kthread and the busy poll
> thread, and prevents the kthread from polling on the napi when this napi
> is still owned by the busy poll thread.
> 
> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> Reported-by: Martin Zaharinov <micron10@gmail.com>
> Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Reviewed-by: Eric Dumazet <edumazet@google.come>

AFAIU sched bit controls the ownership of the poll_list. Can we please
add a poll_list for the thread and make sure the thread polls based on
the list?
IMO that's far clearer than defining a forest of ownership state bits.

I think with just the right (wrong?) timing this patch will still not
protect against disabling the NAPI.
