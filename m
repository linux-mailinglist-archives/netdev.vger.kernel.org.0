Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 477B7E2F14
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438830AbfJXKcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:32:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34487 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438820AbfJXKcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:32:24 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iNaPj-0007Cl-6A; Thu, 24 Oct 2019 10:32:19 +0000
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: dsa: fix dereference on ds->dev before null check error
Date:   Thu, 24 Oct 2019 11:32:18 +0100
Message-Id: <20191024103218.2592-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently ds->dev is dereferenced on the assignments of pdata and
np before ds->dev is null checked, hence there is a potential null
pointer dereference on ds->dev.  Fix this by assigning pdata and
np after the ds->dev null pointer sanity check.

Addresses-Coverity: ("Dereference before null check")
Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/dsa/dsa2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 1e3ac9b56c89..214dd703b0cc 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -842,13 +842,16 @@ static int dsa_switch_add(struct dsa_switch *ds)
 
 static int dsa_switch_probe(struct dsa_switch *ds)
 {
-	struct dsa_chip_data *pdata = ds->dev->platform_data;
-	struct device_node *np = ds->dev->of_node;
+	struct dsa_chip_data *pdata;
+	struct device_node *np;
 	int err;
 
 	if (!ds->dev)
 		return -ENODEV;
 
+	pdata = ds->dev->platform_data;
+	np = ds->dev->of_node;
+
 	if (!ds->num_ports)
 		return -EINVAL;
 
-- 
2.20.1

