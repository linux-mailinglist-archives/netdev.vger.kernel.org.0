Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C71747ED08
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 09:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351929AbhLXITi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 03:19:38 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:48406
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235362AbhLXITh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 03:19:37 -0500
Received: from HP-EliteBook-840-G7.. (223-136-216-233.emome-ip.hinet.net [223.136.216.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 3BD0E3F15D;
        Fri, 24 Dec 2021 08:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640333975;
        bh=z4d47WAXt8lxW9JLIGaWJ2E54ayVDgeNLwPy3mvdFmU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=bO4g8OXXisCbls7zT3GAgwL17didHBsIG3yQH9V2eMWeilwCdcyqTw4tqwtHESqTV
         j4JsVeCzA8IlK8s1I3+VGpT063+g+joJt3ASp6JuMwpYL/+9j9f14J5WlrUdcR8Muq
         R2spST8IS0WNFYF/i6CWom4+7W4rAyXd7ACdjjsLh1AeiH76ekYdS8ZfAQimWKRuDX
         nr9uJJF0Jg1J9F5SYJiaJsqfiLIdAPkXtYBEaL8A/TAY8FGbsiAWZwejvREYwoOS48
         /Vh9/L3SvIkzV09pEDse5og2QVPC9apG56GfOXunmWZqHw4/O/BCWz8G266zqif3XE
         YJBArwUb3WJGQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     m.chetan.kumar@intel.com, linuxwwan@intel.com
Cc:     linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: wwan: iosm: Keep device at D0 for s2idle case
Date:   Fri, 24 Dec 2021 16:19:14 +0800
Message-Id: <20211224081914.345292-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211224081914.345292-1-kai.heng.feng@canonical.com>
References: <20211224081914.345292-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are seeing spurious wakeup caused by Intel 7560 WWAN on AMD laptops.
This prevent those laptops to stay in s2idle state.

From what I can understand, the intention of ipc_pcie_suspend() is to
put the device to D3cold, and ipc_pcie_suspend_s2idle() is to keep the
device at D0. However, the device can still be put to D3hot/D3cold by
PCI core.

So explicitly let PCI core know this device should stay at D0, to solve
the spurious wakeup.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index d73894e2a84ed..af1d0e837fe99 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -340,6 +340,9 @@ static int __maybe_unused ipc_pcie_suspend_s2idle(struct iosm_pcie *ipc_pcie)
 
 	ipc_imem_pm_s2idle_sleep(ipc_pcie->imem, true);
 
+	/* Let PCI core know this device should stay at D0 */
+	pci_save_state(ipc_pcie->pci);
+
 	return 0;
 }
 
-- 
2.33.1

