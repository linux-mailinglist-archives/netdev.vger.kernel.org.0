Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC99D374085
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhEEQfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234495AbhEEQdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:33:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FB6D613CB;
        Wed,  5 May 2021 16:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232347;
        bh=MXO7lywpyeZqi4VabcZBelWaWHOEX+WMMkhOrrfSQC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZJwtLXxq7uh3trGxljuDT8XPlTLPcfuagJ7PmO3gzufXR1RV0SGaovd0oe6eYmPQ
         BVjCAurrP1tuvgeagk4GvQh4629OvXgElkYlsLerliL362UYlJfX+A7CNbfAxVup6k
         2quixFy5YN1ghmjWMgSZnqJeGpNQDCLmFrxi6S5xkK1VAxQtPtIyEBaOSccijk3vg7
         JKYcSPiH6fB3Rkl5A5uNM7rnKd3omyiOjTTDi0s4zzxmNd/WgiqhS0zXxE9KZd47Ek
         r/cp1UfSnSHrSNLvzUCBcoz7j5ZPaeSai0fFfIuhWU/zobpM/DTeuKIx2jEsr/9xC3
         9R7cinVfwiL5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Winkler <danielwinkler@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 045/116] Bluetooth: Do not set cur_adv_instance in adv param MGMT request
Date:   Wed,  5 May 2021 12:30:13 -0400
Message-Id: <20210505163125.3460440-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index 74971b4bd457..939c6f77fecc 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7976,7 +7976,6 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	hdev->cur_adv_instance = cp->instance;
 	/* Submit request for advertising params if ext adv available */
 	if (ext_adv_capable(hdev)) {
 		hci_req_init(&req, hdev);
-- 
2.30.2

