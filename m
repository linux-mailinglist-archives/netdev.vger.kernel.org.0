Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B69257ACC1
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242065AbiGTB0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbiGTBZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:25:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D497478D;
        Tue, 19 Jul 2022 18:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18B416176E;
        Wed, 20 Jul 2022 01:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E579C341CA;
        Wed, 20 Jul 2022 01:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279874;
        bh=qj/EKC69Ek8OWQrDUatH0/+La5iXNNyRDTVBQobYLGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGNoNFu5W8/zpfnL/rldr/r6jKT3IkZXgvZDud0zQOr99848Spv8E8A92vadWzSVb
         NE6lZdjbxZjGtsVMKjSLUli/mu2L/SvGZqQhO6C0Icll4mSyldtaTbN+U/lrFvQxk+
         rp1j5TARny6IzSZeo/6Vk58Oh0GJD9Y9gb0ocAwLMw6HRbkveufjrZuGCYD/JGO0oP
         WhVLKmEQ97PKJgw7FIq+R6rVHyXwqd1atEB/rsxhsgEgLsfRzpXgblm2q8ohAGDUyM
         MCbnUYbFNf+363vRLjx/EZMMMxzcSPhQ7zGO+s/jza9NWSWY0AHOz4XJpwONxFWrTX
         RjZzTn3cf7T1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinayak Yadawad <vinayak.yadawad@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/16] wifi: cfg80211: Allow P2P client interface to indicate port authorization
Date:   Tue, 19 Jul 2022 21:17:21 -0400
Message-Id: <20220720011730.1025099-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011730.1025099-1-sashal@kernel.org>
References: <20220720011730.1025099-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Vinayak Yadawad <vinayak.yadawad@broadcom.com>

[ Upstream commit 8d70f33ed7207e82e51d5a4436c8ba2268a83b14 ]

In case of 4way handshake offload, cfg80211_port_authorized
enables driver to indicate successful 4way handshake to cfg80211 layer.
Currently this path of port authorization is restricted to
interface type NL80211_IFTYPE_STATION. This patch extends
the use of port authorization API for P2P client as well.

Signed-off-by: Vinayak Yadawad <vinayak.yadawad@broadcom.com>
Link: https://lore.kernel.org/r/ef25cb49fcb921df2e5d99e574f65e8a009cc52c.1655905440.git.vinayak.yadawad@broadcom.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 63f89687a018..b70d7e8fbc12 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1032,7 +1032,8 @@ void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *bssid)
 {
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
 		return;
 
 	if (WARN_ON(!wdev->current_bss) ||
-- 
2.35.1

