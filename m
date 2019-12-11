Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAEE11A5C9
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbfLKIX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:23:57 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44864 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfLKIX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 03:23:57 -0500
Received: by mail-pl1-f195.google.com with SMTP id bh2so1113586plb.11
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 00:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ene9HNEpELndTJ+9+fQ+V3XkCSrA1CAW4jgaOqzREN4=;
        b=e/40FtwOmGOuSGOphzi4ISuQXEoUAGgp/NXIMiCE7YX99Aw9laUpTbAnrknfInNXQE
         07pMfZiSHcHWxqHIxO8BMmZz3TenomIcXbbyxEFVCE5YAQKH+6Td09vgsJ6b321G5geD
         2wpLuTgs3R5YIeJykrIepL7XK9QZMruD0J9jGsowsugRd31WOHw3d+oquhIZrG8Jdq4p
         8yNEA3t3iJmTXKdeoAaqVogFsrOnwXoMvsjZbmKeE9VeudLkCVoj0Z91LCHY7aoW6SDR
         3C7boq5YG2gE0N2DUQ11Mu97ncc/mtzs6nuE1FMV96qkscbkBcJnrMz5IbsljPYUecXs
         oFlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ene9HNEpELndTJ+9+fQ+V3XkCSrA1CAW4jgaOqzREN4=;
        b=pD3fhaawRty8rP0imL5N2LkgJCwGtufxwDlItFpLsUcCgH7cnd/3gq3qfreN/3xznA
         KiWbBf0SnALPlNMBSGV+ul/AowcbGbPNEJJTJL0fmBhMvRgg3Z66KolRgjApUlO9APDR
         BVrKVX91hfhrZtxAhvT9+W4MZGR637aHgVwr7tt+Kp3ypFtXif804Iw+hgHjFwSbPCis
         qHExlS5cC62+yjil7UYw4Nhtyww8ZNE+W+mvcGwdCwF6iVjcrZbmvR1FmlrxWSDC0xTu
         Ft5yVJFuZrr6zZAJnQlgeR3BxuGxCyxEhRdWpDAzwau9hACvUOXsSUxjxUpEPwi2wFRA
         rrlg==
X-Gm-Message-State: APjAAAUqPgmOwTT/oGPm98WPrWV6dZaZC0RQZN1xF0uLEcx8UZMZWbAA
        Weg78oHAN6ew5kuSrEcwJFs=
X-Google-Smtp-Source: APXvYqyBNkuaScM/rAC6cjkJxvhFn8t/zduvV+/PaKsNQdeOVD5IwGkidN3pmQSnm73NLxCZHj+Gfg==
X-Received: by 2002:a17:902:8649:: with SMTP id y9mr1941424plt.67.1576052636286;
        Wed, 11 Dec 2019 00:23:56 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id n26sm1868196pgd.46.2019.12.11.00.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 00:23:55 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 4/4] gtp: avoid zero size hashtable
Date:   Wed, 11 Dec 2019 08:23:48 +0000
Message-Id: <20191211082348.28768-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GTP default hashtable size is 1024 and userspace could set specific
hashtable size with IFLA_GTP_PDP_HASHSIZE. If hashtable size is set to 0
from userspace,  hashtable will not work and panic will occur.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/gtp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5450b1099c6d..e5b7d6d2286e 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -667,10 +667,13 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	if (err < 0)
 		return err;
 
-	if (!data[IFLA_GTP_PDP_HASHSIZE])
+	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
 		hashsize = 1024;
-	else
+	} else {
 		hashsize = nla_get_u32(data[IFLA_GTP_PDP_HASHSIZE]);
+		if (!hashsize)
+			hashsize = 1024;
+	}
 
 	err = gtp_hashtable_new(gtp, hashsize);
 	if (err < 0)
-- 
2.17.1

