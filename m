Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE6F4E35B
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 11:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfFUJVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 05:21:36 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:38060 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfFUJVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 05:21:35 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id CB8692D2EC0;
        Fri, 21 Jun 2019 11:21:33 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1heFjh-0007fO-HF; Fri, 21 Jun 2019 11:21:33 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2] ip monitor: display interfaces from all groups
Date:   Fri, 21 Jun 2019 11:21:32 +0200
Message-Id: <20190621092132.29341-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only interface from group 0 were displayed.

ip monitor calls ipaddr_reset_filter() and there is no reason to not reset
the filter group in this function.

Fixes: c4fdf75d3def ("ip link: fix display of interface groups")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 ip/ipaddress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index b504200bb377..fd79f978435d 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1850,7 +1850,6 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
 	ipaddr_reset_filter(oneline, 0);
 	filter.showqueue = 1;
 	filter.family = preferred_family;
-	filter.group = -1;
 
 	if (action == IPADD_FLUSH) {
 		if (argc <= 0) {
@@ -2107,6 +2106,7 @@ void ipaddr_reset_filter(int oneline, int ifindex)
 	memset(&filter, 0, sizeof(filter));
 	filter.oneline = oneline;
 	filter.ifindex = ifindex;
+	filter.group = -1;
 }
 
 static int default_scope(inet_prefix *lcl)
-- 
2.21.0

