Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6F51A01F3
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgDGABI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgDGABH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA63F2078C;
        Tue,  7 Apr 2020 00:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217666;
        bh=qs75tEfOs2fCsYk39M8OgekZWGozE5twqSR4yC7eBIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lk3RsFEMSGM6pW40XdKy8lb3uzIkjVwBmgijaz8k+kdGfw9Q/UCYNfXbg+r6nYxEF
         ZCq0kyEzDjjAQv97ok0ddUm/X15emrjR3baEmenCX9T8NE660BdxusVKnj+Kj3AA5w
         r4CcmOthPDt1q312PVII/vsoCfmDJ47VpBys/v54=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 06/35] iwlwifi: mvm: take the required lock when clearing time event data
Date:   Mon,  6 Apr 2020 20:00:28 -0400
Message-Id: <20200407000058.16423-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 089e5016d7eb063712063670e6da7c1a4de1a5c1 ]

When receiving a session protection end notification, the time event
data is cleared without holding the required lock. Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151128.a49846a634e4.Id1ada7c5a964f5e25f4d0eacc2c4b050015b46a2@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index c0b420fe5e48f..1babc4bb5194b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -785,7 +785,9 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 		if (!le32_to_cpu(notif->status)) {
 			iwl_mvm_te_check_disconnect(mvm, vif,
 						    "Session protection failure");
+			spin_lock_bh(&mvm->time_event_lock);
 			iwl_mvm_te_clear_data(mvm, te_data);
+			spin_unlock_bh(&mvm->time_event_lock);
 		}
 
 		if (le32_to_cpu(notif->start)) {
@@ -801,7 +803,9 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 			 */
 			iwl_mvm_te_check_disconnect(mvm, vif,
 						    "No beacon heard and the session protection is over already...");
+			spin_lock_bh(&mvm->time_event_lock);
 			iwl_mvm_te_clear_data(mvm, te_data);
+			spin_unlock_bh(&mvm->time_event_lock);
 		}
 
 		goto out_unlock;
-- 
2.20.1

