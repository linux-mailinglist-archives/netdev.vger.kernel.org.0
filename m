Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6DD3BCF8B
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbhGFLaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234112AbhGFL05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:26:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0AA461D59;
        Tue,  6 Jul 2021 11:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570396;
        bh=NIpmSb6xWrkUDhVx5Xar84NSlhZVImOx3vM9UEWBHus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cc2v1DJJ0m4XXlFnPRrf1lwvd0jwAtEjbENzwQrgoFOA9crSQifHrFYXd0kkwNUre
         YySBlWcqMrB2kBX+PE/SZHLFDagSCpg4Csy/TLo+LAfgGpJDyGKOY4pnZlFVDvzs8U
         cLNSuRObIP3Zs3oKSRkLbOyZemambWHM4w/zdQigezCpO0043ZniEUuRFjMLlqQ/OC
         ow/g8oJgTwjGdF5m0CeoN2VmoL8i85R8OyPrwSS48YemzrolUQmZ0Lxm3WU8Zmjis4
         2Hu36YKrbMXfFiATYaaEG1qkKMv/jPvvpLzcQOjn7+zGodfCTnU6zv0tdF/9G88Cov
         BNy1HKWSvgraA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liwei Song <liwei.song@windriver.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 067/160] ice: set the value of global config lock timeout longer
Date:   Tue,  6 Jul 2021 07:16:53 -0400
Message-Id: <20210706111827.2060499-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liwei Song <liwei.song@windriver.com>

[ Upstream commit fb3612840d4f587a0af9511a11d7989d1fa48206 ]

It may need hold Global Config Lock a longer time when download DDP
package file, extend the timeout value to 5000ms to ensure that
download can be finished before other AQ command got time to run,
this will fix the issue below when probe the device, 5000ms is a test
value that work with both Backplane and BreakoutCable NVM image:

ice 0000:f4:00.0: VSI 12 failed lan queue config, error ICE_ERR_CFG
ice 0000:f4:00.0: Failed to delete VSI 12 in FW - error: ICE_ERR_AQ_TIMEOUT
ice 0000:f4:00.0: probe failed due to setup PF switch: -12
ice: probe of 0000:f4:00.0 failed with error -12

Signed-off-by: Liwei Song <liwei.song@windriver.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_type.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 266036b7a49a..8a90c47e337d 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -63,7 +63,7 @@ enum ice_aq_res_ids {
 /* FW update timeout definitions are in milliseconds */
 #define ICE_NVM_TIMEOUT			180000
 #define ICE_CHANGE_LOCK_TIMEOUT		1000
-#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	3000
+#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	5000
 
 enum ice_aq_res_access_type {
 	ICE_RES_READ = 1,
-- 
2.30.2

