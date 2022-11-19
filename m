Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F4F630A6E
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbiKSC0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235956AbiKSCZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:25:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB126A6A2;
        Fri, 18 Nov 2022 18:15:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32E25B82670;
        Sat, 19 Nov 2022 02:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD255C433D6;
        Sat, 19 Nov 2022 02:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824148;
        bh=YdOd16i8larOJiF6IQ6t9W+csn8yjRr238dJY+8X0wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fM7KJfmopGOslCCp2yFjFLk0EusTeoVyMujFYzTDHHOO1Fc30YoA/MirlzQS8q3DB
         pOSvTcdPCSNhUwAYj5bD4EO2MpHbliHQM6PaKhmq2QH8ni39JxTjYpmpOtVZAbodPC
         wXzDsBi5vxcngwAxUciATbw4Fut7yH2lkew+cuPm2TgRlwYkFOjnB8GwOJTBlMlwfN
         U42RKuGuuuUIcne5+VMitM6UicnSVeo9SumsyaCNBAG5TuwukQ1oqbqW+qM+3YA/wm
         uai+WHisCEm2ypR7hX0HCQhDsnHZ1TXIywqamq9xpDL73b0bH+FiPaHPFLTz5iZlnm
         HHDXxACvEbv4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonas Jelonek <jelonek.jonas@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/11] wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support
Date:   Fri, 18 Nov 2022 21:15:34 -0500
Message-Id: <20221119021543.1775315-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021543.1775315-1-sashal@kernel.org>
References: <20221119021543.1775315-1-sashal@kernel.org>
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

From: Jonas Jelonek <jelonek.jonas@gmail.com>

[ Upstream commit 69188df5f6e4cecc6b76b958979ba363cd5240e8 ]

Fixes a warning that occurs when rc table support is enabled
(IEEE80211_HW_SUPPORTS_RC_TABLE) in mac80211_hwsim and the PS mode
is changed via the exported debugfs attribute.

When the PS mode is changed, a packet is broadcasted via
hwsim_send_nullfunc by creating and transmitting a plain skb with only
header initialized. The ieee80211 rate array in the control buffer is
zero-initialized. When ratetbl support is enabled, ieee80211_get_tx_rates
is called for the skb with sta parameter set to NULL and thus no
ratetbl can be used. The final rate array then looks like
[-1,0; 0,0; 0,0; 0,0] which causes the warning in ieee80211_get_tx_rate.

The issue is fixed by setting the count of the first rate with idx '0'
to 1 and hence ieee80211_get_tx_rates won't overwrite it with idx '-1'.

Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3a3a5a570694..f80b1d57d6c3 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -663,6 +663,7 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_info *cb;
 
 	if (!vp->assoc)
 		return;
@@ -684,6 +685,10 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	memcpy(hdr->addr2, mac, ETH_ALEN);
 	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
 
+	cb = IEEE80211_SKB_CB(skb);
+	cb->control.rates[0].count = 1;
+	cb->control.rates[1].idx = -1;
+
 	rcu_read_lock();
 	mac80211_hwsim_tx_frame(data->hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
-- 
2.35.1

