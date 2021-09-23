Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6A84164F9
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 20:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242886AbhIWSPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 14:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242711AbhIWSOv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 14:14:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B13F61211;
        Thu, 23 Sep 2021 18:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632420799;
        bh=jwrL23NbCo2fsm514Iz5xIfaNN+I2B1pwpVoLvCR6TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqK4EjhPz3dvY3xJm/awyd9QJ6c+1DSwBOJp8FO+vKbRtw3RaEgqoqjr/tan5lpfk
         rIJdAf0U0FDjGvaZfpV5+OimJrS7e9+vyi/ZFl9fvlscuHKGEEXDYR7aiu9vqMj0+7
         aioSEAu1XkXpaAZ3Me++nEoAJs9I3XndjgG1LER+QZYQm7dJy8GDLF/0O4GHgRUZWb
         L5oHsMkRgRoQSgsFUoaJBQxuORLgjWHsr1INekH1rC9Bu0oB6w3MvvuZUaxid6AFRT
         GrCWLfysdWtvDS+ihvjy3w1pnlwv1uvSoV0CrVqRJCYxICLvYYkTwB01cLXwlvNKls
         3aWJocAOiUBUw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev@vger.kernel.org, Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 5/6] ice: Delete always true check of PF pointer
Date:   Thu, 23 Sep 2021 21:12:52 +0300
Message-Id: <1e19cd378b76b891acd4cff122b622fdb0f99ed0.1632420431.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632420430.git.leonro@nvidia.com>
References: <cover.1632420430.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

PF pointer is always valid when PCI core calls its .shutdown() and
.remove() callbacks. There is no need to check it again.

Fixes: 837f08fdecbe ("ice: Add basic driver framework for Intel(R) E800 Series")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 34e64533026a..aacc0b345bbe 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4593,9 +4593,6 @@ static void ice_remove(struct pci_dev *pdev)
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 	int i;
 
-	if (!pf)
-		return;
-
 	for (i = 0; i < ICE_MAX_RESET_WAIT; i++) {
 		if (!ice_is_reset_in_progress(pf->state))
 			break;
-- 
2.31.1

