Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B94F1CA009
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgEHBTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgEHBTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:19:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966F9C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 18:19:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6CFB119376FE;
        Thu,  7 May 2020 18:19:30 -0700 (PDT)
Date:   Thu, 07 May 2020 18:19:30 -0700 (PDT)
Message-Id: <20200507.181930.292334116869510588.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        jarod@redhat.com, nikolay@cumulusnetworks.com, jpoimboe@redhat.com,
        jannh@google.com, jay.vosburgh@canonical.com
Subject: Re: [Patch net v3] net: fix a potential recursive
 NETDEV_FEAT_CHANGE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507191903.4090-1-xiyou.wangcong@gmail.com>
References: <20200507191903.4090-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 18:19:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu,  7 May 2020 12:19:03 -0700

> syzbot managed to trigger a recursive NETDEV_FEAT_CHANGE event
> between bonding master and slave. I managed to find a reproducer
> for this:
> 
>   ip li set bond0 up
>   ifenslave bond0 eth0
>   brctl addbr br0
>   ethtool -K eth0 lro off
>   brctl addif br0 bond0
>   ip li set br0 up
> 
> When a NETDEV_FEAT_CHANGE event is triggered on a bonding slave,
> it captures this and calls bond_compute_features() to fixup its
> master's and other slaves' features. However, when syncing with
> its lower devices by netdev_sync_lower_features() this event is
> triggered again on slaves when the LRO feature fails to change,
> so it goes back and forth recursively until the kernel stack is
> exhausted.
> 
> Commit 17b85d29e82c intentionally lets __netdev_update_features()
> return -1 for such a failure case, so we have to just rely on
> the existing check inside netdev_sync_lower_features() and skip
> NETDEV_FEAT_CHANGE event only for this specific failure case.
> 
> Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
> Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
> Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
> Cc: Jarod Wilson <jarod@redhat.com>
> Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jann Horn <jannh@google.com>
> Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks Cong.
