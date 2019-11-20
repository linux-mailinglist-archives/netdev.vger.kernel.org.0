Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A0B103A45
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbfKTMnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:43:01 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54251 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729908AbfKTMnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:43:00 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Nov 2019 14:42:53 +0200
Received: from dev-r-vrt-139.mtr.labs.mlnx (dev-r-vrt-139.mtr.labs.mlnx [10.212.139.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xAKCgqRC017234;
        Wed, 20 Nov 2019 14:42:53 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2-next 1/3] tc: flower: add u16 big endian parse option
Date:   Wed, 20 Nov 2019 14:42:43 +0200
Message-Id: <20191120124245.3516-2-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20191120124245.3516-1-roid@mellanox.com>
References: <20191120124245.3516-1-roid@mellanox.com>
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

