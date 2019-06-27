Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8BF58A19
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfF0Sh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:37:56 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:34158 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfF0Sh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 14:37:56 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 0B026440038;
        Thu, 27 Jun 2019 21:37:37 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2 v2 1/2] devlink: fix format string warning for 32bit targets
Date:   Thu, 27 Jun 2019 21:37:18 +0300
Message-Id: <7a72ae0f9519e6a445d9712399d989fed648e6eb.1561660639.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

32bit targets define uint64_t as long long unsigned. This leads to the
following build warning:

devlink.c: In function ‘pr_out_u64’:
devlink.c:1729:11: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘uint64_t {aka long long unsigned int}’ [-Wformat=]
    pr_out("%s %lu", name, val);
           ^
devlink.c:59:21: note: in definition of macro ‘pr_out’
   fprintf(stdout, ##args);   \
                     ^~~~

Use uint64_t specific conversion specifiers in the format string to fix
that.

Cc: Aya Levin <ayal@mellanox.com>
Cc: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
v2: Use inttypes.h conversion specifiers
---
 devlink/devlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 436935f88bda..b6e68f9a4d65 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1726,9 +1726,9 @@ static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
 		jsonw_u64_field(dl->jw, name, val);
 	} else {
 		if (g_indent_newline)
-			pr_out("%s %lu", name, val);
+			pr_out("%s %"PRIu64, name, val);
 		else
-			pr_out(" %s %lu", name, val);
+			pr_out(" %s %"PRIu64, name, val);
 	}
 }
 
@@ -1753,7 +1753,7 @@ static void pr_out_uint64_value(struct dl *dl, uint64_t value)
 	if (dl->json_output)
 		jsonw_u64(dl->jw, value);
 	else
-		pr_out(" %lu", value);
+		pr_out(" %"PRIu64, value);
 }
 
 static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
-- 
2.20.1

