Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4F9537C78
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbiE3Ncq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237093AbiE3Nbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:31:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109CB8E1B0;
        Mon, 30 May 2022 06:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D3C260EE0;
        Mon, 30 May 2022 13:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499C2C36AE9;
        Mon, 30 May 2022 13:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917260;
        bh=MQrjqXErBDcH5v3vhgMjiO1PsCtlzbFiX1PZbys4/vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pY6i3qKzFO7g45zu2rWn1VBukt6piBW6Rr5tOhyZZWde4B7hUlPwo0OLlTo2D5x+P
         zcqcDaGkhp9ndA1u8Aiuhz2P5IXgyqLks8cR3WCBTetgBBv8m5yBZvZ+2bUWtEIpY/
         4vYFd4EF1/NO68WaPDZsZaZZ1iLqSDwa3u05yTOfNRVd5Vl/+WAQqiswjlYgTF+86R
         bWvZRvdxcS9r5BFyLTNnqZ7+R2CQdw6kGiWuYdNZQMZhDpstH/mGCPkoFU7E5T5tSf
         o0u5kwA7PsqsjSN/8+UnNRPfcdf5gBbxq5OiElV5QaZktYJd2BW6FnEAOdzsj1eJqc
         2EaSpNAdYKz2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 073/159] ath11k: fix warning of not found station for bssid in message
Date:   Mon, 30 May 2022 09:22:58 -0400
Message-Id: <20220530132425.1929512-73-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit 7330e1ec9748948177830c6e1a13379835d577f9 ]

When test connect/disconnect to an AP frequently with WCN6855, sometimes
it show below log.

[  277.040121] wls1: deauthenticating from 8c:21:0a:b3:5a:64 by local choice (Reason: 3=DEAUTH_LEAVING)
[  277.050906] ath11k_pci 0000:05:00.0: wmi stats vdev id 0 mac 00:03:7f:29:61:11
[  277.050944] ath11k_pci 0000:05:00.0: wmi stats bssid 8c:21:0a:b3:5a:64 vif         pK-error
[  277.050954] ath11k_pci 0000:05:00.0: not found station for bssid 8c:21:0a:b3:5a:64
[  277.050961] ath11k_pci 0000:05:00.0: failed to parse rssi chain -71
[  277.050967] ath11k_pci 0000:05:00.0: failed to pull fw stats: -71
[  277.050976] ath11k_pci 0000:05:00.0: wmi stats vdev id 0 mac 00:03:7f:29:61:11
[  277.050983] ath11k_pci 0000:05:00.0: wmi stats bssid 8c:21:0a:b3:5a:64 vif         pK-error
[  277.050989] ath11k_pci 0000:05:00.0: not found station for bssid 8c:21:0a:b3:5a:64
[  277.050995] ath11k_pci 0000:05:00.0: failed to parse rssi chain -71
[  277.051000] ath11k_pci 0000:05:00.0: failed to pull fw stats: -71
[  278.064050] ath11k_pci 0000:05:00.0: failed to request fw stats: -110

Reason is:
When running disconnect operation, sta_info removed from local->sta_hash
by __sta_info_destroy_part1() from __sta_info_flush(), after this,
ieee80211_find_sta_by_ifaddr() which called by
ath11k_wmi_tlv_fw_stats_data_parse() and ath11k_wmi_tlv_rssi_chain_parse()
cannot find this station, then failed log printed.

steps are like this:
1. when disconnect from AP, __sta_info_destroy() called __sta_info_destroy_part1()
and __sta_info_destroy_part2().

2. in __sta_info_destroy_part1(),  it has "sta_info_hash_del(local, sta)"
and "list_del_rcu(&sta->list)", it will remove the ieee80211_sta from the
list of ieee80211_hw.

3. in __sta_info_destroy_part2(), it called drv_sta_state()->ath11k_mac_op_sta_state(),
then peer->sta is clear at this moment.

4. in __sta_info_destroy_part2(), it then called sta_set_sinfo()->drv_sta_statistics()
->ath11k_mac_op_sta_statistics(), then WMI_REQUEST_STATS_CMDID sent to firmware.

5. WMI_UPDATE_STATS_EVENTID reported from firmware, at this moment, the
ieee80211_sta can not be found again because it has remove from list in
step2 and also peer->sta is clear in step3.

6. in __sta_info_destroy_part2(), it then called cleanup_single_sta()->
sta_info_free()->kfree(sta), at this moment, the ieee80211_sta is freed
in memory, then the failed log will not happen because function
ath11k_mac_op_sta_state() will not be called.

Actually this print log is not a real error, it is only to skip parse the
info, so change to skip print by default debug setting.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220428022426.2927-1-quic_wgong@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 2751fe8814df..0900f75eef20 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5789,9 +5789,9 @@ static int ath11k_wmi_tlv_rssi_chain_parse(struct ath11k_base *ab,
 					   arvif->bssid,
 					   NULL);
 	if (!sta) {
-		ath11k_warn(ab, "not found station for bssid %pM\n",
-			    arvif->bssid);
-		ret = -EPROTO;
+		ath11k_dbg(ab, ATH11K_DBG_WMI,
+			   "not found station of bssid %pM for rssi chain\n",
+			   arvif->bssid);
 		goto exit;
 	}
 
@@ -5889,8 +5889,9 @@ static int ath11k_wmi_tlv_fw_stats_data_parse(struct ath11k_base *ab,
 					   "wmi stats vdev id %d snr %d\n",
 					   src->vdev_id, src->beacon_snr);
 			} else {
-				ath11k_warn(ab, "not found station for bssid %pM\n",
-					    arvif->bssid);
+				ath11k_dbg(ab, ATH11K_DBG_WMI,
+					   "not found station of bssid %pM for vdev stat\n",
+					   arvif->bssid);
 			}
 		}
 
-- 
2.35.1

