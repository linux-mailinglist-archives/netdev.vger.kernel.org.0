Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A64271832
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgITV2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITV2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:28:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E71C061755;
        Sun, 20 Sep 2020 14:28:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 80F6C13BD0527;
        Sun, 20 Sep 2020 14:11:43 -0700 (PDT)
Date:   Sun, 20 Sep 2020 14:28:28 -0700 (PDT)
Message-Id: <20200920.142828.1649305713979064139.davem@davemloft.net>
To:     liujian56@huawei.com
Cc:     sergei.shtylyov@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-netx] net: renesas: sh_eth: suppress initialized
 field overwritten warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919105945.251532-1-liujian56@huawei.com>
References: <20200919105945.251532-1-liujian56@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 20 Sep 2020 14:11:43 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>
Date: Sat, 19 Sep 2020 18:59:45 +0800

> Suppress a bunch of warnings of the form:
> 
> drivers/net/ethernet/renesas/sh_eth.c:100:13: warning: initialized field overwritten [-Woverride-init]
> 
> This is because after the sh_eth_offset_xxx array is initialized to SH_ETH_OFFSET_INVALID,
> some specific register_offsets are re-initialized. It wasn't a mistake.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Even if I agreed with this approach to the fix, you can't just blindly
add a CFLAG option.  What if the compile doesn't understand or support
that option?

I leave it to the patch submitter to grep the Makefiles in the tree to
learn how to handle this situation properly, because that's how I
learned what the right thing to do since I wasn't sure.

But in the end I think just sticking a warning disable here and there
isn't the solution.  I think this driver should explicitly initialize
the array entries that are invalid on each and every chip.

No only does that get rid of the warnings cleanly, but it also more
clearly documents the available register set.  Currently you have to
walk each and every enumeration value in the sh_eth.h header and
see if the table has it or not, in order to figure out which registers
are _not_ present for a chip.

Thank you.
