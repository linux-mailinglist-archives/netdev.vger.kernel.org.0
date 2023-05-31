Return-Path: <netdev+bounces-6732-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4F4717AE3
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4D0A281192
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5E5C14E;
	Wed, 31 May 2023 08:58:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D0CBE6E
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F257C4339B;
	Wed, 31 May 2023 08:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685523518;
	bh=HaYbQJNi6y881NqAy/tkhEXGqgb8cgiQ7a1/RH6TbrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKwl+ueYa9OKC0VTzsZZm6QE+TtD+wHKIUCr/INiDLgF9vK6gK8Vasyu9RcSI3gQZ
	 LdtJqjpTS1zuKkZpNXCRo9G8VN8UXcQr4mlVr2eUKYaoou5OrMPDYpAZEjbtdUmKVt
	 2zCOrSE25apXdIFqkxTGpx9DkmYCTp4hGmKQoUOmp7ZCbtcOpzG/HsgrkpQiHtQADx
	 Ow8qtQehHdWoom1OUMwbf28DlkfGWVPmv7xWFRrUeHJMef7gyixk4v6mjUfoh9KdVx
	 XBzNsuWeNTO9es6qJEjFKLBfcxPS8Zh5He0Z4ObGWuO8wBS6+4Ja09/edT+95W6qYv
	 B4BwUqWcWuDtw==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan+linaro@kernel.org>)
	id 1q4HfF-0000jn-Oe; Wed, 31 May 2023 10:58:41 +0200
From: Johan Hovold <johan+linaro@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Johan Hovold <johan+linaro@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND 2/2] Bluetooth: hci_qca: fix debugfs registration
Date: Wed, 31 May 2023 10:57:59 +0200
Message-Id: <20230531085759.2803-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230531085759.2803-1-johan+linaro@kernel.org>
References: <20230531085759.2803-1-johan+linaro@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 3e4be65eb82c ("Bluetooth: hci_qca: Add poweroff support
during hci down for wcn3990"), the setup callback which registers the
debugfs interface can be called multiple times.

This specifically leads to the following error when powering on the
controller:

	debugfs: Directory 'ibs' with parent 'hci0' already present!

Add a driver flag to avoid trying to register the debugfs interface more
than once.

Fixes: 3e4be65eb82c ("Bluetooth: hci_qca: Add poweroff support during hci down for wcn3990")
Cc: stable@vger.kernel.org	# 4.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 1b064504b388..e30c979535b1 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -78,7 +78,8 @@ enum qca_flags {
 	QCA_HW_ERROR_EVENT,
 	QCA_SSR_TRIGGERED,
 	QCA_BT_OFF,
-	QCA_ROM_FW
+	QCA_ROM_FW,
+	QCA_DEBUGFS_CREATED,
 };
 
 enum qca_capabilities {
@@ -635,6 +636,9 @@ static void qca_debugfs_init(struct hci_dev *hdev)
 	if (!hdev->debugfs)
 		return;
 
+	if (test_and_set_bit(QCA_DEBUGFS_CREATED, &qca->flags))
+		return;
+
 	ibs_dir = debugfs_create_dir("ibs", hdev->debugfs);
 
 	/* read only */
-- 
2.39.3


