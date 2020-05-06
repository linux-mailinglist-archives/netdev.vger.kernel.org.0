Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64861C7B88
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgEFUv3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 16:51:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51835 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgEFUv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:51:28 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1jWQz9-0001tg-LD; Wed, 06 May 2020 20:49:43 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id E61A06C567; Wed,  6 May 2020 13:49:41 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id E0AD8AC1DB;
        Wed,  6 May 2020 13:49:41 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
cc:     netdev@vger.kernel.org,
        syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jann Horn <jannh@google.com>
Subject: Re: [Patch net v2] net: fix a potential recursive NETDEV_FEAT_CHANGE
In-reply-to: <20200506194613.18342-1-xiyou.wangcong@gmail.com>
References: <20200506194613.18342-1-xiyou.wangcong@gmail.com>
Comments: In-reply-to Cong Wang <xiyou.wangcong@gmail.com>
   message dated "Wed, 06 May 2020 12:46:13 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10172.1588798181.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 06 May 2020 13:49:41 -0700
Message-ID: <10173.1588798181@famine>
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
>
>When a NETDEV_FEAT_CHANGE event is triggered on a bonding slave,
>it captures this and calls bond_compute_features() to fixup its
>master's and other slaves' features. However, when syncing with
>its lower devices by netdev_sync_lower_features() this event is
>triggered again on slaves when the LRO feature fails to change,
>so it goes back and forth recursively until the kernel stack is
>exhausted.
>
>Commit 17b85d29e82c intentionally lets __netdev_update_features()
>return -1 for such a failure case, so we have to just rely on
>the existing check inside netdev_sync_lower_features() and skip
>NETDEV_FEAT_CHANGE event only for this specific failure case.
>
>Fixes: 17b85d29e82c ("net/core: revert "net: fix __netdev_update_features return.." and add comment")
>Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
>Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
>Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>Cc: Josh Poimboeuf <jpoimboe@redhat.com>
>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Jann Horn <jannh@google.com>
>Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
> net/core/dev.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/net/core/dev.c b/net/core/dev.c
>index 522288177bbd..6d327b7aa813 100644
>--- a/net/core/dev.c
>+++ b/net/core/dev.c
>@@ -8907,11 +8907,13 @@ static void netdev_sync_lower_features(struct net_device *upper,
> 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
> 				   &feature, lower->name);
> 			lower->wanted_features &= ~feature;
>-			netdev_update_features(lower);
>+			__netdev_update_features(lower);
> 
> 			if (unlikely(lower->features & feature))
> 				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
> 					    &feature, lower->name);
>+			else
>+				netdev_features_change(lower);
> 		}
> 	}
> }
>-- 
>2.26.2
>
