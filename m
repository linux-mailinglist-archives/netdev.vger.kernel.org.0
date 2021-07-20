Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472A63D02B6
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhGTT3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 15:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbhGTT0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 15:26:32 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA565C061574;
        Tue, 20 Jul 2021 13:07:03 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id c68so16545495qkf.9;
        Tue, 20 Jul 2021 13:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rI8cSuSairE1K6x1UuaJ83a15FibjOPB9oWfkOqo2XY=;
        b=lIi5dj/+zcyg6CyrTbemupbiHGg6WbzbM7GtL6Bg/cKac0QiHP28GBOk5uFaUTH+5y
         5+FkHZoy2zoXPnMvEN9+G5SHWw+6fT873DjcqWAlWGAwCUZ2b7fXQwNI5LPtxELhVx5I
         W/XAMFQb6qa6/B5CVSBng1txHioRCMP6BiCw+LMCoFMx76ceTAnBtp5fHjcuw4aQkjpv
         Dd9BvuEUvs/zTH5PgUaZO21IpJeIrOm79IDfMjoib8DjGoy9obYs8jv98pbGkNJfs+8n
         C+tTpfWSHZFwccZQP2NPaEGBcvwcNzYW/2td8bprk3oMij2pXcjdld3LLjjogysEFrZe
         8j7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rI8cSuSairE1K6x1UuaJ83a15FibjOPB9oWfkOqo2XY=;
        b=dSRWqWJ4fKc7roT/viaijcT0j2AfHGQbWDd/CCcQ0eAYJ6IMLSE2H+N2ayXnrRq9kC
         WrXXb2n8J9DuIXP7PrVOJeBXuyQcYn6ROVqXT5//QFoRVf6YLlPx+bKivjv38JJrc4Bg
         /EYJv/eAMInrKOrHzKTAI3kWpZBeMGkeSZnNRSn6YnF02Y38LQAvyRojpoS9coUMrsoj
         /Ix15/5gYwLb5R1v8C7pdSEa7AH1syMvM0U27SbswYFBL2Rp77mKHYnr4XDy5QRn7zNC
         qbQIpc1jCSBcJvbakVw5Xy+PP3Kfaqv56d9ko7t8Uotupjw9yXwtb2khBgkDhfOLt/SV
         xZ3g==
X-Gm-Message-State: AOAM533DfHyyOf4xXIn6UAnbVqul1c8nhDR2Y+Kg4vat+mh3ALbgQxHY
        EE4HjaE7hNEcmuF17Oi4iX/SNKHBOjY=
X-Google-Smtp-Source: ABdhPJzcW2XC0MbgtplTFUv5C4C979jJI8EpVsxRBFLTUwV2NAf2bdjXXmI0Gzez4Dl3ViQS0ZPIpA==
X-Received: by 2002:a05:620a:13c8:: with SMTP id g8mr31319122qkl.342.1626811622860;
        Tue, 20 Jul 2021 13:07:02 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d192sm75650qkc.51.2021.07.20.13.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:07:02 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: update active_key for asoc when old key is being replaced
Date:   Tue, 20 Jul 2021 16:07:01 -0400
Message-Id: <a1e260329384a040f11f0f393327e25cf909da2e.1626811621.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a call trace:

  BUG: KASAN: use-after-free in sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
  Call Trace:
   sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
   sctp_set_owner_w net/sctp/socket.c:131 [inline]
   sctp_sendmsg_to_asoc+0x152e/0x2180 net/sctp/socket.c:1865
   sctp_sendmsg+0x103b/0x1d30 net/sctp/socket.c:2027
   inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
   sock_sendmsg_nosec net/socket.c:703 [inline]
   sock_sendmsg+0xcf/0x120 net/socket.c:723

This is an use-after-free issue caused by not updating asoc->shkey after
it was replaced in the key list asoc->endpoint_shared_keys, and the old
key was freed.

This patch is to fix by also updating active_key for asoc when old key is
being replaced with a new one. Note that this issue doesn't exist in
sctp_auth_del_key_id(), as it's not allowed to delete the active_key
from the asoc.

Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
Reported-by: syzbot+b774577370208727d12b@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/auth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 6f8319b828b0..fe74c5f95630 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -860,6 +860,8 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 	if (replace) {
 		list_del_init(&shkey->key_list);
 		sctp_auth_shkey_release(shkey);
+		if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
+			sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
 	}
 	list_add(&cur_key->key_list, sh_keys);
 
-- 
2.27.0

