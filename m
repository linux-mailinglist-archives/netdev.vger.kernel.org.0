Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221F33AF780
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhFUVhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbhFUVha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 17:37:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF07C06175F
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 14:35:14 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id h1so9307160plt.1
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 14:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UDidmCZxhroQ+TOCX79nOJNfPKJOGFSjcIs3K19hLp8=;
        b=UKzXohh/1StZBHDI4g+MalYUrKYsPNiqfF19dWdrEZWlbsMxHYiLQZgLy4EXhUuWXR
         M+dVug9hbGLGGAL1TsjAV2lS3Xn1aEk8CKPpyb8zBB/H/ZMu0XR6EhXJwCYlO4Hs6EVq
         8esrQr3Bd6IvJ34m0TFKXLP/ytkY9pj/UA2nQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UDidmCZxhroQ+TOCX79nOJNfPKJOGFSjcIs3K19hLp8=;
        b=soa7Wd7XvB7jCX+TQg+J3oOF+ZD6eBSMmbSzu8rTm4+p2jkPudtfNczkOrdxmOznEr
         IM6up5m4jyfyZeqA8gmz70jHoLBSWY9sg+O39BZXbjQDfVwuc/jwL0uiMc84U/Jb+r5C
         dYGwaexEi0GtvetxA28jQ7aAI8KtjgdhTUvuGMXiJcVED1PZJTl9MWgwdVYe6ZUU+P9e
         V0+ff8rpwEATyfDm3jJN/klfC9Xj6kNVcodoyMJyAh+/VRfHtEcopp3Kfk/E0v9NEDxd
         Og6Scpy/OiTSMSq6RerRHHpriclCtdkYTWB3AcCTY5BLftBKo7KdPnvpSp8OJoZ5g40+
         yaXw==
X-Gm-Message-State: AOAM532RiAmGh/duPxqNlsr36OC6PuoG3g9sk5xHSda6mN6ZgBDQFmz7
        Afp0+JCDl1jVq/hlw2FMEDFiUw==
X-Google-Smtp-Source: ABdhPJySc3RO6aQntY+AiU2uAIVn9+bZL0/etrX7035KzHaNrh5bI1NZpIt1xweDPjKFhM6dFtEERg==
X-Received: by 2002:a17:90a:e98f:: with SMTP id v15mr133613pjy.144.1624311314348;
        Mon, 21 Jun 2021 14:35:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k9sm17811211pgq.27.2021.06.21.14.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 14:35:13 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>, Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] ibmvnic: Use strscpy() instead of strncpy()
Date:   Mon, 21 Jun 2021 14:35:09 -0700
Message-Id: <20210621213509.1404256-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=9d7d233a23aa862fcc6a92c72955f66ab680a7cf; i=2MSGt3s6JKlmLqc/7MhI8MosbesWNfHpXt3ZKIs5Ui0=; m=73OdtUon7HnZ7lwINUsDE2u3rLyNTedCFDxqqnCnH0U=; p=3HCUEwDxbB6Mvm9EsCUsGy6FDmIED+nO7uTZDX2jFb4=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDRBg0ACgkQiXL039xtwCYm1hAAn8z zKGC+z3/HykUm/wR8tpn/0aihvrjXOE/pNGc82OUB9sRdy3xFtnvDq7A/jcfeK5kwd4zBM6kXwNzB hM8KxnDiM88KuS4hLn61XmYxNC7V6L5moz2ZX5SZrvv0xsM9gZUxe6frtJoocA4jHfKeR5g0picxr 4UBq2Wf+VhkKayMKHHYMEAq/2PvJb5hDt/xCV0SMyKx00OPatExs2CZtCbpjmCcQSSGdiufea830i Zi3jIfzppQecp3bIq8fXUC0hzIjbYa6KUMJoWOA7SrBAiupg+msTYzA1UvWScPZJE7XtObX9bE4Cf K3u5t+0yC8wx0Cjl/0H+QRMVd7iZV2c+FS67Ynwc6eC8NQj2eOE89pg9VBEj0gOqJjkWu7UHzmt62 SAXNfDGiqs9pmSsrYuAVJV6qsgEPK7f2qzbndwBGL3gqE4uRoV2k5E7f2jnrKGyje3LnVZGAR8Fx9 tlX3OuqdEB05ejAW5Ay60gUCa3I14flW6fTJwQdHM9zfpSxwMPNuy9apw0tb8BJTCUlTe5fan6HA4 QSM3EcAu5rSIcgiXiqrDR4AMldjPbKuvtczjKve7Z9KCH7IX1EaTOalWwNH6F6392Sm1X/y0TEMPO TB9Mi0LVgyXEfzTKoyyXC7lU49OAulgfZrJe+DU7iiAUhNw+8b75S3j73KGOv46g=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since these strings are expected to be NUL-terminated and the buffers
are exactly sized (in vnic_client_data_len()) with no padding, strncpy()
can be safely replaced with strscpy() here, as strncpy() on
NUL-terminated string is considered deprecated[1]. This has the
side-effect of silencing a -Warray-bounds warning due to the compiler
being confused about the vlcd incrementing:

