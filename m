Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F51356A1A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 12:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbhDGKnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 06:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236418AbhDGKnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 06:43:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DEAC061756
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 03:43:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d5-20020a17090a2a45b029014d934553c4so330719pjg.1
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 03:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HirO+Q0OBJEy9dZvyn9vrel+cDU947PTKIKG1x5aZyY=;
        b=IjtqXkEqYby0aC7I72V/TK3GrwXoKDSoWnDoagSoNgtuL8up1BYJ8ZYGLelfTWMX3m
         HPzAkaGV9lGkF2VhnRnOXqNP7Z+m2MkdZH9EuEil8qB7WCe3Sl7Qjk9fFXVK5NJdm1I4
         /TU0CKZAGfPqNgAQWyaZAvh1/Jk3kt1xvX1nkucjP5oa8iilsPzfZKyuvonNhhoEvFiK
         J9dnpljvtit4JdnlWI0ZDKJMXikY1Hmu6RMo0//YREGdYDiUD7LNWDVjSq591DN9j6co
         ZDfxzjjiI5QFiMrCVCPOKdwpcJTHz4p8boJUmBEwVOkNTlwQublmIPG80ohpk4jIzfFD
         cT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HirO+Q0OBJEy9dZvyn9vrel+cDU947PTKIKG1x5aZyY=;
        b=UZqtRDRK1BbVnMBTHA4pxynpyn9EVyNxMp0goOnCS0dt0j49Gz14PEC1pN3kw1SIlL
         srzhCZBvC0489Jo/zNjJVG1qn4D9K4HYCpHkqThTIxy7uOvsqrZc+Q7OvSNGujhn4iCA
         FnD9aA5T/1tW4tp4csRRO4pDcUHK3htgtxHVCK8p6w2ZZsBKjSxEjvS1cToVM7mxNHEA
         BgFP9SHcVodiQGtW3sa2aHPoSukWTgcz4I7/FNWwW6ItAEhpKULREh8KHbt57XsLxK0V
         5uaXdmxVa/whkMhEpc9Q0b91Zuv2XCpiRikp630gv4wL+xXVYfrUVBfXz4mz6eSs3TQG
         MofA==
X-Gm-Message-State: AOAM531j0d+28e0HMzjNXcHe5ka3FdXwJLXM6PuBAl23lBG6PV1KPwht
        8zqHpr3LQ4fdhx3PEthHRcpr1KfDgNFkzg==
X-Google-Smtp-Source: ABdhPJzpgnO3065fXHi4Zb7eKLqtrnWSgkCZRDHYX7ucOkH/C2FUNwICsZCkxJxF7lAPi8szVnLNqg==
X-Received: by 2002:a17:90b:100a:: with SMTP id gm10mr2678973pjb.0.1617792208807;
        Wed, 07 Apr 2021 03:43:28 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n22sm22246386pgf.42.2021.04.07.03.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 03:43:28 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] wireguard: disable in FIPS mode
Date:   Wed,  7 Apr 2021 18:43:07 +0800
Message-Id: <20210407104307.3731826-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the cryptos(BLAKE2S, Curve25519, CHACHA20POLY1305) in WireGuard are not
FIPS certified, the WireGuard module should be disabled in FIPS mode.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/wireguard/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireguard/main.c b/drivers/net/wireguard/main.c
index 7a7d5f1a80fc..8a9aaea7623c 100644
--- a/drivers/net/wireguard/main.c
+++ b/drivers/net/wireguard/main.c
@@ -12,6 +12,7 @@
 
 #include <uapi/linux/wireguard.h>
 
+#include <linux/fips.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/genetlink.h>
@@ -21,6 +22,9 @@ static int __init mod_init(void)
 {
 	int ret;
 
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 #ifdef DEBUG
 	if (!wg_allowedips_selftest() || !wg_packet_counter_selftest() ||
 	    !wg_ratelimiter_selftest())
-- 
2.26.3

