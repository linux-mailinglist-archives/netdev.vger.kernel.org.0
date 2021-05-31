Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129273955F0
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhEaHXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:23:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60327 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhEaHXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:23:21 -0400
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lncF3-0001PE-Dp
        for netdev@vger.kernel.org; Mon, 31 May 2021 07:21:41 +0000
Received: by mail-wm1-f71.google.com with SMTP id 18-20020a05600c0252b029019a0ce35d36so1510361wmj.4
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3GSON0j3KJh2/Oj56KH/Htj1p3OWvu821JK06uHKfk=;
        b=fmhln14VBrgRgiojLGL0Yx/WrNx6IROxTZm0sNyOAExPAs6yUVoZL6WgpBj086gxQY
         YcJSmt7zOZJgg0AyqMijhXDECpBpZtnMJy/+bAtTpCkPdFgVGvo+jYZqB2xuVWweFH3Y
         CJ9CCBH6D7wjFS04EX0nYLVOT2pM8eFfzzy+T9JF7Zmm3vWF9vxnfBDy/XokYLvPvc25
         mU8rqKVnDFsS12R3c6vaemayquLEPNaJM9EBh+gfZbes03pl5hJ3IMjIVzKVSaPneYFw
         E6VEiga0UbB9h6txHvn1CFkSF6UfTtuIvzFZ2nHdzIq8IzKhIKFvt93+JZHN6SxGhJwS
         y8OA==
X-Gm-Message-State: AOAM531raBxkt6Yb4r2PgZ1QlxSuH6WYWZeQiB65E+V8Btg3Dre5HPn9
        oUlVIWmakt6QUdlsT+lCUODhymfDbt5lbBmfDbUcLZ0gaeCFePULJ5m2COsosCiUEHrqRGeD2Nc
        lzfpjrkaD+4t5vpe1zx9Bf+ucxW5pvV/K0Q==
X-Received: by 2002:a5d:6d04:: with SMTP id e4mr20690492wrq.344.1622445701115;
        Mon, 31 May 2021 00:21:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNPl5seNhNk64GNvxyThbVLS2aeektyv2tIuWTKudSYCJFfU7ib3HhFvUqJqAh5HDGJq0JCA==
X-Received: by 2002:a5d:6d04:: with SMTP id e4mr20690477wrq.344.1622445700918;
        Mon, 31 May 2021 00:21:40 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id r4sm17199111wre.84.2021.05.31.00.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 00:21:40 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     thadeu.cascardo@canonical.com, stable@vger.kernel.org,
        syzbot+80fb126e7f7d8b1a5914@syzkaller.appspotmail.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [RESEND PATCH] nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect
Date:   Mon, 31 May 2021 09:21:38 +0200
Message-Id: <20210531072138.5219-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible to trigger NULL pointer dereference by local unprivileged
user, when calling getsockname() after failed bind() (e.g. the bind
fails because LLCP_SAP_MAX used as SAP):

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  CPU: 1 PID: 426 Comm: llcp_sock_getna Not tainted 5.13.0-rc2-next-20210521+ #9
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
  Call Trace:
   llcp_sock_getname+0xb1/0xe0
   __sys_getpeername+0x95/0xc0
   ? lockdep_hardirqs_on_prepare+0xd5/0x180
   ? syscall_enter_from_user_mode+0x1c/0x40
   __x64_sys_getpeername+0x11/0x20
   do_syscall_64+0x36/0x70
   entry_SYSCALL_64_after_hwframe+0x44/0xae

This can be reproduced with Syzkaller C repro (bind followed by
getpeername):
https://syzkaller.appspot.com/x/repro.c?x=14def446e00000

Cc: <stable@vger.kernel.org>
Fixes: d646960f7986 ("NFC: Initial LLCP support")
Reported-by: syzbot+80fb126e7f7d8b1a5914@syzkaller.appspotmail.com
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

Not extensively tested yet but fixes this particular issue.

Reason for resend:
1. Keep it public.
---
 net/nfc/llcp_sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 53dbe733f998..6cfd30fc0798 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -110,6 +110,7 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 	if (!llcp_sock->service_name) {
 		nfc_llcp_local_put(llcp_sock->local);
 		llcp_sock->local = NULL;
+		llcp_sock->dev = NULL;
 		ret = -ENOMEM;
 		goto put_dev;
 	}
@@ -119,6 +120,7 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 		llcp_sock->local = NULL;
 		kfree(llcp_sock->service_name);
 		llcp_sock->service_name = NULL;
+		llcp_sock->dev = NULL;
 		ret = -EADDRINUSE;
 		goto put_dev;
 	}
-- 
2.27.0

