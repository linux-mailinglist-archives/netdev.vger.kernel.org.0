Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5527F220664
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 09:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgGOHld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 03:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729036AbgGOHlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 03:41:32 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A79C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 00:41:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so4352400wme.5
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 00:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=fPZAAh6XsmYVOwEtQ9QgTBMrLWPHTOlempZ6e2w/4sU=;
        b=XPTbra3ZOzVgnz5JAKFC8v0Agx2i05NYi4IOxJjdCn+CJ3soiT4ZTYkL9OfYp7qT3v
         6xigK5yRETDbWC2odMm2ahd/ZEEyNWbaBxUpT61j5wTjSP9J5DvOa2xKfMR76dai1lzE
         4/uAUhebVItP0adiJSFxvM8DAixnd5wBvS1iMQjvIe9ftZYeB3WAdY4WPbriwEQhapmD
         DEEdfxHtEccyTonf+aq3fs38hkGd36uzgkMSttOAGXQ9NaVkSQ6CySEXstQw7Jm2m0Xp
         uGb6JpHs7Nbtr6C+ONH1UDCiL2bqIDkpbZhkcyze2EmMx7STJm1x03qdquoBnG9emdyl
         jTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fPZAAh6XsmYVOwEtQ9QgTBMrLWPHTOlempZ6e2w/4sU=;
        b=MmKNJhxMGa3bCo8exoUy1QJVLibpCBamelW0E48v/gKKVz0kQb+ygFtR59L+iSkWKz
         TjdVe+jlN1hXHqO7pkQaFEw0GmPFKrMDfSo9LdOG6XxN2fu53GwqMy/KprLGa/mtCQ52
         dQ2mgVsjfGYTAMrD8fFzSGbN9rZRlU3GcoNbnkkuRH2bH0DuASQ5QBXBm73ixSmTM8L0
         u29osESoqKmaQftCi0CI7aQ2NM0M4+SThCKosdvNqZK39OMKUIm2/mflgMlI9wneOBp/
         GtIMY8PL6i0nSHNuvkDKQo1qwbgYhrZx53YR6EFzFZQmwpWA+AsySlAGawnTWLZIxsTz
         Y4YA==
X-Gm-Message-State: AOAM533ykFVe9Qi2t+1PpFCZ9rao6RMYYBQxyPmm2KxCJe/ntznlY+FN
        UMQvZrjhUCevtOPGuIpdL9yK1A==
X-Google-Smtp-Source: ABdhPJzmUcfwbdCsLs7U+nWKQHMNhKcf2XcOeObtyHpRpyrzjTXFBZDadWKRQNDU8Uj7JYAzhHb0Tg==
X-Received: by 2002:a7b:c013:: with SMTP id c19mr7188412wmb.158.1594798890987;
        Wed, 15 Jul 2020 00:41:30 -0700 (PDT)
Received: from localhost.localdomain (lns-bzn-59-82-252-131-168.adsl.proxad.net. [82.252.131.168])
        by smtp.gmail.com with ESMTPSA id k11sm2303745wrd.23.2020.07.15.00.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 00:41:30 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     davem@davemloft.net
Cc:     daniel.lezcano@linaro.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: genetlink: Move initialization to core_initcall
Date:   Wed, 15 Jul 2020 09:41:18 +0200
Message-Id: <20200715074120.8768-1-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The generic netlink is initialized far after the netlink protocol
itself at subsys_initcall. The devlink is initialized at the same
level, but after, as shown by a disassembly of the vmlinux:

[ ... ]
374 ffff8000115f22c0 <__initcall_devlink_init4>:
375 ffff8000115f22c4 <__initcall_genl_init4>:
[ ... ]

The function devlink_init() calls genl_register_family() before the
generic netlink subsystem is initialized.

As the generic netlink initcall level is set since 2005, it seems that
was not a problem, but now we have the thermal framework initialized
at the core_initcall level which creates the generic netlink family
and sends a notification which leads to a subtle memory corruption
only detectable when the CONFIG_INIT_ON_ALLOC_DEFAULT_ON option is set
with the earlycon at init time.

The thermal framework needs to be initialized early in order to begin
the mitigation as soon as possible. Moving it to postcore_initcall is
acceptable.

This patch changes the initialization level for the generic netlink
family to the core_initcall and comes after the netlink protocol
initialization.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 net/netlink/genetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 55ee680e9db1..36b8a1909826 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1263,7 +1263,7 @@ static int __init genl_init(void)
 	panic("GENL: Cannot register controller: %d\n", err);
 }
 
-subsys_initcall(genl_init);
+core_initcall(genl_init);
 
 static int genlmsg_mcast(struct sk_buff *skb, u32 portid, unsigned long group,
 			 gfp_t flags)
-- 
2.17.1

