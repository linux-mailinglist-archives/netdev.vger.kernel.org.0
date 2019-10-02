Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802AEC936D
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbfJBVWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:22:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728713AbfJBVWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:22:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DF32154F41D6;
        Wed,  2 Oct 2019 14:22:15 -0700 (PDT)
Date:   Wed, 02 Oct 2019 14:22:14 -0700 (PDT)
Message-Id: <20191002.142214.252882219207569928.davem@davemloft.net>
To:     yzhai003@ucr.edu
Cc:     csong@cs.ucr.edu, zhiyunq@cs.ucr.edu, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hisilicon: Fix usage of uninitialized variable in
 function mdio_sc_cfg_reg_write()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001202439.15766-1-yzhai003@ucr.edu>
References: <20191001202439.15766-1-yzhai003@ucr.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 14:22:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yizhuo <yzhai003@ucr.edu>
Date: Tue,  1 Oct 2019 13:24:39 -0700

> In function mdio_sc_cfg_reg_write(), variable "reg_value" could be
> uninitialized if regmap_read() fails. However, "reg_value" is used
> to decide the control flow later in the if statement, which is
> potentially unsafe.
> 
> Signed-off-by: Yizhuo <yzhai003@ucr.edu>

Applied, but really this is such a pervasive problem.

So much code doesn't check the return value from either regmap_read
or regmap_write.

_EVEN_ in the code you are editing, the patch context shows an unchecked
regmap_write() call.

> @@ -148,11 +148,15 @@ static int mdio_sc_cfg_reg_write(struct hns_mdio_device *mdio_dev,
>  {
>  	u32 time_cnt;
>  	u32 reg_value;
> +	int ret;
>  
>  	regmap_write(mdio_dev->subctrl_vbase, cfg_reg, set_val);
        ^^^^^^^^^^^^

Grepping for regmap_{read,write}() shows how big an issue this is.

I don't know what to do, maybe we can work over time to add checks to
all calls and then force warnings on unchecked return values so that
the problem is not introduced in the future.
