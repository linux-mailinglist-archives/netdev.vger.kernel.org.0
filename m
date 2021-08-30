Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8843FB51B
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbhH3MBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236839AbhH3MB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71BAC61163;
        Mon, 30 Aug 2021 12:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324822;
        bh=UtKDepxJnKD6aep966SvPGD5FdpgoSt7hPXJeZYRJj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Js/woudnHpe+aauZRGPtZS6e+nbyNSebT4D4LBDRnqSvAecSdncPJKYww9blONq5f
         ZuZb4+Wcm6ggvpoZwTUhkdUf5VgE3A1mwFZ1O7FyPnC5tN975hyQD/k4NSYoRrEbLn
         VunVhxUkWtGsOP9Fc+I7QKVzyma3zyHvae93zKdjHz5P3NFKW55+Vfa5umFBwGbxVn
         PYB++lFUmPtyhwU9Tfxf4DAcUzlTH1M0yQz/EAcij0qJp1RI7//9HY5/DIq+ovB2tp
         j75cp0sXrQhfIrSpYKoNfjc5ss4QfyVXDUWtip8gscFWaAHt7vijuRzBSr2oc7lQOB
         WtVyxA3V0jLEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/10] qed: Fix the VF msix vectors flow
Date:   Mon, 30 Aug 2021 08:00:10 -0400
Message-Id: <20210830120018.1017841-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120018.1017841-1-sashal@kernel.org>
References: <20210830120018.1017841-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

[ Upstream commit b0cd08537db8d2fbb227cdb2e5835209db295a24 ]

For VFs we should return with an error in case we didn't get the exact
number of msix vectors as we requested.
Not doing that will lead to a crash when starting queues for this VF.

Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index bc1f5b36b5bf..1db49424aa43 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -559,7 +559,12 @@ static int qed_enable_msix(struct qed_dev *cdev,
 			rc = cnt;
 	}
 
-	if (rc > 0) {
+	/* For VFs, we should return with an error in case we didn't get the
+	 * exact number of msix vectors as we requested.
+	 * Not doing that will lead to a crash when starting queues for
+	 * this VF.
+	 */
+	if ((IS_PF(cdev) && rc > 0) || (IS_VF(cdev) && rc == cnt)) {
 		/* MSI-x configuration was achieved */
 		int_params->out.int_mode = QED_INT_MODE_MSIX;
 		int_params->out.num_vectors = rc;
-- 
2.30.2

