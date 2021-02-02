Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C14F30C4BB
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhBBQAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:00:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235212AbhBBPMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C07364F80;
        Tue,  2 Feb 2021 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278422;
        bh=X8nsuQJTgoe6gbLnW8ip3eaIYtCcVSr3zvpNLTjzxfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9pVZBb+2T/kqWxEySQHswXOCAnkSJL5nrFpdfHY2rcYjpAMATfvePshP6ZjCh9bB
         yJPUNRgYqOjad9io8QptcTFaU9DzjxR6z8rzE8h/CTUuRQ6CGN/nqz3UHhFv5rheuw
         3Cgzdrw7zehf43UE5FG2hOz04oU+E1OqTlQ9e//nDoM+4FwF/db32ACFaXSiDjnzOg
         SSKTDnAb8iea5MFVsLftShrs5iQLkSQTaHFXYsvDatXN5Zrl5P+IWPDvw6kWmrsSA+
         Bt2ngw6a66osBcCNI/S25brfgi0fGSReeEhKI7zZ2yOWFtuvRzB816Wb+u+fk41BgI
         ucmoSeuNGJUBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/17] iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()
Date:   Tue,  2 Feb 2021 10:06:43 -0500
Message-Id: <20210202150651.1864426-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150651.1864426-1-sashal@kernel.org>
References: <20210202150651.1864426-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5c56d862c749669d45c256f581eac4244be00d4d ]

We need to take the mutex to call iwl_mvm_get_sync_time(), do it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.4bb5ccf881a6.I62973cbb081e80aa5b0447a5c3b9c3251a65cf6b@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index f043eefabb4ec..7b1d2dac6ceb8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -514,7 +514,10 @@ static ssize_t iwl_dbgfs_os_device_timediff_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 	int pos = 0;
 
+	mutex_lock(&mvm->mutex);
 	iwl_mvm_get_sync_time(mvm, &curr_gp2, &curr_os);
+	mutex_unlock(&mvm->mutex);
+
 	do_div(curr_os, NSEC_PER_USEC);
 	diff = curr_os - curr_gp2;
 	pos += scnprintf(buf + pos, bufsz - pos, "diff=%lld\n", diff);
-- 
2.27.0

