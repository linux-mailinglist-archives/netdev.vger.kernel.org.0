Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B48AE5B75
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbfJZNXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728544AbfJZNXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:23:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38283222C1;
        Sat, 26 Oct 2019 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096185;
        bh=FwP8bS4J4ZdSMfIHm6NBKtvHy62uX7mA9Aqvaq1WIdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2ZxNmXvyRTElQrKmxxsFSqWYi39dhXzZMAKf8k4LEdCSm6nSD08LwKggoiYdV7J8
         N7CVE6hVOiRESWdJ+Fs/6HOsNpnJmFpJignlVOtaK/oIcER1HPr9kIFNpb0aerkFx/
         mPoz8XabiAkAwnDBjmA/w52zwXsZbhwHPY/XlShA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Vassernis <michael.vassernis@tandemg.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/17] mac80211_hwsim: fix incorrect dev_alloc_name failure goto
Date:   Sat, 26 Oct 2019 09:22:46 -0400
Message-Id: <20191026132302.4622-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132302.4622-1-sashal@kernel.org>
References: <20191026132302.4622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Vassernis <michael.vassernis@tandemg.com>

[ Upstream commit 313c3fe9c2348e7147eca38bb446f295b45403a0 ]

If dev_alloc_name fails, hwsim_mon's memory allocated in alloc_netdev
needs to be freed.
Change goto command in dev_alloc_name failure to out_free_mon in
order to perform free_netdev.

Signed-off-by: Michael Vassernis <michael.vassernis@tandemg.com>
Link: https://lore.kernel.org/r/20191003073049.3760-1-michael.vassernis@tandemg.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0f582117b0e3d..9464beaed37f4 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3294,7 +3294,7 @@ static int __init init_mac80211_hwsim(void)
 	err = dev_alloc_name(hwsim_mon, hwsim_mon->name);
 	if (err < 0) {
 		rtnl_unlock();
-		goto out_free_radios;
+		goto out_free_mon;
 	}
 
 	err = register_netdevice(hwsim_mon);
-- 
2.20.1

