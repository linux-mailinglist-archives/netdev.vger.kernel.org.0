Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688A058097
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfF0Kk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:40:26 -0400
Received: from packetmixer.de ([79.140.42.25]:48642 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbfF0Kk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:40:26 -0400
Received: from kero.packetmixer.de (ip-109-41-128-179.web.vodafone.de [109.41.128.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id E76846206B;
        Thu, 27 Jun 2019 12:31:25 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Jeremy Sowden <jeremy@azazel.net>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/2] batman-adv: fix for leaked TVLV handler.
Date:   Thu, 27 Jun 2019 12:31:18 +0200
Message-Id: <20190627103119.6969-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190627103119.6969-1-sw@simonwunderlich.de>
References: <20190627103119.6969-1-sw@simonwunderlich.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

A handler for BATADV_TVLV_ROAM was being registered when the
translation-table was initialized, but not unregistered when the
translation-table was freed.  Unregister it.

Fixes: 122edaa05940 ("batman-adv: tvlv - convert roaming adv packet to use tvlv unicast packets")
Reported-by: syzbot+d454a826e670502484b8@syzkaller.appspotmail.com
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/translation-table.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 1ddfd5e011ee..8a482c5ec67b 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3813,6 +3813,8 @@ static void batadv_tt_purge(struct work_struct *work)
  */
 void batadv_tt_free(struct batadv_priv *bat_priv)
 {
+	batadv_tvlv_handler_unregister(bat_priv, BATADV_TVLV_ROAM, 1);
+
 	batadv_tvlv_container_unregister(bat_priv, BATADV_TVLV_TT, 1);
 	batadv_tvlv_handler_unregister(bat_priv, BATADV_TVLV_TT, 1);
 
-- 
2.11.0

