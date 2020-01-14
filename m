Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D343313A78B
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgANKjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:39:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:45488 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgANKjv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 05:39:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E0E07AAC7;
        Tue, 14 Jan 2020 10:39:49 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Wen Huang <huangwenabc@gmail.com>,
        Nicolai Stange <nstange@suse.de>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH 1/2] libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held
Date:   Tue, 14 Jan 2020 11:39:02 +0100
Message-Id: <20200114103903.2336-2-nstange@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200114103903.2336-1-nstange@suse.de>
References: <87woa04t2v.fsf@suse.de>
 <20200114103903.2336-1-nstange@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
descriptor") introduced a bounds check on the number of supplied rates to
lbs_ibss_join_existing().

Unfortunately, it introduced a return path from within a RCU read side
critical section without a corresponding rcu_read_unlock(). Fix this.

Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
                      descriptor")
Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index c9401c121a14..68985d766349 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1785,6 +1785,7 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 		rates_max = rates_eid[1];
 		if (rates_max > MAX_RATES) {
 			lbs_deb_join("invalid rates");
+			rcu_read_unlock();
 			goto out;
 		}
 		rates = cmd.bss.rates;
-- 
2.16.4

