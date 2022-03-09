Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9F74D3761
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbiCIQfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbiCIQan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:30:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871551637D8;
        Wed,  9 Mar 2022 08:24:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CBE08CE1F9B;
        Wed,  9 Mar 2022 16:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5E8C36AE2;
        Wed,  9 Mar 2022 16:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843054;
        bh=Jfcq61gqf9CXq2ZHuQFRQVZPk1VmB2ZeZedHRCCDDxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtlgg8i96wSDHMOmZ6Q2Sd/LGp3eFDzIJPrtBcznxo/4mGmU32yx1ehDFKKvHE1Al
         u0yfmN0eMAJ564m74bnOb7El4cLNgqeVg5uqEfmId5Djs/NjcuZ3oGMF0MRxoZYBd4
         R6//OqeNdXAOLp3h6XsTk3208pBuNP/d2Dx4eiWhq+ILgraUJxaQdcYQhwQEgFozO3
         s8DhzY6CSxdnR0yWBg/3j22US9d61gjEZE3ooxO7JAbFnTskGYloKfNFQC00rePirS
         RPliwgfNUn8O+qDFyFkz6OXInfCGL00V9FrM9jN3gdwausEs8b70E6lQ0OkMf+TWDj
         SPm9oyPKwuJ6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/19] mac80211: refuse aggregations sessions before authorized
Date:   Wed,  9 Mar 2022 11:23:25 -0500
Message-Id: <20220309162337.136773-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162337.136773-1-sashal@kernel.org>
References: <20220309162337.136773-1-sashal@kernel.org>
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
index f140c2b94b2c..f30cdd7f3a73 100644
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
@@ -615,6 +615,14 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
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

