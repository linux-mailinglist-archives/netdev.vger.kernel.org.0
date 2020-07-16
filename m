Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC0E221B8D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgGPEto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgGPEto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:49:44 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B693C061755;
        Wed, 15 Jul 2020 21:49:44 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id e13so4403368qkg.5;
        Wed, 15 Jul 2020 21:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n811LGQ+Fs+fBe93hqpRgAF7EkTTe3DB3wlxhpthHDw=;
        b=SN1EWsentgIHscCjmZscmE4hUCVQR/1YxFOEaA2X4eJyYCgfDw76RB4yTMxi1W8jHk
         tVP1TH55qedN4ibmS3LTkcIguB97sohxrNr7aJ8i5Skd8MGRMvtbsA4qvfH9yjsoxMY2
         BslrqZzF7cvqBNWz+ym7AASewM3JMVymzxgwMiZiwfLTaEop5kzr3kRal3cbWIwxUFQz
         ED7ZgyiI9scdVeqLvZWEZe/dpojv8rszJv6NRUlGBP7ZaPqLpelGMlvNV+YBESb1h1jk
         qxbatPUQkxME556vz4b9YinXKvUniS8GTOcZLo0Z+/dy3wr7nMOkf6eE4asa3vcI38x0
         Tu9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n811LGQ+Fs+fBe93hqpRgAF7EkTTe3DB3wlxhpthHDw=;
        b=Kut/rofbK8eSKLkVApYjgcIffayywrri3hb2+baK3rq01g7QjCNZJ5J4Uizj99nvkx
         blvk94eg1FVLv2EiRoSpKvrO8WqmqxMlsNqGWKFpf/DGkVS9Xdr8KMJL+UGisNTuBT6V
         5a+wzu+7yofP+ik3VFqQsm4l2bGIdm4fySLOg0QIJX04VUmggGx9SbjqAApVqU+Tbish
         qX6JAEm2w5qJ4ACfQkPSYQ3hm3rHhiKsrQSDlD3MuVH9tWKA2F/118tBvxjXPY8jQd5i
         Lici08hHmzQJgrUq0/abn8aWJ+Ni6qXYR8//gGo7fXkVTQBHEGXJH8BQ1a5d6drSzvWP
         wTtw==
X-Gm-Message-State: AOAM531JHzBS4e7IfYEKz8G5quFowDArR535AMZq2djZ56fbGI2/otAJ
        Tbhk4NJIcrY3DrTmqQT3r35Kkdu17Zk=
X-Google-Smtp-Source: ABdhPJxBhHumFvG6aGwTPxpSidimNXkf7fv044wp4/GTzx2Yec4tK844YQU6nCh0L0QPTxx2qBsEow==
X-Received: by 2002:a05:620a:91b:: with SMTP id v27mr2143475qkv.499.1594874983094;
        Wed, 15 Jul 2020 21:49:43 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id 16sm5606381qkn.106.2020.07.15.21.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 21:49:42 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] igc: Do not use link uninitialized in igc_check_for_copper_link
Date:   Wed, 15 Jul 2020 21:49:34 -0700
Message-Id: <20200716044934.152364-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/ethernet/intel/igc/igc_mac.c:374:6: warning: variable 'link'
is used uninitialized whenever 'if' condition is true
[-Wsometimes-uninitialized]
        if (!mac->get_link_status) {
            ^~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/intel/igc/igc_mac.c:424:33: note: uninitialized use
occurs here
        ret_val = igc_set_ltr_i225(hw, link);
                                       ^~~~
drivers/net/ethernet/intel/igc/igc_mac.c:374:2: note: remove the 'if' if
its condition is always false
        if (!mac->get_link_status) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/intel/igc/igc_mac.c:367:11: note: initialize the
variable 'link' to silence this warning
        bool link;
                 ^
                  = 0
1 warning generated.

It is not wrong, link is only uninitialized after this through
igc_phy_has_link. Presumably, if we skip the majority of this function
when get_link_status is false, we should skip calling igc_set_ltr_i225
as well. Just directly return 0 in this case, rather than bothering with
adding another label or initializing link in the if statement.

Fixes: 707abf069548 ("igc: Add initial LTR support")
Link: https://github.com/ClangBuiltLinux/linux/issues/1095
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index b47e7b0a6398..26e3c56a4a8b 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -371,10 +371,8 @@ s32 igc_check_for_copper_link(struct igc_hw *hw)
 	 * get_link_status flag is set upon receiving a Link Status
 	 * Change or Rx Sequence Error interrupt.
 	 */
-	if (!mac->get_link_status) {
-		ret_val = 0;
-		goto out;
-	}
+	if (!mac->get_link_status)
+		return 0;
 
 	/* First we want to see if the MII Status Register reports
 	 * link.  If so, then we want to get the current speed/duplex

base-commit: ca0e494af5edb59002665bf12871e94b4163a257
-- 
2.28.0.rc0

