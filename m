Return-Path: <netdev+bounces-8041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E967228AD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:20:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B889281238
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4481DDE6;
	Mon,  5 Jun 2023 14:20:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0861C777
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01611C433D2;
	Mon,  5 Jun 2023 14:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685974844;
	bh=XJKIGYB3oqtb0Y5y8NuCMe2eV9kWk7hV4Eyo0xuuSCc=;
	h=From:Date:Subject:To:Cc:From;
	b=oOHQQZCbzFGsF1ciLgBBibXUP/Cbj1yu+TsNW9NWSsnG7qgoKJz0aAWC0oEkG/NmQ
	 EPTzFlHshAQUsCn9EYBBfAff3hoRhP0K4c5RziMsvOVhXZXZ8rz22cNZbNqOcEnMEp
	 /NxOnkXqmQKe5AzK+kI/vKNp+rXaHw8kiSGaZgqCldGOVDmCD1rasBGqL+6mOq8cU1
	 Rgxg2S5dwQd6ou/EukbWodyCLt9SjC4B+lVyIa87QpAwKqrDt763FcfYvfWIqTbT6N
	 Ljg4RHQQvEPP+Raz7SKmaDhWr0RKT0bo1qU9wJwIa79fEfOJ5TMxJJVAspmWnXGmSc
	 UdPXW0pA4ndUQ==
From: Simon Horman <horms@kernel.org>
Date: Mon, 05 Jun 2023 16:20:28 +0200
Subject: [PATCH net-next] net: txgbe: Avoid passing uninitialised parameter
 to pci_wake_from_d3()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230605-txgbe-wake-v1-1-ea6c441780f9@kernel.org>
X-B4-Tracking: v=1; b=H4sIACvvfWQC/x2NywrCMBAAf6Xs2YU0PuOvFA+bZm0XyypJ1EDpv
 7t4nIFhViichQtcuxUyf6TIUw36XQfjTDoxSjIG7/zendwRa5si45cejIc+XCglH84UwIJIhTF
 m0nG2RN/LYvKV+S7tfxhAuaJyq3Dbth915DG4ewAAAA==
To: Jakub Kicinski <kuba@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Paolo Abeni <pabeni@redhat.com>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>, 
 Mengyuan Lou <mengyuanlou@net-swift.com>, 
 Dan Carpenter <dan.carpenter@linaro.com>, netdev@vger.kernel.org
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

  bbd22f34b47c ("net: txgbe: Avoid passing uninitialised parameter to pci_wake_from_d3()")

Flagged by Smatch as:

  .../txgbe_main.c:486 txgbe_shutdown() error: uninitialized symbol 'wake'.

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
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


