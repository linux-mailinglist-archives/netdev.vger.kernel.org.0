Return-Path: <netdev+bounces-5442-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46856711470
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E91361C20EE3
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C01B423D50;
	Thu, 25 May 2023 18:38:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9709319BC4
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0F7C4339C;
	Thu, 25 May 2023 18:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685039895;
	bh=EA7EnyBO8cmCNPcf02dhIWL9dadcEv0qdxkRF7doZKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAqVzC2HAGhcfAxE2MW5GyrQmArqWiXHiOrxlsvjCLzxj+tXVMpbsAxS1d/E1qU+I
	 8JaCb5hhgrdB/4Nf3oouNFbBxQXhSCODAK5hKZ+6Xj6fj2gEsjdBgO2GIVzrIPJdN4
	 zy80wLyGhi6xzEkkhlvBLigszqvsKK+FPIi6ndINT73o4KDxls1LL471lASFUnYohy
	 Hp2Tjg+pjNjOpit1kmKl4KzqbFnoYy9YTCQHxG2dGMOfNSMuyhBt9Vt6FzcV6qkas8
	 ueohZvjZtYfWcMXh+NV1Vevct4hwZGqrx/5rUnpUdB9DE7sEfYX0qK8bMyscNExCGl
	 LbFfJBqez9PJQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 41/57] wifi: mac80211: recalc chanctx mindef before assigning
Date: Thu, 25 May 2023 14:35:51 -0400
Message-Id: <20230525183607.1793983-41-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525183607.1793983-1-sashal@kernel.org>
References: <20230525183607.1793983-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 04312de4ced4b152749614e8179f3978a20a992f ]

When we allocate a new channel context, or find an existing one
that is compatible, we currently assign it to a link before its
mindef is updated. This leads to strange situations, especially
in link switching where you switch to an 80 MHz link and expect
it to be active immediately, but the mindef is still configured
to 20 MHz while assigning.  Also, it's strange that the chandef
passed to the assign method's argument is wider than the one in
the context.

Fix this by calculating the mindef with the new link considered
before calling the driver.

In particular, this fixes an iwlwifi problem during link switch
where the firmware would assert because the (link) station that
was added for the AP is configured to transmit at a bandwidth
that's wider than the channel context that it's configured on.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230504134511.828474-5-gregory.greenman@intel.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index c5d345e53056a..f07e34bed8f3a 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -871,6 +871,9 @@ static int ieee80211_assign_link_chanctx(struct ieee80211_link_data *link,
 	}
 
 	if (new_ctx) {
+		/* recalc considering the link we'll use it for now */
+		ieee80211_recalc_chanctx_min_def(local, new_ctx, link);
+
 		ret = drv_assign_vif_chanctx(local, sdata, link->conf, new_ctx);
 		if (ret)
 			goto out;
-- 
2.39.2


