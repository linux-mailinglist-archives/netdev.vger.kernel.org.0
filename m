Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D791C6799D2
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbjAXNmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbjAXNmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:42:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF2E3E61E;
        Tue, 24 Jan 2023 05:41:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6335DB811DD;
        Tue, 24 Jan 2023 13:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F52EC4339E;
        Tue, 24 Jan 2023 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567713;
        bh=rGPzs7kmVKrk2vlRWmqB9RBll/IIAzm77xKeCZXA8J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bp80HCUuNx1iDJombS5GxZLrsa6390/4f58Cb9tRYCU6TIf9TZ8+kbspLYnakV4r+
         qlBV9yhb91vet21gaHZgCxx3fzEPh8aLni7j6pvlSCab3VoHJjqZizrebHqtDfWPA8
         MWkRi+JbInYXFEWxNxEUXcebZ00rwtox7NVZciP0XmIZmT9zSmmsfQjE4xa9nPbSxt
         4wQm21rC802VzTgL3JcTz2Km8YsAZgwJwa/NWqU9hvvov3lwKNnm1YRuO5LQY70rdC
         RKLaZNKDmhEtyB0xFMRmxbgoAwe4MNHKgGXK7XKkuWRPmilIWDPdOourF0ubN2DRcf
         MQ0up2Y2karOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sriram R <quic_srirrama@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 08/35] mac80211: Fix MLO address translation for multiple bss case
Date:   Tue, 24 Jan 2023 08:41:04 -0500
Message-Id: <20230124134131.637036-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriram R <quic_srirrama@quicinc.com>

[ Upstream commit fa22b51ace8aa106267636f36170e940e676809c ]

When multiple interfaces are present in the local interface
list, new skb copy is taken before rx processing except for
the first interface. The address translation happens each
time only on the original skb since the hdr pointer is not
updated properly to the newly created skb.

As a result frames start to drop in userspace when address
based checks or search fails.

Signed-off-by: Sriram R <quic_srirrama@quicinc.com>
Link: https://lore.kernel.org/r/20221208040050.25922-1-quic_srirrama@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f99416d2e144..60b83cbbd5b0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4859,6 +4859,9 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 		 */
 		shwt = skb_hwtstamps(rx->skb);
 		shwt->hwtstamp = skb_hwtstamps(skb)->hwtstamp;
+
+		/* Update the hdr pointer to the new skb for translation below */
+		hdr = (struct ieee80211_hdr *)rx->skb->data;
 	}
 
 	if (unlikely(link_sta)) {
-- 
2.39.0

