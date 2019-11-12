Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F87F9342
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfKLOw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:52:29 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44332 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727678AbfKLOw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:52:27 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Nov 2019 16:52:21 +0200
Received: from mtr-vdi-191.wap.labs.mlnx. (mtr-vdi-191.wap.labs.mlnx [10.209.100.28])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xACEqKxB020273;
        Tue, 12 Nov 2019 16:52:21 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2-next 6/8] tc: flower: add u16 big endian parse option
Date:   Tue, 12 Nov 2019 16:51:52 +0200
Message-Id: <20191112145154.145289-7-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20191112145154.145289-1-roid@mellanox.com>
References: <20191112145154.145289-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Add u16 big endian parse option as a pre-step towards TCP/UDP/SCTP
ports usage.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/f_flower.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 1b518ef30583..69de6a80735b 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -220,7 +220,7 @@ static int flower_parse_matching_flags(char *str,
 }
 
 static int flower_parse_u16(char *str, int value_type, int mask_type,
-			    struct nlmsghdr *n)
+			    struct nlmsghdr *n, bool be)
 {
 	__u16 value, mask;
 	char *slash;
@@ -239,6 +239,10 @@ static int flower_parse_u16(char *str, int value_type, int mask_type,
 		mask = UINT16_MAX;
 	}
 
+	if (be) {
+		value = htons(value);
+		mask = htons(mask);
+	}
 	addattr16(n, MAX_MSG, value_type, value);
 	addattr16(n, MAX_MSG, mask_type, mask);
 
@@ -284,7 +288,8 @@ static int flower_parse_ct_zone(char *str, struct nlmsghdr *n)
 	return flower_parse_u16(str,
 				TCA_FLOWER_KEY_CT_ZONE,
 				TCA_FLOWER_KEY_CT_ZONE_MASK,
-				n);
+				n,
+				false);
 }
 
 static int flower_parse_ct_labels(char *str, struct nlmsghdr *n)
-- 
2.8.4

