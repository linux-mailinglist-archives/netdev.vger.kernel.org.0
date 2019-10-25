Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C01E4D01
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502332AbfJYN5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394797AbfJYN5I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:57:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E5521E6F;
        Fri, 25 Oct 2019 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011826;
        bh=lLl/382NG8pDVJRx0pzc1ZEuxoHjguG+r8UTBHq+76s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyITTS1GBtMEPt6oj5R13jY3BqHEx3rtH0SIA3td2rlICIkboWxbVOWTnsZL54w4e
         kFG6BT2NWP/Q5IO9agejJG9OfqcFwHuPFHhBYr2sTFFwkqliBLZGLf/ENz/mybFs/C
         +YgdknK0kGw+nvU9pjwj70ZSvoCvuDItsZE2fKCQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 35/37] ipv6: Handle race in addrconf_dad_work
Date:   Fri, 25 Oct 2019 09:55:59 -0400
Message-Id: <20191025135603.25093-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit a3ce2a21bb8969ae27917281244fa91bf5f286d7 ]

Rajendra reported a kernel panic when a link was taken down:

[ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
[ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290

<snip>

[ 6870.570501] Call Trace:
[ 6870.573238] [<ffffffff8efc58c6>] ? ipv6_ifa_notify+0x26/0x40
[ 6870.579665] [<ffffffff8efc98ec>] ? addrconf_dad_completed+0x4c/0x2c0
[ 6870.586869] [<ffffffff8efe70c6>] ? ipv6_dev_mc_inc+0x196/0x260
[ 6870.593491] [<ffffffff8efc9c6a>] ? addrconf_dad_work+0x10a/0x430
[ 6870.600305] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
[ 6870.606732] [<ffffffff8ea93a7a>] ? process_one_work+0x18a/0x430
[ 6870.613449] [<ffffffff8ea93d6d>] ? worker_thread+0x4d/0x490
[ 6870.619778] [<ffffffff8ea93d20>] ? process_one_work+0x430/0x430
[ 6870.626495] [<ffffffff8ea99dd9>] ? kthread+0xd9/0xf0
[ 6870.632145] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
[ 6870.638573] [<ffffffff8ea99d00>] ? kthread_park+0x60/0x60
[ 6870.644707] [<ffffffff8f01ae77>] ? ret_from_fork+0x57/0x70
[ 6870.650936] Code: 31 c0 31 d2 41 b9 20 00 08 02 b9 09 00 00 0

addrconf_dad_work is kicked to be scheduled when a device is brought
up. There is a race between addrcond_dad_work getting scheduled and
taking the rtnl lock and a process taking the link down (under rtnl).
The latter removes the host route from the inet6_addr as part of
addrconf_ifdown which is run for NETDEV_DOWN. The former attempts
to use the host route in ipv6_ifa_notify. If the down event removes
the host route due to the race to the rtnl, then the BUG listed above
occurs.

This scenario does not occur when the ipv6 address is not kept
(net.ipv6.conf.all.keep_addr_on_down = 0) as addrconf_ifdown sets the
state of the ifp to DEAD. Handle when the addresses are kept by checking
IF_READY which is reset by addrconf_ifdown.

The 'dead' flag for an inet6_addr is set only under rtnl, in
addrconf_ifdown and it means the device is getting removed (or IPv6 is
disabled). The interesting cases for changing the idev flag are
addrconf_notify (NETDEV_UP and NETDEV_CHANGE) and addrconf_ifdown
(reset the flag). The former does not have the idev lock - only rtnl;
the latter has both. Based on that the existing dead + IF_READY check
can be moved to right after the rtnl_lock in addrconf_dad_work.

Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
Reported-by: Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index d2968a79abea8..75f520db6a6db 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3974,6 +3974,12 @@ static void addrconf_dad_work(struct work_struct *w)
 
 	rtnl_lock();
 
+	/* check if device was taken down before this delayed work
+	 * function could be canceled
+	 */
+	if (idev->dead || !(idev->if_flags & IF_READY))
+		goto out;
+
 	spin_lock_bh(&ifp->lock);
 	if (ifp->state == INET6_IFADDR_STATE_PREDAD) {
 		action = DAD_BEGIN;
@@ -4019,11 +4025,6 @@ static void addrconf_dad_work(struct work_struct *w)
 		goto out;
 
 	write_lock_bh(&idev->lock);
-	if (idev->dead || !(idev->if_flags & IF_READY)) {
-		write_unlock_bh(&idev->lock);
-		goto out;
-	}
-
 	spin_lock(&ifp->lock);
 	if (ifp->state == INET6_IFADDR_STATE_DEAD) {
 		spin_unlock(&ifp->lock);
-- 
2.20.1

