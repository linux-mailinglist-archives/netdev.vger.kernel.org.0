Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129D213F7D9
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733041AbgAPQze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:55:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgAPQzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F33152467C;
        Thu, 16 Jan 2020 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193731;
        bh=eq4V5fWRWUv3qEIk4JJVlBSpyfCfuRrIIjYJ1RW9xb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrqzuh17heWZLcRbrZSplidfpuKusQH8UV6gya78hxuY0H5LbyzTmPsSZjLYmE0FC
         zJGFcpfxXC91TQZ5YEPVvnFq5kN3j3eRdggS3NK7pYIRjs5ZmbQ9GtnIu5ZQL6QD/X
         yzQnu1SwVY9XeK4AWL2M7w5KfkY2E8WsCGSs+obQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 024/671] cfg80211: regulatory: make initialization more robust
Date:   Thu, 16 Jan 2020 11:44:15 -0500
Message-Id: <20200116165502.8838-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 71e5e886806ee3f8e0c44ed945eb2e4d6659c6e3 ]

Since my change to split out the regulatory init to occur later,
any issues during earlier cfg80211_init() or errors during the
platform device allocation would lead to crashes later. Make this
more robust by checking that the earlier initialization succeeded.

Fixes: d7be102f2945 ("cfg80211: initialize regulatory keys/database later")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 64841238df85..5643bdee7198 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3870,6 +3870,15 @@ static int __init regulatory_init_db(void)
 {
 	int err;
 
+	/*
+	 * It's possible that - due to other bugs/issues - cfg80211
+	 * never called regulatory_init() below, or that it failed;
+	 * in that case, don't try to do any further work here as
+	 * it's doomed to lead to crashes.
+	 */
+	if (IS_ERR_OR_NULL(reg_pdev))
+		return -EINVAL;
+
 	err = load_builtin_regdb_keys();
 	if (err)
 		return err;
-- 
2.20.1

