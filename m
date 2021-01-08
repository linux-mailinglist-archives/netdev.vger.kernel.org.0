Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3132EF64E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 18:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbhAHRMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 12:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbhAHRMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 12:12:38 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAF5C0612EA
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 09:11:58 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id z9so7000836qtn.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 09:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ErZAiVJLhWp/t0+f/uIDA2ze7Up4XbAYrW4zfl6dXDc=;
        b=sTxyXO+NZvRmAOG/eFW+zHk7qPhOPlGLRKbsQFdhSHUKpCGCmqHYvGfRSdHEzJWPwS
         /UZjPtPd8sgeB+f9IDN8Wxq/SJCkikmC0ENY5jN77Am1DHT4lixFJ9mld5d1DZ8tolrm
         La3B6PCYnS3px64wXPyMJeTbvH7570seQuqaXsmpia3f2T8osl7VDzPZKJlkSiZvtbSV
         GQxj8333eq5u/EKS1H6IDnF9yu0hgvmZA6nAXQzd7tO3kx0/SF9NM4V89UoeyQIlknxb
         qZDoqIsbB6RELFiH2GWoeDYfpCcTbaUIHm8gBc+LfvX16BhoJbglbKsOJ3l427iVg/n6
         kQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ErZAiVJLhWp/t0+f/uIDA2ze7Up4XbAYrW4zfl6dXDc=;
        b=cVbNhWKgekDZhUFVmSJRICq1HIPvgkIGQ2a2mFoG0+12xCD7ittzTwOxPH7O14KEl2
         bCHn6jWLhYTKesR+dKtggkfo4zDehIf1XWDj7tZ0QuDJebF3B7NyZk0o+J5oLKCrbtdy
         aFa5C4Jx2kXm1yoe9z/BpaOXQMYsBAcm6rr153m+AALq3788+GaXvQK9dGA/erW2OIs+
         AHCIrSLXREf92naj4HQrw/aU1SuL0eWvPevIEHT9tawaiUjsrXsoy1x02fEWjTTu5120
         VgVHR96Ac1gsQQEdw/FyXU6XC+bWhSKKmb0ZWRB+eLwmABnD0dtQpLKn9SqpMiu4JRZs
         /jrw==
X-Gm-Message-State: AOAM533aCn31BftWLZwcBj5GHV48MNuvXg9c/2JuXxs81f0JvWuZ3QP8
        +yBNQcZSJFsslEpllBMZvSmZY5NXwFk=
X-Google-Smtp-Source: ABdhPJzf9xZd07nMJSnl2R2ucDEHBWznZwzvTcqTW6FtpcD6tTi408I2VOw3aIkNvWxhp0otqbVNow==
X-Received: by 2002:aed:3482:: with SMTP id x2mr4449293qtd.368.1610125917615;
        Fri, 08 Jan 2021 09:11:57 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id c2sm5081600qke.109.2021.01.08.09.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 09:11:56 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net 2/3] net: compound page support in skb_seq_read
Date:   Fri,  8 Jan 2021 12:11:51 -0500
Message-Id: <20210108171152.2961251-3-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
In-Reply-To: <20210108171152.2961251-1-willemdebruijn.kernel@gmail.com>
References: <20210108171152.2961251-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

skb_seq_read iterates over an skb, returning pointer and length of
the next data range with each call.

It relies on kmap_atomic to access highmem pages when needed.

An skb frag may be backed by a compound page, but kmap_atomic maps
only a single page. There are not enough kmap slots to always map all
pages concurrently.

Instead, if kmap_atomic is needed, iterate over each page.

As this increases the number of calls, avoid this unless needed.
The necessary condition is captured in skb_frag_must_loop.

I tried to make the change as obvious as possible. It should be easy
to verify that nothing changes if skb_frag_must_loop returns false.

Tested:
  On an x86 platform with
    CONFIG_HIGHMEM=y
    CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=y
    CONFIG_NETFILTER_XT_MATCH_STRING=y

  Run
    ip link set dev lo mtu 1500
    iptables -A OUTPUT -m string --string 'badstring' -algo bm -j ACCEPT
    dd if=/dev/urandom of=in bs=1M count=20
    nc -l -p 8000 > /dev/null &
    nc -w 1 -q 0 localhost 8000 < in

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/skbuff.h |  1 +
 net/core/skbuff.c      | 28 +++++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c858adfb5a82..68ffd3f115c1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1203,6 +1203,7 @@ struct skb_seq_state {
 	struct sk_buff	*root_skb;
 	struct sk_buff	*cur_skb;
 	__u8		*frag_data;
+	__u16		frag_off;
 };
 
 void skb_prepare_seq_read(struct sk_buff *skb, unsigned int from,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f62cae3f75d8..4acf45154b17 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3442,6 +3442,7 @@ void skb_prepare_seq_read(struct sk_buff *skb, unsigned int from,
 	st->root_skb = st->cur_skb = skb;
 	st->frag_idx = st->stepped_offset = 0;
 	st->frag_data = NULL;
+	st->frag_off = 0;
 }
 EXPORT_SYMBOL(skb_prepare_seq_read);
 
@@ -3496,14 +3497,27 @@ unsigned int skb_seq_read(unsigned int consumed, const u8 **data,
 		st->stepped_offset += skb_headlen(st->cur_skb);
 
 	while (st->frag_idx < skb_shinfo(st->cur_skb)->nr_frags) {
+		unsigned int pg_idx, pg_off, pg_sz;
+
 		frag = &skb_shinfo(st->cur_skb)->frags[st->frag_idx];
-		block_limit = skb_frag_size(frag) + st->stepped_offset;
 
+		pg_idx = 0;
+		pg_off = skb_frag_off(frag);
+		pg_sz = skb_frag_size(frag);
+
+		if (skb_frag_must_loop(skb_frag_page(frag))) {
+			pg_idx = (pg_off + st->frag_off) >> PAGE_SHIFT;
+			pg_off = offset_in_page(pg_off + st->frag_off);
+			pg_sz = min_t(unsigned int, pg_sz - st->frag_off,
+						    PAGE_SIZE - pg_off);
+		}
+
+		block_limit = pg_sz + st->stepped_offset;
 		if (abs_offset < block_limit) {
 			if (!st->frag_data)
-				st->frag_data = kmap_atomic(skb_frag_page(frag));
+				st->frag_data = kmap_atomic(skb_frag_page(frag) + pg_idx);
 
-			*data = (u8 *) st->frag_data + skb_frag_off(frag) +
+			*data = (u8 *)st->frag_data + pg_off +
 				(abs_offset - st->stepped_offset);
 
 			return block_limit - abs_offset;
@@ -3514,8 +3528,12 @@ unsigned int skb_seq_read(unsigned int consumed, const u8 **data,
 			st->frag_data = NULL;
 		}
 
-		st->frag_idx++;
-		st->stepped_offset += skb_frag_size(frag);
+		st->stepped_offset += pg_sz;
+		st->frag_off += pg_sz;
+		if (st->frag_off == skb_frag_size(frag)) {
+			st->frag_off = 0;
+			st->frag_idx++;
+		}
 	}
 
 	if (st->frag_data) {
-- 
2.30.0.284.gd98b1dd5eaa7-goog

