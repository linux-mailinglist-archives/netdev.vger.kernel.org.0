Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB962F3C9A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfKHAMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:12:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKHAMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:12:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA39015385162;
        Thu,  7 Nov 2019 16:12:49 -0800 (PST)
Date:   Thu, 07 Nov 2019 16:12:49 -0800 (PST)
Message-Id: <20191107.161249.384380300231076347.davem@davemloft.net>
To:     salil.mehta@huawei.com
Cc:     maz@kernel.org, edumazet@google.com, yisen.zhuang@huawei.com,
        lipeng321@huawei.com, mehta.salil@opnsrc.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH V2 net] net: hns: Fix the stray netpoll locks causing
 deadlock in NAPI path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107170953.7672-1-salil.mehta@huawei.com>
References: <20191107170953.7672-1-salil.mehta@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 16:12:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Salil Mehta <salil.mehta@huawei.com>
Date: Thu, 7 Nov 2019 17:09:53 +0000

> This patch fixes the problem of the spin locks, originally
> meant for the netpoll path of hns driver, causing deadlock in
> the normal NAPI poll path. The issue happened due to the presence
> of the stray leftover spin lock code related to the netpoll,
> whose support was earlier removed from the HNS[1], got activated
> due to enabling of NET_POLL_CONTROLLER switch.
> 
> Earlier background:
> The netpoll handling code originally had this bug(as identified
> by Marc Zyngier[2]) of wrong spin lock API being used which did
> not disable the interrupts and hence could cause locking issues.
> i.e. if the lock were first acquired in context to thread like
> 'ip' util and this lock if ever got later acquired again in
> context to the interrupt context like TX/RX (Interrupts could
> always pre-empt the lock holding task and acquire the lock again)
> and hence could cause deadlock.
> 
> Proposed Solution:
> 1. If the netpoll was enabled in the HNS driver, which is not
>    right now, we could have simply used spin_[un]lock_irqsave()
> 2. But as netpoll is disabled, therefore, it is best to get rid
>    of the existing locks and stray code for now. This should
>    solve the problem reported by Marc.
> 
> [1] https://git.kernel.org/torvalds/c/4bd2c03be7
> [2] https://patchwork.ozlabs.org/patch/1189139/
> 
> Fixes: 4bd2c03be707 ("net: hns: remove ndo_poll_controller")
> Reported-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Tested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>

Applied and queued up for -stable, thanks.
