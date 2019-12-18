Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B921124941
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfLRORI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:17:08 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36910 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfLRORG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:17:06 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so1040575plz.4;
        Wed, 18 Dec 2019 06:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L3jQPTQ2R5MiyMCuFQ28/QWm5v0842TnhDYDEhmSL3A=;
        b=AUgHnCwjrq2NwEEG1Av211jYafr70uh5ebuUs9nuRl2qxREry4BoHzgTAYFsMv3wmB
         a5YHGLTtY98yx+j9Q8b0+FfGt3JAt9UXBE5Tc2ZKcoONX9VI2nvpvdLs3RQVZ0ZWg3D/
         wGNTH8LtR+5ExwolcnWmnJPdNKSBdOlHYInW34Z4F1Q+/IjyVPyQbqT6/6epI1U9qcjK
         hIq0wWqyQAIsz3YtV0XUhJMTjyxbmzkECW3oVzbsKmYy5ylphCqEF7EEeRZ5ip1KDtCF
         7fKH461scRZnfR6yLog37fd6vf7hZU9n927npHCGxC1sOUrPpxn197u0alXAG8w6IXUR
         tr8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L3jQPTQ2R5MiyMCuFQ28/QWm5v0842TnhDYDEhmSL3A=;
        b=V/eXzXEvfyC4+NyQrTdwAlkV2OagB+tyo1iBpGNyDeNQ5KKLUYgLxlK4ciOYm4sCsw
         vJJaJYV8exYQzvIxxaNhI58j0Z/7Z6yXie/dsgWrR5lJwUUo6WvJGFVug7AxpxwpPuxV
         H4yNCqXLBKFwLI7dh2haYQOOiwXbIpDl4qlprDoHKDMbBVuiZg1UScT97esbu2+LDvGP
         NrKz/W35LjVgAnrurPLlORTc0SFxjtlHqWhPG0V8THL2PHoG2ShDiGJyPVPhauTz3pij
         fEysX0kuanQZaebyxe5vmdzBXc57iwmm2FG67Ycks2w9u7SL+/QholjXEcPUEh73J7V9
         N6TA==
X-Gm-Message-State: APjAAAXLYeteL9b53VWxaTVVCXUTI8DrmqXwFo98JJsPicpvTpkwMq7O
        k5JEcqRGeNYIGwsLNaFaVk0=
X-Google-Smtp-Source: APXvYqxrumjb/MCyv+nqkhnIWzKh4Ue6ATLhMTvMUn7j3d3USRqbMhKU5djbDU374OD2VrPmFbBudQ==
X-Received: by 2002:a17:90a:a386:: with SMTP id x6mr3205472pjp.116.1576678625582;
        Wed, 18 Dec 2019 06:17:05 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.172])
        by smtp.gmail.com with ESMTPSA id t187sm3546560pfd.21.2019.12.18.06.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:17:05 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     jeffrey.t.kirsher@intel.com, davem@davemloft.net
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: intel: e1000e: fix possible sleep-in-atomic-context bugs in e1000e_get_hw_semaphore()
Date:   Wed, 18 Dec 2019 22:16:56 +0800
Message-Id: <20191218141656.12416-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

drivers/net/ethernet/intel/e1000e/mac.c, 1366: 
	usleep_range in e1000e_get_hw_semaphore
drivers/net/ethernet/intel/e1000e/80003es2lan.c, 322:
	e1000e_get_hw_semaphore in e1000_release_swfw_sync_80003es2lan
drivers/net/ethernet/intel/e1000e/80003es2lan.c, 197:
	e1000_release_swfw_sync_80003es2lan in e1000_release_phy_80003es2lan
drivers/net/ethernet/intel/e1000e/netdev.c, 4883: 
	(FUNC_PTR) e1000_release_phy_80003es2lan in e1000e_update_phy_stats
drivers/net/ethernet/intel/e1000e/netdev.c, 4917:
	e1000e_update_phy_stats in e1000e_update_stats
drivers/net/ethernet/intel/e1000e/netdev.c, 5945: 
	e1000e_update_stats in e1000e_get_stats64
drivers/net/ethernet/intel/e1000e/netdev.c, 5944: 
	spin_lock in e1000e_get_stats64

drivers/net/ethernet/intel/e1000e/mac.c, 1384: 
	usleep_range in e1000e_get_hw_semaphore
drivers/net/ethernet/intel/e1000e/80003es2lan.c, 322:
	e1000e_get_hw_semaphore in e1000_release_swfw_sync_80003es2lan
drivers/net/ethernet/intel/e1000e/80003es2lan.c, 197:
	e1000_release_swfw_sync_80003es2lan in e1000_release_phy_80003es2lan
drivers/net/ethernet/intel/e1000e/netdev.c, 4883: 
	(FUNC_PTR) e1000_release_phy_80003es2lan in e1000e_update_phy_stats
drivers/net/ethernet/intel/e1000e/netdev.c, 4917:
	e1000e_update_phy_stats in e1000e_update_stats
drivers/net/ethernet/intel/e1000e/netdev.c, 5945: 
	e1000e_update_stats in e1000e_get_stats64
drivers/net/ethernet/intel/e1000e/netdev.c, 5944: 
	spin_lock in e1000e_get_stats64

(FUNC_PTR) means a function pointer is called.

To fix these bugs, usleep_range() is replaced with udelay().

These bugs are found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/mac.c b/drivers/net/ethernet/intel/e1000e/mac.c
index e531976f8a67..51512a73fdd0 100644
--- a/drivers/net/ethernet/intel/e1000e/mac.c
+++ b/drivers/net/ethernet/intel/e1000e/mac.c
@@ -1363,7 +1363,7 @@ s32 e1000e_get_hw_semaphore(struct e1000_hw *hw)
 		if (!(swsm & E1000_SWSM_SMBI))
 			break;
 
-		usleep_range(50, 100);
+		udelay(100);
 		i++;
 	}
 
@@ -1381,7 +1381,7 @@ s32 e1000e_get_hw_semaphore(struct e1000_hw *hw)
 		if (er32(SWSM) & E1000_SWSM_SWESMBI)
 			break;
 
-		usleep_range(50, 100);
+		udelay(100);
 	}
 
 	if (i == timeout) {
-- 
2.17.1

