Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E084E2E9BB8
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 18:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbhADRIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 12:08:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbhADRIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 12:08:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609780043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2de/+aI5hpKlvLFsaL1DCMrkMJh+VBZyPlNqnu8zUTI=;
        b=RCx57qhmjY3+xNtTjdihKWPaJSLY8/8zgzbrpV5WMCnIL3E4z02Nfj6yJCcdtwy1cvID84
        vwBiXGdc0DwFEx/JWJYuPZYSCIIcI5yT+jCm8s9I1j3gBdtTInsQ+hmprFvImYOXWMEzOG
        SlXXjV3NHx+qo5Vys6NWFkY6WGYoCdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-AGzmScoiOH6WoGV6VKqzvQ-1; Mon, 04 Jan 2021 12:07:20 -0500
X-MC-Unique: AGzmScoiOH6WoGV6VKqzvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87FF4100F340;
        Mon,  4 Jan 2021 17:07:17 +0000 (UTC)
Received: from x1.localdomain (ovpn-112-167.ams2.redhat.com [10.36.112.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 858C86F921;
        Mon,  4 Jan 2021 17:07:14 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] cfg80211: Fix "suspicious RCU usage in wiphy_apply_custom_regulatory" warning/backtrace
Date:   Mon,  4 Jan 2021 18:07:13 +0100
Message-Id: <20210104170713.66956-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit beee24695157 ("cfg80211: Save the regulatory domain when
setting custom regulatory") adds a get_wiphy_regdom call to
wiphy_apply_custom_regulatory. But as the comment above
wiphy_apply_custom_regulatory says:
"/* Used by drivers prior to wiphy registration */"
this function is used by driver's probe function before the wiphy is
registered and at this point wiphy->regd will typically by NULL and
calling rcu_dereference_rtnl on a NULL pointer causes the following
warning/backtrace:

=============================
WARNING: suspicious RCU usage
5.11.0-rc1+ #19 Tainted: G        W
-----------------------------
net/wireless/reg.c:144 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/2:0/22:
 #0: ffff9a4bc104df38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x1ee/0x570
 #1: ffffb6e94010be78 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: process_one_work+0x1ee/0x570

stack backtrace:
CPU: 2 PID: 22 Comm: kworker/2:0 Tainted: G        W         5.11.0-rc1+ #19
Hardware name: LENOVO 60073/INVALID, BIOS 01WT17WW 08/01/2014
Workqueue: events request_firmware_work_func
Call Trace:
 dump_stack+0x8b/0xb0
 get_wiphy_regdom+0x57/0x60 [cfg80211]
 wiphy_apply_custom_regulatory+0xa0/0xf0 [cfg80211]
 brcmf_cfg80211_attach+0xb02/0x1360 [brcmfmac]
 brcmf_attach+0x189/0x460 [brcmfmac]
 brcmf_sdio_firmware_callback+0x78a/0x8f0 [brcmfmac]
 brcmf_fw_request_done+0x67/0xf0 [brcmfmac]
 request_firmware_work_func+0x3d/0x70
 process_one_work+0x26e/0x570
 worker_thread+0x55/0x3c0
 ? process_one_work+0x570/0x570
 kthread+0x137/0x150
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30

Add a check for wiphy->regd being NULL before calling get_wiphy_regdom
(as is already done in other places) to fix this.

wiphy->regd will likely always be NULL when wiphy_apply_custom_regulatory
gets called, so arguably the tmp = get_wiphy_regdom() and
rcu_free_regdom(tmp) calls should simply be dropped, this patch keeps the
2 calls, to allow drivers to call wiphy_apply_custom_regulatory more then
once if necessary.

Cc: Ilan Peer <ilan.peer@intel.com>
Fixes: beee24695157 ("cfg80211: Save the regulatory domain when setting custom regulator")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 net/wireless/reg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index bb72447ad960..9254b9cbaa21 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2547,7 +2547,7 @@ static void handle_band_custom(struct wiphy *wiphy,
 void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 				   const struct ieee80211_regdomain *regd)
 {
-	const struct ieee80211_regdomain *new_regd, *tmp;
+	const struct ieee80211_regdomain *new_regd, *tmp = NULL;
 	enum nl80211_band band;
 	unsigned int bands_set = 0;
 
@@ -2571,7 +2571,8 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 	if (IS_ERR(new_regd))
 		return;
 
-	tmp = get_wiphy_regdom(wiphy);
+	if (wiphy->regd)
+		tmp = get_wiphy_regdom(wiphy);
 	rcu_assign_pointer(wiphy->regd, new_regd);
 	rcu_free_regdom(tmp);
 }
-- 
2.28.0

