Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7876957F70F
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 22:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiGXU0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 16:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiGXU0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 16:26:33 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918FCD12C;
        Sun, 24 Jul 2022 13:26:32 -0700 (PDT)
Received: from integral2.. (unknown [125.160.99.33])
        by gnuweeb.org (Postfix) with ESMTPSA id D28FB7E328;
        Sun, 24 Jul 2022 20:26:27 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658694391;
        bh=upcwVnPzO07Kr5AImxs3CXXPqhTn+Mt/d3N1UpRAOdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffMt7dFWpB+2sQge4Rtn4oz/pSB/Ue+lmfVYtRnZWQUtjsW/TTBu/Tyv1cXf1YKvC
         E/u6GY3AhXkV0BZxLJMacwkS4MMjj1cXedFqv/QzoKU/nPR3X+TRmWZPgWNuchgyii
         at7SxYGtU8WxPgCDlH/KTY74dWvdv7lmzuOWO0ro5yinJivn/A8xlpDegiP17coYxk
         vL8NHuAxj7Ov9rLB4fEV85Cdz2hdGkDbMqumWo7OIInbYkkylqfSIE1PN5q6AotxS4
         Zi5ScdOBGJq0iiQbT8It5tCgHjgvhviwVUD+SZ38Dz/lXxsbfdUyUa1fcAxrvxvzLm
         B3uPOrhqXI5tQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        llvm@lists.linux.dev, kbuild-all@lists.01.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`
Date:   Mon, 25 Jul 2022 03:26:18 +0700
Message-Id: <20220724202452.61846-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <202207250332.5ud26AGE-lkp@intel.com>
References: <202207250332.5ud26AGE-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7a4836560a61 changes simple_write_to_buffer() with memdup_user()
but it forgets to change the value to be returned that came from
simple_write_to_buffer() call. It results in the following warning:

  warning: variable 'rc' is uninitialized when used here [-Wuninitialized]
           return rc;
                  ^~

Remove rc variable and just return the passed in length if the
memdup_user() succeeds.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 7a4836560a6198d245d5732e26f94898b12eb760 ("wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()")
Fixes: ff974e4083341383d3dd4079e52ed30f57f376f0 ("wil6210: debugfs interface to send raw WMI command")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index fe84362718de..04d1aa0e2d35 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1010,7 +1010,7 @@ static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
 	void *cmd;
 	int cmdlen = len - sizeof(struct wmi_cmd_hdr);
 	u16 cmdid;
-	int rc, rc1;
+	int rc1;
 
 	if (cmdlen < 0 || *ppos != 0)
 		return -EINVAL;
@@ -1027,7 +1027,7 @@ static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
 
 	wil_info(wil, "0x%04x[%d] -> %d\n", cmdid, cmdlen, rc1);
 
-	return rc;
+	return len;
 }
 
 static const struct file_operations fops_wmi = {

base-commit: 086f67ba21ede199307e78476353bda9ffef982c
-- 
Ammar Faizi

