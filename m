Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153A05A3968
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 20:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiH0SNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 14:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH0SNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 14:13:20 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9BBF8F4B
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 11:13:19 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id de16so3465827qvb.12
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 11:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ibR0j4ckhSjkJbD9irJms7/Ca/50Jq0nxwL05yfqGJ0=;
        b=GU4rWb/lPDm0agt50pVZxTqDFuwFA5qv95BRYpIlO7xsBtVB02xiydMFlp3NCSHKjK
         B0RAxs3SC0XGhg5TaoEaf4JllOzxtT31p4fIPf+Ou9MTsEwLm+QiXYtixvHOMwA9HfSq
         tOWIOwY0mXc5O5gNPY4qIqNsKygGH2s17HhMrUf7Exr7UZ6vtAAvGpMgeLeWOzsKOncn
         7PAiDIkMmtDVvE7aAWCI67cqzXr+gdYM8uYVBuLhB7XsvLDVwKAyPwkmEyTastQayG7W
         aqaEoyhy8GipnZVWYIznzDOKkrriFGI6cWqvI3UTA41uWFvBTVLfveKOCAFgx6X1qzbJ
         qtug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ibR0j4ckhSjkJbD9irJms7/Ca/50Jq0nxwL05yfqGJ0=;
        b=ulC8SIjKUaxPW9Ii3fLoDXNDTwO/FgUiVoCSj318GPzS7pYqPBefQEU+wroNsJmEhv
         57dz2yNN6T9bxuto7X9Jfv7HGjhfjFEEW8ZsYDCadDXaUSdf31gLAHjC19TDnSnRUW0j
         4Vi5ryO7LXWfxWu+e9NhSLo/RjesU6ZYpNzgnSLnibnLUwLXlraKNIciFGT70XtJSpQZ
         8ZAoJdgRyh04iqfYI4tz257S1B1BrER1OM15MYrDHnqqBqm91q+w+Ph5o46HZ8fW1Kb1
         tWEj5yOujaqiquI0nVb9LUp3eIrB5S2suPNhs7/ayHmUYKB293c1ta41Cam7P+oy5rE6
         4IqQ==
X-Gm-Message-State: ACgBeo0uGSNRsBm4cTLkMJwlN2GPO2pCw30L9PInUdJpOhS3RRHfu69R
        Q+DQfY/bH+YNg/LK2eazfnc199RH5Ew=
X-Google-Smtp-Source: AA6agR7fDwL877F6da9WQ1ulBcq3m+fsIbqJaDyBorvp5pKiFhxgT1H3byxzsIls+7NPZX08oDc0QA==
X-Received: by 2002:a0c:aa89:0:b0:48f:5a1b:2e4a with SMTP id f9-20020a0caa89000000b0048f5a1b2e4amr4472987qvb.102.1661623998669;
        Sat, 27 Aug 2022 11:13:18 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:e448:c1ce:ae49:d00c])
        by smtp.gmail.com with ESMTPSA id bs31-20020a05620a471f00b006bb83c2be40sm2372119qkb.59.2022.08.27.11.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Aug 2022 11:13:18 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+9fc084a4348493ef65d2@syzkaller.appspotmail.com,
        syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Herbert <tom@herbertland.com>
Subject: [Patch net v2] kcm: fix strp_init() order and cleanup
Date:   Sat, 27 Aug 2022 11:13:14 -0700
Message-Id: <20220827181314.193710-1-xiyou.wangcong@gmail.com>
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

And if sk_user_data is already used by KCM, psock->strp should not be
touched, particularly strp->work state, so we need to move strp_init()
after the csk->sk_user_data check.

This also makes a lockdep warning reported by syzbot go away.

Reported-and-tested-by: syzbot+9fc084a4348493ef65d2@syzkaller.appspotmail.com
Reported-by: syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com
Fixes: e5571240236c ("kcm: Check if sk_user_data already set in kcm_attach")
Fixes: dff8baa26117 ("kcm: Call strp_stop before strp_done in kcm_attach")
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/kcm/kcmsock.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 71899e5a5a11..1215c863e1c4 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1412,12 +1412,6 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
 	psock->sk = csk;
 	psock->bpf_prog = prog;
 
-	err = strp_init(&psock->strp, csk, &cb);
-	if (err) {
-		kmem_cache_free(kcm_psockp, psock);
-		goto out;
-	}
-
 	write_lock_bh(&csk->sk_callback_lock);
 
 	/* Check if sk_user_data is already by KCM or someone else.
@@ -1425,13 +1419,18 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
 	 */
 	if (csk->sk_user_data) {
 		write_unlock_bh(&csk->sk_callback_lock);
-		strp_stop(&psock->strp);
-		strp_done(&psock->strp);
 		kmem_cache_free(kcm_psockp, psock);
 		err = -EALREADY;
 		goto out;
 	}
 
+	err = strp_init(&psock->strp, csk, &cb);
+	if (err) {
+		write_unlock_bh(&csk->sk_callback_lock);
+		kmem_cache_free(kcm_psockp, psock);
+		goto out;
+	}
+
 	psock->save_data_ready = csk->sk_data_ready;
 	psock->save_write_space = csk->sk_write_space;
 	psock->save_state_change = csk->sk_state_change;
-- 
2.34.1

