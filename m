Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6679B15907
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfEGFdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbfEGFdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:33:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30983214AE;
        Tue,  7 May 2019 05:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207185;
        bh=YlQuGwAHeK0mc4QWtXD6WY/m1BDOpX0GZj6Qku8Z/b0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFBADaETzztdCDi0ppaxZWhNf/UvstOPYfg4T4svcsBn9V9hwj0UyBizLsNB31A23
         fJl1nzc07ks9F2B6MnTAgsCvpoV6KS+/RPmwzDoTLxxVfMFWZCjrfAZEyrCpvZ7l9r
         F3Gdbk4j8r8/s8uQZGzhI/mKElt09FHnegzpySNM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Wetzel <alexander@wetzel-home.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 20/99] mac80211: Honor SW_CRYPTO_CONTROL for unicast keys in AP VLAN mode
Date:   Tue,  7 May 2019 01:31:14 -0400
Message-Id: <20190507053235.29900-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Wetzel <alexander@wetzel-home.de>

[ Upstream commit 78ad2341521d5ea96cb936244ed4c4c4ef9ec13b ]

Restore SW_CRYPTO_CONTROL operation on AP_VLAN interfaces for unicast
keys, the original override was intended to be done for group keys as
those are treated specially by mac80211 and would always have been
rejected.

Now the situation is that AP_VLAN support must be enabled by the driver
if it can support it (meaning it can support software crypto GTK TX).

Thus, also simplify the code - if we get here with AP_VLAN and non-
pairwise key, software crypto must be used (driver doesn't know about
the interface) and can be used (driver must've advertised AP_VLAN if
it also uses SW_CRYPTO_CONTROL).

Fixes: db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on crypto controlled devices")
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
[rewrite commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/key.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 4700718e010f..37e372896230 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -167,8 +167,10 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		 * The driver doesn't know anything about VLAN interfaces.
 		 * Hence, don't send GTKs for VLAN interfaces to the driver.
 		 */
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+			ret = 1;
 			goto out_unsupported;
+		}
 	}
 
 	ret = drv_set_key(key->local, SET_KEY, sdata,
@@ -213,11 +215,8 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
 			return 0;
-		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL)) {
-			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-				return 0;
+		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL))
 			return -EINVAL;
-		}
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.20.1

