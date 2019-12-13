Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F7411E6EB
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfLMPrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:47:47 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33361 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbfLMPrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:47:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id b6so7198122wrq.0
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 07:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zy/1vxmK7IESgZ5MufAb5lMH5M1hrx2tBtD49AP8IGg=;
        b=EwfZKJpHgTZfq2oP7jePrJKUK8ZNAm4PsQGN32QF3UGr1NkO0kMWQMhpx3xpKJd4k2
         qCENKuKt9VkU+QR6qzO73xgYJPkZkW515/0DMsa4G85AiuMp+AxljrIpsZKE+TY8ngmk
         /8dv3fPgl/f9PgecfmougTtKhSdBMssa8PEsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zy/1vxmK7IESgZ5MufAb5lMH5M1hrx2tBtD49AP8IGg=;
        b=sNnLSgoiomXdY62G2wL9Yej2bExbRyy39Qo5uIMjxJHdGzvLuFlVilkQz+3+QQSUs9
         FTkbIMQQD/adcRCTIciTf5Ad+2yEVSiEFbkmGj9A1+QEXo3LpQdrhz7OyTMsDEdRn3Np
         j8XT2bYw7wD+QWHIoiBjd/QIf8q8SFHlDFrqM1mNgVOulwoJQ3cIVjfwu6NDxDOt8gXW
         uOPezPiCHN6yVJn8s+293TmNoImxqRMVQKi2XSkUeJ95S0v1cXhny9RkaljN79vNSrs5
         yeGdC5SMEbGHD4XYBc0DcI3U0gPosaB7upuBVRjDqfYDHnEQZQ5novBM7nsJ5GP3Bl2w
         A/Eg==
X-Gm-Message-State: APjAAAUe4z7n2jTGlgf5hbNcXmfG7WflFr81I8M4K9egY8gCj2/XwuqF
        3YyS/nJpcms6kbyiVtQgi0JU1w==
X-Google-Smtp-Source: APXvYqxDDCsPNF553NwXAaiIZEZtJCqKHvMMr8OTf4QdQlkxPgrUbkSbZGoxyJoE0pe94MnpErfvJQ==
X-Received: by 2002:adf:f3d0:: with SMTP id g16mr14079175wrp.2.1576252064539;
        Fri, 13 Dec 2019 07:47:44 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:3da5:43ec:24b:e240])
        by smtp.gmail.com with ESMTPSA id s8sm10140295wrt.57.2019.12.13.07.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:47:43 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net,
        "David S. Miller" <davem@davemloft.net>,
        Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Richard Cochran <rcochran@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf] bpf: clear skb->tstamp in bpf_redirect when necessary
Date:   Fri, 13 Dec 2019 15:46:34 +0000
Message-Id: <20191213154634.27338-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Redirecting a packet from ingress to egress by using bpf_redirect
breaks if the egress interface has an fq qdisc installed. This is the same
problem as fixed in 8203e2d8 ("net: clear skb->tstamp in forwarding paths").

Clear skb->tstamp when redirecting into the egress path.

Fixes: 80b14de ("net: Add a new socket option for a future transmit time.")
Fixes: fb420d5 ("tcp/fq: move back to CLOCK_MONOTONIC")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 net/core/filter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index f1e703eed3d2..d914257763b5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2055,6 +2055,7 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
 	}
 
 	skb->dev = dev;
+	skb->tstamp = 0;
 
 	dev_xmit_recursion_inc();
 	ret = dev_queue_xmit(skb);
-- 
2.20.1

