Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27ACDC2B38
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 02:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbfJAAOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 20:14:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfJAAOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 20:14:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 18AAF154F6365;
        Mon, 30 Sep 2019 17:14:33 -0700 (PDT)
Date:   Mon, 30 Sep 2019 17:14:32 -0700 (PDT)
Message-Id: <20190930.171432.924026195206299750.davem@davemloft.net>
To:     kafai@fb.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net] net: Unpublish sk from sk_reuseport_cb before
 call_rcu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190927230031.3859970-1-kafai@fb.com>
References: <20190927230031.3859970-1-kafai@fb.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Sep 2019 17:14:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>
Date: Fri, 27 Sep 2019 16:00:31 -0700

> The "reuse->sock[]" array is shared by multiple sockets.  The going away
> sk must unpublish itself from "reuse->sock[]" before making call_rcu()
> call.  However, this unpublish-action is currently done after a grace
> period and it may cause use-after-free.
> 
> The fix is to move reuseport_detach_sock() to sk_destruct().
> Due to the above reason, any socket with sk_reuseport_cb has
> to go through the rcu grace period before freeing it.
> 
> It is a rather old bug (~3 yrs).  The Fixes tag is not necessary
> the right commit but it is the one that introduced the SOCK_RCU_FREE
> logic and this fix is depending on it.
> 
> Fixes: a4298e4522d6 ("net: add SOCK_RCU_FREE socket flag")
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied and queued up for -stable, thanks Martin.
