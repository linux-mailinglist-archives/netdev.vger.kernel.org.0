Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 298707AB16
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbfG3OcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:32:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40348 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbfG3OcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:32:09 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hsTAc-0005LT-6L; Tue, 30 Jul 2019 14:32:06 +0000
From:   Colin King <colin.king@canonical.com>
To:     John Crispin <john@phrozen.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][net-next] mac80211: add missing null return check from call to ieee80211_get_sband
Date:   Tue, 30 Jul 2019 15:32:05 +0100
Message-Id: <20190730143205.14261-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The return from ieee80211_get_sband can potentially be a null pointer, so
it seems prudent to add a null check to avoid a null pointer dereference
on sband.

Addresses-Coverity: ("Dereference null return")
Fixes: 2ab45876756f ("mac80211: add support for the ADDBA extension element")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/mac80211/agg-rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 0e1bb43973b8..4d1c335e06e5 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -189,6 +189,8 @@ static void ieee80211_add_addbaext(struct ieee80211_sub_if_data *sdata,
 	u8 *pos;
 
 	sband = ieee80211_get_sband(sdata);
+	if (!sband)
+		return;
 	he_cap = ieee80211_get_he_iftype_cap(sband, sdata->vif.type);
 	if (!he_cap)
 		return;
-- 
2.20.1

