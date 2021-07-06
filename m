Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7D63BD00D
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhGFLcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235732AbhGFLaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4F1761DE0;
        Tue,  6 Jul 2021 11:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570508;
        bh=5iEhyJc5jRAZcSJ+jALheu4lO7pONRNTGSkqdl6KHLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlx9ozxnRUJoKUwFtuGuhtJgOcm3bR97mSGryTwMrCzl1y650dvgMS9bOo6CNiktW
         kp4/AAV3d1VfympvfgVTRKbpSTG2fjbtjdLS9oKBv+IJLw8KjZtBesWBHVrLSQFyTJ
         K0Trjj34DeqLm+48zlyYT/ssDj4pmt7exmZl+MMukP0izdNz9X8Nck4v1fEHfXZzIe
         Eriv0O45OApABc5DUTRt51kDN3yqaq0W/ejErSi8QE+VXQw7meavdYVCW8F+2grCcB
         67JJeXTFBSYrScSDSEHclkERfRCPWvST+jqX4MwTj8JX+dwftu9xHR1gfPVl65EvWx
         MheicgiYYCozA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tedd Ho-Jeong An <tedd.an@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 150/160] Bluetooth: mgmt: Fix the command returns garbage parameter value
Date:   Tue,  6 Jul 2021 07:18:16 -0400
Message-Id: <20210706111827.2060499-150-sashal@kernel.org>
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

From: Tedd Ho-Jeong An <tedd.an@intel.com>

[ Upstream commit 02ce2c2c24024aade65a8d91d6a596651eaf2d0a ]

When the Get Device Flags command fails, it returns the error status
with the parameters filled with the garbage values. Although the
parameters are not used, it is better to fill with zero than the random
values.

Signed-off-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 09638b4fc9ac..99f199b97bb2 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4056,6 +4056,8 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
+	memset(&rp, 0, sizeof(rp));
+
 	if (cp->addr.type == BDADDR_BREDR) {
 		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
 							      &cp->addr.bdaddr,
-- 
2.30.2

