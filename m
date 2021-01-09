Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E217A2F0411
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbhAIWT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbhAIWT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 17:19:28 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8E7C0617A2
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 14:18:48 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id x15so14320216ilq.1
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 14:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3CCmCAKZ5+FY+7iiUxor4VqeVOkqFmzZ5x3D/T4EjIs=;
        b=a5eeRNKr6nCehkbKGg2NtnTDFLZkz2+a/SOZ9tYIclQy6+TfwzQoReExrDcv4W+B7y
         8ehBod2KCKBn8LvywMlQCEi8KrPWJ7cOTDWUIDxIgCmxMdmjtwYhgNP11dFyUsGw011Q
         KTtloQVGIovFm6+eiMxYDKPlfqh1YM4Efl2tIoNlftCBOFGON8E/FgS6KS6zfiz9em0j
         C56tT6pWurjWi+794hBvHTNlFjkDdP9S+VUQmzmU/l6iX/ni31u+kGpayI2PL1on5xAX
         HtN9P/E6VZ4DH2WSkR7A0REdI6onbl6Ogw2BJ0B6BO6h292y6h7gPqHg+4ZLkDgnZDxV
         0AMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3CCmCAKZ5+FY+7iiUxor4VqeVOkqFmzZ5x3D/T4EjIs=;
        b=sCdE5h4Y+cp+cW92WEP4OAXfOmxth162N0b9YN1/8RDd2nzf3EeQip3a5Ar+C7fajg
         ez8YaUcLOE7ESQ9xXz9tQyJbrbO2cd5R2+6fZJ7RZHKsYa2QIr50hk8MwUsLKORNgm3V
         Otc5wJvtr0vxCaVJ9lHJJxMuqBECc5XEtrolnk8VoLhl3+hBg3eDmB/Y7Zf+lxcdigXy
         dTDAnBWhRnpLKlQpueBsfJ0wt18JU6dfbIHZLwWUzxMXyAaCzSOJdg1rIdfjHlJcnZDt
         0JI83AXOxxKF43+JsPbuy4VAvIM69+zL7ly+tZaFkJC52o0Y+J/aW0f6VJ0akMLust2G
         1neg==
X-Gm-Message-State: AOAM531dk6FNu3XkaVL2I0FrXiGhfX6NvAthEUVPHJL42hAPbYw66Ls/
        Bln4pcTsu5+uyM8zhR+IrIYYeKtdRZM=
X-Google-Smtp-Source: ABdhPJxXBOd/gwayNaRKtHJkSmzz8j7EdSKTqIlur4elHSagagr/r78JBxleXRJde03jaJ4iMZxSFw==
X-Received: by 2002:a05:6e02:87:: with SMTP id l7mr10135074ilm.57.1610230727414;
        Sat, 09 Jan 2021 14:18:47 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id i27sm11415849ill.45.2021.01.09.14.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 14:18:46 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net v2 2/3] net: compound page support in skb_seq_read
Date:   Sat,  9 Jan 2021 17:18:33 -0500
Message-Id: <20210109221834.3459768-3-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
In-Reply-To: <20210109221834.3459768-1-willemdebruijn.kernel@gmail.com>
References: <20210109221834.3459768-1-willemdebruijn.kernel@gmail.com>
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

Changes:
  v1->v2
    - increase frag_off size to u32
---
 include/linux/skbuff.h |  1 +
 net/core/skbuff.c      | 28 +++++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c858adfb5a82..5f60c9e907c9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1203,6 +1203,7 @@ struct skb_seq_state {
 	struct sk_buff	*root_skb;
 	struct sk_buff	*cur_skb;
 	__u8		*frag_data;
+	__u32		frag_off;
 };
 
 void skb_prepare_seq_read(struct sk_buff *skb, unsigned int from,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b6f2b520a9b7..0da035c1e53f 100644
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

