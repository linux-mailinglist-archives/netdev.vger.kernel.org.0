Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBFFAA365
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 14:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389459AbfIEMna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 08:43:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58414 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389450AbfIEMn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 08:43:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Sep 2019 15:43:23 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x85ChNGZ021437;
        Thu, 5 Sep 2019 15:43:23 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 2/4] devlink: Left justification on FMSG output
Date:   Thu,  5 Sep 2019 15:43:05 +0300
Message-Id: <1567687387-12993-3-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567687387-12993-1-git-send-email-tariqt@mellanox.com>
References: <1567687387-12993-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

FMSG output is dynamic, space separator must be on the left hand side of
the value. Otherwise output has redundant left indentation regardless
the hierarchy.

Before the patch:
 Common config: SQ: stride size: 64 size: 1024
 CQ: stride size: 64 size: 1024
 SQs:
   channel ix: 0 tc: 0 txq ix: 0 sqn: 10 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 6 HW status: 0
   channel ix: 1 tc: 0 txq ix: 1 sqn: 14 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 10 HW status: 0
   channel ix: 2 tc: 0 txq ix: 2 sqn: 18 HW state: 1 stopped: false cc: 5 pc: 5 CQ: cqn: 14 HW status: 0
   channel ix: 3 tc: 0 txq ix: 3 sqn: 22 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 18 HW status: 0

With the patch:
Common config: SQ: stride size: 64 size: 1024
CQ: stride size: 64 size: 1024
SQs:
  channel ix: 0 tc: 0 txq ix: 0 sqn: 10 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 6 HW status: 0
  channel ix: 1 tc: 0 txq ix: 1 sqn: 14 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 10 HW status: 0
  channel ix: 2 tc: 0 txq ix: 2 sqn: 18 HW state: 1 stopped: false cc: 5 pc: 5 CQ: cqn: 14 HW status: 0
  channel ix: 3 tc: 0 txq ix: 3 sqn: 22 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 18 HW status: 0

Fixes: 844a61764c6f ("devlink: Add helper functions for name and value separately")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 devlink/devlink.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index f1b9b2da39d7..1bfc3283a832 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1843,26 +1843,29 @@ static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
 
 static void pr_out_bool_value(struct dl *dl, bool value)
 {
+	__pr_out_indent_newline(dl);
 	if (dl->json_output)
 		jsonw_bool(dl->jw, value);
 	else
-		pr_out(" %s", value ? "true" : "false");
+		pr_out("%s", value ? "true" : "false");
 }
 
 static void pr_out_uint_value(struct dl *dl, unsigned int value)
 {
+	__pr_out_indent_newline(dl);
 	if (dl->json_output)
 		jsonw_uint(dl->jw, value);
 	else
-		pr_out(" %u", value);
+		pr_out("%u", value);
 }
 
 static void pr_out_uint64_value(struct dl *dl, uint64_t value)
 {
+	__pr_out_indent_newline(dl);
 	if (dl->json_output)
 		jsonw_u64(dl->jw, value);
 	else
-		pr_out(" %"PRIu64, value);
+		pr_out("%"PRIu64, value);
 }
 
 static bool is_binary_eol(int i)
@@ -1889,18 +1892,20 @@ static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
 
 static void pr_out_str_value(struct dl *dl, const char *value)
 {
+	__pr_out_indent_newline(dl);
 	if (dl->json_output)
 		jsonw_string(dl->jw, value);
 	else
-		pr_out(" %s", value);
+		pr_out("%s", value);
 }
 
 static void pr_out_name(struct dl *dl, const char *name)
 {
+	__pr_out_indent_newline(dl);
 	if (dl->json_output)
 		jsonw_name(dl->jw, name);
 	else
-		pr_out(" %s:", name);
+		pr_out("%s:", name);
 }
 
 static void pr_out_region_chunk_start(struct dl *dl, uint64_t addr)
-- 
1.8.3.1

