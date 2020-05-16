Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3640A1D64C2
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 01:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgEPXjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 19:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726729AbgEPXjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 19:39:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0042C061A0C;
        Sat, 16 May 2020 16:39:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E03E126390CD;
        Sat, 16 May 2020 16:39:30 -0700 (PDT)
Date:   Sat, 16 May 2020 16:39:27 -0700 (PDT)
Message-Id: <20200516.163927.1112911965183377217.davem@davemloft.net>
To:     shakeelb@google.com
Cc:     edumazet@google.com, willemb@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/packet: simply allocations in alloc_one_pg_vec_page
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CALvZod7euq10j6k9Z_dej4BvGXDjqbND05oM-u6tQrLjosX31A@mail.gmail.com>
References: <20200516021736.226222-1-shakeelb@google.com>
        <20200516.134018.1760282800329273820.davem@davemloft.net>
        <CALvZod7euq10j6k9Z_dej4BvGXDjqbND05oM-u6tQrLjosX31A@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 16:39:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Date: Sat, 16 May 2020 15:35:46 -0700

> So, my argument is if non-zero order vzalloc has failed (allocations
> internal to vzalloc, including virtual mapping allocation and page
> table allocations, are order 0 and use GFP_KERNEL i.e. triggering
> reclaim and oom-killer) then the next non-zero order page allocation
> has very low chance of succeeding.

Also not true.

Page table allocation strategies and limits vary by architecture, they
may even need virtual mappings themselves.  So they can fail in situations
where a non-zero GFP_KERNEL page allocator allocation would succeed.
