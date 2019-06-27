Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF82957853
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfF0AeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbfF0AeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:08 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5766121738;
        Thu, 27 Jun 2019 00:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595647;
        bh=CqGM+weWgCPGBuGa69EzqSAFp37GL7myimy/h9Olkws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryVqoQBpTpT8PYBHtoaqPCw/VGhl+DxLJPhdkhwDCJ6ZEn/GqK6iveWsR83HjA2QW
         HaEGbTQ6HELwPdJ3Y/jZWzHxvpEuo+F1LAnMsACCe0Shx6YAi8XqUUxQ78I9TMvOdk
         oeWPzf2+MlEqgMSJINa/KWoD0wWpVYgzvU2XQ/YU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 66/95] cfg80211: util: fix bit count off by one
Date:   Wed, 26 Jun 2019 20:29:51 -0400
Message-Id: <20190627003021.19867-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 1a473d6092d5d182914bea854ce0b21e6d12519d ]

The bits of Rx MCS Map in VHT capability were enumerated
with index transform - index i -> (i + 1) bit => nss i. BUG!
while it should be -   index i -> (i + 1) bit => (i + 1) nss.

The bug was exposed in commit a53b2a0b1245 ("iwlwifi: mvm: implement VHT
extended NSS support in rs.c"), where iwlwifi started using the
function.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: b0aa75f0b1b2 ("ieee80211: add new VHT capability fields/parsing")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 5a03f38788e7..5ac66a571e33 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1989,7 +1989,7 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 			continue;
 
 		if (supp >= mcs_encoding) {
-			max_vht_nss = i;
+			max_vht_nss = i + 1;
 			break;
 		}
 	}
-- 
2.20.1

