Return-Path: <netdev+bounces-7157-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D350471EED5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E4AA281833
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC38B42516;
	Thu,  1 Jun 2023 16:26:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAF322D6B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:26:39 +0000 (UTC)
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86A5138;
	Thu,  1 Jun 2023 09:26:37 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.101.196.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 134EE412AF;
	Thu,  1 Jun 2023 16:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1685636793;
	bh=axcyh+az/BBUzfpbsUua0mK6zDrWRXBjvxehcafqRw0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=OFimkuWyFYRWSftA8jYcAl0tzkUQMW8d9D2Di/kyZMDMGb/0yzUZm6XoA80b9RKjo
	 V2CFYG7zcW6O4GODt8uS55uXsWBYTRWaoz4pGBIET/WzX/6F9xWE1GJy3xOjZUdqwU
	 bPmUmBHaCFwCJX6P7liZg01oCEpaAH96jmojFEvdvWiQS+9QRMtFvB15pVsue1V5CH
	 nslXHWysanmAVO94TD+UABba+vrZi/63UDytkFWfCpzkNczYDSYV8hXeBMvWCoTsR8
	 PDNTQxDEvP5Z3t3tFzrzVhAA9rOQOu9+1jqInDnvTV0c6tKdJ3TOJoGlWUkCivqoIO
	 C9mF8P1+72JcA==
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
To: jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com
Cc: linux-pm@vger.kernel.org,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] e1000e: Use PME poll to circumvent unreliable ACPI wake
Date: Fri,  2 Jun 2023 00:25:37 +0800
Message-Id: <20230601162537.1163270-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On some I219 devices, ethernet cable plugging detection only works once
from PCI D3 state. Subsequent cable plugging does set PME bit correctly,
but device still doesn't get woken up.

Since I219 connects to the root complex directly, it relies on platform
firmware (ACPI) to wake it up. In this case, the GPE from _PRW only
works for first cable plugging but fails to notify the driver for
subsequent plugging events.

The issue was originally found on CNP, but the same issue can be found
on ADL too. So workaround the issue by continuing use PME poll after
first ACPI wake. As PME poll is always used, the runtime suspend
restriction for CNP can also be removed.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index bd7ef59b1f2e..f0e48f2bc3a2 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7021,6 +7021,8 @@ static __maybe_unused int e1000e_pm_runtime_resume(struct device *dev)
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
+	pdev->pme_poll = true;
+
 	rc = __e1000_resume(pdev);
 	if (rc)
 		return rc;
@@ -7682,7 +7684,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_SMART_PREPARE);
 
-	if (pci_dev_run_wake(pdev) && hw->mac.type != e1000_pch_cnp)
+	if (pci_dev_run_wake(pdev))
 		pm_runtime_put_noidle(&pdev->dev);
 
 	return 0;
-- 
2.34.1


