Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEF412874D
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfLUFPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:15:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56838 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfLUFPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:15:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 195D2153CA713;
        Fri, 20 Dec 2019 21:15:44 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:15:43 -0800 (PST)
Message-Id: <20191220.211543.940622133336540668.davem@davemloft.net>
To:     xiaojiangfeng@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        zhangfei.gao@linaro.org, arnd@arndb.de, dingtianhong@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jakub.kicinski@netronome.com, leeyou.li@huawei.com,
        nixiaoming@huawei.com
Subject: Re: [PATCH v4] net: hisilicon: Fix a BUG trigered by wrong
 bytes_compl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576721287-68102-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1576721287-68102-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:15:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Date: Thu, 19 Dec 2019 10:08:07 +0800

> When doing stress test, we get the following trace:
 ...
> Pre-modification code:
> int hip04_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
> {
> [...]
> [1]	priv->tx_head = TX_NEXT(tx_head);
> [2]	count++;
> [3]	netdev_sent_queue(ndev, skb->len);
> [...]
> }
> An rx interrupt occurs if hip04_mac_start_xmit just executes to the line 2,
> tx_head has been updated, but corresponding 'skb->len' has not been
> added to dql_queue.
> 
> And then
> hip04_mac_interrupt->__napi_schedule->hip04_rx_poll->hip04_tx_reclaim
> 
> In hip04_tx_reclaim, because tx_head has been updated,
> bytes_compl will plus an additional "skb-> len"
> which has not been added to dql_queue. And then
> trigger the BUG_ON(bytes_compl > num_queued - dql->num_completed).
> 
> To solve the problem described above, we put
> "netdev_sent_queue(ndev, skb->len);"
> before
> "priv->tx_head = TX_NEXT(tx_head);"
> 
> Fixes: a41ea46a9a12 ("net: hisilicon: new hip04 ethernet driver")
> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

Applied, thanks.
