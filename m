Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA57EDDAAE
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfJSTWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 15:22:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42770 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfJSTWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 15:22:36 -0400
Received: from localhost (unknown [64.79.112.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C094E1493C1FF;
        Sat, 19 Oct 2019 12:22:35 -0700 (PDT)
Date:   Sat, 19 Oct 2019 12:22:35 -0700 (PDT)
Message-Id: <20191019.122235.256708841075577482.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        oliver.sang@intel.com
Subject: Re: [PATCH net] net: reorder 'struct net' fields to avoid false
 sharing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191018222005.45260-1-edumazet@google.com>
References: <20191018222005.45260-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 19 Oct 2019 12:22:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 18 Oct 2019 15:20:05 -0700

> Intel test robot reported a ~7% regression on TCP_CRR tests
> that they bisected to the cited commit.
> 
> Indeed, every time a new TCP socket is created or deleted,
> the atomic counter net->count is touched (via get_net(net)
> and put_net(net) calls)
> 
> So cpus might have to reload a contended cache line in
> net_hash_mix(net) calls.
> 
> We need to reorder 'struct net' fields to move @hash_mix
> in a read mostly cache line.
> 
> We move in the first cache line fields that can be
> dirtied often.
> 
> We probably will have to address in a followup patch
> the __randomize_layout that was added in linux-4.13,
> since this might break our placement choices.
> 
> Fixes: 355b98553789 ("netns: provide pure entropy for net_hash_mix()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>

Applied and queued up for -stable, thanks Eric.
