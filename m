Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093192019F0
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390160AbgFSSEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389671AbgFSSEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 14:04:44 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B073420DD4;
        Fri, 19 Jun 2020 18:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592589883;
        bh=4BtD3MYD+VZOU9pnwXf8Ajs1DRRHrNXmV37Wuhj/+Gc=;
        h=Date:From:To:Cc:Subject:From;
        b=UZfGmO8K/btUZpFfszkFst5DdKQp3Z5but4edsWZRZEa649haUjZIo/YfTaIihf9J
         MHr9+242B2LfW5ZQt0C4GlvHuYwNDDu7tyNRlhvSOcIUkM0svtcIKnULrfGL0b200u
         ZoFkVbUk1/ukdB7mdywIyqBa/v5CzlQwfKGRCUVM=
Date:   Fri, 19 Jun 2020 13:10:07 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: dsa: sja1105: Use struct_size() in kzalloc()
Message-ID: <20200619181007.GA32353@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_tas.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
index 3aa1a8b5f766..31d8acff1f01 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.c
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -475,8 +475,7 @@ bool sja1105_gating_check_conflicts(struct sja1105_private *priv, int port,
 	if (list_empty(&gating_cfg->entries))
 		return false;
 
-	dummy = kzalloc(sizeof(struct tc_taprio_sched_entry) * num_entries +
-			sizeof(struct tc_taprio_qopt_offload), GFP_KERNEL);
+	dummy = kzalloc(struct_size(dummy, entries, num_entries), GFP_KERNEL);
 	if (!dummy) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to allocate memory");
 		return true;
-- 
2.27.0

