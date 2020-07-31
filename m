Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B766234EBF
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgGaXyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgGaXyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:54:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3875CC06174A;
        Fri, 31 Jul 2020 16:54:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20C1011E58FA6;
        Fri, 31 Jul 2020 16:37:37 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:54:21 -0700 (PDT)
Message-Id: <20200731.165421.653261887142519995.davem@davemloft.net>
To:     yepeilin.cs@gmail.com
Cc:     santosh.shilimkar@oracle.com, kuba@kernel.org,
        dan.carpenter@oracle.com, arnd@arndb.de,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent
 kernel-infoleak in rds_notify_queue_get()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730192026.110246-1-yepeilin.cs@gmail.com>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:37:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>
Date: Thu, 30 Jul 2020 15:20:26 -0400

> rds_notify_queue_get() is potentially copying uninitialized kernel stack
> memory to userspace since the compiler may leave a 4-byte hole at the end
> of `cmsg`.
> 
> In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`, which
> unfortunately does not always initialize that 4-byte hole. Fix it by using
> memset() instead.
> 
> Cc: stable@vger.kernel.org
> Fixes: f037590fff30 ("rds: fix a leak of kernel memory")
> Fixes: bdbe6fbc6a2f ("RDS: recv.c")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>

Applied and queued up for -stable, thanks.

I saw a suggestion to use __packed but that breaks UAPI and is definitely
not an option to solve this problem.
