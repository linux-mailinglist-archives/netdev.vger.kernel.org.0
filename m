Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4D07916E
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfG2Qu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:50:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35860 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfG2Qu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:50:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BDA51266536D;
        Mon, 29 Jul 2019 09:50:57 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:50:56 -0700 (PDT)
Message-Id: <20190729.095056.757433801392494014.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] net: bridge: delete local fdb on device init
 failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729092841.4260-1-nikolay@cumulusnetworks.com>
References: <20190728182230.28818-1-nikolay@cumulusnetworks.com>
        <20190729092841.4260-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 09:50:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Mon, 29 Jul 2019 12:28:41 +0300

> On initialization failure we have to delete the local fdb which was
> inserted due to the default pvid creation. This problem has been present
> since the inception of default_pvid. Note that currently there are 2 cases:
> 1) in br_dev_init() when br_multicast_init() fails
> 2) if register_netdevice() fails after calling ndo_init()
> 
> This patch takes care of both since br_vlan_flush() is called on both
> occasions. Also the new fdb delete would be a no-op on normal bridge
> device destruction since the local fdb would've been already flushed by
> br_dev_delete(). This is not an issue for ports since nbp_vlan_init() is
> called last when adding a port thus nothing can fail after it.
> 
> Reported-by: syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
> Fixes: 5be5a2df40f0 ("bridge: Add filtering support for default_pvid")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
> v2: reworded the commit message and comment so they're not plural, we're
>     talking about a single bridge local fdb added on the init vlan creation
>     of the default pvid
> 
> Tested with the provided reproducer and can no longer trigger the leak.
> Also tested the br_multicast_init() failure manually by making it always
> return an error.

Applied and queued up for -stable, thank you.
