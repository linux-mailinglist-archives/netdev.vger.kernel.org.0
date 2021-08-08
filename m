Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EE73E3812
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 05:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhHHDWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 23:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhHHDWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 23:22:22 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F9DC061760;
        Sat,  7 Aug 2021 20:22:03 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j3so12685873plx.4;
        Sat, 07 Aug 2021 20:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b4+eN9bpiKnHX7lu+xFEi0IU4TCXd8H9JxiJveHTsSw=;
        b=dEtmzyC5kAP2AaQ8rVpxMNpb98KMTvXG4fr83hlbj+7cgOMCZr5GG8evKsqcnaNU+a
         eLJDai3kjOOtSZ0t7SDspn/ZmTHYVyMFgqfvUv8VuizHzm7m3V4M940ob4wlp8eo3OYG
         N3KTQ0+JkF2i+mfFvhwB6sOk/xQgdaPdqeDplLzvuoy1XFygvJjWMN8rtkhdeBeGBS6h
         /3jexKGhBcgd8iHgnvexKwSYm2pFTAEHri3Uvsq807TukqOjH2qA2mtJnkAudioOUf5W
         2CKdpYfh408PvXGd1D/haQ8sAyVWKKSZ+6OodJmTk9DhhLYRfjcgJIhqLoe+eVFZIq0D
         2a6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b4+eN9bpiKnHX7lu+xFEi0IU4TCXd8H9JxiJveHTsSw=;
        b=ATb5d/XHcjVei65av7gDYCxUi3dXZlNqf3Nmp+3mEds1umtaZ+yi6i72eFAs3lP5JN
         ScKe/BscCSXy6YNh1HGFmv3a9vXaFzvyzH7Wzj9N7aL7uper1jQN4UwBkTYXGhR3AVvP
         na1zQB5OLzh3ioklF+QntwHDAeXu8uGQhzPzMk0oQBS0Rs+o0Vi6w5xDeevvharuyDKh
         IV5365U6jHmBDFzb9So2x/I9KQ+vQamZkad6Nm31eDG25to94/oBxfexhVivi3tGFfEj
         ee6iEvrXRO18uBQABSRGWll6EuiEHYWFBSy13e26hRu9HMivHx7YNziR3LkpHtAPwI8g
         5i2A==
X-Gm-Message-State: AOAM533GM9quiPHjHmh9E8YU+sMwyGl2n6UbFzi1bId7qvc18uz7LHVN
        Ly8QQq/Wg7Al1c6ePk/Cu7g=
X-Google-Smtp-Source: ABdhPJwjoDLiT4fHUYwUMvUXtEVKOQY0BPXm6hBkgOtP8vVtAbR+r9QfbRhF2ZdWad3QEiXNKx5Bjg==
X-Received: by 2002:a17:90a:150d:: with SMTP id l13mr17919388pja.93.1628392922521;
        Sat, 07 Aug 2021 20:22:02 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id bj6sm16961198pjb.53.2021.08.07.20.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 20:22:02 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipv4: fix error path in fou_create()
Date:   Sun,  8 Aug 2021 12:21:57 +0900
Message-Id: <20210808032157.2439-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kzalloc() to allocate fou is never called when udp_sock_create()
is failed. So, fou is always NULL in error label in this case.

Therefore, add a error_sock label and goto this label when
udp_sock_screate() is failed.

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
 net/ipv4/fou.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index e5f69b0bf3df..60d67ae76880 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -572,7 +572,7 @@ static int fou_create(struct net *net, struct fou_cfg *cfg,
 	/* Open UDP socket */
 	err = udp_sock_create(net, &cfg->udp_config, &sock);
 	if (err < 0)
-		goto error;
+		goto error_sock;
 
 	/* Allocate FOU port structure */
 	fou = kzalloc(sizeof(*fou), GFP_KERNEL);
@@ -627,9 +627,9 @@ static int fou_create(struct net *net, struct fou_cfg *cfg,
 
 error:
 	kfree(fou);
+error_sock:
 	if (sock)
 		udp_tunnel_sock_release(sock);
-
 	return err;
 }
 
-- 
2.26.2

