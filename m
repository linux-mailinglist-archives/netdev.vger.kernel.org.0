Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F22E696567
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjBNNwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjBNNwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:52:20 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CB56A44;
        Tue, 14 Feb 2023 05:51:51 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 27D1F4001C;
        Tue, 14 Feb 2023 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676382648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aFpeaht2YTkpF7k3aSsGfayRg82bAR8GM9wVS2OZdx8=;
        b=d3Xz7QpaF6c4mCDDZIVw9sxiRTPUohjbFrFSGuxayj92gHn21dKT1mTIHRBAeGzVavHje1
        c1rNjUPqbXW0suouoVJSlCVcnKgt+6lobLdqjFObbyHCxwHTw//D5s6+ipdWEtmIoEjj2w
        rareXCu3tgpGpVQTBJaHpj8vXG9sVqUOSJ8i/0G29AA2gmXKkebwoapY0Zp5Z6EHYK35X7
        GGcxWsJE+Uv+C0Ws3nd29Xk2kC156dPaIHbP3QfCpJrqQTxxt7MNTMbjtNuYY6wa0sxw/X
        26pPAoVEMmhR0JpVIqDc7gwTF/c4LsxF4WkBIb6FDml85YlE9u2ufyBBgInVaw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH wpan v2 5/6] mac802154: Fix an always true condition
Date:   Tue, 14 Feb 2023 14:50:34 +0100
Message-Id: <20230214135035.1202471-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
References: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At this stage we simply do not care about the delayed work value,
because active scan is not yet supported, so we can blindly queue
another work once a beacon has been sent.

It fixes a smatch warning:
    mac802154_beacon_worker() warn: always true condition
    '(local->beacon_interval >= 0) => (0-u32max >= 0)'

Fixes: 3accf4762734 ("mac802154: Handle basic beaconing")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/scan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index fff41e59099e..9b0933a185eb 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -383,9 +383,8 @@ void mac802154_beacon_worker(struct work_struct *work)
 		dev_err(&sdata->dev->dev,
 			"Beacon could not be transmitted (%d)\n", ret);
 
-	if (local->beacon_interval >= 0)
-		queue_delayed_work(local->mac_wq, &local->beacon_work,
-				   local->beacon_interval);
+	queue_delayed_work(local->mac_wq, &local->beacon_work,
+			   local->beacon_interval);
 }
 
 int mac802154_stop_beacons_locked(struct ieee802154_local *local,
-- 
2.34.1

