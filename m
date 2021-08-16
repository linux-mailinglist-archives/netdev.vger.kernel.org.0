Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E8E3ED1AF
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbhHPKMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbhHPKMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 06:12:17 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1515FC0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 03:11:46 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id i6so25596417edu.1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 03:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yXugY6d6T5JQ0E8sNO0/q9WRH/ek0UK4wOazUv+3iLQ=;
        b=InZAbQ1dDJW3JUG3tm2610Sm8jfyPUYpcoztYMjP3QPX6CrHuqXMLzK/lIOG9eHXzj
         XVJx/WMkrNhURHBhIuAgPtMx0M2VTQGFtbGXPMiqHX0LTXPsrXntccWmbh2HPcCdGxFR
         +3fZIMByMt0JmSB5Ui8t7oS+NYmfP361BAjXFmW2akUzQsy8+SkBQ/IeTnqsGkXjkfrJ
         fMoMdlTa0b69VVL4+zS/iXRezG2yKTrMep1xPT4HwmKblqo4G81uta6epcU6LsAOvhPC
         DomqSU+R2nra6h9rRHZrGh1z4C532asQSdb/roM0sUsGGNQu0SYlweJA0C4y7+XSu1dU
         oO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yXugY6d6T5JQ0E8sNO0/q9WRH/ek0UK4wOazUv+3iLQ=;
        b=gFDDY5YgEBAedJko5yQy8EV3IsDwbr/WEgQbTf5ogb3yOSEsuG9oOx5qxBAI/A4jXc
         3UmEMoLbZ+Ce+5CMQpsoAmiZCdES0I3Cjpwz/zniQZ/eOHMo+q4wDBVFWAoxGtDePCRM
         x1WEFZCXMnTvcCmvFYD8+pWEGwNi/EewZdXxmBBb83WV8Y3qTZYIciHK7CAN8qJV9wjw
         SJO2Qb3+Ksa5nmCcjAeR72guTvGk2RAj0RbeaFDxK/USYXzc3GFbYT/xFWmtliuVpYEZ
         Zn17G9QcmfQr3P1cHfNZclF1FBJVNHmZeI9Ssrg7DleKVBKOQnPFW7nNkC/TpySGyGGx
         Fa6g==
X-Gm-Message-State: AOAM532Zn/cnc2iTRUxSGvwImTIU52tsD+7kOZbbCMhMTfpzuP9xPloV
        JUbj1Fdiu95OJ7shNHMSBSCqDALrnw2jwMXa
X-Google-Smtp-Source: ABdhPJxXMqyssyRDAaVHKKZHAxqRTwPslVkpP4lo0zhlzblNeZyoaadY5J41kFKz1+DE7YwIPI0EzA==
X-Received: by 2002:aa7:db8b:: with SMTP id u11mr1633238edt.362.1629108704494;
        Mon, 16 Aug 2021 03:11:44 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a60sm4673779edf.59.2021.08.16.03.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 03:11:44 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 1/3] net: bridge: mcast: don't dump querier state if snooping is disabled
Date:   Mon, 16 Aug 2021 13:11:32 +0300
Message-Id: <20210816101134.577413-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816101134.577413-1-razor@blackwall.org>
References: <20210816101134.577413-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

A minor improvement to avoid dumping mcast ctx querier state if snooping
is disabled for that context (either bridge or vlan).

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 0e5d6ba03457..9bdf12635871 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2943,6 +2943,10 @@ int br_multicast_dump_querier_state(struct sk_buff *skb,
 	struct net_bridge_port *p;
 	struct nlattr *nest;
 
+	if (!br_opt_get(brmctx->br, BROPT_MULTICAST_ENABLED) ||
+	    br_multicast_ctx_vlan_global_disabled(brmctx))
+		return 0;
+
 	nest = nla_nest_start(skb, nest_attr);
 	if (!nest)
 		return -EMSGSIZE;
-- 
2.31.1

