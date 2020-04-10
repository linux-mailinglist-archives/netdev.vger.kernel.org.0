Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885521A4431
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgDJJGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:06:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44447 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgDJJGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 05:06:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id h11so472979plr.11
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 02:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9JXL6DTBBodY+9s1LEYX0fJQL0O4X5XxRYE+Fym9jX8=;
        b=cj/ggrKZp5s/OKMnqZryMQqrHqEMDLAWVwNTPqk6bSVLllJCxgLmciKynqUozqDTv2
         L9w2rUvrD9Ygm1ZeLZUY5gtfGrqIL3/YG1Ex86v1fevWuoMhTGlvvWtBIOdQhC5/V9UH
         c01nuRzwG5xDLl6m+oKYi+c52T9t155GD7pDnO6blEIssC9Qa0Z/TVZKlSYH+qZTbeqP
         N93VeilyA9X/nfX/wEsu135pt5164JaxAoiIjWL46et7HEsPeRZAI+mCcvn/jaXOTG9/
         X7ZhPgZXUeNiQuQXfS3qXAQDEtTyQnWQgRKOG3jW1/aIhJpLpbbgBdJ8KY740PS8ub8V
         Xqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9JXL6DTBBodY+9s1LEYX0fJQL0O4X5XxRYE+Fym9jX8=;
        b=gVauequdNT1ngOIvYnfFoY90qzCfvyvwCqfxiQ09usBOsf8D2NT0U/yf0Cc9iUAUEs
         d1jbZJMhHKkQ3VGc2SGoP4+YWPBvMDHPdkpmPFxk39J/EW8Ro1dov99rS/YwoLhfMLgk
         ATcPZYpvL7PpmV8PJLGC3SXvP8u8oXu43xEOvhGKwN1/8XQbFfrwRlY/YWM7SK8y9vOx
         1abBuUBb+Y3weIk6kpI9QIo0Xm/IX71PQ5nUddCO41MLbPeUEIr19ygCrD1DcV+/D5PJ
         DagnHGmhyumQnozvsA6k8fLz88VeDSgHnfStegcBvBLPUY80wVVH+IZ4zsy6nvM0aXnV
         6Y2A==
X-Gm-Message-State: AGi0PuZgWlMfNeWSEiYaY9NMvO8TKEqLPSeSOfPwUQO+tg46a4wZixNJ
        Yu9Z0ki4Njh18O5/+T00KErWs17s
X-Google-Smtp-Source: APiQypKpqxse2NBZ4ffjPFSfPvNX6feWbCUAwIw+8dC6wjKnkiyNrg9yDWPVFEUmwTdtdOWhweQN7g==
X-Received: by 2002:a17:90a:94c8:: with SMTP id j8mr4340056pjw.155.1586509569775;
        Fri, 10 Apr 2020 02:06:09 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s26sm37479pga.71.2020.04.10.02.06.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2020 02:06:09 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input
Date:   Fri, 10 Apr 2020 17:06:01 +0800
Message-Id: <ba8d9777f2da2906e744cace0836dc579190ccd7.1586509561.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For beet mode, when it's ipv6 inner address with nexthdrs set,
the packet format might be:

    ----------------------------------------------------
    | outer  |     | dest |     |      |  ESP    | ESP |
    | IP hdr | ESP | opts.| TCP | Data | Trailer | ICV |
    ----------------------------------------------------

The nexthdr from ESP could be NEXTHDR_HOP(0), so it should
continue processing the packet when nexthdr returns 0 in
xfrm_input(). Otherwise, when ipv6 nexthdr is set, the
packet will be dropped.

I don't see any error cases that nexthdr may return 0. So
fix it by removing the check for nexthdr == 0.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index aa35f23..8a202c44 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -644,7 +644,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		dev_put(skb->dev);
 
 		spin_lock(&x->lock);
-		if (nexthdr <= 0) {
+		if (nexthdr < 0) {
 			if (nexthdr == -EBADMSG) {
 				xfrm_audit_state_icvfail(x, skb,
 							 x->type->proto);
-- 
2.1.0

