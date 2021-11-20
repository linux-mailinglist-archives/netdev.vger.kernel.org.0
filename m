Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056F5457FC8
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 18:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237849AbhKTRST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 12:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232180AbhKTRST (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 12:18:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8735B60C4B;
        Sat, 20 Nov 2021 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637428515;
        bh=2FTpC09/Qm45dKCsNXWYXq8rk+LPeg9ej0ovKGNGwAg=;
        h=From:To:Cc:Subject:Date:From;
        b=nblFQ50mmCj9xDd9sjthhzRkb8Rw+TAcgWV+7raKWYf9VwStX03dHChSoiMmhfk55
         O/BUEuty5fMMJOXp+N+skheYgSR1hed5lApoXla5C7RBlFjLfciTz6UlUZ6ptuQQHF
         Vl95DlwTIf7E6YIUU8Pw+bQANJynknrSpzO+7+0EEFeQIj5cYG+9cRbTWQjsgRN/pF
         A76GqvlBXoctIw/sEIyH1vG3Fj6Yp/2JV0CASt9nAAIF1ZZd7nmWNoRjZlOnQ9n3/s
         on8Lwpblp8+49tIwLf0q12DKFeTdlTod8mYq9qV0M4595fjwcFwXKoUXeorY1YA5PJ
         uU+rM57GPo1sg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] pcmcia: hide the MAC address helpers if !NET
Date:   Sat, 20 Nov 2021 09:15:10 -0800
Message-Id: <20211120171510.201163-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pcmcia_get_mac_from_cis is only called from networking and
recent changes made it call dev_addr_mod() which is itself
only defined if NET.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/pcmcia/pcmcia_cis.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pcmcia/pcmcia_cis.c b/drivers/pcmcia/pcmcia_cis.c
index f650e19a315c..6bc0bc24d357 100644
--- a/drivers/pcmcia/pcmcia_cis.c
+++ b/drivers/pcmcia/pcmcia_cis.c
@@ -386,7 +386,7 @@ size_t pcmcia_get_tuple(struct pcmcia_device *p_dev, cisdata_t code,
 }
 EXPORT_SYMBOL(pcmcia_get_tuple);
 
-
+#ifdef CONFIG_NET
 /*
  * pcmcia_do_get_mac() - internal helper for pcmcia_get_mac_from_cis()
  *
@@ -431,3 +431,4 @@ int pcmcia_get_mac_from_cis(struct pcmcia_device *p_dev, struct net_device *dev)
 }
 EXPORT_SYMBOL(pcmcia_get_mac_from_cis);
 
+#endif /* CONFIG_NET */
-- 
2.31.1

