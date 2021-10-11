Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0224D428D71
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 14:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbhJKNA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:00:58 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:53416 "EHLO
        smtpservice.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235323AbhJKNA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 09:00:57 -0400
Received: from bretzel (bretzel.dev.6wind.com [10.16.0.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 097B560099;
        Mon, 11 Oct 2021 14:58:56 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mZutL-000228-Uu; Mon, 11 Oct 2021 14:58:55 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2] iplink: enable to specify newifindex when changing netns
Date:   Mon, 11 Oct 2021 14:58:52 +0200
Message-Id: <20211011125852.7805-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an interface is moved to another netns, it's possible to specify a
new ifindex. Let's add this support.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eeb85a14ee34
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 ip/iplink.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 18b2ea25b7c2..80b6615319f4 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -95,7 +95,7 @@ void iplink_usage(void)
 		"		[ address LLADDR ]\n"
 		"		[ broadcast LLADDR ]\n"
 		"		[ mtu MTU ]\n"
-		"		[ netns { PID | NAME } ]\n"
+		"		[ netns { PID | NAME } [ newindex IXD ] ]\n"
 		"		[ link-netns NAME | link-netnsid ID ]\n"
 		"		[ alias NAME ]\n"
 		"		[ vf NUM [ mac LLADDR ]\n"
@@ -590,6 +590,7 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 	int numtxqueues = -1;
 	int numrxqueues = -1;
 	int link_netnsid = -1;
+	int newindex = 0;
 	int index = 0;
 	int group = -1;
 	int addr_len = 0;
@@ -683,6 +684,15 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 					  IFLA_NET_NS_PID, &netns, 4);
 			else
 				invarg("Invalid \"netns\" value\n", *argv);
+		} else if (strcmp(*argv, "newindex") == 0) {
+			NEXT_ARG();
+			if (newindex)
+				duparg("newindex", *argv);
+			newindex = atoi(*argv);
+			if (newindex <= 0)
+				invarg("Invalid \"newindex\" value", *argv);
+			addattr32(&req->n, sizeof(*req), IFLA_NEW_IFINDEX,
+				  newindex);
 		} else if (strcmp(*argv, "multicast") == 0) {
 			NEXT_ARG();
 			req->i.ifi_change |= IFF_MULTICAST;
-- 
2.33.0

