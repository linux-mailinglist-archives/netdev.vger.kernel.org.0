Return-Path: <netdev+bounces-706-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E8D6F9254
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 15:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37C22281144
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 13:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC778836;
	Sat,  6 May 2023 13:53:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDFC1FB0
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 13:53:24 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C4023A10
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 06:53:22 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id vILdpZJ7QLshbvILdpEMnX; Sat, 06 May 2023 15:53:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1683381200;
	bh=r2E/7o27DlnpjDgt/7U4i84YKnHKe8gQvEkHYS6ZEo4=;
	h=From:To:Cc:Subject:Date;
	b=lHlfvw7vCLJXsOvSEVtTEc2wvFWkD4EblArPxqrOu5YDJrRsXSR4s5ZSksWAVkdZv
	 55glhtQuraGZycXpPsAWNDnlCpjsF7iI9pc+PHoXZr1Blt+WtwgTPjM8wwfGVImAz7
	 DalbgVM/UlkBgGUuGOOYCcugmBKHHG+5wN1eeH7h6OQSkQ9On742MD7fG+MBCjwcAI
	 gg3/DueVXVN9832W8oFD09ckXazRl0t5AbhLGWIw5oNU4D2ucn0BXTM1HO4dbW/K5O
	 jO1e5fFIBx7HOAkq3GgASHeePGwU347WIkFlQAO1vbLTB43Cuhm4oJpTmcb34uzFLV
	 zUwL97u8QjFUA==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 06 May 2023 15:53:20 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
	Ganapathi Bhat <ganapathi017@gmail.com>,
	Sharvari Harisangam <sharvari.harisangam@nxp.com>,
	Xinming Hu <huxinming820@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	chunfan chen <jeffc@marvell.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH wireless] mwifiex: Fix the size of a memory allocation in mwifiex_ret_802_11_scan()
Date: Sat,  6 May 2023 15:53:15 +0200
Message-Id: <7a6074fb056d2181e058a3cc6048d8155c20aec7.1683371982.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The type of "mwifiex_adapter->nd_info" is "struct cfg80211_wowlan_nd_info",
not "struct cfg80211_wowlan_nd_match".

Use struct_size() to ease the computation of the needed size.

The current code over-allocates some memory, so is safe.
But it wastes 32 bytes.

Fixes: 7d7f07d8c5d3 ("mwifiex: add wowlan net-detect support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index ac8001c84293..dd73ade4ddf1 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2187,9 +2187,9 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 	if (nd_config) {
 		adapter->nd_info =
-			kzalloc(sizeof(struct cfg80211_wowlan_nd_match) +
-				sizeof(struct cfg80211_wowlan_nd_match *) *
-				scan_rsp->number_of_sets, GFP_ATOMIC);
+			kzalloc(struct_size(adapter->nd_info, matches,
+					    scan_rsp->number_of_sets),
+				GFP_ATOMIC);
 
 		if (adapter->nd_info)
 			adapter->nd_info->n_matches = scan_rsp->number_of_sets;
-- 
2.34.1


