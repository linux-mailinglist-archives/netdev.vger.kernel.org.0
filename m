Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C882D3777
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbgLIARd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730236AbgLIARd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:17:33 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3821FC0613D6;
        Tue,  8 Dec 2020 16:16:52 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6486E4D249B43;
        Tue,  8 Dec 2020 16:16:51 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:16:50 -0800 (PST)
Message-Id: <20201208.161650.1190066192708878176.davem@davemloft.net>
To:     zhangchangzhong@huawei.com
Cc:     kuba@kernel.org, michal.simek@xilinx.com, esben@geanix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ll_temac: Fix potential NULL dereference in
 temac_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1607392422-20372-1-git-send-email-zhangchangzhong@huawei.com>
References: <1607392422-20372-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:16:51 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>
Date: Tue, 8 Dec 2020 09:53:42 +0800

> platform_get_resource() may fail and in this case a NULL dereference
> will occur.
> 
> Fix it to use devm_platform_ioremap_resource() instead of calling
> platform_get_resource() and devm_ioremap().
> 
> This is detected by Coccinelle semantic patch.
> 
> @@
> expression pdev, res, n, t, e, e1, e2;
> @@
> 
> res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t, n);
> + if (!res)
> +   return -EINVAL;
> ... when != res == NULL
> e = devm_ioremap(e1, res->start, e2);
> 
> Fixes: 8425c41d1ef7 ("net: ll_temac: Extend support to non-device-tree platforms")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied, thanks.
