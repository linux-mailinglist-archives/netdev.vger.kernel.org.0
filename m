Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AE1491409
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbiARCT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244359AbiARCTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:19:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A3BC061574;
        Mon, 17 Jan 2022 18:19:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17B32612CD;
        Tue, 18 Jan 2022 02:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B12C36AF2;
        Tue, 18 Jan 2022 02:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472390;
        bh=Ye+NvjmveOKmvl6+16nojtYqOUgYxCut3gVhU6p2Vlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCWdC8Ioso/ZaNoG/2TmWYQA6X24XRzPllkIeIBdU8BPin5eJ6t4QF8mlJcT4a5jW
         lDdtCS4a0PKQMyvtftI3X5crDx9rHJa7KmFSHaC6D5yFGLtnDyXJaad4KDBNk1v6SL
         S3yg3euzWaOB4DfNUl76CAJz3mE+PYPm2NXepCGsbNFXGNLPK8ZSRXct9VMDm6HTss
         ut+2gDKc0BzE6YqUV2B+jCNhilty5N0btOldUyLsHrXWUe/1JrbpWTY7El8hBnPIxC
         c1xTRXdQ/B+6Pv81oXpEHxMFPudJcU2ntuav0dKxUZXOUhl0OtP1FnUyxAcNE+BWWU
         a809ddlgW+G7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Archie Pusaka <apusaka@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 005/217] Bluetooth: Fix removing adv when processing cmd complete
Date:   Mon, 17 Jan 2022 21:16:08 -0500
Message-Id: <20220118021940.1942199-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

[ Upstream commit 2128939fe2e771645dd88e1938c27fdf96bd1cd0 ]

If we remove one instance of adv using Set Extended Adv Enable, there
is a possibility of issue occurs when processing the Command Complete
event. Especially, the adv_info might not be found since we already
remove it in hci_req_clear_adv_instance() -> hci_remove_adv_instance().
If that's the case, we will mistakenly proceed to remove all adv
instances instead of just one single instance.

This patch fixes the issue by checking the content of the HCI command
instead of checking whether the adv_info is found.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7d0db1ca12482..41795851949f1 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1326,8 +1326,10 @@ static void hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev,
 					   &conn->le_conn_timeout,
 					   conn->conn_timeout);
 	} else {
-		if (adv) {
-			adv->enabled = false;
+		if (cp->num_of_sets) {
+			if (adv)
+				adv->enabled = false;
+
 			/* If just one instance was disabled check if there are
 			 * any other instance enabled before clearing HCI_LE_ADV
 			 */
-- 
2.34.1

