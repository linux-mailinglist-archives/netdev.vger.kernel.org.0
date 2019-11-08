Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13031F491D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391115AbfKHMA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388777AbfKHLno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF713222C2;
        Fri,  8 Nov 2019 11:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213423;
        bh=eUkZ04H25tcOU3XzyAJgSjCwZ1Hp4q0z9s2RJC9opNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UA51aXhCpSugLVvCwSXMGj4k9SWWVJ4ReQzhGYyAdA80iIqlIeCVZZHAB1bQumCEg
         n8oqalj+GffdkV4kmZIt7KoCmeQ8+D55OO8Nts/ni01/lEjIJnolDctDVltuSRIXLC
         Jx1ZgohPihtdwINR1a+kFmPQXMYPuKc/CHbwMnVQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Patryk=20Ma=C5=82ek?= <patryk.malek@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 025/103] i40e: hold the rtnl lock on clearing interrupt scheme
Date:   Fri,  8 Nov 2019 06:41:50 -0500
Message-Id: <20191108114310.14363-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patryk Małek <patryk.malek@intel.com>

[ Upstream commit 5cba17b14182696d6bb0ec83a1d087933f252241 ]

Hold the rtnl lock when we're clearing interrupt scheme
in i40e_shutdown and in i40e_remove.

Signed-off-by: Patryk Małek <patryk.malek@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 39029a12a2337..aa2b446d6ad0f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11885,6 +11885,7 @@ static void i40e_remove(struct pci_dev *pdev)
 	mutex_destroy(&hw->aq.asq_mutex);
 
 	/* Clear all dynamic memory lists of rings, q_vectors, and VSIs */
+	rtnl_lock();
 	i40e_clear_interrupt_scheme(pf);
 	for (i = 0; i < pf->num_alloc_vsi; i++) {
 		if (pf->vsi[i]) {
@@ -11893,6 +11894,7 @@ static void i40e_remove(struct pci_dev *pdev)
 			pf->vsi[i] = NULL;
 		}
 	}
+	rtnl_unlock();
 
 	for (i = 0; i < I40E_MAX_VEB; i++) {
 		kfree(pf->veb[i]);
@@ -12086,7 +12088,13 @@ static void i40e_shutdown(struct pci_dev *pdev)
 	wr32(hw, I40E_PFPM_WUFC,
 	     (pf->wol_en ? I40E_PFPM_WUFC_MAG_MASK : 0));
 
+	/* Since we're going to destroy queues during the
+	 * i40e_clear_interrupt_scheme() we should hold the RTNL lock for this
+	 * whole section
+	 */
+	rtnl_lock();
 	i40e_clear_interrupt_scheme(pf);
+	rtnl_unlock();
 
 	if (system_state == SYSTEM_POWER_OFF) {
 		pci_wake_from_d3(pdev, pf->wol_en);
-- 
2.20.1

