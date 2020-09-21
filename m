Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D092736EB
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgIUXxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgIUXxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:53:21 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ABAC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 16:53:21 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id C7644589A3B0D; Tue, 22 Sep 2020 01:53:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on a3.inai.de
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 9E97B589A3B0B;
        Tue, 22 Sep 2020 01:53:18 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] ip: do not exit if RTM_GETNSID failed
Date:   Tue, 22 Sep 2020 01:53:18 +0200
Message-Id: <20200921235318.14001-1-jengelh@inai.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`ip addr` when run under qemu-user-riscv64, fails. This likely is
due to qemu-5.1 not doing translation of RTM_GETNSID calls.

2: host0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 5a:44:da:1a:c4:0b brd ff:ff:ff:ff:ff:ff
request send failed: Operation not supported

Treat the situation similar to an absence of procfs.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 ip/ipnetns.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 46cc235b..8fab51cd 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -85,8 +85,9 @@ static int ipnetns_have_nsid(void)
 		addattr32(&req.n, 1024, NETNSA_FD, fd);
 
 		if (rtnl_send(&rth, &req.n, req.n.nlmsg_len) < 0) {
-			perror("request send failed");
-			exit(1);
+			have_rtnl_getnsid = 0;
+			close(fd);
+			return 0;
 		}
 		rtnl_listen(&rth, ipnetns_accept_msg, NULL);
 		close(fd);
-- 
2.28.0

