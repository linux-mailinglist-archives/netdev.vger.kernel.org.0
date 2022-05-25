Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA3B534074
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 17:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiEYPgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 11:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiEYPgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 11:36:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDE96554
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 08:36:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pq9-20020a17090b3d8900b001df622bf81dso5447131pjb.3
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 08:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bu2VrtRiv5YPL5qJIl0dQ33o31yOnff58weGXh8Er4s=;
        b=AchVLP8usDKQbbsoTYXGPbBjerao5KY/8lau9DZmXV3e1dIV15KloUQWwlcQMu50/l
         nu4MDhoezVe0HHXIfBV3NBLYmUtKEyZUNTN5ljPim4q1U6CkdLvuLffCajWjjZIFdm88
         iZI+uhINlw2SVfWP7b75vHiweuF88pbPnuIC9WWQjgRRCpY+aNqJKAR36yCK4glmEgnj
         qSxhlDy4pSN232BwP+oRCV55ig9QcY7awsugBedPx7MuQuC22pZwpvONc36WD1PzD28H
         E82kRCDhmVIwvGK4fo7FOjyiHlyOyWZ3F8lBJ2hxpcKGiE+p943PNr46s4m4vXHlbIRD
         hv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bu2VrtRiv5YPL5qJIl0dQ33o31yOnff58weGXh8Er4s=;
        b=Nh+iLQkDG+E6lCkqe+49sJhVdrdleIGo8Hp5aqDEeT0PIFm2K30hd3apL2vqsmN4Ic
         rBmu9pzZGbkS82YfVHKtzKYraMklqY3UngjmCACUbT0l1Ba3Iv2Un85nNh0KGAfhrpy3
         mRYBITtz+EnyJ3FHhMEA4TaFNEoQp68MFZey0eyx0oTAuZx7oy/o1f6BT7ggUNlLW57F
         2+4Dq5GHhN11tSsd5Y55H/mmokEWeTLzcEy6Hd6ShjO6CRjuax1I/z8+4BEIW4rXzu1M
         av0IX11DdqyK3mfoO9dn4F5043JmXWdqvUeY/8jsR6P/2tNbOcLTF5qK0h4x0zbBwtHm
         fNew==
X-Gm-Message-State: AOAM530LiGQLHkrpgBB9zEqSkn6MIhIlXQ7iz6qdeJH8qklenC13RksL
        TfhUAMCQLJLFUsLGl5IFE7E=
X-Google-Smtp-Source: ABdhPJzb24HS7Bfskp75YcBABsWPtZxSSoZ6TkFRQp5lc/tA76RxUG9OBzuz8/XSuUudHQ8G6kMsbw==
X-Received: by 2002:a17:90a:940d:b0:1df:359b:2f9e with SMTP id r13-20020a17090a940d00b001df359b2f9emr10797221pjo.235.1653492987637;
        Wed, 25 May 2022 08:36:27 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d156:3c09:f297:61a8])
        by smtp.gmail.com with ESMTPSA id a15-20020a170902eccf00b0016170bb6528sm9661579plh.113.2022.05.25.08.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 08:36:27 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH iproute2] iplink: report tso_max_size and tso_max_segs
Date:   Wed, 25 May 2022 08:36:24 -0700
Message-Id: <20220525153624.1943884-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

New netlink attributes IFLA_TSO_MAX_SIZE and IFLA_TSO_MAX_SEGS
are used to report device TSO limits to user-space.

ip -d link sh dev eth0
...
   tso_max_size 65536 tso_max_segs 65535

ip -d link sh dev lo
...
   tso_max_size 524280 tso_max_segs 65535

Signed-off-by: Eric Dumazet <edumazet@google.com>
---

This compiles once include/uapi/linux/if_link.h has been synced.
It seems iproute2 maintainers prefer to sync the headers in separate patches.

 ip/ipaddress.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index a80996efdc28753da3cc80e7a90e39941a67b926..a1ade37ca2777a121f835abcdc3beeda3eb8f3a5 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1219,6 +1219,18 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 				   "gso_max_segs %u ",
 				   rta_getattr_u32(tb[IFLA_GSO_MAX_SEGS]));
 
+		if (tb[IFLA_TSO_MAX_SIZE])
+				   print_uint(PRINT_ANY,
+				   "tso_max_size",
+				   "tso_max_size %u ",
+				   rta_getattr_u32(tb[IFLA_TSO_MAX_SIZE]));
+
+		if (tb[IFLA_TSO_MAX_SEGS])
+				   print_uint(PRINT_ANY,
+				   "tso_max_segs",
+				   "tso_max_segs %u ",
+				   rta_getattr_u32(tb[IFLA_TSO_MAX_SEGS]));
+
 		if (tb[IFLA_GRO_MAX_SIZE])
 			print_uint(PRINT_ANY,
 				   "gro_max_size",
-- 
2.36.1.124.g0e6072fb45-goog

