Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBF0374231
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhEEQqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235346AbhEEQny (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:43:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3483361878;
        Wed,  5 May 2021 16:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232514;
        bh=whOO/qEGOEz7yoV6ZAmhRiWRqssU/z4LEZFhx831jh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVq4xfBYgDWzDprwSKXj+ZsSzYb9bol1pvsn7LB+ktJVjgNJwL7bUieWi4vKU8Bz9
         HxlGtOREAJyQGca0pPxR7VfdgJWPqVdHe8Aq1oWqR7MT3wxoR7maxySO9FLN9ZRTXL
         ng/Tw6sFNwJa/GRs7UDwF75tsRGl9GRLZ34O6LCDLLBqYIOuU41AAyxIF85Ynsntma
         qz0G9CAgXgbO51f7sV2Djzo3yobKAUfu0Y/hj2a2c8vjNeTYkZBO0cACULXXhalvDJ
         Y6R6nRP/sIWXI4IOe9jIrFmZRdmU6sQZeWE8Qb9b2QnPLtZeZ4uv7L/g/FO55WmJpq
         ZNonoNZUzfNFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Winkler <danielwinkler@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 042/104] Bluetooth: Do not set cur_adv_instance in adv param MGMT request
Date:   Wed,  5 May 2021 12:33:11 -0400
Message-Id: <20210505163413.3461611-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Winkler <danielwinkler@google.com>

[ Upstream commit b6f1b79deabd32f89adbf24ef7b30f82d029808a ]

We set hdev->cur_adv_instance in the adv param MGMT request to allow the
callback to the hci param request to set the tx power to the correct
instance. Now that the callbacks use the advertising handle from the hci
request (as they should), this workaround is no longer necessary.

Furthermore, this change resolves a race condition that is more
prevalent when using the extended advertising MGMT calls - if
hdev->cur_adv_instance is set in the params request, then when the data
request is called, we believe our new instance is already active. This
treats it as an update and immediately schedules the instance with the
controller, which has a potential race with the software rotation adv
update. By not setting hdev->cur_adv_instance too early, the new
instance is queued as it should be, to be used when the rotation comes
around again.

This change is tested on harrison peak to confirm that it resolves the
race condition on registration, and that there is no regression in
single- and multi-advertising automated tests.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index fa0f7a4a1d2f..01e143c2bbc0 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7768,7 +7768,6 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	hdev->cur_adv_instance = cp->instance;
 	/* Submit request for advertising params if ext adv available */
 	if (ext_adv_capable(hdev)) {
 		hci_req_init(&req, hdev);
-- 
2.30.2

