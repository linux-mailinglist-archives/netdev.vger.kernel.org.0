Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11571F3DA1
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 16:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgFIOJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 10:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729332AbgFIOJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 10:09:42 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0D9C03E97C
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 07:09:41 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id u17so17690328qtq.1
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 07:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BwXHoGirj7qPs32m+Cp4zDEMolPVQXHOAsqRos1ND8Y=;
        b=V6USaU9aAkAXfD2evQuQ4sITaxBCX3elvfjVgxziErvhJXys2bd9xJqqNG0FLRCq9X
         dy+84kc5kdOyVvypz+4t3O5Zfag0nKxbTWkHBMJQadFfqAADMReBImAE5bhujjmU4+q5
         OWPiunY1GeXcbI5bVL1LyiW8iDB5OGPMdwCqlEBlZsGzrig2MQaSSHUrYGyJ1+BZpFUB
         FC3PxcOScQLA6ugIKddp5murYanHeAbqjXYEhxhG2KERMo5fYKw+H3uAz9cyzIFl8A+q
         MMZm4hYkm9Db8bPPXS/z3pBUvSZkBkRiEhMiexTRdezmR2kBLWIyDICdkU7E2WMLsQdx
         RHeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BwXHoGirj7qPs32m+Cp4zDEMolPVQXHOAsqRos1ND8Y=;
        b=HcBFbFD2A07wpmakC7sBs3710xHkLFB9Lf+kCyDG4tHTl7PT9k7Of81DFHmjLezy6m
         y8repBWRvOVXyls7Pj3yaLv5VSnB90ldnC+4yQpGtpoNWvlTN2F68qZHTs+BuMUekYc6
         v3KubgAFZQSzZAEHMDNs2/oM2I49jYUJ5Z4ntLIT5W6YhP0uvq9RGAtaBqgAQe7q6Kjb
         /3GKe1ET4d2D7z/jSx7Gh3vZPY+9YKwXac5hptUuOfEDAFdPUo0s17wkO3xRMJqqCM/o
         Tg+9yvb9wdluiZveWTeyWFUJA2RyF4ygfNGOR0TIJ8UPWlphCiEmeWuvNEFCkfCh7ZFz
         F8zw==
X-Gm-Message-State: AOAM532/XSk3+DgK29H1gl6VrJESbaMjawK2C0QqQTg5Va6yZ4p4K5xs
        AlZBOT54w11C0I5w0V+/JxM3lia8
X-Google-Smtp-Source: ABdhPJw3kdQmyjrxuROSGVeeliY+FPgsXFmCYXlXTkEL9W68BY49XMku1sN81EEivtFGRrBBS2W7MA==
X-Received: by 2002:ac8:37ad:: with SMTP id d42mr29062145qtc.352.1591711780130;
        Tue, 09 Jun 2020 07:09:40 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id u25sm10454614qtc.11.2020.06.09.07.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:09:39 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
Subject: [PATCH RFC net-next 2/6] net: build gso segs in multi release time SO_TXTIME
Date:   Tue,  9 Jun 2020 10:09:30 -0400
Message-Id: <20200609140934.110785-3-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
In-Reply-To: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
References: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

When sending multiple segments per interval and the device supports
hardware segmentation, build one GSO segment per interval.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/core/dev.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5058083375fb..05f538f0f631 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3379,7 +3379,9 @@ EXPORT_SYMBOL(__skb_gso_segment);
 
 struct sk_buff *skb_gso_segment_txtime(struct sk_buff *skb)
 {
+	const netdev_features_t hw_features = NETIF_F_GSO_UDP_L4;
 	int mss_per_ival, mss_in_cur_ival;
+	u16 gso_size_orig, gso_segs_orig;
 	struct sk_buff *segs, *seg;
 	struct skb_shared_info *sh;
 	u64 step_ns, tstamp;
@@ -3401,13 +3403,27 @@ struct sk_buff *skb_gso_segment_txtime(struct sk_buff *skb)
 	if (sh->gso_segs <= mss_per_ival)
 		return NULL;
 
+	/* update gso size and segs to build 1 GSO packet per ival */
+	gso_size_orig = sh->gso_size;
+	gso_segs_orig = sh->gso_segs;
+	if (mss_per_ival > 1 && skb->dev->features & hw_features) {
+		sh->gso_size *= mss_per_ival;
+		sh->gso_segs = DIV_ROUND_UP(sh->gso_segs, mss_per_ival);
+		mss_per_ival = 1;
+	}
+
 	segs = skb_gso_segment(skb, NETIF_F_SG | NETIF_F_HW_CSUM);
-	if (IS_ERR_OR_NULL(segs))
+	if (IS_ERR_OR_NULL(segs)) {
+		sh->gso_size = gso_size_orig;
+		sh->gso_segs = gso_segs_orig;
 		return segs;
+	}
 
 	mss_in_cur_ival = 0;
 
 	for (seg = segs; seg; seg = seg->next) {
+		unsigned int data_len, data_off;
+
 		seg->tstamp = tstamp & ~0xFF;
 
 		mss_in_cur_ival++;
@@ -3415,6 +3431,17 @@ struct sk_buff *skb_gso_segment_txtime(struct sk_buff *skb)
 			tstamp += step_ns;
 			mss_in_cur_ival = 0;
 		}
+
+		data_off = skb_checksum_start_offset(skb) +
+			   skb->csum_offset + sizeof(__sum16);
+		data_len = seg->len - data_off;
+
+		if (data_len > gso_size_orig) {
+			sh = skb_shinfo(seg);
+			sh->gso_type = skb_shinfo(skb)->gso_type;
+			sh->gso_size = gso_size_orig;
+			sh->gso_segs = DIV_ROUND_UP(data_len, gso_size_orig);
+		}
 	}
 
 	return segs;
-- 
2.27.0.278.ge193c7cf3a9-goog

