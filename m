Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D15B53CD6A
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 18:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344040AbiFCQoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 12:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344039AbiFCQoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 12:44:17 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5447E517DE;
        Fri,  3 Jun 2022 09:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654274656; x=1685810656;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xsNqvl0vWM4js1N6rZvuJ6nvPTp8oPY0FhSTTjdvN+0=;
  b=MDoNLHzlAJSNmi16A00dcPQ140S1oPVucpBjnCHEfRnem9ZdheuXVK5f
   oxXMBP09C/Q6gtQ6WI+JnmYl83UYAQ6OWjVq3f9VfKuQRa2ZPqxH4Wm/h
   baDAg2B0ShOmaiZkHD+wcaJs0LdBsLCgCmfvVP0bgwpdOGFVA3mTsDoi/
   vlVh58a2aPkOcRDQ6lWEg1KDm40bRsIwq5/khpur/22Q54nggyQgbc0zl
   D4kJ4/JG5U/kVb1uoEnuG1Vbu6xeyJSy/kWiM0rY3RQCv1LV+kPzGw8F3
   6KtG3zaPMH4QPCSwnynHPQz19E89jtYcXwqdH4TwqA1U7v7T9Z46SWwpo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10367"; a="258378053"
X-IronPort-AV: E=Sophos;i="5.91,275,1647327600"; 
   d="scan'208";a="258378053"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2022 09:44:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,275,1647327600"; 
   d="scan'208";a="905526826"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 03 Jun 2022 09:44:13 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id BA87CF8; Fri,  3 Jun 2022 19:44:15 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v1 1/2] wireless: ray_cs: Utilize strnlen() in parse_addr()
Date:   Fri,  3 Jun 2022 19:44:13 +0300
Message-Id: <20220603164414.48436-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of doing simple operations and using an additional variable on stack,
utilize strnlen() and reuse len variable.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/ray_cs.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 87e98ab068ed..9ac371d6cd6c 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -1643,31 +1643,29 @@ static void authenticate_timeout(struct timer_list *t)
 /*===========================================================================*/
 static int parse_addr(char *in_str, UCHAR *out)
 {
+	int i, k;
 	int len;
-	int i, j, k;
 	int status;
 
 	if (in_str == NULL)
 		return 0;
-	if ((len = strlen(in_str)) < 2)
+	len = strnlen(in_str, ADDRLEN * 2 + 1) - 1;
+	if (len < 1)
 		return 0;
 	memset(out, 0, ADDRLEN);
 
 	status = 1;
-	j = len - 1;
-	if (j > 12)
-		j = 12;
 	i = 5;
 
-	while (j > 0) {
-		if ((k = hex_to_bin(in_str[j--])) != -1)
+	while (len > 0) {
+		if ((k = hex_to_bin(in_str[len--])) != -1)
 			out[i] = k;
 		else
 			return 0;
 
-		if (j == 0)
+		if (len == 0)
 			break;
-		if ((k = hex_to_bin(in_str[j--])) != -1)
+		if ((k = hex_to_bin(in_str[len--])) != -1)
 			out[i] += k << 4;
 		else
 			return 0;
-- 
2.35.1

