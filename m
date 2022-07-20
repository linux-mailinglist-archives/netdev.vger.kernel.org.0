Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6AB57ABBB
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240924AbiGTBN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240657AbiGTBNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:13:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4E8664F0;
        Tue, 19 Jul 2022 18:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B35161729;
        Wed, 20 Jul 2022 01:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C247C385A5;
        Wed, 20 Jul 2022 01:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279557;
        bh=baf00Py4b86iH8zjzldeDSsKwFrcb2QrFKEJZFe3+mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvUMfH9s5cJLI5w+y2M71/ejkGz9InASalAWVjwLcOICpSqKtDs6ninbXkixTPPtn
         rNUxtTSk2JUS/0S01nuXwJsQhM3XF4LGzPYXcJb9ffYBIh4opxnMtb8DCKpGsFFzSA
         9aKSCaxvIqFdw7627Q23s0JyI1Iw5V3I787KicjYqOYj6ANf+ZibWQJ/8X/oyMoHi1
         Iv9rxdSe338gG5Rr3RxG8cIpt7489hPiTMGEGUXEhZi6QeWrlQ7DvHvlvj7GVyb8GT
         nJoRYXIQGp4N3Hc0+rlQMGBMyE9xSVmbSDJZ1rx8E3MNyy//W/erygnN/dTMwoJYoa
         QqTw3hjdutDrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 30/54] wifi: mac80211: do not wake queues on a vif that is being stopped
Date:   Tue, 19 Jul 2022 21:10:07 -0400
Message-Id: <20220720011031.1023305-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit f856373e2f31ffd340e47e2b00027bd4070f74b3 ]

When a vif is being removed and sdata->bss is cleared, __ieee80211_wake_txqs
can still be called on it, which crashes as soon as sdata->bss is being
dereferenced.
To fix this properly, check for SDATA_STATE_RUNNING before waking queues,
and take the fq lock when setting it (to ensure that __ieee80211_wake_txqs
observes the change when running on a different CPU)

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Toke Høiland-Jørgensen <toke@kernel.org>
Link: https://lore.kernel.org/r/20220531190824.60019-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 2 ++
 net/mac80211/util.c  | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 41531478437c..15a73b7fdd75 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -377,7 +377,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 	bool cancel_scan;
 	struct cfg80211_nan_func *func;
 
+	spin_lock_bh(&local->fq.lock);
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
+	spin_unlock_bh(&local->fq.lock);
 
 	cancel_scan = rcu_access_pointer(local->scan_sdata) == sdata;
 	if (cancel_scan)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 682a164f795a..8ed877a42f71 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -301,6 +301,9 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 	local_bh_disable();
 	spin_lock(&fq->lock);
 
+	if (!test_bit(SDATA_STATE_RUNNING, &sdata->state))
+		goto out;
+
 	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		ps = &sdata->bss->ps;
 
-- 
2.35.1

