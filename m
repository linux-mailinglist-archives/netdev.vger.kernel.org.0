Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE8710F594
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 04:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLCD2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 22:28:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfLCD2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 22:28:41 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44D5014F35C41;
        Mon,  2 Dec 2019 19:28:41 -0800 (PST)
Date:   Mon, 02 Dec 2019 19:28:40 -0800 (PST)
Message-Id: <20191202.192840.1366675580449158510.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com,
        linyunsheng@huawei.com
Subject: Re: [PATCH net 2/3] net: hns3: fix a use after free problem in
 hns3_nic_maybe_stop_tx()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1575342535-2981-3-git-send-email-tanhuazhong@huawei.com>
References: <1575342535-2981-1-git-send-email-tanhuazhong@huawei.com>
        <1575342535-2981-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Dec 2019 19:28:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Tue, 3 Dec 2019 11:08:54 +0800

> From: Yunsheng Lin <linyunsheng@huawei.com>
> 
> Currently, hns3_nic_maybe_stop_tx() uses skb_copy() to linearize a
> SKB if the BD num required by the SKB does not meet the hardware
> limitation, and it linearizes the SKB by allocating a new SKB and
> freeing the old SKB, if hns3_nic_maybe_stop_tx() returns -EBUSY,
> the sch_direct_xmit() still hold reference to old SKB and try to
> retransmit the old SKB when dev_hard_start_xmit() return TX_BUSY,
> which may cause use after freed problem.
> 
> This patch fixes it by using __skb_linearize() to linearize the
> SKB in hns3_nic_maybe_stop_tx().
> 
> Fixes: 51e8439f3496 ("net: hns3: add 8 BD limit for tx flow")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

That's not what I see.

You're freeing the SKB in the caller of hns3_nic_maybe_stop_tx()
in the -ENOMEM case, not the generic qdisc code.

Standing practice is to always return NETIF_TX_OK in this case
and just pretend the frame was sent.

Grep for __skb_linearize use throughout various drivers to see
what I mean.  i40e is just one of several examples.

