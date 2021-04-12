Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3942C35B7C8
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbhDLAie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:38:34 -0400
Received: from mail-ej1-f53.google.com ([209.85.218.53]:39860 "EHLO
        mail-ej1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbhDLAie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 20:38:34 -0400
Received: by mail-ej1-f53.google.com with SMTP id v6so16145238ejo.6;
        Sun, 11 Apr 2021 17:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HY433txR2TPxtfhAmq6V4OY/PH9A7hXTvBzJvxSGgpo=;
        b=JWAgDDfOuy30qHhP77vyeg2ocrjX3akSHKsOdws5RN0z++RO2UGc2wM9E+FSsiCYcO
         2Nxgp5aSr+kFgHNFIsbbu2YY5ALrthtcLfEx7T/CllCYIfa2arRognio9z0ln/qrz3Kt
         n0aX7BjAk5rR+0SKVSljF6/KvAVUHa3qx9L2cVOIuFuSWcLFCXD0lC/nqllp5F2SepQ5
         4NwtWbZ1jjqBzLncJWp60OUposGfkkFf8RnxGCBR3eir+d7x/fKGqYEHXUq6yxA5zfo2
         Ky6S3cZ9P3+eCgZGUb22JKlGeJ5z0wFe5k6ecQe+Zwa/M2BUTgIj4wm7KNxZkUSJ14t8
         6BFg==
X-Gm-Message-State: AOAM532hinKhDbK2qIs9CnTCcJv5Oe8Lzmfnw9tRtnHJ8rOLkuR0Ahbq
        kl1ETUWsz54iqJLGPerAHWfomWbWe6M=
X-Google-Smtp-Source: ABdhPJwMBUGPZsqotj1GQ/KewY8JQCMukEDmOVIDDY4DUOARrLTPH2r13wJioaPO/K7RBibbdfrqIQ==
X-Received: by 2002:a17:906:d04d:: with SMTP id bo13mr24938194ejb.157.1618187894741;
        Sun, 11 Apr 2021 17:38:14 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id a9sm5477837eds.33.2021.04.11.17.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 17:38:14 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH net-next v2 1/3] skbuff: add helper to walk over the fraglist
Date:   Mon, 12 Apr 2021 02:38:00 +0200
Message-Id: <20210412003802.51613-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412003802.51613-1-mcroce@linux.microsoft.com>
References: <20210412003802.51613-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Add an skb_for_each_frag() macro to iterate on SKB fragments.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 include/linux/skbuff.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dbf820a50a39..a8d4ccacdda5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1528,6 +1528,10 @@ static inline void skb_mark_not_on_list(struct sk_buff *skb)
 	for ((skb) = (first), (next_skb) = (skb) ? (skb)->next : NULL; (skb);  \
 	     (skb) = (next_skb), (next_skb) = (skb) ? (skb)->next : NULL)
 
+/* Iterate through skb fragments. */
+#define skb_for_each_frag(skb, __i) \
+	for (__i = 0; __i < skb_shinfo(skb)->nr_frags; __i++)
+
 static inline void skb_list_del_init(struct sk_buff *skb)
 {
 	__list_del_entry(&skb->list);
-- 
2.30.2

