Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218B835A530
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhDISGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:06:38 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:40956 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbhDISGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:06:37 -0400
Received: by mail-ed1-f50.google.com with SMTP id w23so7565257edx.7;
        Fri, 09 Apr 2021 11:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HY433txR2TPxtfhAmq6V4OY/PH9A7hXTvBzJvxSGgpo=;
        b=ue/P7d95FaSn8T6Si7V3Av7Gj+pCN5FoDIUNXcp7UctA1Sp1mNNoX9gYad+o2ePCo0
         hQN+SN8EPAXm9mPfoR6e+bNglehCIXHZvXmN+R+JwZgFyxZqO7RX2mZrrRdVatCQh69R
         Pq8aSjPZUblQqw0QL5f+7zrfLiMOufvc6BqIAAP2ONY4MgHHEm15v1GjWLYVfmSPIlwx
         RzsG3FDIvFkgVUdVBE0ujBVwyZshXzcqr6TPBgyMOFRoCyBeq980bV9Z3uAlsmKrDCcD
         J+nBsvpsD3WULp55OcyJwyazvWDqYl0GoxFBB6FqjRMZEQymVHQI/x7ipDFlFM5x71j+
         dDtw==
X-Gm-Message-State: AOAM533f/8dIipzQA0NfqkJ1DKk5LdwRO4ZX/j2/VP7Ka5AI2RWgmbHk
        M68XUiDLQ3+iXD1URtudaH9p4cWKIAk=
X-Google-Smtp-Source: ABdhPJzU4XeBiIcjIs2Hwgf+96KOFrMiJI/+rgHKP0RCyXVVu3JT8Q2fM4K9UF49RQzylEe0IHzFOw==
X-Received: by 2002:a50:e887:: with SMTP id f7mr18211092edn.107.1617991582918;
        Fri, 09 Apr 2021 11:06:22 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id k26sm1571383ejc.23.2021.04.09.11.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:06:22 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH net-next 1/3] skbuff: add helper to walk over the fraglist
Date:   Fri,  9 Apr 2021 20:06:03 +0200
Message-Id: <20210409180605.78599-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210409180605.78599-1-mcroce@linux.microsoft.com>
References: <20210409180605.78599-1-mcroce@linux.microsoft.com>
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

