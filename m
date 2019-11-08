Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA579F490B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391719AbfKHMAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:00:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387999AbfKHLnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42F04222C2;
        Fri,  8 Nov 2019 11:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213431;
        bh=RloCVusTu2nmMd+17/acGPUt6gZueL7/1blIIxEjGAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEEnwzFv7wao9AGDZse6BkcqLBuZElcBLKMWrHUj+914GgWOfRFmFaz5jeF8FExu+
         Rue7Mrta1lpTdQrKQ9ASJ7M0XL6/plasdgrDwfsa1HbJME7/wzsnSDbLMyI2KuD2mY
         Lqb6uqcb02zW+uf0yJWq7gsQ8NIayvTUlsYloFFs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 029/103] iwlwifi: mvm: avoid sending too many BARs
Date:   Fri,  8 Nov 2019 06:41:54 -0500
Message-Id: <20191108114310.14363-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 1a19c139be18ed4d6d681049cc48586fae070120 ]

When we receive TX response, we may release a few packets
due to a hole that was closed in the transmission window.

However, if that frame failed, we will mark all the released
frames as failed and will send multiple BARs.

This affects statistics badly, and cause unnecessary frames
transmission.

Instead, mark all the following packets as success, with the
desired result of sending a bar for the failed frame only.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index efef28012a6b9..ac1e05b93a9ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1378,6 +1378,14 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			break;
 		}
 
+		/*
+		 * If we are freeing multiple frames, mark all the frames
+		 * but the first one as acked, since they were acknowledged
+		 * before
+		 * */
+		if (skb_freed > 1)
+			info->flags |= IEEE80211_TX_STAT_ACK;
+
 		iwl_mvm_tx_status_check_trigger(mvm, status);
 
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
-- 
2.20.1

