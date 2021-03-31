Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156EE34F53F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhCaAC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:02:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50554 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhCaACe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 20:02:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 16F344D25BD13;
        Tue, 30 Mar 2021 17:02:33 -0700 (PDT)
Date:   Tue, 30 Mar 2021 17:02:28 -0700 (PDT)
Message-Id: <20210330.170228.191449180243560631.davem@davemloft.net>
To:     lyl2019@mail.ustc.edu.cn
Cc:     santosh.shilimkar@oracle.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rds: Fix a use after free in rds_message_map_pages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210330101602.22505-1-lyl2019@mail.ustc.edu.cn>
References: <20210330101602.22505-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 30 Mar 2021 17:02:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Date: Tue, 30 Mar 2021 03:16:02 -0700

> @@ -348,7 +348,7 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
>  	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
>  	if (IS_ERR(rm->data.op_sg)) {
>  		rds_message_put(rm);
> -		return ERR_CAST(rm->data.op_sg);
> +		return ERR_PTR(-ENOMEM);
>  	}
>  
>  	for (i = 0; i < rm->data.op_nents; ++i) {

Maybe instead do:

      int err = ERR_CAST(rm->data.op_sg);
      rds_message_put(rm);
      return err;

Then if rds_message_alloc_sgs() starts to return other errors, they will propagate.

Thank you.
