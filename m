Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0F718136A
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 09:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgCKIiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 04:38:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:50158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728593AbgCKIiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 04:38:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2FD77B1C5;
        Wed, 11 Mar 2020 08:38:02 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7/7] netdevsim: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 09:37:45 +0100
Message-Id: <20200311083745.17328-8-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200311083745.17328-1-tiwai@suse.de>
References: <20200311083745.17328-1-tiwai@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/netdevsim/ipsec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index e27fc1a4516d..3281ce3d6c70 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -29,7 +29,7 @@ static ssize_t nsim_dbg_netdev_ops_read(struct file *filp,
 		return -ENOMEM;
 
 	p = buf;
-	p += snprintf(p, bufsize - (p - buf),
+	p += scnprintf(p, bufsize - (p - buf),
 		      "SA count=%u tx=%u\n",
 		      ipsec->count, ipsec->tx);
 
@@ -39,15 +39,15 @@ static ssize_t nsim_dbg_netdev_ops_read(struct file *filp,
 		if (!sap->used)
 			continue;
 
-		p += snprintf(p, bufsize - (p - buf),
+		p += scnprintf(p, bufsize - (p - buf),
 			      "sa[%i] %cx ipaddr=0x%08x %08x %08x %08x\n",
 			      i, (sap->rx ? 'r' : 't'), sap->ipaddr[0],
 			      sap->ipaddr[1], sap->ipaddr[2], sap->ipaddr[3]);
-		p += snprintf(p, bufsize - (p - buf),
+		p += scnprintf(p, bufsize - (p - buf),
 			      "sa[%i]    spi=0x%08x proto=0x%x salt=0x%08x crypt=%d\n",
 			      i, be32_to_cpu(sap->xs->id.spi),
 			      sap->xs->id.proto, sap->salt, sap->crypt);
-		p += snprintf(p, bufsize - (p - buf),
+		p += scnprintf(p, bufsize - (p - buf),
 			      "sa[%i]    key=0x%08x %08x %08x %08x\n",
 			      i, sap->key[0], sap->key[1],
 			      sap->key[2], sap->key[3]);
-- 
2.16.4

