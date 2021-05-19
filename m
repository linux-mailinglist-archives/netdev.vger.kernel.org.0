Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC273896A1
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhEST12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhEST11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 15:27:27 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36E1C06175F;
        Wed, 19 May 2021 12:26:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id ECB844D25C1D0;
        Wed, 19 May 2021 12:26:05 -0700 (PDT)
Date:   Wed, 19 May 2021 12:26:05 -0700 (PDT)
Message-Id: <20210519.122605.1971627339402718160.davem@davemloft.net>
To:     zheyuma97@gmail.com
Cc:     GR-Linux-NIC-Dev@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/qla3xxx: fix schedule while atomic in
 ql_sem_spinlock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1621406954-1130-1-git-send-email-zheyuma97@gmail.com>
References: <1621406954-1130-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 19 May 2021 12:26:06 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>
Date: Wed, 19 May 2021 06:49:14 +0000

> When calling the 'ql_sem_spinlock', the driver has already acquired the
> spin lock, so the driver should not call 'ssleep' in atomic context.
> 
> This bug can be fixed by unlocking before calling 'ssleep'.
 ...
> diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
> index 214e347097a7..af7c142a066f 100644
> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
> @@ -114,7 +114,9 @@ static int ql_sem_spinlock(struct ql3_adapter *qdev,
>  		value = readl(&port_regs->CommonRegs.semaphoreReg);
>  		if ((value & (sem_mask >> 16)) == sem_bits)
>  			return 0;
> +		spin_unlock_irq(&qdev->hw_lock);
>  		ssleep(1);
> +		spin_lock_irq(&qdev->hw_lock);
>  	} while (--seconds);
>  	return -1;
>  }

Are you sure dropping the lock like this dos not introduce a race condition?

Thank you.
