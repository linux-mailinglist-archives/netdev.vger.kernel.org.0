Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D972676C7
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgILAZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgILAZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:25:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FEFC061573;
        Fri, 11 Sep 2020 17:25:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99B23120ED4A3;
        Fri, 11 Sep 2020 17:08:12 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:24:58 -0700 (PDT)
Message-Id: <20200911.172458.1064584936977530501.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com
Subject: Re: [PATCH net v1] hinic: fix rewaking txq after netif_tx_disable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910140440.20361-1-luobin9@huawei.com>
References: <20200910140440.20361-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:08:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Thu, 10 Sep 2020 22:04:40 +0800

> When calling hinic_close in hinic_set_channels, all queues are
> stopped after netif_tx_disable, but some queue may be rewaken in
> free_tx_poll by mistake while drv is handling tx irq. If one queue
> is rewaken core may call hinic_xmit_frame to send pkt after
> netif_tx_disable within a short time which may results in accessing
> memory that has been already freed in hinic_close. So we call
> napi_disable before netif_tx_disable in hinic_close to fix this bug.
> 
> Fixes: 2eed5a8b614b ("hinic: add set_channels ethtool_ops support")
> Signed-off-by: Luo bin <luobin9@huawei.com>
> ---
> V0~V1:
> - call napi_disable before netif_tx_disable instead of judging whether
>   the netdev is in down state before waking txq in free_tx_poll to fix
>   this bug

Applied and queued up for -stable, thank you.
