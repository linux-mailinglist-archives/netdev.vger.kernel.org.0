Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73ECB3BCFCF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbhGFLba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235490AbhGFLaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 296C361DB5;
        Tue,  6 Jul 2021 11:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570472;
        bh=r8kwZdWEjeJQgavL3sZHDfFvoV3qOI6K31qBnTF5WkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOQeOgeVLP7TLPfCeVmWYetDyDhSVu0g/jSWFGYyyUVsknNTrFafhn8rWgdvEGiS5
         oEG0kaHMCtlMN4deVg8k5+CdLSimpZpWSv9tm0inMMglHe9ZZnmp8CW0SfTSA1FLVO
         7eIlqXffrBe6idb7rYBA2JEXfqKj20hPJPW/5GGIhxdj1HBnsBjxRPFLDXkiXPISVQ
         l83JNSA+O4Fc3QYhLPglDSdbn4ZYereKEQ7YAmMjqo/Y5xwDR++14eYjmIVtiVmAt+
         UuSsbNTglzd4BWcsboXUpKiD1kxXvFcE4INXCoI+Gjd01E0Zp4HvvtBzfWNLAz4en8
         qwEAb/Eqi42hA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 123/160] iwlwifi: mvm: fix error print when session protection ends
Date:   Tue,  6 Jul 2021 07:17:49 -0400
Message-Id: <20210706111827.2060499-123-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 0b012f8c9eb2..9a4a1b363254 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -289,6 +289,8 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 			 * and know the dtim period.
 			 */
 			iwl_mvm_te_check_disconnect(mvm, te_data->vif,
+				!te_data->vif->bss_conf.assoc ?
+				"Not associated and the time event is over already..." :
 				"No beacon heard and the time event is over already...");
 			break;
 		default:
@@ -787,6 +789,8 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
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

