Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E243C3BD1EA
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbhGFLkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236800AbhGFLfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB99561E44;
        Tue,  6 Jul 2021 11:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570661;
        bh=3Fs+gAv7AGiLCzxSOVAnIumXX4vXQB1F0+AeoQ2SAyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2GRe4xg/tQZkvfxWOrEMhPAd3vN4UDEXNHWTRAYL52DiZL6KeJtQwJ564msuglYp
         J4YJmvYrXZpxYE2m61Fw2uFuAZEheh3ExVhctEE9QE5yuGGcKO+P/SOvtqd/B0X40L
         8iaYhuUSZagGeT2PpXPchVScztJrFrB/PhuJg4mDtPjFsdgkSnNd5+Eax6QSo0xC8I
         pUVXu1/QLux4eWwo1EVuiLC/QnprlpktAJiWx+ei9uZ7HOpG7zuYXk9G/7Nzt3lzou
         dm6mNT/JuxMAawFCcE3JCbohXzEPpKS5mTBCYx/Mf+algFlNm/5qtloOZvh1fDHQFE
         tqvaL95DWClEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 106/137] iwlwifi: mvm: fix error print when session protection ends
Date:   Tue,  6 Jul 2021 07:21:32 -0400
Message-Id: <20210706112203.2062605-106-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index 3939eccd3d5a..394598b14a17 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -345,6 +345,8 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 			 * and know the dtim period.
 			 */
 			iwl_mvm_te_check_disconnect(mvm, te_data->vif,
+				!te_data->vif->bss_conf.assoc ?
+				"Not associated and the time event is over already..." :
 				"No beacon heard and the time event is over already...");
 			break;
 		default:
@@ -843,6 +845,8 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
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

