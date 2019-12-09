Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A5111795E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfLIWbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:31:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36536 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfLIWbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:31:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4AC1A15492874;
        Mon,  9 Dec 2019 14:31:10 -0800 (PST)
Date:   Mon, 09 Dec 2019 14:31:09 -0800 (PST)
Message-Id: <20191209.143109.1010404838982057668.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     loke.chetan@gmail.com, willemb@google.com, edumazet@google.com,
        maximmi@mellanox.com, nhorman@tuxdriver.com, pabeni@redhat.com,
        yuehaibing@huawei.com, tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        xiaojiangfeng@huawei.com
Subject: Re: [PATCH net] af_packet: set defaule value for tmo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209133125.59093-1-maowenan@huawei.com>
References: <20191209133125.59093-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 14:31:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Mon, 9 Dec 2019 21:31:25 +0800

> There is softlockup when using TPACKET_V3:
> ...
> NMI watchdog: BUG: soft lockup - CPU#2 stuck for 60010ms!
> (__irq_svc) from [<c0558a0c>] (_raw_spin_unlock_irqrestore+0x44/0x54)
> (_raw_spin_unlock_irqrestore) from [<c027b7e8>] (mod_timer+0x210/0x25c)
> (mod_timer) from [<c0549c30>]
> (prb_retire_rx_blk_timer_expired+0x68/0x11c)
> (prb_retire_rx_blk_timer_expired) from [<c027a7ac>]
> (call_timer_fn+0x90/0x17c)
> (call_timer_fn) from [<c027ab6c>] (run_timer_softirq+0x2d4/0x2fc)
> (run_timer_softirq) from [<c021eaf4>] (__do_softirq+0x218/0x318)
> (__do_softirq) from [<c021eea0>] (irq_exit+0x88/0xac)
> (irq_exit) from [<c0240130>] (msa_irq_exit+0x11c/0x1d4)
> (msa_irq_exit) from [<c0209cf0>] (handle_IPI+0x650/0x7f4)
> (handle_IPI) from [<c02015bc>] (gic_handle_irq+0x108/0x118)
> (gic_handle_irq) from [<c0558ee4>] (__irq_usr+0x44/0x5c)
> ...
> 
> If __ethtool_get_link_ksettings() is failed in
> prb_calc_retire_blk_tmo(), msec and tmo will be zero, so tov_in_jiffies
> is zero and the timer expire for retire_blk_timer is turn to
> mod_timer(&pkc->retire_blk_timer, jiffies + 0),
> which will trigger cpu usage of softirq is 100%.
> 
> Fixes: f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer implementation.")
> Tested-by: Xiao Jiangfeng <xiaojiangfeng@huawei.com>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied, thanks.
