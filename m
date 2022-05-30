Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A31F537EAD
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237997AbiE3Nru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiE3No0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:44:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76769B1B5;
        Mon, 30 May 2022 06:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CA8060F27;
        Mon, 30 May 2022 13:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753FCC3411F;
        Mon, 30 May 2022 13:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917539;
        bh=XIqhTsg1qO/7k2cKdd5hBUUYJE1jfjy8SEsUHanP4ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/DsUsR/k/54ASj2SB+dfZ2RK8i1iD1L4SVD670k7zljo83BquS2sDfYqHgzWl5zz
         9WdfXs+Wz5U9ZiL2QgpKhVauH+kXNvUZchyy27lMavAHQYGLO2rL01E9b3Yu5md01W
         SMuARTMUQyhTS0te6avCYffQydsHniBqpqpuUW+7ibapn4Ga+3GygJi/3pl9xSlBLQ
         qR7W/6yKptp8vZwYE17sxFu3m+herfRQZ8FTvYiQFCk722MXCDy82B3gGm8QL1rqRr
         yknPGAWXjgvkTQjhGWEIdCGJL+jag/SSWDdgV3sm61Bbz8qm9q47FeUuSk8kTZbK0c
         4inrtPL3cbrBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Seiderer <ps.report@gmx.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 017/135] mac80211: minstrel_ht: fix where rate stats are stored (fixes debugfs output)
Date:   Mon, 30 May 2022 09:29:35 -0400
Message-Id: <20220530133133.1931716-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Seiderer <ps.report@gmx.net>

[ Upstream commit 5c6dd7bd569b54c0d2904125d7366aa93f077f67 ]

Using an ath9k card the debugfs output of minstrel_ht looks like the following
(note the zero values for the first four rates sum-of success/attempts):

             best    ____________rate__________    ____statistics___    _____last____    ______sum-of________
mode guard #  rate   [name   idx airtime  max_tp]  [avg(tp) avg(prob)]  [retry|suc|att]  [#success | #attempts]
OFDM       1    DP     6.0M  272    1640     5.2       3.1      53.8       3     0 0             0   0
OFDM       1   C       9.0M  273    1104     7.7       4.6      53.8       4     0 0             0   0
OFDM       1  B       12.0M  274     836    10.0       6.0      53.8       4     0 0             0   0
OFDM       1 A    S   18.0M  275     568    14.3       8.5      53.8       5     0 0             0   0
OFDM       1      S   24.0M  276     436    18.1       0.0       0.0       5     0 1            80   1778
OFDM       1          36.0M  277     300    24.9       0.0       0.0       0     0 1             0   107
OFDM       1      S   48.0M  278     236    30.4       0.0       0.0       0     0 0             0   75
OFDM       1          54.0M  279     212    33.0       0.0       0.0       0     0 0             0   72

Total packet count::    ideal 16582      lookaround 885
Average # of aggregated frames per A-MPDU: 1.0

Debugging showed that the rate statistics for the first four rates where
stored in the MINSTREL_CCK_GROUP instead of the MINSTREL_OFDM_GROUP because
in minstrel_ht_get_stats() the supported check was not honoured as done in
various other places, e.g net/mac80211/rc80211_minstrel_ht_debugfs.c:

 74                 if (!(mi->supported[i] & BIT(j)))
 75                         continue;

With the patch applied the output looks good:

              best    ____________rate__________    ____statistics___    _____last____    ______sum-of________
mode guard #  rate   [name   idx airtime  max_tp]  [avg(tp) avg(prob)]  [retry|suc|att]  [#success | #attempts]
OFDM       1    D      6.0M  272    1640     5.2       5.2     100.0       3     0 0             1   1
OFDM       1   C       9.0M  273    1104     7.7       7.7     100.0       4     0 0            38   38
OFDM       1  B       12.0M  274     836    10.0       9.9      89.5       4     2 2           372   395
OFDM       1 A   P    18.0M  275     568    14.3      14.3      97.2       5    52 53         6956   7181
OFDM       1      S   24.0M  276     436    18.1       0.0       0.0       0     0 1             6   163
OFDM       1          36.0M  277     300    24.9       0.0       0.0       0     0 1             0   35
OFDM       1      S   48.0M  278     236    30.4       0.0       0.0       0     0 0             0   38
OFDM       1      S   54.0M  279     212    33.0       0.0       0.0       0     0 0             0   38

Total packet count::    ideal 7097      lookaround 287
Average # of aggregated frames per A-MPDU: 1.0

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Link: https://lore.kernel.org/r/20220404165414.1036-1-ps.report@gmx.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 9c3b7fc377c1..50cce990784f 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -362,6 +362,9 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 
 	group = MINSTREL_CCK_GROUP;
 	for (idx = 0; idx < ARRAY_SIZE(mp->cck_rates); idx++) {
+		if (!(mi->supported[group] & BIT(idx)))
+			continue;
+
 		if (rate->idx != mp->cck_rates[idx])
 			continue;
 
-- 
2.35.1

