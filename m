Return-Path: <netdev+bounces-379-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BDEF6F750B
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17E28280F55
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F213213AFE;
	Thu,  4 May 2023 19:45:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A99F13ACE
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFB7C433EF;
	Thu,  4 May 2023 19:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229534;
	bh=HuACdH04/SnLKjru+SlGem+Rq1yUiRQJ7uVm4GqiOps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXd7j9cV1/kKTVQTKpCjPCitBeCZzmrSMm9awBoGKw9HYL1eEsAFmpJ8wWGQsWVsj
	 pi+TphSnuZKIFaLBgMmkX1ynQHrVegJ9KcL+M+Lw0ESzvoHhdMMCJvkFw8Tfg2wxht
	 T1Me6VDFrgpigFQnekeGYHkNHUxwiBsOLbTLvkPECW7Sv5SJubpmXp8lfg50vlz/Ue
	 B71PkLrYJ9oyscjanhSA+Xxl9co6zO+RzoiwcRpdCrY5dtmzc14s5HcR/HgV7le/wC
	 BNaIXlZLwcAppDWpBjNlgxi4tZt97IcJAFK+eyYNv/HL4bI3ina8iUasOW3yRxWjjI
	 qZvX1/fav4HMg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Daniel Gabay <daniel.gabay@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kvalo@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	mukesh.sisodiya@intel.com,
	yaara.baruch@intel.com,
	golan.ben.ami@intel.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 31/53] wifi: iwlwifi: pcie: fix possible NULL pointer dereference
Date: Thu,  4 May 2023 15:43:51 -0400
Message-Id: <20230504194413.3806354-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194413.3806354-1-sashal@kernel.org>
References: <20230504194413.3806354-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel Gabay <daniel.gabay@intel.com>

[ Upstream commit b655b9a9f8467684cfa8906713d33b71ea8c8f54 ]

It is possible that iwl_pci_probe() will fail and free the trans,
then afterwards iwl_pci_remove() will be called and crash by trying
to access trans which is already freed, fix it.

iwlwifi 0000:01:00.0: Detected crf-id 0xa5a5a5a2, cnv-id 0xa5a5a5a2
		      wfpm id 0xa5a5a5a2
iwlwifi 0000:01:00.0: Can't find a correct rfid for crf id 0x5a2
...
BUG: kernel NULL pointer dereference, address: 0000000000000028
...
RIP: 0010:iwl_pci_remove+0x12/0x30 [iwlwifi]
pci_device_remove+0x3e/0xb0
device_release_driver_internal+0x103/0x1f0
driver_detach+0x4c/0x90
bus_remove_driver+0x5c/0xd0
driver_unregister+0x31/0x50
pci_unregister_driver+0x40/0x90
iwl_pci_unregister_driver+0x15/0x20 [iwlwifi]
__exit_compat+0x9/0x98 [iwlwifi]
__x64_sys_delete_module+0x147/0x260

Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230413213309.082f6e21341b.I0db21d7fa9a828d571ca886713bd0b5d0b6e1e5c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 99768d6a60322..49e8a27ecce54 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1699,6 +1699,9 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_trans *trans = pci_get_drvdata(pdev);
 
+	if (!trans)
+		return;
+
 	iwl_drv_stop(trans->drv);
 
 	iwl_trans_pcie_free(trans);
-- 
2.39.2


