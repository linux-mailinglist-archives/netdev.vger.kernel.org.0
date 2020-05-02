Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A822A1C2908
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 01:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgEBXp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 19:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgEBXp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 19:45:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B47C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 16:45:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DE401151671D6;
        Sat,  2 May 2020 16:45:27 -0700 (PDT)
Date:   Sat, 02 May 2020 16:45:27 -0700 (PDT)
Message-Id: <20200502.164527.1751947884056966917.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     jwi@linux.ibm.com, edumazet@google.com, netdev@vger.kernel.org,
        lrizzo@google.com
Subject: Re: [PATCH net-next 1/3] net: napi: add hard irqs deferral feature
From:   David Miller <davem@davemloft.net>
In-Reply-To: <78e8b060-6386-b6c1-d32f-907da2c930a7@gmail.com>
References: <CANn89iKid-JWYs6esRYo25NqVdLkLvn6uwiB7wLz_PXuREQQKA@mail.gmail.com>
        <08fd7715-62c3-23b9-ecac-4d0caff71d3e@linux.ibm.com>
        <78e8b060-6386-b6c1-d32f-907da2c930a7@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 May 2020 16:45:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 2 May 2020 09:24:19 -0700

> Doing the unmap stuff can be costly in IOMMU world, and freeing skb
> can be also expensive.  Add to this that TCP stack might be called
> back (via skb->destructor()) to add more packets to the
> qdisc/device.
> 
> So using effectively the budget as a limit might help in some stress
> situations, by not re-enabling NIC interrupts, even before
> napi_defer_hard_irqs addition.

Even with this logic, TX budgeting should be consuming some fraction of
the budget compared to RX processing.  Even if TX work isn't free, it's
much cheaper than RX.

