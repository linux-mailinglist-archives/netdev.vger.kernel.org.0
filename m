Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4248652BAEE
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbiERM1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbiERM04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:26:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30486D4D0;
        Wed, 18 May 2022 05:26:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A5C6B81F43;
        Wed, 18 May 2022 12:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B817EC3411A;
        Wed, 18 May 2022 12:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876812;
        bh=jpp7JaAjtpYcJypZTqEMC1XKrOHHdguJX9I0ndKgnbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1bLlc/rFCCTpcleeiaRDtN6oPm+C5AxfSu7EnFRpJdDTuJCnvQDr4ZosE0mdtqFO
         LXUqEV1ZSuR5PSEzQ4GJbf50xdr8KuhUfzNBCYMyvDAreItSlvkn3wXHbUhsAZ5VzJ
         4zKHxSXa0co5F2YIY0pKZlYhZ0Y+uISME/0CRm3bPtoX7xhTQbM3g//+o3/X7qTvyB
         rArhZ2IdrXSuu7BeHELJXjsdutQlIldIawIBgVh1TUqQQZ4UKXCoGf4NykJvGF9gT9
         m9WJM2H0AmTWb/oJo+LXx+H45C5SE6cv8m5KQYw2KLFad45GWObOPDmtB/wBTa5Mpj
         pNIPnRmqLe5MQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kieran Frewen <kieran.frewen@morsemicro.com>,
        Bassem Dawood <bassem@morsemicro.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 05/23] cfg80211: retrieve S1G operating channel number
Date:   Wed, 18 May 2022 08:26:18 -0400
Message-Id: <20220518122641.342120-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kieran Frewen <kieran.frewen@morsemicro.com>

[ Upstream commit e847ffe2d146cfd52980ca688d84358e024a6e70 ]

When retrieving the S1G channel number from IEs, we should retrieve
the operating channel instead of the primary channel. The S1G operation
element specifies the main channel of operation as the oper channel,
unlike for HT and HE which specify their main channel of operation as
the primary channel.

Signed-off-by: Kieran Frewen <kieran.frewen@morsemicro.com>
Signed-off-by: Bassem Dawood <bassem@morsemicro.com>
Link: https://lore.kernel.org/r/20220420041321.3788789-1-kieran.frewen@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 4a6d86432910..6d82bd9eaf8c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1829,7 +1829,7 @@ int cfg80211_get_ies_channel_number(const u8 *ie, size_t ielen,
 		if (tmp && tmp->datalen >= sizeof(struct ieee80211_s1g_oper_ie)) {
 			struct ieee80211_s1g_oper_ie *s1gop = (void *)tmp->data;
 
-			return s1gop->primary_ch;
+			return s1gop->oper_ch;
 		}
 	} else {
 		tmp = cfg80211_find_elem(WLAN_EID_DS_PARAMS, ie, ielen);
-- 
2.35.1

