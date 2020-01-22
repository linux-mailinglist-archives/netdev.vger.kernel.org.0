Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D169145C84
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAVTd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:33:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVTd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 14:33:28 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 525DD15A14973;
        Wed, 22 Jan 2020 11:32:53 -0800 (PST)
Date:   Wed, 22 Jan 2020 20:32:52 +0100 (CET)
Message-Id: <20200122.203252.1974816529601154217.davem@davemloft.net>
To:     rpalethorpe@suse.com
Cc:     linux-can@vger.kernel.org,
        syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com,
        wg@grandegger.com, mkl@pengutronix.de, tylerwhall@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com
Subject: Re: [PATCH v3] can, slip: Protect tty->disc_data in write_wakeup
 and close with RCU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121134258.18013-1-rpalethorpe@suse.com>
References: <20200121134258.18013-1-rpalethorpe@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jan 2020 11:33:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Palethorpe <rpalethorpe@suse.com>
Date: Tue, 21 Jan 2020 14:42:58 +0100

> write_wakeup can happen in parallel with close/hangup where tty->disc_data
> is set to NULL and the netdevice is freed thus also freeing
> disc_data. write_wakeup accesses disc_data so we must prevent close from
> freeing the netdev while write_wakeup has a non-NULL view of
> tty->disc_data.
> 
> We also need to make sure that accesses to disc_data are atomic. Which can
> all be done with RCU.
> 
> This problem was found by Syzkaller on SLCAN, but the same issue is
> reproducible with the SLIP line discipline using an LTP test based on the
> Syzkaller reproducer.
> 
> A fix which didn't use RCU was posted by Hillf Danton.
> 
> Fixes: 661f7fda21b1 ("slip: Fix deadlock in write_wakeup")
> Fixes: a8e83b17536a ("slcan: Port write_wakeup deadlock fix from slip")
> Reported-by: syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com
> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>

Applied and queued up for -stable, thanks.
