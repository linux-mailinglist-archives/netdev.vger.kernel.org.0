Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6DA232627
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgG2U2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2U2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 16:28:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFDCC061794;
        Wed, 29 Jul 2020 13:28:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F9A911CEB79D;
        Wed, 29 Jul 2020 13:12:06 -0700 (PDT)
Date:   Wed, 29 Jul 2020 13:28:42 -0700 (PDT)
Message-Id: <20200729.132842.190888844026802233.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     songliubraving@fb.com, hawk@kernel.org, kafai@fb.com,
        kpsingh@chromium.org, john.fastabend@gmail.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org,
        linux-rdma@vger.kernel.org, xiongx18@fudan.edu.cn, yhs@fb.com,
        andriin@fb.com, kuba@kernel.org, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        xiyuyang19@fudan.edu.cn, tanxin.ctf@gmail.com,
        yuanxzhang@fudan.edu.cn
Subject: Re: [PATCH] net/mlx5e: fix bpf_prog refcnt leaks in mlx5e_alloc_rq
From:   David Miller <davem@davemloft.net>
In-Reply-To: <613fe5f56cb60982937c826ed915ada2de5e93a2.camel@mellanox.com>
References: <20200729123334.GA6766@xin-virtual-machine>
        <613fe5f56cb60982937c826ed915ada2de5e93a2.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jul 2020 13:12:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 29 Jul 2020 19:02:15 +0000

> On Wed, 2020-07-29 at 20:33 +0800, Xin Xiong wrote:
>> The function invokes bpf_prog_inc(), which increases the refcount of
>> a
>> bpf_prog object "rq->xdp_prog" if the object isn't NULL.
>> 
>> The refcount leak issues take place in two error handling paths. When
>> mlx5_wq_ll_create() or mlx5_wq_cyc_create() fails, the function
>> simply
>> returns the error code and forgets to drop the refcount increased
>> earlier, causing a refcount leak of "rq->xdp_prog".
>> 
>> Fix this issue by jumping to the error handling path
>> err_rq_wq_destroy
>> when either function fails.
>> 
> 
> Fixes: 422d4c401edd ("net/mlx5e: RX, Split WQ objects for different RQ
> types")

Saeed, are you going to take this into your tree or would you like me to
apply it directly?

Thanks.
