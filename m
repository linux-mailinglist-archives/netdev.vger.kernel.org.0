Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7312A62CAA
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfGHXch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:32:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfGHXch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 19:32:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F1F112E4E44D;
        Mon,  8 Jul 2019 16:32:36 -0700 (PDT)
Date:   Mon, 08 Jul 2019 16:32:35 -0700 (PDT)
Message-Id: <20190708.163235.455094269982602106.davem@davemloft.net>
To:     wen.yang99@zte.com.cn
Cc:     linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, cheng.shengyu@zte.com.cn, anirudh@xilinx.com,
        John.Linn@xilinx.com, michal.simek@xilinx.com,
        hancock@sedsystems.ca, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: axienet: fix a potential double free in
 axienet_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562384321-46727-1-git-send-email-wen.yang99@zte.com.cn>
References: <1562384321-46727-1-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 16:32:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>
Date: Sat, 6 Jul 2019 11:38:41 +0800

> There is a possible use-after-free issue in the axienet_probe():
> 
> 1701:	np = of_parse_phandle(pdev->dev.of_node, "axistream-connected", 0);
> 1702:   if (np) {
> ...
> 1787:		of_node_put(np); ---> released here
> 1788:		lp->eth_irq = platform_get_irq(pdev, 0);
> 1789:	} else {
> ...
> 1801:	}
> 1802:	if (IS_ERR(lp->dma_regs)) {
> ...
> 1805:		of_node_put(np); ---> double released here
> 1806:		goto free_netdev;
> 1807:	}
> 
> We solve this problem by removing the unnecessary of_node_put().
> 
> Fixes: 28ef9ebdb64c ("net: axienet: make use of axistream-connected attribute optional")
> Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>

Applied to net-next
