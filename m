Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396ED29FB32
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgJ3C0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgJ3C0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:26:09 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7B0C0613D4
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 19:26:07 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c18so1554799wme.2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 19:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0dSc/u2vFyuVIH9pLeGn6Txj8jzDcQIh2Oq8sqMcN9Q=;
        b=Q4jgCNbSL6ILYvuVYYrVqY1MX9KZDszP7B3nuS9o1g6DunZxcLKcvv3TOx2EHN4Jwr
         ZnoVlEFesIz7vpMBIuU5eYzLKKBKmoUz1yesKc2iDDFkY8T8IFJtQw8OtnmNj0+5pk+/
         OY0KNi5DAWwixvYn+dnm3tsJO+4W4Kbre3ZRDNh8FEdI+FwDe+3DBi4CVQmfZL9NrPlc
         Bk0e9O8g7WvvSRQMHGj+Nm+9jxeaqJ/XU08/HlAdeYzHbq1i01A9nFsc16DOBAkXvmBL
         E+CFXkfPHFrV4FPbjzUVUe2zIQbDyEbzL/s/9NhIl1Lr3T+yMNoK5D9akT7OFwOTzSFf
         RG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0dSc/u2vFyuVIH9pLeGn6Txj8jzDcQIh2Oq8sqMcN9Q=;
        b=cB0rTFrZynAnAB3s9BfVVdxDL0kVeHvQJ0AgFJKLsNyD4tmhcihFqaDzRZx3PPgQaq
         1jg6YEKSudmDjCtpz910GBe9qMQYxuwbn16irKOrTShOFZ7+M3tDrgEHpFJtWYhaN+7a
         qRJlTJSn/8ifX7f93jyQoDSZoNdWpUZlOfBwSVy8jotOSUoUojzmDSCSF9kWszt0Lpeu
         R36gDnVYUua9ilAQSg7fuOKVYE5VDNPCVMmtCzbuPfzQWfxa245VDXzWHexFejjnaiAX
         rQda0iQXlTM7V1gtc7TCWYCOcXpo7CAxeuU+TDv9aSEw8m+PZLsNZJxCjXpQJWjoGSvc
         yRJg==
X-Gm-Message-State: AOAM530t5kJkF62l+1X2AjCVVO6eCJpTv4mbaDCiMo93NAr3p5AFXluC
        k8duv699n0j8kgck2V9NlRY13A==
X-Google-Smtp-Source: ABdhPJxu5DIa8TSCGmWh7GBS45lYXSHm2gfDhUjPWeZLCdWfEtvt3xCJm0a9LMNPck06YNScmAbsPw==
X-Received: by 2002:a05:600c:22d9:: with SMTP id 25mr1942017wmg.21.1604024766044;
        Thu, 29 Oct 2020 19:26:06 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id i14sm2757170wml.24.2020.10.29.19.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 19:26:05 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org
Subject: [PATCH 3/3] xfrm/compat: Don't allocate memory with __GFP_ZERO
Date:   Fri, 30 Oct 2020 02:26:00 +0000
Message-Id: <20201030022600.724932-4-dima@arista.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030022600.724932-1-dima@arista.com>
References: <20201030022600.724932-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

32-bit to 64-bit messages translator zerofies needed paddings in the
translation, the rest is the actual payload.
Don't allocate zero pages as they are not needed.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/xfrm/xfrm_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index 556e9f33b815..d8e8a11ca845 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -564,7 +564,7 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 		return NULL;
 
 	len += NLMSG_HDRLEN;
-	h64 = kvmalloc(len, GFP_KERNEL | __GFP_ZERO);
+	h64 = kvmalloc(len, GFP_KERNEL);
 	if (!h64)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.28.0

