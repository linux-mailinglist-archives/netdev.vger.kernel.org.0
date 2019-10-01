Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7BC2BB4
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 03:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbfJABdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 21:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfJABdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 21:33:49 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0570D20815;
        Tue,  1 Oct 2019 01:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569893629;
        bh=G3DThRgEYFHM4GdnYQ7LuLK4cKwARD1lQAXhF63pF1k=;
        h=From:To:Cc:Subject:Date:From;
        b=WfwRgqv6KArYYP2m1GFohwA3yQjEFNYH9w1vY3tA+jkO9mO41Q2usbctKLQMUtQ5c
         tP5VdvbHxRaSJRU8OWWQPR8dW/pMU6kF01WSBDwDYUE6Dxz8QD/3EcFiavcEnpkyOV
         /aZ/cOLe5fbPz3GrG1U1U7UIdtG7UwukqN5Cc8eg=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv6: Handle race in addrconf_dad_work
Date:   Mon, 30 Sep 2019 18:37:36 -0700
Message-Id: <20191001013736.25119-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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

Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
Reported-by: Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/addrconf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6a576ff92c39..e2759ef73b03 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4032,6 +4032,12 @@ static void addrconf_dad_work(struct work_struct *w)
 
 	rtnl_lock();
 
+	/* check if device was taken down before this delayed work
+	 * function could be canceled
+	 */
+	if (!(idev->if_flags & IF_READY))
+		goto out;
+
 	spin_lock_bh(&ifp->lock);
 	if (ifp->state == INET6_IFADDR_STATE_PREDAD) {
 		action = DAD_BEGIN;
-- 
2.11.0

