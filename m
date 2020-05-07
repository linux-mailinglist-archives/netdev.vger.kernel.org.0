Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AAC1C870D
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEGKmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725834AbgEGKmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:42:23 -0400
X-Greylist: delayed 577 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 May 2020 03:42:23 PDT
Received: from smail.fem.tu-ilmenau.de (smail.fem.tu-ilmenau.de [IPv6:2001:638:904:ffbf::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AC3C061A10
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 03:42:23 -0700 (PDT)
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id E938A20013;
        Thu,  7 May 2020 12:32:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id A56E06207;
        Thu,  7 May 2020 12:32:41 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TKvELitrPHO1; Thu,  7 May 2020 12:32:38 +0200 (CEST)
Received: from mail-backup.fem.tu-ilmenau.de (mail-backup.net.fem.tu-ilmenau.de [10.42.40.22])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTPS;
        Thu,  7 May 2020 12:32:38 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail-backup.fem.tu-ilmenau.de (Postfix) with ESMTP id 3C36956052;
        Thu,  7 May 2020 12:32:38 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id 1E735306A950; Thu,  7 May 2020 12:32:38 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netdev@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>,
        Li RongQing <roy.qing.li@gmail.com>
Subject: [PATCH] bridge: increase mtu to 64K
Date:   Thu,  7 May 2020 12:32:28 +0200
Message-Id: <aa8b1f36e80728f6fae31d98ba990a2b509b1e34.1588847509.git.michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A linux bridge always adopts the smallest MTU of the enslaved devices.
When no device are enslaved, it defaults to a MTU of 1500 and refuses to
use a larger one. This is problematic when using bridges enslaving only
virtual NICs (vnetX) like it's common with KVM guests.

Steps to reproduce the problem

1) sudo ip link add br-test0 type bridge # create an empty bridge
2) sudo ip link set br-test0 mtu 9000 # attempt to set MTU > 1500
3) ip link show dev br-test0 # confirm MTU

Here, 2) returns "RTNETLINK answers: Invalid argument". One (cumbersome)
way around this is:

4) sudo modprobe dummy
5) sudo ip link set dummy0 mtu 9000 master br-test0

Then the bridge's MTU can be changed from anywhere to 9000.

This is especially annoying for the virtualization case because the
KVM's tap driver will by default adopt the bridge's MTU on startup
making it impossible (without the workaround) to use a large MTU on the
guest VMs.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1399064

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
Reported-by: Li RongQing <roy.qing.li@gmail.com>

--
If found https://patchwork.ozlabs.org/project/netdev/patch/1456133351-10292-1-git-send-email-roy.qing.li@gmail.com/
but I am missing any follow up. So here comes a refresh patch that
addresses the issue raised.
---
 net/bridge/br_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 4fe30b182ee7..f14e7d2329bd 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -496,7 +496,7 @@ static int br_mtu_min(const struct net_bridge *br)
 		if (!ret_mtu || ret_mtu > p->dev->mtu)
 			ret_mtu = p->dev->mtu;
 
-	return ret_mtu ? ret_mtu : ETH_DATA_LEN;
+	return ret_mtu ? ret_mtu : (64 * 1024);
 }
 
 void br_mtu_auto_adjust(struct net_bridge *br)
-- 
2.20.1

