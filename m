Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E603DCA4E
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 08:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhHAGZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 02:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhHAGZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 02:25:45 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301D0C06175F;
        Sat, 31 Jul 2021 23:25:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so1194197pjs.0;
        Sat, 31 Jul 2021 23:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BtXZYRmT/NygaPovlN6oa9mK2ot2ugUhbkM/k/oqAFc=;
        b=u1zd4g941vdPgwNRViARd7Z1hL7pEvoXJLiPhiYFFIDu5CWoOlbz1jmMzEuMj7T+7Y
         mTbEIesEptIXQmk2bOM8XM7emd/kvad8Slz5A/QaY+b4DwAuCCXjHMwXE1YTAv6DZ+zg
         MeXRSxMEG2Iv+D7j/BY19u2NhlMiawS3IeCQWXOS8fzTjo9KSn10cBuzuWLkycpCJGwU
         brdiRbuLn4fFYf5Uo1MYTNuOkZybae+m0by9qLf5chYPhHxOWMCciPNSnYedT92lZDHC
         tQR/ovGSIPq/ASZ3gJhKuxxu0jATz9RpGZkffEpKgumMFqy36azVa+qlBESeR8EguHwR
         r6gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BtXZYRmT/NygaPovlN6oa9mK2ot2ugUhbkM/k/oqAFc=;
        b=pP30pBfSJE82s78/kTTN2r8eDZjquP3UTE0TnkRF4ZGfz0+3tkABjNOzX/k7HhTwvE
         PIJKmHOe5BmhRQXTCab9MR1UjOPKU1/XSw1lAH4c8HGDYQWLvpUC9tAS/nrzCErdQm/D
         rQhO0OagYCJ9gn8vlQjGlFcmfH8xuAbh1jQvuHP715YPH6TT5WHWgrJ4Uqid7R/+kedO
         bjwrf7DxrrgTZxb9zfrGRiakbTMt8YPNbqg/MJWI5y3X0QBcvja8TYhshy+2tN5MKOl+
         +jqtWc+xXu6uAXm6dkLeR92PRf2LNrJZ9As5Eu5VirMK/flXhHSXEep4w6mYT7Zv87Wh
         S64Q==
X-Gm-Message-State: AOAM533edYRqbsPAn1sedL6o1R5wSCRYBDMYM/7vWn3+6y8ldD+QkWgy
        V47yf+5xLPcY+tJ5z997qWl7GWBVs5AsiQ==
X-Google-Smtp-Source: ABdhPJx8yO4av8qIygpaoIvNvNi6Zc0yhbOZ7kjqzuAGkDmjU8YvDeIfvFjjS43ZuzyRmnmhgqMoRg==
X-Received: by 2002:a63:4b0a:: with SMTP id y10mr3487658pga.437.1627799137345;
        Sat, 31 Jul 2021 23:25:37 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x81sm7452631pfc.22.2021.07.31.23.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 23:25:36 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: move the active_key update after sh_keys is added
Date:   Sun,  1 Aug 2021 02:25:31 -0400
Message-Id: <514d9b43054a4dc752b7d575700ad87ae0db5f0c.1627799131.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 58acd1009226 ("sctp: update active_key for asoc when old key is
being replaced"), sctp_auth_asoc_init_active_key() is called to update
the active_key right after the old key is deleted and before the new key
is added, and it caused that the active_key could be found with the key_id.

In Ying Xu's testing, the BUG_ON in sctp_auth_asoc_init_active_key() was
triggered:

  [ ] kernel BUG at net/sctp/auth.c:416!
  [ ] RIP: 0010:sctp_auth_asoc_init_active_key.part.8+0xe7/0xf0 [sctp]
  [ ] Call Trace:
  [ ]  sctp_auth_set_key+0x16d/0x1b0 [sctp]
  [ ]  sctp_setsockopt.part.33+0x1ba9/0x2bd0 [sctp]
  [ ]  __sys_setsockopt+0xd6/0x1d0
  [ ]  __x64_sys_setsockopt+0x20/0x30
  [ ]  do_syscall_64+0x5b/0x1a0

So fix it by moving the active_key update after sh_keys is added.

Fixes: 58acd1009226 ("sctp: update active_key for asoc when old key is being replaced")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/auth.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index fe74c5f95630..db6b7373d16c 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -857,14 +857,18 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 	memcpy(key->data, &auth_key->sca_key[0], auth_key->sca_keylength);
 	cur_key->key = key;
 
-	if (replace) {
-		list_del_init(&shkey->key_list);
-		sctp_auth_shkey_release(shkey);
-		if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
-			sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+	if (!replace) {
+		list_add(&cur_key->key_list, sh_keys);
+		return 0;
 	}
+
+	list_del_init(&shkey->key_list);
+	sctp_auth_shkey_release(shkey);
 	list_add(&cur_key->key_list, sh_keys);
 
+	if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
+		sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+
 	return 0;
 }
 
-- 
2.27.0

