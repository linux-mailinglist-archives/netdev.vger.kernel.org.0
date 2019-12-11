Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC5511A5C5
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfLKIXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:23:09 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44015 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbfLKIXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 03:23:09 -0500
Received: by mail-pg1-f194.google.com with SMTP id b1so10383730pgq.10
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 00:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lJULtQpShpRHaFvPKisAkpyn8+FMGgWhnQPjZrnhx70=;
        b=QJbAEUAU8o36R3ftEbob/J1V8rJpAgoS2KqNQYUWYPSor4kApLDSh92KDBrFzA9WG2
         wENNSnLaI0kLTkGsjisgfMDpXm2VE7RWKdRPlIBmodc4eRbrKK9rXc2ltfQYEe4NNkp7
         tZadZbAhK/5t7DPKDC5iznIDUmlWszWg2ud+jfJ1mfo3UypFy9kzeeQb4z57XZf9r8mR
         s5PLHAUPrn1jMJFyF/EENshY97tahCLDLKvxILOGA5JvN3F0zDMo8nDJhXhIwtY04ybb
         Uy79OSHPqV8GLpz60JO8VJiQtPu9FSFwTzM3eKA+axwtJfwLLngAqJgtlI+1RDPpZrhC
         wetA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lJULtQpShpRHaFvPKisAkpyn8+FMGgWhnQPjZrnhx70=;
        b=G7GLkxXGC4/Lv5re+H3HysGA4/5KZ6bMCnaX76r+f+FKXO3MpKh4B0qqrToRAdAZX9
         7KkSbV6nHDs9IZG0yuSF9+1ZMBsWRdJDHKpmjFICpfZH56Ctj8fgH8p8Z99RRQRo6dos
         tOrRm5Us1i2kdmHX3aHoGA9W6VeihOq3J4TQqSc3hp6lLxxx/eB9eYojWcdYsSTYZmNg
         +cp8yHaIJyRAAZv4RKVqiSieW5l10S430LJK9nG6Uvc+yl/G574XopGb8q9ZhgymM5SW
         V0I94Bz6Te6XzfZJuyM+ALDrKR3C0+OVyHXMMYlrFqqH+DhYEZbX7eolBZJUOOkmPrsb
         5VKA==
X-Gm-Message-State: APjAAAUbCr0APguEV81+r6m8OJtKH3xtq08VLe56YXgjL8gJj437fYLa
        KytWGSA60NsqyDWSZUzVq7E=
X-Google-Smtp-Source: APXvYqzhXVm9uN6RLHuqEpYVGf6dnA04Kag86rWP+Kimy+CsdAmKcVGibJBH0hShzgZsKsDS1aQYSA==
X-Received: by 2002:aa7:8181:: with SMTP id g1mr2405778pfi.215.1576052588789;
        Wed, 11 Dec 2019 00:23:08 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id a13sm1852549pfc.40.2019.12.11.00.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 00:23:07 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/4] gtp: do not allow adding duplicate tid and ms_addr pdp context
Date:   Wed, 11 Dec 2019 08:23:00 +0000
Message-Id: <20191211082300.28530-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GTP RX packet path lookups pdp context with TID. If duplicate TID pdp
contexts are existing in the list, it couldn't select correct pdp context.
So, TID value  should be unique.
GTP TX packet path lookups pdp context with ms_addr. If duplicate ms_addr pdp
contexts are existing in the list, it couldn't select correct pdp context.
So, ms_addr value should be unique.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/gtp.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index ecfe26215935..8b742edf793d 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -926,24 +926,31 @@ static void ipv4_pdp_fill(struct pdp_ctx *pctx, struct genl_info *info)
 	}
 }
 
-static int ipv4_pdp_add(struct gtp_dev *gtp, struct sock *sk,
-			struct genl_info *info)
+static int gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
+		       struct genl_info *info)
 {
+	struct pdp_ctx *pctx, *pctx_tid = NULL;
 	struct net_device *dev = gtp->dev;
 	u32 hash_ms, hash_tid = 0;
-	struct pdp_ctx *pctx;
+	unsigned int version;
 	bool found = false;
 	__be32 ms_addr;
 
 	ms_addr = nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
 	hash_ms = ipv4_hashfn(ms_addr) % gtp->hash_size;
+	version = nla_get_u32(info->attrs[GTPA_VERSION]);
 
-	hlist_for_each_entry_rcu(pctx, &gtp->addr_hash[hash_ms], hlist_addr) {
-		if (pctx->ms_addr_ip4.s_addr == ms_addr) {
-			found = true;
-			break;
-		}
-	}
+	pctx = ipv4_pdp_find(gtp, ms_addr);
+	if (pctx)
+		found = true;
+	if (version == GTP_V0)
+		pctx_tid = gtp0_pdp_find(gtp,
+					 nla_get_u64(info->attrs[GTPA_TID]));
+	else if (version == GTP_V1)
+		pctx_tid = gtp1_pdp_find(gtp,
+					 nla_get_u32(info->attrs[GTPA_I_TEI]));
+	if (pctx_tid)
+		found = true;
 
 	if (found) {
 		if (info->nlhdr->nlmsg_flags & NLM_F_EXCL)
@@ -951,6 +958,11 @@ static int ipv4_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 		if (info->nlhdr->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
+		if (pctx && pctx_tid)
+			return -EEXIST;
+		if (!pctx)
+			pctx = pctx_tid;
+
 		ipv4_pdp_fill(pctx, info);
 
 		if (pctx->gtp_version == GTP_V0)
@@ -1074,7 +1086,7 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 		goto out_unlock;
 	}
 
-	err = ipv4_pdp_add(gtp, sk, info);
+	err = gtp_pdp_add(gtp, sk, info);
 
 out_unlock:
 	rcu_read_unlock();
-- 
2.17.1

