Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C56532C47C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392362AbhCDAOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349003AbhCCQ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 11:29:18 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB66C061762;
        Wed,  3 Mar 2021 08:28:32 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id q25so17831908lfc.8;
        Wed, 03 Mar 2021 08:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e6jk4zYBS5RjBAZNG1Jc1PukaUiIwiF3IBqy3w9hmmE=;
        b=BVFfZbLb/FeEe0raR3StYBDGVDr7EX5N7HR+g7owlm2IURTCIF/HOBRI03YTYuqbXF
         jywwE5g/Qr2634AGPScQqQZ32quudwZ7KqWjwszCuBZBb/QQduiNLOZmqI0CvZxJBav5
         FTVlD/6w9RwzTBzlDIybudSexYk0YPtLLWHyGFkftBOX3MWf9vhrz8MLyO6SeA3rSgi4
         G5euWldZ6kU0QG2RBFGMIvX0ZEXJco1BDjJICcq29HtG1dZV6IPaF9yeqhQLOyzZkmXI
         4gKWrKZuv+ktwOl7R56zww/pDMCkfIAu7YWW3iGQb9poXB766giMAKNQ79eHN86519k3
         Haew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e6jk4zYBS5RjBAZNG1Jc1PukaUiIwiF3IBqy3w9hmmE=;
        b=A2AyNPrbyWTvxEywP60T82SYU6Ms+R2naiIPpGpzh9C3O8yLW3aycVnJkbUvERm8sr
         z6JdiuFpO1Q4wl5hdRcYxM7whDBRhjJL0t58wCvqZsZ5Jit3Jtck+bwqmSwCa5j4buiI
         hyyhJrwvpoJ3TPii24bwU7VCHdJkhU6vwX6qoyvjEaEun2syDphIDm5De2gDZDC2D5Qe
         kw4Axeb3tQiMZvROzDq4gCiaBxaTl4FEV2+Yh/2B4tqcHnr32JIJ19spc6ZLY1tgxlkp
         HwhPlFOvwI3Dwyv+CEWnwsTdtBfyMInEMjIq+10ZaD7/QNO9r6GHVHuLcYHfNe66wsoY
         9Qrw==
X-Gm-Message-State: AOAM530YBa4YMgdCfQy9MrG7m4mS3+rJ/6x9E5roUH25t7qSMi2rLoRy
        I5y/ysm5NXirEOhN+TRyB2m/7HVAOEaU8RG72E4=
X-Google-Smtp-Source: ABdhPJzHo9T4zCaRaT2RXZe7050zl4QyZYHQQOAv+ZHRdXKF78eQwZLT0ljcRlyNCHQr+e/PesVdKQ==
X-Received: by 2002:a19:8888:: with SMTP id k130mr14960980lfd.399.1614788911449;
        Wed, 03 Mar 2021 08:28:31 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.167])
        by smtp.gmail.com with ESMTPSA id s7sm2084403lfi.140.2021.03.03.08.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 08:28:31 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
Subject: [PATCH] net: mac802154: Fix null pointer dereference
Date:   Wed,  3 Mar 2021 19:27:56 +0300
Message-Id: <20210303162757.763502-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found general protection fault in crypto_destroy_tfm()[1].
It was caused by wrong clean up loop in llsec_key_alloc().
If one of the tfm array members won't be initialized it will cause
NULL dereference in crypto_destroy_tfm().

Call Trace:
 crypto_free_aead include/crypto/aead.h:191 [inline] [1]
 llsec_key_alloc net/mac802154/llsec.c:156 [inline]
 mac802154_llsec_key_add+0x9e0/0xcc0 net/mac802154/llsec.c:249
 ieee802154_add_llsec_key+0x56/0x80 net/mac802154/cfg.c:338
 rdev_add_llsec_key net/ieee802154/rdev-ops.h:260 [inline]
 nl802154_add_llsec_key+0x3d3/0x560 net/ieee802154/nl802154.c:1584
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reported-by: syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
---
 net/mac802154/llsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
index 585d33144c33..6709f186f777 100644
--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -151,7 +151,7 @@ llsec_key_alloc(const struct ieee802154_llsec_key *template)
 err_tfm0:
 	crypto_free_sync_skcipher(key->tfm0);
 err_tfm:
-	for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
+	for (; i >= 0; i--)
 		if (key->tfm[i])
 			crypto_free_aead(key->tfm[i]);
 
-- 
2.25.1

