Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8821E16943C
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgBWCYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:24:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729125AbgBWCYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:24:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DEB822525;
        Sun, 23 Feb 2020 02:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424657;
        bh=+XrCY285HQc7bIPS4L9LWgBFcENdvWmH4USlchC0yfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKCOURZ6LfTpuAnu8WMWJrjSauKh92W9uWaEkNU4JF1guDgB13JNgSP01m3z88mlf
         PheU7OQx9KMUtHe/tOMEkTlXBPwMAiRJLY9F9lKSd1xFvqvmeVj3yHNF+A+HdwbHed
         B56Vfs7/9I0gH+TuhtwWS78K1D0FCr+4Xji55h+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/21] mac80211: consider more elements in parsing CRC
Date:   Sat, 22 Feb 2020 21:23:54 -0500
Message-Id: <20200223022411.2159-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022411.2159-1-sashal@kernel.org>
References: <20200223022411.2159-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a04564c99bb4a92f805a58e56b2d22cc4978f152 ]

We only use the parsing CRC for checking if a beacon changed,
and elements with an ID > 63 cannot be represented in the
filter. Thus, like we did before with WMM and Cisco vendor
elements, just statically add these forgotten items to the
CRC:
 - WLAN_EID_VHT_OPERATION
 - WLAN_EID_OPMODE_NOTIF

I guess that in most cases when VHT/HE operation change, the HT
operation also changed, and so the change was picked up, but we
did notice that pure operating mode notification changes were
ignored.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20200131111300.891737-22-luca@coelho.fi
[restrict to VHT for the mac80211 branch]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 81f120466c38b..cd3cdd1a0b576 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -944,16 +944,22 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 				elem_parse_failed = true;
 			break;
 		case WLAN_EID_VHT_OPERATION:
-			if (elen >= sizeof(struct ieee80211_vht_operation))
+			if (elen >= sizeof(struct ieee80211_vht_operation)) {
 				elems->vht_operation = (void *)pos;
-			else
-				elem_parse_failed = true;
+				if (calc_crc)
+					crc = crc32_be(crc, pos - 2, elen + 2);
+				break;
+			}
+			elem_parse_failed = true;
 			break;
 		case WLAN_EID_OPMODE_NOTIF:
-			if (elen > 0)
+			if (elen > 0) {
 				elems->opmode_notif = pos;
-			else
-				elem_parse_failed = true;
+				if (calc_crc)
+					crc = crc32_be(crc, pos - 2, elen + 2);
+				break;
+			}
+			elem_parse_failed = true;
 			break;
 		case WLAN_EID_MESH_ID:
 			elems->mesh_id = pos;
-- 
2.20.1

