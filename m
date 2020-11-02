Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180F82A2F71
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgKBQPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgKBQOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:14:55 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE1EC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 08:14:54 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id p22so9958526wmg.3
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 08:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YP7gpeIdOxquq/TfUCec+7EbTBaII9gjVTUVcNqSjPU=;
        b=AaGBSGvjhehUR423BN+bvavmMxSWC0jcslz8PXWQI1XmoPgaS4nFW1xD9lIqMKt6fJ
         ig21d8KFcShPzUP/t8fEo7pGj0B6s2gUgHYjWwgJIZRyTtpn5h9wG0Qz6FBwkIsLw0bL
         24hUoOXsYRm/C22dDpF7S6ZydHjBZpi11cTodG1Ywc2Ung4P2MtJm6ArmjSLh4qgyO5/
         6+TomzWOaYB/y3a/cU5XSRDD3kOaeVuZHBLe4iIK6rqQz2JfBryqGoi4b1hylhPbAnVa
         rd8uQMwnTQp9b643eLX3ctwUTkzYM5XSL1r6wcHYpGx4zaGq/mZZCS68XmJP+ybcuyqH
         NEzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YP7gpeIdOxquq/TfUCec+7EbTBaII9gjVTUVcNqSjPU=;
        b=EiEHcLmKJyU8Uhwlm53wNx9t8pU6yik3HHwRt+rmUJMUGKtzYEWAQ991zPWk94z4hc
         NOFl21rsIzMzG3Rp2FKCoiLLDaQMCmC3u6l71/ANpbfl2PDwgPXfsKtEs4BppfEHO3bT
         bfUOCw7yPMsGOJPhSh0JMvogHmo1clRwZq2YlwafYwY7RAY1YciAr+XCFPZ0Em9TlxSU
         7uXa6n20qSgcvhlAzt/cG0EMLlDtg5J1gomo+ahTvj69X8jssI5Z43Vn2bjQ8v5eOeXm
         fnFd6au6cp5my0porjj89CjRJDcH2fG5ZDWNxndnBE4a7oDoUW5G9wLwiIUZBMYwVZsj
         gY9w==
X-Gm-Message-State: AOAM531d7tdga2mZFuT8vi7K9MHt21TA/uuNonCySSEAfzd2ZNNOaFIq
        hnoGmMEj0JJCtZlW1L+nG/H8bw==
X-Google-Smtp-Source: ABdhPJw3RBVQO147VlnGF8efd93BaENdZO5NDLkR4YamM5z8tQtiVuJe8uc3wyzwHceF473tMBXz3g==
X-Received: by 2002:a05:600c:209:: with SMTP id 9mr18317719wmi.89.1604333693619;
        Mon, 02 Nov 2020 08:14:53 -0800 (PST)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id x18sm24127878wrg.4.2020.11.02.08.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:14:52 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org
Subject: [PATCH v2 3/3] xfrm/compat: Don't allocate memory with __GFP_ZERO
Date:   Mon,  2 Nov 2020 16:14:47 +0000
Message-Id: <20201102161447.1266001-4-dima@arista.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102161447.1266001-1-dima@arista.com>
References: <20201102161447.1266001-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

32-bit to 64-bit messages translator zerofies needed paddings in the
translation, the rest is the actual payload.
Don't allocate zero pages as they are not needed.

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
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

