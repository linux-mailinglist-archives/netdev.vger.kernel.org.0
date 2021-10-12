Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627DF42A131
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 11:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhJLJgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 05:36:14 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:51392 "EHLO
        smtpservice.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235518AbhJLJgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 05:36:14 -0400
Received: from bretzel (bretzel.dev.6wind.com [10.16.0.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id A633360047;
        Tue, 12 Oct 2021 11:34:11 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1maEAl-0004m8-JG; Tue, 12 Oct 2021 11:34:11 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2 v2] iplink: enable to specify index when changing netns
Date:   Tue, 12 Oct 2021 11:34:05 +0200
Message-Id: <20211012093405.18302-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011125852.7805-1-nicolas.dichtel@6wind.com>
References: <20211011125852.7805-1-nicolas.dichtel@6wind.com>
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

v1 -> v2:
  reuse index option instead adding a new option

 ip/iplink.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 18b2ea25b7c2..1d2776c3b5c9 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -578,6 +578,7 @@ static int iplink_parse_vf(int vf, int *argcp, char ***argvp,
 
 int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 {
+	bool move_netns = false;
 	char *name = NULL;
 	char *dev = NULL;
 	char *link = NULL;
@@ -683,6 +684,7 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 					  IFLA_NET_NS_PID, &netns, 4);
 			else
 				invarg("Invalid \"netns\" value\n", *argv);
+			move_netns = true;
 		} else if (strcmp(*argv, "multicast") == 0) {
 			NEXT_ARG();
 			req->i.ifi_change |= IFF_MULTICAST;
@@ -980,9 +982,11 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 		}
 	}
 
-	if (!(req->n.nlmsg_flags & NLM_F_CREATE) && index) {
+	if (index &&
+	    (!(req->n.nlmsg_flags & NLM_F_CREATE) &&
+	     !move_netns)) {
 		fprintf(stderr,
-			"index can be used only when creating devices.\n");
+			"index can be used only when creating devices or when moving device to another netns.\n");
 		exit(-1);
 	}
 
@@ -1019,6 +1023,9 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 		/* Not renaming to the same name */
 		if (name == dev)
 			name = NULL;
+
+		if (index)
+			addattr32(&req->n, sizeof(*req), IFLA_NEW_IFINDEX, index);
 	} else {
 		if (name != dev) {
 			fprintf(stderr,
-- 
2.33.0

