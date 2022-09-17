Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63D85BB9CC
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 19:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiIQR6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 13:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIQR6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 13:58:41 -0400
X-Greylist: delayed 462 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 17 Sep 2022 10:58:39 PDT
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F046730549
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 10:58:39 -0700 (PDT)
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
        by mail.parknet.co.jp (Postfix) with ESMTPSA id E62C1205158B;
        Sun, 18 Sep 2022 02:50:55 +0900 (JST)
Received: from devron.myhome.or.jp (foobar@devron.myhome.or.jp [192.168.0.3])
        by ibmpc.myhome.or.jp (8.17.1.9/8.17.1.9/Debian-1) with ESMTPS id 28HHos0B074597
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 18 Sep 2022 02:50:55 +0900
Received: from devron.myhome.or.jp (foobar@localhost [127.0.0.1])
        by devron.myhome.or.jp (8.17.1.9/8.17.1.9/Debian-1) with ESMTPS id 28HHosZh234310
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 18 Sep 2022 02:50:54 +0900
Received: (from hirofumi@localhost)
        by devron.myhome.or.jp (8.17.1.9/8.17.1.9/Submit) id 28HHosqV234309;
        Sun, 18 Sep 2022 02:50:54 +0900
From:   OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] Fix segv on "-r" option if unknown rpc service
Date:   Sun, 18 Sep 2022 02:50:54 +0900
Message-ID: <87tu55q48x.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/29.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In init_service_resolver(), if getrpcbynumber() returned NULL, c->name
is pointing the undefined memory. So "-r" can segv for example.

So this patch uses "rpc.<r_prog>" format like the following if rpc
name is unresolved, instead of segv or raw port number.

	tcp   LISTEN  0  64  0.0.0.0:rpc.100227  0.0.0.0:*

[Or we would be able to set c->name = NULL to use raw port number]

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 misc/ss.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/misc/ss.c b/misc/ss.c
index ff985cd..866e278 100644
--- a/misc/ss.c	2022-08-25 16:22:06.454913793 +0900
+++ b/misc/ss.c	2022-09-18 02:48:24.212779850 +0900
@@ -1596,6 +1596,15 @@ static void init_service_resolver(void)
 		if (rpc) {
 			strncat(prog, rpc->r_name, 128 - strlen(prog));
 			c->name = strdup(prog);
+		} else {
+			const char fmt[] = "%s%u";
+			char *buf = NULL;
+			int len = snprintf(buf, 0, fmt, prog,
+					   rhead->rpcb_map.r_prog);
+			len++;
+			buf = malloc(len);
+			snprintf(buf, len, fmt, prog, rhead->rpcb_map.r_prog);
+			c->name = buf;
 		}
 
 		c->next = rlist;
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
