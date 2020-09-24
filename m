Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3FD277B18
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 23:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgIXVeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 17:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgIXVeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 17:34:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCEF623899;
        Thu, 24 Sep 2020 21:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600983248;
        bh=lpF7+H5NHgl31JT8ymD6WzPLK1chDR+gm24YtcIjOpk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RA+FKsmtnUFuB6FMdD8Exmiml1wQmNT4NTNmhfaex8JtVfKwsevVLyDTHBpTIIJ+j
         CNcVx1QJ4rpqQYmuFN7x77O9u7gfSO/AuEiDZKaVUvEq0d9iR750wMw0G9e6BK81ho
         8zygHs1uMm/X1AusNyyJ/2Akzz8/KiMekmbRhMW8=
Date:   Thu, 24 Sep 2020 14:34:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vakul.garg@nxp.com,
        secdev@chelsio.com
Subject: Re: [PATCH] net/tls: race causes kernel panic
Message-ID: <20200924143406.45288d74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200924065845.30594-1-rohitm@chelsio.com>
References: <20200924065845.30594-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020 12:28:45 +0530 Rohit Maheshwari wrote:
> BUG: kernel NULL pointer dereference, address: 00000000000000b8
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 80000008b6fef067 P4D 80000008b6fef067 PUD 8b6fe6067 PMD 0
>  Oops: 0000 [#1] SMP PTI
>  CPU: 12 PID: 23871 Comm: kworker/12:80 Kdump: loaded Tainted: G S
>  5.9.0-rc3+ #1
>  Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.1 03/29/2018
>  Workqueue: events tx_work_handler [tls]
>  RIP: 0010:tx_work_handler+0x1b/0x70 [tls]
>  Code: dc fe ff ff e8 16 d4 a3 f6 66 0f 1f 44 00 00 0f 1f 44 00 00 55 53 48 8b
>  6f 58 48 8b bd a0 04 00 00 48 85 ff 74 1c 48 8b 47 28 <48> 8b 90 b8 00 00 00 83
>  e2 02 75 0c f0 48 0f ba b0 b8 00 00 00 00
>  RSP: 0018:ffffa44ace61fe88 EFLAGS: 00010286
>  RAX: 0000000000000000 RBX: ffff91da9e45cc30 RCX: dead000000000122
>  RDX: 0000000000000001 RSI: ffff91da9e45cc38 RDI: ffff91d95efac200
>  RBP: ffff91da133fd780 R08: 0000000000000000 R09: 000073746e657665
>  R10: 8080808080808080 R11: 0000000000000000 R12: ffff91dad7d30700
>  R13: ffff91dab6561080 R14: 0ffff91dad7d3070 R15: ffff91da9e45cc38
>  FS:  0000000000000000(0000) GS:ffff91dad7d00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00000000000000b8 CR3: 0000000906478003 CR4: 00000000003706e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
>   process_one_work+0x1a7/0x370
>   worker_thread+0x30/0x370
>   ? process_one_work+0x370/0x370
>   kthread+0x114/0x130
>   ? kthread_park+0x80/0x80
>   ret_from_fork+0x22/0x30
> 
> tls_sw_release_resources_tx() waits for encrypt_pending, which
> can have race, so we need similar changes as in commit
> 0cada33241d9de205522e3858b18e506ca5cce2c here as well.
> 
> Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
