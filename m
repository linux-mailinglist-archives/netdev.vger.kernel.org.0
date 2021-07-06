Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336633BCE99
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbhGFL0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233934AbhGFLXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:23:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ECB561D01;
        Tue,  6 Jul 2021 11:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570289;
        bh=m3dohVFWiNvNrxgZb3MiEuDyl8NHehKbXvCYfxO7etI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHh77UVJ4uUECyp5T+lSyZAzx2cXToXNEvt7fInk+hk4JW8QWxAfYuGr7XnJqewbV
         TiBsy3D82zxC5nBwKrl67IFVlU0JNMbnDXQlcNmv1R5qpDI+RhN/v0Gv1o6+48bhxe
         JxKtanm6/j/FB68orKX5YtUGgaChK3WeEoh40K91D2WCkip1W6EVUgum5tUuIMXYGQ
         OxVIGTSax9MztyJC5gwcc/WdeVLl4irrs8Hvi/spu5Y3+BDVSlhucDcoPn2lEFct5N
         XX4n4MfwRuByslPWEi/y9LljLqlEcvwRWQJ5deMVVF8Kvytla9Gehe4hf10zamdDte
         HKTNHrFU2WcJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tedd Ho-Jeong An <tedd.an@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 179/189] Bluetooth: mgmt: Fix the command returns garbage parameter value
Date:   Tue,  6 Jul 2021 07:13:59 -0400
Message-Id: <20210706111409.2058071-179-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 425502f1d380..d0c8b8a41914 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4061,6 +4061,8 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
+	memset(&rp, 0, sizeof(rp));
+
 	if (cp->addr.type == BDADDR_BREDR) {
 		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
 							      &cp->addr.bdaddr,
-- 
2.30.2

