Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EA814F373
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 21:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgAaUxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 15:53:21 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34987 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgAaUw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 15:52:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id y73so3955340pfg.2;
        Fri, 31 Jan 2020 12:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wat0pZ5YhU+1OSyNdyIWpU8kZvFRlp/ltTMqcWyCzTc=;
        b=NXejuL7Y2f7dgcSQvsDkrvn2HWsXawtYkEmTxoSZUij5Q5mCBBlzt5v14gu8zOl9ul
         n1YpyyM6xPwcONn4vzzmc8yx+CmQPYgQenSZ85tWsFKYEGuQ9ytMh3f6pJEocwBEXIEJ
         nRNzzmuJesGE3vsDnmxdf9hjTjHXcP97sBXrUvhtkZ6ospFjCheO3m8dVEvU8JRFh/Sq
         KLKGeFzfdP9UoLsC3CP+kdP+L7slMVFDoPzz5SmXoL6mtlr/Haqtek+lHl9YkHp1++bJ
         LBCSd1P8mX2mlRzsgr0vNlB6Oo58Krdzk/Zwceo3S/jMeLKJaeHDz7estwN4742daBiU
         cwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wat0pZ5YhU+1OSyNdyIWpU8kZvFRlp/ltTMqcWyCzTc=;
        b=UUuv15Wa86C6EjL+TbVzBIqsczh3nHE5XZcphapFVYawHsBH2i1h0gXA1N0sCFs+zb
         Z/6REr+ZF8HhYE8uouaIKHAZsjd1I/fOPOZ4783bQu3R3WFBhoYdZRKDEdoO37GpIDul
         uzc8vtHJnkjfK4gJqtvOCOx0bFIwZD4/9HpqZ/bOJ/cx5Kr0V8S/gxhr4WVJRWPjh86x
         V5Zma2MsNmlFYXACsGSFQFR4X+qwNA3liVeaPLcE5CKa42bYny1sUbYwmwUD8711RTfp
         2yRjAAJLolOdDTUqdVo0AAuEo4mSsv4P6fnBfXe6Un2xte1QXDYSSpx5CUIKpZA79ke9
         1I7A==
X-Gm-Message-State: APjAAAUdzePjxuffObdM/V0GHVDM0JQh8cfSYbFaEcJIWNuWIx0SvEl0
        7Oeki/2HhxQMdVhJy6sWGV441N+aTKg=
X-Google-Smtp-Source: APXvYqyLNu0JQq+2uR4TjNDD8HVj+o8E+F0w08J1KPKY+K0dqFNvlDrFY+y3JnnhzKybtIsZeSJknw==
X-Received: by 2002:a63:df0a:: with SMTP id u10mr12612095pgg.282.1580503975395;
        Fri, 31 Jan 2020 12:52:55 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id m128sm11599169pfm.183.2020.01.31.12.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 12:52:55 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [Patch nf 2/3] xt_hashlimit: reduce hashlimit_mutex scope for htable_put()
Date:   Fri, 31 Jan 2020 12:52:15 -0800
Message-Id: <20200131205216.22213-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is unnecessary to hold hashlimit_mutex for htable_destroy()
as it is already removed from the global hashtable and its
refcount is already zero.

Also, switch hinfo->use to refcount_t so that we don't have
to hold the mutex until it reaches zero in htable_put().

Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 885a266d8e57..57a2639bcc22 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -36,6 +36,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/mutex.h>
 #include <linux/kernel.h>
+#include <linux/refcount.h>
 #include <uapi/linux/netfilter/xt_hashlimit.h>
 
 #define XT_HASHLIMIT_ALL (XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT | \
@@ -114,7 +115,7 @@ struct dsthash_ent {
 
 struct xt_hashlimit_htable {
 	struct hlist_node node;		/* global list of all htables */
-	int use;
+	refcount_t use;
 	u_int8_t family;
 	bool rnd_initialized;
 
@@ -316,7 +317,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	for (i = 0; i < hinfo->cfg.size; i++)
 		INIT_HLIST_HEAD(&hinfo->hash[i]);
 
-	hinfo->use = 1;
+	refcount_set(&hinfo->use, 1);
 	hinfo->count = 0;
 	hinfo->family = family;
 	hinfo->rnd_initialized = false;
@@ -421,7 +422,7 @@ static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node) {
 		if (!strcmp(name, hinfo->name) &&
 		    hinfo->family == family) {
-			hinfo->use++;
+			refcount_inc(&hinfo->use);
 			return hinfo;
 		}
 	}
@@ -430,12 +431,11 @@ static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 
 static void htable_put(struct xt_hashlimit_htable *hinfo)
 {
-	mutex_lock(&hashlimit_mutex);
-	if (--hinfo->use == 0) {
+	if (refcount_dec_and_mutex_lock(&hinfo->use, &hashlimit_mutex)) {
 		hlist_del(&hinfo->node);
+		mutex_unlock(&hashlimit_mutex);
 		htable_destroy(hinfo);
 	}
-	mutex_unlock(&hashlimit_mutex);
 }
 
 /* The algorithm used is the Simple Token Bucket Filter (TBF)
-- 
2.21.1

