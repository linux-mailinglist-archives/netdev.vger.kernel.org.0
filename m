Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC1A1C640F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 00:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgEEWmR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 May 2020 18:42:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43217 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgEEWmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 18:42:17 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1jW6EJ-0002am-Fk; Tue, 05 May 2020 22:39:59 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id BDDBE6C567; Tue,  5 May 2020 15:39:57 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id B6A1BAC1DB;
        Tue,  5 May 2020 15:39:57 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
cc:     netdev@vger.kernel.org,
        syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jann Horn <jannh@google.com>
Subject: Re: [Patch net] net: fix a potential recursive NETDEV_FEAT_CHANGE
In-reply-to: <20200505215819.1997-1-xiyou.wangcong@gmail.com>
References: <20200505215819.1997-1-xiyou.wangcong@gmail.com>
Comments: In-reply-to Cong Wang <xiyou.wangcong@gmail.com>
   message dated "Tue, 05 May 2020 14:58:19 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2832.1588718397.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 05 May 2020 15:39:57 -0700
Message-ID: <2833.1588718397@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:

>syzbot managed to trigger a recursive NETDEV_FEAT_CHANGE event
>between bonding master and slave. I managed to find a reproducer
>for this:
>
>  ip li set bond0 up
>  ifenslave bond0 eth0
>  brctl addbr br0
>  ethtool -K eth0 lro off
>  brctl addif br0 bond0
>  ip li set br0 up

	Presumably this is tied to the LRO feature being special in
netdev_sync_lower_features (via NETIF_F_UPPER_DISABLES), but why doesn't
LRO become disabled and stop the recursion once the test

		if (!(features & feature) && (lower->features & feature)) {

	no longer evalutes to true (in theory)?

	-J

>When a NETDEV_FEAT_CHANGE event is triggered on a bonding slave,
>it captures this and calls bond_compute_features() to fixup its
>master's and other slaves' features. However, when syncing with
>its lower devices by netdev_sync_lower_features() this event is
>triggered again on slaves, so it goes back and forth recursively
>until the kernel stack is exhausted.
>
>It is unnecessary to trigger it for a second time, because when
>we update the features from top down, we rely on each
>dev->netdev_ops->ndo_fix_features() to do the job, each stacked
>device should implement it. NETDEV_FEAT_CHANGE event is necessary
>when we update from bottom up, like in existing stacked device
>implementations.
>
>Just calling __netdev_update_features() is sufficient to fix this
>issue.
>
>Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
>Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
>Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
>Cc: Jarod Wilson <jarod@redhat.com>
>Cc: Josh Poimboeuf <jpoimboe@redhat.com>
>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Jann Horn <jannh@google.com>
>Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>---
> net/core/dev.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/core/dev.c b/net/core/dev.c
>index 522288177bbd..ece50ae346c3 100644
>--- a/net/core/dev.c
>+++ b/net/core/dev.c
>@@ -8907,7 +8907,7 @@ static void netdev_sync_lower_features(struct net_device *upper,
> 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
> 				   &feature, lower->name);
> 			lower->wanted_features &= ~feature;
>-			netdev_update_features(lower);
>+			__netdev_update_features(lower);
> 
> 			if (unlikely(lower->features & feature))
> 				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
>-- 
>2.26.2
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
