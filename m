Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5402F201983
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 19:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392643AbgFSRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 13:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392026AbgFSRbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 13:31:51 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB66720809;
        Fri, 19 Jun 2020 17:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592587911;
        bh=9mCNxE/8rXZYK27gbI7jREQY5FMFSwoWsy4EMvaeG3Y=;
        h=Date:From:To:Cc:Subject:From;
        b=unM1SajPAWGLO2RLvI4NOTywsFTs4JNz5ftkv1P4abcHdAiYJlLxxftqMzWVVdRYW
         8LjabTaptFybYvdAORjLyRqioXRM8AthFwJhxSQKnZS4mxwSJlt2gbuQfd6hqSpuZf
         2xrtAHAexLBnyUEGA3p6bjBJm9CePmO0zvcTHIao=
Date:   Fri, 19 Jun 2020 12:37:15 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] ethernet: ti: am65-cpsw-qos: Use struct_size() in
 devm_kzalloc()
Message-ID: <20200619173715.GA6998@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes. Also, remove unnecessary
variable _size_.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index 32eac04468bb..3bdd4dbcd2ff 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -505,7 +505,6 @@ static int am65_cpsw_set_taprio(struct net_device *ndev, void *type_data)
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct am65_cpsw_est *est_new;
-	size_t size;
 	int ret = 0;
 
 	if (taprio->cycle_time_extension) {
@@ -513,10 +512,9 @@ static int am65_cpsw_set_taprio(struct net_device *ndev, void *type_data)
 		return -EOPNOTSUPP;
 	}
 
-	size = sizeof(struct tc_taprio_sched_entry) * taprio->num_entries +
-	       sizeof(struct am65_cpsw_est);
-
-	est_new = devm_kzalloc(&ndev->dev, size, GFP_KERNEL);
+	est_new = devm_kzalloc(&ndev->dev,
+			       struct_size(est_new, taprio.entries, taprio->num_entries),
+			       GFP_KERNEL);
 	if (!est_new)
 		return -ENOMEM;
 
-- 
2.27.0

