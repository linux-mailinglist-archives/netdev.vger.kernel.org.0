Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFD8AC4C2
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 07:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394399AbfIGFaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 01:30:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36694 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394256AbfIGFaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 01:30:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id y19so8563764wrd.3
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 22:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f2s5rhtwO8YHxyDkRTSrlV6IIFRP4Xm8hU+pa5uONk4=;
        b=nHh7E8NQtmzN9NMKoDlOHwF3gy/4i6AkJGaHM4tj+0jli7P2POBedUtRfFsWTf2qaa
         i1v/NMsqwSTDq2axbZPGFB0JzwhPvwyqSkGKc3QJ3dOHwigDzHGAkH9/3gEavwKHUy2S
         gFslG6w5ytd68XL6HbyzDzUkr5iGY4Dy4/xc7CJVIFLf/Nh5ND42ItjVKFceDidu/ImS
         84M54mA9yliVMv0oJYq0+JA2eRf1U9bFBoAePlCTx/dEgGEgM4tbDCTIpKGrCU9fqEqY
         B6NUKeXojSvp+T415tw3zbMIk8EFMhYLcLtCoB4OCfWc5QHO/rwvzylj2FVjiRYkajyn
         0q2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f2s5rhtwO8YHxyDkRTSrlV6IIFRP4Xm8hU+pa5uONk4=;
        b=IF/2A28kCs1cCaHlP5bDn3AhT9pUgTVy4L0/DZ59ndmDVR53z6ncFXbdDUGgGDf4in
         nxqIARGUIJ3DtnCKQlJD4oMaTW0lsdRXol58zu+qPmtplpZp6QTt831L9a/nGoAKRMkx
         sQysnqYCZct9c+L3lb2qBgqh0/cNZ/BiKEfNaPGZ3R5wFobqEJphGGh36eSuFJ5en7ZK
         o2J+P8rN8o1bGnBpAl+7zlmmi25Nwb1Feb9Rs8VsH08cJY5mR+SH0ALNyKxGFPKfAlj+
         wl1qRCvDkZWc8Uwq9fkmE3Y9TLEwaIk5MxBE06tJR/jA1XMsCGPNNRIyAfbXPwnqhg9p
         Zc3w==
X-Gm-Message-State: APjAAAXrCXqan6NmqN2h3fgCqHh1JTqQS0O4n1lL4WGCNyDy80Uihlf1
        NBzxFCf/eDfSWP0QDSQYrkTnwQ==
X-Google-Smtp-Source: APXvYqzKui96PtaXVeM4Kv/+btM0Ccud81Yoe5Fn0FfURIPAojDiAY8P/iH9hRbt/8OIPyS2rwcDCw==
X-Received: by 2002:adf:db01:: with SMTP id s1mr6786333wri.164.1567834218748;
        Fri, 06 Sep 2019 22:30:18 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n4sm2446939wmd.45.2019.09.06.22.30.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 22:30:18 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 1/4] net/tls: unref frags in order
Date:   Fri,  6 Sep 2019 22:29:57 -0700
Message-Id: <20190907053000.23869-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190907053000.23869-1-jakub.kicinski@netronome.com>
References: <20190907053000.23869-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's generally more cache friendly to walk arrays in order,
especially those which are likely not in cache.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 41c106e45f01..285c9f9e94e4 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -122,13 +122,10 @@ static struct net_device *get_netdev_for_sock(struct sock *sk)
 
 static void destroy_record(struct tls_record_info *record)
 {
-	int nr_frags = record->num_frags;
-	skb_frag_t *frag;
+	int i;
 
-	while (nr_frags-- > 0) {
-		frag = &record->frags[nr_frags];
-		__skb_frag_unref(frag);
-	}
+	for (i = 0; i < record->num_frags; i++)
+		__skb_frag_unref(&record->frags[i]);
 	kfree(record);
 }
 
-- 
2.21.0

