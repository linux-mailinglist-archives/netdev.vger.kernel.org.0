Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46592A8DA6
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbfIDRZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 13:25:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfIDRZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 13:25:00 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 850B82A09B4;
        Wed,  4 Sep 2019 17:25:00 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B18385C219;
        Wed,  4 Sep 2019 17:24:59 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2] devlink: fix segfault on health command
Date:   Wed,  4 Sep 2019 19:26:14 +0200
Message-Id: <1b981424e70678675af12bc391fbff02625640b8.1567617745.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 04 Sep 2019 17:25:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink segfaults when using grace_period without reporter

$ devlink health set pci/0000:00:09.0 grace_period 3500
Segmentation fault

devlink is instead supposed to gracefully fail printing a warning
message

$ devlink health set pci/0000:00:09.0 grace_period 3500
Reporter's name is expected.

This happens because DL_OPT_HEALTH_REPORTER_NAME and
DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD are both defined as BIT(27).
When dl_opts_put() parse options and grace_period is set, it erroneously
tries to set reporter name to null.

This is fixed simply shifting by 1 bit enumeration starting with
DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD.

Fixes: b18d89195b16 ("devlink: Add devlink health set command")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 devlink/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 91c85dc1de730..0293373928f50 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -231,8 +231,8 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_FLASH_FILE_NAME	BIT(25)
 #define DL_OPT_FLASH_COMPONENT	BIT(26)
 #define DL_OPT_HEALTH_REPORTER_NAME	BIT(27)
-#define DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD	BIT(27)
-#define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(28)
+#define DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD	BIT(28)
+#define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(29)
 
 struct dl_opts {
 	uint32_t present; /* flags of present items */
-- 
2.21.0

