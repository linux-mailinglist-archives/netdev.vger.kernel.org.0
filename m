Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5A3FC678
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKNMo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:44:58 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33961 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726452AbfKNMo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:44:57 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 Nov 2019 14:44:54 +0200
Received: from dev-r-vrt-139.mtr.labs.mlnx (dev-r-vrt-139.mtr.labs.mlnx [10.212.139.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xAECirEJ024546;
        Thu, 14 Nov 2019 14:44:54 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2 v2 5/5] tc: flower: fix output for ip tos and ttl
Date:   Thu, 14 Nov 2019 14:44:41 +0200
Message-Id: <20191114124441.2261-6-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20191114124441.2261-1-roid@mellanox.com>
References: <20191114124441.2261-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Fix the output for ip tos and ttl to be numbers in JSON format.

Example:
$ tc qdisc add dev eth0 ingress
$ tc filter add dev eth0 protocol ip parent ffff: prio 1 flower skip_hw \
      ip_tos 5/0xf action drop

Non JSON format remains the same:
$ tc filter show dev eth0 parent ffff:
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  ip_tos 5/0xf
  skip_hw
  not_in_hw
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1

JSON format is changed (partial output):
$ tc -p -j filter show dev eth0 parent ffff:
Before:
        "options": {
            "keys": {
                "ip_tos": "0x5/f",
                ...
After:
        "options": {
            "keys": {
                "ip_tos": 5,
                "ip_tos_mask": 15,
                ...

Fixes: 6ea2c2b1cff6 ("tc: flower: add support for matching on ip tos and ttl")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/f_flower.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 724577563c27..1b518ef30583 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1617,20 +1617,7 @@ static void flower_print_ip_proto(__u8 *p_ip_proto,
 static void flower_print_ip_attr(const char *name, struct rtattr *key_attr,
 				 struct rtattr *mask_attr)
 {
-	SPRINT_BUF(namefrm);
-	SPRINT_BUF(out);
-	size_t done;
-
-	if (!key_attr)
-		return;
-
-	done = sprintf(out, "0x%x", rta_getattr_u8(key_attr));
-	if (mask_attr)
-		sprintf(out + done, "/%x", rta_getattr_u8(mask_attr));
-
-	print_string(PRINT_FP, NULL, "%s  ", _SL_);
-	sprintf(namefrm, "%s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	print_masked_u8(name, key_attr, mask_attr, true);
 }
 
 static void flower_print_matching_flags(char *name,
-- 
2.8.4

