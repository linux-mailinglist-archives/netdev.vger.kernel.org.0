Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3607424A35
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 10:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEUIXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 04:23:48 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42398 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfEUIXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 04:23:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id x15so8069136pln.9;
        Tue, 21 May 2019 01:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cftAPYrP8xYfrEicUsBv/taLJMOWX61KyJ1eZP8Jk2c=;
        b=WCoq8md8uakBDOCs5WHQPe/1x7hMfDToFnqS4FA0hiBLKR5/uil7/Agc3ieY7g8xzR
         tEO5p9RDtOvHhovXx8jq6uFajiOKaBo5fve0sGXi7oE+P6Lu/UuyeHEQftKz/zWh5S9t
         +i8/uCLs9yrtJ7Y+jQUfIcKKign1FpLZCWNCRU6QVX8j/o41pIzqtNyLMNKZcnNj/am9
         Joj4cBDfUT9pvTL+m03X7eLPs3wnqCTjN/fe7gmnrfoW3KmFbZsz2MAY51nvfMQ27R1d
         TI5XnszP5e7E19sOPbDZ0oCCrtzTU4+xxnpmx+VYqp/8rgvXJvBs9oabDxHydoGOMiKg
         BE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cftAPYrP8xYfrEicUsBv/taLJMOWX61KyJ1eZP8Jk2c=;
        b=InRl96K968xBilgZ+sbkygakI9ChywYgRJlp1EbtHl7Qrgv5lL3cumrXhjG8hOmsiX
         Ay53M+d/Ld3ak5j89uF3j8JYvNDeuliIczF+kqWnpGtCf/gEsYm5WfORA7+2m2B5NVJq
         HMMFfzYCYy+vohXL+b0Xgrmw3bGQUeYvufTQrOFHc+hgftpU5OJ6lTl0kKU5YlkMTnym
         mHrKN3C2xv+Dgfif9+EKq8qSK/QPy30S52GihRiMRChhsdrL9XtU/Pyn5v31vq+kZFnO
         G61JOmvo23Zs+IurL/LXIuP5Pp8iUPWx17jLnD4zyy/q2OU+RFQVQD2964yOu7fKtqL+
         +q3Q==
X-Gm-Message-State: APjAAAUNyi35+gxQgvPXEgvilTsGeRk7DD9ckF1CdbX1U8x9Q8HX+zr9
        thIsmlwMTUbj0+kWS5ds5QODgsHMKM0=
X-Google-Smtp-Source: APXvYqzGCM0ZCfBiZtjUqwJQ3ceeRB/ZZireHclCD98P6PSL83QdcV1wUHaVrzmfGs6ruTnjKVVc0Q==
X-Received: by 2002:a17:902:a70f:: with SMTP id w15mr10911141plq.222.1558427027468;
        Tue, 21 May 2019 01:23:47 -0700 (PDT)
Received: from localhost.localdomain ([27.61.168.215])
        by smtp.googlemail.com with ESMTPSA id k22sm16700325pfk.54.2019.05.21.01.23.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 01:23:46 -0700 (PDT)
From:   Anirudh Gupta <anirudhrudr@gmail.com>
X-Google-Original-From: Anirudh Gupta <anirudh.gupta@sophos.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Anirudh Gupta <anirudh.gupta@sophos.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] xfrm: Fix xfrm sel prefix length validation
Date:   Tue, 21 May 2019 13:52:47 +0530
Message-Id: <20190521082247.67732-1-anirudh.gupta@sophos.com>
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
 net/xfrm/xfrm_user.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index eb8d14389601..1d1fe2208ab5 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -150,6 +150,23 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 
 	err = -EINVAL;
 	switch (p->family) {
+	case AF_INET:
+		break;
+
+	case AF_INET6:
+#if IS_ENABLED(CONFIG_IPV6)
+		break;
+#else
+		err = -EAFNOSUPPORT;
+		goto out;
+#endif
+
+	default:
+		goto out;
+	}
+
+	err = -EINVAL;
+	switch (p->sel.family) {
 	case AF_INET:
 		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
 			goto out;
-- 
2.19.0

