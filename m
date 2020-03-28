Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5931964E1
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 10:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgC1JxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 05:53:17 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:57711 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgC1JxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 05:53:17 -0400
Received: from localhost.localdomain ([90.126.162.40])
        by mwinf5d59 with ME
        id KltC2200B0scBcy03ltC7b; Sat, 28 Mar 2020 10:53:15 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 28 Mar 2020 10:53:15 +0100
X-ME-IP: 90.126.162.40
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: dsa: Simplify 'dsa_tag_protocol_to_str()'
Date:   Sat, 28 Mar 2020 10:53:09 +0100
Message-Id: <20200328095309.27389-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no point in preparing the module name in a buffer. The format
string can be passed diectly to 'request_module()'.

This axes a few lines of code and cleans a few things:
   - max len for a driver name is MODULE_NAME_LEN wich is ~ 60 chars,
     not 128. It would be down-sized in 'request_module()'
   - we should pass the total size of the buffer to 'snprintf()', not the
     size minus 1

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This was introduced in 367561753144 ("dsa: Make use of the list of tag drivers")
---
 net/dsa/dsa.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 17281fec710c..ee2610c4d46a 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -88,13 +88,9 @@ const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol)
 {
 	struct dsa_tag_driver *dsa_tag_driver;
 	const struct dsa_device_ops *ops;
-	char module_name[128];
 	bool found = false;
 
-	snprintf(module_name, 127, "%s%d", DSA_TAG_DRIVER_ALIAS,
-		 tag_protocol);
-
-	request_module(module_name);
+	request_module("%s%d", DSA_TAG_DRIVER_ALIAS, tag_protocol);
 
 	mutex_lock(&dsa_tag_drivers_lock);
 	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
-- 
2.20.1

