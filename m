Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6F617AB92
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgCEROs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgCEROp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 648CD2465D;
        Thu,  5 Mar 2020 17:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428485;
        bh=fVEhOtjzIRXLblm9Oehoq5s64cEfH6JyaAg+jP4d8oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctNo/RhSeb6zpCeyH+TU+zsEMiuMDc/8nT8oQ7wvX2AH6HuEy6zmZ1JEAboiow2el
         zCSQp7F4iA8npn6SBdjXbxy3HMYqjewBpE0iYgd2NDp1IVJ8og0J8WkyihduXVTXjI
         D8vf/rjU3rbaFpCn6f5JEUlIDPAixER1T7e1hJak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/58] nl80211: fix potential leak in AP start
Date:   Thu,  5 Mar 2020 12:13:41 -0500
Message-Id: <20200305171420.29595-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9951ebfcdf2b97dbb28a5d930458424341e61aa2 ]

If nl80211_parse_he_obss_pd() fails, we leak the previously
allocated ACL memory. Free it in this case.

Fixes: 796e90f42b7e ("cfg80211: add support for parsing OBBS_PD attributes")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200221104142.835aba4cdd14.I1923b55ba9989c57e13978f91f40bfdc45e60cbd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c74646b7a751f..78c2d9359fc72 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4794,8 +4794,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		err = nl80211_parse_he_obss_pd(
 					info->attrs[NL80211_ATTR_HE_OBSS_PD],
 					&params.he_obss_pd);
-		if (err)
-			return err;
+		goto out;
 	}
 
 	nl80211_calculate_ap_params(&params);
@@ -4817,6 +4816,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	}
 	wdev_unlock(wdev);
 
+out:
 	kfree(params.acl);
 
 	return err;
-- 
2.20.1

