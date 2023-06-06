Return-Path: <netdev+bounces-8494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADCA57244DA
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:50:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2233C280FDF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BBA22A9F5;
	Tue,  6 Jun 2023 13:49:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094F62910B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1534C433D2;
	Tue,  6 Jun 2023 13:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686059396;
	bh=yya9EMML1vVI8LwsIr8qVB4Fnb364C2AKwrbjV1/tF0=;
	h=From:Date:Subject:To:Cc:From;
	b=ufEEt6jYpE7CRiCx3VthMsqd8P68JgVNLvbDE7VMb5Zc7J6SX2hWDTRM/p6c29Uud
	 jrVN5ttAMXtqlWdG7ASmeLWv+6Wb2L8KrKA+ZHddWU+mcqHaTVwJveCq4ZcXPQ2kE6
	 eT+acg856BqaLDKEg5rSsV3YsTeiD38UsHZoUN5rvV+onrQwhLw2LgKea2UF51s9m1
	 L0kdhpzAY8z//SxLa+45147cTctvweCvpUq2uJTPFLE4nogHMdtnIOVlN4D9B6NDhB
	 X7JtLE6EAOtgU/rmqJoPz2styftusPhnEUa2mP2XR1/SpHlWOcib0GmSO9fx0nYay5
	 jKxPC7AAMrwGg==
From: Simon Horman <horms@kernel.org>
Date: Tue, 06 Jun 2023 15:49:45 +0200
Subject: [PATCH net-next v2] net: txgbe: Avoid passing uninitialised
 parameter to pci_wake_from_d3()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230605-txgbe-wake-v2-1-82e1f0441c72@kernel.org>
X-B4-Tracking: v=1; b=H4sIAHg5f2QC/22NQQ6CMBBFr2Jm7Zi2IlBX3sOwGGCABjKYtiKGc
 Hcb1i7f/3l5GwT2jgPcTxt4XlxwsyQw5xM0A0nP6NrEYJS5qlzdMK59zfihkTHTtqS2NbYgC0m
 oKTDWnqQZkiLvaUrjy3Pn1qPwBOGIwmuEKj2DC3H23yO96OP/V1k0amTKmyzTRak6+xjZC0+X2
 fdQ7fv+A/CTqhvEAAAA
To: Jakub Kicinski <kuba@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Paolo Abeni <pabeni@redhat.com>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>, 
 Mengyuan Lou <mengyuanlou@net-swift.com>, 
 Dan Carpenter <dan.carpenter@linaro.com>, 
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>, netdev@vger.kernel.org
X-Mailer: b4 0.12.2

txgbe_shutdown() relies on txgbe_dev_shutdown() to initialise
wake by passing it by reference. However, txgbe_dev_shutdown()
doesn't use this parameter at all.

wake is then passed uninitialised by txgbe_dev_shutdown()
to pci_wake_from_d3().

Resolve this problem by:
* Removing the unused parameter from txgbe_dev_shutdown()
* Removing the uninitialised variable wake from txgbe_dev_shutdown()
* Passing false to pci_wake_from_d3() - this assumes that
  although uninitialised wake was in practice false (0).

I'm not sure that this counts as a bug, as I'm not sure that
it manifests in any unwanted behaviour. But in any case, the issue
was introduced by:

  3ce7547e5b71 ("net: txgbe: Add build support for txgbe")

Flagged by Smatch as:

  .../txgbe_main.c:486 txgbe_shutdown() error: uninitialized symbol 'wake'.

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
Changes in v2:
- Correct referenced commit: it self referential in v1
- Add added Reviewed-by tag from Jiawen Wu
- Link to v1: https://lore.kernel.org/r/20230605-txgbe-wake-v1-1-ea6c441780f9@kernel.org
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 0f0d9fa1cde1..cfe47f3d2503 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -457,7 +457,7 @@ static int txgbe_close(struct net_device *netdev)
 	return 0;
 }
 
-static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
+static void txgbe_dev_shutdown(struct pci_dev *pdev)
 {
 	struct wx *wx = pci_get_drvdata(pdev);
 	struct net_device *netdev;
@@ -477,12 +477,10 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 static void txgbe_shutdown(struct pci_dev *pdev)
 {
-	bool wake;
-
-	txgbe_dev_shutdown(pdev, &wake);
+	txgbe_dev_shutdown(pdev);
 
 	if (system_state == SYSTEM_POWER_OFF) {
-		pci_wake_from_d3(pdev, wake);
+		pci_wake_from_d3(pdev, false);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 }


