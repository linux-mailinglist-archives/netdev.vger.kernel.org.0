Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715EA2C57E5
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390020AbgKZPM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389316AbgKZPM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 10:12:26 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E8BC0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 07:12:25 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id v143so1808219qkb.2
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 07:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s0mSLXkveRT/Z0N1TE7U+YTX79J1JxSJIuUnFkkISm4=;
        b=ti8u/E8ub4+XRhB9jlOCi/l3Y+uJAIRvomaFQ56Sw8Gn+1JnQNFXKuWO0Aos66Fekt
         DJzTpVJyajLtRup/e3vkBgHZb3HQZ/9ry56uE+bi37ZawpF+AVV2wT+9N2zaNnHmUajk
         XS1sSk0O8ac/S6IYAlcdc8GigXfbAwXkhkttkPGOvottQnuw/DuoW/RC8ousyAO8biv0
         a48O/KMuMB44AZDXkdhQcpq4e0IdmB/xl2GyBmd4miRemunkYuCd7tElF8wmcVSKJiqD
         7vpPjnWC2/Oabbq1pOJNPIZMJHFW23crTlybqR3EFN40Cr1DmziMSOJ05WZ9tnGK1Qs5
         0QnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s0mSLXkveRT/Z0N1TE7U+YTX79J1JxSJIuUnFkkISm4=;
        b=UJl7M8bAnIiaQRvBzMH+g6N5SZFtfQKTk4vXbDzWaHqhFWG8NUE4dQo09PSQtcEZIL
         ykYdPKWliQl/blKfbyzlX5P1uh2NDFSMUYZEAnCthxnDJb4H/NY0DkGcybq9Mo51toJS
         iDwLI8x4xDmdo8CoPUb2Zq6IW0uFP2KLsTtB4wYuF02TP9Th85S+u+Bdxr4Lebn6ZlvU
         DXqg+/TnnaeuDclsdrLEZwITkdLakytnFAO7lAz7B0pCmOLa3iGy5ztf4KdSlZ7dcGOf
         ecZtpUFSxn+haPmUaxXJmRbpAb0Apc+YOZbh0ijSTbqcRVZe9FrbZCK0+21vkouN9S6n
         CoAA==
X-Gm-Message-State: AOAM532p8j5sKDPzZlM70ef/DpP+DxVF6YXK/qXY7FCvhgsQV3mV6L/u
        2eeX4QXdvZyNKU++ZjmoI3Z2IFKiZ/4=
X-Google-Smtp-Source: ABdhPJwa/hP5A6MiXOxOoi3OBm2DAdWqgoeChA5ckFxzXhHI1hZY7n8XnvgItvrCWzqn8KkSHd0Paw==
X-Received: by 2002:a37:9947:: with SMTP id b68mr3609201qke.70.1606403544500;
        Thu, 26 Nov 2020 07:12:24 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id d48sm3181329qta.26.2020.11.26.07.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 07:12:22 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, soheil@google.com,
        Willem de Bruijn <willemb@google.com>,
        Ayush Ranjan <ayushranjan@google.com>
Subject: [PATCH net] sock: set sk_err to ee_errno on dequeue from errq
Date:   Thu, 26 Nov 2020 10:12:20 -0500
Message-Id: <20201126151220.2819322-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

When setting sk_err, set it to ee_errno, not ee_origin.

Commit f5f99309fa74 ("sock: do not set sk_err in
sock_dequeue_err_skb") disabled updating sk_err on errq dequeue,
which is correct for most error types (origins):

  -       sk->sk_err = err;

Commit 38b257938ac6 ("sock: reset sk_err when the error queue is
empty") reenabled the behavior for IMCP origins, which do require it:

  +       if (icmp_next)
  +               sk->sk_err = SKB_EXT_ERR(skb_next)->ee.ee_origin;

But read from ee_errno.

Fixes: 38b257938ac6 ("sock: reset sk_err when the error queue is empty")
Reported-by: Ayush Ranjan <ayushranjan@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1ba8f0163744..06c526e0d810 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4549,7 +4549,7 @@ struct sk_buff *sock_dequeue_err_skb(struct sock *sk)
 	if (skb && (skb_next = skb_peek(q))) {
 		icmp_next = is_icmp_err_skb(skb_next);
 		if (icmp_next)
-			sk->sk_err = SKB_EXT_ERR(skb_next)->ee.ee_origin;
+			sk->sk_err = SKB_EXT_ERR(skb_next)->ee.ee_errno;
 	}
 	spin_unlock_irqrestore(&q->lock, flags);
 
-- 
2.29.2.454.gaff20da3a2-goog

