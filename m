Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E08F2280D7
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGUNYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgGUNYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:24:08 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516B3C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 06:24:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p1so10264484pls.4
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 06:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wgx4z/DNiLcnwiVMTxlKfTLr89BUcZAmWBACQY4L4M0=;
        b=IPtVjYH+4Nl8qj0o4aNFzWOBc8gf/CsNkxwtrKnuV97gpBAP4vQDUvLkQhnl/IymTK
         qyrj6NZsozQP5Wh/LB1GqxnSVUNnrZSRjmS0UNg0wdO+LwaSWuPW/IrZzsUVvFijySMZ
         AJrAX6iI9Y9L+5VfYYMwZwp54BEJS6i+9oEXI4QN7H5MtWV12OoJ3+Z+X3K8yi17KoAS
         M1NbO1LfhHiuyYXkMhpV5eaJX6WcjB0wIR9BmSOT9vE+4WxTdBTQQPnK9ACUaw/iQCSz
         EtkaRQ4W3XJ/ZjhPgeDdmPyNX4RCtriRD4ABulFJj0/ngeXIVCqyb+NoojM9cEuXXZ22
         38vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wgx4z/DNiLcnwiVMTxlKfTLr89BUcZAmWBACQY4L4M0=;
        b=cyh+TEUY1tj70p1cB0Ew1kRO97XnhTrAz8NYYetVCtzZwGq6KPA1eBV8Gm/Zx64489
         1IZyYcd3XcHKWIuoj9yPBso/h+7rHJ25VzPxwNplLQa6jgBIOkJpwYvdpGspUHrRoDB5
         N1isyqV+DAq8RnzNBDrdIvelzC8FBQR4fQsmPYMmwAW6CTDCx4CQCe26v0ZWj5pkIVAm
         sg01CRZy+mXSCytnxZEI3So8I/x8uPUkerdttjeVzQERwcuZsHxuP3i3QpyA6g/rRsnV
         qc5lhARq4dLM5K/yIjF8M/syVlsZh9YSEBErqH63CPoDZFmRZaPIJqQ2Uc+3+Z9+d0oY
         AH9Q==
X-Gm-Message-State: AOAM531OkYkxc2fmxE/Xw2JYr94fw9A0j1/lDbCZx1o+uPY8mIRxRYQJ
        kbiRQKoH24QbXAm4cxe+9Ydpaw==
X-Google-Smtp-Source: ABdhPJwfgpV2BR8t4aLZkOMHXUhOw8u41DWYuFc0TKpk2ua8/asby494f33+AMKBrt2W09ZFdEDGyA==
X-Received: by 2002:a17:90a:a78b:: with SMTP id f11mr4608489pjq.42.1595337847865;
        Tue, 21 Jul 2020 06:24:07 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:0:4a0f:cfff:fe35:d61b])
        by smtp.gmail.com with ESMTPSA id c207sm20291090pfb.159.2020.07.21.06.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:24:07 -0700 (PDT)
From:   Mark Salyzyn <salyzyn@android.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Mark Salyzyn <salyzyn@android.com>,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: af_key: pfkey_dump needs parameter validation
Date:   Tue, 21 Jul 2020 06:23:54 -0700
Message-Id: <20200721132358.966099-1-salyzyn@android.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In pfkey_dump() dplen and splen can both be specified to access the
xfrm_address_t structure out of bounds in__xfrm_state_filter_match()
when it calls addr_match() with the indexes.  Return EINVAL if either
are out of range.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
---
Should be back ported to the stable queues because this is a out of
bounds access.

 net/key/af_key.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index b67ed3a8486c..dd2a684879de 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1849,6 +1849,13 @@ static int pfkey_dump(struct sock *sk, struct sk_buff *skb, const struct sadb_ms
 	if (ext_hdrs[SADB_X_EXT_FILTER - 1]) {
 		struct sadb_x_filter *xfilter = ext_hdrs[SADB_X_EXT_FILTER - 1];
 
+		if ((xfilter->sadb_x_filter_splen >=
+			(sizeof(xfrm_address_t) << 3)) ||
+		    (xfilter->sadb_x_filter_dplen >=
+			(sizeof(xfrm_address_t) << 3))) {
+			mutex_unlock(&pfk->dump_lock);
+			return -EINVAL;
+		}
 		filter = kmalloc(sizeof(*filter), GFP_KERNEL);
 		if (filter == NULL) {
 			mutex_unlock(&pfk->dump_lock);
-- 
2.28.0.rc0.105.gf9edc3c819-goog

