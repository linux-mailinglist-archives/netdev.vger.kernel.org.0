Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EFD32B36F
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449634AbhCCEBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383880AbhCBMcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 07:32:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8027764F25;
        Tue,  2 Mar 2021 11:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686189;
        bh=Lf4E2EbPxFAb0cIRYV4xQxcbHaujRyn/8kT+zabVpNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jydTaEaIb9fF3TqAXdCcOI5Qongd3Ine8UzF2aQxKuLD3poJtxukZCDKPVvIv8Dyv
         1tl+QoMSP1H0vTGm9AZV9GIC3JOMEoQXC3jLqofPH4Pvx+wg9PyGYZ+t4evVRhTdka
         nawsMRPpFUXB5LKWlt8P9vtzlpU3Ob2mRR4OHtPir86vUIqzlFpW7zi5AgRADKbIVq
         s2qb/Nc2B7IpXtcbPcCMicAJWt+apRoN/boYqNRU4etY5uXgDHhmXuyDicno9I1ozQ
         IFwU81dYj1zYRbYQHv2ImtUjMDnIPcP107KUi0mdQD8wKMlW7DbmQrxqsq/yFrTxQW
         FFZTWd8NWS1ow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 42/52] i40e: Fix memory leak in i40e_probe
Date:   Tue,  2 Mar 2021 06:55:23 -0500
Message-Id: <20210302115534.61800-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

[ Upstream commit 58cab46c622d6324e47bd1c533693c94498e4172 ]

Struct i40e_veb is allocated in function i40e_setup_pf_switch, and
stored to an array field veb inside struct i40e_pf. However when
i40e_setup_misc_vector fails, this memory leaks.

Fix this by calling exit and teardown functions.

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1db482d310c2..84916261f5df 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15122,6 +15122,8 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (err) {
 			dev_info(&pdev->dev,
 				 "setup of misc vector failed: %d\n", err);
+			i40e_cloud_filter_exit(pf);
+			i40e_fdir_teardown(pf);
 			goto err_vsis;
 		}
 	}
-- 
2.30.1

