Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F992FAE44
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfKMKOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 05:14:06 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53666 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbfKMKOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 05:14:06 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 13 Nov 2019 12:13:59 +0200
Received: from mtr-vdi-191.wap.labs.mlnx. (mtr-vdi-191.wap.labs.mlnx [10.209.100.28])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xADADwQO009511;
        Wed, 13 Nov 2019 12:13:59 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2 3/5] tc: flower: fix newline prints for ct-mark and ct-zone
Date:   Wed, 13 Nov 2019 12:12:43 +0200
Message-Id: <20191113101245.182025-4-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20191113101245.182025-1-roid@mellanox.com>
References: <20191113101245.182025-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Matches of ct-mark and ct-zone were printed all in the same line. Fix
that so each ct match is printed in a separate line.

Example:
$ tc qdisc add dev eth0 ingress
$ tc filter add dev eth0 protocol ip parent ffff: prio 1 flower skip_hw \
      ct_zone 5 ct_mark 6/0xf action ct commit zone 7 mark 8/0xf drop

Before:
$ tc -s filter show dev eth0 parent ffff:
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4 ct_zone 5 ct_mark 6/0xf
  skip_hw
  not_in_hw
        action order 1: ct commit mark 8/0xf zone 7 drop
         index 1 ref 1 bind 1 installed 31 sec used 31 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

After:
$ tc -s filter show dev eth0 parent ffff:
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  ct_zone 5
  ct_mark 6/0xf
  skip_hw
  not_in_hw
        action order 1: ct commit mark 8/0xf zone 7 drop
         index 1 ref 1 bind 1 installed 108 sec used 108 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

Fixes: c8a494314c40 ("tc: Introduce tc ct action")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/f_flower.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 41b81217e47e..724577563c27 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1847,13 +1847,13 @@ static void flower_print_ct_label(struct rtattr *attr,
 static void flower_print_ct_zone(struct rtattr *attr,
 				 struct rtattr *mask_attr)
 {
-	print_masked_u16("ct_zone", attr, mask_attr, false);
+	print_masked_u16("ct_zone", attr, mask_attr, true);
 }
 
 static void flower_print_ct_mark(struct rtattr *attr,
 				 struct rtattr *mask_attr)
 {
-	print_masked_u32("ct_mark", attr, mask_attr, false);
+	print_masked_u32("ct_mark", attr, mask_attr, true);
 }
 
 static void flower_print_key_id(const char *name, struct rtattr *attr)
-- 
2.8.4

