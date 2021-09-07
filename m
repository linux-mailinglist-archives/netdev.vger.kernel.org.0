Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB35402558
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 10:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243094AbhIGIqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 04:46:43 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:60488
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230259AbhIGIqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 04:46:42 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id DC50A4017A;
        Tue,  7 Sep 2021 08:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631004335;
        bh=oCiPtmkkbYn3+4ND5fAN4SGrEk+sY+yFDlI4yjQjrR4=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=HxX8b+p9yTy+fYJdNTfONf1CQNtp12DXgh0eFO801pIJPDKw4hp/GVbVNQAkkUIDG
         2cYD7OSZm/ATLE5HVzBKxoC6cjMU4KQu4TfbSgbwJkOj/76oxuo0JWctJ5LHt/YeXv
         U841YHZhlpZ2yVfgkWziTeuBqzr5AhP8VyWR5r968r5UgDx/ESRTtFdrmUlIWT/rxB
         yGP0CUQ3VtB2SgYwoiTOQ+ucuyRlToTnGxa3KRzT/juPl/4QsKUSg8YSsQjPcGfU+L
         8+w+O5zUUJXOZOuBSBV0PAQLxGsUqV9CWJ+Umqx+ud5bbl5XgEwClrdOkgKliqmUwl
         IhiVeotcYgs0A==
From:   Colin King <colin.king@canonical.com>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bonding: 3ad: pass parameter bond_params by reference
Date:   Tue,  7 Sep 2021 09:45:34 +0100
Message-Id: <20210907084534.10323-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The parameter bond_params is a relatively large 192 byte sized
struct so pass it by reference rather than by value to reduce
copying.

Addresses-Coverity: ("Big parameter passed by value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/bonding/bond_3ad.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index a4a202b9a0a2..6006c2e8fa2b 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -96,7 +96,7 @@ static int ad_marker_send(struct port *port, struct bond_marker *marker);
 static void ad_mux_machine(struct port *port, bool *update_slave_arr);
 static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port);
 static void ad_tx_machine(struct port *port);
-static void ad_periodic_machine(struct port *port, struct bond_params bond_params);
+static void ad_periodic_machine(struct port *port, struct bond_params *bond_params);
 static void ad_port_selection_logic(struct port *port, bool *update_slave_arr);
 static void ad_agg_selection_logic(struct aggregator *aggregator,
 				   bool *update_slave_arr);
@@ -1298,7 +1298,7 @@ static void ad_tx_machine(struct port *port)
  *
  * Turn ntt flag on priodically to perform periodic transmission of lacpdu's.
  */
-static void ad_periodic_machine(struct port *port, struct bond_params bond_params)
+static void ad_periodic_machine(struct port *port, struct bond_params *bond_params)
 {
 	periodic_states_t last_state;
 
@@ -1308,7 +1308,7 @@ static void ad_periodic_machine(struct port *port, struct bond_params bond_param
 	/* check if port was reinitialized */
 	if (((port->sm_vars & AD_PORT_BEGIN) || !(port->sm_vars & AD_PORT_LACP_ENABLED) || !port->is_enabled) ||
 	    (!(port->actor_oper_port_state & LACP_STATE_LACP_ACTIVITY) && !(port->partner_oper.port_state & LACP_STATE_LACP_ACTIVITY)) ||
-	    !bond_params.lacp_active) {
+	    !bond_params->lacp_active) {
 		port->sm_periodic_state = AD_NO_PERIODIC;
 	}
 	/* check if state machine should change state */
@@ -2342,7 +2342,7 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 		}
 
 		ad_rx_machine(NULL, port);
-		ad_periodic_machine(port, bond->params);
+		ad_periodic_machine(port, &bond->params);
 		ad_port_selection_logic(port, &update_slave_arr);
 		ad_mux_machine(port, &update_slave_arr);
 		ad_tx_machine(port);
-- 
2.32.0

