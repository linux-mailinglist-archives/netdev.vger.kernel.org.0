Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB1B3BCDBC
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhGFLXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233395AbhGFLUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B1E861C9B;
        Tue,  6 Jul 2021 11:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570253;
        bh=KYy/ZnJwIZOkmYg9gryDdBg5r+MYNCbmlEXTKfQ0oJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QF4ku557jCL8j/eZtPvEr5ZVdmPPk0zD+jtCgBkh/kLHoevLouqTClkycEfHtqwPL
         06Pgt5gm8Etv0RnNDzM9XvjY4LqVs47r0MgxZqiRKIyAqp54PQdIqdolomXaNdhebz
         OXPLW3FJcVt6OIIeuGTUzuTv5rS85XSi82wiiPDvlKEk4/36nEPhHCoPKvuFg9coKG
         gw+ZTa+VlUB0xwTxJxmVYKpfyWK45DNvRb6MXBwBe7goOOg9m229y//kzwwEVJ06wG
         czH/aTo5OpcFLga9iMSWCybUyg2bMxI+S+yAKPujRKT3htjmcd8Epr0iWrD00nVgeh
         ovfsSxoBlNRug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 151/189] iwlwifi: mvm: fix error print when session protection ends
Date:   Tue,  6 Jul 2021 07:13:31 -0400
Message-Id: <20210706111409.2058071-151-sashal@kernel.org>
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

From: Shaul Triebitz <shaul.triebitz@intel.com>

[ Upstream commit 976ac0af7ba2c5424bc305b926c0807d96fdcc83 ]

When the session protection ends and the Driver is not
associated or a beacon was not heard, the Driver
prints "No beacons heard...".
That's confusing for the case where not associated.
Change the print when not associated to "Not associated...".

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210617100544.41a5a5a894fa.I9eabb76e7a3a7f4abbed8f2ef918f1df8e825726@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 83342a6a6d5b..f19081a6f046 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -310,6 +310,8 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 			 * and know the dtim period.
 			 */
 			iwl_mvm_te_check_disconnect(mvm, te_data->vif,
+				!te_data->vif->bss_conf.assoc ?
+				"Not associated and the time event is over already..." :
 				"No beacon heard and the time event is over already...");
 			break;
 		default:
@@ -808,6 +810,8 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 			 * and know the dtim period.
 			 */
 			iwl_mvm_te_check_disconnect(mvm, vif,
+						    !vif->bss_conf.assoc ?
+						    "Not associated and the session protection is over already..." :
 						    "No beacon heard and the session protection is over already...");
 			spin_lock_bh(&mvm->time_event_lock);
 			iwl_mvm_te_clear_data(mvm, te_data);
-- 
2.30.2

