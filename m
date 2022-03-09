Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91DBF4D362A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbiCIQga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbiCIQ1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:27:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EEA289A0;
        Wed,  9 Mar 2022 08:22:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9052B81EE7;
        Wed,  9 Mar 2022 16:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D271AC340F3;
        Wed,  9 Mar 2022 16:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842957;
        bh=LHKATBomQ6ACtfJjG+YFvVAXAGjmKFmdhJSOLfP3MmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mppyaOvV4/JUsE/osAdLx3Eiy/OahdPQJEhvQbm5UtvNrWkPlE7ZqA2ETfe7WDFcB
         YoCzRcslhMqYjvTEItRWXhUKiwaPVOUdcvhLHu4Q+Icmtl/+VZKVoh1eEOyUmDXnYs
         QnWc3UkMkdNaOyr5uG7lfpIT4+M7U6x1s6x0/4WTanXhm2pjgD/m7qq1vOUdXLbvHu
         E10G2ugZZuJV15EWaYUd3A9QvU5aZLBeKX4vCAkZA+B51QMx907tvDooDdLcr47lu8
         suORkDUQn3AO/B1rraJq3ieo/A8WK8c0uNfcKVA40sStjBTBQLDSgWSCEbT/DlqJWW
         As/kzI4RHBCPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/20] mac80211: refuse aggregations sessions before authorized
Date:   Wed,  9 Mar 2022 11:21:46 -0500
Message-Id: <20220309162158.136467-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162158.136467-1-sashal@kernel.org>
References: <20220309162158.136467-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a6bce78262f5dd4b50510f0aa47f3995f7b185f3 ]

If an MFP station isn't authorized, the receiver will (or
at least should) drop the action frame since it's a robust
management frame, but if we're not authorized we haven't
installed keys yet. Refuse attempts to start a session as
they'd just time out.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20220203201528.ff4d5679dce9.I34bb1f2bc341e161af2d6faf74f91b332ba11285@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-tx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 190f300d8923..4b4ab1961068 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -9,7 +9,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2021 Intel Corporation
+ * Copyright (C) 2018 - 2022 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -626,6 +626,14 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		return -EINVAL;
 	}
 
+	if (test_sta_flag(sta, WLAN_STA_MFP) &&
+	    !test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
+		ht_dbg(sdata,
+		       "MFP STA not authorized - deny BA session request %pM tid %d\n",
+		       sta->sta.addr, tid);
+		return -EINVAL;
+	}
+
 	/*
 	 * 802.11n-2009 11.5.1.1: If the initiating STA is an HT STA, is a
 	 * member of an IBSS, and has no other existing Block Ack agreement
-- 
2.34.1

