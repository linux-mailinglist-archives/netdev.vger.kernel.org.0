Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C326F28B8EE
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389613AbgJLN4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389652AbgJLN4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:56:00 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F1C0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:56:00 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id E74AE586342DF; Mon, 12 Oct 2020 15:55:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on a3.inai.de
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 12BD9586342DD;
        Mon, 12 Oct 2020 15:55:56 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     stephen@networkplumber.org
Cc:     jengelh@inai.de, netdev@vger.kernel.org
Subject: [iproute PATCH] ip: add error reporting when RTM_GETNSID failed
Date:   Mon, 12 Oct 2020 15:55:55 +0200
Message-Id: <20201012135555.6071-1-jengelh@inai.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`ip addr` when run under qemu-user-riscv64, fails. This likely is due
to qemu-5.1 not doing translation of RTM_GETNSID calls. Aborting ip
completely is not helpful for the user however. This patch reworks
the error handling.

Before:

rtest:/ # ip a
2: host0@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
request send failed: Operation not supported
    link/ether 46:3f:2d:88:3d:db brd ff:ff:ff:ff:ff:ffrtest:/ #

Afterwards:

rtest:/ # ip a
2: host0@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
rtnl_send(RTM_GETNSID): Operation not supported. Continuing anyway.
    link/ether 46:3f:2d:88:3d:db brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.72.147/28 brd 192.168.72.159 scope global host0
       valid_lft forever preferred_lft forever
    inet6 fe80::443f:2dff:fe88:3ddb/64 scope link
       valid_lft forever preferred_lft forever
rtest:/ #

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 ip/ipnetns.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 46cc235b..e7a45653 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -78,6 +78,8 @@ static int ipnetns_have_nsid(void)
 	if (have_rtnl_getnsid < 0) {
 		fd = open("/proc/self/ns/net", O_RDONLY);
 		if (fd < 0) {
+			fprintf(stderr, "/proc/self/ns/net: %s. "
+				"Continuing anyway.\n", strerror(errno));
 			have_rtnl_getnsid = 0;
 			return 0;
 		}
@@ -85,8 +87,11 @@ static int ipnetns_have_nsid(void)
 		addattr32(&req.n, 1024, NETNSA_FD, fd);
 
 		if (rtnl_send(&rth, &req.n, req.n.nlmsg_len) < 0) {
-			perror("request send failed");
-			exit(1);
+			fprintf(stderr, "rtnl_send(RTM_GETNSID): %s. "
+				"Continuing anyway.\n", strerror(errno));
+			have_rtnl_getnsid = 0;
+			close(fd);
+			return 0;
 		}
 		rtnl_listen(&rth, ipnetns_accept_msg, NULL);
 		close(fd);
-- 
2.28.0

