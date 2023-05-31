Return-Path: <netdev+bounces-6731-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF926717ADD
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53EC71C20DFA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA74CC12C;
	Wed, 31 May 2023 08:58:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAA61879
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B31EC433EF;
	Wed, 31 May 2023 08:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685523518;
	bh=5iPlGxWeg1puDstJF/Uf9U+q7gbki1LPKTuxWP0fpy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+G5QG4Ewb9mHrkc46gjlJhtJa/w1G/Pc4kDxiv/43CB5dmGDEyIfvdfWgigSrNbO
	 N/P/n3JP8tmQwfDVaEWuINBWDoVn6G8W1hOZHGAvaWFQvCNzejsg0yZWXeVAvCcEO2
	 zqwo+lK7l/caqELIRHKPPL8qPaNsXO5yRjAdoMe91CsvqQx7rkqxTFrb4EkU07FvVG
	 DuEUWfYP1QT+mrVYGS6kA3JskT2PD1R8EWe1vyId0kg4paJd54Q/jx9a87XK+E9xHO
	 3jPdf6yLr2h+mmuXoiQCVKRUudqSFH/ikT32IQRQYATy+VRF4dSNdLlMDlWNnxqm8v
	 /8/LpjfB/aerA==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan+linaro@kernel.org>)
	id 1q4HfF-0000jl-M5; Wed, 31 May 2023 10:58:41 +0200
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
Subject: [PATCH RESEND 1/2] Bluetooth: fix debugfs registration
Date: Wed, 31 May 2023 10:57:58 +0200
Message-Id: <20230531085759.2803-2-johan+linaro@kernel.org>
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

Since commit ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for
unconfigured controllers") the debugfs interface for unconfigured
controllers will be created when the controller is configured.

There is however currently nothing preventing a controller from being
configured multiple time (e.g. setting the device address using btmgmt)
which results in failed attempts to register the already registered
debugfs entries:

	debugfs: File 'features' in directory 'hci0' already present!
	debugfs: File 'manufacturer' in directory 'hci0' already present!
	debugfs: File 'hci_version' in directory 'hci0' already present!
	...
	debugfs: File 'quirk_simultaneous_discovery' in directory 'hci0' already present!

Add a controller flag to avoid trying to register the debugfs interface
more than once.

Fixes: ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for unconfigured controllers")
Cc: stable@vger.kernel.org      # 4.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_sync.c    | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 07df96c47ef4..872dcb91a540 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -350,6 +350,7 @@ enum {
 enum {
 	HCI_SETUP,
 	HCI_CONFIG,
+	HCI_DEBUGFS_CREATED,
 	HCI_AUTO_OFF,
 	HCI_RFKILLED,
 	HCI_MGMT,
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 647a8ce54062..0efc2253265e 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4543,6 +4543,9 @@ static int hci_init_sync(struct hci_dev *hdev)
 	    !hci_dev_test_flag(hdev, HCI_CONFIG))
 		return 0;
 
+	if (hci_dev_test_and_set_flag(hdev, HCI_DEBUGFS_CREATED))
+		return 0;
+
 	hci_debugfs_create_common(hdev);
 
 	if (lmp_bredr_capable(hdev))
-- 
2.39.3


