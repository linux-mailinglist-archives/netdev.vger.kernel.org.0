Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39E159B834
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 06:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiHVEGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 00:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiHVEGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 00:06:44 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DCD2018F
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 21:06:43 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id y4so7321733qvp.3
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 21:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=9kDbG8QwThdHvzMEekKGOffv+9+/7RJCAWGRiaKxE1A=;
        b=dva4zr1sGhgRcsyLc5RRGhyaNLQRoQusHX1O1f6lCCBUqOyMaQYePjLYzsHYGXVmTV
         ulsVseE6K+0MaqX+vcgSimNorbTJVJnocUwJcYWVjsHnezo3+OCQSsTTtcunGdWA216F
         5JG1rIoZpnAZ7l9b8zu/VdTTZ3562dVoaW+8hUl9ZJExDt5y8230gpqFM389n9x0cGtu
         u1bh5/9sqhylCEhzasScqcXVbpCiAYucPCPQfQcg4f0YH8/QUEdJhtbmeSItNT3Chimq
         9H/9zEYexl3HA7djRjGxaLuuYSHMggxXz5WdK6vMI1jhdjorkUmpaYeWP17Y/tm5HYZP
         nO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=9kDbG8QwThdHvzMEekKGOffv+9+/7RJCAWGRiaKxE1A=;
        b=lHEQvnpE3omu48R+uNSy1s7/w7m6h1NFWlCdrRqg9vYrklEpcfqbBgCNLeuEmanMBp
         JY06A3tX2f44D9B67fRz6fhez/afqT2H+QR7xgjmy4GxIYIaQ3gb6NBr3Qk1dvq6O07p
         VLiNrL8Yc9wOp0vQixPQq3fVxuGOukcKWrEZ1Zvg8jdiKqOFxGY84I7BRuuStYUC6gy5
         scIArmEluLjxbbWslr7k37AhgdtOnliFKwg/asMu1d/jQxDHmmyDlOIqw4sUhNvNQa2+
         cGkSSYgbc+YbHeKtQE0arGP3u+KFigzNHLFIr64QG1sPJGzAGUxtV/eW9lDlgz9J8t92
         XjhA==
X-Gm-Message-State: ACgBeo0YblGmmDxW9lShRC5gJgAO2uHJoVAjcaRtt+q3sPweKFD+gH5y
        bHU14vi2hJrQP+nzqi1SWtg6j2Zhpw8=
X-Google-Smtp-Source: AA6agR6bynx6ODBJBk984e6uYhYfhppXppuNHMjzSZ5wNWIvsRfg/rAjcu2pt+oBV1k3EhiR2Q67rA==
X-Received: by 2002:ad4:5bef:0:b0:477:3178:6d4d with SMTP id k15-20020ad45bef000000b0047731786d4dmr13986225qvc.94.1661141202479;
        Sun, 21 Aug 2022 21:06:42 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:79d7:bdad:c641:a462])
        by smtp.gmail.com with ESMTPSA id do14-20020a05620a2b0e00b006bb0e5ca4bbsm8464549qkb.85.2022.08.21.21.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 21:06:41 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+9fc084a4348493ef65d2@syzkaller.appspotmail.com,
        syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Herbert <tom@herbertland.com>
Subject: [Patch net] kcm: get rid of unnecessary cleanup
Date:   Sun, 21 Aug 2022 21:06:28 -0700
Message-Id: <20220822040628.177649-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

strp_init() is called just a few lines above this csk->sk_user_data
check, it also initializes strp->work etc., therefore, it is
unnecessary to call strp_done() to cancel the freshly initialized
work.

This also makes a lockdep warning reported by syzbot go away.

Reported-and-tested-by: syzbot+9fc084a4348493ef65d2@syzkaller.appspotmail.com
Reported-by: syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com
Fixes: e5571240236c ("kcm: Check if sk_user_data already set in kcm_attach")
Fixes: dff8baa26117 ("kcm: Call strp_stop before strp_done in kcm_attach")
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/kcm/kcmsock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 71899e5a5a11..661c40cdab3e 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1425,8 +1425,6 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
 	 */
 	if (csk->sk_user_data) {
 		write_unlock_bh(&csk->sk_callback_lock);
-		strp_stop(&psock->strp);
-		strp_done(&psock->strp);
 		kmem_cache_free(kcm_psockp, psock);
 		err = -EALREADY;
 		goto out;
-- 
2.34.1

