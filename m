Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C17B11FB5C
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfLOVGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:06:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:34526 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726426AbfLOVGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 16:06:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B8F9ACE3;
        Sun, 15 Dec 2019 21:06:10 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 20B17E0404; Sun, 15 Dec 2019 22:06:10 +0100 (CET)
Message-Id: <b924dfca0572f87df953743e1ea26270eb251672.1576443050.git.mkubecek@suse.cz>
In-Reply-To: <cover.1576443050.git.mkubecek@suse.cz>
References: <cover.1576443050.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH iproute2-next 2/2] ip link: show permanent hardware address
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Date:   Sun, 15 Dec 2019 22:06:10 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Display permanent hardware address of an interface in output of
"ip link show" and "ip addr show". To reduce noise, permanent address is
only shown if it is different from current one.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ip/ipaddress.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 964f14df93f0..9415d7682c12 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1011,6 +1011,24 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 						       ifi->ifi_type,
 						       b1, sizeof(b1)));
 		}
+		if (tb[IFLA_PERM_ADDRESS]) {
+			unsigned int len = RTA_PAYLOAD(tb[IFLA_PERM_ADDRESS]);
+
+			if (!tb[IFLA_ADDRESS] ||
+			    RTA_PAYLOAD(tb[IFLA_ADDRESS]) != len ||
+			    memcmp(RTA_DATA(tb[IFLA_PERM_ADDRESS]),
+				   RTA_DATA(tb[IFLA_ADDRESS]), len)) {
+				print_string(PRINT_FP, NULL, " permaddr ", NULL);
+				print_color_string(PRINT_ANY,
+						   COLOR_MAC,
+						   "permaddr",
+						   "%s",
+						   ll_addr_n2a(RTA_DATA(tb[IFLA_PERM_ADDRESS]),
+							       RTA_PAYLOAD(tb[IFLA_PERM_ADDRESS]),
+							       ifi->ifi_type,
+							       b1, sizeof(b1)));
+			}
+		}
 	}
 
 	if (tb[IFLA_LINK_NETNSID]) {
-- 
2.24.1

