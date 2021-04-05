Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192A535473D
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 21:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbhDET6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 15:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhDET6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 15:58:41 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E726FC061756;
        Mon,  5 Apr 2021 12:58:34 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id z8so13849067ljm.12;
        Mon, 05 Apr 2021 12:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DflEnZqNaTqhFLOszH5g6WqXbTdR2L/cK7QakrDQWfc=;
        b=CpvlGRHYyALnZiHrH+dTdWbIi1i+gds9+wua9epYVXW2hxl1i1v0EFQ7si+QvvGsFS
         aMf9p9bxxCHnVMj3CJiKtNoViqOF2xx+LGvAwL/9RDJvXBDO19n57oboqUMIbM/PUKOS
         YRFkeBvhSSXUXLov3k0oFlMM5zqnX01AW2ouoxNAIdxrz2Zq4A5kiqWFRbQ1C8XKuBHd
         uKBKMqfjLEx+aKU/PFr4cbwCWS6S/zZNEZoJbw/wyj7t1B6elPEUkfoCJ/IGI0kFeJTI
         8lLk9p/I1/h7zir4J/QUVlQ5MzJoTkuMHzuYS/rld5pJStr2YIqr9ypBQEGWo30Je0Jq
         SLjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DflEnZqNaTqhFLOszH5g6WqXbTdR2L/cK7QakrDQWfc=;
        b=pVmSmh21Alb3fMRmG7djb8zebKc1HSsRHDe+rYroqVJZaLlF8n+v3BhTUbTQnFceHT
         wYffj6mkkLPT06DLj+YjdUilFJTbG+hpwNUd/sRnOQHeMczcxWRMFnjIxD2MaoIqA8iC
         IHaTt5J8YAyteYQ2a/UUK2r+sJY+0rrl1bwi5IXX03kNR/2PoopysgRD3HjrRETfrEiR
         ckjpT3Fhe+o1oQN1tLxxlAu62t4gc0aCoVC0Zh91LpTsFfxCZZfxlXcU9wykaezHyww4
         Mk11cEZJH2fohEWTdak1l5hiH+5QVy3Yyj6q/meVkS2tNofxv64lZYj83fpV1ZEK17va
         e//g==
X-Gm-Message-State: AOAM533enCEBhzH/ZvH34r5EYHdD/qGR3yQJY+MZk6sZ7f787DoLeEU3
        7TZiAx/VimdZjkJ0dUKqUGsoNDKduxYpgLYTRk4=
X-Google-Smtp-Source: ABdhPJwV9oDLdxUe9916RyWbSrL4h7ilXbHMUn8Ky0I3p2nbh1SrC6ZwUHnkd5K82l1XeUtGYdMRjA==
X-Received: by 2002:a2e:8eda:: with SMTP id e26mr16527361ljl.457.1617652713303;
        Mon, 05 Apr 2021 12:58:33 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.149])
        by smtp.gmail.com with ESMTPSA id b25sm1888949lff.268.2021.04.05.12.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 12:58:32 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com
Subject: [PATCH] net: fix shift-out-of-bounds in nl802154_new_interface
Date:   Mon,  5 Apr 2021 22:57:44 +0300
Message-Id: <20210405195744.19386-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported shift-out-of-bounds in nl802154_new_interface.
The problem was in signed representation of enum nl802154_iftype

enum nl802154_iftype {
	/* for backwards compatibility TODO */
	NL802154_IFTYPE_UNSPEC = -1,
...

Since, enum has negative value in it, objects of this type
will be represented as signed integer.

	type = nla_get_u32(info->attrs[NL802154_ATTR_IFTYPE]);

u32 will be casted to signed, which can cause negative value type.

Reported-by: syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/ieee802154/nl802154.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 7c5a1aa5adb4..6cce045e3d40 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -910,7 +910,7 @@ static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL802154_ATTR_IFTYPE]) {
 		type = nla_get_u32(info->attrs[NL802154_ATTR_IFTYPE]);
-		if (type > NL802154_IFTYPE_MAX ||
+		if (type > NL802154_IFTYPE_MAX || type < 0 ||
 		    !(rdev->wpan_phy.supported.iftypes & BIT(type)))
 			return -EINVAL;
 	}
-- 
2.30.2

