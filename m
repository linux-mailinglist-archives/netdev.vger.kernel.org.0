Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A0EE0D85
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 22:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbfJVUxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 16:53:31 -0400
Received: from cache12.mydevil.net ([128.204.216.223]:21823 "EHLO
        cache12.mydevil.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731476AbfJVUxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 16:53:31 -0400
X-Greylist: delayed 2633 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Oct 2019 16:53:30 EDT
From:   =?UTF-8?q?Micha=C5=82=20=C5=81yszczek?= <michal.lyszczek@bofc.pl>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20=C5=81yszczek?= <michal.lyszczek@bofc.pl>
Subject: [PATCH iproute2] ipnetns: do not check netns NAME when -all is specified
Date:   Tue, 22 Oct 2019 22:09:23 +0200
Message-Id: <20191022200923.17366-1-michal.lyszczek@bofc.pl>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AV-Check: Passed
X-System-Sender: michal.lyszczek@bofc.pl
X-Spam-Flag: NO
X-Spam-Status: NO, score=0.8 required=5.0, tests=(BAYES_50=0.8,
        NO_RELAYS=-0.001, URIBL_BLOCKED=0.001) autolearn=disabled
        version=3.4.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When `-all' argument is specified netns runs cmd on all namespaces
and NAME is not used, but netns nevertheless checks if argv[1] is a
valid namespace name ignoring the fact that argv[1] contains cmd
and not NAME. This results in bug where user cannot specify
absolute path to command.

    # ip -all netns exec /usr/bin/whoami
    Invalid netns name "/usr/bin/whoami"

This forces user to have his command in PATH.

Solution is simply to not validate argv[1] when `-all' argument is
specified.

Signed-off-by: Michał Łyszczek <michal.lyszczek@bofc.pl>
---
 ip/ipnetns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 20110ef0..fc58a04b 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -994,7 +994,7 @@ int do_netns(int argc, char **argv)
 		return netns_list(0, NULL);
 	}
 
-	if (argc > 1 && invalid_name(argv[1])) {
+	if (!do_all && argc > 1 && invalid_name(argv[1])) {
 		fprintf(stderr, "Invalid netns name \"%s\"\n", argv[1]);
 		exit(-1);
 	}
-- 
2.21.0

