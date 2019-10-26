Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB022E5E9F
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfJZSWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:22:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfJZSWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:22:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA13614DE9796;
        Sat, 26 Oct 2019 11:22:35 -0700 (PDT)
Date:   Sat, 26 Oct 2019 11:22:35 -0700 (PDT)
Message-Id: <20191026.112235.711416398803098524.davem@davemloft.net>
To:     xiaojiangfeng@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        leeyou.li@huawei.com, zhanghan23@huawei.com, nixiaoming@huawei.com,
        zhangqiang.cn@hisilicon.com, dingjingcheng@hisilicon.com
Subject: Re: [PATCH] net: hisilicon: Fix ping latency when deal with high
 throughput
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572079779-76449-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1572079779-76449-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 26 Oct 2019 11:22:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Date: Sat, 26 Oct 2019 16:49:39 +0800

> diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
> index ad6d912..78f338a 100644
> --- a/drivers/net/ethernet/hisilicon/hip04_eth.c
> +++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
> @@ -575,7 +575,7 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
>  	struct hip04_priv *priv = container_of(napi, struct hip04_priv, napi);
>  	struct net_device *ndev = priv->ndev;
>  	struct net_device_stats *stats = &ndev->stats;
> -	unsigned int cnt = hip04_recv_cnt(priv);
> +	static unsigned int cnt_remaining;

There is no way a piece of software state should be system wide, this is
a per device instance value.
