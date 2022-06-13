Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E046547E2A
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 05:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiFMDaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 23:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiFMDaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 23:30:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B10E2125C
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655090998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5I2dj+cT/NCOtepo3+g1dbElxr84BofmUvMaWRJaUh0=;
        b=fULwAz8nnSv5gpdIfVE7LR2D85ezEbyiyc8jxxAlLmr5vnN3ELfz5y0Up570EQdKIVr7Sm
        NHbvAipumWzzjaaEa3KKm4XPUTfmGA5yGn2p1Si9ptZtm+I7xTey+T7nUaZuCbdw0sre5T
        O8rSqQw1Kt0f1ZtNMDJ7T2FEwfx54gk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-svD0vTKlMtOGHnns9fA-FA-1; Sun, 12 Jun 2022 23:29:53 -0400
X-MC-Unique: svD0vTKlMtOGHnns9fA-FA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E80E2185A79C;
        Mon, 13 Jun 2022 03:29:52 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0E00492C3B;
        Mon, 13 Jun 2022 03:29:52 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, aahringo@redhat.com
Subject: [PATCH wpan-next 2/2] 6lowpan: nhc: drop EEXIST limitation
Date:   Sun, 12 Jun 2022 23:29:22 -0400
Message-Id: <20220613032922.1030739-2-aahringo@redhat.com>
In-Reply-To: <20220613032922.1030739-1-aahringo@redhat.com>
References: <20220613032922.1030739-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nhc we have compression() and uncompression(). Currently we have a
limitation that we return -EEXIST when it's the nhc is already
registered according the nexthdr. But on receiving handling and the
nhcid we can indeed support both at the same time. We remove the current
static array implementation and replace it by a dynamic list handling to
get rid of this limitation.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/6lowpan/nhc.c | 69 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 25 deletions(-)

diff --git a/net/6lowpan/nhc.c b/net/6lowpan/nhc.c
index 7b374595328d..3d7c50139142 100644
--- a/net/6lowpan/nhc.c
+++ b/net/6lowpan/nhc.c
@@ -12,13 +12,30 @@
 
 #include "nhc.h"
 
-static const struct lowpan_nhc *lowpan_nexthdr_nhcs[NEXTHDR_MAX + 1];
+struct lowpan_nhc_entry {
+	const struct lowpan_nhc *nhc;
+	struct list_head list;
+};
+
 static DEFINE_SPINLOCK(lowpan_nhc_lock);
+static LIST_HEAD(lowpan_nexthdr_nhcs);
+
+const struct lowpan_nhc *lowpan_nhc_by_nexthdr(u8 nexthdr)
+{
+	const struct lowpan_nhc_entry *e;
+
+	list_for_each_entry(e, &lowpan_nexthdr_nhcs, list) {
+		if (e->nhc->nexthdr == nexthdr &&
+		    e->nhc->compress)
+			return e->nhc;
+	}
+
+	return NULL;
+}
 
 static const struct lowpan_nhc *lowpan_nhc_by_nhcid(struct sk_buff *skb)
 {
-	const struct lowpan_nhc *nhc;
-	int i;
+	const struct lowpan_nhc_entry *e;
 	u8 id;
 
 	if (!pskb_may_pull(skb, 1))
@@ -26,13 +43,9 @@ static const struct lowpan_nhc *lowpan_nhc_by_nhcid(struct sk_buff *skb)
 
 	id = *skb->data;
 
-	for (i = 0; i < NEXTHDR_MAX + 1; i++) {
-		nhc = lowpan_nexthdr_nhcs[i];
-		if (!nhc)
-			continue;
-
-		if ((id & nhc->idmask) == nhc->id)
-			return nhc;
+	list_for_each_entry(e, &lowpan_nexthdr_nhcs, list) {
+		if ((id & e->nhc->idmask) == e->nhc->id)
+			return e->nhc;
 	}
 
 	return NULL;
@@ -46,8 +59,8 @@ int lowpan_nhc_check_compression(struct sk_buff *skb,
 
 	spin_lock_bh(&lowpan_nhc_lock);
 
-	nhc = lowpan_nexthdr_nhcs[hdr->nexthdr];
-	if (!(nhc && nhc->compress))
+	nhc = lowpan_nhc_by_nexthdr(hdr->nexthdr);
+	if (!nhc)
 		ret = -ENOENT;
 
 	spin_unlock_bh(&lowpan_nhc_lock);
@@ -63,7 +76,7 @@ int lowpan_nhc_do_compression(struct sk_buff *skb, const struct ipv6hdr *hdr,
 
 	spin_lock_bh(&lowpan_nhc_lock);
 
-	nhc = lowpan_nexthdr_nhcs[hdr->nexthdr];
+	nhc = lowpan_nhc_by_nexthdr(hdr->nexthdr);
 	/* check if the nhc module was removed in unlocked part.
 	 * TODO: this is a workaround we should prevent unloading
 	 * of nhc modules while unlocked part, this will always drop
@@ -140,28 +153,34 @@ int lowpan_nhc_do_uncompression(struct sk_buff *skb,
 
 int lowpan_nhc_add(const struct lowpan_nhc *nhc)
 {
-	int ret = 0;
+	struct lowpan_nhc_entry *e;
 
-	spin_lock_bh(&lowpan_nhc_lock);
+	e = kmalloc(sizeof(*e), GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
 
-	if (lowpan_nexthdr_nhcs[nhc->nexthdr]) {
-		ret = -EEXIST;
-		goto out;
-	}
+	e->nhc = nhc;
 
-	lowpan_nexthdr_nhcs[nhc->nexthdr] = nhc;
-out:
+	spin_lock_bh(&lowpan_nhc_lock);
+	list_add(&e->list, &lowpan_nexthdr_nhcs);
 	spin_unlock_bh(&lowpan_nhc_lock);
-	return ret;
+
+	return 0;
 }
 EXPORT_SYMBOL(lowpan_nhc_add);
 
 void lowpan_nhc_del(const struct lowpan_nhc *nhc)
 {
-	spin_lock_bh(&lowpan_nhc_lock);
-
-	lowpan_nexthdr_nhcs[nhc->nexthdr] = NULL;
+	struct lowpan_nhc_entry *e, *tmp;
 
+	spin_lock_bh(&lowpan_nhc_lock);
+	list_for_each_entry_safe(e, tmp, &lowpan_nexthdr_nhcs, list) {
+		if (e->nhc == nhc) {
+			list_del(&e->list);
+			kfree(e);
+			break;
+		}
+	}
 	spin_unlock_bh(&lowpan_nhc_lock);
 
 	synchronize_net();
-- 
2.31.1

