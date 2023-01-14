Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DC666ACA5
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 17:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjANQe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 11:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjANQeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 11:34:24 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BDC558B
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 08:34:23 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d15so26370983pls.6
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 08:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAWCEh2Sg/ca4zDkccA/HyXugy+m4RYAciqyOUmIt98=;
        b=dw6jChuvzMhHjmluOW0wyTz4/lAQKARipVuXcBw0rLQ11L1NGLKwJbiyqyu+4bO78v
         7gaFVs/4YlsWPiop/bsTQZR91F/ROcD7UfhNUmJm7mYvMz9nAMIWUmx5XneQQJvOJZpi
         pzSI5Rh5mWum+r00uAeZjHZdts7lQ9mQBodjoC/BZxLG8rRytB0JOf6KqVmegxey6PQp
         7/ShfuyUp92w2zWdOU+ovQxien6XEBUAfFRLtxXFJfwm6AMORjblLHXq0CJhzLFepJ/l
         f1ODJHqDzmJkEkVdHSOkeaxlTobXcHvkuGXRIdFT1eYDdirb2blv1XOPMPcdgsP8yfOH
         /hfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uAWCEh2Sg/ca4zDkccA/HyXugy+m4RYAciqyOUmIt98=;
        b=VhRCT/F7lnsmhMRudN+WgWZ9dcWacY9wOyWmJitlU8ppGBH/0URgBDtfFTIiZay7cG
         yUAPIGyhq5lcfKv63h8HO4nrJDVb8xMQijqq2lnXdoYR7DkRwyMhyavFFHUVrksflchA
         kGmQSHS4RuGOzkJHlA+3Wb0FE3cibhd0z9MIJg/gFu6OaYVkh7nmKEYomZFPAErXg+xW
         4UimhFta/9m6gjv/JkG24Poc1fBqOI+ctFnA2AdcgE6ScriJH4MTAkYntdLjx+lc+OB0
         dhyBvLj/GXISotKSFQDiSanwm84I+JU8erk4qzty5kLy1MTCPZlDc3WfUBq9zWY79sMO
         jHBQ==
X-Gm-Message-State: AFqh2kq+wwga8n8tHzVpm5cztUHOYxExBZTt4OpP2NhgR9uYFp+79Kst
        cJRVtsCQ+3ewXW/CjF+cdScm7pscFis=
X-Google-Smtp-Source: AMrXdXs+/txpq9mMZmlszMx555HtHQexbhK+mf/HzmE3/qt+Pc+08u9j33/LmESuWzQdFqoH9YLdGw==
X-Received: by 2002:a17:90a:aa84:b0:227:1a22:d182 with SMTP id l4-20020a17090aaa8400b002271a22d182mr22145984pjq.42.1673714062598;
        Sat, 14 Jan 2023 08:34:22 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z7-20020a17090ad78700b002270155254csm11864797pju.24.2023.01.14.08.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 08:34:21 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool v2 2/3] netlink: Fix maybe uninitialized 'meters' variable
Date:   Sat, 14 Jan 2023 08:34:10 -0800
Message-Id: <20230114163411.3290201-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230114163411.3290201-1-f.fainelli@gmail.com>
References: <20230114163411.3290201-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC12 warns that 'meters' may be uninitialized, initialize it
accordingly.

Fixes: 9561db9b76f4 ("Add cable test TDR support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 netlink/parser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/parser.c b/netlink/parser.c
index f982f229a040..6f863610a490 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -237,7 +237,7 @@ int nl_parse_direct_m2cm(struct nl_context *nlctx, uint16_t type,
 			 struct nl_msg_buff *msgbuff, void *dest)
 {
 	const char *arg = *nlctx->argp;
-	float meters;
+	float meters = 0.0;
 	uint32_t cm;
 	int ret;
 
-- 
2.25.1

