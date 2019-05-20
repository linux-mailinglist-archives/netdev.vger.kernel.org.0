Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFE023066
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 11:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732206AbfETJdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 05:33:03 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40483 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbfETJdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 05:33:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id d30so6518566pgm.7;
        Mon, 20 May 2019 02:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BikJ1LqRGkhlGlmQU7THI1KaCDjHN3UGQHGSJZ6WA6g=;
        b=J3MG2YP03SsO1qXFGAn18jiLeOIAZKbuUAmVf8TReg9hr8zgctqHFzViHxpq2gC0tY
         36pvwXRsbT/4UCMYRnfO9qEMu11ogdiZyszY6xfl3EHJV1shVwKI3pjY3PX2Pl8XcrP+
         6GPs3ujoS6y+08+8yvK9RK8grOWM9nQL4l4ywllQFmpkpn9rtiCIBAZZiA3PkN/m2rFM
         j4gyCECQkqM2GMKeRoAlBs2GBWjSrflpZZowYoiSQQ0fXdEtVfZuYLNEFrtzmPI3neUC
         JWVtug+EtI3GGNZxDbIyyx2rict/Oe5SDrtO/WqbAQ9r7fUxfXeghj8S50Un3VkAkohX
         3ZGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BikJ1LqRGkhlGlmQU7THI1KaCDjHN3UGQHGSJZ6WA6g=;
        b=gE/ugULGr0JlST60PrqpdNAGoRrIIUSa0+A5qiYagqJxBjLc7UFFMOjxYDxhkAXQwI
         KftenFbMSXzvvuxmFjqcleY6oWfPaa+BQnInbDpGMm3N+DVtO4s8HP5+bo5kceaXflZF
         udQRNJa627W/xpKXGm/8C+s+Qca4zwgERyXl70gB2RsZEW7XyawxMYHR3YAABTYYLhAO
         XxSY2zZZ6NiJG+Ht3jtuf2lqRxpIQpHmr/YFpTD3EaLRxuTApIJKfnRNXKP8zjp7q3FS
         W40y0F4IA6grSVSyJsAnCgJzQ3OuPlOtTJAG5PRYkULD/D/y0lWTcAbwMEybIplzvE9m
         49EA==
X-Gm-Message-State: APjAAAXotKEhBuUB/+abobMbUVRbL0Pmrx++ryXnbpD12XuqU9q7Z8Gj
        jdt/wg0x1GV/AN5xTMU6ccQRhLpYp0w=
X-Google-Smtp-Source: APXvYqyzIU/ujLG3HBRbWQPkBok00jmmEnwQ4j4xgXmrKgCz7JSxOX/jz1RzDyLA8VSktbRK+5tsuw==
X-Received: by 2002:a63:d016:: with SMTP id z22mr75145505pgf.116.1558344782769;
        Mon, 20 May 2019 02:33:02 -0700 (PDT)
Received: from localhost.localdomain ([27.61.168.215])
        by smtp.googlemail.com with ESMTPSA id f36sm17649707pgb.76.2019.05.20.02.32.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 02:33:02 -0700 (PDT)
From:   Anirudh Gupta <anirudhrudr@gmail.com>
X-Google-Original-From: Anirudh Gupta <anirudh.gupta@sophos.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Anirudh Gupta <anirudh.gupta@sophos.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] xfrm: Fix xfrm sel prefix length validation
Date:   Mon, 20 May 2019 15:01:56 +0530
Message-Id: <20190520093157.59825-1-anirudh.gupta@sophos.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Family of src/dst can be different from family of selector src/dst.
Use xfrm selector family to validate address prefix length,
while verifying new sa from userspace.

Validated patch with this command:
ip xfrm state add src 1.1.6.1 dst 1.1.6.2 proto esp spi 4260196 \
reqid 20004 mode tunnel aead "rfc4106(gcm(aes))" \
0x1111016400000000000000000000000044440001 128 \
sel src 1011:1:4::2/128 sel dst 1021:1:4::2/128 dev Port5

Fixes: 07bf7908950a ("xfrm: Validate address prefix lengths in the xfrm selector.")
Signed-off-by: Anirudh Gupta <anirudh.gupta@sophos.com>
---
 net/xfrm/xfrm_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index eb8d14389601..fc2a8c08091b 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -149,7 +149,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 	int err;
 
 	err = -EINVAL;
-	switch (p->family) {
+	switch (p->sel.family) {
 	case AF_INET:
 		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
 			goto out;
-- 
2.19.0

