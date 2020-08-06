Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1723E19F
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 21:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgHFTBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 15:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFTBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 15:01:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A70C061574;
        Thu,  6 Aug 2020 12:01:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1AA8211DB3163;
        Thu,  6 Aug 2020 11:44:21 -0700 (PDT)
Date:   Thu, 06 Aug 2020 12:01:03 -0700 (PDT)
Message-Id: <20200806.120103.1200684111953914586.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com
Subject: Re: [PATCH net-next] hinic: fix strncpy output truncated compile
 warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200806074830.1375-1-luobin9@huawei.com>
References: <20200806074830.1375-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Aug 2020 11:44:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Thu, 6 Aug 2020 15:48:30 +0800

> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> index c6adc776f3c8..1dc948c07b94 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> @@ -342,9 +342,9 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
>  
>  	level = event->event.chip.err_level;
>  	if (level < FAULT_LEVEL_MAX)
> -		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
> +		strncpy(level_str, fault_level[level], strlen(fault_level[level]) + 1);
>  	else
> -		strncpy(level_str, "Unknown", strlen("Unknown"));
> +		strncpy(level_str, "Unknown", sizeof(level_str));
>  
>  	if (level == FAULT_LEVEL_SERIOUS_FLR) {

Please fix these cases consistently, either use the strlen()+1 pattern
or the "sizeof(destination)" one.

Probably sizeof(destination) is best.
