Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113A259AD2F
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 12:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344889AbiHTKYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 06:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344890AbiHTKYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 06:24:40 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C8B9AFA0;
        Sat, 20 Aug 2022 03:24:40 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p9so5245519pfq.13;
        Sat, 20 Aug 2022 03:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=nKp6cX35kKuztd9e6R2iId5aUs+2KW/yz8inHnsMuvo=;
        b=lwCp9h7qs0yB2t+2fO+OoMB0Esh49TWIWFVy/wLcZKpXSq/OSo8VO9TRPPNCFDrbCi
         K1/SZxsgpPtlQjsrPcv0oj3ctx0ehsfm1Aq023JnX6GmoEaeWKX2lcW2jvFGhHzK5csN
         GL3Fy8VjOBz35pIg/BBj8X30i2xJ/kvDampADGu++dBwJ6Jy8yBzwriduKTC+jmdogAQ
         E4y/qTzCp8u1cinpBhD5tHZ56g5FPEOVGyiYbnTNxV15pKAEn2Il0dI6myBWaPDJk289
         vKEaIf4wgFEQrCXF0edk358pQAGSK6mYaB6KbiFvAsNa5C0IXqus3wMkHYPXr1OV9TMI
         v+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=nKp6cX35kKuztd9e6R2iId5aUs+2KW/yz8inHnsMuvo=;
        b=rvDoO+xwc/N6+ZNXiTteASuAfOrP1ipSBhfMRAJ7TElGIchzDXZWb1zQ6K/MT+fqcH
         4cws6qzG5/cSxkMM+neAisijitphNBbRCAglihBfsBAwGhBM2SYE+ynEOJGoG98FtYnq
         VGcVruaL15qvugmX8qomLOY6ceIev0hQHUT679k9qXRqJsrLk29nSfOi+jBmXw4RnnT2
         Nnb1y/HEcPW/TzP3o0H8x39X3oV80EM/BuPkNF5JoDUCJYYcsCYtzBeS7vnfqKCMg8br
         9a36IaWe3GLxPh1tJfsjhDpMYHforuZFAC5nTsknutfzuMxsKPwTEeTTDQ1M8F+0K/Yh
         EtgQ==
X-Gm-Message-State: ACgBeo0iy4kGoETTooLt8c5pl38R1sDhCcHUCei2JKxyJUyDOwHyGXJc
        IGvCNDkhXdsMeH4lB9m/rhs=
X-Google-Smtp-Source: AA6agR6RBqlVk4RECNHJiBoXGnefrjUbqi5rnNTK+XOqM7E5c3qfb7afLEFYwWuGyn7saxJ9lgup2A==
X-Received: by 2002:a05:6a00:3408:b0:52f:9dd0:4b21 with SMTP id cn8-20020a056a00340800b0052f9dd04b21mr12040334pfb.39.1660991079560;
        Sat, 20 Aug 2022 03:24:39 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id c4-20020a170903234400b0016f09d217c1sm4591630plh.281.2022.08.20.03.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 03:24:39 -0700 (PDT)
From:   lily <floridsleeves@gmail.com>
To:     ziw002@eng.ucsd.edu, lizhong@ucsd.edu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     lily <floridsleeves@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: [PATCH v1] net/ipv6/addrconf.c: Check the return value of __in6_dev_get() in addrconf_type_change()
Date:   Sat, 20 Aug 2022 03:24:34 -0700
Message-Id: <20220820102434.995678-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
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

The function __in6_dev_get() could return NULL pointer. This needs to be
checked before used in ipv6_mc_remap() and ipv6_mc_unmap(). Otherwise it
could result in null pointer dereference.
---
 net/ipv6/addrconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b624e3d8c5f0..b5e490fe0bcd 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3718,6 +3718,9 @@ static void addrconf_type_change(struct net_device *dev, unsigned long event)
 
 	idev = __in6_dev_get(dev);
 
+	if(!idev)
+		return;
+	
 	if (event == NETDEV_POST_TYPE_CHANGE)
 		ipv6_mc_remap(idev);
 	else if (event == NETDEV_PRE_TYPE_CHANGE)
-- 
2.25.1

