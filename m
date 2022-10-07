Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032645F8101
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 00:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiJGW5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 18:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJGW5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 18:57:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F98B459B0
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 15:57:48 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b15so5549330pje.1
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 15:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZU76uLwyjU7M+xx35ps05anqLd9LURu85tvF/oVdOAE=;
        b=D+RhrZP8iAAcJtEj1mzPEpIi5o3ql3Jrop4jCmqVtASWsL6iVh+xUUra/BLPifMk+O
         QGI81oGDwqkn1tPyxfCr2anAXEXKlRe87CyLx5GARPBVzIic6d7F0nqYtdO6l3Vs9jcb
         bApLaIz9hcBqv5wRTEyTz1DAgAKTJsyplTjBX0HXhvtg6vohHQrObd/ZOpcZbEwoINpZ
         0U5nom15Z03kMXwBnvs8G+PlKAG6Hpe2mjkBMkBHKtaSbRDsZ3uP/ZxqOtgCpUC5xBbI
         Z1gJbswBe++m3LBHne9lu4NOgKoaUqRw24hs2ztOagcLhNTA+Km/sjp6cGgpbbXrqm55
         vBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZU76uLwyjU7M+xx35ps05anqLd9LURu85tvF/oVdOAE=;
        b=dvRsem/UMwj64md0UVNM/HHzdyCQNjSMyqrLi9oCzmzcHWUxiSfdN8QBfDAsGyS/rQ
         yxf0svjkxQcSa2uATjzdeXjhutF/Hw0QGp1obZalyYtkK79sMCwjmwgjEpRMATnRpH38
         /eEuEV32wPBgHRA+OJuW8gyNSDesZQkP//92jxU4OIwIx+LDmAuXnvREHcGegelGkq0J
         KJOaIu1rGtSAJbyvBKdyjaaScL2+9SUg4LHfxtI3p+JmRkiR825kYsFcTcpyeSkQyc/b
         HCYDMb/uSQ+IZPY/svkdD7pwFVznBpq3BEy3any9zEGKUs8Cihsczl1bxoUjUBRPEmPA
         7epw==
X-Gm-Message-State: ACrzQf2hO9eYeaTHcc6obcQLJylV0LzSHSpkgYpjc+V+vcai6hsH9Hsb
        FZnMzwJa2BuaD3EOXUpCrog=
X-Google-Smtp-Source: AMsMyM6kWERb00bqRYmPkxwJIxxhscC3n/V4CLdhHTsufbHKdJL7Gfa8kfL6EFckg6Y0RkWNHuEn9g==
X-Received: by 2002:a17:902:f60b:b0:178:6a49:d4e3 with SMTP id n11-20020a170902f60b00b001786a49d4e3mr7286982plg.75.1665183467778;
        Fri, 07 Oct 2022 15:57:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c421:b06a:d31a:2720])
        by smtp.gmail.com with ESMTPSA id b17-20020a170902d41100b0017bb38e4591sm2018569ple.41.2022.10.07.15.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 15:57:46 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] macvlan: enforce a consistent minimal mtu
Date:   Fri,  7 Oct 2022 15:57:43 -0700
Message-Id: <20221007225743.1633333-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
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

From: Eric Dumazet <edumazet@google.com>

macvlan should enforce a minimal mtu of 68, even at link creation.

This patch avoids the current behavior (which could lead to crashes
in ipv6 stack if the link is brought up)

$ ip link add macvlan1 link eno1 mtu 8 type macvlan  # This should fail !
$ ip link sh dev macvlan1
5: macvlan1@eno1: <BROADCAST,MULTICAST> mtu 8 qdisc noop
    state DOWN mode DEFAULT group default qlen 1000
    link/ether 02:47:6c:24:74:82 brd ff:ff:ff:ff:ff:ff
$ ip link set macvlan1 mtu 67
Error: mtu less than device minimum.
$ ip link set macvlan1 mtu 68
$ ip link set macvlan1 mtu 8
Error: mtu less than device minimum.

Fixes: 91572088e3fd ("net: use core MTU range checking in core net infra")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/macvlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 713e3354cb2eb14cbf4009e67858c261508a037b..8f8f73099de8d8308b45b7e3bf9179e8311182ee 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1192,7 +1192,7 @@ void macvlan_common_setup(struct net_device *dev)
 {
 	ether_setup(dev);
 
-	dev->min_mtu		= 0;
+	/* ether_setup() has set dev->min_mtu to ETH_MIN_MTU. */
 	dev->max_mtu		= ETH_MAX_MTU;
 	dev->priv_flags	       &= ~IFF_TX_SKB_SHARING;
 	netif_keep_dst(dev);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

