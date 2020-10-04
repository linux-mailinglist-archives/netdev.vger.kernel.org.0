Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C7728279A
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgJDA0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgJDA0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:26:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2AFC0613D0;
        Sat,  3 Oct 2020 17:26:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B204611E3E4CA;
        Sat,  3 Oct 2020 17:10:00 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:26:47 -0700 (PDT)
Message-Id: <20201003.172647.2111926819782777286.davem@davemloft.net>
To:     manjunath.b.patil@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, aruna.ramakrishna@oracle.com,
        rama.nichanamatlu@oracle.com
Subject: Re: [PATCH 1/1] net/rds: suppress page allocation failure error in
 recv buffer refill
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1601669145-13604-1-git-send-email-manjunath.b.patil@oracle.com>
References: <1601669145-13604-1-git-send-email-manjunath.b.patil@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 17:10:00 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manjunath Patil <manjunath.b.patil@oracle.com>
Date: Fri,  2 Oct 2020 13:05:45 -0700

> RDS/IB tries to refill the recv buffer in softirq context using
> GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
> refill the recv buffer with GFP_KERNEL flag. This means failure to
> allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
> softirq context fails to refill the recv buffer, instead print rate
> limited warnings.
> 
> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
> Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>

Honestly I don't think the subsystem should print any warning at all.

Either it's a softirq failure, and that's ok because you will push
the allocation to GFP_KERNEL via a work job.  Or it's a GFP_KERNEL
failure in non-softirq context and the kernel will print a warning
and a stack backtrace from the memory allocator.

Therefore, please remove all of the warnings in the rds code.

Thanks.
