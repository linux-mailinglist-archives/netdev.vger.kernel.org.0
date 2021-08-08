Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE8C3E3920
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 07:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhHHFtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 01:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhHHFtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 01:49:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C64C061760;
        Sat,  7 Aug 2021 22:49:23 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d1so12936614pll.1;
        Sat, 07 Aug 2021 22:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6BZAJwNVxh7BBq5KJRh3cIe1IxGdTWQfrAqveunfQ9A=;
        b=X282WwyX2+xa2GLcX2oWX4NRxg3Ys39kcIzAVStrLh1r24CkmQsLruZtJ2vvtPYp76
         yfkF8V1hKwnk0OZs//Tdil6kbp0+u0dYnKejgmVnLWYVlvKecrLotYyCFYJ9ZlMi0l7A
         wVNVULhVeYahsS+6AtAFItxKKtZWxtknHuI0e3XsL8jG6pCTUtYsBz/P1v09XcYK+RL2
         8wHjXWJseisLxQAvb8r2MIrpS/T22OcbQlYbZbV6aD8phd7OSURg76KS37ULX2xgP1JN
         9Gaby/AVM2bVr2AWJPcz+u4fa744t2aeubQwuGISzn/KCMcsZifhVE1BwlFvsI4pMwks
         ussg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6BZAJwNVxh7BBq5KJRh3cIe1IxGdTWQfrAqveunfQ9A=;
        b=Ato1EbExa00KaOmma35Q6pxhRJFw0PloJtzubf176EPz6asXtcf+mXj1/XiYVDvdEE
         e5vpLGqJUlREHKvf7rtNWdTFDXhrJzZVsT7n/ugZLkkvl/oLSSsZFjERttg02YByGjxu
         lR3A1N0KUUamhD8ol+2Fh11uuJlxgHDAMcZobkafuLDPcb+AcgUZ9kEmBcAaHyBfXVOI
         6ycKGZJm5CqUma4QA8RNDvyvUHuOP8oCKsmfp6SLhGyR49PinNDWd+nOU/lJxhV82zK/
         9JMjGOlSYR6i+uJI4IVNZBy4H9J1WgZZFFwy3DpR+iAKjMZdC0Jszl3/kXqHiLCgTBsR
         EMCA==
X-Gm-Message-State: AOAM530IN6rLnYP6+UKkdmSUkt2tcJTtfgny7S2xPHjRx9Gi7VA7PXv6
        N2zeBtvBVmxt5L5nojVR+T4=
X-Google-Smtp-Source: ABdhPJyfiVBRK91EqgPnTh4dRdUKDMgLtniNBWtoEBxeDUjehqtCy70im+rX1IfJMcqe6zslv14lUw==
X-Received: by 2002:a62:7d84:0:b029:3b8:49bb:4c3f with SMTP id y126-20020a627d840000b02903b849bb4c3fmr12642251pfc.49.1628401762761;
        Sat, 07 Aug 2021 22:49:22 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id o10sm12842849pjg.34.2021.08.07.22.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 22:49:22 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ipv4: fix error path in fou_create()
Date:   Sun,  8 Aug 2021 14:49:17 +0900
Message-Id: <20210808054917.5418-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock is always NULL when udp_sock_create() is failed and fou is
always NULL when kzalloc() is failed.

So, add error_sock and error_alloc label and fix the error path
in those cases.

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
v2:
 - change commit message
 - fix error path

 net/ipv4/fou.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 60d67ae76880..f1d99e776bb8 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -578,7 +578,7 @@ static int fou_create(struct net *net, struct fou_cfg *cfg,
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
-error_sock:
+error_alloc:
 	if (sock)
 		udp_tunnel_sock_release(sock);
+error_sock:
 	return err;
 }
 
-- 
2.26.2

