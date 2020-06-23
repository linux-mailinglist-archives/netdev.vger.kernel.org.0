Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3D02065C9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389736AbgFWVdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391365AbgFWVdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 17:33:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827C9C061573;
        Tue, 23 Jun 2020 14:33:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C76DA129425B6;
        Tue, 23 Jun 2020 14:33:13 -0700 (PDT)
Date:   Tue, 23 Jun 2020 14:33:11 -0700 (PDT)
Message-Id: <20200623.143311.995885759487352025.davem@davemloft.net>
To:     likaige@loongson.cn
Cc:     benve@cisco.com, _govind@gmx.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lixuefeng@loongson.cn,
        yangtiezhu@loongson.cn
Subject: Re: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592899989-22049-1-git-send-email-likaige@loongson.cn>
References: <1592899989-22049-1-git-send-email-likaige@loongson.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 14:33:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaige Li <likaige@loongson.cn>
Date: Tue, 23 Jun 2020 16:13:09 +0800

> The kernel module may sleep with holding a spinlock.
> 
> The function call paths (from bottom to top) are:
> 
> [FUNC] zalloc_cpumask_var(GFP_KERNEL)
> drivers/net/ethernet/cisco/enic/enic_main.c, 125: zalloc_cpumask_var in enic_init_affinity_hint
> drivers/net/ethernet/cisco/enic/enic_main.c, 1918: enic_init_affinity_hint in enic_open
> drivers/net/ethernet/cisco/enic/enic_main.c, 2348: enic_open in enic_reset
> drivers/net/ethernet/cisco/enic/enic_main.c, 2341: spin_lock in enic_reset
> 
> To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.
> 
> Signed-off-by: Kaige Li <likaige@loongson.cn>

Just grepping around for GFP_KERNEL usage in atomic contexts I guess
is fine.

But you really have to look at the bigger picture.

Calling a NIC driver open function from a context holding a spinlock
is very much the real problem, so many operations have to sleep and
in face that ->ndo_open() method is defined as being allowed to sleep
and that's why the core networking never invokes it with spinlocks
held.
