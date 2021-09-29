Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539D041C880
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345241AbhI2PeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345191AbhI2PeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:34:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BC0761247;
        Wed, 29 Sep 2021 15:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632929550;
        bh=mZN4WHEH7SfBbgfnMGP3DEIgIkh/IFNuIydXiWwOmrk=;
        h=From:To:Cc:Subject:Date:From;
        b=DURmdxRJhxR4fbnRtSdlAA7PgCP/797Yn3xLDiZFO4ky40X5jakdlo+LhpXOvK/gN
         FKxd+owlPW1TEY+1SgJHAzuBO7q3zZHn0gSFztHVibwBpF1rKcq16XFfHLNj9tdw+S
         D+mbv2JzHzqy48yfXn95I4qRlH+iI/7Cn1ZJvH8YFlTUTINGZED5W5fuLmT9fCyOQ8
         5Ej9+we2YhcEotFQnvM/4W42/G5/ZJjuara4tv6RcsSrBv5DE9HkKBBMDjykOu3dFL
         6hd/5tsoCO1ADXdyotxYS+kNT/wpBN1rmJfvhOvGukBm4FqK35BRyorFPTsdY84Rms
         xaLYHF9CvFFRQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gnaaman@drivenets.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+7a2ab2cdc14d134de553@syzkaller.appspotmail.com
Subject: [PATCH net] net: dev_addr_list: handle first address in __hw_addr_add_ex
Date:   Wed, 29 Sep 2021 08:32:24 -0700
Message-Id: <20210929153224.1290487-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct dev_addr_list is used for device addresses, unicast addresses
and multicast addresses. The first of those needs special handling
of the main address - netdev->dev_addr points directly the data
of the entry and drivers write to it freely, so we can't maintain
it in the rbtree (for now, at least, to be fixed in net-next).

Current work around sprinkles special handling of the first
address on the list throughout the code but it missed the case
where address is being added. First address will not be visible
during subsequent adds.

Syzbot found a warning where unicast addresses are modified
without holding the rtnl lock, tl;dr is that team generates
the same modification multiple times, not necessarily when
right locks are held.

In the repro we have:

  macvlan -> team -> veth

macvlan adds a unicast address to the team. Team then pushes
that address down to its memebers (veths). Next something unrelated
makes team sync member addrs again, and because of the bug
the addr entries get duplicated in the veths. macvlan gets
removed, removes its addr from team which removes only one
of the duplicated addresses from veths. This removal is done
under rtnl. Next syzbot uses iptables to add a multicast addr
to team (which does not hold rtnl lock). Team syncs veth addrs,
but because veths' unicast list still has the duplicate it will
also get sync, even though this update is intended for mc addresses.
Again, uc address updates need rtnl lock, boom.

Reported-by: syzbot+7a2ab2cdc14d134de553@syzkaller.appspotmail.com
Fixes: 406f42fa0d3c ("net-next: When a bond have a massive amount of VLANs with IPv6 addresses, performance of changing link state, attaching a VRF, changing an IPv6 address, etc. go down dramtically.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev_addr_lists.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 8c39283c26ae..f0cb38344126 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -50,6 +50,11 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 	if (addr_len > MAX_ADDR_LEN)
 		return -EINVAL;
 
+	ha = list_first_entry(&list->list, struct netdev_hw_addr, list);
+	if (ha && !memcmp(addr, ha->addr, addr_len) &&
+	    (!addr_type || addr_type == ha->type))
+		goto found_it;
+
 	while (*ins_point) {
 		int diff;
 
@@ -64,6 +69,7 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 		} else if (diff > 0) {
 			ins_point = &parent->rb_right;
 		} else {
+found_it:
 			if (exclusive)
 				return -EEXIST;
 			if (global) {
-- 
2.31.1

