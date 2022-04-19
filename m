Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED2350693E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349052AbiDSLCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349139AbiDSLCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:02:14 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B4E1C910
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:59:31 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id j8so15377270pll.11
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iYXC99B6/QBZVx8POjQwakPzlm8KJ7uY65Fo+GcZWDo=;
        b=Icj0szRdj9L+BP2I9HxNxECDXNZ9SbwSVsWpJwtieNjZj3LQv94HL6dI6EpDigpc0Q
         4M6fVT1wumK6vKE/Nv0vE+v+Kn0p4n1kYXft9KuJKsiq0aCXOJd0N69uqjPYcQzq3tsP
         WriMtBdobdto8Zv/zxCmm75FjgbG8KiCcIwL60ZqJnTGbqKpf84Io12JHsL4786KjYTc
         hU4Fe5yifK53FjaQJighJno4JSMQmGd0TVOMAEGoicxwl3rJSsJPyJRNbaxpuU1lME4p
         e02+hG0E1twcMmmTijg7LaTl4tibwycX6RNxE/X/4LzCVzJprqsEjbKacRoI6pbnaFF/
         6Cuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iYXC99B6/QBZVx8POjQwakPzlm8KJ7uY65Fo+GcZWDo=;
        b=0nysU6odM1X+crFWhh+P/2k1VlAVxT+FFiqlGyWyPk6qYv1OPJ5tJVSXIJDd0oZAMY
         ftVgqmMctDRASJbHQQ6EW4TfxlDr16mOZqdLxTths1/w2WVtzpucdEAUZ8ATCn9+aiIB
         biLdcqd3+jYYHgpVakNxu0I50z/anbexcYGWa9m1uh0x9LJ8iK4oy0q5XV1DZztZ4M01
         CwXNGr7SnCY0HatAgp4KWZKKr9sHDf4UZ2yIrehVmuiseRgeoF4elXRt6tgZcrxakari
         nIrRE4K/4QitpsRtKaZnP5lE3+EznU0lDWFlgNqSJxb8exrYoj3bAgHEIZRyg+gNyHje
         IqXQ==
X-Gm-Message-State: AOAM532NmR4rRS4YJembwma90n1MN5EliykUQvVUG6dhdykWq4kHPlbO
        72zvS5xp869VBiO3MP7Z/WQnnNfRVlN+UA==
X-Google-Smtp-Source: ABdhPJw8GAKzkWDVFjgiWUZG4OOYCj3yh3y7UH9wsvRIpp0bySKAxhzWWQGXsH3s39xPqQYwlc1URw==
X-Received: by 2002:a17:902:ccd0:b0:156:7ac2:5600 with SMTP id z16-20020a170902ccd000b001567ac25600mr15239886ple.156.1650365970826;
        Tue, 19 Apr 2022 03:59:30 -0700 (PDT)
Received: from localhost.localdomain ([49.37.166.144])
        by smtp.gmail.com with ESMTPSA id q203-20020a632ad4000000b003987c421eb2sm16503626pgq.34.2022.04.19.03.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 03:59:29 -0700 (PDT)
From:   Arun Ajith S <aajith@arista.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, aajith@arista.com
Subject: [PATCH net-next] net/ipv6: Enforce limits for accept_unsolicited_na sysctl
Date:   Tue, 19 Apr 2022 10:59:10 +0000
Message-Id: <20220419105910.686-1-aajith@arista.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix mistake in the original patch where limits were specified but the
handler didn't take care of the limits.

Signed-off-by: Arun Ajith S <aajith@arista.com>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6473dc84b71d..f01b8a3e1952 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7043,7 +7043,7 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.data		= &ipv6_devconf.accept_unsolicited_na,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (void *)SYSCTL_ZERO,
 		.extra2		= (void *)SYSCTL_ONE,
 	},
-- 
2.27.0

