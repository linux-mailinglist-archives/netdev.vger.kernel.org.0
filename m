Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 896AE10841F
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 17:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKXQD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 11:03:28 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51559 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726765AbfKXQD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 11:03:27 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 24 Nov 2019 18:03:20 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.134.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xAOG3K4v029013;
        Sun, 24 Nov 2019 18:03:20 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id xAOG3KSO028866;
        Sun, 24 Nov 2019 18:03:20 +0200
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id xAOG3DXu028861;
        Sun, 24 Nov 2019 18:03:13 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2] ip: fix oneline output
Date:   Sun, 24 Nov 2019 18:02:38 +0200
Message-Id: <1574611358-28795-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ip tool oneline option should output each record on a single line. While
oneline option is active the variable _SL_ replaces line feeds with the
'\' character. However, at the end of print_linkinfo() the variable _SL_
shouldn't be used, otherwise the whole output is on a single line.

Before this fix:
$ip -o link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode
DEFAULT group default qlen 1000\    link/loopback 00:00:00:00:00:00 brd
00:00:00:00:00:00\2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500
qdisc fq_codel state UP mode DEFAULT group default qlen 1000\
link/ether 52:54:00:60:0a:db brd ff:ff:ff:ff:ff:ff\3: eth1:
<BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode
DEFAULT group default qlen 1000\    link/ether 00:50:56:1b:05:cd brd
ff:ff:ff:ff:ff:ff\

After this fix:
$ip -o link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode
DEFAULT group default qlen 1000\    link/loopback 00:00:00:00:00:00 brd
00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state
UP mode DEFAULT group default qlen 1000\    link/ether 52:54:00:60:0a:db
brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state
UP mode DEFAULT group default qlen 1000\    link/ether 00:50:56:1b:05:cd
brd ff:ff:ff:ff:ff:ff

Fixes: 3aa0e51be64b ("ip: add support for alternative name addition/deletion/list")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 ip/ipaddress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index b72eb7a..da1bc44 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1155,7 +1155,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 		close_json_array(PRINT_JSON, NULL);
 	}
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_string(PRINT_FP, NULL, "%s", "\n");
 	fflush(fp);
 	return 1;
 }
-- 
1.8.2.3

