Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188FA17ADAB
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCER4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:56:02 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41415 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgCER4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 12:56:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id v4so8122644wrs.8;
        Thu, 05 Mar 2020 09:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rN0SehFieK1S420zrDd71gH/X37YlDRA2Yp0i/5B3us=;
        b=TGOlfgPmAhqwkll3WqAAKHNmZ2gdI3Ge697YzJaY+rCSi3xMQzizkMuzt3YWBKUHlb
         dI2hu949zJ+31YF2gvGrnyCo9U4yWb0q3M9ohSgYXS64qzYw7D6sqTnresX37Vp9UJk2
         M/YE3o3OL/exmv95uZ4mm7P9f892HSuhixSmH85n2iog1Tw70fN6ByXYmIwBhSgcZmo7
         Bj+dF7H1MVjVoB9MJgEpVucqvQ6UFkGioBhDKi68M6IDHT4KVAC9xlbw35QpP9Xr64nv
         7en+exgOMGctDu7h0bn5Z9W83iHbAbrzS1tZO55kzO9dE8y/ijxsu2CAVYSW19KsTflM
         Ygvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rN0SehFieK1S420zrDd71gH/X37YlDRA2Yp0i/5B3us=;
        b=YTWgoz4PmIxxrkIMVhoKDoHN1q9UbiM8z/W2Cd2tuaaUrflZy9h8hHlLi+HPgGQlfR
         bNTDL6m1m/fejyNfVm0XEMqbAnG6cUZQLcWD0AFz/e8rKUicIlkSdArCVN/cgEbSncqC
         iUUqXw3RS8IIPAR0QJtD2J+c0pR9OUtW/hZoweSQhdsHDDUyD9EBV9TkAP+X1PpmXyct
         FHWgI2Lmvjf7Tqh3QTK1KN30oWsI0q56QZMc7ub82w3XXeiLxU28tBX7+GVDlBC0fG5R
         OvqVhA0vPQc9Ql7FYDfM7bOzlrrFIGyiG6UV6og4SX1DOYFVZBU2ZoLRdBJtJ3n0vOGy
         gbLg==
X-Gm-Message-State: ANhLgQ1hMrYmTwmEq0qppDMU/dOL7YXqB+OB1qunP51/ddfZGrvAc21t
        SJHF4hiRA3E+0bNP/h0BEOCwH89HCcSCkA==
X-Google-Smtp-Source: ADFU+vtoH1WRQrInN1LkTXr6vGuYhI9MXsSWsn3T/i1f631EP6LLtMuqU82IcVxHgTPmJ1daQ5wMfw==
X-Received: by 2002:a05:6000:1081:: with SMTP id y1mr142652wrw.52.1583430959568;
        Thu, 05 Mar 2020 09:55:59 -0800 (PST)
Received: from localhost (hosting85.skyberate.net. [185.87.248.81])
        by smtp.gmail.com with ESMTPSA id w206sm10631718wmg.11.2020.03.05.09.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 09:55:58 -0800 (PST)
From:   Era Mayflower <mayflowerera@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Era Mayflower <mayflowerera@gmail.com>
Subject: [PATCH 2/2] macsec: Fix frame loss in XPN mode when PN=0 bug
Date:   Fri,  6 Mar 2020 02:55:23 +0000
Message-Id: <20200306025523.63457-2-mayflowerera@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200306025523.63457-1-mayflowerera@gmail.com>
References: <20200306025523.63457-1-mayflowerera@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to IEEE 802.1aebw figure 10-5,
the PN of incoming frame can be 0 when XPN cipher suite is used.

Fixed `macsec_validate_skb` to fail on PN=0 only if we are not using XPN.

Depends on: macsec: Backward compatibility bugfix of consts values

Signed-off-by: Era Mayflower <mayflowerera@gmail.com>
---
 drivers/net/macsec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index aff28ee89..418e1b126 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -386,7 +386,7 @@ static const struct macsec_ops *macsec_get_ops(struct macsec_dev *macsec,
 }
 
 /* validate MACsec packet according to IEEE 802.1AE-2006 9.12 */
-static bool macsec_validate_skb(struct sk_buff *skb, u16 icv_len)
+static bool macsec_validate_skb(struct sk_buff *skb, u16 icv_len, bool xpn)
 {
 	struct macsec_eth_header *h = (struct macsec_eth_header *)skb->data;
 	int len = skb->len - 2 * ETH_ALEN;
@@ -411,8 +411,8 @@ static bool macsec_validate_skb(struct sk_buff *skb, u16 icv_len)
 	if (h->unused)
 		return false;
 
-	/* rx.pn != 0 (figure 10-5) */
-	if (!h->packet_number)
+	/* rx.pn != 0 if not XPN (figure 10-5) */
+	if (!h->packet_number && !xpn)
 		return false;
 
 	/* length check, f) g) h) i) */
@@ -1117,7 +1117,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	secy_stats = this_cpu_ptr(macsec->stats);
 	rxsc_stats = this_cpu_ptr(rx_sc->stats);
 
-	if (!macsec_validate_skb(skb, secy->icv_len)) {
+	if (!macsec_validate_skb(skb, secy->icv_len, secy->xpn)) {
 		u64_stats_update_begin(&secy_stats->syncp);
 		secy_stats->stats.InPktsBadTag++;
 		u64_stats_update_end(&secy_stats->syncp);
-- 
2.20.1

