Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D980772EF6
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387415AbfGXMgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 08:36:44 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37788 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfGXMgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 08:36:44 -0400
Received: by mail-pl1-f193.google.com with SMTP id b3so21975302plr.4;
        Wed, 24 Jul 2019 05:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9Y7vn96lG/SonoxneykCtISW/bv1WUyhoDMBdhzYd/E=;
        b=kz9EUmanSnC0l/FHzyWj0Ew0jqrIOrwgL336BcPBG3gHWyiTHDEzdoYDIraHIe0+2M
         IhH8Kd98DS0LyweccALZ/EZRsxhoZ4fFojrMyz4VNemWc4Y8RtQ6F7YS4z8WGqeUdnik
         YXUvjX44JbFwapw5WvXxvnapGJfAzevcBjZafXBLoyY6w2hzRjHv3FFpgPLIdC8rxGPT
         Z9/bi2BLGSMmHXaYMZ8ZL0tjRoRZXnAZiOvPVuuKcdep0sa+m8soM3GDA0P+Oe21Htm9
         1A6Sh9+IZz7HaKcq21Y48wEmpNz2fl92Rp75FwovdAkNcM3a/+1imsnn1YdEKkvEIjIj
         50Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9Y7vn96lG/SonoxneykCtISW/bv1WUyhoDMBdhzYd/E=;
        b=JJcK7XImxmytvJy/86+cA3fyV7Kw2oHP3rlYFeHXRZPLxAW8rVM947TFK8BiIDvD6e
         6yLEmTZbSv/9CuBjKYisHwFmOZQo3kyhHZ1WP6WSu8ItxtoGxNpSBY6h7uYqbC6TyyFA
         T1PFCIMlhYyoJ0eaym5y2n6w1zxcMO1RGEzHHthXHibrVFLwha4PRmBjElwT6Zfn1nFZ
         8JvheZfOLeREKTCOZJFYCJzmsJy9vNSXd/LD7d4tRERWwLbncZLml9LJO4nE9k18XDRf
         W99TpvRWO4fVANRd765S6XwoZSO6kNP+nLrcpoIr3J4+g4CqT5znbtR3Rcpf/MxPx2hT
         sfdA==
X-Gm-Message-State: APjAAAU1NasXJ0SnPCaJ2ALJZY+Sqnd07a0huAPMZOERyoUXgAYRpBIB
        qVUJd2xg+qE8V7hW2QLhNH4=
X-Google-Smtp-Source: APXvYqz66tE/8060PJx6PuNGrwOD5jd3AB+6NsG3+Bdx64V6jnhIBRluTLEoFbPyEYNDgpc63gbOYw==
X-Received: by 2002:a17:902:aa83:: with SMTP id d3mr83294210plr.74.1563971803776;
        Wed, 24 Jul 2019 05:36:43 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id j15sm68288184pfn.150.2019.07.24.05.36.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 05:36:43 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 2/2] net: mac80211: Fix possible null-pointer dereferences in ieee80211_xmit_fast_finish()
Date:   Wed, 24 Jul 2019 20:36:33 +0800
Message-Id: <20190724123633.10145-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ieee80211_xmit_fast_finish(), there is an if statement on line 3356
to check whether key is NULL:
    if (key)

When key is NULL, it is used on line 3388:
    switch (key->conf.cipher)
and line 3393:
    pn = atomic64_inc_return(&key->conf.tx_pn);
and line 3396:
    crypto_hdr[3] = 0x20 | (key->conf.keyidx << 6);

Thus, possible null-pointer dereferences may occur.

To fix these bugs, key is checked on line 3384.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f13eb2f61ccf..2cc261165b91 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3381,7 +3381,7 @@ static void ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sdata,
 	sta->tx_stats.bytes[skb_get_queue_mapping(skb)] += skb->len;
 	sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
 
-	if (pn_offs) {
+	if (key && pn_offs) {
 		u64 pn;
 		u8 *crypto_hdr = skb->data + pn_offs;
 
-- 
2.17.0

