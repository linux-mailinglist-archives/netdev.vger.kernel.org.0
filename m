Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4EB5BB593
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 04:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiIQCak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 22:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIQCai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 22:30:38 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A13184ECC;
        Fri, 16 Sep 2022 19:30:37 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso2534536pjq.1;
        Fri, 16 Sep 2022 19:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=zFwcid0Q8E2gf9MQQjQKHEHwun7GkfVCpiWkqyhDqh4=;
        b=G8854RFIbUsqLAvs+PS5n+DTD8Di9YVJ3g/J2nlPxPCzyoP07VEGUwIe9IN7PLjN7/
         Gsnj0WUD612Gp7xtM0dZlyUO5TTGM4hEDL5cHE8DooSU/VY2OxFHPfdVMwv8OvEHRfXp
         C+RwPQXoX/7FT1bnqjnYNegaHXZeMqGCGfSlYTbmBP9xdwuZQG+sAS73R2NqVu/nnidG
         yJ6TA2a5zCpt5WKmgnmG8xjnVfaOXmCXDdF2U2mSsahy8t6Jfs+ZjFnLrfmhU1R6U+OF
         hHBVwZ53U3ZvCKbbwMa/TTucgsLuUgmiPB7iAnXuiAndsAeWLk77j3nZqNMEyF7KhDw+
         8XTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=zFwcid0Q8E2gf9MQQjQKHEHwun7GkfVCpiWkqyhDqh4=;
        b=LMK//abI6Dpw8+9Djni9d0DPQ3fa3HEEIlJzynDUlt61MbPeQQWCH8K0PVaDThavck
         K9A9gkOTwwtOWqQq6VeAfXBKEeepZaTpuTDvgLGZmMtiGv1VKBCqBi66b0KHTppvWt1S
         CF3iSQQTke9q+ARGATr47FWPi3W2w2/aiL1DLryEaeI8mdRNk5qKUm/g3CWvZjzkOqQt
         MHPYrDD5SMa1MwPHWwJvn4C/WlPJbbpBojFJqZNA/XAq4MrHXaX5d+ZtVWKGfNKYe5/8
         ARnPh+BuqXeGblu1LQVNqGg+mOKk3hke96zyHsKKPzoI8rS9P9HJC7W/mTcRpB1r1bDC
         qDyw==
X-Gm-Message-State: ACrzQf3BVlEykOZTIBZnM/ygWL6XzfbHZ5ApKu/ObLTQizxVRfGjLDZR
        LiiAMUasa494hfhWvFcSr+qXSTBKyWOnFQ==
X-Google-Smtp-Source: AMsMyM52K6PD5NHVorAXxob07dnYphcH3O0/Ww7sz7ZAXaoxTwZzNEyycs3s3xY03DQLTWNfFI4Diw==
X-Received: by 2002:a17:902:dad2:b0:178:401c:f672 with SMTP id q18-20020a170902dad200b00178401cf672mr2570615plx.168.1663381836083;
        Fri, 16 Sep 2022 19:30:36 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id m8-20020a62a208000000b005386b58c8a3sm15129454pff.100.2022.09.16.19.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 19:30:35 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH v1] net/ipv4/nexthop: check the return value of nexthop_find_by_id()
Date:   Fri, 16 Sep 2022 19:30:20 -0700
Message-Id: <20220917023020.3845137-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Check the return value of nexthop_find_by_id(), which could be NULL on
when not found. So we check to avoid null pointer dereference.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/ipv4/nexthop.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 853a75a8fbaf..9f91bb78eed5 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2445,6 +2445,10 @@ static struct nexthop *nexthop_create_group(struct net *net,
 		struct nh_info *nhi;
 
 		nhe = nexthop_find_by_id(net, entry[i].id);
+		if (!nhe) {
+			err = -EINVAL;
+			goto out_no_nh;
+		}
 		if (!nexthop_get(nhe)) {
 			err = -ENOENT;
 			goto out_no_nh;
-- 
2.25.1

