Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8327741A7
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbfGXWrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:47:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53120 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbfGXWrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:47:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 18C311543C8D5;
        Wed, 24 Jul 2019 15:47:06 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:47:05 -0700 (PDT)
Message-Id: <20190724.154705.141831380224703229.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     tariqt@mellanox.com, ereza@mellanox.com, jackm@dev.mellanox.co.il,
        eli@mellanox.co.il, moshe@mellanox.com, jiri@mellanox.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] [net-next] mlx4: avoid large stack usage in
 mlx4_init_hca()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722150204.1157315-1-arnd@arndb.de>
References: <20190722150204.1157315-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 15:47:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 22 Jul 2019 17:01:55 +0200

> The mlx4_dev_cap and mlx4_init_hca_param are really too large
> to be put on the kernel stack, as shown by this clang warning:
> 
> drivers/net/ethernet/mellanox/mlx4/main.c:3304:12: error: stack frame size of 1088 bytes in function 'mlx4_load_one' [-Werror,-Wframe-larger-than=]
> 
> With gcc, the problem is the same, but it does not warn because
> it does not inline this function, and therefore stays just below
> the warning limit, while clang is just above it.
> 
> Use kzalloc for dynamic allocation instead of putting them
> on stack. This gets the combined stack frame down to 424 bytes.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