In file included from ./include/linux/string.h:253,
                 from ./include/linux/bitmap.h:10,
                 from ./include/linux/cpumask.h:12,
                 from ./include/linux/mm_types_task.h:14,
                 from ./include/linux/mm_types.h:5,
                 from ./include/linux/buildid.h:5,
                 from ./include/linux/module.h:14,
                 from drivers/net/ethernet/ibm/ibmvnic.c:35:
In function '__fortify_strncpy',
    inlined from 'vnic_add_client_data' at drivers/net/ethernet/ibm/ibmvnic.c:3919:2:
./include/linux/fortify-string.h:39:30: warning: '__builtin_strncpy' offset 12 from the object at 'v
lcd' is out of the bounds of referenced subobject 'name' with type 'char[]' at offset 12 [-Warray-bo
unds]
   39 | #define __underlying_strncpy __builtin_strncpy
      |                              ^
./include/linux/fortify-string.h:51:9: note: in expansion of macro '__underlying_strncpy'
   51 |  return __underlying_strncpy(p, q, size);
      |         ^~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/ibm/ibmvnic.c: In function 'vnic_add_client_data':
drivers/net/ethernet/ibm/ibmvnic.c:3883:7: note: subobject 'name' declared here
 3883 |  char name[];
      |       ^~~~

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings

Cc: Dany Madden <drt@linux.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc: Thomas Falcon <tlfalcon@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2d8804ebdf96..adb0d5ca9ff1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3909,21 +3909,21 @@ static void vnic_add_client_data(struct ibmvnic_adapter *adapter,
 	vlcd->type = 1;
 	len = strlen(os_name) + 1;
 	vlcd->len = cpu_to_be16(len);
-	strncpy(vlcd->name, os_name, len);
+	strscpy(vlcd->name, os_name, len);
 	vlcd = (struct vnic_login_client_data *)(vlcd->name + len);
 
 	/* Type 2 - LPAR name */
 	vlcd->type = 2;
 	len = strlen(utsname()->nodename) + 1;
 	vlcd->len = cpu_to_be16(len);
-	strncpy(vlcd->name, utsname()->nodename, len);
+	strscpy(vlcd->name, utsname()->nodename, len);
 	vlcd = (struct vnic_login_client_data *)(vlcd->name + len);
 
 	/* Type 3 - device name */
 	vlcd->type = 3;
 	len = strlen(adapter->netdev->name) + 1;
 	vlcd->len = cpu_to_be16(len);
-	strncpy(vlcd->name, adapter->netdev->name, len);
+	strscpy(vlcd->name, adapter->netdev->name, len);
 }
 
 static int send_login(struct ibmvnic_adapter *adapter)
-- 
2.30.2

