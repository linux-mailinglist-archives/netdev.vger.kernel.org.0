Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF20E2EC34A
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbhAFSky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbhAFSky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 13:40:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3C9223125;
        Wed,  6 Jan 2021 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609958413;
        bh=e76ZrSUo4kfJMpdyS4XgVdQgK/kZ7LafnTrqfSStf5s=;
        h=From:To:Cc:Subject:Date:From;
        b=pBi4uRgIH6zJJxneqrp7CcW348KiG4LvjcAwvdaPVu4iECzXwnwSiGTTFTnmEFcON
         iid5VS3fLOBaK+NYmEvtPSggWPKFs/ZhN7/+hlwBKq3fNzwP06gcAhgFZB3XenhyPA
         y5tdf6BChp6nd36g2lTVPnu1NO4Xyh2PkjRUrewQ6E51payf6A3Jpqn4PA/3WuVFcY
         351YrhmHGuYe1YJY9bnvvXFnyeXrU/STnabgatHgBWYmVunmU70OAvdMqmNiWSssxk
         5MkrB9roIqfFcHQMHZWjnTvYNfJObAbdVzK+UY2iITciOmbB/zuJ3+WJMTQhfy/Hfv
         u3reuzm6P5uoQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com, xiyou.wangcong@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/3] net: fix issues around register_netdevice() failures
Date:   Wed,  6 Jan 2021 10:40:04 -0800
Message-Id: <20210106184007.1821480-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series attempts to clean up the life cycle of struct
net_device. Dave has added dev->needs_free_netdev in the
past to fix double frees, we can lean on that mechanism
a little more to fix remaining issues with register_netdevice().

This is the next chapter of the saga which already includes:
commit 0e0eee2465df ("net: correct error path in rtnl_newlink()")
commit e51fb152318e ("rtnetlink: fix a memory leak when ->newlink fails")
commit cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
commit 93ee31f14f6f ("[NET]: Fix free_netdev on register_netdev failure.")
commit 814152a89ed5 ("net: fix memleak in register_netdevice()")
commit 10cc514f451a ("net: Fix null de-reference of device refcount")

The immediate problem which gets fixed here is that calling
free_netdev() right after unregister_netdevice() is illegal
because we need to release rtnl_lock first, to let the
unregistration finish. Note that unregister_netdevice() is
just a wrapper of unregister_netdevice_queue(), it only
does half of the job.

Where this limitation becomes most problematic is in failure
modes of register_netdevice(). There is a notifier call right
at the end of it, which lets other subsystems veto the entire
thing. At which point we should really go through a full
unregister_netdevice(), but we can't because callers may
go straight to free_netdev() after the failure, and that's
no bueno (see the previous paragraph).

This set makes free_netdev() more lenient, when device
is still being unregistered free_netdev() will simply set
dev->needs_free_netdev and let the unregister process do
the freeing.

With the free_netdev() problem out of the way failures in
register_netdevice() can make use of net_todo, again.
Users are still expected to call free_netdev() right after
failure but that will only set dev->needs_free_netdev.

To prevent the pathological case of:

 dev->needs_free_netdev = true;
 if (register_netdevice(dev)) {
   rtnl_unlock();
   free_netdev(dev);
 }

make register_netdevice()'s failure clear dev->needs_free_netdev.

Problems described above are only present with register_netdevice() /
unregister_netdevice(). We have two parallel APIs for registration
of devices:
 - those called outside rtnl_lock (register_netdev(), and
   unregister_netdev());
 - and those to be used under rtnl_lock - register_netdevice()
   and unregister_netdevice().
The former is trivial and has no problems. The alternative
approach to fix the latter would be to also separate the
freeing functions - i.e. add free_netdevice(). This has been
implemented (incl. converting all relevant calls in the tree)
but it feels a little unnecessary to put the burden of choosing
the right free_netdev{,ice}() call on the programmer when we
can "just do the right thing" by default.

Jakub Kicinski (3):
  docs: net: explain struct net_device lifetime
  net: make free_netdev() more lenient with unregistering devices
  net: make sure devices go through netdev_wait_all_refs

 Documentation/networking/netdevices.rst | 171 +++++++++++++++++++++++-
 net/8021q/vlan.c                        |   4 +-
 net/core/dev.c                          |  25 ++--
 net/core/rtnetlink.c                    |  23 +---
 4 files changed, 187 insertions(+), 36 deletions(-)

-- 
2.26.2

