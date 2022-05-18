Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386DA52BA78
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbiERMdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236999AbiERMdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:33:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15CF14D7A4;
        Wed, 18 May 2022 05:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14CEB61678;
        Wed, 18 May 2022 12:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104CCC34100;
        Wed, 18 May 2022 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876934;
        bh=chbWy/TEaB5WRdwytyMUcR6JYaAww5Sa6VH1cBD2hdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lY07lkQ5DbsmA44y4GcRc3PPLRKLKaaWePOVPGuiY1lMORgSqig4YM7yYENxOnH3m
         ebd38wRqK9//k0mG1s+pPAFTrW6fCa4ggj03ySt8Cp6egSQqMuUP9WNZxChmdHipql
         s5cJuEZ/cjhze1a9d0QXddIDHydp7X4SxoCNIkJGaprVlyIAjinOEXkGfuM6U7ExJp
         pT1gBx42r5MWlb9vIlL6PNavAotrgdTjlbHjJ2+nyqAHeZMPpLfpyg8F+qzbeVVICP
         unA4UbImZLTa0ds6cRbzYLmRG7IXMmivU/4V3rc/pXvtvCzrb7A0X/RExvIgzKr/pQ
         W8VxHJj07ODxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/13] mac80211: fix rx reordering with non explicit / psmp ack policy
Date:   Wed, 18 May 2022 08:28:33 -0400
Message-Id: <20220518122844.343220-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122844.343220-1-sashal@kernel.org>
References: <20220518122844.343220-1-sashal@kernel.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5e469ed9764d4722c59562da13120bd2dc6834c5 ]

When the QoS ack policy was set to non explicit / psmp ack, frames are treated
as not being part of a BA session, which causes extra latency on reordering.
Fix this by only bypassing reordering for packets with no-ack policy

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20220420105038.36443-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1e7614abd947..e991abb45f68 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1387,8 +1387,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 		goto dont_reorder;
 
 	/* not part of a BA session */
-	if (ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK &&
-	    ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)
+	if (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
 		goto dont_reorder;
 
 	/* new, potentially un-ordered, ampdu frame - process it */
-- 
2.35.1

