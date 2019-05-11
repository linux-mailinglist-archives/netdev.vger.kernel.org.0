Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC6041A95B
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 22:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfEKUQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 16:16:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45707 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfEKUQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 16:16:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id b18so1197327wrq.12
        for <netdev@vger.kernel.org>; Sat, 11 May 2019 13:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RpDFMdPDM3WRjweaGGvyVDk2hIKJfB0v8xZ3hbSBjVA=;
        b=ihz8I0Gimy0vB+PXoUH25O40gufVpqrgjSGa6G+HMrCrnQm0MThNlMfHsFQ+qJ72cn
         tbvgDTYLxR0/oV5PQuoEscjXxG20tRsyhbymdLbqij8TRlonu763OP+b8bKK06akl2Uv
         C1R7hkfOMyp4jsfCJ/cY3g4SJBRk2ztHFyXGoAdJSsKeAjvLFoAQ7DefJkJhPC7OMYmm
         wgVhiSb1d3ZfDRQq2PqVm2OIPyDsmTaNf0mC5IOezwYfQb1DNX++LmxLxOEIsBOuTuqs
         tqhYpgse44TGtugYwv6ZOoTB32wJXcs8LYm7IMssnwZH5wT8ikRPWiYCu5VYRKOOyoGl
         RTgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RpDFMdPDM3WRjweaGGvyVDk2hIKJfB0v8xZ3hbSBjVA=;
        b=cUEjad453ni5nc7rOdh/1eurFrFP6UA7wylIbxtZO3Kf3nkGWb5wPkI9gEqFGvcRSu
         bRjSfg73Crjbrk/2GrbwYqrOYmpIRX3SIGcOgO6ytJffOah5/xy6xqM/vfvHFZ/181EX
         hrbVTXC+KARZKvWO05hmEi6BSJEdBplgteQWqNMdKHOiaj1weafnXZz5ziubAOpXdWBx
         9co5quUVepi9nyESSq4uRXgPhJh4HXwNk3cyz9ioA6mAaEhX90TKHZFKCmT8hCQPK9Xq
         ZPrqeG7f45t+Z36fTLIL3CigO5uwrGD2vYfpVRi7W8PTKO5sjZf2jdii7c9tJPcUMza6
         9bIw==
X-Gm-Message-State: APjAAAWlepsHFq6itxLMgTUB0DMsSNt50/STES6pAsQ+SVri8U1DX99r
        M3YMVbDCncVAifNRWSJoi+o=
X-Google-Smtp-Source: APXvYqx609VHwycgwJ9CzRsN2wvXGwzFRsvQEqocIbtrFeEjUCWdkaTeE7JZ44fM5JnvvuuKfZ3rMQ==
X-Received: by 2002:a5d:420a:: with SMTP id n10mr11648898wrq.325.1557605770137;
        Sat, 11 May 2019 13:16:10 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id c20sm11853275wre.28.2019.05.11.13.16.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 13:16:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 1/3] net: dsa: Initialize DSA_SKB_CB(skb)->deferred_xmit variable
Date:   Sat, 11 May 2019 23:14:45 +0300
Message-Id: <20190511201447.15662-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190511201447.15662-1-olteanv@gmail.com>
References: <20190511201447.15662-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sk_buff control block can have any contents on xmit put there by the
stack, so initialization is mandatory, since we are checking its value
after the actual DSA xmit (the tagger may have changed it).

The DSA_SKB_ZERO() macro could have been used for this purpose, but:
- Zeroizing a 48-byte memory region in the hotpath is best avoided.
- It would have triggered a warning with newer compilers since
  __dsa_skb_cb contains a structure within a structure, and the {0}
  initializer was incorrect for that purpose.

So simply remove the DSA_SKB_ZERO() macro and initialize the
deferred_xmit variable by hand (which should be done for all further
dsa_skb_cb variables which need initialization - currently none - to
avoid the performance penalty).

Fixes: 97a69a0dea9a ("net: dsa: Add support for deferred xmit")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h | 3 ---
 net/dsa/slave.c   | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6aaaadd6a413..35ca1f2c6e28 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -102,9 +102,6 @@ struct __dsa_skb_cb {
 #define DSA_SKB_CB_COPY(nskb, skb)		\
 	{ *__DSA_SKB_CB(nskb) = *__DSA_SKB_CB(skb); }
 
-#define DSA_SKB_CB_ZERO(skb)			\
-	{ *__DSA_SKB_CB(skb) = (struct __dsa_skb_cb) {0}; }
-
 #define DSA_SKB_CB_PRIV(skb)			\
 	((void *)(skb)->cb + offsetof(struct __dsa_skb_cb, priv))
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index fe7b6a62e8f1..9892ca1f6859 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -463,6 +463,8 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	s->tx_bytes += skb->len;
 	u64_stats_update_end(&s->syncp);
 
+	DSA_SKB_CB(skb)->deferred_xmit = false;
+
 	/* Identify PTP protocol packets, clone them, and pass them to the
 	 * switch driver
 	 */
-- 
2.17.1

