Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A54FE5B30
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfJZNVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727682AbfJZNVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:21:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CD16222C1;
        Sat, 26 Oct 2019 13:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096073;
        bh=L9cinPEi7M+i9MwB/krobyiQhUdl5qi4MNEIMRE+Dq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+/1YX9TLVfnruicAXEf/Eq6nRTgK7O2knvzDo8gfDkfpPO7Na0vuiuxR23B/f5eG
         mL7uq8zUbmoWfwi0CD69isubk0zf1qHRPNJl7sr6dnvtrJ7a5LtAkpf1bkSGI/lMV6
         40FPI8XjMEb6yOiuVzUV++Ore/1UmSMk5+wq5T3A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Vassernis <michael.vassernis@tandemg.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/33] mac80211_hwsim: fix incorrect dev_alloc_name failure goto
Date:   Sat, 26 Oct 2019 09:20:39 -0400
Message-Id: <20191026132110.4026-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132110.4026-1-sashal@kernel.org>
References: <20191026132110.4026-1-sashal@kernel.org>
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
index 27224dc264133..e9e2e128125b6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3571,7 +3571,7 @@ static int __init init_mac80211_hwsim(void)
 	err = dev_alloc_name(hwsim_mon, hwsim_mon->name);
 	if (err < 0) {
 		rtnl_unlock();
-		goto out_free_radios;
+		goto out_free_mon;
 	}
 
 	err = register_netdevice(hwsim_mon);
-- 
2.20.1

