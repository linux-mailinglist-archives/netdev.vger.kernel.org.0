Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32D917ED76
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 01:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbgCJAzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 20:55:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbgCJAzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 20:55:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A69DB15A00CD2;
        Mon,  9 Mar 2020 17:55:34 -0700 (PDT)
Date:   Mon, 09 Mar 2020 17:55:34 -0700 (PDT)
Message-Id: <20200309.175534.1029399234531592179.davem@davemloft.net>
To:     jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, kernel-team@fb.com
Subject: Re: [PATCH] page_pool: use irqsave/irqrestore to protect ring
 access.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
References: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 17:55:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>
Date: Mon, 9 Mar 2020 12:49:29 -0700

> netpoll may be called from IRQ context, which may access the
> page pool ring.  The current _bh variants do not provide sufficient
> protection, so use irqsave/restore instead.
> 
> Error observed on a modified mlx4 driver, but the code path exists
> for any driver which calls page_pool_recycle from napi poll.
> 
> WARNING: CPU: 34 PID: 550248 at /ro/source/kernel/softirq.c:161 __local_bh_enable_ip+0x35/0x50
 ...
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

The netpoll stuff always makes the locking more complicated than it needs
to be.  I wonder if there is another way around this issue?

Because IRQ save/restore is a high cost to pay in this critical path.
