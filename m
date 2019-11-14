Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52254FC67A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKNMo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:44:58 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33963 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726632AbfKNMo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:44:57 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 Nov 2019 14:44:54 +0200
Received: from dev-r-vrt-139.mtr.labs.mlnx (dev-r-vrt-139.mtr.labs.mlnx [10.212.139.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xAECirEI024546;
        Thu, 14 Nov 2019 14:44:54 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2 v2 4/5] tc_util: fix JSON prints for ct-mark and ct-zone
Date:   Thu, 14 Nov 2019 14:44:40 +0200
Message-Id: <20191114124441.2261-5-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20191114124441.2261-1-roid@mellanox.com>
References: <20191114124441.2261-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Fix the output of ct-mark and ct-zone (both for matches and actions) to
be different in JSON/non-JSON mode.

Example:
$ tc qdisc add dev eth0 ingress
$ tc filter add dev eth0 protocol ip parent ffff: prio 1 flower skip_hw \
      ct_zone 5 ct_mark 6/0xf action ct commit zone 7 mark 8/0xf drop

Non JSON format remains the same:
$ tc filter show dev eth0 parent ffff:
$ tc -s filter show dev ens1f0_0 parent ffff:
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

JSON format is changed (partial output):
$ tc -p -j filter show dev eth0 parent ffff:
Before:
        "options": {
            "keys": {
                "ct_zone": "5",
                "ct_mark": "6/0xf"
                ...
        "actions": [ {
                "order": 1,
                "kind": "ct",
                "action": "commit",
                "mark": "8/0xf",
                "zone": "7",
                ...
After:
        "options": {
            "keys": {
                "ct_zone": 5,
                "ct_mark": 6,
                "ct_mark_mask": 15
                ...
        "actions": [ {
                "order": 1,
                "kind": "ct",
                "action": "commit",
                "mark": 8,
                "mark_mask": 15,
                "zone": 7,
                ...

Fixes: c8a494314c40 ("tc: Introduce tc ct action")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/tc_util.c | 41 ++++++++---------------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index e9f3e5a227f9..393721e33bf0 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -958,45 +958,20 @@ static void print_masked_type(__u32 type_max,
 void print_masked_u32(const char *name, struct rtattr *attr,
 		      struct rtattr *mask_attr, bool newline)
 {
-	__u32 value, mask;
-	SPRINT_BUF(namefrm);
-	SPRINT_BUF(out);
-	size_t done;
-
-	if (!attr)
-		return;
-
-	value = rta_getattr_u32(attr);
-	mask = mask_attr ? rta_getattr_u32(mask_attr) : UINT32_MAX;
-
-	done = sprintf(out, "%u", value);
-	if (mask != UINT32_MAX)
-		sprintf(out + done, "/0x%x", mask);
+	print_masked_type(UINT32_MAX, rta_getattr_u32, name, attr, mask_attr,
+			  newline);
+}
 
-	sprintf(namefrm, "%s %s %%s", newline ? "\n " : "", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+static __u32 __rta_getattr_u16_u32(const struct rtattr *attr)
+{
+	return rta_getattr_u16(attr);
 }
 
 void print_masked_u16(const char *name, struct rtattr *attr,
 		      struct rtattr *mask_attr, bool newline)
 {
-	__u16 value, mask;
-	SPRINT_BUF(namefrm);
-	SPRINT_BUF(out);
-	size_t done;
-
-	if (!attr)
-		return;
-
-	value = rta_getattr_u16(attr);
-	mask = mask_attr ? rta_getattr_u16(mask_attr) : UINT16_MAX;
-
-	done = sprintf(out, "%u", value);
-	if (mask != UINT16_MAX)
-		sprintf(out + done, "/0x%x", mask);
-
-	sprintf(namefrm, "%s %s %%s", newline ? "\n " : "", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	print_masked_type(UINT16_MAX, __rta_getattr_u16_u32, name, attr,
+			  mask_attr, newline);
 }
 
 static __u32 __rta_getattr_u8_u32(const struct rtattr *attr)
-- 
2.8.4

