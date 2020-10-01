Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E487E2807F3
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733038AbgJATns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729990AbgJATns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 15:43:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A832C0613D0;
        Thu,  1 Oct 2020 12:43:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E28F81443FFCF;
        Thu,  1 Oct 2020 12:26:58 -0700 (PDT)
Date:   Thu, 01 Oct 2020 12:43:45 -0700 (PDT)
Message-Id: <20201001.124345.2303686561459641833.davem@davemloft.net>
To:     colyli@suse.de
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, chaitanya.kulkarni@wdc.com,
        cleech@redhat.com, hch@lst.de, amwang@redhat.com,
        eric.dumazet@gmail.com, hare@suse.de, idryomov@gmail.com,
        jack@suse.com, jlayton@kernel.org, axboe@kernel.dk,
        lduncan@suse.com, michaelc@cs.wisc.edu,
        mskorzhinskiy@solarflare.com, philipp.reisner@linbit.com,
        sagi@grimberg.me, vvs@virtuozzo.com, vbabka@suse.com
Subject: Re: [PATCH v9 0/7] Introduce sendpage_ok() to detect misused
 sendpage in network related drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001075408.25508-1-colyli@suse.de>
References: <20201001075408.25508-1-colyli@suse.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 12:26:59 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coly Li <colyli@suse.de>
Date: Thu,  1 Oct 2020 15:54:01 +0800

> This series was original by a bug fix in nvme-over-tcp driver which only
> checked whether a page was allocated from slab allcoator, but forgot to
> check its page_count: The page handled by sendpage should be neither a
> Slab page nor 0 page_count page.
> 
> As Sagi Grimberg suggested, the original fix is refind to a more common
> inline routine:
>     static inline bool sendpage_ok(struct page *page)
>     {
>         return  (!PageSlab(page) && page_count(page) >= 1);
>     }
> If sendpage_ok() returns true, the checking page can be handled by the
> concrete zero-copy sendpage method in network layer.
> 
> The v9 series has 7 patches, no change from v8 series,
> - The 1st patch in this series introduces sendpage_ok() in header file
>   include/linux/net.h.
> - The 2nd patch adds WARN_ONCE() for improper zero-copy send in
>   kernel_sendpage().
> - The 3rd patch fixes the page checking issue in nvme-over-tcp driver.
> - The 4th patch adds page_count check by using sendpage_ok() in
>   do_tcp_sendpages() as Eric Dumazet suggested.
> - The 5th and 6th patches just replace existing open coded checks with
 ...

Series applied and queued up for -stable, thank you.
