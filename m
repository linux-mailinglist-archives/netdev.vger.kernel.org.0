Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C16633C76
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbiKVM3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKVM3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:29:46 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36343450BF;
        Tue, 22 Nov 2022 04:29:45 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id f13so1818958lfa.6;
        Tue, 22 Nov 2022 04:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qG9k0HLJtBKzDnSY86wVSnvV+i9S7/oBKCID23f+3EQ=;
        b=ZfERH2OQIOYLGULfO5tULnn8BtI9Fxe1ZQdtKpjLnpoasPcc5Dd0xOcUnXDO7AJkFQ
         OZz+/9xuK8faMsN9dDPK+6vuxhwAHyXVW8D7tasLXUzhs4oZoAAkzfBwOZEQ0FN5KRAl
         qopbsX2DVWqApQozSK48JzE36zHBhb7ImQTSBvx5iONwTGWGQgfrqEiFbxsfML/NFl/b
         DmLlzoeqbqiID72ASK5EacsK4ZuP322rOi4XN2NgO99PL/zQxje0ACpGrnM3+IwrCg+m
         SkH0t5wwS0m5mS1/mQuJQ4s6Ghf0cn2/bi4IS0QaE2ST3O6EUYgmxCEZf/165VhB8iNV
         wYEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qG9k0HLJtBKzDnSY86wVSnvV+i9S7/oBKCID23f+3EQ=;
        b=OsD9v6n7jau+O08bzO9wWqXEgXgMIsgSiJajeHibqT0HjlOf9Bsyc7zzjCTvBHBL77
         FRP8c2HiWkYSYATWb6heeZzm6qGdKsW/jQtKtJka1pDLDe3NvbQcQ9RFlW6Qx7gbJXso
         Si1RrhDK7TWQF2AZ2GbBG8u+Z7aojFzj9aIdTxtgDWIQSTrFQkwVoJGkb7ZASAzGu7VK
         K9gtJ6c+hdrpPh1y7T0kZU9x3axS7ywvJsF07zGq8+hJs/JPREWTXEu46IxlPh14OC4t
         IcsgP7lx0r/ll4O1dtGCIK2LpN1kN+yrMIHB+XYvcUHxDJoQ7hvA/sFctrWxM3ZqVsRM
         2WWw==
X-Gm-Message-State: ANoB5pnILMwjBFVbK2o9ARzDKljuO8l90i568WBY744wUadwQCt7df6H
        mmV4SF6rxEqkJo07xvzuoB8=
X-Google-Smtp-Source: AA0mqf6cIZ+AdRctQhtWsFiZp2CrpVinQr9cyIkZb+8z9ng57+u3o/xS4TeDE7glEv4F62amVq4Nyw==
X-Received: by 2002:a05:6512:489:b0:4b4:9193:1caf with SMTP id v9-20020a056512048900b004b491931cafmr1422091lfq.300.1669120181759;
        Tue, 22 Nov 2022 04:29:41 -0800 (PST)
Received: from mkor.rasu.local ([212.22.67.162])
        by smtp.gmail.com with ESMTPSA id c16-20020a056512075000b0049462af8614sm2462897lfs.145.2022.11.22.04.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 04:29:41 -0800 (PST)
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH v3] ethtool: avoiding integer overflow in ethtool_phys_id()
Date:   Tue, 22 Nov 2022 15:29:01 +0300
Message-Id: <20221122122901.22294-1-korotkov.maxim.s@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of an arithmetic expression "n * id.data" is subject
to possible overflow due to a failure to cast operands to a larger data
type before performing arithmetic. Used macro for multiplication instead
operator for avoiding overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
---
 net/ethtool/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 6a7308de192d..6b59e7a1c906 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2007,7 +2007,8 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	} else {
 		/* Driver expects to be called at twice the frequency in rc */
 		int n = rc * 2, interval = HZ / n;
-		u64 count = n * id.data, i = 0;
+		u64 count = mul_u32_u32(n, id.data);
+		u64 i = 0;
 
 		do {
 			rtnl_lock();
-- 
2.17.1

