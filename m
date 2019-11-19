Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C867010304C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfKSXgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:36:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46620 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfKSXgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:36:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A58B0142C0124;
        Tue, 19 Nov 2019 15:36:03 -0800 (PST)
Date:   Tue, 19 Nov 2019 15:36:03 -0800 (PST)
Message-Id: <20191119.153603.2158592594523337284.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net] net: hns3: fix a wrong reset interrupt status mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574130708-30767-1-git-send-email-tanhuazhong@huawei.com>
References: <1574130708-30767-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 15:36:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Tue, 19 Nov 2019 10:31:48 +0800

> According to hardware user manual, bits5~7 in register
> HCLGE_MISC_VECTOR_INT_STS means reset interrupts status,
> but HCLGE_RESET_INT_M is defined as bits0~2 now. So it
> will make hclge_reset_err_handle() read the wrong reset
> interrupt status.
> 
> This patch fixes it and prints out the register value.
> 
> Fixes: 2336f19d7892 ("net: hns3: check reset interrupt status when reset fails")
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Fix exactly _one_ thing or else you make your patch hard to review.

The bug is that the bits are wrong, just fix the bits!

>  
> +	u32 msix_sts_reg;
> +
> +	msix_sts_reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS);
> +
>  	if (hdev->reset_pending) {

Now you are reading a register, and potentially clearing status bits and
causing other side effects, that would not happen in this code path
where hdev->reset_pending is true.

Don't do stuff like this!

If you want to add code to print out the register value, that is a
separate patch, for net-next, and it must be done properly.  In that
you should only read the register in the same code paths you do
previously.   Otherwise you must _clearly_ explain why reading the
register value in new code paths is OK, and the side effects will
not potentially cause problems for the pending reset operation.  It
is still going to be a net-next improvement only.

Thank you.
