Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432F3273AE5
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 08:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgIVG2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 02:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728603AbgIVG2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 02:28:39 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA2DC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 23:28:38 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 793C5587431B5; Tue, 22 Sep 2020 08:28:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 753B360DAC6DE;
        Tue, 22 Sep 2020 08:28:37 +0200 (CEST)
Date:   Tue, 22 Sep 2020 08:28:37 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip: do not exit if RTM_GETNSID failed
In-Reply-To: <20200921172232.7c51b6b7@hermes.lan>
Message-ID: <nycvar.YFH.7.78.908.2009220817270.10964@n3.vanv.qr>
References: <20200921235318.14001-1-jengelh@inai.de> <20200921172232.7c51b6b7@hermes.lan>
User-Agent: Alpine 2.23 (LSU 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tuesday 2020-09-22 02:22, Stephen Hemminger wrote:
>Jan Engelhardt <jengelh@inai.de> wrote:
>
>> `ip addr` when run under qemu-user-riscv64, fails. This likely is
>> due to qemu-5.1 not doing translation of RTM_GETNSID calls.
>> 
>> 2: host0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
>>     link/ether 5a:44:da:1a:c4:0b brd ff:ff:ff:ff:ff:ff
>> request send failed: Operation not supported
>> 
>> Treat the situation similar to an absence of procfs.
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
>
>Not a good idea to hide a platform bug in ip command.
>When you do this, you risk creating all sorts of issues for people that
>run ip commands in container environments where the send is rejected (perhaps by SELinux)
>and then things go off into a different failure.

In the very same function you do

  fd = open("/proc/self/ns/net", O_RDONLY);

which equally hides a potential platform bug (namely, forgetting to
mount /proc in a chroot, or in case SELinux was improperly set-up).
Why is this measured two different ways?


From 4222d059c910136f5e2b5c6de96ddaf06828c1d5 Mon Sep 17 00:00:00 2001
From: Jan Engelhardt <jengelh@inai.de>
Date: Tue, 22 Sep 2020 01:41:50 +0200
Subject: [PATCH] ip: add error reporting when RTM_GETNSID failed

`ip addr` when run under qemu-user-riscv64, fails. This likely is
due to qemu-5.1 not doing translation of RTM_GETNSID calls. Aborting
ip completely is the wrong response however. This patch reworks the
error handling.

2: host0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 5a:44:da:1a:c4:0b brd ff:ff:ff:ff:ff:ff
request send failed: Operation not supported

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

