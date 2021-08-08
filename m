Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738743E3947
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 09:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhHHHGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 03:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhHHHGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 03:06:22 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4920C061760;
        Sun,  8 Aug 2021 00:06:03 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso24638279pjf.4;
        Sun, 08 Aug 2021 00:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Id49AvJlsrukCQw2aVHFU3JVesZ+nmFVyp5cZUBrgDk=;
        b=D5WO1UksA4807jR59fpOkdeRfaH4f597Fbf6r1/Bf/LCSUNRgnRcQ+xad5STftxJrI
         e3k05T2Hu5lAVsA79FCb/+8H18V29oIOkNmy0xLxoBaCNFAEbKJIp9vPq78hkPDm6I2M
         kRUSBrjchX+dUYdZTcUxk18IFlcf0cdfYzI+LoJ3PcpOtXN8bNthdqUD/xfqOU1dMQS2
         LaAKsSf80f2+PcUconldVR5prEurpdK64wez0zyMgzg5n1v+OxjgcExZ2+I/Mj6viJD3
         QzdXlZro5sHOJDcYwpF6iGcqGiibZzniVH7FV6Hgb9+JjbymOhH0sOoe8XYvgLl4+cGo
         h1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Id49AvJlsrukCQw2aVHFU3JVesZ+nmFVyp5cZUBrgDk=;
        b=ZigzGeMgBFkOcYpzqlf+JrM8PKmrkYRzt2OXfbsjHBbpheXxN4OypapYl3XfwfLxD9
         5lkIFcwyqRhGK7Tla1FoHbYLaPV/+fPeIN9W3qURN8pXw55DX8ZaJM9y65PjIfn1ZieR
         PRR4e6cD21e6NCVKQGYdzaHobNoOoDHt/G81pHPcgh8oFKW8WZg84yc3xzrPYwviK3Zx
         ZuhIQYlg4saYsdVQl/yS7dkm/h+3Sy0Sl9joGf6BJzQTzBGJjMh24tNUVNRx4WQwNlE7
         m8ZO1x3MUtdiU9x9ChopJh7EZWFj16rk3od62MOa3lfkrXm39mrcjrRt2d6xs1z3wgKc
         7BTg==
X-Gm-Message-State: AOAM530c72jbSjtHNL0Jxo5x28hD2z/w/qZjRiDkTSeddEitO25Y4mzr
        WX+IrTlPJcmyBgUT3i3ULdKAYp+1f0U4zI/CD8M=
X-Google-Smtp-Source: ABdhPJwO5zgXyH9DLPdlzB4IcPfBeyPOT2uAJcJz7eySfvO8B3PjLZ0EZWOelMryhPwm+RmEP8MMcA==
X-Received: by 2002:a17:90b:4ac8:: with SMTP id mh8mr18104180pjb.5.1628406363398;
        Sun, 08 Aug 2021 00:06:03 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id 37sm17672490pgt.28.2021.08.08.00.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 00:06:02 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net] ipv4: fix error path in fou_create()
Date:   Sun,  8 Aug 2021 16:05:57 +0900
Message-Id: <20210808070557.17858-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock is always NULL when udp_sock_create() is failed and fou is
always NULL when kzalloc() is failed in error label.

So, add error_sock and error_alloc label and fix the error path
in those cases.

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
v3:
 - change commit message
 - fix error path
---
 net/ipv4/fou.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index e5f69b0bf3df..f1d99e776bb8 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -572,13 +572,13 @@ static int fou_create(struct net *net, struct fou_cfg *cfg,
 	/* Open UDP socket */
 	err = udp_sock_create(net, &cfg->udp_config, &sock);
 	if (err < 0)
-		goto error;
+		goto error_sock;
 
 	/* Allocate FOU port structure */
 	fou = kzalloc(sizeof(*fou), GFP_KERNEL);
 	if (!fou) {
 		err = -ENOMEM;
-		goto error;
+		goto error_alloc;
 	}
 
 	sk = sock->sk;
@@ -627,9 +627,10 @@ static int fou_create(struct net *net, struct fou_cfg *cfg,
 
 error:
 	kfree(fou);
+error_alloc:
 	if (sock)
 		udp_tunnel_sock_release(sock);
-
+error_sock:
 	return err;
 }
 
-- 
2.26.2

