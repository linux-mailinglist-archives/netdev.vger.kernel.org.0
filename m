Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C321B28079E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732755AbgJATVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729990AbgJATVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 15:21:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FEEC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 12:21:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F40CE14418109;
        Thu,  1 Oct 2020 12:04:35 -0700 (PDT)
Date:   Thu, 01 Oct 2020 12:21:20 -0700 (PDT)
Message-Id: <20201001.122120.1497340751468134272.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, shayd@mellanox.com,
        saeedm@mellanox.com, saeedm@nvidia.com
Subject: Re: [net 01/15] net/mlx5: Don't allow health work when device is
 uninitialized
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001020516.41217-2-saeed@kernel.org>
References: <20201001020516.41217-1-saeed@kernel.org>
        <20201001020516.41217-2-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 12:04:36 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: saeed@kernel.org
Date: Wed, 30 Sep 2020 19:05:02 -0700

> @@ -201,6 +206,9 @@ void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
>  		err_detected = true;
>  	}
>  	mutex_lock(&dev->intf_state_mutex);
> +	if (!mlx5_is_device_initialized(dev))
> +		return;
> +

You can return with this mutex held, and that's ok?

I think you have to "goto unlock;" or similar.
