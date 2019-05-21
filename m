Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FBC25919
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfEUUkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:40:19 -0400
Received: from kadath.azazel.net ([81.187.231.250]:49650 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfEUUkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:40:19 -0400
X-Greylist: delayed 2477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2019 16:40:19 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bIWV7iIsf8AKP6V8W5Fd3LFsZQx+WR5hi29FIGI9dbk=; b=SlbjLSeJ7bPqJpEAh8wddf+qn0
        0yTPg4C+LRVB3fdezV6kCjUkI7aidiarYX5a8XsqEdX2Cit4Cbz1RV4zkdM5HyFIC/XanHrM1HDTE
        i+71LBKwIbGTj05j1Ii+3MLlP/WQjztbeat0aCtMCTLVzr+yQBPf2H5MRF+LJYnq13z3KbzGZ2kZH
        /SZB/L4/SYrS03tX+UJZ3S6sDlOlB0rb2dnVBLmX0FJFbRmJN/PwQtcrlug5pkwpP9CitqZNeqpLx
        dcu3c777byHa3IycXbLkwPbTy/vZ6bh8qu5xEg889otfDkvMDSmZlSnN3aiSnabFjIQGQ2eOVl3uN
        N0l0XQvQ==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hTAuX-0000Xa-Af; Tue, 21 May 2019 20:58:57 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>
Cc:     syzbot+d454a826e670502484b8@syzkaller.appspotmail.com
Subject: [PATCH net] batadv: fix for leaked TVLV handler.
Date:   Tue, 21 May 2019 20:58:57 +0100
Message-Id: <20190521195857.14639-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <00000000000017d64c058965f966@google.com>
References: <00000000000017d64c058965f966@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A handler for BATADV_TVLV_ROAM was being registered when the
translation-table was initialized, but not unregistered when the
translation-table was freed.  Unregister it.

Reported-by: syzbot+d454a826e670502484b8@syzkaller.appspotmail.com
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
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
2.20.1

