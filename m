Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE70FB968
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKMUI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:08:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfKMUI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:08:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 019AB11F5F7B9;
        Wed, 13 Nov 2019 12:08:28 -0800 (PST)
Date:   Wed, 13 Nov 2019 12:08:28 -0800 (PST)
Message-Id: <20191113.120828.4034322769281345.davem@davemloft.net>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, socketcan@hartkopp.net,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH] slip: Fix memory leak in slip_open error path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113114502.22462-1-jouni.hogander@unikie.com>
References: <20191113114502.22462-1-jouni.hogander@unikie.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 12:08:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jouni.hogander@unikie.com
Date: Wed, 13 Nov 2019 13:45:02 +0200

> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Driver/net/can/slcan.c is derived from slip.c. Memory leak was detected
> by Syzkaller in slcan. Same issue exists in slip.c and this patch is
> addressing the leak in slip.c.
> 
> Here is the slcan memory leak trace reported by Syzkaller:
...
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>

Applied and queued up for -stable.

Looking at slip_open() while reviewing this patch, it has this test:

	if (!test_bit(SLF_INUSE, &sl->flags)) {
		/* Perform the low-level SLIP initialization. */
		err = sl_alloc_bufs(sl, SL_MTU);
		if (err)
			goto err_free_chan;

which seems bogus, because 'sl' here is always a freshly allocated object
from sl_alloc(), which always provides an all-zeros value on sl->flags
so this test always passes.

It can therefore be removed.
